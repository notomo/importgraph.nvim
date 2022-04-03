local M = {}

function M.get_first_tree_root(str, language)
  if not vim.treesitter.language.require_language(language, nil, true) then
    return nil, ("not found tree-sitter parser for `%s`"):format(language)
  end
  local parser = vim.treesitter.get_string_parser(str, language)
  local trees = parser:parse()
  return trees[1]:root()
end

function M.get_captures(match, query, handlers)
  local captures = {}
  for id, node in pairs(match) do
    local captured = query.captures[id]
    local f = handlers[captured]
    if f then
      f(captures, node)
    end
  end
  return captures
end

return M
