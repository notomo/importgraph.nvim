local M = {}

--- Returns import graph string
--- @param language string: language name
--- @param opts table|nil: TODO
--- @return string: import graph
function M.render(language, opts)
  local rendered, err = require("importgraph.command").render(language, opts)
  if err then
    require("importgraph.vendor.misclib.message").error(err)
  end
  return rendered
end

return M
