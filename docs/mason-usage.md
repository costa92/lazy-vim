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
  "vtsls",        -- TypeScript/JavaScript（取代 ts_ls，两者不可共存）
  "vue_ls",       -- Vue SFC（依赖 vtsls 提供 <script> 的 TS 能力）
  "html",         -- HTML
  "cssls",        -- CSS
}
```

⚠️ 这份列表属于 **mason-lspconfig**，用的是 lspconfig 服务器名。同文件里 mason.nvim 那个 spec **没有** `ensure_installed` 选项，formatter 的安装是在其 `config` 里用 `mason-registry` 自行实现的，用的是 mason 包名。两者不要混。

另外 mason-lspconfig 的 `automatic_enable` 已显式设为 `false`：默认 `true` 会把所有已安装服务器以 lspconfig 原版默认配置自动启用，绕过 `plugins/lsp.lua`，并连带启用已安装但不该启用的 `ts_ls`（与 `vtsls` 冲突）。

#### 格式化工具 (mason.nvim)
在 `lua/plugins/mason.lua` 的 `config` 函数里，用 `mason-registry` 自行安装（**不是** `opts.ensure_installed`）：

```lua
local ensure_installed = {
  "gofumpt",       -- Go formatter
  "shfmt",         -- Shell formatter
  "prettier",      -- JSON/YAML/Markdown/JS/TS formatter
  "prettierd",     -- Prettier 守护进程（更快）
  "stylua",        -- Lua formatter
}
```

之所以要自己实现：**mason.nvim 的 settings schema 里根本没有 `ensure_installed` 字段**，写在 `opts` 里会被静默忽略，上述 formatter 曾因此长期处于未安装状态。

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
| TypeScript/JavaScript | vtsls | ✅ 自动安装 |
| Vue SFC | vue_ls | ✅ 自动安装 |
| HTML | html | ✅ 自动安装 |
| CSS | cssls | ✅ 自动安装 |
| Python | pylsp/pyright | 🔧 手动安装 |
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
| Go | golangci-lint | ✅ 启用（系统安装） | nvim-lint.lua:10 |
| Shell | shellcheck | ❌ 未启用（已注释） | nvim-lint.lua:14-15 |
| YAML | yamllint | ❌ 未启用（已注释） | nvim-lint.lua:18-19 |
| Lua | luacheck | ❌ 未启用（已注释） | nvim-lint.lua:25 |
| Markdown | markdownlint | ❌ 未启用（已注释） | nvim-lint.lua:35 |
| Dockerfile | hadolint | ❌ 禁用（`dockerfile = {}`） | nvim-lint.lua:38 |

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
- **LSP 配置**: `lua/plugins/lsp.lua`（server 列表在此，逐服务器配置在 `lua/lsp/`）
- **格式化配置**: `lua/plugins/conform.lua`

## 添加新语言支持

### 1. 添加 LSP 服务器
```lua
-- 在 lua/plugins/mason.lua 的 mason-lspconfig spec 里（用 lspconfig 服务器名）
ensure_installed = {
  "gopls",
  "lua_ls",
  -- 添加新的 LSP 服务器
  "pyright",     -- Python
}
```

装上还不够 —— `automatic_enable` 已关闭，**必须同时把服务器名加入 `lua/plugins/lsp.lua` 的 `servers` 列表**才会真正启用。逐服务器的自定义配置放在 `lua/lsp/<name>.lua`，详见 `lua/lsp/README.md`。

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
-- 在 lua/plugins/mason.lua 的 mason.nvim config 函数里（用 mason 包名）
local ensure_installed = {
  "gofumpt",
  "stylua",
  -- 添加新的格式化工具
  "black",       -- Python
  "isort",       -- Python imports
}
```

装完还要在 `lua/plugins/conform.lua` 的 `formatters_by_ft` 里挂到对应文件类型上，否则只是装了不用。

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
- `<leader>fm` - 格式化当前文件（或命令 `:Format`）
- `<leader>ca` - 显示代码操作菜单

现在你可以根据需要通过 Mason 安装和管理各种开发工具了！