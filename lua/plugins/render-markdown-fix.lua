return {
  "MeanderingProgrammer/render-markdown.nvim",
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
  },
  config = function()
    require("render-markdown").setup({
      latex = { enabled = false },
      -- 让 avante.lua 依赖项声明的 Avante filetype 也渲染 markdown
      file_types = { "markdown", "Avante" },
    })

    -- 注意：不要自定义 `:RenderMarkdown` 用户命令。
    -- 新版 render-markdown.nvim 已经自动注册同名命令，支持子命令：
    --   :RenderMarkdown             -- 等价于 enable
    --   :RenderMarkdown toggle      -- 全局切换
    --   :RenderMarkdown buf_toggle  -- 当前 buffer 切换
    --   :RenderMarkdown enable / disable / buf_enable / buf_disable
    --   :RenderMarkdown expand / contract / preview / log / debug / config
    -- 旧的 M.render() 零参数调用已废弃（新签名需要 context 对象），
    -- 再包一层自定义命令只会 shadow 掉插件本身的命令并报
    -- "attempt to index local 'ctx' (a nil value)"。

    -- 为 .md 文件绑定 buffer-local 快捷键：切换当前 buffer 的 md 渲染
    vim.api.nvim_create_autocmd("FileType", {
      pattern = "markdown",
      callback = function(ev)
        vim.keymap.set("n", "<leader>md", "<cmd>RenderMarkdown buf_toggle<CR>", {
          buffer = ev.buf,
          desc = "[Markdown] Toggle inline render (current buffer)",
        })
      end,
    })
  end,
}
