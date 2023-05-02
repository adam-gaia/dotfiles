return {
	-- customize alpha options
	{
		"goolord/alpha-nvim",
		opts = function(_, opts)
			-- customize the dashboard header

			-- Random color picker taken from https://github.com/goolord/alpha-nvim/discussions/16#discussioncomment-1937804
			math.randomseed(os.time())
			local function pick_color()
				local colors = { "String", "Identifier", "Keyword", "Number" }
				return colors[math.random(#colors)]
			end

			-- Have alpha-nvim use the random color picture to set the header color
			opts.section.header.opts.hl = pick_color()

			-- File operations taken from https://stackoverflow.com/a/11204889/9761733
			local function file_exists(file)
				local f = io.open(file, "rb")
				if f then
					f:close()
				end
				return f ~= nil
			end

			local function lines_from(file)
				if not file_exists(file) then
					return { "unable to find logo files", file }
				end
				local lines = {}
				for line in io.lines(file) do
					lines[#lines + 1] = line
				end
				return lines
			end

			local function getFilesInDir(path)
				local files = {}
				local cmd = "find " .. path .. " -name '*.txt'" -- TODO: figure out how to install luarocks and luafilesystem for better compat
				local p = io.popen(cmd)
				for file in p:lines() do
					table.insert(files, file)
				end
				p:close()
				return files
			end

			local function getRandomFile(files)
				local randomIndex = math.random(#files)
				return files[randomIndex]
			end

			local function getRandomLogo(logos_dir)
				local logos = getFilesInDir(logos_dir)
				local logo = lines_from(getRandomFile(logos))
				return logo
			end

			-- Read a logo from a file
			local logos_dir = "/home/agaia/.local/share/text-art/share" -- TODO: make this configurable
			opts.section.header.val = getRandomLogo(logos_dir)
			return opts
		end,
	},
	-- You can disable default plugins as follows:
	-- { "max397574/better-escape.nvim", enabled = false },
	--
	-- You can also easily customize additional setup of plugins that is outside of the plugin's setup call
	-- {
	--   "L3MON4D3/LuaSnip",
	--   config = function(plugin, opts)
	--     plugin.default_config(opts) -- include the default astronvim config that calls the setup call
	--     -- add more custom luasnip configuration such as filetype extend or custom snippets
	--     local luasnip = require "luasnip"
	--     luasnip.filetype_extend("javascript", { "javascriptreact" })
	--   end,
	-- },
	-- {
	--   "windwp/nvim-autopairs",
	--   config = function(plugin, opts)
	--     plugin.default_config(opts) -- include the default astronvim config that calls the setup call
	--     -- add more custom autopairs configuration such as custom rules
	--     local npairs = require "nvim-autopairs"
	--     local Rule = require "nvim-autopairs.rule"
	--     local cond = require "nvim-autopairs.conds"
	--     npairs.add_rules(
	--       {
	--         Rule("$", "$", { "tex", "latex" })
	--           -- don't add a pair if the next character is %
	--           :with_pair(cond.not_after_regex "%%")
	--           -- don't add a pair if  the previous character is xxx
	--           :with_pair(
	--             cond.not_before_regex("xxx", 3)
	--           )
	--           -- don't move right when repeat character
	--           :with_move(cond.none())
	--           -- don't delete if the next character is xx
	--           :with_del(cond.not_after_regex "xx")
	--           -- disable adding a newline when you press <cr>
	--           :with_cr(cond.none()),
	--       },
	--       -- disable for .vim files, but it work for another filetypes
	--       Rule("a", "a", "-vim")
	--     )
	--   end,
	-- },
	-- By adding to the which-key config and using our helper function you can add more which-key registered bindings
	-- {
	--   "folke/which-key.nvim",
	--   config = function(plugin, opts)
	--     plugin.default_config(opts)
	--     -- Add bindings which show up as group name
	--     local wk = require "which-key"
	--     wk.register({
	--       b = { name = "Buffer" },
	--     }, { mode = "n", prefix = "<leader>" })
	--   end,
	-- },
}
