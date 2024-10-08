local M = {}
M.__index = M

function M.new(working_dir)
  local go_mod_path = vim.fs.find("go.mod", {
    path = working_dir,
    upward = true,
    type = "file",
  })[1]
  if not go_mod_path then
    require("importgraph.vendor.misclib.message").error("not found go.mod")
    return
  end

  local root_dir = vim.fs.normalize(vim.fs.dirname(go_mod_path))
  local cmd = { "go", "mod", "edit", "-json" }
  local stdout = require("importgraph.vendor.misclib.job.output").new()
  local job = require("importgraph.vendor.misclib.job").start(cmd, {
    cwd = root_dir,
    on_stdout = stdout:collector(),
  })
  if type(job) == "string" then
    local err = job
    require("importgraph.vendor.misclib.message").error(err)
    return
  end
  vim.wait(1000, function()
    return not job:is_running()
  end)
  local module_path = vim.json.decode(stdout:str()).Module.Path

  local pattern = "^" .. root_dir:gsub("%-", "%%-")
  local to_package_path = function(path)
    local dir_path = vim.fs.normalize(vim.fs.dirname(path))
    local package_path = dir_path:gsub(pattern, module_path)
    return package_path
  end

  local tbl = {
    _to_package_path = to_package_path,
    _string_unwrapper = require("importgraph.lib.treesitter.string_unwrapper").new("go"),
  }
  return setmetatable(tbl, M)
end

function M.grouping(self, path)
  if not vim.endswith(path, ".go") then
    return nil
  end
  return self._to_package_path(path)
end

function M.unwrap_string(self, str)
  return self._string_unwrapper:unwrap(str)
end

function M.build_query()
  return vim.treesitter.query.parse(
    "go",
    [[
(import_spec
  path: (_) @import.target
)
]]
  )
end

return M
