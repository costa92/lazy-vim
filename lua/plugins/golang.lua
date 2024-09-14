-- https://github.com/mfussenegger/nvim-dap/wiki/Debug-Adapter-installation#go-using-delve-directly

return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = { ensure_installed = { "go", "gomod", "gowork", "gosum" } },
  },
  {
    "mfussenegger/nvim-dap",
    optional = true,
    dependencies = {
      {
        "williamboman/mason.nvim",
        opts = { ensure_installed = { "delve" } },
      },
      {
        "leoluz/nvim-dap-go",
        opts = {},
      },
    },
  },
  {
    "nvim-neotest/neotest",
    dependencies = {
      "nvim-neotest/nvim-nio",
      "nvim-lua/plenary.nvim",
      "antoinemadec/FixCursorHold.nvim",
      "nvim-treesitter/nvim-treesitter",
      {
        "fredrikaverpil/neotest-golang", -- Installation
        dependencies = {
          "leoluz/nvim-dap-go", -- Installation
        },
      },
    },
    config = function()
      require("neotest").setup({
        keys = {
          {
            "<leader>td",
            function()
              require("neotest").run.run({ suite = false, strategy = "dap" })
            end,
            desc = "Debug nearest test",
          },
        },
        adapters = {
          require("neotest-golang")({
            go_test_args = {
              "-v",
              "-race",
              "-count=1",
              "-coverprofile=" .. vim.fn.getcwd() .. "/coverage.out",
            },
            go_list_args = { "-tags=integration" },
            dap_go_enabled = true, -- requires leoluz/nvim-dap-go
            -- dap_go_opts = {
            --   delve = {
            --     build_flags = { "-tags=integration" },
            --   },
            -- },
          }), -- Registration
        },
      })
    end,
  },
}
