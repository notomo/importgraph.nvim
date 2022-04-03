local M = {}

function M.collect(working_dir, path_filter)
  local paths = vim.fn.glob(working_dir .. "**", false, true)

  return vim.tbl_filter(function(path)
    return vim.fn.isdirectory(path) == 0 and path_filter(path)
  end, paths)
end

return M
