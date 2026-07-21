# LSP 配置结构说明

每个语言服务器一个独立配置文件，统一由 `lua/plugins/lsp.lua` 加载。

## 目录结构

```
lua/
├── plugins/
│   └── lsp.lua              # 服务器列表 + 统一 setup 循环
└── lsp/                     # LSP 配置目录（独立于 plugins）
    ├── README.md            # 本说明文档
    ├── init.lua             # 通用工具和配置函数
    ├── gopls.lua            # Go LSP
    ├── vtsls.lua            # TypeScript/JavaScript + .vue 的 <script>
    ├── lua_ls.lua           # Lua LSP
    ├── yamlls.lua           # YAML LSP
    ├── html.lua             # HTML LSP
    ├── cssls.lua            # CSS LSP
    ├── jsonls.lua           # JSON LSP
    └── bashls.lua           # Bash/Shell LSP
```

**注意**：LSP 配置文件位于 `lua/lsp/`，而不是 `lua/plugins/lsp/`，以避免 Lazy.nvim 的自动扫描警告。

`taplo`（TOML）、`marksman`（Markdown）、`vue_ls`（Vue SFC）没有对应文件 —— 它们不需要任何自定义，直接用 nvim-lspconfig 自带默认值。**没有配置文件不等于没启用**，启用与否只看 `plugins/lsp.lua` 的 `servers` 列表。

## 工作原理

### 1. 主配置文件 (`plugins/lsp.lua`)

- 调用 `setup_global()` 设置全局 LSP 行为
- 定义 `servers` 列表
- 循环加载每个服务器的配置文件并 setup

循环只把「模块不存在」当作回退默认配置的理由；配置文件自身的语法或运行错误会**直接抛出**。这是刻意为之：静默吞掉错误会让服务器退化成默认配置而毫无迹象，极难排查。

### 2. 通用模块 (`lsp/init.lua`)

- `setup_global()`：设置日志级别、浮动窗口样式等全局项
- `setup_server(server_name, config)`：合并通用能力（capabilities、snippetSupport、on_attach）后调用 `vim.lsp.config()` + `vim.lsp.enable()`

**走的是 Neovim 0.11+ 原生路径，不是 `require("lspconfig")[name].setup()`。** 后者已弃用，会在启动时打印带堆栈的警告，并将于 nvim-lspconfig v3.0.0 移除；而 `vue_ls`、`vtsls` 这类较新服务器的配置只存在于插件的 `lsp/` 目录，废弃框架里根本查不到。

### 3. 语言服务器配置文件 (`lsp/*.lua`)

每个文件返回一个 **`vim.lsp.Config` 表**（不是函数）。该表会与 nvim-lspconfig 在 `lsp/<name>.lua` 提供的默认值深度合并，所以只需写差异项：

```lua
-- lsp/gopls.lua
return {
  root_markers = { "go.mod", ".git" },
  settings = {
    gopls = {
      gofumpt = true,
    },
  },
}
```

## 添加新的 LSP 服务器

### 步骤 1：创建配置文件（可选）

在 `lua/lsp/` 下创建，例如 `pyright.lua`。文件名必须与 `servers` 列表里的名字一致：

```lua
-- lsp/pyright.lua
return {
  settings = {
    python = {
      analysis = {
        typeCheckingMode = "basic",
      },
    },
  },
}
```

无自定义需求可以跳过这步。

### 步骤 2：添加到服务器列表

编辑 `lua/plugins/lsp.lua`：

```lua
local servers = {
  "gopls",
  "vtsls",
  -- ... 其他服务器
  "pyright",  -- 添加新服务器
}
```

### 步骤 3：安装 LSP 服务器

编辑 `lua/plugins/mason.lua`，加到 **mason-lspconfig** 的 `ensure_installed`（用 lspconfig 服务器名）：

```lua
ensure_installed = {
  "gopls",
  -- ...
  "pyright",
}
```

