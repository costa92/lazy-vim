

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