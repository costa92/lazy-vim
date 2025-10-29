# LSP 配置结构说明

LSP 配置已经重构为模块化结构，每个语言服务器都有独立的配置文件。

## 目录结构

```
lua/
├── plugins/
│   └── lsp.lua              # 主配置文件，加载所有 LSP 服务器
└── lsp/                     # LSP 配置目录（独立于 plugins）
    ├── README.md            # 本说明文档
    ├── init.lua             # 通用工具和配置函数
    ├── gopls.lua            # Go LSP
    ├── ts_ls.lua            # TypeScript/JavaScript LSP
    ├── lua_ls.lua           # Lua LSP
    ├── yamlls.lua           # YAML LSP
    ├── html.lua             # HTML LSP
    ├── cssls.lua            # CSS LSP
    ├── jsonls.lua           # JSON LSP
    ├── taplo.lua            # TOML LSP
    ├── bashls.lua           # Bash/Shell LSP
    └── marksman.lua         # Markdown LSP
```

**注意**：LSP 配置文件位于 `lua/lsp/` 目录，而不是 `lua/plugins/lsp/`。这样可以避免 Lazy.nvim 的自动扫描警告。

## 工作原理

### 1. 主配置文件 (`lsp.lua`)

- 加载通用配置模块
- 定义需要加载的 LSP 服务器列表
- 自动加载每个服务器的配置文件

### 2. 通用模块 (`lsp/init.lua`)

包含两个主要函数：

- `setup_global()`: 设置全局 LSP 配置
- `setup_server(server_name, config)`: 通用服务器配置函数

### 3. 语言服务器配置文件 (`lsp/*.lua`)

每个文件返回一个配置函数，接收 `setup_server` 作为参数：

```lua
-- lsp/gopls.lua
return function(setup_server)
  setup_server("gopls", {
    -- 服务器特定配置
  })
end
```

## 添加新的 LSP 服务器

### 步骤 1：创建配置文件

在 `lua/plugins/lsp/` 目录下创建新文件，例如 `python.lua`:

```lua
-- lsp/python.lua
return function(setup_server)
  setup_server("pyright", {
    settings = {
      python = {
        analysis = {
          typeCheckingMode = "basic"
        }
      }
    }
  })
end
```

### 步骤 2：添加到服务器列表

编辑 `lua/plugins/lsp.lua`，在 servers 列表中添加服务器名：

```lua
local servers = {
  "gopls",
  "ts_ls",
  -- ... 其他服务器
  "pyright",  -- 添加新服务器
}
```

### 步骤 3：安装 LSP 服务器

编辑 `lua/plugins/mason.lua`，添加到 `ensure_installed` 列表：

```lua
ensure_installed = {
  "gopls",
  -- ...
  "pyright",  -- 添加新服务器
}
```

## 修改现有 LSP 配置

只需编辑对应的配置文件即可，例如修改 Go LSP：

```lua
-- lua/plugins/lsp/gopls.lua
return function(setup_server)
  setup_server("gopls", {
    -- 修改这里的配置
    settings = {
      gopls = {
        gofumpt = false,  -- 禁用 gofumpt
        -- ...
      }
    }
  })
end
```

## 优势

1. **模块化**：每个语言服务器配置独立，互不影响
2. **易维护**：修改某个语言的配置只需编辑对应文件
3. **易扩展**：添加新语言只需创建新文件
4. **清晰**：配置文件小巧，易于理解
5. **复用**：通用配置在 `init.lua` 中统一管理

## 配置说明

### Go (gopls)

- 使用缓存的根目录查找
- 启用 gofumpt 格式化
- 优化性能设置

### TypeScript/JavaScript (ts_ls)

- 支持 package.json, tsconfig.json 项目检测
- 启用内联类型提示
- 支持 JSX/TSX

### Lua (lua_ls)

- 识别 vim 全局变量
- 加载 Neovim runtime 文件
- 禁用第三方库检查

### YAML (yamlls)

- 集成 JSON Schema Store
- 支持 GitHub Actions, Docker Compose 等 schema
- 启用自动补全和验证

### JSON (jsonls)

- 使用 schemastore 插件
- 自动加载常见 JSON schemas
- 支持 JSON 和 JSONC

## 格式化说明

**重要**: 所有文件格式化统一由 `conform.nvim` 管理，不在 LSP 配置中处理。

- Go: gofmt + goimports（通过 Conform）
- TS/JS: prettier/prettierd（通过 Conform）
- 其他语言: 见 `lua/plugins/conform.lua`

## 故障排除

### LSP 未启动

1. 检查服务器是否安装：`:Mason`
2. 查看 LSP 状态：`:LspInfo`
3. 查看日志：`:LspLog`

### 配置未生效

1. 重启 Neovim
2. 检查语法：`lua require('plugins.lsp')`
3. 查看错误：`:messages`

### 添加新服务器后不工作

1. 确保在 `lsp.lua` 的 servers 列表中添加
2. 确保在 `mason.lua` 中添加到 ensure_installed
3. 重启 Neovim 让 Mason 自动安装

## 参考文档

- [nvim-lspconfig](https://github.com/neovim/nvim-lspconfig)
- [Mason.nvim](https://github.com/williamboman/mason.nvim)
- [LSP 配置示例](https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md)
