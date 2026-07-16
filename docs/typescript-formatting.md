# TypeScript/JavaScript 格式化配置指南

本文档说明了 TypeScript 和 JavaScript 的格式化配置和使用方法。

## 已配置的语言支持

### JavaScript / TypeScript
- ✅ JavaScript (`.js`)
- ✅ TypeScript (`.ts`)
- ✅ JSX (`.jsx`)
- ✅ TSX (`.tsx`)

### Web 相关
- ✅ HTML (`.html`)
- ✅ CSS (`.css`)
- ✅ SCSS (`.scss`)
- ✅ LESS (`.less`)
- ✅ JSON (`.json`, `.jsonc`)
- ✅ YAML (`.yml`, `.yaml`)
- ✅ Markdown (`.md`)

## 格式化工具

使用 **Prettier** / **Prettierd** 作为格式化工具：
- `prettier`: 标准的代码格式化工具
- `prettierd`: Prettier 守护进程版本（更快）

## 格式化配置

### 默认格式化规则
本配置只在 `conform.lua` 里给 prettier/prettierd 传了两个参数（`prepend_args`）：

```javascript
{
  "tabWidth": 2,        // 缩进宽度为 2 个空格（--tab-width 2）
  "singleQuote": true   // 使用单引号（--single-quote）
}
```

其余项（`semi`、`trailingComma`、`printWidth`、`arrowParens` 等）均使用 **Prettier 自身默认值**（例如 Prettier 3 的 `trailingComma` 默认为 `all`），本配置未覆盖；如需自定义，在项目根目录放 `.prettierrc`。

### 自定义配置
在项目根目录创建 `.prettierrc` 或 `.prettierrc.json` 文件来覆盖默认配置：

```json
{
  "tabWidth": 2,
  "singleQuote": true,
  "semi": false,
  "printWidth": 100
}
```

## 自动格式化

### 保存时自动格式化
配置已启用保存时自动格式化：
- 保存文件时自动触发格式化（`:w` 或 `Ctrl+s`）
- 超时时间：500ms
- 如果 Prettier 不可用，会回退到 LSP 格式化

### 支持的文件类型
保存以下文件时会自动格式化：
- `.js`, `.jsx` - JavaScript
- `.ts`, `.tsx` - TypeScript
- `.html` - HTML
- `.css`, `.scss`, `.less` - 样式文件
- `.json`, `.jsonc` - JSON
- `.yaml`, `.yml` - YAML
- `.md` - Markdown

## 手动格式化

### 快捷键
| 快捷键 | 模式 | 功能描述 |
|--------|------|----------|
| `<space>fm` | 普通模式 | 格式化整个文件 |
| `<space>fm` | 可视模式 | 格式化选中的代码 |

### 命令
```vim
:Format          " 格式化整个文件或选中区域
:ConformInfo     " 查看格式化工具信息
```

## LSP 支持

### TypeScript/JavaScript LSP
已配置 `ts_ls`（原 tsserver）提供：
- ✅ 代码补全
- ✅ 类型检查
- ✅ 跳转到定义 (`gd`)
- ✅ 查找引用 (`gr`)
- ✅ 重命名 (`<space>rn`)
- ✅ 代码操作 (`<space>ca`)
- ⚙️ 内联提示（Inlay Hints）：ts_ls 已配置，但**默认关闭**（`init.lua` 里 `vim.lsp.inlay_hint.enable(false)`、`lsp.lua` 里 `inlay_hints = { enabled = false }`），需要时 `:lua vim.lsp.inlay_hint.enable(true)` 开启

### HTML/CSS LSP
- HTML: 提供标签补全、验证
- CSS: 提供属性补全、颜色预览

## 使用示例

### 场景 1：格式化混乱的代码
```typescript
// 格式化前
function  test(x,y){const result=x+y;return result}

// 保存文件后自动格式化为：
function test(x, y) {
  const result = x + y;
  return result;
}
```

### 场景 2：手动格式化选中代码
```
1. 进入可视模式 (v 或 V)
2. 选中需要格式化的代码
3. 按 <space>fm
4. 选中的代码被格式化
```

