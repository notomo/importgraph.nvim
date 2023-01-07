local ImportedTargets = {}
ImportedTargets.__index = ImportedTargets

function ImportedTargets.new(raw_targets)
  local imported = require("importgraph.vendor.misclib.collection.ordered_dict").new()
  for _, target in ipairs(raw_targets) do
    imported[target] = true
  end
  local tbl = {
    _imported = imported,
  }
  return setmetatable(tbl, ImportedTargets)
end

function ImportedTargets.expose(self)
  local targets = self._imported:keys()
  table.sort(targets, function(a, b)
    return a < b
  end)
  return targets
end

return ImportedTargets
