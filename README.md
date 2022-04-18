# importgraph.nvim

wip

## Example

```lua
local graph = require("importgraph").render({
  collector = {
    path_filter = function(path)
      return not path:match("test/helper")
    end,
  },
})
print(graph)
```

### Generated graph

```mermaid
graph TB
  1(importgraph) --> 2(importgraph.command)
  2(importgraph.command) --> 3(importgraph.core.file_path)
  2(importgraph.command) --> 4(importgraph.core.graph_factory)
  2(importgraph.command) --> 5(importgraph.core.option)
  2(importgraph.command) --> 6(importgraph.core.renderer)
  2(importgraph.command) --> 7(importgraph.vendor.misclib.error_handler)
  8(importgraph.core.graph) --> 9(importgraph.vendor.misclib.collection.ordered_dict)
  4(importgraph.core.graph_factory) --> 8(importgraph.core.graph)
  4(importgraph.core.graph_factory) --> 10(importgraph.core.grouping)
  4(importgraph.core.graph_factory) --> 11(importgraph.core.imported_targets)
  4(importgraph.core.graph_factory) --> 12(importgraph.lib.treesitter.node)
  4(importgraph.core.graph_factory) --> 13(importgraph.lib.treesitter.string_unwrapper)
  10(importgraph.core.grouping) --> 14(importgraph.vendor.misclib.module)
  11(importgraph.core.imported_targets) --> 9(importgraph.vendor.misclib.collection.ordered_dict)
  6(importgraph.core.renderer) --> 14(importgraph.vendor.misclib.module)
```