return {
  "yetone/avante.nvim",
  event = "VeryLazy", -- 保持延迟加载
  version = false,
  enabled = false, -- 默认禁用，需要时手动启用
  opts = {
    provider = "ollama",
    providers = {
      ollama = {
        model = "deepseek-coder-v2",
      },
      deepseek = {
        endpoint = "https://api.deepseek.com/v1",
        model = "deepseek-chat",
        timeout = 30000,
        temperature = 0,
        api_key = 'DEEPSEEK_API_KEY',
      },
    },
  },
  build = "make",
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    "stevearc/dressing.nvim",
    "nvim-lua/plenary.nvim",
    "MunifTanjim/nui.nvim",
    "nvim-tree/nvim-web-devicons",
    {
      "HakonHarnes/img-clip.nvim",
      event = "VeryLazy",
      opts = {
        default = {
          embed_image_as_base64 = false,
          prompt_for_file_name = false,
          drag_and_drop = { insert_mode = true },
          use_absolute_path = true,
        },
      },
    },
    -- render-markdown.nvim 由 lua/plugins/render-markdown-fix.lua 统一管理
    -- （包含 file_types = { "markdown", "Avante" }），此处仅保留作为依赖声明
    "MeanderingProgrammer/render-markdown.nvim",
  },
}
