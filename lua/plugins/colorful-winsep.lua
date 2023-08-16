return {
  "nvim-zh/colorful-winsep.nvim",
  lazy = true,
  event = "WinNew",
  config = function()
    require("colorful-winsep").setup()
  end,
}
