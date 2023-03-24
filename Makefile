include spec/.shared/neovim-plugin.mk

spec/.shared/neovim-plugin.mk:
	git clone https://github.com/notomo/workflow.git --depth 1 spec/.shared

NVIM_TREESITTER:=./spec/lua/nvim-treesitter
$(NVIM_TREESITTER):
	git clone https://github.com/nvim-treesitter/nvim-treesitter.git $@

deps: $(NVIM_TREESITTER)