### 场景 3：格式化整个文件
```
1. 在普通模式下
2. 按 <space>fm
3. 整个文件被格式化
```

### 场景 4：检查格式化工具状态
```vim
:ConformInfo
```
显示：
- 当前文件类型
- 可用的格式化工具
- 格式化工具的路径

## 安装格式化工具

### 自动安装
重启 Neovim 后，Mason 会自动安装：
- `prettier`
- `prettierd`
- TypeScript LSP (`ts_ls`)
- HTML LSP
- CSS LSP

### 手动安装
如果自动安装失败，可以手动安装：

```vim
:Mason
```
然后搜索并安装：
- `prettier`
- `prettierd`
- `typescript-language-server`
- `html-lsp`
- `css-lsp`

### 系统级安装（可选）
```bash
# 使用 npm
npm install -g prettier @fsouza/prettierd

# 或使用 yarn
yarn global add prettier @fsouza/prettierd
```

## 故障排除

### 问题 1：保存时没有自动格式化
**解决方案：**
1. 检查格式化工具是否安装：`:ConformInfo`
2. 检查文件类型是否支持：`:set filetype?`
3. 查看错误信息：`:messages`

### 问题 2：格式化速度慢
**解决方案：**
- 使用 `prettierd` 而不是 `prettier`
- `prettierd` 是守护进程版本，启动更快
- 配置已优先使用 `prettierd`

### 问题 3：格式化结果不符合预期
**解决方案：**
1. 在项目根目录创建 `.prettierrc` 配置文件
2. 或创建 `.editorconfig` 文件
3. 重启 Neovim 使配置生效

### 问题 4：LSP 不工作
**解决方案：**
```vim
:LspInfo          " 查看 LSP 状态
:LspRestart       " 重启 LSP
:Mason            " 检查 LSP 是否安装
```

## 项目配置示例

### .prettierrc（项目根目录）
```json
{
  "semi": false,
  "singleQuote": true,
  "tabWidth": 2,
  "trailingComma": "all",
  "printWidth": 100,
  "arrowParens": "avoid"
}
```

### .prettierignore（忽略文件）
```
node_modules
dist
build
*.min.js
*.min.css
```

### package.json 中的配置
```json
{
  "prettier": {
    "semi": false,
    "singleQuote": true,
    "tabWidth": 2
  }
}
```

## 其他语言的格式化

| 语言 | 格式化工具 | 自动安装 |
|------|-----------|---------|
| Go | gofmt, goimports | ✅ |
| Lua | stylua | ✅ |
| Python | black, isort | ❌ 需手动安装 |
| Rust | rustfmt | ❌ 需手动安装 |
| Shell | shfmt | ✅ |

## 快捷键总结

| 快捷键 | 功能 |
|--------|------|
| `<space>fm` | 格式化文件/选中代码 |
| `:Format` | 格式化命令 |
| `:ConformInfo` | 查看格式化工具信息 |
| `gd` | 跳转到定义 |
| `gr` | 查找引用 |
| `<space>rn` | 重命名 |
| `<space>ca` | 代码操作 |

## 注意事项

1. **保存时格式化**：
   - 默认启用，保存时自动格式化
   - 超时时间为 500ms
   - 如果格式化失败，文件仍会保存

2. **格式化优先级**：
   - 优先使用 `prettierd`（如果可用）
   - 回退到 `prettier`
   - 最后回退到 LSP 格式化

3. **项目配置优先**：
   - 项目中的 `.prettierrc` 会覆盖全局配置
   - 每个项目可以有不同的格式化规则

4. **性能考虑**：
   - `prettierd` 比 `prettier` 快 3-5 倍
   - 建议大型项目使用 `prettierd`

## 扩展阅读

- [Prettier 官方文档](https://prettier.io/docs/en/)
- [TypeScript LSP 配置](https://github.com/typescript-language-server/typescript-language-server)
- [Conform.nvim 文档](https://github.com/stevearc/conform.nvim)

