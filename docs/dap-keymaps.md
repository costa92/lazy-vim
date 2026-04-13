# DAP 调试快捷键

基于 `nvim-dap` + `nvim-dap-ui` + `nvim-dap-go` + `nvim-dap-virtual-text`。

## 前置要求

在 `:Mason` 里安装对应语言的调试适配器：
- **Go**：`delve`
- **前端/JS/TS**（可选）：`js-debug-adapter`

## 断点

| 快捷键 | 功能描述 |
|--------|----------|
| `<leader>db` | 在当前行打/删断点 |
| `<leader>dB` | 设置条件断点（弹窗输入条件表达式） |

## 控制调试会话

| 快捷键 | 功能描述 |
|--------|----------|
| `<leader>dc` | 开始调试 / 继续运行到下一个断点 |
| `<leader>di` | Step Into（步入函数） |
| `<leader>do` | Step Over（单步跳过） |
| `<leader>dO` | Step Out（跳出函数） |
| `<leader>dt` | 终止调试会话 |

## 查看状态

| 快捷键 | 功能描述 |
|--------|----------|
| `<leader>du` | 切换调试 UI 面板（变量、调用栈、断点、REPL） |
| `<leader>dK` | 悬浮显示光标下变量的值 |
| `<leader>dr` | 打开 DAP REPL（交互式求值） |

## Go 专属

| 快捷键 | 功能描述 |
|--------|----------|
| `<leader>dgt` | 调试当前光标所在的 Go 测试函数 |
| `<leader>dgl` | 调试上一次运行的 Go 测试 |

## 自动行为

- 调试开始时 `dapui` 自动打开；会话结束自动关闭
- 断点用红色实心圆 `●` 显示，条件断点用菱形 `◆`，当前停靠行用箭头 `▶` 高亮
- 虚拟文本（`nvim-dap-virtual-text`）会在变量旁直接显示当前值
