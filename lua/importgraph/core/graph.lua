local Graph = {}
Graph.__index = Graph

function Graph.new(working_dir, grouping, raw_graph)
  local tbl = {
    _working_dir = working_dir,
    _grouping = grouping,
    _graph = raw_graph or require("importgraph.vendor.misclib.collection.ordered_dict").new(),
  }
  return setmetatable(tbl, Graph)
end

function Graph.add(self, path, imported_targets)
  local group = self._grouping(path, self._working_dir)
  if not group then
    return self
  end
  local raw_graph = self._graph:merge({
    [group] = imported_targets,
  })
  return Graph.new(self._working_dir, self._grouping, raw_graph)
end

function Graph.expose(self)
  local exposed = {}
  for group, imported_targets in self._graph:iter() do
    table.insert(exposed, {
      name = group,
      targets = imported_targets:expose(),
    })
  end
  table.sort(exposed, function(a, b)
    return a.name < b.name
  end)
  return exposed
end

return Graph
