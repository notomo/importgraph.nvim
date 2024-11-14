local M = {}

--- @class ImportgraphOption
--- @field renderer ImportgraphRendererOption?: |ImportgraphRendererOption|
--- @field collector ImportgraphCollectorOption?: |ImportgraphCollectorOption|

--- @class ImportgraphRendererOption
--- @field name string? (default: "mermaid")
--- @field opts table? renderer specific option

--- @class ImportgraphCollectorOption
--- @field working_dir string? (default: ".")
--- @field path_filter (fun(path:string):boolean)?
--- @field imported_target_filter (fun(imported_target:string):boolean)?

--- Returns import graph string
--- @param language string: language name
--- @param opts ImportgraphOption? |ImportgraphOption|
--- @return string # import graph
function M.render(language, opts)
  local rendered = require("importgraph.command").render(language, opts)
  if type(rendered) == "table" then
    error("[importgraph] " .. rendered.err, 0)
  end
  return rendered
end

return M
