local M = {}

function M.grouping(path, working_dir)
  if not vim.endswith(path, ".lua") then
    return nil
  end

  path = vim.fs.normalize(path)
  local relative = path:match("/lua/(.*)")
  if not relative then
    relative = path:sub(#working_dir + 1)
  end

  relative = relative:gsub("/", ".")
  relative = relative:gsub(".lua$", "")
  relative = relative:gsub(".init$", "")
  relative = relative:gsub("^lua.", "")
  return relative
end

function M.unwrap_string(str)
  local string_unwrapper = require("importgraph.lib.treesitter.string_unwrapper").new("lua")
  return string_unwrapper:unwrap(str)
end

return M
