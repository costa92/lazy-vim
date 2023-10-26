return {
  "NvChad/nvim-colorizer.lua",
  event = { "CursorHold" },
  config = function()
    require("plugin-configs.colorizer")
  end,
}
