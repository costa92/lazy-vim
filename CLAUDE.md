# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a modern Neovim configuration using `lazy.nvim` for plugin management. The configuration focuses on Go development but provides general-purpose functionality for various programming languages. It uses Lua for configuration and includes comprehensive LSP support, fuzzy finding, git integration, and a rich set of keybindings.

## Key Architecture

### Configuration Structure
- `init.lua` - Main entry point that loads all modules
- `lua/configs/` - Core configuration files:
  - `basic.lua` - Basic Neovim settings (indentation, search, etc.)
  - `keymaps.lua` - Global keybinding definitions
  - `lazy.lua` - Plugin manager setup and plugin imports
- `lua/plugins/` - Individual plugin configurations (one file per plugin/feature)

### Plugin Management
- Uses `lazy.nvim` for plugin management
- Plugins are lazy-loaded for performance
- Each plugin has its own configuration file in `lua/plugins/`
- Plugin updates are disabled by default (`checker.enabled = false`)

### LSP and Development Tools
- Primary language server: `gopls` for Go development
- `nvim-lspconfig` for LSP management
- `mason.nvim` for automatic LSP server installation
- `conform.nvim` for code formatting
- `nvim-cmp` for autocompletion with LSP integration
- `nvim-treesitter` for syntax highlighting and code parsing
- `nvim-lint` for code quality checking and linting
- `trouble.nvim` for enhanced diagnostics display

### Code Quality and Diagnostics
- **Automatic linting**: Runs on file save, buffer enter, and insert mode exit
- **Multi-language support**: Go (golangci-lint), Shell (shellcheck), YAML (yamllint), Lua (luacheck), etc.
- **Integrated diagnostics**: LSP errors/warnings combined with linter results
- **Visual indicators**: Error/warning signs in gutter, virtual text, and floating windows

## Common Development Tasks

### Neovim Configuration Management
- **Start Neovim**: `nvim` (plugins auto-install on first launch)
- **Plugin management**: Use `:Lazy` command for plugin operations
- **Theme switching**: Edit `vim.cmd.colorscheme()` in `init.lua`
- **Configuration reload**: Restart Neovim after making changes

### Key Development Features
- **File navigation**: FZF-based fuzzy finding (`<leader>o` for files, `<C-e>` for buffers)
- **Code search**: Live grep with `<leader>f`, current buffer search with `<C-f>`
- **LSP operations**: `gd` (definition), `gr` (references), `gi` (implementation), `K` (hover)
- **Code diagnostics**: `[d`/`]d` (navigate), `<leader>e` (show), `<leader>xx` (trouble view)
- **Code quality**: `<leader>l` (manual lint), `<leader>ca` (code actions)
- **Git integration**: Git status (`<leader>gs`), commits (`<leader>gp`), blame (`<leader>b`)
- **Go development**: Error handling (`<leader>fe`), struct filling (`<leader>gf`), tag operations (`<leader>ta/tr/tc`)

### File Tree Operations (Neo-tree)
- **Toggle**: `<C-b>`
- **Locate current file**: `<leader>ee`
- Navigation and file operations use standard keybindings (see README.md)

## Important Keybindings

### Leader Keys
- `<Space>` - Global leader key
- `\` - Local leader key

### Essential Shortcuts
- `<C-s>` - Save file
- `<C-q>` - Quit
- `<ESC>` - Clear search highlights
- `<leader>i` - Format current file
- `<S-n>` - Toggle line numbers

### Window Management
- `sv/sh` - Vertical/horizontal split
- `sc/so` - Close current/other windows
- `<C-h/j/k/l>` - Navigate between windows

### Code Diagnostics and Quality
- `[d`/`]d` - Navigate to previous/next diagnostic
- `<leader>e` - Show line diagnostics in floating window
- `<leader>q` - Open diagnostic quickfix list
- `<leader>l` - Run linter manually on current buffer
- `<leader>ca` - Show available code actions
- `<leader>xx` - Toggle Trouble diagnostics view
- `<leader>xX` - Toggle buffer diagnostics view

## Configuration Customization

### Adding New Plugins
1. Create new file in `lua/plugins/[plugin-name].lua`
2. Add `{ import = "plugins/[plugin-name]" }` to `lua/configs/lazy.lua`
3. Plugin will be automatically loaded

### Modifying Settings
- **Basic Neovim settings**: Edit `lua/configs/basic.lua`
- **Keybindings**: Edit `lua/configs/keymaps.lua`
- **Theme**: Change colorscheme in `init.lua`

### Language Support
- Go development is primary focus with extensive tooling
- Other languages supported through LSP and Treesitter
- Add new language servers via Mason (`:Mason` command)
- **Supported linters**: golangci-lint (Go), shellcheck (Shell), yamllint (YAML), luacheck (Lua), markdownlint (Markdown), hadolint (Dockerfile)
- **Auto-installed tools**: LSP servers, linters, and formatters managed by Mason

### Code Quality Tools
- **Mason auto-installs**: golangci-lint, shellcheck, yamllint, luacheck, markdownlint, hadolint, prettier, stylua
- **Linting triggers**: File save, buffer enter, insert mode exit
- **Manual commands**: `:Lint` to run linter, `:Mason` to manage tools
- **Diagnostic sources**: LSP servers + nvim-lint results combined in unified interface

## File Organization Notes

- Configuration is modular - each feature/plugin has its own file
- Disabled plugins are commented out in `lazy.lua` rather than deleted
- Documentation files in `docs/` provide detailed keybinding references
- `lazy-lock.json` pins plugin versions for reproducibility