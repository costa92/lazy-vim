# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Personal Neovim configuration written in Lua, managed by `lazy.nvim`. Primary focus is Go development (`gopls` + `go.nvim`), with general LSP/Treesitter/lint support for other languages.

## Entry Point & Load Order

`init.lua` loads three modules in strict order, then applies the colorscheme:

1. `lua/configs/basic.lua` — `vim.opt` settings
2. `lua/configs/lazy.lua` — bootstraps `lazy.nvim` and declares plugin specs with lazy-loading triggers (`event`/`cmd`/`ft`/`keys`)
3. `lua/configs/keymaps.lua` — global keymaps + `LspAttach` autocmd that installs LSP keymaps *only on real buffers* (explicitly excludes `neo-tree`, `neo-tree-popup`, `NvimTree`, `alpha`, `dashboard`)

Leader = `<Space>`, local leader = `\`. Both are set in `lua/configs/lazy.lua` *before* `lazy.setup()` (required — keymaps registered before leader is set bind to the wrong key). `basic.lua` intentionally does **not** set leader — do not add it back there.

## Plugin System Conventions

- Each plugin lives in its own file under `lua/plugins/<name>.lua` returning a lazy spec table.
- To add a plugin: create `lua/plugins/<name>.lua` (returning the spec **with its `event`/`cmd`/`ft`/`keys` trigger inside it**) then add a plain `{ import = "plugins/<name>" }` line to `lua/configs/lazy.lua`. Choose the trigger by role (UI → `VeryLazy`, LSP → `BufReadPre`/`BufNewFile`, filetype-specific → `ft`, command-driven → `cmd`, keymap-driven → `keys`).
- **The trigger MUST live inside the plugin file's spec, not on the `{ import = ... }` line.** Handlers written as `{ import = "plugins/x", cmd = "..." }` in `lazy.lua` are **silently ignored** by this setup (verified: they do not propagate to the imported spec), so the plugin falls back to `lazy = false` and **eager-loads at startup**. This bit a whole batch of plugins (neo-tree, lsp, mason, Comment, blame, toggleterm, surround, treesitter-textobjects, bqf, fidget, notify, render-markdown, visual-multi) — all were declared with an import-line trigger yet loaded eagerly until their trigger was moved in-file. To check what actually loads at startup: `:lua for n,p in pairs(require("lazy.core.config").plugins) do if p.lazy==false then print(n) end end`. Keep triggers out of `lazy.lua` import lines (any left there are inert legacy).
- **Do not put `lazy = false` inside a plugin file** unless eager load is intended (colorscheme, treesitter main branch). It overrides any in-file trigger.
- **mason** is wired as a `dependencies` entry of `nvim-lspconfig` (in `plugins/lsp.lua`), so it loads *before* lspconfig on file open (its `bin/` must be on `PATH` before servers are configured). `mason.nvim` also keeps a `cmd` trigger so `:Mason` works standalone; `mason-lspconfig.nvim` is `lazy = true` (dependency-only). Do not give mason a `VeryLazy` trigger — that would load it independently of the LSP ordering.
- Use `opts = {...}` or `config = function() ... end`, **not both**. When a `config` function exists, the `opts` table is ignored (this bit `blame.nvim` before — the `-w` option was silently dropped).
- **Do not rely on `:source` or `:Lazy reload`** for config changes — lazy-loaded plugin opts only apply at startup. Always fully quit (`:qa`) and restart when iterating on plugin config.
- `lazy.lua` explicitly disables many built-in Vim plugins for startup speed (`netrw`, `matchit`, `man`, `health`, `editorconfig`, etc.). If you add a feature that depends on one of those, re-enable it here.
- Plugin update checker is disabled (`checker.enabled = false`); upgrades are manual via `:Lazy sync`.

## LSP / Tooling Pipeline

- **Mason** (`plugins/mason.lua`) auto-installs LSP servers, formatters, and linters.
- **LSP** configs are split — see `plugins/lsp.lua` and any per-server files referenced from it (`ts_ls` has a documented quirk in `docs/ts_ls-fix.md`).
- **Formatting** runs via `conform.nvim` on the `Format` command, not on save by default.
- **Linting** (`nvim-lint`) runs on `BufReadPre`/`BufNewFile`/`BufWritePost`/`InsertLeave`.
- Diagnostics are **disabled by default** at the Neovim level (`vim.diagnostic.enable(false)` in `init.lua`). Inlay hints also disabled. Re-enable per buffer/globally when actually needed.

## Non-Obvious Gotchas

### neo-tree ↔ nvim-rooter interaction

`plugins/root.lua` loads `nvim-rooter.lua` with `cd_scope = "global"` and `trigger_patterns = {'*'}`, which auto-changes Neovim's global cwd on BufEnter. Neo-tree's default `filesystem.bind_to_cwd = true` is a **two-way** binding between cwd and tree root — so any path that changes cwd pulls the tree root with it, and any tree root change pushes cwd. In this config `bind_to_cwd = false` and `cwd_target = {sidebar = "none", current = "none"}` are set explicitly in `plugins/neo-tree.lua` to break the loop. **Do not re-enable `bind_to_cwd` without also neutralizing `nvim-rooter`.**

### Terminal Ctrl-h == BS

Most terminals send the same byte (0x08) for `Ctrl+h` and `<BS>`. Neo-tree's default `<BS>` = `navigate_up` would climb to `/` when the user presses the global `<C-h>` window-switch shortcut inside the tree. Current config:

- `<BS>` / `<bs>` mapped to `"noop"` in all three neo-tree mapping scopes (top-level, `filesystem`, `buffers`) — official disable keyword is `"noop"`, not `"none"`.
- A `FileType` autocmd on `neo-tree`/`neo-tree-popup` uses `vim.schedule` to install buffer-local overrides *after* neo-tree sets its own mappings (`<BS>` → `<Nop>`, `<C-h>` → `<C-w>h`, plus `<Nop>`s for `gd`/`gr`/`gi`/`gD`/`K` so LSP keys don't fire inside the tree).
- `<C-b>` is remapped to `close_window` inside neo-tree (default is `scroll_preview`, which shadows the global `:Neotree toggle` keymap).

If you see the tree root drifting or window-switch keys misbehaving inside neo-tree, check both these paths before adding more hacks.

### Global keymap pitfalls

`<C-h>` is globally mapped to `<C-w><C-h>` for window navigation (`keymaps.lua`). The insert-mode `<C-h>` = `<ESC>I` and `<C-l>` = `<ESC>A` are intentional (jump to line start/end when exiting insert), not typos.

### VimLeavePre force-cleanup (intentional)

Two `VimLeavePre` autocmds exist and **should not be removed**:

- `lua/configs/keymaps.lua` — force-stops all LSP clients (`vim.lsp.stop_client(id, true)`) and terminates any active DAP session. `gopls` shutdown on a large workspace can take 1-2 seconds; without force, `:q!` hangs that long.
- `lua/plugins/neotest.lua` — calls `require("neotest").run.stop()` to kill `go test` subprocesses. Otherwise `:q!` waits for the Go test process to exit.

If `:q!` ever becomes laggy again, check these are still present and firing (`:verbose autocmd VimLeavePre`).

### neotest-golang query patch (auto-applied)

`lua/plugins/neotest.lua` declares a `build` hook on the `neotest-golang` dependency that runs `scripts/patch-neotest-golang.lua`. The script is **conditional and self-healing** — it does *not* blindly strip anything. The compatibility issue is that `tree-sitter-go`'s `statement_list` handling drifts by version: on the mainline / `nvim-treesitter` **main** parser it is a **named** node, so the upstream queries `(block (statement_list X))` compile as-is; on some other versions `_statement_list` is anonymous and those queries fail with `Impossible pattern` / `Invalid node type "statement_list"`, needing the wrapper stripped to `(block X)`.

The script therefore: (1) `git checkout`s the 6 query files back to upstream original, (2) for each, compiles the query against the **actual** loaded go parser, (3) strips `(statement_list ...)` **only if** the original fails to compile *and* the stripped form compiles, (4) otherwise leaves the original (also the fallback when the go parser isn't installed yet). This fixes an earlier bug where the old *unconditional* strip broke discovery on the main-branch parser (stripped `(block (short_var_declaration))` → `Impossible pattern` → **zero tests discovered**). Because the script uses `vim.treesitter`, the build hook runs it via `dofile` **inside the current nvim process**, not a standalone `lua` interpreter. Re-runs automatically on `:Lazy sync`. If tests stop being discovered, run `:Lazy build neotest-golang` and check `:messages` for the script's output.

### Go test defaults

`neotest-golang` is configured with `-timeout=30s` instead of Go's default 10-minute timeout. This makes hung tests visible fast (panic with goroutine dump at 30s instead of silent spinner). Override per-run with `:Neotest run extra_args={'-timeout=5m'}`. Also `warn_test_name_dupes = false` silences a `Press ENTER` prompt on duplicate `t.Run` names.

## Reference Docs

Detailed keybinding references live in `docs/` (`navigation-keymaps.md`, `neo-tree-keymaps.md`, `git-commands.md`, `code-diagnostics.md`, etc.) and are the source of truth for user-facing shortcuts — the README.md summarizes them.

## Theme

Active theme is set in `init.lua` (`tokyonight-night`). Alternatives (`gruvbox`, `catppuccin`) are installed but lazy-loaded; switch by editing `vim.cmd.colorscheme(...)` in `init.lua`.
