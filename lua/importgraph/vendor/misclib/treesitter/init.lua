local M = {}

function M.has_parser(language)
  local parser = vim.treesitter.get_parser(0, language, { error = false })
  return parser ~= nil
end

--- @param source integer|string
--- @param language string
--- @return TSNode|string
function M.get_first_tree_root(source, language)
  if not M.has_parser(language) then
    return ("not found tree-sitter parser for `%s`"):format(language)
  end

  local factory
  if type(source) == "number" then
    factory = vim.treesitter.get_parser
  else
    factory = vim.treesitter.get_string_parser
  end
  local parser = factory(source, language)
  assert(parser, ("failed to get parser: `%s`"):format(language))

  local trees = parser:parse()
  return trees[1]:root()
end

function M.get_captures(match, query, handlers)
  if type(handlers) == "function" then
    local captures = {}
    for id, nodes in pairs(match) do
      for _, node in ipairs(nodes) do
        local captured = query.captures[id]
        handlers(captures, captured, node)
      end
    end
    return captures
  end

  local captures = {}
  for id, nodes in pairs(match) do
    for _, node in ipairs(nodes) do
      local captured = query.captures[id]
      local f = handlers[captured]
      if f then
        f(captures, node)
      end
    end
  end
  return captures
end

return M
