-- scripts/patch-neotest-golang.lua
-- 作用：把 neotest-golang 的 treesitter 查询里 (statement_list ...) 包装剥掉。
--
-- 原因：新版 tree-sitter-go 把 _statement_list 规则改成匿名的，查询里
-- `(block (statement_list X))` 会报 "Invalid node type 'statement_list'"。
-- 既然该规则匿名，其子节点就是 block 的直接子节点，所以把包装去掉即可。
--
-- 触发：在 plugins/neotest.lua 的 build hook 里运行，每次安装/更新插件后自动执行。

local function patch_file(path)
  local f = io.open(path, "r")
  if not f then return false end
  local text = f:read("*a")
  f:close()

  local original = text
  -- 重复剥离直到没有 statement_list 残留（处理嵌套场景）
  for _ = 1, 10 do
    local out = {}
    local i = 1
    local changed = false
    while i <= #text do
      if text:sub(i, i + 14) == "(statement_list" then
        changed = true
        local j = i + 15
        while j <= #text and (text:sub(j, j) == "\n" or text:sub(j, j) == " ") do
          j = j + 1
        end
        local depth, body_start = 1, j
        while j <= #text and depth > 0 do
          local c = text:sub(j, j)
          if c == "(" then depth = depth + 1
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

  if text ~= original then
    local w = io.open(path, "w")
    if w then w:write(text); w:close() end
    io.write("patched: " .. path .. "\n")
    return true
  end
  return false
end

local home = os.getenv("HOME") or ""
local base = home .. "/.local/share/nvim/lazy/neotest-golang/lua/neotest-golang/queries/go"
local files = {
  "table_tests_list.scm",
  "table_tests_map.scm",
  "table_tests_unkeyed.scm",
  "table_tests_loop.scm",
  "table_tests_loop_unkeyed.scm",
  "table_tests_inline_field_access.scm",
}
for _, name in ipairs(files) do
  patch_file(base .. "/" .. name)
end
