return function()
	local oil = require("oil")
	oil.setup({
		default_file_explorer = true,
		delete_to_trash = true,
		skip_confirm_for_simple_edits = true,
		view_options = {
			show_hidden = true,
			natural_order = true,
			is_always_hidden = function(name, _)
				return name == ".." or name == ".git" or name == ".DS_Store" or name == ".gitkeep"
			end,
		},
		win_options = {
			wrap = true,
		},
	})
end
