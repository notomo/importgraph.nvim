local M = {}

--- @class Option
--- @field renderer RendererOption?: |importgraph.RendererOption|
--- @field collector CollectorOption?: |importgraph.CollectorOption|

--- @class RendererOption
--- @field name string? (default: "mermaid")
--- @field opts table? renderer specific option

--- @class CollectorOption
--- @field working_dir string? (default: ".")
--- @field path_filter (fun(path:string):boolean)?
--- @field imported_target_filter (fun(imported_target:string):boolean)?

--- Returns import graph string
--- @param language string: language name
--- @param opts Option? |importgraph.Option|
--- @return string: import graph
function M.render(language, opts)
  local rendered, err = require("importgraph.command").render(language, opts)
  if err then
    require("importgraph.vendor.misclib.message").error(err)
  end
  return rendered
end

return M
