local M = {}

function M.render(language, raw_opts)
  vim.validate({ language = { language, "string" } })
  local opts = require("importgraph.core.option").new(raw_opts)

  local graph_factory = require("importgraph.core.graph_factory").new(
    opts.collector.working_dir,
    language,
    opts.collector.imported_target_filter
  )
  if type(graph_factory) == "string" then
    local err = graph_factory
    return { err = err }
  end

  local paths = require("importgraph.core.file_path").collect(opts.collector.working_dir, opts.collector.path_filter)

  local graph = graph_factory:create(paths)
  if type(graph) == "string" then
    local err = graph
    return { err = err }
  end

  local render = require("importgraph.core.renderer").new(opts.renderer)
  if type(render) == "string" then
    local err = render
    return { err = err }
  end

  return render(graph)
end

return M
