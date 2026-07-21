# TypeScript / Vue LSP：从 ts_ls 迁移到 vtsls + vue_ls

> 本文原为 `ts_ls` 的 `root_dir` 崩溃修复记录（2025-10-29）。该问题与该服务器均已不再适用，
> 原内容整体作废，见下方「历史问题的现状」。

## 当前方案

| 文件类型 | 承载服务器 |
|---|---|
| `.ts` / `.js` / `.tsx` / `.jsx` | `vtsls` |
| `.vue` | `vue_ls` + `vtsls` |

- `lua/lsp/vtsls.lua` —— vtsls 配置，含 `@vue/typescript-plugin`
- `vue_ls` 无自定义配置文件，直接用 nvim-lspconfig 自带默认值
- 两者都在 `lua/plugins/lsp.lua` 的 `servers` 列表里

### 为什么必须是两个服务器

`vue_ls` 自 v3.0.0 起**取消 takeover mode**，只负责 template / CSS 部分。`.vue` 的
`<script>` 里的 TS 请求由它转发给一个 TS 服务器处理。因此：

- `vtsls` 的 `filetypes` 必须包含 `vue`
- `@vue/typescript-plugin` 的 `languages` 也必须包含 `vue`（即使 filetypes 里已有）
- 插件的 `location` 指向 mason 装的 `@vue/language-server` 包目录

缺任何一项，`.vue` 里按 `gd` 都会报
`method "textDocument/definition" is not supported by any server activated for this buffer`。

### 硬约束：vtsls 与 ts_ls 不可共存

nvim-lspconfig 的 `lsp/vtsls.lua` 明确写着 *"It is not recommended to enable both `vtsls`
and `ts_ls` at the same time"*。故 `lua/lsp/ts_ls.lua` 已删除，`plugins/lsp.lua` 与
mason-lspconfig 的 `ensure_installed` 里也都不再有 `ts_ls`。

注意 mason-lspconfig 的 `automatic_enable` 默认为 `true`，会把**所有已安装**的服务器
自动 enable —— 只要 `typescript-language-server` 这个包还在，ts_ls 就会被悄悄拉起来和
vtsls 打架。`plugins/mason.lua` 里已显式设为 `false`。

## 依赖安装

```vim
:MasonInstall vtsls vue-language-server
```

两者也在 `plugins/mason.lua` 的 mason-lspconfig `ensure_installed` 列表里，会自动安装。

## 历史问题的现状

原记录的问题是 nvim-lspconfig 的 `lsp/ts_ls.lua` 把 `root_markers` 写成嵌套表：

```lua
root_markers = vim.fn.has('nvim-0.11.3') == 1 and { root_markers, { '.git' } } or ...
```

在 Neovim 0.12.0-dev 上导致 `vim/fs.lua: invalid value (table) at index 2 in table for 'concat'`。

**该问题在 Neovim 0.12.1 上已不复现** —— 嵌套表是 `vim.fs.root()` 的优先级分组语法，
上游已正常支持：

```vim
:lua =vim.fs.root(vim.fn.getcwd(), { { "package-lock.json" }, { ".git" } })
```

返回正常路径而非报错。因此 `lua/lsp/vtsls.lua` **没有**重写 `root_dir`，直接使用
nvim-lspconfig 自带的实现（它还带有 Deno 项目排除逻辑，手写覆盖反而会丢掉）。

## 验证

打开一个 `.vue` 文件后：

```vim
:lua =vim.tbl_map(function(c) return c.name end, vim.lsp.get_clients({ bufnr = 0 }))
```

应返回 `{ "vtsls", "vue_ls" }`。若只有 `vue_ls`，说明 vtsls 没附着，检查 `filetypes`
是否包含 `vue`；若两个都没有，检查 `plugins/lsp.lua` 的 `config` 是否真的被执行
（见 `CLAUDE.md` 里关于 lazy spec 片段 `config` 字段互相覆盖的说明）。

## 相关文件

- `lua/lsp/vtsls.lua` —— vtsls 配置
- `lua/plugins/lsp.lua` —— 服务器列表与统一 setup
- `lua/plugins/mason.lua` —— `automatic_enable = false` 与安装列表
- `docs/gopls-fix.md` —— 另一个 LSP 专项排查记录

## 更新日期

2026-07-21
