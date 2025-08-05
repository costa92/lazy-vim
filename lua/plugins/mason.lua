return {
  -- Mason for plugin management
  {
    "williamboman/mason.nvim",
    opts = {
      ui = {
        icons = {
          package_installed = "✓",
          package_pending = "→",
          package_uninstalled = "✗",
        },
      },
      -- 自动安装常用工具（包括 LSP 服务器、linters、formatters）
      ensure_installed = {
        -- Linters（代码检测工具）
        "golangci-lint", -- Go linter
        "shellcheck",    -- Shell script linter
        "yamllint",      -- YAML linter
        "luacheck",      -- Lua linter
        "markdownlint",  -- Markdown linter
        "hadolint",      -- Dockerfile linter
        
        -- Formatters（格式化工具）
        "gofumpt",       -- Go formatter
        "shfmt",         -- Shell formatter
        "prettier",      -- JSON/YAML/Markdown formatter
        "stylua",        -- Lua formatter
      },
    },
  },
  -- Bridge between Mason and lspconfig
  {
    "williamboman/mason-lspconfig.nvim",
    opts = {
      -- 只包含 LSP 服务器
      ensure_installed = { 
        "gopls",        -- Go
        "lua_ls",       -- Lua  
        "bashls",       -- Bash
        "jsonls",       -- JSON
        "marksman",     -- Markdown
        "yamlls",       -- YAML
        "taplo",        -- TOML
      },
    },
  },
}