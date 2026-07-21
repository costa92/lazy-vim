-- vtsls：TypeScript/JavaScript 语言服务器，同时承载 .vue 里 <script> 的 TS 能力
--
-- 与本目录其它文件不同，这里直接返回 vim.lsp.Config 表（不是 function(setup_server)），
-- 因为 vtsls/vue_ls 走 Neovim 0.11+ 原生路径，见 lsp/init.lua 的 setup_native_server。
--
-- 两条硬约束（来自 nvim-lspconfig 的 lsp/vtsls.lua 与 lsp/vue_ls.lua 说明）：
--   1. vtsls 与 ts_ls 不可同时启用，故 plugins/lsp.lua 的列表里已移除 ts_ls。
--   2. vue_ls 自 v3.0.0 起取消 takeover mode，只管 template/CSS；.vue 里的 TS
--      请求由它转发给 vtsls，因此 filetypes 必须含 vue，且插件的 languages 也必须含 vue。

local vue_language_server_path = vim.fn.stdpath("data")
  .. "/mason/packages/vue-language-server/node_modules/@vue/language-server"

-- vtsls 用 VSCode 风格的键名，和 ts_ls 的 includeInlay* 不是同一套 schema，
-- 键名以 mason 下载的 vtsls configuration schema 为准。
local inlay_hints = {
  parameterNames = {
    enabled = "all",
    -- 等价于 ts_ls 的 includeInlayParameterNameHintsWhenArgumentMatchesName = false
    suppressWhenArgumentMatchesName = true,
  },
  parameterTypes = { enabled = true },
  variableTypes = { enabled = true },
  propertyDeclarationTypes = { enabled = true },
  functionLikeReturnTypes = { enabled = true },
}

return {
  filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact", "vue" },
  settings = {
    vtsls = {
      tsserver = {
        globalPlugins = {
          {
            name = "@vue/typescript-plugin",
            location = vue_language_server_path,
            languages = { "vue" },
            configNamespace = "typescript",
          },
        },
      },
    },
    typescript = {
      tsserver = {
        -- 默认 3072 MB，大型 Vue 项目会不断 OOM：tsserver 被 SIGABRT 杀掉后无限重启，
        -- LSP log 刷屏 "TSServer exited. Code: null. Signal: SIGABRT"，编辑器里表现为
        -- 进度条永远卡在 "Analyzing 'xxx.vue' and its dependencies"。
        --
        -- 内存开销几乎全部来自 @vue/typescript-plugin —— 它要为每个 .vue 生成虚拟 TS
        -- 文件。在一个约 2800 .vue + 3000 .ts 的项目上实测：
        --   禁用该插件：tsserver 稳定 336 MB
        --   启用该插件：稳定 4587 MB（是工作集，不是泄漏，30 秒后即走平）
        -- 3072 和 8192 都会崩（初始化期峰值高于稳态），12288 实测 0 崩溃。
        -- 这只是上限而非预分配，稳态仍只占约 4.6 GB。
        maxTsServerMemory = 12288,
      },
      inlayHints = vim.tbl_extend("force", inlay_hints, {
        enumMemberValues = { enabled = true },
      }),
    },
    javascript = { inlayHints = inlay_hints },
  },
}
