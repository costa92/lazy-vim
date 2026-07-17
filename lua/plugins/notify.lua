return {
  "rcarriga/nvim-notify",
  event = "VeryLazy",
  config = function()
    local notify = require("notify")
    notify.setup({
      stages = "fade",
      timeout = 3000,
      -- LSP 的长报错（如 gopls workspace load 失败）不折行会被右边界截断，
      -- 真正的错因常在屏幕外。wrapped-compact + max_width 强制折行。
      render = "wrapped-compact",
      max_width = 80,
      top_down = true,
    })
    -- 真正接管 vim.notify（此前 config 为空，插件装了却没启用）
    vim.notify = notify
  end,
}
