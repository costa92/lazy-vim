return {
  "voldikss/vim-translator",
  init = function()
    vim.g.translator_default_engines = { "google" }
    vim.g.translator_target_lang = "zh"
  end,
  config = function()
    vim.keymap.set("n", "mm", "<Plug>TranslateW", { desc = "Translate Word" })
    vim.keymap.set("n", "mr", "<Plug>TranslateR", { desc = "Translate Word Replace" })
  end,
}
