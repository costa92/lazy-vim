-- LSP 通用配置和工具函数
local M = {}

-- 设置全局 LSP 配置
function M.setup_global()
  -- 减少日志输出。用 vim.lsp.log.set_level，不用 vim.lsp.set_log_level（后者在
  -- Neovim 0.12 已弃用，会在启动时打印警告）
  vim.lsp.log.set_level("WARN")

  -- 优化 LSP 浮动窗口
  local orig_util_open_floating_preview = vim.lsp.util.open_floating_preview
  function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
    opts = opts or {}
    opts.border = opts.border or "rounded"
    opts.max_width = opts.max_width or 80
    return orig_util_open_floating_preview(contents, syntax, opts, ...)
  end
end

-- 通用 LSP 服务器配置函数
--
-- 走 Neovim 0.11+ 原生路径（vim.lsp.config / vim.lsp.enable），不用
-- require("lspconfig")[name].setup()：后者已弃用，会在启动时打印带堆栈的警告，
-- 且将在 nvim-lspconfig v3.0.0 移除；新版服务器配置（vtsls / vue_ls 等）也只存在于
-- 插件的 lsp/ 目录，废弃框架里根本没有。
--
-- config 会与插件 lsp/<name>.lua 提供的默认值深度合并，故各服务器文件只写差异项。
function M.setup_server(server_name, config)
  config = config or {}
  config.capabilities = config.capabilities or vim.lsp.protocol.make_client_capabilities()
  config.capabilities.textDocument.completion.completionItem.snippetSupport = true

  config.flags = config.flags or {}
  config.flags.debounce_text_changes = 200 -- 减少防抖时间

  local user_on_attach = config.on_attach
  config.on_attach = function(client, bufnr)
    vim.bo[bufnr].omnifunc = "v:lua.vim.lsp.omnifunc"

    -- 禁用格式化功能，由 Conform 统一管理
    if server_name ~= "gopls" then
      client.server_capabilities.documentFormattingProvider = false
    end

    if user_on_attach then
      user_on_attach(client, bufnr)
    end
  end

  vim.lsp.config(server_name, config)
  vim.lsp.enable(server_name)
end

return M
