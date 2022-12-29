local M = {}

--- Returns import graph string
--- @param opts table|nil: TODO
--- @return string: import graph
function M.render(opts)
  local rendered, err = require("importgraph.command").render(opts)
  if err then
    error("[importgraph] " .. err, 0)
  end
  return rendered
end

return M
