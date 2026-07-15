-- plugins/lsp.lua - 主 LSP 配置文件
return {
  "neovim/nvim-lspconfig",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    -- mason 必须先于 lspconfig 加载：mason.setup 会把 ~/.local/share/nvim/mason/bin
    -- 前插到 PATH，server 二进制才找得到；作为 dependency，lazy 保证按此顺序先加载。
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
    "b0o/schemastore.nvim", -- JSON schemas
  },
  opts = {
    inlay_hints = { enabled = false },
  },
  config = function()
    -- 加载通用配置（注意：现在从 lsp 目录加载，不是 plugins.lsp）
    local lsp_common = require("lsp")

    -- 设置全局 LSP 配置
    lsp_common.setup_global()

    -- LSP 服务器列表
    local servers = {
      "gopls",      -- Go
      "ts_ls",      -- TypeScript/JavaScript
      "lua_ls",     -- Lua
      "yamlls",     -- YAML
      "html",       -- HTML
      "cssls",      -- CSS
      "jsonls",     -- JSON
      "taplo",      -- TOML
      "bashls",     -- Bash/Shell
      "marksman",   -- Markdown
    }

    -- 自动加载并配置所有 LSP 服务器
    for _, server in ipairs(servers) do
      local ok, config_fn = pcall(require, "lsp." .. server)
      if ok then
        -- 执行配置函数，传入 setup_server 函数
        config_fn(lsp_common.setup_server)
      else
        -- 如果没有单独配置文件，使用默认配置
        lsp_common.setup_server(server)
      end
    end

    -- 注意：文件格式化已由 conform.nvim 统一管理
    -- Go 格式化：gofmt + goimports（通过 Conform）
    -- TS/JS 格式化：prettier/prettierd（通过 Conform）
    -- 其他格式化也由 Conform 统一处理
  end
}
