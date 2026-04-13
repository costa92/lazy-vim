return {
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      { "rcarriga/nvim-dap-ui", dependencies = { "nvim-neotest/nvim-nio" } },
      "theHamsta/nvim-dap-virtual-text",
      "leoluz/nvim-dap-go",
    },
    keys = {
      { "<leader>db", function() require("dap").toggle_breakpoint() end, desc = "[DAP] Toggle breakpoint" },
      { "<leader>dB", function() require("dap").set_breakpoint(vim.fn.input("Condition: ")) end, desc = "[DAP] Conditional breakpoint" },
      { "<leader>dc", function() require("dap").continue() end, desc = "[DAP] Continue / Start" },
      { "<leader>di", function() require("dap").step_into() end, desc = "[DAP] Step into" },
      { "<leader>do", function() require("dap").step_over() end, desc = "[DAP] Step over" },
      { "<leader>dO", function() require("dap").step_out() end, desc = "[DAP] Step out" },
      { "<leader>dr", function() require("dap").repl.open() end, desc = "[DAP] Open REPL" },
      { "<leader>dt", function() require("dap").terminate() end, desc = "[DAP] Terminate" },
      { "<leader>du", function() require("dapui").toggle() end, desc = "[DAP] Toggle UI" },
      { "<leader>dK", function() require("dap.ui.widgets").hover() end, desc = "[DAP] Hover variable" },
      { "<leader>dgt", function() require("dap-go").debug_test() end, desc = "[DAP] Go: debug test" },
      { "<leader>dgl", function() require("dap-go").debug_last_test() end, desc = "[DAP] Go: debug last test" },
    },
    config = function()
      local dap = require("dap")
      local dapui = require("dapui")

      dapui.setup()
      require("nvim-dap-virtual-text").setup({})
      require("dap-go").setup()

      -- 自动开关 dap-ui
      dap.listeners.before.attach.dapui_config = function() dapui.open() end
      dap.listeners.before.launch.dapui_config = function() dapui.open() end
      dap.listeners.before.event_terminated.dapui_config = function() dapui.close() end
      dap.listeners.before.event_exited.dapui_config = function() dapui.close() end

      -- signs
      vim.fn.sign_define("DapBreakpoint", { text = "●", texthl = "DiagnosticError", numhl = "" })
      vim.fn.sign_define("DapBreakpointCondition", { text = "◆", texthl = "DiagnosticWarn", numhl = "" })
      vim.fn.sign_define("DapStopped", { text = "▶", texthl = "DiagnosticInfo", linehl = "Visual", numhl = "" })
      vim.fn.sign_define("DapLogPoint", { text = "◆", texthl = "DiagnosticInfo", numhl = "" })
    end,
  },
}
