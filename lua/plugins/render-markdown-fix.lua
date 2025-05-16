return {
  "MeanderingProgrammer/render-markdown.nvim",
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
  },
  config = function()
    require("render-markdown").setup({
      latex = { enabled = false }
    })
    
    -- 创建一个命令用于手动触发渲染
    vim.api.nvim_create_user_command("RenderMarkdown", function()
      -- 使用 pcall 捕获可能的错误
      local status, err = pcall(function()
        require("render-markdown").render()
      end)
      
      if not status then
        vim.notify("Markdown 渲染错误: " .. err, vim.log.levels.ERROR)
      end
    end, { desc = "手动渲染 Markdown" })
    
    -- 为 .md 文件创建键映射
    vim.api.nvim_create_autocmd("FileType", {
      pattern = "markdown",
      callback = function()
        vim.keymap.set("n", "<leader>md", "<cmd>RenderMarkdown<CR>", { 
          buffer = true, 
          desc = "渲染 Markdown" 
        })
      end
    })
  end,
} 