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

	-- Add plugins from community.packs.{java,yaml,bash} and remove the treesitter option
	-- Instead, we install treesitter in modules/neovim/default.nix
	-- This is because the treesitter plugins have compile-time dependencies and I couldn't get it to work otherwise
	-- TODO: figure out how to pull from astrocommunit and disable treesitter

	{
		"williamboman/mason-lspconfig.nvim",
		opts = function(_, opts)
			local utils = require("astronvim.utils")
			opts.ensure_installed = utils.list_insert_unique(opts.ensure_installed, "bashls")
		end,
	},
	{
		"jay-babu/mason-null-ls.nvim",
		opts = function(_, opts)
			local utils = require("astronvim.utils")
			opts.ensure_installed = utils.list_insert_unique(opts.ensure_installed, { "shellcheck", "shfmt" })
		end,
	},
	{
		"jay-babu/mason-nvim-dap.nvim",
		opts = function(_, opts)
			local utils = require("astronvim.utils")
			opts.ensure_installed = utils.list_insert_unique(opts.ensure_installed, "bash")
		end,
	},
	{
		"williamboman/mason-lspconfig.nvim",
		opts = function(_, opts)
			local utils = require("astronvim.utils")
			opts.ensure_installed = utils.list_insert_unique(opts.ensure_installed, "yamlls")
		end,
	},
	{
		"jay-babu/mason-null-ls.nvim",
		opts = function(_, opts)
			local utils = require("astronvim.utils")
			opts.ensure_installed = utils.list_insert_unique(opts.ensure_installed, "prettierd")
		end,
	},
	{
		"williamboman/mason-lspconfig.nvim",
		opts = function(_, opts)
			local utils = require("astronvim.utils")
			opts.ensure_installed = utils.list_insert_unique(opts.ensure_installed, "jsonls")
		end,
	},

	{
		"williamboman/mason-lspconfig.nvim",
		opts = function(_, opts)
			local utils = require("astronvim.utils")

			opts.ensure_installed = utils.list_insert_unique(opts.ensure_installed, { "jdtls", "lemminx" })
		end,
	},

	{
		"jay-babu/mason-null-ls.nvim",
		opts = function(_, opts)
			local utils = require("astronvim.utils")
			opts.ensure_installed = utils.list_insert_unique(opts.ensure_installed, "clang_format")
		end,
	},

	{
		"jay-babu/mason-nvim-dap.nvim",
		opts = function(_, opts)
			local utils = require("astronvim.utils")

			opts.ensure_installed = utils.list_insert_unique(opts.ensure_installed, { "javadbg", "javatest" })
		end,
	},

	{
		"mfussenegger/nvim-jdtls",
		ft = { "java" },
		init = function()
			local utils = require("astronvim.utils")

			astronvim.lsp.skip_setup = utils.list_insert_unique(astronvim.lsp.skip_setup, "jdtls")
		end,
		opts = function(_, opts)
			-- use this function notation to build some variables
			local root_markers = { ".git", "mvnw", "gradlew", "pom.xml", "build.gradle", ".project" }
			local root_dir = require("jdtls.setup").find_root(root_markers)

			-- calculate workspace dir
			local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t")
			local workspace_dir = vim.fn.stdpath("data") .. "/site/java/workspace-root/" .. project_name
			os.execute("mkdir " .. workspace_dir)

			-- get the mason install path
			local install_path = require("mason-registry").get_package("jdtls"):get_install_path()

			-- get the current OS
			local os
			if vim.fn.has("mac") == 1 then
				os = "mac"
			elseif vim.fn.has("unix") == 1 then
				os = "linux"
			elseif vim.fn.has("win32") == 1 then
				os = "win"
			end

			-- ensure that OS is valid
			if not os or os == "" then
				require("astronvim.utils").notify("jdtls: Could not detect valid OS", vim.log.levels.ERROR)
			end

			local defaults = {
				cmd = {
					"java",
					"-Declipse.application=org.eclipse.jdt.ls.core.id1",
					"-Dosgi.bundles.defaultStartLevel=4",
					"-Declipse.product=org.eclipse.jdt.ls.core.product",
					"-Dlog.protocol=true",
					"-Dlog.level=ALL",
					"-javaagent:" .. install_path .. "/lombok.jar",
					"-Xms1g",
					"--add-modules=ALL-SYSTEM",
					"--add-opens",
					"java.base/java.util=ALL-UNNAMED",
					"--add-opens",
					"java.base/java.lang=ALL-UNNAMED",
					"-jar",
					vim.fn.glob(install_path .. "/plugins/org.eclipse.equinox.launcher_*.jar"),
					"-configuration",
					install_path .. "/config_" .. os,
					"-data",
					workspace_dir,
				},
				root_dir = root_dir,
				settings = {
					java = {},
				},
				init_options = {
					bundles = {
						vim.fn.glob(
							require("mason-registry").get_package("java-debug-adapter"):get_install_path()
								.. "/extension/server/com.microsoft.java.debug.plugin-*.jar"
						),
						-- unpack remaining bundles
						(table.unpack or unpack)(
							vim.split(
								vim.fn.glob(
									require("mason-registry").get_package("java-test"):get_install_path()
										.. "/extension/server/*.jar"
								),
								"\n",
								{}
							)
						),
					},
				},
				handlers = {
					["language/status"] = function()
						-- print(result)
					end,
					["$/progress"] = function()
						-- disable progress updates.
					end,
				},
				filetypes = { "java" },
				on_attach = function(client, bufnr)
					require("jdtls").setup_dap()
					require("astronvim.utils.lsp").on_attach(client, bufnr)
				end,
			}

			-- TODO: add overwrite for on_attach

			-- ensure that table is valid
			if not opts then
				opts = {}
			end

			-- extend the current table with the defaults keeping options in the user opts
			-- this allows users to pass opts through an opts table in community.lua
			opts = vim.tbl_deep_extend("keep", opts, defaults)

			-- send opts to config
			return opts
		end,
		config = function(_, opts)
			-- setup autocmd on filetype detect java
			vim.api.nvim_create_autocmd("Filetype", {
				pattern = "java", -- autocmd to start jdtls
				callback = function()
					if opts.root_dir and opts.root_dir ~= "" then
						require("jdtls").start_or_attach(opts)
						-- require('jdtls.dap').setup_dap_main_class_configs()
					else
						require("astronvim.utils").notify(
							"jdtls: root_dir not found. Please specify a root marker",
							vim.log.levels.ERROR
						)
					end
				end,
			})
			-- create autocmd to load main class configs on LspAttach.
			-- This ensures that the LSP is fully attached.
			-- See https://github.com/mfussenegger/nvim-jdtls#nvim-dap-configuration
			vim.api.nvim_create_autocmd("LspAttach", {
				pattern = "*.java",
				callback = function(args)
					local client = vim.lsp.get_client_by_id(args.data.client_id)
					-- ensure that only the jdtls client is activated
					if client.name == "jdtls" then
						require("jdtls.dap").setup_dap_main_class_configs()
					end
				end,
			})
		end,
	},
}
