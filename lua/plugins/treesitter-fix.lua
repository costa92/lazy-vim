-- nvim-treesitter `main` 分支：模块化 API 已被移除。
-- highlight / indent / fold 改成 nvim 内建 API + FileType autocmd 触发。
-- 解析器通过 `require('nvim-treesitter').install{...}` 异步安装，
-- 不再有 `ensure_installed`。`incremental_selection` 在 main 分支没有
-- 对应模块（旧 <C-space> 快捷键失效，需要的话用 mini.ai 之类替代）。
local parsers = {
  "go", "lua", "yaml", "json", "markdown", "markdown_inline",
  "bash", "vim", "vimdoc", "query",
}

return {
  "nvim-treesitter/nvim-treesitter",
  branch = "main",
  build = ":TSUpdate",
  config = function()
    require("nvim-treesitter").setup()
    require("nvim-treesitter").install(parsers)

    vim.api.nvim_create_autocmd("FileType", {
      pattern = parsers,
      callback = function(ev)
        pcall(vim.treesitter.start, ev.buf)
        vim.bo[ev.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        -- 折叠：原生 treesitter foldexpr，仅对当前有解析器的 buffer 启用
        vim.wo[0][0].foldmethod = "expr"
        vim.wo[0][0].foldexpr = "v:lua.vim.treesitter.foldexpr()"
      end,
    })
  end,
}
