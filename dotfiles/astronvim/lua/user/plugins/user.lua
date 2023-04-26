return {
	-- You can also add new plugins here as well:
	-- Add plugins, the lazy syntax
	-- "andweeb/presence.nvim",
	-- {
	--   "ray-x/lsp_signature.nvim",
	--   event = "BufRead",
	--   config = function()
	--     require("lsp_signature").setup()
	--   end,
	-- },
	{
		"LnL7/vim-nix",
	},
	{
		"tools-life/taskwiki",
		lazy = false, -- Always load on start up
		init = function()
			vim.g.taskwiki_taskrc_location = "~/.config/task/taskrc"
			vim.g.taskwiki_data_location = "~/.local/share/task/"
		end,
	},
	{
		-- Automatically save (n)vim sessions
		-- Works with tmux resurrect (https://github.com/tmux-plugins/tmux-resurrect)
		"tpope/vim-obsession",
	},
	{
		"simrat39/inlay-hints.nvim",
		config = function()
			require("inlay-hints").setup({ eol = { right_alight = true } })
		end,
	},
	{
		"vimwiki/vimwiki",
		lazy = false, -- Always load on start up
		init = function()
			vim.g.vimwiki_global_ext = 0 -- Stop all markdown files from being intrepreted as "temporary wikis"
			vim.g.vimwiki_folding = "" -- Disable folding
			vim.g.vimwiki_list = {
				{
					path = "~/vimwiki/",
					syntax = "markdown",
					ext = ".md",
				},
			}
		end,
	},
	{
		-- Vim Monokai scheme
		"crusoexia/vim-monokai",
	},
	{
		-- Collection of Nvim monokai schemes
		"sainnhe/sonokai",
	},
	{
		"christoomey/vim-tmux-navigator",
	},
	{
		"https://git.sr.ht/~whynothugo/lsp_lines.nvim",
		config = function()
			require("lsp_lines").setup()
		end,
	},
	{
		"NoahTheDuke/vim-just",
		lazy = false, -- TODO: wasnt loading when opening justfiles so set to always load on startup
	},
}
