# 字体与插件指南

本文档讲两件事：① 让 Nerd Font 图标正常显示（终端选字体 + 验证 + 换风格）；② 在本配置里增删、更新、排错插件。

安装依赖本身见 [`install.md`](./install.md) 的「分平台安装依赖」。

---

# 一、字体

Neovim 本身不渲染字体——图标由**终端的字体**决定。必须把终端字体设成一款 **Nerd Font**（内嵌了图标字形），否则 neo-tree、lualine、bufferline、诊断符号等处会显示成乱码方块 `▯`。

## 1. 各终端如何选字体

装好 Nerd Font 后（见 install.md），在**终端**里设置，不是在 nvim 里：

| 终端 | 设置方式 |
|------|----------|
| **iTerm2**（mac） | Settings → Profiles → Text → Font，选 `JetBrainsMono Nerd Font` |
| **Alacritty** | 编辑 `~/.config/alacritty/alacritty.toml`（见下） |
| **kitty** | 编辑 `~/.config/kitty/kitty.conf`：`font_family JetBrainsMono Nerd Font` |
| **WezTerm** | `~/.wezterm.lua`：`font = wezterm.font('JetBrainsMono Nerd Font')` |
| **GNOME Terminal**（Linux） | Preferences → 选中 Profile → Text → Custom font，选 Nerd Font |
| **Windows Terminal** | Settings → Profile → Appearance → Font face |

Alacritty 示例：

```toml
[font.normal]
family = "JetBrainsMono Nerd Font"
style = "Regular"

[font]
size = 13.0
```

> 名字要用**字体全名**（含 `Nerd Font`）。装完若列表里搜不到，Linux 上跑 `fc-list | grep -i nerd` 确认已被系统识别；mac 上在「字体册」里搜一下。

## 2. 验证图标是否生效

1. 重启终端，进 `nvim`，按 `<C-b>` 打开 neo-tree —— 文件/文件夹前应有彩色图标，而不是方块。
2. 底部 lualine、顶部 bufferline 的图标应正常。
3. 终端里直接测字形（不进 nvim）：

   ```bash
   echo -e "   "   # 文件夹 / nvim / GitHub 猫 / git 分支
   ```

   显示成四个图标 = 字体 OK；显示成方块/问号 = 终端字体还没切到 Nerd Font。
4. `:checkhealth` 里各插件段落若提示图标相关警告，一般也是字体没配好。

## 3. 换字体 / 调图标风格

- **换字体**：任选一款 Nerd Font 重复上面的安装+设置即可。常用：`JetBrainsMono`、`FiraCode`（带连字）、`Hack`、`CaskaydiaCove`(Cascadia)、`Meslo`。字号建议 12–14。
- **文件类型图标**来自 `nvim-web-devicons`（被 neo-tree / bufferline / fzf 等作为依赖引入），一般无需改。
- **配置里各处图标**是硬编码的，想换符号去对应文件改：

  | 图标 | 位置 |
  |------|------|
  | `:Lazy` 面板图标（ft / lazy / loaded…） | `lua/configs/lazy.lua` 的 `ui.icons` |
  | Mason 安装状态 `✓ → ✗` | `lua/plugins/mason.lua` 的 `ui.icons` |
  | Git 改动标记 `│ _ ‾ ~ ┆` | `lua/plugins/gitsigns.lua` 的 `signs` |
  | 诊断符号 `✘ ▲ ⚑ »` | `lua/plugins/diagnostics.lua` 的 `signs.text` |
  | 文件树图标 | `lua/plugins/neo-tree.lua` |
  | 标签栏 / 状态栏图标 | `lua/plugins/bufferline.lua`、`lua/plugins/lualine.lua` |

  > 改插件文件后要**完全退出重启**（`:qa`）才生效，`:source` / `:Lazy reload` 不行。

---

# 二、插件

