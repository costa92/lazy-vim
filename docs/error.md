

## 1. 错误信息

```sh

Perl provider (optional) ~
- ⚠️ WARNING "Neovim::Ext" cpan module is not installed
  - ADVICE:
    - See :help |provider-perl| for more information.
    - You can disable this provider (and warning) by adding `let g:loaded_perl_provider = 0` to your init.vim
- ⚠️ WARNING No usable perl executable found

Python 3 provider (optional) ~
```

###  解决：

如果你不需要 Perl 支持：

```lua
let g:loaded_perl_provider = 0
```


如果你需要 Perl 支持：
```sh
  sudo apt install perl cpanminus
  cpanm Neovim::Ext
```

##  2. WARNING latex2text: not installed

### 解决方法

**方案一：关闭 LaTeX 支持（推荐）**

如果你不需要在 markdown 里渲染 LaTeX 数学公式，直接在配置里禁用：

```lua
require('render-markdown').setup({
  latex = { enabled = false }
})
```

**方案二：安装 latex2text**

如果你需要 LaTeX 支持，可以安装 latex2text

Debian/Ubuntu:

```sh
sudo apt install latex2text
```

macOS (Homebrew):


```sh
brew install latex2text
```

或用 pip（有些系统也支持）：

```sh
pip install latex2text
```

## 3. Git Commit Amend 错误

### 错误信息

```
git commit --amend
hint: Waiting for your editor to close the file... E1187: Failed to source defaults.vim
Error detected while processing /opt/homebrew/Cellar/neovim/0.11.3/share/nvim/runtime/plugin/matchparen.vim:
line   10:
E15: Invalid expression: "exists("g:loaded_matchparen") || &cp ||"
line   11:
E10: \ should be followed by /, ? or &
Error detected while processing .../rplugin.vim[68]..function <SNR>6_LoadRemotePlugins[1]..<SNR>6_GetManifest[1]..<SNR>6_GetManifestPath:
line    7:
E117: Unknown function: stdpath
```

### 问题原因

这个错误不是 nvim 配置问题，而是 **Git 编辑器配置问题**：
- Git 使用传统的 `vim` 而不是 `nvim`
- 传统 vim 试图加载 nvim 的运行时文件，导致兼容性错误
- 环境变量 `$EDITOR` 未正确设置

### 解决方案

#### 1. 设置 Git 使用 nvim 作为编辑器

```bash
git config --global core.editor nvim
```

#### 2. 设置环境变量

```bash
# 添加到 ~/.zshrc (macOS 默认使用 zsh)
echo 'export EDITOR=nvim' >> ~/.zshrc

# 在当前会话中生效
export EDITOR=nvim
```

#### 3. 验证设置

```bash
# 检查 git 编辑器配置
git config --global core.editor

# 检查环境变量
echo $EDITOR

# 测试功能
git commit --amend --no-edit
```

#### 4. 重启终端

重启终端或执行 `source ~/.zshrc` 使环境变量永久生效。

### 配置文件兼容性优化

如果仍有问题，可在 `lua/configs/basic.lua` 中添加兼容性设置：

```lua
-- 禁用可能导致问题的内置插件
vim.g.loaded_matchparen = 1        -- 禁用括号匹配高亮
vim.g.loaded_matchit = 1           -- 禁用matchit插件
vim.g.loaded_logiPat = 1           -- 禁用LogiPat插件
```