------------------------------------------------------------------------------  
-- 1. Leader 键  
------------------------------------------------------------------------------  
vim.g.mapleader = " "            -- 设置全局 leader 键为空格  
vim.g.maplocalleader = " "       -- 设置本地 leader 键为空格  

------------------------------------------------------------------------------  
-- 2. 文件与编码  
------------------------------------------------------------------------------  
vim.g.encoding = "UTF-8"         -- Vim 内部使用 UTF-8 编码  
vim.o.fileencoding = "utf-8"     -- 文件默认保存编码为 UTF-8  

------------------------------------------------------------------------------  
-- 3. 光标与滚动  
------------------------------------------------------------------------------  
vim.o.scrolloff = 8              -- 光标上下保留 8 行可见区域  
vim.o.sidescrolloff = 8          -- 光标左右滚动时保留 8 列可见区域  

------------------------------------------------------------------------------  
-- 4. 行号与指示列  
------------------------------------------------------------------------------  
vim.wo.number = false            -- 不显示绝对行号  
vim.wo.relativenumber = false    -- 不显示相对行号  
vim.wo.cursorline = false        -- 不高亮当前行  
vim.wo.signcolumn = "no"         -- 不显示左侧指示符符号列  

------------------------------------------------------------------------------  
-- 5. 折叠 (Folding)  
------------------------------------------------------------------------------  
vim.opt.foldenable = true        -- 默认开启文件折叠  
vim.opt.foldnestmax = 1          -- 最大折叠层数为 1  
vim.wo.foldmethod = 'expr'       -- 使用表达式进行折叠  
vim.wo.foldexpr = 'nvim_treesitter#foldexpr()' -- 使用 treesitter 进行折叠  
vim.wo.foldlevel = 1             -- 打开文件时折叠层级为 1  

------------------------------------------------------------------------------  
-- 6. 缩进与 Tab  
------------------------------------------------------------------------------  
vim.o.tabstop = 4                -- Tab 显示为 4 个空格宽度  
vim.bo.tabstop = 4  
vim.o.softtabstop = 4            -- 插入模式下 Tab 的软宽度  
vim.o.shiftround = true          -- >> << 时对齐到 shiftwidth 的倍数  
vim.o.shiftwidth = 4             -- 自动缩进时每级缩进为 4 个空格  
vim.bo.shiftwidth = 4  
vim.o.expandtab = true           -- 将 Tab 转为空格  
vim.bo.expandtab = true  
vim.o.autoindent = true          -- 自动继承上一行缩进  
vim.bo.autoindent = true  
vim.o.smartindent = true         -- 根据语法自动缩进  

------------------------------------------------------------------------------  
-- 7. 文件自动保存与读取  
------------------------------------------------------------------------------  
vim.o.autowrite = true           -- 切换 buffer 时自动保存  
vim.o.autoread = true            -- 外部修改文件后自动重新加载  
vim.bo.autoread = true  

------------------------------------------------------------------------------  
-- 8. 搜索  
------------------------------------------------------------------------------  
vim.o.ignorecase = true          -- 搜索时忽略大小写  
vim.o.smartcase = true           -- 若有大写字母，则开启智能大小写搜索  
vim.o.hlsearch = true            -- 高亮搜索结果  
vim.o.incsearch = true           -- 边输入边搜索  

------------------------------------------------------------------------------  
-- 9. 历史记录与命令行  
------------------------------------------------------------------------------  
vim.o.cmdheight = 1              -- 命令行高度为 1  
vim.o.history = 1000             -- 历史记录数量  
vim.o.backspace = "indent,eol,start"  
vim.o.whichwrap = 'b,s,<,>,[,],~' -- 允许在行首尾使用 <Left>/<Right> 跨行移动  

------------------------------------------------------------------------------  
-- 10. 延迟与交互  
------------------------------------------------------------------------------  
vim.o.updatetime = 300           -- 触发自动保存及 CursorHold 事件的时间  
vim.o.timeoutlen = 500           -- 等待映射连击的时间（毫秒）  

------------------------------------------------------------------------------  
-- 11. 窗口拆分与折行  
------------------------------------------------------------------------------  
vim.o.splitbelow = true          -- 水平分割窗口时，新窗口显示在下方  
vim.o.splitright = true          -- 垂直分割窗口时，新窗口显示在右侧  
vim.wo.wrap = true               -- 自动折行  
vim.o.whichwrap = "<,>,[,]"      -- 光标在行首尾时允许向上一行或下一行移动  

------------------------------------------------------------------------------  
-- 12. 缓冲区与鼠标支持  
------------------------------------------------------------------------------  
vim.o.hidden = true              -- 允许切换未经保存的 buffer  
vim.o.mouse = "a"                -- 启用鼠标支持  

------------------------------------------------------------------------------  
-- 13. 备份与 Undo  
------------------------------------------------------------------------------  
vim.o.backup = false             -- 禁用备份文件  
vim.o.writebackup = false        -- 禁用写入时备份  
vim.opt.undofile = true          -- 启用持久化 Undo  
vim.opt.swapfile = false         -- 禁用交换文件  

------------------------------------------------------------------------------  
-- 14. 自动补全与提示  
------------------------------------------------------------------------------  
vim.g.completeopt = "menu,menuone,noselect,noinsert"  
                                -- 设定自动补全选项  
vim.o.shortmess = vim.o.shortmess .. "c"  
                                -- 不将某些消息显示到补全菜单  
vim.o.pumheight = 10            -- 自动补全弹出菜单最多显示 10 行  
vim.o.showtabline = 2           -- 始终显示标签页  
vim.o.showmode = false          -- 不在状态栏显示当前模式（由插件代替）  

------------------------------------------------------------------------------  
-- 15. 终端颜色与字符显示  
------------------------------------------------------------------------------  
vim.o.termguicolors = true      -- 启用 24 位色  
vim.opt.termguicolors = true  
vim.o.list = false              -- 不显示不可见字符  
vim.o.listchars = "space:·,tab:··"  
                                -- 定义空格和 Tab 的可见字符  
vim.o.wildmenu = true           -- 命令行补全时显示菜单  

------------------------------------------------------------------------------  
-- 16. 系统剪切板  
------------------------------------------------------------------------------  
vim.opt.clipboard = "unnamedplus"  -- 使用系统剪贴板 

vim.opt.termguicolors = fals
