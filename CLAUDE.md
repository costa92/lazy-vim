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
- To add a plugin: create `lua/plugins/<name>.lua` then add `{ import = "plugins/<name>", <trigger> }` to `lua/configs/lazy.lua`. Choose the trigger carefully — see the existing groupings in `lazy.lua` (UI plugins use `VeryLazy`, LSP uses `BufReadPre`/`BufNewFile`, filetype-specific uses `ft`, command-driven tools use `cmd`).
- **The plugin file and `lazy.lua` must not both specify loading behavior.** Putting `lazy = false` inside `plugins/<name>.lua` forces eager load and silently overrides the `cmd = ...` / `event = ...` you set in `lazy.lua`. Let `lazy.lua` be the single source of truth for *when* plugins load; plugin files only describe *what* the plugin is and its `opts`/`config`.
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

`lua/plugins/neotest.lua` declares a `build` hook on the `neotest-golang` dependency that runs `scripts/patch-neotest-golang.lua`. This strips `(statement_list ...)` wrappers from 6 tree-sitter query files in the plugin — newer `tree-sitter-go` parsers made `_statement_list` an anonymous rule, so the upstream queries fail with `Invalid node type "statement_list"`. Without the patch, **zero Go tests are discovered** by neotest (`positions()` returns nil). Re-runs automatically on `:Lazy sync`. If tests stop being discovered, first check `:Lazy build neotest-golang` actually ran.

### Go test defaults

`neotest-golang` is configured with `-timeout=30s` instead of Go's default 10-minute timeout. This makes hung tests visible fast (panic with goroutine dump at 30s instead of silent spinner). Override per-run with `:Neotest run extra_args={'-timeout=5m'}`. Also `warn_test_name_dupes = false` silences a `Press ENTER` prompt on duplicate `t.Run` names.

## Reference Docs

Detailed keybinding references live in `docs/` (`navigation-keymaps.md`, `neo-tree-keymaps.md`, `git-commands.md`, `code-diagnostics.md`, etc.) and are the source of truth for user-facing shortcuts — the README.md summarizes them.

## Theme

Active theme is set in `init.lua` (`tokyonight-night`). Alternatives (`gruvbox`, `catppuccin`) are installed but lazy-loaded; switch by editing `vim.cmd.colorscheme(...)` in `init.lua`.
