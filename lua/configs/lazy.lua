-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-- Make sure to setup `mapleader` and `maplocalleader` before
-- loading lazy.nvim so that mappings are correct.
-- This is also a good place to setup other settings (vim.opt)
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Setup lazy.nvim
require("lazy").setup({
  spec = {
    -- 核心插件 - 立即加载
    { import = "plugins/tokyonight" }, 
    { import = "plugins/which-key" }, 
    { import = "plugins/guess-indent" },
    
    -- UI 插件 - 延迟加载
    { import = "plugins/alpha" },   
    { import = "plugins/gruvbox" },   
    { import = "plugins/lualine" },   
    { import = "plugins/indent-blankline" }, 
    { import = "plugins/notify" },
    
    -- 编辑功能 - 按需加载
    { import = "plugins/autopairs" }, 
    { import = "plugins/comment" }, 
    { import = "plugins/conform" },
    
    -- 代码检测和诊断
    { import = "plugins/nvim-lint" },
    { import = "plugins/diagnostics" },    
    
    -- 文件管理 - 按需加载
    { import = "plugins/neo-tree" }, 
    { import = "plugins/fzf" },  
    { import = "plugins/toggleterm" },
    
    -- LSP 和开发工具 - 延迟加载
    { import = "plugins/mason" },
    { import = "plugins/lsp" },  
    { import = "plugins/cmp" },   
    { import = "plugins/treesitter-fix" },
    
    -- Git 集成 - 按需加载
    { import = "plugins/gitsigns" },  
    { import = "plugins/blame" },  
    { import = "plugins/vim-fugitive" },
    
    -- 语言特定 - 文件类型加载
    { import = "plugins/go-vim" }, 
    { import = "plugins/markdown" }, 
    
    -- 高级功能 - 最后加载
    { import = "plugins/avante" }, 
    { import = "plugins/root" },   
    { import = "plugins/visual-multi" },
    { import = "plugins/render-markdown-fix" },
    
    { "mg979/vim-visual-multi", branch = "master" },
  },
  -- Configure any other settings here. See the documentation for more details.
  -- colorscheme that will be used when installing plugins.
  install = { colorscheme = { "tokyonight" } },
  -- automatically check for plugin updates
  checker = { 
    enabled = false,    -- 完全禁用更新检查  
    notify = false      -- 关闭所有通知
    -- frequency = 604800  -- 检查间隔改为每周一次（单位：秒）
  },

  ui = {
    icons = {
      ft = "",
      lazy = "󰂠 ",
      loaded = "",
      not_loaded = "",
    },
  },

  performance = {
    rtp = {
      disabled_plugins = {
        "2html_plugin",
        "tohtml",
        "getscript",
        "getscriptPlugin",
        "gzip",
        "logipat",
        "netrw",
        "netrwPlugin",
        "netrwSettings",
        "netrwFileHandlers",
        "matchit",
        "tar",
        "tarPlugin",
        "rrhelper",
        "spellfile_plugin",
        "vimball",
        "vimballPlugin",
        "zip",
        "zipPlugin",
        "tutor",
        "rplugin",
        "syntax",
        "synmenu",
        "optwin",
        "compiler",
        "bugreport",
        "ftplugin",
      },
    },
  },
})
