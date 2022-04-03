return function(graph)
  local groups = {}

  for _, node in ipairs(graph) do
    if #node.targets == 0 then
      goto continue
    end

    local flows = {}
    for _, v in ipairs(node.targets) do
      local flow = ("  %s --> %s"):format(node.name, v)
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
