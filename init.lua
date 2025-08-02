-- 错误处理函数
local function safe_require(module)
  local ok, err = pcall(require, module)
  if not ok then
    vim.notify("配置模块 " .. module .. " 加载失败: " .. err, vim.log.levels.ERROR)
    return false
  end
  return true
end

-- 安全加载配置模块
safe_require("configs.basic")    -- 加载全局配置
safe_require("configs.lazy")     -- 加载插件管理器
safe_require("configs.keymaps")  -- 加载全局快捷键

-- 必须设置在 init.lua 的最外层（非函数内部）
if vim.fn.has('termguicolors') == 1 then
  vim.opt.termguicolors = true -- 启用真彩色支持
end

vim.o.background = "dark" -- or "light" for light mode

-- 安全应用主题
local function safe_colorscheme(scheme)
  local ok, _ = pcall(vim.cmd.colorscheme, scheme)
  if not ok then
    vim.notify("主题 " .. scheme .. " 加载失败，使用默认主题", vim.log.levels.WARN)
    pcall(vim.cmd.colorscheme, "default")
  end
end

safe_colorscheme("tokyonight-night")
-- safe_colorscheme("gruvbox") -- 备选主题
