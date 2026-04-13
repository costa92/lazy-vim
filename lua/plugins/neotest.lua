return {
  "nvim-neotest/neotest",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-neotest/nvim-nio",
    "antoinemadec/FixCursorHold.nvim",
    "nvim-treesitter/nvim-treesitter",
    {
      "fredrikaverpil/neotest-golang",
      -- neotest-golang 的 treesitter 查询还在用旧版的 `statement_list` 节点名，
      -- 新版 tree-sitter-go 把该规则改成匿名，会报 "Invalid node type"。
      -- 安装/更新后自动跑 scripts/patch-neotest-golang.lua 把包装剥掉。
      build = function()
        local script = vim.fn.stdpath("config") .. "/scripts/patch-neotest-golang.lua"
        vim.fn.system({ "lua", script })
      end,
    },
    "nvim-neotest/neotest-jest",
  },
  keys = {
    { "<leader>Tn", function() require("neotest").run.run() end, desc = "[Test] Run nearest" },
    { "<leader>Tf", function() require("neotest").run.run(vim.fn.expand("%")) end, desc = "[Test] Run file" },
    { "<leader>Td", function() require("neotest").run.run({ strategy = "dap" }) end, desc = "[Test] Debug nearest (DAP)" },
    { "<leader>Ts", function() require("neotest").run.stop() end, desc = "[Test] Stop" },
    { "<leader>To", function() require("neotest").output.open({ enter = true }) end, desc = "[Test] Show output" },
    { "<leader>Tp", function() require("neotest").output_panel.toggle() end, desc = "[Test] Toggle output panel" },
    { "<leader>TS", function() require("neotest").summary.toggle() end, desc = "[Test] Toggle summary" },
  },
  config = function()
    require("neotest").setup({
      adapters = {
        require("neotest-golang")({
          -- -timeout 30s：单个测试 30 秒没结束直接 fail（默认 10 分钟太长，hang 的时候只能看图标转）
          -- 如果有慢测试需要更长时间，在测试函数里调 t.Cleanup/t.Deadline 控制，或按需调大这里
          go_test_args = { "-v", "-race", "-count=1", "-timeout=30s" },
          dap_go_enabled = true,
          -- 关闭重名子测试警告（Go 会自动加 #01 后缀，功能上无影响）
          warn_test_name_dupes = false,
        }),
        require("neotest-jest")({
          jestCommand = "npx jest --",
          env = { CI = true },
          cwd = function() return vim.fn.getcwd() end,
        }),
      },
      -- 测试失败直接在对应行显示诊断（红色波浪线 + 错误消息）
      diagnostic = {
        enabled = true,
        severity = vim.diagnostic.severity.ERROR,
      },
      -- 悬浮窗展示单个测试结果摘要
      floating = {
        border = "rounded",
        max_height = 0.8,
        max_width = 0.8,
      },
      -- 状态图标
      icons = {
        passed = "✓",
        failed = "✗",
        running = "⟳",
        skipped = "○",
      },
      -- 输出面板配置
      output = {
        enabled = true,
        open_on_run = false, -- 设 true 会每次跑都弹输出，可能很吵
      },
      output_panel = {
        enabled = true,
        open = "botright split | resize 15",
      },
      -- 测试摘要树
      summary = {
        enabled = true,
        animated = false,
      },
    })

    -- 测试完成后，只要有失败就自动打开输出面板
    local group = vim.api.nvim_create_augroup("NeotestAutoOutput", { clear = true })
    vim.api.nvim_create_autocmd("User", {
      pattern = "NeotestTestCompleted",
      group = group,
      callback = function(args)
        if args.data and args.data.result and args.data.result.status == "failed" then
          require("neotest").output_panel.open()
        end
      end,
    })

    -- 退出 Neovim 前杀掉还在跑的测试子进程，避免 :q! 卡几秒等 go test 结束
    vim.api.nvim_create_autocmd("VimLeavePre", {
      group = group,
      callback = function()
        pcall(function() require("neotest").run.stop() end)
      end,
    })
  end,
}
