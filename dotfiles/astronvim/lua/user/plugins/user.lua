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
}
