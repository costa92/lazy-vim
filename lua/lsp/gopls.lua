-- Go 语言服务器配置
local lsp_utils = require("lspconfig.util")

return function(setup_server)
  -- 缓存根目录查找结果，避免重复计算
  local root_cache = {}
  local function get_cached_root(path)
    if root_cache[path] then
      return root_cache[path]
    end
    local root = lsp_utils.root_pattern("go.mod", ".git")(path)
    root_cache[path] = root
    return root
  end

  setup_server("gopls", {
    cmd = { "gopls", "serve" },
    root_dir = get_cached_root,
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
  })
end

