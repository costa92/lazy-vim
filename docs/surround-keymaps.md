# nvim-surround 文本环绕

基于 `kylechui/nvim-surround`。用**一组 motion**管理包裹符号（引号、括号、HTML 标签等）。

## 三个核心操作

| 快捷键 | 功能描述 |
|--------|----------|
| `ys<motion><char>` | **Y**ou **S**urround：给 motion 选中的文本加上 `<char>` 环绕 |
| `cs<old><new>` | **C**hange **S**urround：把 `<old>` 环绕换成 `<new>` |
| `ds<char>` | **D**elete **S**urround：删掉 `<char>` 环绕 |

## 常用例子

| 起始文本 | 操作 | 结果 | 说明 |
|---------|------|------|------|
| `hello` | `ysiw"` | `"hello"` | 给 inner word 加双引号 |
| `"hello"` | `cs"'` | `'hello'` | 双引号换单引号 |
| `"hello"` | `ds"` | `hello` | 删掉双引号 |
| `hello world` | `yss)` | `(hello world)` | 整行用括号包 |
| `hello` | `ysiw<em>` | `<em>hello</em>` | 加 HTML 标签 |
| `<em>hello</em>` | `cst<b>` | `<b>hello</b>` | 换 HTML 标签名 |

## 可视模式

1. 用 `v` / `V` 选中文本
2. 按 `S<char>` 添加环绕（大写 S）
3. 例：选中 `hello`，按 `S"` → 变成 `"hello"`

## 记忆要点

- **`s` 代表 surround**，搭配 vim 的 `y`/`c`/`d` 三个基础操作动词
- **括号有左右之分**：
  - `(` / `[` / `{` 会加空格：`( hello )`
  - `)` / `]` / `}` 不加空格：`(hello)`
- **标签 char 用 `t`**：`cst<new>` 只换标签名，保留属性；`csT<new tag="v">` 整个替换
