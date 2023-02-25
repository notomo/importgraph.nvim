local M = {}

function M.has_parser(language)
  local ok, err = pcall(vim.treesitter.language.add, language)
  if type(err) == "string" and err:match(" no parser ") then
    return false
  end
  if not ok then
    error(err)
  end
  return true
end

function M.get_first_tree_root(source, language)
  vim.validate({ source = { source, { "number", "string" } } })

  if not M.has_parser(language) then
    return nil, ("not found tree-sitter parser for `%s`"):format(language)
  end

  local factory
  if type(source) == "number" then
    factory = vim.treesitter.get_parser
  else
    factory = vim.treesitter.get_string_parser
  end
  local parser = factory(source, language)

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
