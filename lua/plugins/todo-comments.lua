return {
  "folke/todo-comments.nvim",
  lazy = true,
  event = { "User FileOpened" },
  config = function()
    require("todo-comments").setup()
  end,
}
