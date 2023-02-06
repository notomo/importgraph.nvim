local M = {}
M.__index = M

function M.new(working_dir)
  local tbl = {
    _working_dir = working_dir,
    _string_unwrapper = require("importgraph.lib.treesitter.string_unwrapper").new("lua"),
  }
  return setmetatable(tbl, M)
end

function M.grouping(self, path)
  if not vim.endswith(path, ".lua") then
    return nil
  end

  path = vim.fs.normalize(path)
  local relative = path:match("/lua/(.*)")
  if not relative then
    relative = path:sub(#self._working_dir + 1)
  end

  relative = relative:gsub("/", ".")
  relative = relative:gsub(".lua$", "")
  relative = relative:gsub(".init$", "")
  relative = relative:gsub("^lua.", "")
  return relative
end

function M.unwrap_string(self, str)
  return self._string_unwrapper:unwrap(str)
end

function M.build_query()
  return vim.treesitter.query.parse_query(
    "lua",
    [[
(function_call
  name: (identifier) @import (#eq? @import "require")
  arguments: (arguments (string) @import.target)
)
]]
  )
end

return M
