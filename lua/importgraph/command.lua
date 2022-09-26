local ReturnValue = require("importgraph.vendor.misclib.error_handler").for_return_value()

function ReturnValue.render(raw_opts)
  local opts = require("importgraph.core.option").new(raw_opts)

  local paths, collect_err =
    require("importgraph.core.file_path").collect(opts.collector.working_dir, opts.collector.path_filter)
  if collect_err then
    return nil, collect_err
  end

  local graph_factory, factory_err =
    require("importgraph.core.graph_factory").new(opts.collector.working_dir, opts.collector.language)
  if factory_err then
    return nil, factory_err
  end

  local graph, graph_err = graph_factory:create(paths)
  if graph_err then
    return nil, graph_err
  end

  local render, err = require("importgraph.core.renderer").new(opts.renderer)
  if err then
    return nil, err
  end
  return render(graph)
end

return ReturnValue:methods()
