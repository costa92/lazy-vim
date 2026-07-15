return {
  "akinsho/toggleterm.nvim",
  -- cmd 触发 :ToggleTerm；keys 触发 <c-t>（open_mapping 在 setup 里才注册，
  -- 所以必须把 <c-t> 也作为加载触发键，否则首次按 <c-t> 无法拉起插件）
  cmd = "ToggleTerm",
  keys = { { "<c-t>", mode = { "n", "t" }, desc = "ToggleTerm" } },
  config = function()
    require("toggleterm").setup({  
      open_mapping = [[<c-t>]],  -- 改用 ctrl-t 作为快捷键
      start_in_insert = true,     
      direction = "float"    -- tab, float, vertical
    })  
  end  
}
