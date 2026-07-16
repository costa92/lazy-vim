# ts_ls 配置修复说明

## 问题描述

在使用 Neovim 0.12.0-dev 版本时,打开 TypeScript/JavaScript 文件会出现以下错误:

```
Error executing lua callback: vim/fs.lua:0: invalid value (table) at index 2 in table for 'concat'
```

## 根本原因

这是 **nvim-lspconfig** 插件的一个 bug,位于文件:

```
/home/hellotalk/.local/share/nvim/lazy/nvim-lspconfig/lsp/ts_ls.lua
```

原始代码(第 61-64 行):

```lua
local root_markers = { 'package-lock.json', 'yarn.lock', 'pnpm-lock.yaml', 'bun.lockb', 'bun.lock' }
root_markers = vim.fn.has('nvim-0.11.3') == 1 and { root_markers, { '.git' } }
  or vim.list_extend(root_markers, { '.git' })
```

在 Neovim 0.12.0-dev 中,`vim.fn.has('nvim-0.11.3')` 返回 true,导致 `root_markers` 变成嵌套表:

```lua
{ { 'package-lock.json', ... }, { '.git' } }  -- 嵌套表
```

但 `vim.fs.root()` 期望的是扁平的字符串列表:

```lua
{ 'package-lock.json', 'yarn.lock', ..., '.git' }  -- 扁平列表
```

## 解决方案

### 方法 1: 修复 nvim-lspconfig 插件源码(可选,改动仓库外的插件文件)

直接修改 nvim-lspconfig 插件文件:

```
/home/hellotalk/.local/share/nvim/lazy/nvim-lspconfig/lsp/ts_ls.lua
```

将第 61-64 行替换为:

```lua
-- FIX: 扁平化 root_markers 以避免嵌套表导致的 vim.fs.root() 错误
local root_markers = { 'package-lock.json', 'yarn.lock', 'pnpm-lock.yaml', 'bun.lockb', 'bun.lock', '.git' }
```

备份文件保存在:

```
/home/hellotalk/.local/share/nvim/lazy/nvim-lspconfig/lsp/ts_ls.lua.bak
```

### 方法 2: 在自定义配置中覆盖(本仓库实际采用)

本仓库当前生效的就是这一方案 —— `lua/lsp/ts_ls.lua` 里已通过 `root_dir` 回调用扁平化的 `root_markers` 覆盖，随仓库一起版本管理，不受插件更新影响。方法 1 改动的是 `~/.local/share/nvim/lazy/...` 下的插件文件（仓库外，未纳入版本管理，本文无法核实是否仍处于已打补丁状态）。

在 `lua/lsp/ts_ls.lua` 中覆盖 `root_dir` 配置:

```lua
return function(setup_server)
  setup_server("ts_ls", {
    root_dir = function(bufnr, on_dir)
      local root_markers = {
        'package-lock.json',
        'yarn.lock',
        'pnpm-lock.yaml',
        'bun.lockb',
        'bun.lock',
        '.git'
      }
      local project_root = vim.fs.root(bufnr, root_markers) or vim.fn.getcwd()
      on_dir(project_root)
    end,
    settings = {
      -- ... 其他设置
    }
  })
end
```

## 注意事项

1. **插件更新**: 当 nvim-lspconfig 更新时,修改可能会被覆盖,需要重新应用修复
2. **上游修复**: 这个 bug 应该会在 nvim-lspconfig 的未来版本中修复
3. **监控**: 定期检查 nvim-lspconfig 的更新日志

## 验证修复

重启 Neovim 后,尝试打开任何 `.ts` 或 `.js` 文件,应该不再出现错误。

## 相关文件

- `/home/hellotalk/.config/nvim/lua/lsp/ts_ls.lua` - 自定义 ts_ls 配置
- `/home/hellotalk/.config/nvim/lua/plugins/lsp.lua` - LSP 主配置
- `/home/hellotalk/.local/share/nvim/lazy/nvim-lspconfig/lsp/ts_ls.lua` - 插件源文件(已修复)
- `/home/hellotalk/.local/share/nvim/lazy/nvim-lspconfig/lsp/ts_ls.lua.bak` - 原始备份

## 更新日期

2025-10-29
