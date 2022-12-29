local M = {}

local default_grouping = function(path)
  return path
end

function M.new(language)
  local grouping = require("importgraph.vendor.misclib.module").find("importgraph.core.grouping." .. language)
  if grouping then
    return grouping
  end
  return default_grouping
end

return M
