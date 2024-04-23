return {
  {
    "ldelossa/litee-calltree.nvim",
    dependencies = {
      "ldelossa/litee.nvim",
      config = function()
        require("litee.lib").setup({})
      end,
    },
    config = function()
      require("litee.calltree").setup({})
    end,

    keys = {
      { "<leader>ct", "<cmd>lua vim.lsp.buf.incoming_calls()<cr>", desc = "calltree" },
    },
  },
}
