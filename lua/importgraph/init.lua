local M = {}

--- Returns import graph string
--- @param opts table: TODO
--- @return string: import graph
function M.render(opts)
  return require("importgraph.command").render(opts)
end

return M
