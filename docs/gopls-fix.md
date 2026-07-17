# gopls 加载失败排查说明

## 问题描述

打开 Go 文件时，gopls 报错且所有 LSP 功能（跳转、补全、悬浮）全部失效：

```
packages.Load error: err: exit status 1: stderr: go: downloading code.hellotalk.com/im/common v1.14.13 go: downloading code.hellotalk.com/infra/logger v0.10.1 go: ...
```

伴随症状：

```
gopls: getting file for InlayHint: no package metadata for file file:///.../xxx_test.go
initial workspace load failed: packages.Load error
```

## 两个误导性表象

排查此类问题时，有两点极易带偏方向，需要先排除：

### 1. `go: downloading ...` 是噪音，不是错因

那些 `downloading` 行只是进度输出。真正的错误在**最后一行**，通常被终端宽度截断到屏幕外。完整错误往往是：

```
go: updates to go.mod needed; to update it:
	go mod tidy
```

消息里出现的旧版本号（如 `im/common v1.14.13`，而 go.mod 里写的是 `v1.18.60`）同样不是问题所在，只是 Go 解析模块图时顺带拉取的旧 `go.mod` 文件。

### 2. `go build ./...` 会骗你

`go build ./...` 可能**完全成功**，让人误判项目没问题。原因是它只编译非测试包，而 gopls 加载时带 `-test=true`，会把测试文件的依赖一并计入。

要复现 gopls 真正看到的东西，必须用带测试的加载方式：

```bash
go vet ./...            # 复现 gopls 的加载视角
go list -e -test ./...  # gopls 内部实际做的事
```

## 根本原因

`go.mod` 中的 `// indirect` 依赖块已过期。升级内部库（如 `code.hellotalk.com/im/common`）后会引入新的传递依赖，若未同步 `go.mod`，Go 会拒绝加载包并要求 `go mod tidy`，gopls 因此拿不到 package metadata。

**这是项目侧的状态问题，不是 Neovim 配置问题**，任何 nvim 配置都无法规避。

## 解决方案

在**项目目录**（不是本仓库）执行：

```bash
go mod tidy -diff   # 非破坏性预览：看它要改什么
go mod tidy         # 确认无误后执行
```

`-diff` 是 Go 1.23+ 提供的预览开关，不修改任何文件。若项目未纳入 git 版本管理，建议先备份 `go.mod` / `go.sum` 再执行 tidy。

## 验证修复

用最初的复现命令验证，而不是只看 gopls 是否还报错：

```bash
go vet ./...                       # 应无输出
go mod tidy -diff                  # 应无输出（已收敛）
gopls check ./path/to/file.go      # 应无输出
```

`gopls check` 无输出是最直接的证据——它此前会输出 `initial workspace load failed`。

之后重启 Neovim（或 `:LspRestart`）。

## 配套：让长报错不被截断

本仓库的 `lua/plugins/notify.lua` 曾用 `render = "compact"` 且未设 `max_width`，nvim-notify 在无宽度上限时不折行，导致上述长报错撑满屏幕、右侧被切掉，关键的 `go: updates to go.mod needed` 被挤到屏幕外——这正是本次排查被拖慢的直接原因。

现已改为：

```lua
render = "wrapped-compact",
max_width = 80,
```

`wrapped-compact` 依据 `max_width` 强制折行（见插件源码 `render/wrapped-compact.lua`），长报错可完整显示。

相关排障命令：

| 命令 | 用途 |
|------|------|
| `:Notifications` | 翻看完整通知历史（通知 3 秒后消失仍可回看） |
| `:checkhealth vim.lsp` | 查看 LSP 整体状态 |
| `:LspLog` | 查看 LSP 日志（需已打开对应文件触发 lspconfig 加载） |

## 相关文件

- `lua/lsp/gopls.lua` —— gopls 配置（`root_dir` 使用 `root_pattern("go.mod", ".git")`）
- `lua/plugins/notify.lua` —— 通知渲染配置
- `docs/ts_ls-fix.md` —— 另一个 LSP 专项修复记录

## 更新日期

2026-07-17
