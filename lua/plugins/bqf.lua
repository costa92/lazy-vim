-- nvim-bqf：增强原生 quickfix —— 光标停在某条(如 gr 引用列表)时，右侧浮窗实时预览
-- 该位置的代码上下文，回车才真正跳过去。加载时机(ft = "qf")在 lazy.lua 声明。
-- 预览的语法高亮会自动复用已装的 nvim-treesitter；未命中时回退到基础高亮，无需额外依赖。
return {
    "kevinhwang91/nvim-bqf",
    ft = "qf",
    opts = {
        preview = {
            auto_preview = true, -- 光标移动即预览(默认开，显式声明表意)
            winblend = 0,        -- 预览浮窗不透明，配色更清晰
        },
    },
}
