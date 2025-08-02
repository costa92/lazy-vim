# Neovim Configuration

这是一个现代化的 Neovim 配置，使用 [lazy.nvim](https://github.com/folke/lazy.nvim) 作为插件管理器，提供了丰富的功能和优雅的界面。

## ✨ 特性

- 🚀 使用 lazy.nvim 进行插件管理
- 🎨 默认使用 Tokyo Night 主题（可切换到 Gruvbox）
- 📝 完整的 LSP 支持
- 🔍 模糊搜索（FZF）
- 🌲 语法高亮（Treesitter）
- ⌨️ 智能代码补全（nvim-cmp）
- 📦 Git 集成（gitsigns）
- 💡 Which-key 快捷键提示
- 🔧 代码格式化（conform.nvim）
- 💬 注释支持
- 📊 状态栏美化（lualine）
- 🎯 缩进指示线
- �� 通知系统
- 🚦 终端集成

## ⌨️ 快捷键

### 基础操作

- `<Space>` - Leader 键
- `\` - Local Leader 键
- `<C-s>` - 保存文件
- `<C-q>` - 退出
- `<ESC>` - 清除搜索高亮
- `<S-n>` - 切换行号显示

### 窗口管理

- `sv` - 垂直分屏
- `sh` - 水平分屏
- `sc` - 关闭当前窗口
- `so` - 关闭其他窗口
- `<C-h>` - 切换到左窗口
- `<C-j>` - 切换到下窗口
- `<C-k>` - 切换到上窗口
- `<C-l>` - 切换到右窗口

### 文本编辑

- `<Space>i` - 格式化整个文件
- `j` (在可视模式) - 向下移动选中文本
- `K` (在普通/插入模式) - 向上移动选中文本
- `<C-h>` (在插入模式) - 跳到行首
- `<C-l>` (在插入模式) - 跳到行尾

### 文件浏览和搜索 (FZF)

- `<C-e>` - 显示缓冲区列表
- `<leader>r` - 最近使用的文件
- `<leader>s` - Treesitter 符号搜索
- `<leader>f` - 全局文本搜索
- `<leader>h` - 搜索历史
- `<leader>m` - 显示标记列表
- `<C-f>` - 当前文件内搜索

### Git 操作

- `<leader>gp` - Git 提交历史
- `<leader>gb` - 当前文件的 Git 历史
- `<leader>gs` - Git 状态
- `<leader>b` - 切换 Git blame 显示

### LSP 相关

- `gd` - 跳转到定义
- `gr` - 查看引用
- `gi` - 跳转到实现
- `K` - 显示悬浮文档
- `<leader>rn` - 重命名

### Go 开发

- `<leader>fe` - 插入错误处理
- `<leader>fs` - 填充结构体
- `<leader>fc` - 填充 switch 语句
- `<leader>ta` - 添加标签
- `<leader>tr` - 移除标签
- `<leader>tc` - 清除所有标签

### 终端

- `<C-\>` - 切换浮动终端

### 其他功能

- `<leader>il` - 切换缩进指示线
- `<leader>?` - 显示当前缓冲区的快捷键

### 文件树 (Neo-tree)

- `<C-b>` - 打开/关闭文件树
- `<leader>e` - 在文件树中定位当前文件

#### 文件树内快捷键

- `<space>` - 展开/折叠节点
- `<cr>` 或 `<2-LeftMouse>` - 打开文件
- `P` - 切换预览
- `S` - 在新窗口中打开
- `s` - 在垂直分屏中打开
- `t` - 在新标签页中打开
- `w` - 使用窗口选择器打开
- `C` - 关闭节点
- `z` - 关闭所有节点
- `a` - 添加文件
- `A` - 添加目录
- `d` - 删除
- `r` - 重命名
- `y` - 复制到剪贴板
- `x` - 剪切到剪贴板
- `p` - 从剪贴板粘贴
- `c` - 复制
- `m` - 移动
- `q` - 关闭窗口
- `R` - 刷新
- `?` - 显示帮助

## 📦 安装要求

### 基础要求
- **Neovim >= 0.9.0** (推荐 0.10.0+)
- **Git** >= 2.25.0
- **一个 Nerd Font 字体**（用于图标显示）

### macOS 特定要求
- macOS 10.15 (Catalina) 或更高版本
- Homebrew 包管理器
- Xcode Command Line Tools

### 可选依赖
- **Node.js** (用于某些 LSP 服务器)
- **Python 3** (用于 Python 支持)
- **ripgrep** (更快的文本搜索)
- **fd** (更快的文件查找)
- **lazygit** (Git TUI 界面)

## 🛠️ 安装步骤

### 基础安装

1. **安装 Neovim** (macOS 用户)：
   ```bash
   brew install neovim
   ```

2. **备份现有配置**（如果有的话）：
   ```bash
   [ -d ~/.config/nvim ] && mv ~/.config/nvim ~/.config/nvim.backup.$(date +%Y%m%d)
   ```

3. **克隆此配置**：
   ```bash
   git clone https://github.com/yourusername/nvim-config.git ~/.config/nvim
   ```

4. **设置环境变量** (macOS/Linux)：
   ```bash
   echo 'export EDITOR=nvim' >> ~/.zshrc  # 或 ~/.bashrc
   echo 'export VISUAL=nvim' >> ~/.zshrc
   source ~/.zshrc
   ```

5. **配置 Git 编辑器**：
   ```bash
   git config --global core.editor nvim
   ```

6. **安装字体** (macOS)：
   ```bash
   brew tap homebrew/cask-fonts
   brew install font-fira-code-nerd-font
   ```

7. **启动 Neovim**，插件将自动安装：
   ```bash
   nvim
   ```

### 快速验证

安装完成后，运行以下命令验证配置：

```bash
# 检查 Neovim 版本
nvim --version

# 检查环境变量
echo $EDITOR

# 检查 Git 配置
git config --global core.editor

# 运行健康检查
nvim -c ":checkhealth" -c ":q"
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

## 🔌 包含的主要插件

- LSP 支持
- 代码补全
- 文件查找
- Git 集成
- Markdown 预览
- 终端集成
- 通知系统
- 等等...

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

## 📋 文档目录

- [📄 错误解决方案](docs/error.md) - 常见错误和解决方法
- [🍎 macOS 设置指南](docs/macos-setup.md) - macOS 专用配置指南
- [🌲 文件树快捷键](docs/neo-tree-keymaps.md) - Neo-tree 详细操作
- [🔍 搜索命令](docs/search-commands.md) - FZF 搜索功能
- [📝 可视模式](docs/nvim-visual-mode.md) - 可视模式操作
- [📁 文件导航](docs/file-navigation.md) - 文件导航技巧
- [🔀 Git 操作](docs/git-fugitive-commands.md) - Git Fugitive 命令

## 🚨 故障排除

### 常见问题快速解决

#### 1. Git Commit 编辑器错误
```bash
# 设置 nvim 为 Git 编辑器
git config --global core.editor nvim
export EDITOR=nvim
```

#### 2. 插件加载失败
```bash
# 清除插件缓存重新安装
rm -rf ~/.local/share/nvim/lazy
nvim
```

#### 3. LSP 服务器无响应
```bash
# 检查 LSP 状态
nvim -c ":LspInfo" -c ":q"
```

#### 4. 字体图标显示异常
确保终端字体设置为 Nerd Font，如 "FiraCode Nerd Font"。

#### 5. 性能问题
```bash
# 运行健康检查
nvim -c ":checkhealth" -c ":q"

# 查看启动时间
nvim --startuptime startup.log
```

### 获取帮助

1. **查看文档**: 详细问题请查看 `docs/` 目录下的相关文档
2. **健康检查**: 在 Neovim 中运行 `:checkhealth`
3. **重置配置**: 备份并重新克隆配置作为最后手段

更多详细信息请参考: [错误解决文档](docs/error.md)

⭐️ 如果这个配置对你有帮助，请给它一个星标！

