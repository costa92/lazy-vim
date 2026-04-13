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
  
  -- 诊断相关的额外配置
  {
    "neovim/nvim-lspconfig",
    opts = {
      diagnostics = {
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
      },
    },
    config = function(_, opts)
      vim.diagnostic.config(opts.diagnostics)
      -- 诊断相关的 keymaps（<leader>e/<leader>q/[d/]d）在 lua/configs/keymaps.lua
      -- 作为全局键位统一管理；此处不再注册 LspAttach autocmd 避免重复
    end,
  },
}