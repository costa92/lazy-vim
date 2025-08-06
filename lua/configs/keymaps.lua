-- 复用 opt 参数
local opt = {noremap = true, silent = true }

vim.keymap.set("n", "<leader>i", function()
  require("conform").format({ async = true, lsp_fallback = true })
end, { desc = "Format file" })

-- 窗口操作
-- 取消 s 默认功能
vim.keymap.set("n", "s", "", opt)

-- windows 分屏快捷键
vim.keymap.set("n", "sv", ":vsp<CR>", opt)
vim.keymap.set("n", "sh", ":sp<CR>", opt)
vim.keymap.set("n", "sc", "<C-w>c", opt) -- 关闭当前
vim.keymap.set("n", "so", "<C-w>o", opt) -- 关闭其他

-- 简化窗口跳转快捷键
vim.keymap.set("n", "<C-h>", "<C-w><C-h>", { desc = "Switch Left Window" })
vim.keymap.set("n", "<C-j>", "<C-w><C-j>", { desc = "Switch Lower Window" })
vim.keymap.set("n", "<C-k>", "<C-w><C-k>", { desc = "Switch Upper Window" })
vim.keymap.set("n", "<C-l>", "<C-w><C-l>", { desc = "Switch Right Window" })

-- 上下移动选中文本
vim.keymap.set("v", "J", ":move '>+1<CR>gv=gv", opt) -- 向下移动选中文本
vim.keymap.set("v", "K", ":move '<-2<CR>gv=gv", opt) -- 向上移动选中文本

-- 在插入模式和普通模式下移动当前行
vim.keymap.set("i", "<A-j>", "<Esc>:move .+1<CR>==gi", opt) -- 插入模式下当前行向下移动
vim.keymap.set("i", "<A-k>", "<Esc>:move .-2<CR>==gi", opt) -- 插入模式下当前行向上移动
vim.keymap.set("n", "<A-j>", ":move .+1<CR>==", opt)        -- 普通模式下当前行向下移动
vim.keymap.set("n", "<A-k>", ":move .-2<CR>==", opt)        -- 普通模式下当前行向上移动

-- insert 模式下，跳到行首行尾
vim.keymap.set("i", "<C-h>", "<ESC>I", opt)
vim.keymap.set("i", "<C-l>", "<ESC>A", opt)

-- 打开或者关闭 neo-tree
vim.keymap.set("n", "<C-b>", ":Neotree toggle<CR>", opt)

-- 清除高亮
vim.keymap.set("n", "<ESC>", vim.cmd.nohlsearch, { desc = "Clear Highlights" })
-- 简化退出、保存文件
vim.keymap.set({ "i", "x", "n", "s" }, "<C-q>", vim.cmd.quit, { desc = "Quit File" })
vim.keymap.set({ "i", "x", "n", "s" }, "<C-s>", vim.cmd.write, { desc = "Save File" })

-- Go IDE
-- 绑定 Ctrl+i 快捷键执行 GoFillStruct
-- vim.keymap.set("n", "<C-i>", ":GoFillStruct<CR>", { desc = "Fill Struct in Go" })
vim.keymap.set("n", "<leader>fe", ":GoIfErr<CR>", { desc = "[Go] Insert if err != nil" })
vim.keymap.set("n", "<leader>gf", ":GoFillStruct<CR>", { desc = "[Go] Fill Struct" })
vim.keymap.set("n", "<leader>fc", ":GoFillSwitch<CR>", { desc = "[Go] Fill Switch" })
vim.keymap.set("n", "<leader>ta", ":GoAddTag<CR>", { desc = "[Go] Add Struct Tag" })
vim.keymap.set("n", "<leader>tr", ":GoRmTag<CR>", { desc = "[Go] Remove Struct Tag" })
vim.keymap.set("n", "<leader>tc", ":GoClearTag<CR>", { desc = "[Go] Clear Struct Tag" })

-- LSP 导航快捷键 - 只在支持 LSP 的 buffer 中生效，排除 Neo-tree
vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("UserLspConfig", {}),
  callback = function(ev)
    -- 检查是否是 Neo-tree 或其他特殊文件类型
    local exclude_filetypes = { "neo-tree", "neo-tree-popup", "NvimTree", "alpha", "dashboard" }
    local current_ft = vim.bo[ev.buf].filetype
    
    -- 如果是排除的文件类型，不设置 LSP 快捷键
    for _, ft in ipairs(exclude_filetypes) do
      if current_ft == ft then
        return
      end
    end
    
    local opts = { buffer = ev.buf }
    vim.keymap.set("n", "gd", vim.lsp.buf.definition, vim.tbl_extend("force", opts, { desc = "[LSP] Go to Definition" }))
    vim.keymap.set("n", "gr", vim.lsp.buf.references, vim.tbl_extend("force", opts, { desc = "[LSP] Go to References" }))
    vim.keymap.set("n", "gi", vim.lsp.buf.implementation, vim.tbl_extend("force", opts, { desc = "[LSP] Go to Implementation" }))
    vim.keymap.set("n", "K", vim.lsp.buf.hover, vim.tbl_extend("force", opts, { desc = "Show hover documentation" }))
    vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, vim.tbl_extend("force", opts, { desc = "[LSP] Code actions" }))
    vim.keymap.set("n", "<leader>D", vim.lsp.buf.type_definition, vim.tbl_extend("force", opts, { desc = "[LSP] Type definition" }))
    vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, vim.tbl_extend("force", opts, { desc = "[LSP] Rename" }))
  end,
})

