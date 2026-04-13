return {
  "ThePrimeagen/harpoon",
  branch = "harpoon2",
  dependencies = { "nvim-lua/plenary.nvim" },
  keys = {
    { "<leader>Ha", function() require("harpoon"):list():add() end, desc = "[Harpoon] Add file" },
    { "<leader>He", function()
        local h = require("harpoon")
        h.ui:toggle_quick_menu(h:list())
      end, desc = "[Harpoon] Toggle menu" },
    { "<leader>1", function() require("harpoon"):list():select(1) end, desc = "[Harpoon] Go to 1" },
    { "<leader>2", function() require("harpoon"):list():select(2) end, desc = "[Harpoon] Go to 2" },
    { "<leader>3", function() require("harpoon"):list():select(3) end, desc = "[Harpoon] Go to 3" },
    { "<leader>4", function() require("harpoon"):list():select(4) end, desc = "[Harpoon] Go to 4" },
    { "<leader>Hn", function() require("harpoon"):list():next() end, desc = "[Harpoon] Next" },
    { "<leader>Hp", function() require("harpoon"):list():prev() end, desc = "[Harpoon] Prev" },
  },
  config = function()
    require("harpoon"):setup({})
  end,
}
