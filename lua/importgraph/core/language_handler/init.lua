local M = {}

function M.new(language, working_dir)
  local LanguageHandler =
    require("importgraph.vendor.misclib.module").find("importgraph.core.language_handler." .. language)
  if LanguageHandler then
    return LanguageHandler.new(working_dir), nil
  end
  return nil, "no language handler: " .. language
end

return M
