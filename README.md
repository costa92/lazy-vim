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

## 出现问题解决

[chatgpt](https://chatgpt.com/c/67eb9e10-08d0-800d-bd6c-f08ffed1a384)

⭐️ 如果这个配置对你有帮助，请给它一个星标！
