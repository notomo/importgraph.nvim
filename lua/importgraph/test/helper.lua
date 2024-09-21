local helper = require("vusted.helper")
local plugin_name = helper.get_module_root(...)

helper.root = helper.find_plugin_root(plugin_name)
vim.opt.packpath:prepend(vim.fs.joinpath(helper.root, "spec/.shared/packages"))
require("assertlib").register(require("vusted.assert").register)

function helper.before_each()
  helper.test_data = require("importgraph.vendor.misclib.test.data_dir").setup(helper.root)
  vim.cmd.packadd("nvim-treesitter")
  vim.g.loaded_nvim_treesitter = nil
  vim.cmd.runtime([[plugin/nvim-treesitter.lua]])
end

function helper.after_each()
  helper.cleanup()
  helper.cleanup_loaded_modules(plugin_name)
  helper.test_data:teardown()
end

function helper.install_parser(language)
  if not require("importgraph.vendor.misclib.treesitter").has_parser(language) then
    vim.cmd.TSInstallSync(language)
  end
end

return helper
