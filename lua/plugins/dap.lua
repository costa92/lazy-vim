return {
  {
    "mfussenegger/nvim-dap",
    event = "VeryLazy",
    keys = {
      {
        "<f5>",
        function()
          require("dap").continue()
        end,
        desc = "launch/continue gdb",
      },
    },
    config = function()
      local dap = require("dap")
      dap.adapters.gdb = {
        type = "executable",
        executable = {
          command = vim.fn.exepath("gdb"),
          args = { "-i", "dap" },
        },
      }
      dap.configurations.c = {
        name = "Launch file",
        type = "gdb",
        request = "launch",
        gdbpath = function()
          return "/usr/local/gdb/bin/gdb"
        end,
        cmd = "${workspaceFolder}",
      }
    end,
  },
}
