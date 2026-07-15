-- bufferline.nvim：顶部 buffer 标签栏。
-- 切换/加载说明：
--   * event = "VeryLazy" 让标签栏在启动后即出现（触发器必须写在本文件内，
--     写在 lazy.lua 的 import 行上会被忽略——见 CLAUDE.md 插件约定）。
--   * [b / ]b 循环上一个 / 下一个 buffer；[B / ]B 左移 / 右移当前 buffer。
--   * 已有的 <C-e>(FzfLua buffers) 模糊跳转仍可用，两者互补。
return {
  "akinsho/bufferline.nvim",
  version = "*",
  event = "VeryLazy",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  keys = {
    { "]b", "<cmd>BufferLineCycleNext<cr>", desc = "下一个 buffer" },
    { "[b", "<cmd>BufferLineCyclePrev<cr>", desc = "上一个 buffer" },
    { "]B", "<cmd>BufferLineMoveNext<cr>", desc = "buffer 右移" },
    { "[B", "<cmd>BufferLineMovePrev<cr>", desc = "buffer 左移" },
  },
  opts = {
    options = {
      mode = "buffers",
      diagnostics = "nvim_lsp",       -- 诊断默认全局关闭，开启单 buffer 诊断时这里会显示
      always_show_bufferline = true,
      show_buffer_close_icons = true,
      show_close_icon = false,
      separator_style = "thin",
      -- neo-tree 侧栏打开时，让标签栏为其留出空位、不与之重叠
      offsets = {
        {
          filetype = "neo-tree",
          text = "File Explorer",
          text_align = "center",
          separator = true,
        },
      },
    },
  },
}
