-- markdown-preview.nvim 依赖 `app/bin/markdown-preview-linux` 预编译二进制启动预览服务器。
-- 如果 bin/ 目录不存在，插件会 fallback 到 `node app/index.js`，但那需要
-- app/node_modules/ 有装好依赖（tslib、log4js 等），默认是没装的 —— 结果就是
-- 预览压根起不来，浏览器什么都看不到。
-- build 钩子里的 mkdp#util#install() 会调 app/install.sh 去 GitHub Releases 下载
-- 对应平台的预编译二进制，必须跑成功，否则预览不可用。
return {
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    ft = { "markdown" },
    build = function()
        vim.fn["mkdp#util#install"]()
    end,
    lazy = true,
    config = function()
        -- 绑定 <leader>mp 切换浏览器预览。
        -- 不用 buffer-local + FileType autocmd 的原因：
        -- 插件是 `ft = { "markdown" }` 懒加载，打开 md 文件时 FileType 事件已经
        -- 先于插件加载触发，autocmd 来不及绑当前 buffer，结果快捷键用不了。
        -- 改成全局绑定，非 md buffer 里按也无害（命令自己会处理）。
        vim.keymap.set("n", "<leader>mp", "<cmd>MarkdownPreviewToggle<CR>", {
            desc = "[Markdown] Toggle browser preview (supports mermaid)",
        })
    end,
}
