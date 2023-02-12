local M = {}

function M.new(raw_renderer)
  local name = raw_renderer.name
  local renderer = require("importgraph.vendor.misclib.module").find("importgraph.core.renderer." .. name)
  if not renderer then
    return nil, "not found renderer: " .. name
  end
  local opts = vim.tbl_deep_extend("force", renderer.default_opts, raw_renderer.opts)
  return function(graph)
    return renderer.render(graph, opts)
  end
end

return M
