return function()
	local tsconfig = require("nvim-treesitter.configs")

	---@diagnostic disable-next-line: missing-fields
	tsconfig.setup({
		ensure_installed = {
			"go",
			"rust",
			"lua",
			"javascript",
			"typescript",
			"php",
			"css",
			"html",
			"astro",
			"templ",
		},
		highlight = {
			enable = true,
			use_languagetree = true,
			additional_vim_regex_highlighting = false,
		},
		autotag = {
			enable = true,
		},
		indent = {
			enable = true,
		},
	})
end
