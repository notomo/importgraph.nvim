local GraphFactory = {}
GraphFactory.__index = GraphFactory

function GraphFactory.new(working_dir, language)
  local grouping, err = require("importgraph.core.grouping").new(language)
  if err then
    return nil, err
  end

  local query = vim.treesitter.get_query(language, "importgraph")
  local string_unwrapper = require("importgraph.lib.treesitter.string_unwrapper").new(language)

  local tbl = {
    _grouping = grouping,
    _query = query,
    _string_unwrapper = string_unwrapper,
    _working_dir = working_dir,
    _language = language,
  }
  return setmetatable(tbl, GraphFactory)
end

function GraphFactory.create(self, paths)
  local graph = require("importgraph.vendor.misclib.collection.ordered_dict").new()
  for _, path in ipairs(paths) do
    local import_targets, err = self:_create_one(path)
    if err then
      return nil, err
    end
    local group = self._grouping(path, self._working_dir)
    graph[group] = import_targets
  end

  local exposed = {}
  for k, v in graph:iter() do
    table.insert(exposed, {
      name = k,
      targets = v,
    })
  end
  table.sort(exposed, function(a, b)
    return a.name < b.name
  end)
  return exposed, nil
end

function GraphFactory._create_one(self, path)
  local f = io.open(path, "r")
  if not f then
    return nil, "cannot read: " .. path
  end

  local str = f:read("*a")
  f:close()

  local root, err = require("importgraph.lib.treesitter.node").get_first_tree_root(str, self._language)
  if err then
    return nil, err
  end

  local imported = require("importgraph.vendor.misclib.collection.ordered_dict").new()
  for _, match in self._query:iter_matches(root, str, 0, -1) do
    local captured = require("importgraph.lib.treesitter.node").get_captures(match, self._query, {
      ["import.target"] = function(tbl, tsnode)
        tbl.tsnode = tsnode
      end,
    })
    local raw_text = vim.treesitter.get_node_text(captured.tsnode, str)
    local target = self._string_unwrapper:unwrap(raw_text)
    imported[target] = true
  end
  local imported_targets = imported:keys()
  table.sort(imported_targets, function(a, b)
    return a < b
  end)
  return imported_targets, nil
end

return GraphFactory
