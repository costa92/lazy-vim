-- scripts/patch-neotest-golang.lua
-- 作用：条件自愈地处理 neotest-golang 的 treesitter 查询与当前 go parser 的兼容性。
--
-- 背景：不同版本的 tree-sitter-go 对 `statement_list` 规则的处理不一致——
--   * 主线/nvim-treesitter main：`statement_list` 是命名节点，
--     upstream 原始查询 `(block (statement_list X))` 可直接编译，无需改动。
--   * 某些版本：`_statement_list` 是匿名规则，上面的查询会报
--     "Invalid node type / Impossible pattern"，需把 (statement_list ...) 包装剥掉。
-- 旧版脚本无条件剥离，一旦 parser 用的是命名版本，反而把本可用的查询打坏
-- （block 不能直接含 short_var_declaration → Impossible pattern → 零测试发现）。
--
-- 本脚本策略（幂等、双向自愈）：
--   1. 先用 git 把 6 个查询文件恢复成 upstream 原始内容（清掉任何历史改动）。
--   2. 若当前 go parser 下原始查询能编译 → 保持原样。
--   3. 若不能编译 → 剥掉 (statement_list ...) 后再试；能编译才写回。
--   4. go parser 不可用（尚未安装）或仍无法编译 → 不动文件，留原始（主线默认）。
--
-- 触发：plugins/neotest.lua 的 build hook 在**当前 nvim 进程内** dofile 执行
--       （需要 vim.treesitter，故不能再用独立 lua 解释器跑）。

local home = os.getenv("HOME") or ""
local repo = home .. "/.local/share/nvim/lazy/neotest-golang"
local rel_dir = "lua/neotest-golang/queries/go"
local base = repo .. "/" .. rel_dir
local files = {
  "table_tests_list.scm",
  "table_tests_map.scm",
  "table_tests_unkeyed.scm",
  "table_tests_loop.scm",
  "table_tests_loop_unkeyed.scm",
  "table_tests_inline_field_access.scm",
}

-- 剥掉 (statement_list ...) 包装（重复直到无残留，处理嵌套）
local function strip_statement_list(text)
  local changed_any = false
  for _ = 1, 10 do
    local out = {}
    local i = 1
    local changed = false
    while i <= #text do
      if text:sub(i, i + 14) == "(statement_list" then
        changed = true
        changed_any = true
        local j = i + 15
        while j <= #text and (text:sub(j, j) == "\n" or text:sub(j, j) == " ") do
          j = j + 1
        end
        local depth, body_start = 1, j
        while j <= #text and depth > 0 do
          local c = text:sub(j, j)
          if c == "(" then
            depth = depth + 1
          elseif c == ")" then
            depth = depth - 1
            if depth == 0 then break end
          end
          j = j + 1
        end
        local body_end = j - 1
        while body_end >= body_start and
              (text:sub(body_end, body_end) == " " or text:sub(body_end, body_end) == "\n") do
          body_end = body_end - 1
        end
        table.insert(out, text:sub(body_start, body_end))
        i = j + 1
      else
        table.insert(out, text:sub(i, i))
        i = i + 1
      end
    end
    text = table.concat(out)
    if not changed then break end
  end
  return text, changed_any
end

-- 当前 go parser 下该查询能否编译
local function compiles(text)
  return pcall(vim.treesitter.query.parse, "go", text)
end

-- go parser 是否可用（未安装时探测会失败）
local function go_parser_ready()
  return (pcall(vim.treesitter.query.parse, "go", "(source_file) @s"))
end

local function read(path)
  local f = io.open(path, "r")
  if not f then return nil end
  local s = f:read("*a")
  f:close()
  return s
end

local function write(path, s)
  local w = io.open(path, "w")
  if not w then return false end
  w:write(s)
  w:close()
  return true
end

-- 1. 先把查询文件恢复成 upstream 原始内容（忽略失败：离线/非 git 时用磁盘现状）
pcall(function()
  vim.fn.system({ "git", "-C", repo, "checkout", "--", rel_dir })
end)

if not go_parser_ready() then
  io.write("patch-neotest-golang: go parser 不可用，保持 upstream 原始查询\n")
  return
end

for _, name in ipairs(files) do
  local path = base .. "/" .. name
  local text = read(path)
  if text then
    if compiles(text) then
      -- 原始查询已兼容当前 parser，无需改动
    else
      local stripped = strip_statement_list(text)
      if compiles(stripped) then
        write(path, stripped)
        io.write("patched (stripped statement_list): " .. name .. "\n")
      else
        io.write("patch-neotest-golang: " .. name .. " 剥离后仍无法编译，保持原样\n")
      end
    end
  end
end
