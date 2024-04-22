local fn = vim.fn

local M = {}

function M.collect(working_dir, path_filter)
  local paths = fn.glob(working_dir .. "**", false, true)

  return vim
    .iter(paths)
    :filter(function(path)
      path = fn.fnamemodify(path, ":p")
      return fn.isdirectory(path) == 0 and path_filter(path)
    end)
    :totable()
end

return M
