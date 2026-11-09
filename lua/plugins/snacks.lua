-- 只启用 image 模块：在 kitty 里把 markdown 的 mermaid 块经 mmdc 渲染成图贴在块下方。
-- 依赖外部命令 mmdc（npm i -g @mermaid-js/mermaid-cli）与 magick。
return {
  "folke/snacks.nvim",
  -- 有意 eager：image 在 BufReadPre 时 setup，按 ft 懒加载会错过首个 md buffer
  lazy = false,
  init = function()
    -- puppeteer 自带的 chrome-headless-shell 下载不下来，改用系统 chrome
    if not vim.env.PUPPETEER_EXECUTABLE_PATH and vim.fn.executable("google-chrome") == 1 then
      vim.env.PUPPETEER_EXECUTABLE_PATH = vim.fn.exepath("google-chrome")
    end
  end,
  opts = {
    image = { enabled = true },
  },
}