插件由 [`lazy.nvim`](https://github.com/folke/lazy.nvim) 管理。本配置有一套**必须遵守的约定**，否则插件会在启动时被急加载、拖慢启动。

## 1. 新增插件

两步：

**① 建插件文件** `lua/plugins/<name>.lua`，返回一个 lazy spec 表，**把懒加载触发器写在表里面**：

```lua
-- lua/plugins/example.lua
return {
  "author/example.nvim",
  event = "VeryLazy",          -- 触发器写在这里！
  opts = {
    -- 插件配置
  },
}
```

**② 在 `lua/configs/lazy.lua` 的 `spec` 里加一行 import**（只写 import，**不带触发器**）：

```lua
{ import = "plugins/example" },
```

按角色选触发器（写在插件文件内）：

| 插件类型 | 触发器 |
|----------|--------|
| UI 类 | `event = "VeryLazy"` |
| LSP / 依赖打开文件 | `event = { "BufReadPre", "BufNewFile" }` |
| 某语言专用 | `ft = "go"` |
| 命令驱动 | `cmd = "XxxCommand"` |
| 快捷键驱动 | `keys = { "<leader>x" }` |

> ⚠️ **最容易踩的坑**：触发器**必须写在插件文件的 spec 里**，写在 `lazy.lua` 的 `{ import = ..., event = ... }` 那行上会被**静默忽略**，插件会退化成 `lazy = false` 在**启动时急加载**。这批插件历史上全踩过（neo-tree、lsp、mason 等）。`lazy.lua` import 行上任何残留的触发器都是失效的遗留，不要依赖。

其他约定：

- `opts = {...}` 和 `config = function() ... end` **二选一**，不要同时写（有 `config` 时 `opts` 被忽略）。
- 除非确实要启动即加载（如主题、treesitter），**不要**在插件文件里写 `lazy = false`（它会覆盖你的触发器）。
- 加完必须 `:qa` 重启，再 `:Lazy`，新插件会自动下载。

## 2. 删除插件

1. 删掉 `lua/plugins/<name>.lua`；
2. 删掉 `lua/configs/lazy.lua` 里对应的 `{ import = "plugins/<name>" }` 行；
3. `:qa` 重启后 `:Lazy clean` 清理已下载但不再引用的插件目录。

## 3. 更新 / 同步插件

本配置**关闭了自动更新检查**（`lazy.lua` 里 `checker.enabled = false`），升级全靠手动：

```vim
:Lazy sync            " 一键：装缺失 + 更新 + 清理，并写回 lazy-lock.json
:Lazy update          " 只更新（会刷新 lazy-lock.json）
:Lazy update <name>   " 只更新某个插件
:Lazy restore         " 回滚到 lazy-lock.json 锁定的版本
```

- **`lazy-lock.json`** 记录每个插件的确切 commit，已纳入版本管理。换机器时 `git clone` + `nvim` 会按锁文件装一致的版本。
- 更新后若某插件出问题，`:Lazy restore` 回滚；确认没问题再 `git add lazy-lock.json` 提交锁文件。

命令行一键同步（不进交互界面）：

```bash
nvim +":Lazy sync" +qa
```

## 4. 禁用 / 排错插件

**临时禁用**某个插件：在它的 spec 里加 `enabled = false`（或注释掉 `lazy.lua` 里的 import 行），`:qa` 重启。

```lua
return {
  "author/example.nvim",
  enabled = false,   -- 临时关掉
  ...
}
```

**排错常用**：

```vim
:Lazy               " 面板：看每个插件是否已加载（● = loaded）、有无报错
:Lazy profile       " 启动耗时分析，找拖慢启动的插件
:Lazy log <name>    " 看某插件最近的更新提交
:messages           " 看启动/加载期间的报错
:checkhealth lazy   " lazy 自身健康检查
```

**查哪些插件在启动时被急加载**（应当很少，只有主题、treesitter、rooter 等）：

```vim
:lua for n,p in pairs(require("lazy.core.config").plugins) do if p.lazy==false then print(n) end end
```

如果这里冒出本该懒加载的插件，八成是上面「新增插件」那个坑——触发器被写到了 import 行上而失效。把触发器挪回插件文件内即可。

> 记住：**懒加载插件的配置只在启动时应用**。任何 `lua/plugins/*.lua` 的改动都要**完全退出**（`:qa`）再启动，别用 `:source` 或 `:Lazy reload`。

---

## 参考

- 安装与系统依赖：[`install.md`](./install.md)
- 架构、加载顺序与更多陷阱：[`../CLAUDE.md`](../CLAUDE.md)