-- FZF LSP 功能作为可选项（如果需要更好的搜索界面）
vim.keymap.set("n", "<leader>fd", "<cmd>FzfLua lsp_definitions<CR>", { desc = "[FZF] LSP Definitions" })
vim.keymap.set("n", "<leader>fR", "<cmd>FzfLua lsp_references<CR>", { desc = "[FZF] LSP References" })
vim.keymap.set("n", "<leader>fi", "<cmd>FzfLua lsp_implementations<CR>", { desc = "[FZF] LSP Implementations" })
vim.keymap.set("n", "<leader>fS", "<cmd>FzfLua lsp_document_symbols<CR>", { desc = "[FZF] Document Symbols" })
vim.keymap.set("n", "<leader>fW", "<cmd>FzfLua lsp_workspace_symbols<CR>", { desc = "[FZF] Workspace Symbols" })

-- 代码检测和诊断快捷键
vim.keymap.set("n", "<leader>l", "<cmd>Lint<CR>", { desc = "[Lint] Run linter on current buffer" })
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "[Diagnostic] Go to previous" })
vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "[Diagnostic] Go to next" })
vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, { desc = "[Diagnostic] Show line diagnostics" })
vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "[Diagnostic] Open quickfix list" })

-- FZF-Lua
vim.keymap.set("n", "<C-e>", "<cmd>FzfLua buffers<CR>", { desc = "[FZF] Buffers" })
vim.keymap.set("n", "<leader>r", "<cmd>FzfLua oldfiles<CR>", { desc = "[FZF] Recent Files" })
vim.keymap.set("n", "<leader>s", "<cmd>FzfLua treesitter<CR>", { desc = "[FZF] Treesitter" })
vim.keymap.set("n", "<leader>f", "<cmd>FzfLua live_grep<CR>", { desc = "[FZF] Live Grep" })
vim.keymap.set("n", "<leader>h", "<cmd>FzfLua search_history<CR>", { desc = "[FZF] Search History" })
vim.keymap.set("n", "<leader>m", "<cmd>FzfLua marks<CR>", { desc = "[FZF] Marks" })
vim.keymap.set("n", "<leader>o", "<cmd>FzfLua files<CR>", { desc = "[FZF] Files" })
vim.keymap.set("n", "<leader>gp", "<cmd>FzfLua git_commits<CR>", { desc = "[FZF] Git Commits" })
vim.keymap.set("n", "<leader>gb", "<cmd>FzfLua git_bcommits<CR>", { desc = "[FZF] Git Branch Commits" })
vim.keymap.set("n", "<leader>gs", "<cmd>FzfLua git_status<CR>", { desc = "[FZF] Git Status" })
vim.keymap.set("n", "<C-f>", "<cmd>FzfLua lgrep_curbuf<CR>", { desc = "[FZF] Grep in Current Buffer" })

-- Git
vim.keymap.set("n", "<leader>b", "<cmd>BlameToggle<CR>", { desc = "lines" })

-- 其他
vim.keymap.set('n', '<S-n>', function()
  vim.wo.number = not vim.wo.number
end, { desc = 'Toggle line numbers' })

-- vim.keymap.set("i", "<C-BS>", "<C-W>")
-- vim.keymap.set("i", "<C-H>", "<C-W>")

vim.keymap.set("n", "<leader>fp", ':echo expand("%:p")<CR>', { desc = "显示当前文件路径" })
vim.keymap.set("n", "<leader>yfp", [[:let @+ = expand("%:p")<CR>]], { desc = "复制当前文件绝对路径" })
-- 相对路径
vim.keymap.set("n", "<leader>fr", ':echo expand("%")<CR>', { desc = "显示当前文件相对路径" })
vim.keymap.set("n", "<leader>yr", [[:let @+ = expand("%")<CR>]], { desc = "复制当前文件相对路径" })

-- 性能监控快捷键
vim.keymap.set("n", "<leader>pt", function()
  vim.cmd("profile start /tmp/nvim-profile.log")
  vim.cmd("profile func *")
  vim.cmd("profile file *")
  vim.notify("性能分析已开始，保存到 /tmp/nvim-profile.log")
end, { desc = "开始性能分析" })

vim.keymap.set("n", "<leader>ps", function()
  vim.cmd("profile stop")
  vim.notify("性能分析已停止")
end, { desc = "停止性能分析" })

vim.keymap.set("n", "<leader>pst", function()
  local start_time = vim.fn.reltime()
  vim.cmd("silent! edit /tmp/startup_test_file.txt")
  vim.cmd("silent! write")
  vim.cmd("silent! bdelete")
  local elapsed = vim.fn.reltimestr(vim.fn.reltime(start_time))
  vim.notify("启动时间测试完成: " .. elapsed .. "s")
end, { desc = "测试文件操作性能" })
