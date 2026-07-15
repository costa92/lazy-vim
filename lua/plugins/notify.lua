return {
  "rcarriga/nvim-notify",
  event = "VeryLazy",
  config = function()
    local notify = require("notify")
    notify.setup({
      stages = "fade",
      timeout = 3000,
      render = "compact",
      top_down = true,
    })
    -- 真正接管 vim.notify（此前 config 为空，插件装了却没启用）
    vim.notify = notify
  end,
}
