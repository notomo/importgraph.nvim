local M = {}

function M.new(language)
  local language_handler =
    require("importgraph.vendor.misclib.module").find("importgraph.core.language_handler." .. language)
  if language_handler then
    return language_handler, nil
  end
  return nil, "no language handler: " .. language
end

return M
