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
    -- 每个服务器的差异配置放在 lua/lsp/<name>.lua，返回一个 vim.lsp.Config 表；
    -- 没有对应文件的（taplo/marksman/vue_ls）直接用 nvim-lspconfig 自带默认值。
    local servers = {
      "gopls",      -- Go
      "vtsls",      -- TypeScript/JavaScript + .vue 的 <script>（取代 ts_ls，两者不可共存）
      "vue_ls",     -- Vue SFC，把 TS 请求转发给 vtsls
      "lua_ls",     -- Lua
      "yamlls",     -- YAML
      "html",       -- HTML
      "cssls",      -- CSS
      "jsonls",     -- JSON
      "taplo",      -- TOML
      "bashls",     -- Bash/Shell
      "marksman",   -- Markdown
    }

    for _, server in ipairs(servers) do
      local ok, config = pcall(require, "lsp." .. server)
      if not ok then
        -- 只有"文件不存在"才回退到默认配置；配置文件自身的语法/运行错误必须抛出，
        -- 否则服务器会静默退化成默认配置，自定义项全部失效且毫无迹象。
        if not tostring(config):match("module 'lsp%.[%w_]+' not found") then
          error(config)
        end
        config = nil
      end
      lsp_common.setup_server(server, config)
    end

    -- 注意：文件格式化已由 conform.nvim 统一管理
    -- Go 格式化：gofmt + goimports（通过 Conform）
    -- TS/JS 格式化：prettier/prettierd（通过 Conform）
    -- 其他格式化也由 Conform 统一处理
  end
}
