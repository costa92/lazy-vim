# Vim-Fugitive Git 命令详解

[vim-fugitive](https://github.com/tpope/vim-fugitive) 是 Vim/Neovim 中最强大的 Git 集成插件，提供了丰富的 Git 操作功能。本文档详细介绍其中的冲突解决相关命令。

## 安装 vim-fugitive

在 Neovim 的 lazy.lua 配置文件中添加：

```lua
{
  "tpope/vim-fugitive",
  cmd = { "Git", "G", "Gvdiffsplit" },
  dependencies = {
    "tpope/vim-rhubarb", -- 用于 GitHub 集成
  },
}
```

## 冲突解决命令

### Gvdiffsplit

`:Gvdiffsplit` 或 `:Gvdiffsplit!` 命令用于处理合并冲突，它会打开一个三向差异视图：

```
+-----------------+-------------------+------------------+
| LOCAL (本地版本) | BASE (共同祖先版本) | REMOTE (远程版本) |
+-----------------+-------------------+------------------+
```

- 左侧 (//2): 本地版本（你的更改）
- 中间: 合并结果（当前文件）
- 右侧 (//3): 远程版本（传入的更改）

#### 用法

1. 当发生合并冲突时，打开冲突文件
2. 执行 `:Gvdiffsplit!` 命令
3. 使用 `:diffget` 命令选择要保留的更改：
   - `:diffget //2` - 选择左侧（本地）版本
   - `:diffget //3` - 选择右侧（远程）版本
   
### 冲突导航

在差异视图中，你可以使用以下命令在冲突点之间导航：

- `]c` - 跳转到下一个冲突点/差异
- `[c` - 跳转到上一个冲突点/差异

### 解决冲突

1. **部分合并**：可以在中间窗口手动编辑最终结果
2. **选择一侧**：
   - 光标在中间窗口，执行 `:diffget //2` 获取左侧（本地）的更改
   - 光标在中间窗口，执行 `:diffget //3` 获取右侧（远程）的更改

3. **保存结果**：
   - `:w` - 保存当前文件
   - `:Gwrite` - 保存并将文件标记为已解决

### 有用的别名设置

可以在 Neovim 配置中添加以下快捷键，方便冲突解决：

```lua
-- 冲突解决快捷键
vim.api.nvim_set_keymap('n', '<leader>gd', ':Gvdiffsplit!<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', 'gdh', ':diffget //2<CR>', { noremap = true, silent = true }) -- 获取左侧版本 (本地)
vim.api.nvim_set_keymap('n', 'gdl', ':diffget //3<CR>', { noremap = true, silent = true }) -- 获取右侧版本 (远程)
vim.api.nvim_set_keymap('n', ']c', ']c', { noremap = true, silent = true }) -- 下一个冲突
vim.api.nvim_set_keymap('n', '[c', '[c', { noremap = true, silent = true }) -- 上一个冲突
```

## 其他有用的 Fugitive 命令

| 命令 | 功能 |
|------|------|
| `:Git` 或 `:G` | 打开 Git 状态窗口 |
| `:G blame` | 显示文件的 Git blame 信息 |
| `:G log` | 显示仓库日志 |
| `:G commit` | 提交更改 |
| `:G push` | 推送更改 |
| `:G pull` | 拉取更改 |
| `:G checkout branch_name` | 切换分支 |
| `:G mergetool` | 打开外部合并工具 |

## 建议安装的配套插件

1. **vim-rhubarb** - GitHub 集成
2. **vim-gitgutter** 或 **gitsigns.nvim** - 在行号旁显示 Git 更改
3. **diffview.nvim** - 提供更现代化的差异视图界面

这些工具结合使用，可以让你在 Neovim 中拥有近乎完整的 Git 工作流。 