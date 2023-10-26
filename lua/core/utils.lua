-- 键位定义函数
-- @param mode 模式
-- @param key 键位
-- @param command 命令
-- @param opt 其他参数
skcode.map = function(mode, key, command, opts)
  local options = { noremap = true, silent = true }
  if opts then
    options = skcode.merge(options, opts)
  end
  vim.api.nvim_set_keymap(mode, key, command, options)
end
