local ok, ls = pcall(require, "luasnip")
if not ok then
  return
end

local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

-- Один и тот же набор на все JS/TS-диалекты, включая *react —
-- раньше он был продублирован и не доезжал до .tsx/.jsx.
local js_like = { "javascript", "javascriptreact", "typescript", "typescriptreact" }

local js_snippets = {
  s("cl", { t "console.log(", i(1), t ")" }),
  s("ce", { t "console.error(", i(1), t ")" }),
}

for _, ft in ipairs(js_like) do
  ls.add_snippets(ft, js_snippets)
end
