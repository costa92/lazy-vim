return {
  'stevearc/conform.nvim',
  event = { "BufWritePre" },
  cmd = { "ConformInfo" },
  opts = {},
  config = function()
    require("conform").setup({
      formatters_by_ft = {
        -- Go
        go = { "goimports", "gofmt" },

        -- Lua
        lua = { "stylua" },

        -- Python
        python = { "isort", "black" },

        -- Rust
        rust = { "rustfmt", lsp_format = "fallback" },

        -- JavaScript / TypeScript
        javascript = { "prettierd", "prettier", stop_after_first = true },
        typescript = { "prettierd", "prettier", stop_after_first = true },
        javascriptreact = { "prettierd", "prettier", stop_after_first = true },
        typescriptreact = { "prettierd", "prettier", stop_after_first = true },

        -- Web 相关
        html = { "prettierd", "prettier", stop_after_first = true },
        css = { "prettierd", "prettier", stop_after_first = true },
        scss = { "prettierd", "prettier", stop_after_first = true },
        less = { "prettierd", "prettier", stop_after_first = true },
        json = { "prettierd", "prettier", stop_after_first = true },
        jsonc = { "prettierd", "prettier", stop_after_first = true },
        yaml = { "prettierd", "prettier", stop_after_first = true },

        -- Markdown
        markdown = { "prettierd", "prettier", stop_after_first = true },

        -- Shell
        sh = { "shfmt" },
        bash = { "shfmt" },
      },

      -- 格式化选项
      format_on_save = {
        -- 这些选项将传递给 conform.format()
        timeout_ms = 500,
        lsp_fallback = true,
      },

      -- 设置格式化器选项
      formatters = {
        prettier = {
          prepend_args = { "--tab-width", "2", "--single-quote" },
        },
        prettierd = {
          prepend_args = { "--tab-width", "2", "--single-quote" },
        },
      },
    })

    -- 添加格式化命令
    vim.api.nvim_create_user_command("Format", function(args)
      local range = nil
      if args.count ~= -1 then
        local end_line = vim.api.nvim_buf_get_lines(0, args.line2 - 1, args.line2, true)[1]
        range = {
          start = { args.line1, 0 },
          ["end"] = { args.line2, end_line:len() },
        }
      end
      require("conform").format({ async = true, lsp_fallback = true, range = range })
    end, { range = true })

    -- 添加格式化快捷键
    vim.keymap.set({ "n", "v" }, "<leader>fm", function()
      require("conform").format({ async = true, lsp_fallback = true })
    end, { desc = "[Format] Format buffer" })
  end
}
