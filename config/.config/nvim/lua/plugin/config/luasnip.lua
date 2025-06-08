return function()
	local luasnip = require("luasnip")
	local types = require("luasnip.util.types")
	local from_vscode = require("luasnip.loaders.from_vscode")

	from_vscode.lazy_load()

	luasnip.config.set_config({
		history = true,
		updateevents = "TextChanged,TextChangedI",
		enable_autosnippets = true,
		ext_opts = {
			[types.choiceNode] = {
				active = {
					virt_text = { { "<-", "Error" } },
				},
			},
		},
	})
end
