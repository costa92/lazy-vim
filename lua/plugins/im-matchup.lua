return {
  "andymass/vim-matchup",
  -- Highlight, jump between pairs like if..else
  lazy = true,
  event = { "User FileOpened" },
  config = function()
    vim.g.matchup_matchparen_offscreen = { method = "popup" }
    vim.builtin.treesitter.matchup.enable = true
  end,
}
