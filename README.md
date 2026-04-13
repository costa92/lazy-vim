# Neovim Configuration

这是一个现代化的 Neovim 配置，使用 [lazy.nvim](https://github.com/folke/lazy.nvim) 作为插件管理器，提供了丰富的功能和优雅的界面。

## ✨ 特性

- 🚀 使用 lazy.nvim 进行插件管理
- 🎨 默认使用 Tokyo Night 主题（可切换到 Gruvbox）
- 📝 完整的 LSP 支持
- 🔍 模糊搜索（FZF）
- 🌲 语法高亮（Treesitter）
- ⌨️ 智能代码补全（nvim-cmp）
- 🔍 代码质量检测（nvim-lint）
- 🚨 增强诊断界面（Trouble.nvim）
- 📦 Git 集成（gitsigns）
- 💡 Which-key 快捷键提示
- 🔧 代码格式化（conform.nvim）
- 💬 注释支持
- 📊 状态栏美化（lualine）
- 🎯 缩进指示线
- 📢 通知系统
- 🚦 终端集成

## ⌨️ 快捷键

### Leader 键设置
- `<Space>` - 全局 Leader 键
- `\` - 本地 Leader 键

### 基础操作

| 快捷键 | 模式 | 功能描述 |
|--------|------|----------|
| `<C-s>` | 所有模式 | 保存文件 |
| `<C-q>` | 所有模式 | 退出文件 |
| `<ESC>` | 普通模式 | 清除搜索高亮 |
| `<S-n>` | 普通模式 | 切换行号显示 |
| `<leader>i` | 普通模式 | 格式化当前文件 |

### 窗口管理

| 快捷键 | 功能描述 |
|--------|----------|
| `sv` | 垂直分屏 |
| `sh` | 水平分屏 |
| `sc` | 关闭当前窗口 |
| `so` | 关闭其他窗口 |
| `<C-h>` | 切换到左窗口 |
| `<C-j>` | 切换到下窗口 |
| `<C-k>` | 切换到上窗口 |
| `<C-l>` | 切换到右窗口 |

### 文本编辑与移动

| 快捷键 | 模式 | 功能描述 |
|--------|------|----------|
| `J` | 可视模式 | 向下移动选中文本 |
| `K` | 可视模式 | 向上移动选中文本 |
| `<A-j>` | 普通/插入模式 | 向下移动当前行 |
| `<A-k>` | 普通/插入模式 | 向上移动当前行 |
| `<C-h>` | 插入模式 | 跳到行首 |
| `<C-l>` | 插入模式 | 跳到行尾 |

### 文件浏览与管理 (Neo-tree & FZF)

| 快捷键 | 功能描述 |
|--------|----------|
| `<C-b>` | 打开/关闭文件树 |
| `<leader>ee` | 在文件树中定位当前文件 |
| `<C-e>` | 显示缓冲区列表 (FZF) |
| `<leader>r` | 最近使用的文件 (FZF) |
| `<leader>o` | 快速打开文件 (FZF) |
| `<leader>f` | 全局文本搜索 (FZF) |
| `<C-f>` | 当前文件内搜索 (FZF) |
| `<leader>s` | Treesitter 符号搜索 (FZF) |
| `<leader>h` | 搜索历史 (FZF) |
| `<leader>m` | 显示标记列表 (FZF) |
| `<leader>fj` | 浏览跳转历史 jumplist (FZF) |

### Git 集成

| 快捷键 | 功能描述 |
|--------|----------|
| `<leader>gp` | Git 提交历史 |
| `<leader>gb` | 当前文件的 Git 历史 |
| `<leader>gs` | Git 状态 |
| `<leader>b` | 切换 Git blame 显示 |

### LSP (语言服务器) 功能

#### 基础 LSP 操作
| 快捷键 | 功能描述 |
|--------|----------|
| `gd` | 跳转到定义 |
| `gr` | 查看引用 |
| `gi` | 跳转到实现 |
| `K` | 显示悬浮文档 |
| `<leader>rn` | 重命名符号 |
| `<leader>ca` | 代码操作菜单 |
| `<leader>D` | 跳转到类型定义 |

#### FZF LSP 高级搜索
| 快捷键 | 功能描述 |
|--------|----------|
| `<leader>fd` | FZF LSP 定义搜索 |
| `<leader>fR` | FZF LSP 引用搜索 |
| `<leader>fi` | FZF LSP 实现搜索 |
| `<leader>fS` | FZF 文档符号搜索 |
| `<leader>fW` | FZF 工作区符号搜索 |

### 代码诊断与质量检查

| 快捷键 | 功能描述 |
|--------|----------|
| `[d` | 跳转到上一个诊断 |
| `]d` | 跳转到下一个诊断 |
| `<leader>e` | 显示当前行诊断 |
| `<leader>q` | 打开诊断 quickfix 列表 |
| `<leader>l` | 手动运行代码检测 |

#### Trouble 诊断界面
| 快捷键 | 功能描述 |
|--------|----------|
| `<leader>xx` | 打开/关闭 Trouble 诊断界面 |
| `<leader>xX` | 显示当前缓冲区诊断 |
| `<leader>cs` | 显示符号列表 (Trouble) |
| `<leader>cl` | 显示 LSP 定义/引用 (Trouble) |
| `<leader>xL` | 显示位置列表 (Trouble) |
| `<leader>xQ` | 显示快速修复列表 (Trouble) |

### Go 开发专用

| 快捷键 | 功能描述 |
|--------|----------|
| `<leader>fe` | 插入 `if err != nil` |
| `<leader>gf` | 填充结构体字段 |
| `<leader>fc` | 填充 switch 语句 |
| `<leader>ta` | 添加结构体标签 |
| `<leader>tr` | 移除结构体标签 |
| `<leader>tc` | 清除所有结构体标签 |

### 调试 (DAP)

基于 `nvim-dap` + `nvim-dap-ui` + `nvim-dap-go`。Go 调试需先在 `:Mason` 安装 `delve`。完整文档见 [`docs/dap-keymaps.md`](docs/dap-keymaps.md)。

| 快捷键 | 功能描述 |
|--------|----------|
| `<leader>db` / `<leader>dB` | 打断点 / 条件断点 |
| `<leader>dc` | 开始调试 / 继续 |
| `<leader>di` / `<leader>do` / `<leader>dO` | Step Into / Over / Out |
| `<leader>du` | 切换调试 UI 面板 |
| `<leader>dK` | 悬浮显示变量值 |
| `<leader>dr` | 打开 REPL |
| `<leader>dt` | 终止会话 |
| `<leader>dgt` / `<leader>dgl` | Go：调试当前测试 / 上次测试 |

### 测试 (Neotest)

基于 `neotest` + `neotest-golang` + `neotest-jest`。使用大写 `<leader>T*` 前缀避免与 `<leader>t*` 已有绑定冲突。完整文档见 [`docs/neotest-keymaps.md`](docs/neotest-keymaps.md)（含 summary 树内部快捷键 `r`/`R`/`d`/`o`/`x`、命令行接口、常见问题）。

| 快捷键 | 功能描述 |
|--------|----------|
| `<leader>Tn` | 跑光标处的测试 |
| `<leader>Tf` | 跑当前文件全部测试 |
| `<leader>Td` | 用 DAP 调试光标处测试 |
| `<leader>Ts` | 停止测试 |
| `<leader>To` / `<leader>Tp` | 输出窗口 / 输出面板 |
| `<leader>TS` | 切换测试摘要侧边栏 |

**行为说明**：Go 默认 `go test -v -race -count=1 -timeout=30s`，超时自动 panic；测试失败会自动弹输出面板；`:q!` 退出前会自动停测试/断 LSP/断 DAP 避免卡顿。

### 快速跳转 (Harpoon)

基于 `harpoon2`。把 4-5 个热文件钉到固定槽位，秒切。完整文档见 [`docs/harpoon-keymaps.md`](docs/harpoon-keymaps.md)。

| 快捷键 | 功能描述 |
|--------|----------|
| `<leader>Ha` | 把当前文件加入 harpoon |
| `<leader>He` | 打开 harpoon 菜单 |
| `<leader>1` / `<leader>2` / `<leader>3` / `<leader>4` | 跳到槽位 1-4 |
| `<leader>Hn` / `<leader>Hp` | 下一个 / 上一个 |

### 文本环绕 (nvim-surround)

成对符号（引号、括号、HTML 标签）的 `y`/`c`/`d` 三动词管理。完整文档见 [`docs/surround-keymaps.md`](docs/surround-keymaps.md)。

| 操作 | 功能描述 |
|--------|----------|
| `ysiw"` | 给光标下单词加双引号 |
| `cs"'` | 把双引号换成单引号 |
| `ds"` | 删掉双引号 |
| `yss)` | 整行用括号包起来 |
| `v` / `V` 选中后按 `S"` | 给选区加双引号 |

### 实用工具

| 快捷键 | 功能描述 |
|--------|----------|
| `<leader>il` | 切换缩进指示线 |
| `<leader>fp` | 显示当前文件绝对路径 |
| `<leader>yfp` | 复制当前文件绝对路径 |
| `<leader>fr` | 显示当前文件相对路径 |
| `<leader>yr` | 复制当前文件相对路径 |
| `<leader>md` | 切换 Markdown 渲染 |

### 命令模式快捷命令

| 命令 | 功能描述 |
|------|----------|
| `:MarkdownPreview` | 启动 Markdown 预览 |
| `:MarkdownPreviewToggle` | 切换 Markdown 预览 |
| `:MarkdownPreviewStop` | 停止 Markdown 预览 |
| `:Neotree` | 打开文件树 |
| `:Neotree toggle` | 切换文件树 |
| `:Neotree reveal` | 在文件树中定位当前文件 |
| `:ToggleTerm` | 切换终端 |
| `:BlameToggle` | 切换 Git blame |
| `:Git` | Git 命令 |
| `:G` | Git 命令简写 |
| `:Gvdiffsplit` | Git 垂直分屏差异 |
| `:Trouble` | 打开 Trouble 界面 |
| `:Lint` | 手动运行代码检测 |
| `:Mason` | 打开 Mason 包管理器 |
| `:Lazy` | 打开 Lazy 插件管理器 |
| `:DapReloadConfig` | 重新加载调试配置 |
| `:DapInfo` | 显示调试配置信息 |
| `:DapUIRefresh` | 刷新调试 UI |
| `:DapUIStatus` | 显示调试 UI 状态 |
| `:DapClearConfigs` | 清理多余的调试配置，只保留基础配置 |
| `:DapLoadVSCode` | 重新加载项目的 .vscode/launch.json 配置 |
| `:DapReloadProject` | 重新加载当前项目的完整调试配置（基础+VSCode） |
| `:DapDeduplicateConfigs` | 移除重复的调试配置 |

### 性能监控

| 快捷键 | 功能描述 |
|--------|----------|
| `<leader>pt` | 开始性能分析 |
| `<leader>ps` | 停止性能分析 |
| `<leader>pst` | 测试文件操作性能 |

### 文件树 (Neo-tree) 内部快捷键

| 快捷键 | 功能描述 |
|--------|----------|
| `<space>` | 展开/折叠节点 |
| `<cr>` 或 鼠标双击 | 打开文件 |
| `P` | 切换预览 |
| `S` | 在新窗口中打开 |
| `s` | 在垂直分屏中打开 |
| `t` | 在新标签页中打开 |
| `w` | 使用窗口选择器打开 |
| `C` | 关闭节点 |
| `z` | 关闭所有节点 |
| `a` | 添加文件 |
| `A` | 添加目录 |
| `d` | 删除 |
| `r` | 重命名 |
| `y` | 复制到剪贴板 |
| `x` | 剪切到剪贴板 |
| `p` | 从剪贴板粘贴 |
| `c` | 复制 |
| `m` | 移动 |
| `q` | 关闭窗口 |
| `R` | 刷新 |
| `?` | 显示帮助 |

## 📦 安装要求

- Neovim >= 0.9.0
- Git
- 一个 Nerd Font 字体（用于图标显示）

## 🛠️ 安装步骤

1. 备份你现有的配置（如果有的话）：
   ```bash
   mv ~/.config/nvim ~/.config/nvim.backup
   ```

2. 克隆此配置：
   ```bash
   git clone https://github.com/yourusername/nvim-config.git ~/.config/nvim
   ```

3. 启动 Neovim，插件将自动安装：
   ```bash
   nvim
   ```

## 📂 目录结构

```
.
├── init.lua              # 主配置入口
├── lua
│   ├── configs/          # 基础配置
│   └── plugins/          # 插件配置
└── lazy-lock.json       # 插件版本锁定文件
```

## 🔌 插件列表 (Plugin List)

*   **[alpha-nvim](https://github.com/goolord/alpha-nvim)**: 一个漂亮的启动屏幕。
*   **[nvim-autopairs](https://github.com/windwp/nvim-autopairs)**: 自动配对括号、引号等。
*   **[avante.vim](https://github.com/lewis6991/avante.vim)**: 在 Neovim 和其他程序之间进行交互。
*   **[git-blame.nvim](https://github.com/f-person/git-blame.nvim)**: 在状态栏中显示当前行的 `git blame` 信息。
*   **[nvim-cmp](https://github.com/hrsh7th/nvim-cmp)**: 一个强大的自动补全引擎。
*   **[Comment.nvim](https://github.com/numToStr/Comment.nvim)**: 快速注释代码。
*   **[conform.nvim](https://github.com/stevearc/conform.nvim)**: 一个用于格式化代码的插件。
*   **[fzf-lua](https://github.com/ibhagwan/fzf-lua)**: `fzf` 的 Lua 版本，用于模糊搜索文件、缓冲区、git commit 等。
*   **[gitsigns.nvim](https://github.com/lewis6991/gitsigns.nvim)**: 在符号列中显示 git 状态。
*   **[vim-go](https://github.com/fatih/vim-go)**: Go 语言开发的全面支持。
*   **[gruvbox.nvim](https://github.com/ellisonleao/gruvbox.nvim)**: 一个流行的复古主题。
*   **[guess-indent.nvim](https://github.com/nmac427/guess-indent.nvim)**: 自动检测和设置缩进。
*   **[indent-blankline.nvim](https://github.com/lukas-reineke/indent-blankline.nvim)**: 显示缩进线。
*   **[nvim-lspconfig](https://github.com/neovim/nvim-lspconfig)**: Neovim 的语言服务器协议 (LSP) 配置。
*   **[lualine.nvim](https://github.com/nvim-lualine/lualine.nvim)**: 一个漂亮的、可定制的状态栏。
*   **[markdown-preview.nvim](https://github.com/iamcco/markdown-preview.nvim)**: Markdown 文件的实时预览。
*   **[neo-tree.filesystem](https://github.com/nvim-neo-tree/neo-tree.filesystem)**: 一个文件浏览器。
*   **[nvim-notify](https://github.com/rcarriga/nvim-notify)**: 一个美观的通知管理器。
*   **[nvim-rooter.lua](https://github.com/notjedi/nvim-rooter.lua)**: 自动更改 Neovim 的工作目录到项目根目录。
*   **[toggleterm.nvim](https://github.com/akinsho/toggleterm.nvim)**: 一个易于使用的终端管理器。
*   **[tokyonight.nvim](https://github.com/folke/tokyonight.nvim)**: 一个流行的深色主题。
*   **[nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter)**: 用于语法高亮、缩进等的树形解析器。
*   **[vim-fugitive](https://github.com/tpope/vim-fugitive)**: 一个强大的 Git 包装器。
*   **[vim-visual-multi](https://github.com/mg979/vim-visual-multi)**: 多个光标和选择。
*   **[which-key.nvim](https://github.com/folke/which-key.nvim)**: 在您键入时显示可用的键绑定。

## 🎨 主题

默认使用 Tokyo Night 主题，可以在 `init.lua` 中切换到 Gruvbox：

```lua
-- vim.cmd.colorscheme("tokyonight-night") -- 默认主题
vim.cmd.colorscheme("gruvbox") -- 替代主题
```

## 🔧 自定义配置

你可以通过修改 `lua/configs` 目录下的文件来自定义配置：

- `basic.lua`: 基础设置
- `keymaps.lua`: 快捷键映射
- `lazy.lua`: 插件管理配置

## 📝 许可证

此配置基于 MIT 许可证开源。

## 🤝 贡献

欢迎提交 Issue 和 Pull Request！

---

## 出现问题解决

[chatgpt](https://chatgpt.com/c/67eb9e10-08d0-800d-bd6c-f08ffed1a384)

⭐️ 如果这个配置对你有帮助，请给它一个星标！

