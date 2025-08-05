-- .env 文件类型支持配置
return {
  -- 确保 Treesitter 安装所需的解析器
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, { "bash" })
    end,
  },

  -- 文件类型检测和自动命令配置
  {
    "neovim/nvim-lspconfig",
    config = function()
      -- 为 .env 文件设置文件类型关联
      vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
        pattern = { 
          ".env", 
          ".env.*", 
          "*.env",
          ".envrc",
          ".env.local",
          ".env.development",
          ".env.production",
          ".env.test"
        },
        callback = function()
          -- 设置文件类型为 sh 以获得语法高亮
          vim.bo.filetype = "sh"
          
          -- 设置 .env 文件特定的选项
          vim.bo.commentstring = "# %s"
          
          -- 设置特定的缩进选项
          vim.bo.tabstop = 2
          vim.bo.shiftwidth = 2
          vim.bo.expandtab = true
        end,
        desc = "设置 .env 文件类型和选项"
      })

      -- .env 文件保存时自动清理
      vim.api.nvim_create_autocmd("BufWritePre", {
        pattern = { ".env*", "*.env" },
        callback = function()
          -- 移除行尾空白
          vim.cmd([[silent! %s/\s\+$//e]])
        end,
        desc = "清理 .env 文件的行尾空白"
      })
    end,
  },

  -- 为 .env 文件配置格式化器（可选）
  {
    "stevearc/conform.nvim",
    opts = function(_, opts)
      opts.formatters_by_ft = opts.formatters_by_ft or {}
      -- 可以选择性地为 .env 文件添加格式化器
      -- opts.formatters_by_ft.sh = { "shfmt" }
    end,
  },
}