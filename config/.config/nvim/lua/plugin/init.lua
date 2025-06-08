return {
	"nvim-lua/plenary.nvim",
	{ "preservim/tagbar", cmd = { "TagbarOpen", "TagbarToggle", "Tagbar" } },
	{ "terryma/vim-multiple-cursors", event = "BufRead" },
	{ "tpope/vim-fugitive", event = "BufRead" },
	{ "nvim-lua/popup.nvim", dependencies = { "nvim-lua/plenary.nvim" } },
	{
		"L3MON4D3/LuaSnip",
		event = "BufRead",
		config = require("plugin.config.luasnip"),
		dependencies = {
			"rafamadriz/friendly-snippets",
		},
	},
	{ "kylechui/nvim-surround", event = "BufRead", config = require("plugin.config.nvim-surround") },
	{ "andymass/vim-matchup", event = "BufRead", config = require("plugin.config.matchup") },
	{ "stevearc/oil.nvim", lazy = false, config = require("plugin.config.oil-nvim") },
	{ "numToStr/Comment.nvim", event = "BufRead", config = require("plugin.config.comment") },
	{ "mhartington/formatter.nvim", event = "BufWritePre", config = require("plugin.config.formatter") },
	{
		"williamboman/mason.nvim",
		lazy = false,
		dependencies = { "ray-x/lsp_signature.nvim", "neovim/nvim-lspconfig", "williamboman/mason-lspconfig.nvim" },
		config = require("plugin.config.lsp"),
	},
	{ "nvim-treesitter/nvim-treesitter", lazy = false, config = require("plugin.config.treesitter") },
	{
		"nvim-telescope/telescope.nvim",
		dependencies = {
			"nvim-telescope/telescope-fzy-native.nvim",
			"nvim-telescope/telescope-media-files.nvim",
			"nvim-telescope/telescope-symbols.nvim",
			"benfowler/telescope-luasnip.nvim",
			"nvim-telescope/telescope-live-grep-args.nvim",
		},
		config = require("plugin.config.telescope"),
	},
	{
		"hrsh7th/nvim-cmp",
		dependencies = {
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-nvim-lua",
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-path",
			"hrsh7th/cmp-cmdline",
			"saadparwaiz1/cmp_luasnip",
			"onsails/lspkind-nvim",
		},
		config = require("plugin.config.nvim-cmp"),
	},
	{
		"lewis6991/gitsigns.nvim",
		event = "BufRead",
		dependencies = "plenary.nvim",
		config = require("plugin.config.gitsigns"),
	},
	{
		"nvim-lualine/lualine.nvim",
		lazy = false,
		dependencies = { "nvim-tree/nvim-web-devicons", "arkav/lualine-lsp-progress" },
		config = require("plugin.config.lualine"),
	},
	{
		"catppuccin/nvim",
		name = "catppuccin",
		priority = 1000,
		lazy = false,
		config = require("plugin.config.catppuccin"),
	},
	{
		"kristijanhusak/vim-dadbod-ui",
		event = "BufRead",
		dependencies = "tpope/vim-dadbod",
		config = require("plugin.config.dadbod-ui"),
	},
	{ "kristijanhusak/vim-dadbod-completion", ft = { "sql" }, dependencies = "kristijanhusak/vim-dadbod-ui" },
	{ "folke/zen-mode.nvim", opts = {} },
	{
		"nvim-tree/nvim-tree.lua",
		version = "*",
		lazy = false,
		dependencies = {
			"nvim-tree/nvim-web-devicons",
		},
		config = require("plugin.config.nvim-tree"),
	},
	{
		"supermaven-inc/supermaven-nvim",
		event = "BufRead",
		config = function()
			require("supermaven-nvim").setup({
				keymaps = {
					accept_word = "<C-s-w>",
				},
			})
		end,
	},
	{
		"numToStr/FTerm.nvim",
		lazy = false,
	},
}
