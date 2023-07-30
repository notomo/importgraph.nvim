local Alias = {}
Alias.__index = Alias

function Alias.new()
  local tbl = {
    _index = 1,
    _aliases = {},
  }
  return setmetatable(tbl, Alias)
end

function Alias.index(self, name)
  local index = self._aliases[name]
  if index then
    return index
  end

  self._aliases[name] = self._index
  self._index = self._index + 1
  return self._aliases[name]
end

local to_node_text = function(node_index, name)
  return ("%d(%s)"):format(node_index, name)
end

local M = {}

M.default_opts = {
  direction = "TB",
}

function M.render(graph, opts)
  local groups = {}
  local indent = "  "

  local alias = Alias.new()
  vim.iter(graph):each(function(node)
    local node_index = alias:index(node.name)
    local node_from = to_node_text(node_index, node.name)

    if #node.targets == 0 then
      table.insert(groups, indent .. node_from)
      return
    end

    local flows = {}
    for _, v in ipairs(node.targets) do
      local node_to = to_node_text(alias:index(v), v)
      local flow = ("%s%s --> %s"):format(indent, node_from, node_to)
      table.insert(flows, flow)
    end
    local group = table.concat(flows, "\n")
    table.insert(groups, group)
  end)

  local header = ([[
graph %s
]]):format(opts.direction)
  return header .. table.concat(groups, "\n")
end

return M
