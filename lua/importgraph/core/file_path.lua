local fn = vim.fn

local M = {}

function M.collect(working_dir, path_filter)
  local paths = fn.glob(working_dir .. "**", false, true)

  return vim.tbl_filter(function(path)
    path = fn.fnamemodify(path, ":p")
    return fn.isdirectory(path) == 0 and path_filter(path)
  end, paths)
end

return M
