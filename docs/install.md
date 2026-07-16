# 安装指南

本文档给出完整的从零安装步骤，含系统依赖、外部工具、验证与常见问题处理。

## 系统要求

| 项 | 版本 | 说明 |
|----|------|------|
| Neovim | **≥ 0.10**（推荐 0.11+） | 配置用到 `vim.fs.root`、`vim.bo[].omnifunc` 等 API |
| Git | 任意较新版本 | 克隆配置、`lazy.nvim` 拉插件 |
| Nerd Font | v3.0+ | 图标显示（JetBrainsMono、FiraCode NF、Hack NF 等任一） |
| 操作系统 | Linux / macOS | Windows 可用但未验证 |

## 外部依赖（按使用功能选装）

### 必装

| 工具 | 装法示例 | 用途 |
|------|---------|------|
| `ripgrep` | `apt install ripgrep` / `brew install ripgrep` | fzf-lua 全局搜索（`<leader>fg`） |
| `fd` | `apt install fd-find` / `brew install fd` | fzf-lua 文件查找（`<leader>o`） |
| `go` | 参考 [go.dev](https://go.dev/dl/) | Go 开发 + gopls |
| `node` + `npm` | 参考 [nodejs.org](https://nodejs.org/) | TypeScript LSP、conform 前端格式化、markdown-preview |
| C 编译器 | `apt install build-essential` / Xcode CLI | Treesitter parser 编译 |

### 按需装

| 场景 | 工具 | 装法 |
|------|------|------|
| **Go 调试**（`<leader>Td` / `<leader>d*`） | `delve` | `:MasonInstall delve` |
| **JS/TS 调试** | `js-debug-adapter` | `:MasonInstall js-debug-adapter` |
| **Shell 脚本 lint** | `shellcheck` | `:MasonInstall shellcheck` |
| **Docker lint** | `hadolint` | `:MasonInstall hadolint` |
| **YAML lint** | `yamllint` | `:MasonInstall yamllint` |
| **Markdown 预览** | `npm` + 自动装 markdown-preview.nvim 依赖 | 首次启动时自动拉 |
| **AI 助手**（avante） | API key | 环境变量配 `ANTHROPIC_API_KEY` 等 |

Mason 会自动拉绝大多数 LSP / 格式化器 / lint 工具，无需手动 `apt install`。

## 安装步骤

```bash
# 1. 备份现有配置
[ -d ~/.config/nvim ] && mv ~/.config/nvim ~/.config/nvim.backup.$(date +%s)
[ -d ~/.local/share/nvim ] && mv ~/.local/share/nvim ~/.local/share/nvim.backup.$(date +%s)

# 2. 克隆配置
git clone git@github.com:costa92/lazy-vim.git ~/.config/nvim

# 3. 启动 Neovim（lazy.nvim 会自动拉取全部插件）
nvim
```

首次启动会看到 `:Lazy` 面板自动弹出下载进度条，耐心等到全部 `●` 状态（约 1-3 分钟）。过程中可能偶发 `press ENTER` 提示，回车继续即可。

## 启动后首次配置

### 1. 拉 Treesitter parsers

```vim
:TSInstall go lua bash json yaml markdown typescript tsx javascript
```

或一次装常用：
```vim
:TSInstallSync maintained
```

验证：
```vim
:TSInstallInfo
```

### 2. 触发 Mason 装 LSP / 工具

```vim
:Mason
```

在 Mason 面板里按 `2`（Installed）或手动装想要的工具。**推荐至少装**：

```vim
:MasonInstall gopls delve golangci-lint shellcheck stylua prettier
```

### 3. 健康检查

```vim
:checkhealth
```

关注几个关键段：
- `:checkhealth lazy` — 插件全部加载
- `:checkhealth nvim-treesitter` — parser 全部就绪
- `:checkhealth mason` — Mason 能找到 PATH
- `:checkhealth neotest` — 测试框架可用
- `:checkhealth dap` — 调试器配置正常

### 4. Neotest 补丁（自动应用）

`plugins/neotest.lua` 的 `build` hook 会在 neotest-golang 安装/更新后自动跑 `scripts/patch-neotest-golang.lua`。如果之后 Go 测试识别不到（`:Neotest summary` 是空的），手动重跑：

```bash
lua ~/.config/nvim/scripts/patch-neotest-golang.lua
```

详情见 [`CLAUDE.md`](../CLAUDE.md) 的 `Non-Obvious Gotchas`。

## 验证清单

完成安装后，按顺序快速验证：

| 测试 | 操作 | 预期 |
|------|------|------|
| 启动速度 | `nvim` | 1-2 秒内进入 alpha 起始页 |
| 文件树 | `<C-b>` | 左侧弹出 neo-tree |
| 模糊找文件 | `<leader>o` | FZF 悬浮窗，能搜项目文件 |
| 全局搜索 | `<leader>fg` + 输入关键字 | 能跨文件 grep |
| LSP | 打开 `.go` 文件等几秒 | 右下角 fidget 显示 `gopls` 加载进度 |
| 代码补全 | 进 insert 模式打代码 | 弹出 cmp 补全菜单 |
| 定义跳转 | 光标在函数名上按 `gd` | 跳到定义，`<C-o>` 跳回 |
| 格式化 | `:Format` | 文件按 conform 规则格式化 |
| 测试 | 在 `*_test.go` 按 `<leader>TS` | 右侧出现 neotest 摘要树 |
| Git 状态 | 打开 git 仓库里的文件 | 左边栏出现 gitsigns 的 `+`/`~`/`-` |

## 常见问题

### 图标是乱码方块

终端字体没装 Nerd Font。去 [nerdfonts.com](https://www.nerdfonts.com/) 下载任一 Nerd Font，在终端设置里选上。

### `<C-s>` / `<C-q>` 无反应

终端的流控拦截了。永久禁用：
```bash
echo "stty -ixon" >> ~/.zshrc   # 或 ~/.bashrc
source ~/.zshrc
```

### gopls 加载很慢

大型 Go 项目首次索引正常要 1-3 分钟。fidget 会显示进度。如果超过 5 分钟：
```vim
:LspInfo
:LspLog
```
看日志。通常是 `GOPATH` / `GO111MODULE` / 工作区 module root 检测问题。

### Treesitter 报 "parser not found"

```vim
:TSInstall <语言>
```
或删掉旧 parser 缓存重装：
```bash
rm -rf ~/.local/share/nvim/lazy/nvim-treesitter/parser/
```
重启 nvim，`:TSInstall` 想要的语言。

### neotest 找不到 Go 测试

见上面"Neotest 补丁"一节。通常是 tree-sitter-go 和 neotest-golang 查询不匹配。

### avante / AI 功能不工作

需要 API key。把这几个里你用哪个的加到 shell rc：
```bash
export ANTHROPIC_API_KEY=sk-ant-...
export OPENAI_API_KEY=sk-...
```
然后重启终端和 nvim。

### 配置改动后插件没重新加载

lazy.nvim 懒加载的插件配置**只在启动时生效**。改完 `lua/plugins/*.lua` 后**必须完全退出**（`:qa`）再启动，不能用 `:source` 或 `:Lazy reload`。

## 卸载

```bash
rm -rf ~/.config/nvim ~/.local/share/nvim ~/.local/state/nvim ~/.cache/nvim
# 如果之前备份了：
mv ~/.config/nvim.backup.xxx ~/.config/nvim
```

## 更新

```bash
cd ~/.config/nvim && git pull
nvim +":Lazy sync" +qa   # 更新所有插件到 lazy-lock.json 里的版本
```

想升级某个插件到最新：
```vim
:Lazy update <plugin-name>
```

## 参考链接

- 详细快捷键：[`docs/`](./) 目录下按主题分类的 md 文件
- 架构与陷阱说明：[`CLAUDE.md`](../CLAUDE.md)
- 配置迭代规则：修改后必须 `:qa` 重启生效
