local Graph = require("importgraph.core.graph")
local ImportedTargets = require("importgraph.core.imported_targets")

local GraphFactory = {}
GraphFactory.__index = GraphFactory

function GraphFactory.new(working_dir, language, imported_target_filter)
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
    _imported_target_filter = imported_target_filter,
  }
  return setmetatable(tbl, GraphFactory)
end

function GraphFactory.create(self, paths)
  local graph = Graph.new(self._working_dir, self._grouping)

  for _, path in ipairs(paths) do
    local imported_targets, err = self:_create_one(path)
    if err then
      return nil, err
    end
    graph = graph:add(path, imported_targets)
  end

  return graph:expose(), nil
end

function GraphFactory._create_one(self, path)
  local str, read_err = require("importgraph.lib.file").read_all(path)
  if read_err then
    return nil, read_err
  end

  local root, err = require("importgraph.lib.treesitter.node").get_first_tree_root(str, self._language)
  if err then
    return nil, err
  end

  local imported_targets = ImportedTargets.new()
  for _, match in self._query:iter_matches(root, str, 0, -1) do
    local captured = require("importgraph.lib.treesitter.node").get_captures(match, self._query, {
      ["import.target"] = function(tbl, tsnode)
        tbl.target = tsnode
      end,
    })
    local raw_text = vim.treesitter.get_node_text(captured.target, str)
    local target = self._string_unwrapper:unwrap(raw_text)

    if self._imported_target_filter(target) then
      imported_targets = imported_targets:add(target)
    end
  end
  return imported_targets
end

return GraphFactory
