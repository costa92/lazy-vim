return {
  "mg979/vim-visual-multi",
  branch = "master",
  init = function()
    -- 禁用默认映射，以便我们可以自定义
    vim.g.VM_default_mappings = 0

    -- 定义常用快捷键
    -- 进入 Visual Multi 模式并选择下一个匹配项
    vim.g.VM_maps = {
      ["Find Under"] = "<M-d>", -- 使用 Alt+d 选择下一个匹配项
      ["Find Subword Under"] = "<M-d>", -- 对于子词也使用 Alt+d
      ["Select All"] = "<C-A>", -- (示例) 选择所有匹配项
      ["Skip Region"] = "<C-x>", -- 跳过当前区域
      ["Remove Region"] = "<C-p>", -- 移除上一个区域
      -- 你可以在这里添加更多自定义映射，参考 vim-visual-multi 文档
    }

    -- (可选) 配置光标和选区的外观
    -- vim.g.VM_Mono_hl = "Visual"
    -- vim.g.VM_Cursor_hl = "Visual"
    -- vim.g.VM_Extend_hl = "VM_Extend"
    -- vim.highlight.create('VM_Extend', { bg = '#303050' }, false)
  end,
  config = function()
    -- 可以在这里添加 config 函数的内容，如果需要的话
    -- 例如，设置特定的行为
    -- require('visual_multi').setup({ ... })
  end,
} 