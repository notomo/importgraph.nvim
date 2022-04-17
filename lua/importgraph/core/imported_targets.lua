local ImportedTargets = {}
ImportedTargets.__index = ImportedTargets

function ImportedTargets.new(raw_imported)
  local tbl = {
    _imported = raw_imported or require("importgraph.vendor.misclib.collection.ordered_dict").new(),
  }
  return setmetatable(tbl, ImportedTargets)
end

function ImportedTargets.add(self, target)
  local raw_imported = self._imported:merge({
    [target] = true,
  })
  return ImportedTargets.new(raw_imported)
end

function ImportedTargets.expose(self)
  local targets = self._imported:keys()
  table.sort(targets, function(a, b)
    return a < b
  end)
  return targets
end

return ImportedTargets
