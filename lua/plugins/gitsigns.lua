return {
  "lewis6991/gitsigns.nvim",
  event = "BufReadPre",
  config = function()
    require('gitsigns').setup({
      signs = {
        add          = { text = '│' },
        change       = { text = '│' },
        delete       = { text = '_' },
        topdelete    = { text = '‾' },
        changedelete = { text = '~' },
        untracked    = { text = '┆' },
      },
      signcolumn = true,  -- 在左侧显示 git 状态标记
      numhl      = false, -- 不高亮行号
      linehl     = false, -- 不高亮整行
      word_diff  = false, -- 不显示单词级别的 diff
      watch_gitdir = {
        follow_files = true
      },
      attach_to_untracked = true,
      current_line_blame = false, -- 默认不显示当前行的 blame 信息
      current_line_blame_opts = {
        virt_text = true,
        virt_text_pos = 'eol', -- 'eol' | 'overlay' | 'right_align'
        delay = 500,
        ignore_whitespace = false,
      },
      current_line_blame_formatter = '<author>, <author_time:%Y-%m-%d> - <summary>',
      sign_priority = 6,
      update_debounce = 100,
      status_formatter = nil,
      max_file_length = 40000,
      preview_config = {
        border = 'rounded',
        style = 'minimal',
        relative = 'cursor',
        row = 0,
        col = 1
      },
      on_attach = function(bufnr)
        local gs = package.loaded.gitsigns

        local function map(mode, l, r, opts)
          opts = opts or {}
          opts.buffer = bufnr
          vim.keymap.set(mode, l, r, opts)
        end

        -- 导航到上一个/下一个修改
        map('n', ']c', function()
          if vim.wo.diff then return ']c' end
          vim.schedule(function() gs.next_hunk() end)
          return '<Ignore>'
        end, {expr=true, desc = 'Next git change'})

        map('n', '[c', function()
          if vim.wo.diff then return '[c' end
          vim.schedule(function() gs.prev_hunk() end)
          return '<Ignore>'
        end, {expr=true, desc = 'Previous git change'})

        -- Git 操作
        map('n', '<leader>hs', gs.stage_hunk, { desc = '[Git] Stage hunk' })
        map('n', '<leader>hr', gs.reset_hunk, { desc = '[Git] Reset hunk' })
        map('v', '<leader>hs', function() gs.stage_hunk {vim.fn.line('.'), vim.fn.line('v')} end, { desc = '[Git] Stage hunk' })
        map('v', '<leader>hr', function() gs.reset_hunk {vim.fn.line('.'), vim.fn.line('v')} end, { desc = '[Git] Reset hunk' })
        map('n', '<leader>hS', gs.stage_buffer, { desc = '[Git] Stage buffer' })
        map('n', '<leader>hu', gs.undo_stage_hunk, { desc = '[Git] Undo stage hunk' })
        map('n', '<leader>hR', gs.reset_buffer, { desc = '[Git] Reset buffer' })
        map('n', '<leader>hp', gs.preview_hunk, { desc = '[Git] Preview hunk' })
        map('n', '<leader>hb', function() gs.blame_line{full=true} end, { desc = '[Git] Blame line' })
        map('n', '<leader>hd', gs.diffthis, { desc = '[Git] Diff this' })
        map('n', '<leader>hD', function() gs.diffthis('~') end, { desc = '[Git] Diff this ~' })

        -- 切换显示
        map('n', '<leader>tb', gs.toggle_current_line_blame, { desc = '[Git] Toggle line blame' })
        map('n', '<leader>td', gs.toggle_deleted, { desc = '[Git] Toggle deleted' })
        map('n', '<leader>tg', gs.toggle_signs, { desc = '[Git] Toggle signs' })

        -- 文本对象
        map({'o', 'x'}, 'ih', ':<C-U>Gitsigns select_hunk<CR>', { desc = '[Git] Select hunk' })
      end
    })
  end,
}
