return {
  "mfussenegger/nvim-lint",
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    local lint = require("lint")

    -- 配置不同语言的 linter
    lint.linters_by_ft = {
      -- Go 语言检测（使用系统安装的 golangci-lint）
      go = { "golangcilint" },
      
      -- 暂时禁用其他 linter，直到工具正确安装
      -- Shell 脚本检测
      -- bash = { "shellcheck" },
      -- sh = { "shellcheck" },
      
      -- YAML 检测
      -- yaml = { "yamllint" },
      -- yml = { "yamllint" },
      
      -- JSON 检测
      -- json = { "jsonlint" },
      
      -- Lua 检测
      -- lua = { "luacheck" },
      
      -- Python 检测（如果需要）
      -- python = { "pylint", "flake8" },
      
      -- JavaScript/TypeScript 检测（如果需要）
      -- javascript = { "eslint" },
      -- typescript = { "eslint" },
      
      -- Markdown 检测（暂时禁用，直到工具正确安装）
      -- markdown = { "markdownlint" },
      
      -- 明确禁用 Dockerfile 检测
      dockerfile = {},
    }

    -- 自定义 linter 配置
    lint.linters.golangcilint = {
      cmd = "golangci-lint",
      stdin = false,
      args = {
        "run",
        "--out-format", "json",
        "--path-prefix", function() return vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ":h") end,
      },
      stream = "stdout",
      ignore_exitcode = true,
      parser = function(output, bufnr)
        local decoded = vim.json.decode(output)
        local diagnostics = {}
        
        if decoded and decoded.Issues then
          for _, issue in ipairs(decoded.Issues) do
            table.insert(diagnostics, {
              lnum = (issue.Pos and issue.Pos.Line or 1) - 1,
              col = (issue.Pos and issue.Pos.Column or 1) - 1,
              end_lnum = (issue.Pos and issue.Pos.Line or 1) - 1,
              end_col = (issue.Pos and issue.Pos.Column or 1) - 1,
              severity = vim.diagnostic.severity.WARN,
              message = issue.Text or "Unknown issue",
              source = "golangci-lint",
              code = issue.FromLinter or "unknown",
            })
          end
        end
        
        return diagnostics
      end,
    }

    -- 配置 yamllint
    lint.linters.yamllint.args = {
      "--format", "parsable",
      "-d", "{extends: default, rules: {line-length: {max: 120}, indentation: {spaces: 2}}}"
    }

    -- 自动触发 lint - 优化频率
    local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })

    -- 减少触发频率，只在关键时刻运行
    vim.api.nvim_create_autocmd({ "BufWritePost" }, {
      group = lint_augroup,
      callback = function()
        -- 只对支持的文件类型运行 lint
        local ft = vim.bo.filetype
        if lint.linters_by_ft[ft] and next(lint.linters_by_ft[ft]) then
          lint.try_lint()
        end
      end,
    })

    -- 手动触发 lint 的命令
    vim.api.nvim_create_user_command("Lint", function()
      lint.try_lint()
    end, { desc = "Run linter on current buffer" })

  end,
}