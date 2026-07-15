return {
  -- If you want neo-tree's file operations to work with LSP (updating imports, etc.), you can use a plugin like
  -- https://github.com/antosha417/nvim-lsp-file-operations:
  -- {
  --   "antosha417/nvim-lsp-file-operations",
  --   dependencies = {
  --     "nvim-lua/plenary.nvim",
  --     "nvim-neo-tree/neo-tree.nvim",
  --   },
  --   config = function()
  --     require("lsp-file-operations").setup()
  --   end,
  -- },
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
      "MunifTanjim/nui.nvim",
      -- {"3rd/image.nvim", opts = {}}, -- Optional image support in preview window: See `# Preview Mode` for more information
      {
        "s1n7ax/nvim-window-picker", -- for open_with_window_picker keymaps
        version = "2.*",
        config = function()
          require("window-picker").setup({
            filter_rules = {
              include_current_win = false,
              autoselect_one = true,
              -- filter using buffer options
              bo = {
                -- if the file type is one of following, the window will be ignored
                filetype = { "neo-tree", "neo-tree-popup", "notify" },
                -- if the buffer type is one of following, the window will be ignored
                buftype = { "terminal", "quickfix" },
              },
            },
          })
        end,
      },
    },
    -----Instead of using `config`, you can use `opts` instead, if you'd like:
    -----@module "neo-tree"
    -----@type neotree.Config
    --opts = {},
    config = function()
      -- If you want icons for diagnostic errors, you'll need to define them somewhere.
      -- In Neovim v0.10+, you can configure them in vim.diagnostic.config(), like:
      --
      -- vim.diagnostic.config({
      --   signs = {
      --     text = {
      --       [vim.diagnostic.severity.ERROR] = '',
      --       [vim.diagnostic.severity.WARN] = '',
      --       [vim.diagnostic.severity.INFO] = '',
      --       [vim.diagnostic.severity.HINT] = '������',
      --     },
      --   }
      -- })
      --
      -- In older versions, you can define the signs manually:
      -- vim.fn.sign_define("DiagnosticSignError", { text = " ", texthl = "DiagnosticSignError" })
      -- vim.fn.sign_define("DiagnosticSignWarn", { text = " ", texthl = "DiagnosticSignWarn" })
      -- vim.fn.sign_define("DiagnosticSignInfo", { text = " ", texthl = "DiagnosticSignInfo" })
      -- vim.fn.sign_define("DiagnosticSignHint", { text = "������", texthl = "DiagnosticSignHint" })

      require("neo-tree").setup({
        close_if_last_window = true, -- Close Neo-tree if it is the last window left in the tab
        popup_border_style = "rounded",
        enable_git_status = true,
        enable_diagnostics = true,

        -- 添加以下设置解决 TreeSitter 冲突
        use_libuv_file_watcher = false, -- 禁用 libuv 文件监视器
        use_popups_for_input = true,    -- 使用弹出窗口获取输入
        log_level = "warn",             -- 减少日志级别
        log_to_file = false,            -- 禁用文件日志
        
        -- 最小化事件处理器，只保留核心功能
        event_handlers = {
          {
            event = "file_opened",
            handler = function()
              return false -- 简单阻止跟随
            end
          }
        },

        open_files_do_not_replace_types = { "terminal", "trouble", "qf" }, -- when opening files, do not use windows containing these filetypes or buftypes
        open_files_using_relative_paths = false,
        sort_case_insensitive = false, -- used when sorting files and directories in the tree
        sort_function = nil, -- use a custom function for sorting files and directories in the tree
        -- sort_function = function (a,b)
        --       if a.type == b.type then
        --           return a.path > b.path
        --       else
        --           return a.type > b.type
        --       end
        --   end , -- this sorts files and directories descendantly
        default_component_configs = {
          container = {
            enable_character_fade = true,
          },
          indent = {
            indent_size = 2,
            padding = 1, -- extra padding on left hand side
            -- indent guides
            with_markers = true,
            indent_marker = "│",
            last_indent_marker = "└",
            highlight = "NeoTreeIndentMarker",
            -- expander config, needed for nesting files
            with_expanders = nil, -- if nil and file nesting is enabled, will enable expanders
            expander_collapsed = "",
            expander_expanded = "",
            expander_highlight = "NeoTreeExpander",
          },
          icon = {
            folder_closed = "",
            folder_open = "",
            folder_empty = "",
            provider = function(icon, node, state) -- default icon provider utilizes nvim-web-devicons if available
              if node.type == "file" or node.type == "terminal" then
                local success, web_devicons = pcall(require, "nvim-web-devicons")
                local name = node.type == "terminal" and "terminal" or node.name
                if success then
                  local devicon, hl = web_devicons.get_icon(name)
                  icon.text = devicon or icon.text
                  icon.highlight = hl or icon.highlight
                end
              end
            end,
            -- The next two settings are only a fallback, if you use nvim-web-devicons and configure default icons there
            -- then these will never be used.
            default = "*",
            highlight = "NeoTreeFileIcon",
          },
          modified = {
            symbol = "[+]",
            highlight = "NeoTreeModified",
          },
          name = {
            trailing_slash = false,
            use_git_status_colors = true,
            highlight = "NeoTreeFileName",
          },
          git_status = {
            symbols = {
              -- Change type
              added = "", -- or "✚", but this is redundant info if you use git_status_colors on the name
              modified = "", -- or "", but this is redundant info if you use git_status_colors on the name
              deleted = "✖", -- this can only be used in the git_status source
              renamed = "󰁕", -- this can only be used in the git_status source
              -- Status type
              untracked = "",
              ignored = "",
              unstaged = "󰄱",
              staged = "",
              conflict = "",
            },
          },
          -- If you don't want to use these columns, you can set `enabled = false` for each of them individually
          file_size = {
            enabled = true,
            width = 12, -- width of the column
            required_width = 64, -- min width of window required to show this column
          },
          type = {
            enabled = true,
            width = 10, -- width of the column
            required_width = 122, -- min width of window required to show this column
          },
          last_modified = {
            enabled = true,
            width = 20, -- width of the column
            required_width = 88, -- min width of window required to show this column
          },
          created = {
            enabled = true,
            width = 20, -- width of the column
            required_width = 110, -- min width of window required to show this column
          },
          symlink_target = {
            enabled = false,
          },
        },
        -- A list of functions, each representing a global custom command
        -- that will be available in all sources (if not overridden in `opts[source_name].commands`)
        -- see `:h neo-tree-custom-commands-global`
        commands = {},
        window = {
          position = "left",
          width = 40,
          mapping_options = {
            noremap = true,
            nowait = true,
          },
          mappings = {
            -- 终端下 Ctrl+h 等同于 <BS>，禁用 <BS> 的 navigate_up 行为，
            -- 并让 <C-h> 切换到左窗口，避免跳到电脑根目录
            ["<BS>"] = "noop",
            ["<C-h>"] = function()
              vim.cmd("wincmd h")
            end,
            -- 默认 <C-b>=scroll_preview，会覆盖全局的 :Neotree toggle，这里改为关闭窗口
            ["<C-b>"] = "close_window",
            ["<space>"] = {
              "toggle_node",
              nowait = false, -- disable `nowait` if you have existing combos starting with this char that you want to use
            },
            ["<2-LeftMouse>"] = "open",
            ["<cr>"] = "open",
            ["<esc>"] = "cancel", -- close preview or floating neo-tree window
            ["P"] = { "toggle_preview", config = { use_float = true, use_image_nvim = true } },
            -- Read `# Preview Mode` for more information
            ["l"] = "focus_preview",
            ["S"] = "open_split",
            ["s"] = "open_vsplit",
            -- ["S"] = "split_with_window_picker",
            -- ["s"] = "vsplit_with_window_picker",
            ["t"] = "open_tabnew",
            -- ["<cr>"] = "open_drop",
            -- ["t"] = "open_tab_drop",
            ["w"] = "open_with_window_picker",
            --["P"] = "toggle_preview", -- enter preview mode, which shows the current node without focusing
            ["C"] = "close_node",
            -- ['C'] = 'close_all_subnodes',
            ["z"] = "close_all_nodes",
            --["Z"] = "expand_all_nodes",
            ["a"] = {
              "add",
              -- this command supports BASH style brace expansion ("x{a,b,c}" -> xa,xb,xc). see `:h neo-tree-file-actions` for details
              -- some commands may take optional config options, see `:h neo-tree-mappings` for details
              config = {
                show_path = "none", -- "none", "relative", "absolute"
              },
            },
            ["A"] = "add_directory", -- also accepts the optional config.show_path option like "add". this also supports BASH style brace expansion.
            ["d"] = "delete",
            ["r"] = "rename",
            ["b"] = "rename_basename",
            ["y"] = "copy_to_clipboard",
            ["x"] = "cut_to_clipboard",
            ["p"] = "paste_from_clipboard",
            ["c"] = "copy", -- takes text input for destination, also accepts the optional config.show_path option like "add":
            -- ["c"] = {
            --  "copy",
            --  config = {
            --    show_path = "none" -- "none", "relative", "absolute"
            --  }
            --}
            ["m"] = "move", -- takes text input for destination, also accepts the optional config.show_path option like "add".
            ["q"] = "close_window",
            ["R"] = "refresh",
            ["?"] = "show_help",
            ["<"] = "prev_source",
            [">"] = "next_source",
            ["i"] = "show_file_details",
            -- ["i"] = {
            --   "show_file_details",
            --   -- format strings of the timestamps shown for date created and last modified (see `:h os.date()`)
            --   -- both options accept a string or a function that takes in the date in seconds and returns a string to display
            --   -- config = {
            --   --   created_format = "%Y-%m-%d %I:%M %p",
            --   --   modified_format = "relative", -- equivalent to the line below
            --   --   modified_format = function(seconds) return require('neo-tree.utils').relative_date(seconds) end
            --   -- }
            -- },
          },
        },
        nesting_rules = {},
        filesystem = {
          filtered_items = {
            visible = false, -- when true, they will just be displayed differently than normal items
            hide_dotfiles = false,  -- 修改这里：显示以 . 开头的文件
            hide_gitignored = false,  -- gitignored 文件默认显示，无需按 H 切换
            hide_hidden = true, -- only works on Windows for hidden files/directories
            hide_by_name = {
              --"node_modules"
            },
            hide_by_pattern = { -- uses glob style patterns
              --"*.meta",
              --"*/src/*/tsconfig.json",
            },
            always_show = { -- remains visible even if other settings would normally hide it
              --".gitignored",
            },
            always_show_by_pattern = { -- uses glob style patterns
              --".env*",
            },
            never_show = { -- remains hidden even if visible is toggled to true, this overrides always_show
              --".DS_Store",
              --"thumbs.db"
            },
            never_show_by_pattern = { -- uses glob style patterns
              --".null-ls_*",
            },
          },
          follow_current_file = {
            enabled = false, -- 完全禁用自动跟随
            leave_dirs_open = false,
          },

          -- 关掉 neo-tree root 与 Neovim cwd 的双向绑定
          -- 否则 nvim-rooter 改 cwd 或任何 navigate_up 都会把根目录拉到电脑根
          bind_to_cwd = false,
          cwd_target = {
            sidebar = "none",
            current = "none",
          },

          group_empty_dirs = false, -- when true, empty folders will be grouped together
          hijack_netrw_behavior = "open_default", -- netrw disabled, opening a directory opens neo-tree
          -- in whatever position is specified in window.position
          -- "open_current",  -- netrw disabled, opening a directory opens within the
          -- window like netrw would, regardless of window.position
          -- "disabled",    -- netrw left alone, neo-tree does not handle opening dirs
          use_libuv_file_watcher = false, -- This will use the OS level file watchers to detect changes
          -- instead of relying on nvim autocmd events.
          window = {
            mappings = {
              ["<bs>"] = "noop",
              ["."] = "set_root",
              ["H"] = "toggle_hidden",
              ["/"] = "fuzzy_finder",
              ["D"] = "fuzzy_finder_directory",
              ["#"] = "fuzzy_sorter", -- fuzzy sorting using the fzy algorithm
              -- ["D"] = "fuzzy_sorter_directory",
              ["f"] = "filter_on_submit",
              ["<c-x>"] = "clear_filter",
              ["[g"] = "prev_git_modified",
              ["]g"] = "next_git_modified",
              ["o"] = {
                "show_help",
                nowait = false,
                config = { title = "Order by", prefix_key = "o" },
              },
              ["oc"] = { "order_by_created", nowait = false },
              ["od"] = { "order_by_diagnostics", nowait = false },
              ["og"] = { "order_by_git_status", nowait = false },
              ["om"] = { "order_by_modified", nowait = false },
              ["on"] = { "order_by_name", nowait = false },
              ["os"] = { "order_by_size", nowait = false },
              ["ot"] = { "order_by_type", nowait = false },
              -- ['<key>'] = function(state) ... end,
            },
            fuzzy_finder_mappings = { -- define keymaps for filter popup window in fuzzy_finder_mode
              ["<down>"] = "move_cursor_down",
              ["<C-n>"] = "move_cursor_down",
              ["<up>"] = "move_cursor_up",
              ["<C-p>"] = "move_cursor_up",
              ["<esc>"] = "close",
              -- ['<key>'] = function(state, scroll_padding) ... end,
            },
          },

          commands = {}, -- Add a custom command or override a global one using the same function name
        },
        buffers = {
          follow_current_file = {
            enabled = false, -- 完全禁用自动跟随，防止 gd 跳转时切换项目目录
            leave_dirs_open = false,
          },
          
          group_empty_dirs = true, -- when true, empty folders will be grouped together
          show_unloaded = true,
          window = {
            mappings = {
              ["d"] = "buffer_delete",
              ["bd"] = "buffer_delete",
              ["<bs>"] = "noop",
              ["."] = "set_root",
              ["o"] = {
                "show_help",
                nowait = false,
                config = { title = "Order by", prefix_key = "o" },
              },
              ["oc"] = { "order_by_created", nowait = false },
              ["od"] = { "order_by_diagnostics", nowait = false },
              ["om"] = { "order_by_modified", nowait = false },
              ["on"] = { "order_by_name", nowait = false },
              ["os"] = { "order_by_size", nowait = false },
              ["ot"] = { "order_by_type", nowait = false },
            },
          },
        },
        git_status = {
          window = {
            position = "float",
            mappings = {
              ["A"] = "git_add_all",
              ["gu"] = "git_unstage_file",
              ["ga"] = "git_add_file",
              ["gr"] = "git_revert_file",
              ["gc"] = "git_commit",
              ["gp"] = "git_push",
              ["gg"] = "git_commit_and_push",
              ["o"] = {
                "show_help",
                nowait = false,
                config = { title = "Order by", prefix_key = "o" },
              },
              ["oc"] = { "order_by_created", nowait = false },
              ["od"] = { "order_by_diagnostics", nowait = false },
              ["om"] = { "order_by_modified", nowait = false },
              ["on"] = { "order_by_name", nowait = false },
              ["os"] = { "order_by_size", nowait = false },
              ["ot"] = { "order_by_type", nowait = false },
            },
          },
        },
      })

      vim.keymap.set("n", "<leader>ee", "<Cmd>Neotree reveal<CR>", { desc = "[Neo-tree] Reveal current file" })
      
      -- 简化的 gd 跳转，依赖事件处理器保护根目录
      vim.keymap.set("n", "gd", function()
        vim.lsp.buf.definition()
      end, { desc = "Go to definition (protected by Neo-tree event handlers)" })
      
      -- 禁用 Neo-tree 窗口中的 LSP 快捷键
      vim.api.nvim_create_autocmd("FileType", {
        pattern = { "neo-tree", "neo-tree-popup" },
        callback = function(ev)
          -- 用 vim.schedule 推迟到 neo-tree 自己设置完 buffer 映射之后再覆盖
          vim.schedule(function()
            if not vim.api.nvim_buf_is_valid(ev.buf) then return end
            local opts = { buffer = ev.buf, silent = true, nowait = true }
            -- 在 Neo-tree 中覆盖 LSP 快捷键为无操作
            vim.keymap.set("n", "gd", "<Nop>", opts)
            vim.keymap.set("n", "gr", "<Nop>", opts)
            vim.keymap.set("n", "gi", "<Nop>", opts)
            vim.keymap.set("n", "gD", "<Nop>", opts)
            vim.keymap.set("n", "K", "<Nop>", opts)
            -- 终端里 Ctrl+h 会被当作 <BS> 发送，neo-tree 默认 <BS>=navigate_up
            -- 会把根目录一路往上翻到 /，所以在这里用 buffer 本地映射彻底禁用
            vim.keymap.set("n", "<BS>", "<Nop>", opts)
            vim.keymap.set("n", "<C-h>", "<C-w>h", opts)
            -- 保证 <C-b> 在 neo-tree 里关闭窗口，和外部切换键一致
            vim.keymap.set("n", "<C-b>", "<Cmd>Neotree close<CR>", opts)
          end)
        end,
      })
    end,
  },
}
