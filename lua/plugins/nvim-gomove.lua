return {
  "booperlv/nvim-gomove",
  lazy = true,
  event = { "User FileOpened" },
  config = function()
    require("gomove").setup({
      map_defaults = false,
      reindent = true,
      undojoin = true,
      move_past_end_col = false,
    })

    local map = vim.api.nvim_set_keymap
    map("n", "<M-h>", "<Plug>GoNSMLeft", { noremap = true, silent = true })
    map("n", "<M-j>", "<Plug>GoNSMDown", { noremap = true, silent = true })
    map("n", "<M-k>", "<Plug>GoNSMUp", { noremap = true, silent = true })
    map("n", "<M-l>", "<Plug>GoNSMRight", { noremap = true, silent = true })

    map("x", "<M-h>", "<Plug>GoVSMLeft", { noremap = true, silent = true })
    map("x", "<M-j>", "<Plug>GoVSMDown", { noremap = true, silent = true })
    map("x", "<M-k>", "<Plug>GoVSMUp", { noremap = true, silent = true })
    map("x", "<M-l>", "<Plug>GoVSMRight", { noremap = true, silent = true })

    map("x", "<C-h>", "<Plug>GoVSDLeft", { noremap = true, silent = true })
    map("x", "<C-j>", "<Plug>GoVSDDown", { noremap = true, silent = true })
    map("x", "<C-k>", "<Plug>GoVSDUp", { noremap = true, silent = true })
    map("x", "<C-l>", "<Plug>GoVSDRight", { noremap = true, silent = true })
  end,
}
