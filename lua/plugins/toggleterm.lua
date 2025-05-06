return {  
  "akinsho/toggleterm.nvim",  
  config = function()  
    require("toggleterm").setup({  
      open_mapping = [[<c-t>]],  -- 改用 ctrl-t 作为快捷键
      start_in_insert = true,     
      direction = "float"    -- tab, float, vertical
    })  
  end  
}
