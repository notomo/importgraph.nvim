local M = {}

--- Returns import graph string
--- @param opts table|nil: TODO
--- @return string: import graph
function M.render(opts)
  local rendered, err = require("importgraph.command").render(opts)
  if err then
    require("importgraph.vendor.misclib.message").error(err)
  end
  return rendered
end

return M