⚠️ 别加到 mason.nvim 那个 spec 里 —— **mason.nvim 没有 `ensure_installed` 选项**，写进去会被静默忽略。该文件里 formatter/linter 的安装是在 `config` 中用 `mason-registry` 自行实现的，且用的是 **mason 包名**（如 `prettierd`），与 mason-lspconfig 的服务器名不是一套。

## 修改现有 LSP 配置

编辑对应文件即可：

```lua
-- lua/lsp/gopls.lua
return {
  settings = {
    gopls = {
      gofumpt = false,  -- 禁用 gofumpt
    },
  },
}
```

## 配置说明

### Go (gopls)

- `root_markers = { "go.mod", ".git" }`
- 启用 gofumpt 格式化
- 关闭大部分 codelens 以优化性能

### TypeScript/JavaScript/Vue (vtsls + vue_ls)

- **`vtsls` 取代了 ts_ls，两者不可同时启用**
- `vtsls` 的 `filetypes` 包含 `vue`，并加载 `@vue/typescript-plugin`
- `vue_ls` 自 v3.0.0 起取消 takeover mode，只管 template/CSS，把 `<script>` 的 TS 请求转发给 `vtsls`；因此 **`.vue` 需要两个客户端同时在场**
- `maxTsServerMemory` 提到 12288 MB：默认 3072 在大型 Vue 项目上会持续 OOM，tsserver 被 SIGABRT 杀死后无限重启
- 详见 `docs/ts_ls-fix.md`

### Lua (lua_ls)

- 识别 vim 全局变量
- 加载 Neovim runtime 文件
- 禁用第三方库检查

### YAML (yamlls)

- 集成 JSON Schema Store
- 支持 GitHub Actions、Docker Compose 等 schema

### JSON (jsonls)

- 使用 schemastore 插件自动加载常见 schema
- 支持 JSON 和 JSONC

## 格式化说明

**所有文件格式化统一由 `conform.nvim` 管理**，不在 LSP 配置中处理。`setup_server` 会对 gopls 以外的服务器关闭 `documentFormattingProvider`。

- Go: gofmt + goimports（通过 Conform）
- TS/JS: prettier/prettierd（通过 Conform）
- 其他语言: 见 `lua/plugins/conform.lua`

## 故障排除

### LSP 未启动

1. 检查服务器是否安装：`:Mason`
2. 查看附着情况：`:lua =vim.tbl_map(function(c) return c.name end, vim.lsp.get_clients({ bufnr = 0 }))`
3. 查看日志：`:LspLog`

### 配置未生效

先确认 `plugins/lsp.lua` 的 `config` **真的执行了**。lazy.nvim 合并同一插件的多个 spec 片段时，`config`/`init` 只能存活一个，后者会静默覆盖前者 —— 这曾导致整份 LSP 配置失效，而因为 mason-lspconfig 的自动 enable 在背后用默认配置拉起了服务器，表面上完全看不出异常。

验证方法是断言**只有你的配置才会设置的值**，而不是只看客户端有没有附着：

```vim
:lua =vim.lsp.get_clients({ name = "gopls" })[1].config.settings.gopls.gofumpt
```

返回 `nil` 就说明配置没生效。检查有几个片段声明了 nvim-lspconfig：

```vim
:lua =require("lazy.core.config").plugins["nvim-lspconfig"]._.frags
```

详见 `CLAUDE.md` 的 Non-Obvious Gotchas 一节。

### 添加新服务器后不工作

1. 确认已加入 `plugins/lsp.lua` 的 `servers` 列表
2. 确认已加入 mason-lspconfig 的 `ensure_installed`
3. 确认配置文件名与服务器名完全一致
4. 重启 Neovim（lazy 加载的插件配置只在启动时应用，`:source` 无效）

## 参考文档

- [nvim-lspconfig](https://github.com/neovim/nvim-lspconfig)
- [Mason.nvim](https://github.com/williamboman/mason.nvim)
- `:help lsp-config` —— Neovim 原生 `vim.lsp.config` 文档
- `docs/ts_ls-fix.md` —— TypeScript/Vue 方案与排查
- `docs/gopls-fix.md` —— gopls 加载失败排查
