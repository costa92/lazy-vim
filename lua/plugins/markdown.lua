return {
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    ft = { "markdown" },
    build = "cd app && npm install",
    lazy = true,
    config = function()
        -- Markdown preview 配置
        vim.g.mkdp_auto_start = 0  -- 打开 markdown 文件时不自动启动预览
        vim.g.mkdp_auto_close = 1  -- 关闭 buffer 时自动关闭预览
        vim.g.mkdp_refresh_slow = 0  -- 实时刷新预览
        vim.g.mkdp_browser = ""  -- 使用系统默认浏览器
    end,
}
