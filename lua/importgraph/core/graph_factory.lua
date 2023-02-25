local Graph = require("importgraph.core.graph")
local ImportedTargets = require("importgraph.core.imported_targets")
local tslib = require("importgraph.vendor.misclib.treesitter")
local filelib = require("importgraph.lib.file")
local vim = vim

local GraphFactory = {}
GraphFactory.__index = GraphFactory

function GraphFactory.new(working_dir, language, imported_target_filter)
  local language_handler, err = require("importgraph.core.language_handler").new(language, working_dir)
  if err then
    return nil, err
  end

  local tbl = {
    _language_handler = language_handler,
    _query = language_handler:build_query(),
    _language = language,
    _imported_target_filter = imported_target_filter,
  }
  return setmetatable(tbl, GraphFactory)
end

function GraphFactory.create(self, paths)
  local graph = Graph.new()

  for _, path in ipairs(paths) do
    local group = self._language_handler:grouping(path)
    if not group then
      goto continue
    end

    local imported_targets, err = self:_create_one(path)
    if err then
      return nil, err
    end
    graph = graph:add(group, imported_targets)

    ::continue::
  end

  return graph:expose(), nil
end

function GraphFactory._create_one(self, path)
  local str, read_err = filelib.read_all(path)
  if read_err then
    return nil, read_err
  end

  local root, err = tslib.get_first_tree_root(str, self._language)
  if err then
    return nil, err
  end

  local raw_targets = {}
  for _, match in self._query:iter_matches(root, str, 0, -1) do
    local captured = tslib.get_captures(match, self._query, {
      ["import.target"] = function(tbl, tsnode)
        tbl.target = tsnode
      end,
    })
    local raw_text = vim.treesitter.get_node_text(captured.target, str)
    local target = self._language_handler:unwrap_string(raw_text)
    table.insert(raw_targets, target)
  end
  return ImportedTargets.new(vim.tbl_filter(self._imported_target_filter, raw_targets))
end

return GraphFactory
