local M = {}

function M.new(raw_renderer)
  local name = raw_renderer.name
  local renderer = require("importgraph.vendor.misclib.module").find("importgraph.handler.renderer." .. name)
  if not renderer then
    return nil, "not found renderer: " .. name
  end
  return renderer
end

return M
