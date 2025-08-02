# Neovim 配置优化指南

本文档包含了优化 Neovim 配置的最佳实践和性能调优建议。

## 🚀 性能优化

### 启动时间优化

#### 1. 插件延迟加载

使用 lazy.nvim 的延迟加载功能：

```lua
-- 示例：只在特定事件时加载插件
{
  "nvim-treesitter/nvim-treesitter",
  event = { "BufReadPost", "BufNewFile" },
  dependencies = {
    "nvim-treesitter/nvim-treesitter-textobjects",
  },
}
```

#### 2. 禁用不需要的内置插件

在 `lua/configs/basic.lua` 中：

```lua
-- 禁用不需要的内置插件
vim.g.loaded_gzip = 1
vim.g.loaded_zip = 1
vim.g.loaded_zipPlugin = 1
vim.g.loaded_tar = 1
vim.g.loaded_tarPlugin = 1
vim.g.loaded_getscript = 1
vim.g.loaded_getscriptPlugin = 1
vim.g.loaded_vimball = 1
vim.g.loaded_vimballPlugin = 1
vim.g.loaded_2html_plugin = 1
vim.g.loaded_matchit = 1
vim.g.loaded_matchparen = 1
vim.g.loaded_logiPat = 1
vim.g.loaded_rrhelper = 1
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.g.loaded_netrwSettings = 1
vim.g.loaded_netrwFileHandlers = 1
```

#### 3. 优化启动配置

```lua
-- 减少启动时的检查和设置
vim.opt.shadafile = "NONE"  -- 临时禁用 shada 文件
vim.cmd [[
  augroup RestoreShada
    autocmd!
    autocmd VimEnter * set shadafile& | rshada
  augroup END
]]
```

### 内存使用优化

#### 1. 合理设置历史记录

```lua
vim.opt.history = 1000          -- 命令行历史记录
vim.opt.undolevels = 1000       -- 撤销级别
vim.opt.updatetime = 300        -- 更新时间间隔
```

#### 2. 限制备份和交换文件

```lua
vim.opt.backup = false          -- 禁用备份文件
vim.opt.writebackup = false     -- 禁用写入备份
vim.opt.swapfile = false        -- 禁用交换文件
vim.opt.undofile = true         -- 启用持久化撤销文件
```

## 🔧 配置优化

### LSP 配置优化

#### 1. 按需启动 LSP 服务器

```lua
-- 只在相关文件类型时启动 LSP
local servers = {
  lua_ls = { "lua" },
  pyright = { "python" },
  gopls = { "go" },
  tsserver = { "typescript", "javascript" },
}

for server, filetypes in pairs(servers) do
  require('lspconfig')[server].setup({
    autostart = false,
    filetypes = filetypes,
  })
end
```

#### 2. 优化诊断设置

```lua
vim.diagnostic.config({
  virtual_text = {
    severity = { min = vim.diagnostic.severity.WARN },
  },
  signs = true,
  underline = true,
  update_in_insert = false,
  severity_sort = true,
})
```

### Treesitter 优化

#### 1. 按需安装解析器

```lua
require('nvim-treesitter.configs').setup({
  ensure_installed = {
    -- 只安装你需要的语言
    "lua", "vim", "go", "python", "javascript", "typescript"
  },
  auto_install = false,  -- 禁用自动安装
  sync_install = false,  -- 异步安装
})
```

#### 2. 禁用不需要的功能

```lua
require('nvim-treesitter.configs').setup({
  highlight = { enable = true },
  indent = { enable = false },  -- 如果有问题可以禁用
  incremental_selection = { enable = false },  -- 如果不使用可以禁用
})
```

## 🎯 用户体验优化

### 快捷键优化

#### 1. 减少按键次数

```lua
-- 更短的快捷键
vim.keymap.set('n', ';', ':', { desc = '命令模式' })
vim.keymap.set('n', '<leader>w', ':w<CR>', { desc = '保存文件' })
vim.keymap.set('n', '<leader>q', ':q<CR>', { desc = '退出' })
```

#### 2. 智能快捷键

