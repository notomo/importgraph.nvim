local plugin_name = vim.split((...):gsub("%.", "/"), "/", true)[1]
local helper = require("vusted.helper")

helper.root = helper.find_plugin_root(plugin_name)
local runtimepath = vim.o.runtimepath

function helper.before_each()
  helper.test_data_path = "spec/test_data/" .. math.random(1, 2 ^ 30) .. "/"
  helper.test_data_dir = helper.root .. "/" .. helper.test_data_path
  helper.new_directory("")
  vim.o.runtimepath = runtimepath
end

function helper.after_each()
  vim.cmd("silent %bwipeout!")
  helper.cleanup_loaded_modules(plugin_name)
  vim.fn.delete(helper.root .. "/spec/test_data", "rf")
end

function helper.new_file(path, ...)
  local f = io.open(helper.test_data_dir .. path, "w")
  for _, line in ipairs({ ... }) do
    f:write(line .. "\n")
  end
  f:close()
end

function helper.new_directory(path)
  vim.fn.mkdir(helper.test_data_dir .. path, "p")
end

function helper.delete(path)
  vim.fn.delete(helper.test_data_dir .. path, "rf")
end

function helper.use_parsers()
  vim.o.runtimepath = helper.root .. "/spec/lua/nvim-treesitter," .. vim.o.runtimepath
  vim.cmd([[runtime plugin/nvim-treesitter.*]])
end

function helper.install_parser(language)
  helper.use_parsers()
  if not vim.treesitter.language.require_language(language, nil, true) then
    vim.cmd([[TSInstallSync ]] .. language)
  end
end

return helper
