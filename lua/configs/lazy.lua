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
    -- 核心插件 - 立即加载（最小化）
    { import = "plugins/tokyonight" },
    { import = "plugins/guess-indent" },

    -- UI 插件 - 延迟加载
    { import = "plugins/alpha", event = "VimEnter" },
    { import = "plugins/gruvbox", lazy = true },
    { import = "plugins/lualine", event = "VeryLazy" },
    { import = "plugins/indent-blankline", event = "BufRead" },
    { import = "plugins/notify", event = "VeryLazy" },
    { import = "plugins/which-key", event = "VeryLazy" },

    -- 编辑功能 - 按需加载（优化事件触发）
    { import = "plugins/autopairs", event = "InsertEnter" },
    { import = "plugins/comment", keys = { "gc", "gb" } }, -- 只在快捷键时加载
    { import = "plugins/conform", cmd = "Format" }, -- 改为命令触发
    { import = "plugins/surround", event = { "BufReadPost", "BufNewFile" } }, -- ys/cs/ds 环绕操作

    -- 代码检测和诊断 - 延迟加载
    { import = "plugins/nvim-lint", event = { "BufReadPre", "BufNewFile" } },
    { import = "plugins/diagnostics", event = "LspAttach" },

    -- 文件管理 - 按需加载
    { import = "plugins/neo-tree", cmd = "Neotree" },
    { import = "plugins/fzf", event = "VeryLazy" },
    { import = "plugins/toggleterm", cmd = "ToggleTerm" },

    -- LSP 和开发工具 - 延迟加载
    { import = "plugins/mason", event = "VeryLazy" },
    { import = "plugins/lsp", event = { "BufReadPre", "BufNewFile" } },
    { import = "plugins/cmp", event = "InsertEnter" },
    { import = "plugins/treesitter-fix", event = { "BufReadPost", "BufNewFile" } },
    { import = "plugins/fidget", event = "LspAttach" }, -- LSP 进度提示

    -- 调试 / 测试 - 按键触发
    { import = "plugins/dap" }, -- keys 在插件内声明
    { import = "plugins/neotest" }, -- keys 在插件内声明

    -- 快速文件跳转
    { import = "plugins/harpoon" }, -- keys 在插件内声明

    -- Git 集成 - 按需加载
    { import = "plugins/gitsigns", event = { "BufReadPre", "BufNewFile" } },
    { import = "plugins/blame", cmd = "BlameToggle" },
    { import = "plugins/vim-fugitive", cmd = { "Git", "G" } },

    -- 语言特定 - 文件类型加载
    { import = "plugins/go-vim", ft = "go" },
    { import = "plugins/markdown", ft = "markdown" },
    { import = "plugins/dotenv", ft = { "sh", "bash" } },

    -- 高级功能 - 最后加载
    { import = "plugins/avante", event = "VeryLazy" },
    { import = "plugins/root", event = "VeryLazy" },
    { import = "plugins/visual-multi", event = "VeryLazy" },
    { import = "plugins/render-markdown-fix", ft = "markdown" },
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
    cache = {
      enabled = true, -- 启用缓存
    },
    reset_packpath = true, -- 重置 packpath
    rtp = {
      reset = true, -- 重置 runtimepath
      -- 增加更多禁用的默认插件以提升性能
      disabled_plugins = {
        "2html_plugin", "tohtml", "getscript", "getscriptPlugin", "gzip",
        "logipat", "netrw", "netrwPlugin", "netrwSettings", "netrwFileHandlers",
        "matchit", "tar", "tarPlugin", "rrhelper", "spellfile_plugin",
        "vimball", "vimballPlugin", "zip", "zipPlugin", "tutor", "rplugin",
        "syntax", "synmenu", "optwin", "compiler", "bugreport", "ftplugin",
        -- 新增禁用的插件
        "matchparen", "shada_plugin", "man", "health", "editorconfig"
      },
      -- 排除不应作为插件加载的路径
      paths = {
        -- 排除 LSP 子目录，这些是配置模块而不是插件
      },
    },
  },
  -- 配置插件发现规则
  dev = {
    patterns = {},
  },
})
