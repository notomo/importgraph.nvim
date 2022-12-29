# importgraph.nvim

wip

## Example

```lua
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
```

### Generated graph

```mermaid
graph TB
  1(importgraph) --> 2(importgraph.command)
  2(importgraph.command) --> 3(importgraph.core.file_path)
  2(importgraph.command) --> 4(importgraph.core.graph_factory)
  2(importgraph.command) --> 5(importgraph.core.option)
  2(importgraph.command) --> 6(importgraph.core.renderer)
  4(importgraph.core.graph_factory) --> 7(importgraph.core.graph)
  4(importgraph.core.graph_factory) --> 8(importgraph.core.grouping)
  4(importgraph.core.graph_factory) --> 9(importgraph.core.imported_targets)
```