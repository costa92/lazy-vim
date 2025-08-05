# Mason 使用文档

Mason 是 Neovim 的包管理器，用于自动安装和管理 LSP 服务器、linters、formatters 和调试器。

## 基本命令

### 打开 Mason 界面
```vim
:Mason
```

### 核心操作
- `i` - 安装包
- `u` - 更新包  
- `X` - 卸载包
- `U` - 更新所有包
- `c` - 取消安装
- `q` - 退出界面

## 当前配置

### 自动安装的工具

#### LSP 服务器 (mason-lspconfig)
```lua
ensure_installed = { 
  "gopls",        -- Go
  "lua_ls",       -- Lua  
  "bashls",       -- Bash
  "jsonls",       -- JSON
  "marksman",     -- Markdown
  "yamlls",       -- YAML
  "taplo",        -- TOML
}
```

#### 格式化工具 (Mason)
```lua
ensure_installed = {
  "gofumpt",       -- Go formatter
  "shfmt",         -- Shell formatter
  "prettier",      -- JSON/YAML/Markdown formatter
  "stylua",        -- Lua formatter
}
```

#### 注释掉的 Linters（使用系统版本）
```lua
-- "golangci-lint", -- Go linter
-- "shellcheck",    -- Shell script linter
-- "yamllint",      -- YAML linter
-- "luacheck",      -- Lua linter
-- "markdownlint",  -- Markdown linter
-- "hadolint",      -- Dockerfile linter
```

## 手动安装工具

### 1. 通过 Mason 界面安装
```vim
:Mason
# 在界面中搜索工具名称，按 'i' 安装
```

### 2. 通过命令行安装
```vim
:MasonInstall <tool-name>
```

### 3. 常用工具安装示例
```vim
:MasonInstall golangci-lint
:MasonInstall shellcheck
:MasonInstall yamllint
:MasonInstall luacheck
:MasonInstall markdownlint
:MasonInstall hadolint
:MasonInstall eslint_d
:MasonInstall pylint
```

## 工具分类

### LSP 服务器
| 语言 | LSP 服务器 | 状态 |
|------|-----------|------|
| Go | gopls | ✅ 自动安装 |
| Lua | lua_ls | ✅ 自动安装 |
| Bash/Shell | bashls | ✅ 自动安装 |
| JSON | jsonls | ✅ 自动安装 |
| Markdown | marksman | ✅ 自动安装 |
| YAML | yamlls | ✅ 自动安装 |
| TOML | taplo | ✅ 自动安装 |
| Python | pylsp/pyright | 🔧 手动安装 |
| JavaScript/TypeScript | tsserver | 🔧 手动安装 |
| Rust | rust_analyzer | 🔧 手动安装 |

### 代码格式化工具
| 语言/格式 | 格式化工具 | 状态 |
|-----------|-----------|------|
| Go | gofumpt | ✅ 自动安装 |
| Shell | shfmt | ✅ 自动安装 |
| JSON/YAML/Markdown | prettier | ✅ 自动安装 |
| Lua | stylua | ✅ 自动安装 |
| Python | black/isort | 🔧 手动安装 |
| JavaScript/TypeScript | prettier | ✅ 已安装 |

### 代码检测工具 (Linters)
| 语言 | Linter | 状态 | 配置位置 |
|------|--------|------|----------|
| Go | golangci-lint | 🟡 系统安装 | nvim-lint.lua:10 |
| Shell | shellcheck | 🟡 系统安装 | nvim-lint.lua:14-15 |
| YAML | yamllint | 🟡 系统安装 | nvim-lint.lua:18-19 |
| Lua | luacheck | 🟡 系统安装 | nvim-lint.lua:25 |
| Markdown | markdownlint | ❌ 禁用 | nvim-lint.lua:35 |
| Dockerfile | hadolint | ❌ 禁用 | nvim-lint.lua:38 |

## 启用更多 Linters

要启用被注释的 linters，需要两个步骤：

### 1. 通过 Mason 安装工具
```vim
:MasonInstall shellcheck yamllint luacheck markdownlint hadolint
```

### 2. 在配置中启用
编辑 `lua/plugins/nvim-lint.lua`，取消对应行的注释：

```lua
lint.linters_by_ft = {
  go = { "golangcilint" },
  bash = { "shellcheck" },        -- 取消注释
  sh = { "shellcheck" },          -- 取消注释
  yaml = { "yamllint" },          -- 取消注释
  yml = { "yamllint" },           -- 取消注释
  lua = { "luacheck" },           -- 取消注释
  markdown = { "markdownlint" },  -- 取消注释
}
```

## 常见问题排查

### 1. 工具安装失败
```vim
:checkhealth mason
```

### 2. 查看安装状态
```vim
:Mason
# 查看工具列表和安装状态
```

### 3. 手动重新安装
```vim
:MasonUninstall <tool-name>
:MasonInstall <tool-name>
```

### 4. 清理缓存
```bash
# 删除 Mason 数据目录
rm -rf ~/.local/share/nvim/mason
```

## 配置文件位置

- **Mason 配置**: `lua/plugins/mason.lua`
- **Linter 配置**: `lua/plugins/nvim-lint.lua`
- **LSP 配置**: `lua/plugins/lspconfig.lua`
- **格式化配置**: `lua/plugins/conform.lua`

## 添加新语言支持

### 1. 添加 LSP 服务器
```lua
-- 在 lua/plugins/mason.lua 中添加
ensure_installed = {
  "gopls",
  "lua_ls",
  -- 添加新的 LSP 服务器
  "pyright",     -- Python
  "tsserver",    -- TypeScript
}
```

### 2. 添加 Linter
```lua
-- 在 lua/plugins/nvim-lint.lua 中添加
lint.linters_by_ft = {
  go = { "golangcilint" },
  -- 添加新的 linter 配置
  python = { "pylint", "flake8" },
  javascript = { "eslint" },
}
```

### 3. 添加格式化工具
```lua
-- 在 lua/plugins/mason.lua 中添加
ensure_installed = {
  "gofumpt",
  "stylua",
  -- 添加新的格式化工具
  "black",       -- Python
  "isort",       -- Python imports
}
```

## 有用的命令

```vim
:Mason                    " 打开 Mason 界面
:MasonInstall <tool>      " 安装特定工具
:MasonUninstall <tool>    " 卸载工具
:MasonUpdate             " 更新所有工具
:checkhealth mason       " 检查 Mason 健康状态
:Lint                    " 手动运行 linter（自定义命令）
```

## 快捷键

- `<leader>l` - 手动运行 linter
- `<leader>i` - 格式化当前文件
- `<leader>ca` - 显示代码操作菜单

现在你可以根据需要通过 Mason 安装和管理各种开发工具了！