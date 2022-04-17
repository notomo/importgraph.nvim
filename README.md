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
  importgraph --> importgraph.command
  importgraph.command --> importgraph.core.file_path
  importgraph.command --> importgraph.core.graph_factory
  importgraph.command --> importgraph.core.option
  importgraph.command --> importgraph.core.renderer
  importgraph.command --> importgraph.vendor.misclib.error_handler
  importgraph.core.graph --> importgraph.vendor.misclib.collection.ordered_dict
  importgraph.core.graph_factory --> importgraph.core.graph
  importgraph.core.graph_factory --> importgraph.core.grouping
  importgraph.core.graph_factory --> importgraph.core.imported_targets
  importgraph.core.graph_factory --> importgraph.lib.treesitter.node
  importgraph.core.graph_factory --> importgraph.lib.treesitter.string_unwrapper
  importgraph.core.grouping --> importgraph.vendor.misclib.module
  importgraph.core.imported_targets --> importgraph.vendor.misclib.collection.ordered_dict
  importgraph.core.renderer --> importgraph.vendor.misclib.module
```