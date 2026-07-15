-- nvim-treesitter-textobjects `main` 分支：不再走 nvim-treesitter.configs，
-- 没有内建 keymaps，全部手动 vim.keymap.set 调用模块函数。
return {
  "nvim-treesitter/nvim-treesitter-textobjects",
  branch = "main",
  event = { "BufReadPost", "BufNewFile" },
  dependencies = { "nvim-treesitter/nvim-treesitter" },
  init = function()
    vim.g.no_plugin_maps = true
  end,
  config = function()
    require("nvim-treesitter-textobjects").setup({
      select = { lookahead = true },
      move = { set_jumps = true },
    })

    local select_pairs = {
      aa = "@parameter.outer", ia = "@parameter.inner",
      af = "@function.outer",  ["if"] = "@function.inner",
      ac = "@class.outer",     ic = "@class.inner",
    }
    for lhs, capture in pairs(select_pairs) do
      vim.keymap.set({ "x", "o" }, lhs, function()
        require("nvim-treesitter-textobjects.select").select_textobject(capture, "textobjects")
      end, { desc = "TS select " .. capture })
    end

    local move = {
      goto_next_start     = { ["]m"] = "@function.outer", ["]]"] = "@class.outer" },
      goto_next_end       = { ["]M"] = "@function.outer", ["]["] = "@class.outer" },
      goto_previous_start = { ["[m"] = "@function.outer", ["[["] = "@class.outer" },
      goto_previous_end   = { ["[M"] = "@function.outer", ["[]"] = "@class.outer" },
    }
    for fn, maps in pairs(move) do
      for lhs, capture in pairs(maps) do
        vim.keymap.set({ "n", "x", "o" }, lhs, function()
          require("nvim-treesitter-textobjects.move")[fn](capture, "textobjects")
        end, { desc = "TS " .. fn .. " " .. capture })
      end
    end
  end,
}
