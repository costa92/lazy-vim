local map = skcode.map
local M = {}

M.todo_comments = function()
  map("n", "<leader>tl", ":TodoLocList<CR>")
  map("n", "<leader>ts", ":TodoTelescope<CR>")
end

return M
