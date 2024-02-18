-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

local opt = vim.opt
opt.relativenumber = false
-- opt.guifont = "DroidSansMono Nerd Font"
--
opt.guifont = "FiraCode Nerd Font:h11"
if vim.fn.exists(vim.g.neovide) then
  vim.opt.guifont = { "FiraCode Nerd Font", ":h16" }
  vim.g.neovide_transparency = 0.0
  vim.g.transparency = 0.97
  vim.g.transparency = 1
  vim.g.neovide_background_color = "#000000" .. vim.fn.printf("%x", vim.fn.float2nr(255 * vim.g.transparency))
  vim.g.neovide_input_macos_alt_is_meta = true
end
