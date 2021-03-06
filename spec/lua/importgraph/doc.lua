local util = require("genvdoc.util")
local plugin_name = vim.env.PLUGIN_NAME
local full_plugin_name = plugin_name .. ".nvim"

local example_path = ("./spec/lua/%s/example.lua"):format(plugin_name)
local graph = vim.api.nvim_exec("luafile " .. example_path, true)

require("genvdoc").generate(full_plugin_name, {
  sources = { { name = "lua", pattern = ("lua/%s/init.lua"):format(plugin_name) } },
  chapters = {
    {
      name = function(group)
        return "Lua module: " .. group
      end,
      group = function(node)
        if not node.declaration then
          return nil
        end
        return node.declaration.module
      end,
    },
    {
      name = "EXAMPLES",
      body = function()
        return util.help_code_block_from_file(example_path)
      end,
    },
  },
})

local gen_readme = function()
  local f = io.open(example_path, "r")
  local exmaple = f:read("*a")
  f:close()

  local content = ([[
# %s

wip

## Example

```lua
%s```

### Generated graph

```mermaid
%s
```]]):format(full_plugin_name, exmaple, graph)

  local readme = io.open("README.md", "w")
  readme:write(content)
  readme:close()
end
gen_readme()
