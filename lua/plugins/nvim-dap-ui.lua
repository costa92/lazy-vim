return {
  "mfussenegger/nvim-dap",
  lazy = true,
  dependencies = {
    "rcarriga/nvim-dap-ui",
  },
  keys = {
    {
      "<leader>d",
      function()
        require("dap").toggle_breakpoint()
      end,
    },
    {
      "<leader>c",
      function()
        require("dap").continue()
      end,
    },
  },
  config = function()
    require("dapui").setup()
  end,
}
