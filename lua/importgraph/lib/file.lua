local M = {}

function M.read_all(path)
  local f = io.open(path, "r")
  if not f then
    return { err = "cannot read: " .. path }
  end
  if vim.fn.isdirectory(path) == 1 then
    return { err = "directory: " .. path }
  end
  local str = f:read("*a")
  f:close()
  return str
end

return M