```lua
-- 根据上下文自动选择功能
vim.keymap.set('n', '<leader>f', function()
  if vim.bo.filetype == 'help' then
    require('telescope.builtin').help_tags()
  else
    require('telescope.builtin').find_files()
  end
end, { desc = '智能查找' })
```

### 视觉优化

#### 1. 减少视觉干扰

```lua
vim.opt.showmode = false        -- 不显示模式（由状态栏显示）
vim.opt.showcmd = false         -- 不显示命令
vim.opt.ruler = false           -- 不显示标尺
vim.opt.laststatus = 3          -- 全局状态栏
```

#### 2. 优化颜色主题

```lua
-- 动态主题切换
local function set_theme_based_on_time()
  local hour = tonumber(os.date("%H"))
  if hour >= 6 and hour < 18 then
    vim.cmd.colorscheme("tokyonight-day")
  else
    vim.cmd.colorscheme("tokyonight-night")
  end
end

-- 启动时设置主题
set_theme_based_on_time()
```

## 🔍 调试和监控

### 性能分析

#### 1. 启动时间分析

```bash
# 生成启动时间报告
nvim --startuptime startup.log
```

#### 2. 插件加载时间

```lua
-- 在配置中添加计时器
local start_time = vim.loop.hrtime()

-- 配置代码...

vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    local end_time = vim.loop.hrtime()
    local duration = (end_time - start_time) / 1e6
    print(string.format("Neovim 启动时间: %.2f ms", duration))
  end,
})
```

### 健康检查自动化

```lua
-- 自动运行健康检查
vim.api.nvim_create_user_command('HealthCheck', function()
  vim.cmd('checkhealth')
end, {})

-- 启动时提醒健康检查（可选）
vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    vim.defer_fn(function()
      if math.random() < 0.1 then  -- 10% 概率提醒
        vim.notify("建议运行 :HealthCheck 检查配置状态", vim.log.levels.INFO)
      end
    end, 1000)
  end,
})
```

## 🛡️ 稳定性优化

### 错误处理

#### 1. 安全的配置加载

```lua
local function safe_require(module)
  local ok, result = pcall(require, module)
  if not ok then
    vim.notify(
      string.format("模块 %s 加载失败: %s", module, result),
      vim.log.levels.ERROR
    )
    return nil
  end
  return result
end

-- 使用示例
local telescope = safe_require("telescope")
if telescope then
  telescope.setup({})
end
```

#### 2. 自动备份配置

```lua
-- 定期备份重要配置
local function backup_config()
  local config_path = vim.fn.stdpath("config")
  local backup_path = config_path .. ".backup." .. os.date("%Y%m%d")

  vim.fn.system(string.format("cp -r %s %s", config_path, backup_path))
  vim.notify("配置已备份到: " .. backup_path, vim.log.levels.INFO)
end

-- 每周自动备份
vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    local last_backup = vim.g.last_config_backup or 0
    local now = os.time()

    if now - last_backup > 7 * 24 * 60 * 60 then  -- 7天
      backup_config()
      vim.g.last_config_backup = now
    end
  end,
})
```

## 📊 监控和统计

### 使用统计

```lua
-- 统计功能使用情况
local usage_stats = {}

local function track_usage(feature)
  usage_stats[feature] = (usage_stats[feature] or 0) + 1
end

-- 在退出时显示统计
vim.api.nvim_create_autocmd("VimLeavePre", {
  callback = function()
    if next(usage_stats) then
      print("功能使用统计:")
      for feature, count in pairs(usage_stats) do
        print(string.format("  %s: %d 次", feature, count))
      end
    end
  end,
})
```

## 🔄 配置版本管理

### Git 集成

```lua
-- 自动提交配置更改
vim.api.nvim_create_autocmd("BufWritePost", {
  pattern = vim.fn.stdpath("config") .. "/*",
  callback = function()
    vim.fn.system("cd " .. vim.fn.stdpath("config") .. " && git add . && git commit -m 'Auto-commit config changes'")
  end,
})
```

---

通过这些优化措施，你的 Neovim 配置将更加高效、稳定和用户友好。记住，优化是一个渐进的过程，根据你的实际使用情况进行调整。