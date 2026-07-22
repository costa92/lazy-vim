return {
  "kdheepak/lazygit.nvim",
  cmd = {
    "LazyGit",
    "LazyGitConfig",
    "LazyGitCurrentFile",
    "LazyGitFilter",
    "LazyGitFilterCurrentFile",
  },
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  -- 绑定快捷键进行延迟加载
  keys = {
    { "<leader>gg", "<cmd>LazyGitCurrentFile<cr>", desc = "[Git] Open LazyGit (Current File)" },
  },
}
