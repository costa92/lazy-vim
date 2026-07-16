-- 复用 opt 参数
local opt = {noremap = true, silent = true }

-- 基础操作
vim.keymap.set("n", "<leader>p", ":set invpaste paste?<CR>", opt) -- 格式化文件中所有代码行（nvim-treesitter 代码格式化）

vim.keymap.set("n", "<leader>=", "gg=G", opt) -- 按缩进重排整个文件（gg=G）；从 <leader>t 让位，避免与 tag/gitsigns 前缀冲突延迟

-- 替代 gcc 的快捷键
-- vim.keymap.set("n", "<leader>c", "gcc", { noremap = true, silent = true }) -- 默认将 leader 设置为反斜杠 '\'
-- 替代 gc% 的快捷键
-- vim.keymap.set("n", "<leader>cc", "gc%", { noremap = true, silent = true })

-- 窗口操作
-- 取消 s 默认功能
vim.keymap.set("n", "s", "", opt)

-- windows 分屏快捷键
vim.keymap.set("n", "sv", ":vsp<CR>", opt)
vim.keymap.set("n", "sh", ":sp<CR>", opt)
vim.keymap.set("n", "sc", "<C-w>c", opt) -- 关闭当前
vim.keymap.set("n", "so", "<C-w>o", opt) -- 关闭其他

-- 简化窗口跳转快捷键
-- 左移窗口；若已在最左（如全宽 quickfix，gr 引用列表所在），fallback 聚焦 neo-tree 侧栏
vim.keymap.set("n", "<C-h>", function()
  local cur = vim.api.nvim_get_current_win()
  vim.cmd("wincmd h")
  if vim.api.nvim_get_current_win() == cur then
    vim.cmd("Neotree focus filesystem left")
  end
end, { desc = "Switch Left Window / Focus Neo-tree" })
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

-- insert 模式下跳到行尾。注意：不给 <C-h> 绑"跳行首"——终端里 <C-h> 与 <BS> 同码，
-- 那样会连退格键一起劫持；<C-h> 保持退格（见文件末尾 <C-H>=<BS>），仅保留 <C-l>=跳行尾。
vim.keymap.set("i", "<C-l>", "<ESC>A", opt)

-- 打开或者关闭 neo-tree
vim.keymap.set("n", "<C-b>", "<Cmd>Neotree toggle<CR>", opt)

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
vim.keymap.set("n", "<C-e>", "<cmd>FzfLua buffers<CR>", { desc = "buffers" })
vim.keymap.set("n", "<leader>r", "<cmd>FzfLua oldfiles<CR>", { desc = "mru" })   --mru: most recent used
vim.keymap.set("n", "<leader>s", "<cmd>FzfLua treesitter<CR>", { desc = "mru" })   --mru: most recent used
vim.keymap.set("n", "<leader>fg", "<cmd>FzfLua live_grep<CR>", { desc = "[FZF] Live grep" }) -- 从 <leader>f 移来，避免整组 <leader>f* 前缀延迟
vim.keymap.set("n", "<leader>h", "<cmd>FzfLua search_history<CR>", { desc = "lines" })
vim.keymap.set("n", "<leader>m", "<cmd>FzfLua marks<CR>", { desc = "lines" })

-- 退出 nvim 前强制断开所有 LSP 和 DAP，避免 :q! 卡住等后台进程清理
vim.api.nvim_create_autocmd("VimLeavePre", {
  group = vim.api.nvim_create_augroup("ForceCleanup", { clear = true }),
  callback = function()
    -- 停掉所有 LSP client（gopls 在大项目上 shutdown 可能要 1-2 秒）
    pcall(function()
      for _, client in ipairs(vim.lsp.get_clients()) do
        client:stop(true) -- force = true（Neovim 0.12 起 vim.lsp.stop_client 已弃用）
      end
    end)
    -- 终止 DAP 会话
    pcall(function()
      local dap = package.loaded["dap"]
      if dap then dap.terminate(); dap.close() end
    end)
  end,
})
vim.keymap.set("n", "<leader>o", "<cmd>FzfLua files<CR>", { desc = "Open file" })  -- 新增：快速打开文件
vim.keymap.set("n", "<leader>gp", "<cmd>FzfLua git_commits<CR>", { desc = "lines" })
vim.keymap.set("n", "<leader>gb", "<cmd>FzfLua git_bcommits<CR>", { desc = "lines" })
vim.keymap.set("n", "<leader>gs", "<cmd>FzfLua git_status<CR>", { desc = "lines" })
-- 修改：将 Ctrl+f 改为 leader+/ ，释放 Ctrl+f 用于向下滚动整屏
vim.keymap.set("n", "<leader>/", "<cmd>FzfLua lgrep_curbuf<CR>", { desc = "Search in current buffer" })

-- Git
-- blame.nvim 使用当前 cwd 找 git 根，如果 cwd 漂到非 git 目录会报
-- "Could not get git root, some features might not work"。
-- 先把窗口 cwd 切到当前文件所在目录（一定在 git 仓库内），再执行 BlameToggle。
vim.keymap.set("n", "<leader>b", function()
  local file = vim.api.nvim_buf_get_name(0)
  if file ~= "" and vim.fn.filereadable(file) == 1 then
    vim.cmd("lcd " .. vim.fn.fnameescape(vim.fs.dirname(file)))
  end
  vim.cmd("BlameToggle")
end, { desc = "[Git] Toggle blame (lcd to file dir first)" })

-- 其他
vim.keymap.set('n', '<S-n>', function()
  vim.wo.number = not vim.wo.number
end, { desc = 'Toggle line numbers' })

-- vim.keymap.set("i", "<C-BS>", "<C-W>")
--vim.keymap.set("i", "<C-H>", "<C-W>")
vim.keymap.set("i", "<C-H>", "<BS>", { noremap = true, silent = true })

vim.keymap.set("n", "<leader>fp", ':echo expand("%:p")<CR>', { desc = "显示当前文件路径" })
vim.keymap.set("n", "<leader>yfp", [[:let @+ = expand("%:p")<CR>]], { desc = "复制当前文件绝对路径" })
-- 相对路径
vim.keymap.set("n", "<leader>fr", ':echo expand("%")<CR>', { desc = "显示当前文件相对路径" })
vim.keymap.set("n", "<leader>yr", [[:let @+ = expand("%")<CR>]], { desc = "复制当前文件相对路径" })

-- 性能监控快捷键
vim.keymap.set("n", "<leader>Pt", function()
  vim.cmd("profile start /tmp/nvim-profile.log")
  vim.cmd("profile func *")
  vim.cmd("profile file *")
  vim.notify("性能分析已开始，保存到 /tmp/nvim-profile.log")
end, { desc = "开始性能分析" })

vim.keymap.set("n", "<leader>Ps", function()
  vim.cmd("profile stop")
  vim.notify("性能分析已停止")
end, { desc = "停止性能分析" })

vim.keymap.set("n", "<leader>PT", function()
  local start_time = vim.fn.reltime()
  vim.cmd("silent! edit /tmp/startup_test_file.txt")
  vim.cmd("silent! write")
  vim.cmd("silent! bdelete")
  local elapsed = vim.fn.reltimestr(vim.fn.reltime(start_time))
  vim.notify("启动时间测试完成: " .. elapsed .. "s")
end, { desc = "测试文件操作性能" })
