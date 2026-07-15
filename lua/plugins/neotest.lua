-- 标记：仅当通过 <leader>Tn 触发的单个测试(nearest)运行完成后，才自动弹出该测试输出。
-- neotest 不发测试完成的 User autocmd(NeotestTestCompleted 这个事件并不存在)，
-- 完成只能靠自定义 consumer 的 client.listeners.results 感知。keys 与 config 共享此标志。
local run_nearest_pending = false

return {
  "nvim-neotest/neotest",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-neotest/nvim-nio",
    "antoinemadec/FixCursorHold.nvim",
    "nvim-treesitter/nvim-treesitter",
    {
      "fredrikaverpil/neotest-golang",
      -- neotest-golang 的 treesitter 查询与 go parser 的 `statement_list` 兼容性
      -- 随版本漂移：主线是命名节点(原始查询直接可用)，某些版本是匿名规则(需剥包装)。
      -- scripts/patch-neotest-golang.lua 会条件自愈：先 git 恢复原始查询，只在当前
      -- parser 下编译失败时才剥离，避免无条件补丁把本可用的查询打坏(反造成零发现)。
      -- 脚本用到 vim.treesitter，必须在当前 nvim 进程内 dofile，不能用独立 lua 解释器。
      build = function()
        local script = vim.fn.stdpath("config") .. "/scripts/patch-neotest-golang.lua"
        local ok, err = pcall(dofile, script)
        if not ok then
          vim.notify("patch-neotest-golang 失败: " .. tostring(err), vim.log.levels.WARN)
        end
      end,
    },
    "nvim-neotest/neotest-jest",
  },
  keys = {
    { "<leader>Tn", function()
        run_nearest_pending = true -- 本次跑完后由 auto_output consumer 自动弹输出
        require("neotest").run.run()
      end, desc = "[Test] Run nearest (auto output)" },
    { "<leader>Tf", function() require("neotest").run.run(vim.fn.expand("%")) end, desc = "[Test] Run file" },
    { "<leader>Td", function() require("neotest").run.run({ strategy = "dap" }) end, desc = "[Test] Debug nearest (DAP)" },
    { "<leader>Ts", function() require("neotest").run.stop() end, desc = "[Test] Stop" },
    { "<leader>To", function() require("neotest").output.open({ enter = true }) end, desc = "[Test] Show output" },
    { "<leader>Tp", function() require("neotest").output_panel.toggle() end, desc = "[Test] Toggle output panel" },
    { "<leader>TS", function() require("neotest").summary.toggle() end, desc = "[Test] Toggle summary" },
  },
  config = function()
    require("neotest").setup({
      -- 自定义 consumer：只在 <leader>Tn(单个测试)运行完成后自动弹出该测试输出，
      -- 批量运行(<leader>Tf 等)不受影响，保持默认的安静。
      consumers = {
        auto_output = function(client)
          client.listeners.results = function(_, results, partial)
            if partial then return end -- 只在最终结果时处理，忽略中间态
            vim.schedule(function()
              if run_nearest_pending then
                -- 单个测试(<leader>Tn)：跑完弹出该测试输出浮窗，无论成败
                run_nearest_pending = false
                pcall(function()
                  require("neotest").output.open({ enter = true, last_run = true })
                end)
              else
                -- 批量运行(<leader>Tf 等)：只要有失败就打开底部输出面板
                for _, r in pairs(results) do
                  if r.status == "failed" then
                    pcall(function() require("neotest").output_panel.open() end)
                    break
                  end
                end
              end
            end)
          end
          return {}
        end,
      },
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

    -- 失败自动弹输出面板的逻辑已移到上面的 auto_output consumer（走 client.listeners.results）。
    -- 原先基于 "NeotestTestCompleted" User 事件的写法是死代码——neotest 从不发这个事件。
    local group = vim.api.nvim_create_augroup("NeotestAutoOutput", { clear = true })

    -- neotest 输出浮窗(<leader>Tn 跑完弹出的)默认没有关闭键，直接按 q 会误触发宏录制。
    -- 绑 buffer-local q = 关闭窗口，符合只读输出窗直觉(和 quickfix/help 一致)。
    -- 输出面板(neotest-output-panel)同样绑上，批量失败弹出后也能一键关。
    vim.api.nvim_create_autocmd("FileType", {
      pattern = { "neotest-output", "neotest-output-panel" },
      group = group,
      callback = function(ev)
        vim.keymap.set("n", "q", "<C-w>c", {
          buffer = ev.buf, silent = true, nowait = true, desc = "关闭 neotest 输出窗口",
        })
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
