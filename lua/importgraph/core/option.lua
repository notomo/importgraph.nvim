local M = {}

M.default = {
  renderer = {
    name = "mermaid",
  },
  collector = {
    language = "lua",
    working_dir = ".",
    path_filter = function()
      return true
    end,
    imported_target_filter = function()
      return true
    end,
  },
}

function M.new(raw_opts)
  vim.validate({ raw_opts = { raw_opts, "table", true } })
  raw_opts = raw_opts or {}

  local opts = vim.tbl_deep_extend("force", M.default, raw_opts)
  opts.collector.working_dir = vim.fn.fnamemodify(opts.collector.working_dir, ":p")

  return opts
end

return M
