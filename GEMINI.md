# Neovim Configuration Analysis

## Project Overview

This project is a comprehensive Neovim configuration tailored for a modern development workflow. It uses `lazy.nvim` for plugin management, with a focus on providing a rich feature set out of the box. The configuration is primarily written in Lua and is structured to be modular and easily customizable.

The default theme is "Tokyo Night", with "Gruvbox" available as an alternative. It includes extensive support for Go development, including LSP integration, code formatting, and specific keybindings for Go-related tasks.

## Key Technologies

*   **Editor:** Neovim
*   **Plugin Manager:** `lazy.nvim`
*   **Language:** Lua
*   **Primary Focus:** Go development, with general-purpose features for other languages.

## Building and Running

This is a Neovim configuration, so there is no "build" process. To "run" it, you simply need to:

1.  **Install Neovim:** Ensure you have Neovim version 0.9.0 or higher.
2.  **Clone the repository:**
    ```bash
    git clone <repository-url> ~/.config/nvim
    ```
3.  **Launch Neovim:**
    ```bash
    nvim
    ```
    On the first launch, `lazy.nvim` will automatically install all the configured plugins.

## Development Conventions

### Plugin Management

*   Plugins are managed using `lazy.nvim`.
*   Plugin specifications are located in the `lua/plugins/` directory, with each file representing a plugin or a group of related plugins.
*   The main plugin setup is in `lua/configs/lazy.lua`, which imports the individual plugin files.

### Keybindings

*   Global keybindings are defined in `lua/configs/keymaps.lua`.
*   The `<Space>` key is the leader key.
*   The `\` key is the local leader key.
*   Keybindings are organized by functionality (e.g., window management, text editing, file browsing).

### LSP and Formatting

*   LSP (Language Server Protocol) is configured via `nvim-lspconfig`.
*   The primary language server configured is `gopls` for Go.
*   Automatic formatting on save is enabled for Go files using the `gopls` language server.
*   `nvim-cmp` is used for autocompletion, with sources from LSP, snippets, and buffers.
*   `nvim-treesitter` is used for syntax highlighting and indentation.

### Customization

*   **Basic settings:** `lua/configs/basic.lua`
*   **Keymaps:** `lua/configs/keymaps.lua`
*   **Plugins:** `lua/plugins/` directory
*   **Theme:** The colorscheme can be changed in `init.lua`.

## Key Files

*   `init.lua`: The main entry point of the configuration. It loads the basic settings, plugins, and keymaps.
*   `lua/configs/lazy.lua`: Configures `lazy.nvim` and specifies which plugins to load.
*   `lua/configs/keymaps.lua`: Defines the global keybindings.
*   `lua/plugins/lsp.lua`: Configures the Language Server Protocol, with a specific setup for `gopls`.
*   `lua/plugins/cmp.lua`: Configures `nvim-cmp` for autocompletion.
*   `lua/plugins/treesitter.lua`: Configures `nvim-treesitter` for syntax highlighting and indentation.
*   `README.md`: Provides a user-friendly overview of the configuration, including features, keybindings, and installation instructions.
