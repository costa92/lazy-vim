return {
  -- Mason for plugin management
  {
    "williamboman/mason.nvim",
    -- 既是 lspconfig 的 dependency（随 LSP 加载），也保留命令触发让 :Mason 独立可用
    cmd = { "Mason", "MasonInstall", "MasonUpdate", "MasonLog", "MasonUninstall", "MasonUninstallAll" },
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
        -- Linters（代码检测工具）- 暂时禁用，使用系统安装的工具
        -- "golangci-lint", -- Go linter
        -- "shellcheck",    -- Shell script linter
        -- "yamllint",      -- YAML linter
        -- "luacheck",      -- Lua linter
        -- "markdownlint",  -- Markdown linter (暂时禁用)
        -- "hadolint",      -- Dockerfile linter (暂时禁用)

        -- Formatters（格式化工具）
        "gofumpt",       -- Go formatter
        "shfmt",         -- Shell formatter
        "prettier",      -- JSON/YAML/Markdown/JS/TS formatter
        "prettierd",     -- Prettier daemon (faster)
        "stylua",        -- Lua formatter
      },
    },
  },
  -- Bridge between Mason and lspconfig
  {
    "williamboman/mason-lspconfig.nvim",
    -- 无独立触发器：仅作为 nvim-lspconfig 的 dependency 被拉起（见 lsp.lua）
    lazy = true,
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
        "ts_ls",        -- TypeScript/JavaScript (formerly tsserver)
        "html",         -- HTML
        "cssls",        -- CSS
      },
    },
  },
}