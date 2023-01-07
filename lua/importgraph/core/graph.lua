local Graph = {}
Graph.__index = Graph

function Graph.new(raw_graph)
  local tbl = {
    _graph = raw_graph or require("importgraph.vendor.misclib.collection.ordered_dict").new(),
  }
  return setmetatable(tbl, Graph)
end

function Graph.add(self, group, imported_targets)
  local raw_graph = self._graph:merge({
    [group] = imported_targets,
  })
  return Graph.new(raw_graph)
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
