-- LSP 通用配置和工具函数
local M = {}

-- 设置全局 LSP 配置
function M.setup_global()
  vim.lsp.set_log_level("WARN") -- 减少日志输出

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
function M.setup_server(server_name, config)
  config = config or {}
  config.capabilities = config.capabilities or vim.lsp.protocol.make_client_capabilities()
  config.capabilities.textDocument.completion.completionItem.snippetSupport = true

  -- 增加超时时间
  config.flags = config.flags or {}
  config.flags.debounce_text_changes = 200 -- 减少防抖时间

  -- 通用 on_attach 函数
  local default_on_attach = function(client, bufnr)
    vim.bo[bufnr].omnifunc = "v:lua.vim.lsp.omnifunc"

    -- 禁用格式化功能，由 Conform 统一管理
    if server_name ~= "gopls" then
      client.server_capabilities.documentFormattingProvider = false
    end
  end

  if config.on_attach then
    local user_on_attach = config.on_attach
    config.on_attach = function(client, bufnr)
      default_on_attach(client, bufnr)
      user_on_attach(client, bufnr)
    end
  else
    config.on_attach = default_on_attach
  end

  require("lspconfig")[server_name].setup(config)
end

return M

