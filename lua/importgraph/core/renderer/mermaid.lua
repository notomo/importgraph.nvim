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

return function(graph)
  local groups = {}

  local alias = Alias.new()
  for _, node in ipairs(graph) do
    if #node.targets == 0 then
      goto continue
    end

    local node_index = alias:index(node.name)
    local flows = {}
    for _, v in ipairs(node.targets) do
      local flow = ("  %d(%s) --> %d(%s)"):format(node_index, node.name, alias:index(v), v)
      table.insert(flows, flow)
    end
    local group = table.concat(flows, "\n")
    table.insert(groups, group)

    ::continue::
  end

  return [[
graph TB
]] .. table.concat(groups, "\n")
end
