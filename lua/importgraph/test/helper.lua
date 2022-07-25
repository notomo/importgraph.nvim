local plugin_name = vim.split((...):gsub("%.", "/"), "/", true)[1]
local helper = require("vusted.helper")

helper.root = helper.find_plugin_root(plugin_name)
local runtimepath = vim.o.runtimepath

function helper.before_each()
  helper.test_data = require("importgraph.vendor.misclib.test.data_dir").setup(helper.root)
  vim.o.runtimepath = runtimepath
end

function helper.after_each()
  helper.cleanup()
  helper.cleanup_loaded_modules(plugin_name)
  helper.test_data:teardown()
end

function helper.use_parsers()
  vim.o.runtimepath = helper.root .. "/spec/lua/nvim-treesitter," .. vim.o.runtimepath
  vim.cmd.runtime([[plugin/nvim-treesitter.*]])
end

function helper.install_parser(language)
  helper.use_parsers()
  if not vim.treesitter.language.require_language(language, nil, true) then
    vim.cmd.TSInstallSync(language)
  end
end

return helper
