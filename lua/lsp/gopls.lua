-- Go 语言服务器配置
--
-- root_dir 原先是 lspconfig.util.root_pattern("go.mod", ".git") 加一层手写缓存；
-- 迁到原生 vim.lsp.config 后直接用 root_markers（语义相同：向上找最近一个含任一标记的
-- 目录），查找由 Neovim 自身处理，手写缓存不再需要。
return {
  cmd = { "gopls", "serve" },
  root_markers = { "go.mod", ".git" },
  settings = {
    gopls = {
      analyses = {
        unusedparams = true,
        shadow = false,
      },
      staticcheck = false,
      gofumpt = true,  -- 使用 gofumpt 格式化
      -- 性能优化设置
      codelenses = {
        gc_details = false,
        generate = false,
        regenerate_cgo = false,
        test = false,
        tidy = false,
        upgrade_dependency = false,
        vendor = false,
      },
      experimentalPostfixCompletions = false,
      completionBudget = "300ms",
      hoverKind = "SingleLine",
    }
  },
  init_options = {
    usePlaceholders = true
  },
  on_attach = function(client, bufnr)
    -- 确保 gopls 的格式化功能启用（由 Conform 管理）
    client.server_capabilities.documentFormattingProvider = true
  end
}
