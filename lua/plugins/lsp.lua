-- plugins/lsp.lua  
return {  
  "neovim/nvim-lspconfig",  
  config = function()  
    local lsp_utils = require("lspconfig.util")

    -- 设置全局 LSP 配置
    vim.lsp.set_log_level("WARN") -- 减少日志输出
    
    -- 优化 LSP 客户端设置
    local orig_util_open_floating_preview = vim.lsp.util.open_floating_preview
    function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
      opts = opts or {}
      opts.border = opts.border or "rounded"
      opts.max_width = opts.max_width or 80
      return orig_util_open_floating_preview(contents, syntax, opts, ...)
    end

    -- 通用 LSP 配置函数
    local function setup_lsp_server(server_name, config)
      config = config or {}
      config.capabilities = config.capabilities or vim.lsp.protocol.make_client_capabilities()
      config.capabilities.textDocument.completion.completionItem.snippetSupport = true
      
      -- 增加超时时间
      config.flags = config.flags or {}
      config.flags.debounce_text_changes = 200 -- 减少防抖时间
      
      -- 通用 on_attach 函数
      local default_on_attach = function(client, bufnr)
        vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")
        
        -- 禁用格式化功能，如果有专门的格式化工具
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

    -- Go 语言服务器配置  
    setup_lsp_server("gopls", {
      cmd = { "gopls", "serve" },  
      root_dir = get_cached_root, -- 使用缓存的根目录函数  
      settings = {  
        gopls = {  
          analyses = { 
            unusedparams = true,
            shadow = false,
          },  
          staticcheck = false,
          gofumpt = true,
          -- 性能优化设置
          codelenses = {
            gc_details = false,
            generate = false,
            regenerate_cgo = false,
            test = false, -- 禁用测试透镜
            tidy = false,
            upgrade_dependency = false,
            vendor = false,
          },
          experimentalPostfixCompletions = false,
          completionBudget = "300ms", -- 减少补全时间
          hoverKind = "SingleLine",
        }  
      },  
      init_options = {  
        usePlaceholders = true  
      }  
    })

    -- YAML 语言服务器配置
    setup_lsp_server("yamlls", {
      settings = {
        yaml = {
          schemas = {
            ["https://json.schemastore.org/github-workflow.json"] = "/.github/workflows/*",
            ["https://json.schemastore.org/docker-compose.yml"] = "/docker-compose*.yml",
            ["https://gitlab.com/gitlab-org/gitlab/-/raw/master/app/assets/javascripts/editor/schema/ci.json"] = "/.gitlab-ci.yml",
            ["https://json.schemastore.org/gitlab-ci.json"] = "/.gitlab-ci.yml",
          },
          validate = true,
          completion = true,
          schemaStore = {
            enable = true,
            url = "https://www.schemastore.org/api/json/catalog.json",
          },
        },
      },
    })

    -- TOML 语言服务器配置  
    setup_lsp_server("taplo")

    -- 自动格式化配置  
    vim.api.nvim_create_autocmd("BufWritePre", {  
      pattern = "*.go",  
      callback = function()  
        vim.lsp.buf.format({  
          async = false,  
          timeout_ms = 10000, -- 增加格式化超时时间
          filter = function(client)  
            return client.name == "gopls"  
          end  
        })  
      end  
    })

    -- YAML/TOML 自动格式化配置
    vim.api.nvim_create_autocmd("BufWritePre", {
      pattern = { "*.yml", "*.yaml", "*.toml" },
      callback = function()
        vim.lsp.buf.format({
          async = false,
          timeout_ms = 5000,
        })
      end
    })  
  end  
}  
