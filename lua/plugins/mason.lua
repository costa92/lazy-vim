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
    },
    config = function(_, opts)
      require("mason").setup(opts)

      -- mason.nvim 本身没有 ensure_installed 选项（其 settings schema 里无此字段），
      -- 之前把工具列表写在 opts 里是无声无息被忽略的，这些 formatter 从未安装成功。
      -- 这里用 mason-registry 自己实现最小版本：只装缺的，已装的不动。
      -- 注意：这里是 mason 的包名，不是 lspconfig 的服务器名。
      local ensure_installed = {
        -- Formatters（格式化工具，供 conform.nvim 调用）
        "gofumpt",       -- Go formatter
        "shfmt",         -- Shell formatter
        "prettier",      -- JSON/YAML/Markdown/JS/TS formatter
        "prettierd",     -- Prettier daemon (faster)
        "stylua",        -- Lua formatter

        -- Linters（代码检测工具）- 暂时禁用，使用系统安装的工具
        -- "golangci-lint", "shellcheck", "yamllint", "luacheck",
        -- "markdownlint", "hadolint",
      }

      local registry = require("mason-registry")
      registry.refresh(function()
        for _, name in ipairs(ensure_installed) do
          local ok, pkg = pcall(registry.get_package, name)
          if not ok then
            vim.notify(("[mason] 未知的包名: %s"):format(name), vim.log.levels.WARN)
          elseif not pkg:is_installed() then
            pkg:install()
          end
        end
      end)
    end,
  },
  -- Bridge between Mason and lspconfig
  {
    "williamboman/mason-lspconfig.nvim",
    -- 无独立触发器：仅作为 nvim-lspconfig 的 dependency 被拉起（见 lsp.lua）
    lazy = true,
    opts = {
      -- 关闭自动 enable：默认为 true 时，mason-lspconfig 会用 vim.lsp.enable() 把所有
      -- 已安装的服务器以 lspconfig 原版默认配置拉起，绕过 plugins/lsp.lua，使 lua/lsp/
      -- 下的全部自定义（gopls 调优、vtsls 的 Vue 插件等）失效；还会连带启用已安装但
      -- 不该启用的 ts_ls（与 vtsls 冲突）。服务器统一由 plugins/lsp.lua 配置和启用。
      automatic_enable = false,

      -- 只包含 LSP 服务器
      ensure_installed = {
        "gopls",        -- Go
        "lua_ls",       -- Lua
        "bashls",       -- Bash
        "jsonls",       -- JSON
        "marksman",     -- Markdown
        "yamlls",       -- YAML
        "taplo",        -- TOML
        "vtsls",        -- TypeScript/JavaScript（取代 ts_ls，两者不可共存）
        "vue_ls",       -- Vue SFC（依赖 vtsls 提供 <script> 的 TS 能力）
        "html",         -- HTML
        "cssls",        -- CSS
      },
    },
  },
}