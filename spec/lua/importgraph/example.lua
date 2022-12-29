local graph = require("importgraph").render({
  collector = {
    path_filter = function(path)
      return not path:match("test/helper")
    end,
    imported_target_filter = function(name)
      return not name:match(".vendor.") and not name:match(".lib.")
    end,
  },
})
print(graph)
