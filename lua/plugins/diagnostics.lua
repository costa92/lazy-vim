-- 诊断显示样式：直接调用 vim.diagnostic.config（核心 API，不依赖任何插件）。
--
-- 这里刻意不挂到 { "neovim/nvim-lspconfig", config = ... } 上：lazy 合并同一插件的多个
-- spec 片段时 config 字段只能存活一个，而 plugins/lsp.lua 已经占用了 nvim-lspconfig 的
-- config。之前写成插件片段时本段从未执行过（severity_sort 与自定义 signs 全部失效）。
vim.diagnostic.config({
  underline = true,
  update_in_insert = false,
  virtual_text = {
    spacing = 4,
    source = "if_many",
    prefix = "●",
  },
  severity_sort = true,
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = "✘",
      [vim.diagnostic.severity.WARN] = "▲",
      [vim.diagnostic.severity.HINT] = "⚑",
      [vim.diagnostic.severity.INFO] = "»",
    },
  },
})

-- 诊断相关的 keymaps（<leader>e/<leader>q/[d/]d）在 lua/configs/keymaps.lua 统一管理

return {
  -- Trouble.nvim - 更好的诊断显示界面
  {
    "folke/trouble.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    event = "VeryLazy",
    opts = {
      auto_close = true,
      auto_preview = false,
      focus = true,
      restore = true,
      follow = true,
      indent_guides = true,
      max_items = 200,
      multiline = true,
      pinned = false,
      warn_no_results = false,
      open_no_results = false,
      win = { 
        size = { height = 0.3 } 
      },
      preview = {
        type = "split",
        relative = "win",
        position = "right",
        size = 0.3,
      },
    },
    keys = {
      {
        "<leader>xx",
        "<cmd>Trouble diagnostics toggle<cr>",
        desc = "Diagnostics (Trouble)",
      },
      {
        "<leader>xX",
        "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
        desc = "Buffer Diagnostics (Trouble)",
      },
      {
        "<leader>cs",
        "<cmd>Trouble symbols toggle focus=false<cr>",
        desc = "Symbols (Trouble)",
      },
      {
        "<leader>cl",
        "<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
        desc = "LSP Definitions / references / ... (Trouble)",
      },
      {
        "<leader>xL",
        "<cmd>Trouble loclist toggle<cr>",
        desc = "Location List (Trouble)",
      },
      {
        "<leader>xQ",
        "<cmd>Trouble qflist toggle<cr>",
        desc = "Quickfix List (Trouble)",
      },
    },
  },
}