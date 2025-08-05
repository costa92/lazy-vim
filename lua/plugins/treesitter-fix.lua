return {
  "nvim-treesitter/nvim-treesitter",
  event = { "BufReadPost", "BufNewFile" },
  build = ":TSUpdate",
  dependencies = {
    "nvim-treesitter/nvim-treesitter-textobjects",
  },
  config = function()
    -- 添加一个安全执行 treesitter 操作的函数
    _G.safe_treesitter = function(callback)
      local success, result = pcall(callback)
      if not success then
        -- 避免显示过多错误
        local msg = result
        if string.find(msg, "attempt to yield across C%-call boundary") then
          -- 静默处理这类错误，避免大量错误信息
          vim.schedule(function()
            -- 如果需要，可以在这里添加更温和的通知
          end)
        else
          vim.schedule(function()
            vim.notify("TreeSitter 错误: " .. msg, vim.log.levels.ERROR)
          end)
        end
        return nil
      end
      return result
    end

    -- 替换一些关键的 treesitter 函数以添加错误处理
    local orig_highlighter = require("vim.treesitter.highlighter")
    if orig_highlighter and orig_highlighter.highlight_injected then
      local orig_highlight_injected = orig_highlighter.highlight_injected
      orig_highlighter.highlight_injected = function(buf, tree, query, opts)
        return safe_treesitter(function()
          return orig_highlight_injected(buf, tree, query, opts)
        end)
      end
    end

    -- 正常的 treesitter 配置
    require("nvim-treesitter.configs").setup({
      sync_install = false,
      ensure_installed = {
        "bash", "c", "cpp", "css", "go", "html", "javascript", 
        "json", "lua", "markdown", "markdown_inline", "python", 
        "rust", "typescript", "vim", "vimdoc", "yaml", "toml"
      },
      auto_install = true,
      highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
      },
      indent = { enable = true },
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = "<C-space>",
          node_incremental = "<C-space>",
          scope_incremental = "<C-s>",
          node_decremental = "<M-space>",
        },
      },
      textobjects = {
        select = {
          enable = true,
          lookahead = true,
          keymaps = {
            ["aa"] = "@parameter.outer",
            ["ia"] = "@parameter.inner",
            ["af"] = "@function.outer",
            ["if"] = "@function.inner",
            ["ac"] = "@class.outer",
            ["ic"] = "@class.inner",
          },
        },
        move = {
          enable = true,
          set_jumps = true,
          goto_next_start = {
            ["]m"] = "@function.outer",
            ["]]"] = "@class.outer",
          },
          goto_next_end = {
            ["]M"] = "@function.outer",
            ["]["] = "@class.outer",
          },
          goto_previous_start = {
            ["[m"] = "@function.outer",
            ["[["] = "@class.outer",
          },
          goto_previous_end = {
            ["[M"] = "@function.outer",
            ["[]"] = "@class.outer",
          },
        },
      },
    })
  end,
}