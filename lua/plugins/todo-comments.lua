return {
  "folke/todo-comments.nvim",
  event = "BufRead",
  lazy = true,
  config = function()
    require("plugin-configs.todo_comments")
  end,
  init = function()
    require("core.mappings").todo_comments()
  end,
}
