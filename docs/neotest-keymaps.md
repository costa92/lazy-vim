# Neotest 测试快捷键

基于 `neotest` + `neotest-golang` + `neotest-jest`。

> 提示：键位使用大写 `<leader>T*` 前缀，以避开小写 `<leader>t*` 的现有绑定（Go struct tag、gitsigns toggle 等）。

## 全局快捷键（普通模式下）

### 运行测试

| 快捷键 | 功能描述 |
|--------|----------|
| `<leader>Tn` | 跑光标所在的**单个测试**（nearest）——**光标必须在 `func TestXxx` 函数体内部** |
| `<leader>Tf` | 跑当前文件的全部测试 |
| `<leader>Ts` | 停止正在运行的测试（杀子进程） |

> **只跑单个测试方法**：光标放进目标 `func TestXxx` 函数体内任意一行，按 `<leader>Tn` 即只跑这一个。
> **只跑单个子测试**：光标放到对应的 `t.Run("sub", ...)` 那一行再按 `<leader>Tn`，只跑该子测试。
> 拿不准会不会选错时，用 `<leader>TS` 打开摘要树、移到目标测试按 `r`（见下方「摘要树内快捷键」），绝不会选错。

### 用 DAP 调试测试

| 快捷键 | 功能描述 |
|--------|----------|
| `<leader>Td` | 用 DAP 调试光标所在的测试（需要已装 `delve` / `js-debug-adapter`） |

### 查看结果

| 快捷键 | 功能描述 |
|--------|----------|
| `<leader>To` | 打开当前测试的输出窗口（并进入该窗口） |
| `<leader>Tp` | 切换输出面板（底部常驻，汇总所有测试输出） |
| `<leader>TS` | 切换测试摘要侧边栏（树形展示项目所有测试） |
| `q` | 在输出浮窗 / 输出面板内按 `q` 关闭该窗口（本配置自定义） |

> **`<leader>Tn` 跑完会自动弹出该测试的输出浮窗**（无论成败），看完按 `q` 关闭；也可切到别的窗口让它自动关。批量运行（`<leader>Tf` 等）不会自动弹，只有存在失败时才弹底部面板。

## Summary 树内的专用键位

在 `<leader>TS` 打开的右侧 summary 树里，光标**位于树窗口**时：

| 键 | 功能描述 |
|----|----------|
| `<CR>` | 展开/折叠当前节点（文件/目录） |
| `r` | 跑光标下这个节点（单个测试 / 整个文件 / 整个目录） |
| `R` | 跑整个项目的所有测试 |
| `d` | 用 DAP 调试光标下这个 |
| `o` | 看输出（进入输出窗口） |
| `i` | 浮窗快速预览短输出 |
| `m` | 标记测试（加入 mark 集合） |
| `x` | 停止光标下这个正在跑的测试 |
| `q` | 关闭 summary 侧边栏 |

**推荐工作流**：`<leader>TS` 打开树 → `<C-l>` 切到树窗口 → 移到要跑的测试 → 按 `r`。这个方式**绝不会选错测试**。

## 命令行接口

| 命令 | 等价快捷键 | 说明 |
|------|-----------|------|
| `:Neotest run` | `<leader>Tn` | 跑光标处 |
| `:Neotest run file` | `<leader>Tf` | 跑当前文件 |
| `:Neotest run dir` | — | 跑当前文件所在目录 |
| `:Neotest run name=TestFoo` | — | 按名字跑（支持模糊） |
| `:Neotest run extra_args={'-timeout=5m'}` | — | 临时改参数（绕开默认 30s 超时） |
| `:Neotest stop` | `<leader>Ts` | 停全部 |
| `:Neotest summary` | `<leader>TS` | 开树 |
| `:Neotest output` | `<leader>To` | 看输出 |
| `:Neotest output-panel` | `<leader>Tp` | 切输出面板 |

## 行为说明

### 状态图标

左侧 sign 列和 summary 树会显示：

| 图标 | 含义 |
|------|------|
| `✓` | 通过 |
| `✗` | 失败 |
| `⟳` | 运行中 |
| `○` | 跳过 |
| 空白 | 尚未运行 |

### 自动行为

- **`<leader>Tn` 跑完单个测试**：自动弹出该测试的输出浮窗（无论成败），按 `q` 关闭
- **批量运行（`<leader>Tf` 等）有失败时**：底部输出面板自动弹出，按 `q` 关闭；失败的断言行显示诊断波浪线
- **退出 Neovim 前**：`VimLeavePre` 自动 `Neotest stop`，避免 `:q!` 卡住等 `go test` 结束
- **summary 动画**已禁用（`animated = false`），避免切换时 UI 卡顿

> 实现说明：自动弹输出走自定义 consumer 的 `client.listeners.results`（neotest 并不发 `NeotestTestCompleted` 之类的 User 事件）。单测走输出浮窗、批量失败走底部面板，二者互斥不重复弹。

## 适配器配置

### Go — `neotest-golang`

默认命令：`go test -v -race -count=1 -timeout=30s`

| 参数 | 作用 |
|------|------|
| `-v` | 显示每个测试函数的 PASS/FAIL 和 log 输出 |
| `-race` | 开启竞态检测 |
| `-count=1` | 禁用测试缓存（每次都真跑） |
| `-timeout=30s` | 单个测试 30s 超时自动 panic（避免 hang 时图标永远转） |

其他启用项：
- `dap_go_enabled = true` — `<leader>Td` 用 DAP 调试（需要 `delve`）
- `warn_test_name_dupes = false` — 关闭重名子测试的 ENTER 提示

### JS/TS — `neotest-jest`

默认命令：`npx jest --`，环境变量 `CI=true`，`cwd` 取当前工作目录。

## 常见问题

### "No tests found"

1. 文件名必须以 `_test.go` 结尾（Go 规则）
2. 测试函数签名必须是 `func TestXxx(t *testing.T)`
3. 光标必须在某个测试函数体**内部**（不能在 import / package 行）

### 测试一直转圈不结束

- 默认 30s 超时自动 panic 并显示堆栈
- 想要更长超时：`:Neotest run extra_args={'-timeout=5m'}`
- 手动停：`<leader>Ts` 或树里 `x` 键
- 卡死时核武器：`:!pkill -f "go test"`

### 指定跑某一个具体测试（绕开光标位置）

```vim
:Neotest run name=TestVersionUpgrade
```

或者用 summary 树：`<leader>TS` → 移到测试名 → `r`。
