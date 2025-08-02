# macOS Neovim 配置指南

本文档专门针对 macOS 用户，提供完整的 Neovim 配置和常见问题解决方案。

## 🍎 macOS 特定要求

### 系统要求
- macOS 10.15 (Catalina) 或更高版本
- Homebrew 包管理器
- Xcode Command Line Tools

### 安装 Homebrew (如果尚未安装)

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

## 📦 安装 Neovim

### 使用 Homebrew 安装

```bash
# 安装最新稳定版
brew install neovim

# 或安装开发版本（更多功能但可能不稳定）
brew install --HEAD neovim
```

### 验证安装

```bash
nvim --version
```

应该显示 Neovim 版本信息，推荐使用 0.9.0 或更高版本。

## ⚙️ 环境配置

### 1. Shell 配置

macOS 默认使用 Zsh，需要在 `~/.zshrc` 中添加环境变量：

```bash
# 设置默认编辑器
export EDITOR=nvim
export VISUAL=nvim

# 如果使用代理，可能需要设置
# export https_proxy=http://127.0.0.1:7890
# export http_proxy=http://127.0.0.1:7890
```

### 2. Git 配置

```bash
# 设置 Git 使用 neovim 作为编辑器
git config --global core.editor nvim

# 设置用户信息（如果尚未设置）
git config --global user.name "Your Name"
git config --global user.email "your.email@example.com"
```

### 3. 字体安装

安装 Nerd Font 字体以正确显示图标：

```bash
# 安装字体
brew tap homebrew/cask-fonts
brew install font-fira-code-nerd-font

# 或安装其他 Nerd Font
brew install font-jetbrains-mono-nerd-font
brew install font-meslo-lg-nerd-font
```

安装后在终端应用中设置字体为安装的 Nerd Font。

## 🔧 配置安装

### 1. 备份现有配置

```bash
# 如果已有配置，先备份
[ -d ~/.config/nvim ] && mv ~/.config/nvim ~/.config/nvim.backup.$(date +%Y%m%d)
```

### 2. 克隆配置

```bash
# 创建配置目录
mkdir -p ~/.config

# 克隆此配置（替换为实际的仓库地址）
git clone https://github.com/yourusername/nvim-config.git ~/.config/nvim
```

### 3. 首次启动

```bash
nvim
```

首次启动时，lazy.nvim 会自动下载和安装所有插件，请耐心等待。

## 🛠️ macOS 特定优化

### Terminal.app 优化

如果使用系统自带的 Terminal.app：

1. 打开 Terminal → 偏好设置 → 描述文件
2. 选择或创建新的描述文件
3. 设置字体为 Nerd Font
4. 启用 "使用 Option 作为 Meta 键"
5. 设置颜色方案（推荐 Pro 或自定义暗色主题）

### iTerm2 优化

如果使用 iTerm2（推荐）：

```bash
# 安装 iTerm2
brew install --cask iterm2
```

配置建议：
1. 设置字体为 Nerd Font
2. 启用 "Natural Text Editing"
3. 设置颜色方案（可导入 Tokyo Night 或 Gruvbox 配色）
4. 启用 "Applications in terminal may access clipboard"

### 快捷键冲突解决

macOS 的一些系统快捷键可能与 Neovim 冲突：

```bash
# 在 ~/.zshrc 中添加别名来避免冲突
alias vim=nvim
alias vi=nvim

# 如果需要使用系统 vim，可以用完整路径
# /usr/bin/vim
```

## 🚨 常见问题

### 1. Python Provider 警告

```bash
# 安装 Python provider
pip3 install pynvim

# 或使用 Homebrew
brew install python3
pip3 install --user pynvim
```

### 2. Node.js Provider 警告

```bash
# 安装 Node.js
brew install node

# 安装 neovim npm 包
npm install -g neovim
```

### 3. Ruby Provider 警告

```bash
# 安装 Ruby gem
gem install neovim
```

### 4. Clipboard 支持

macOS 默认支持系统剪贴板，如果有问题：

```bash
# 确保 pbcopy 和 pbpaste 可用
which pbcopy pbpaste

# 在配置中使用
vim.opt.clipboard = "unnamedplus"
```

### 5. 权限问题

如果遇到权限问题：

```bash
# 确保目录权限正确
chmod -R 755 ~/.config/nvim

# 如果使用 brew 安装的工具有权限问题
sudo chown -R $(whoami) $(brew --prefix)/*
```

## 🔍 性能优化

### LazyGit 集成

```bash
# 安装 lazygit
brew install lazygit
```

### ripgrep 和 fd 安装

```bash
# 安装更快的搜索工具
brew install ripgrep fd
```

### 树形目录显示

```bash
# 安装 tree 命令（可选）
brew install tree
```

## 📱 移动设备集成

### SSH 连接优化

如果需要通过 SSH 远程使用：

```bash
# 在 ~/.ssh/config 中添加
Host *
    ForwardAgent yes
    AddKeysToAgent yes
    UseKeychain yes
```

## 🔄 更新和维护

### 更新 Neovim

```bash
brew update && brew upgrade neovim
```

### 更新配置

```bash
cd ~/.config/nvim
git pull origin main
```

### 插件管理

在 Neovim 中：
- `:Lazy` - 打开插件管理器
- `:Lazy update` - 更新所有插件
- `:Lazy sync` - 同步插件状态

### 健康检查

```bash
# 在 Neovim 中运行健康检查
:checkhealth
```

这会显示所有组件的状态，帮助诊断问题。

## 📞 支持

如果遇到问题：

1. 首先运行 `:checkhealth` 诊断
2. 查看 `docs/error.md` 了解常见错误解决方案
3. 检查 GitHub Issues
4. 重新安装配置作为最后手段

---

*macOS 是苹果公司的商标。本文档非苹果公司官方文档。*