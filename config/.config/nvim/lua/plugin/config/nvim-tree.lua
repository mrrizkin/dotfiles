return function()
	local utils = require("core.utils")
	local nmap = utils.nmap
	local keymaps = utils.keymaps
	local nvim_tree = require("nvim-tree")

	local function on_attach(bufnr)
		local api = require("nvim-tree.api")

		local function opts(desc)
			return { desc = "nvim-tree: " .. desc, buffer = bufnr, nowait = true }
		end

		-- BEGIN_DEFAULT_ON_ATTACH
		local maps = {
			nmap("<CR>", api.tree.change_root_to_node, opts("CD")),
			nmap("<C-e>", api.node.open.replace_tree_buffer, opts("Open: In Place")),
			nmap("<C-k>", api.node.show_info_popup, opts("Info")),
			nmap("<C-r>", api.fs.rename_sub, opts("Rename: Omit Filename")),
			nmap("<C-t>", api.node.open.tab, opts("Open: New Tab")),
			nmap("<C-v>", api.node.open.vertical, opts("Open: Vertical Split")),
			nmap("<C-x>", api.node.open.horizontal, opts("Open: Horizontal Split")),
			nmap("h", api.node.navigate.parent_close, opts("Close Directory")),
			nmap("<Tab>", api.node.open.preview, opts("Open Preview")),
			nmap(">", api.node.navigate.sibling.next, opts("Next Sibling")),
			nmap("<", api.node.navigate.sibling.prev, opts("Previous Sibling")),
			nmap(".", api.node.run.cmd, opts("Run Command")),
			nmap("-", api.tree.change_root_to_parent, opts("Up")),
			nmap("a", api.fs.create, opts("Create")),
			nmap("bmv", api.marks.bulk.move, opts("Move Bookmarked")),
			nmap("B", api.tree.toggle_no_buffer_filter, opts("Toggle No Buffer")),
			nmap("c", api.fs.copy.node, opts("Copy")),
			nmap("C", api.tree.toggle_git_clean_filter, opts("Toggle Git Clean")),
			nmap("[c", api.node.navigate.git.prev, opts("Prev Git")),
			nmap("]c", api.node.navigate.git.next, opts("Next Git")),
			nmap("d", api.fs.remove, opts("Delete")),
			nmap("D", api.fs.trash, opts("Trash")),
			nmap("E", api.tree.expand_all, opts("Expand All")),
			nmap("e", api.fs.rename_basename, opts("Rename: Basename")),
			nmap("]e", api.node.navigate.diagnostics.next, opts("Next Diagnostic")),
			nmap("[e", api.node.navigate.diagnostics.prev, opts("Prev Diagnostic")),
			nmap("F", api.live_filter.clear, opts("Clean Filter")),
			nmap("f", api.live_filter.start, opts("Filter")),
			nmap("g?", api.tree.toggle_help, opts("Help")),
			nmap("gy", api.fs.copy.absolute_path, opts("Copy Absolute Path")),
			nmap("H", api.tree.toggle_hidden_filter, opts("Toggle Dotfiles")),
			nmap("I", api.tree.toggle_gitignore_filter, opts("Toggle Git Ignore")),
			nmap("J", api.node.navigate.sibling.last, opts("Last Sibling")),
			nmap("K", api.node.navigate.sibling.first, opts("First Sibling")),
			nmap("m", api.marks.toggle, opts("Toggle Bookmark")),
			nmap("l", api.node.open.edit, opts("Open")),
			nmap("o", api.node.open.edit, opts("Open")),
			nmap("O", api.node.open.no_window_picker, opts("Open: No Window Picker")),
			nmap("p", api.fs.paste, opts("Paste")),
			nmap("P", api.node.navigate.parent, opts("Parent Directory")),
			nmap("q", api.tree.close, opts("Close")),
			nmap("r", api.fs.rename, opts("Rename")),
			nmap("R", api.tree.reload, opts("Refresh")),
			nmap("s", api.node.run.system, opts("Run System")),
			nmap("S", api.tree.search_node, opts("Search")),
			nmap("U", api.tree.toggle_custom_filter, opts("Toggle Hidden")),
			nmap("W", api.tree.collapse_all, opts("Collapse")),
			nmap("x", api.fs.cut, opts("Cut")),
			nmap("y", api.fs.copy.filename, opts("Copy Name")),
			nmap("Y", api.fs.copy.relative_path, opts("Copy Relative Path")),
			nmap("<2-LeftMouse>", api.node.open.edit, opts("Open")),
			nmap("<2-RightMouse>", api.tree.change_root_to_node, opts("CD")),
		}
		keymaps(maps, {
			report_conflicts = true,
			abort_on_conflict = true,
			override_conflicts = true,
			log_level = "silent",
		})
	end

	nvim_tree.setup({
		auto_reload_on_write = true,
		disable_netrw = true,
		hijack_netrw = true,
		hijack_cursor = true,
		on_attach = on_attach,
		update_focused_file = {
			enable = true,
			update_root = false,
			ignore_list = {},
		},
		view = {
			centralize_selection = false,
			cursorline = true,
			debounce_delay = 15,
			width = 30,
			side = "left",
			preserve_window_proportions = false,
			signcolumn = "yes",
			float = {
				enable = false,
				quit_on_focus_loss = true,
				open_win_config = {
					relative = "editor",
					border = "rounded",
					width = 30,
					height = 30,
					row = 1,
					col = 1,
				},
			},
		},
		renderer = {
			add_trailing = false,
			group_empty = false,
			highlight_git = true,
			full_name = false,
			highlight_opened_files = "icon",
			highlight_modified = "none",
			root_folder_label = ":~:s?$?/..?",
			indent_width = 2,
			indent_markers = {
				enable = true,
				inline_arrows = false,
				icons = {
					corner = "╰",
					edge = "│",
					item = "│",
					bottom = "─",
					none = " ",
				},
			},
			icons = {
				webdev_colors = true,
				git_placement = "before",
				modified_placement = "after",
				padding = " ",
				symlink_arrow = " ➛ ",
				show = {
					file = true,
					folder = true,
					folder_arrow = false,
					git = true,
					modified = true,
				},
				glyphs = {
					default = "",
					symlink = "",
					bookmark = "",
					modified = "●",
					folder = {
						arrow_closed = "",
						arrow_open = "",
						default = "",
						open = "",
						empty = "",
						empty_open = "",
						symlink = "",
						symlink_open = "",
					},
					git = {
						unstaged = "✗",
						staged = "✓",
						unmerged = "",
						renamed = "➜",
						untracked = "★",
						deleted = "",
						ignored = "◌",
					},
				},
			},
			special_files = { "Cargo.toml", "Makefile", "README.md", "readme.md" },
			symlink_destination = true,
		},
		diagnostics = {
			enable = true,
			show_on_dirs = true,
			show_on_open_dirs = true,
			debounce_delay = 500,
			severity = {
				min = vim.diagnostic.severity.HINT,
				max = vim.diagnostic.severity.ERROR,
			},
			icons = {
				hint = "",
				info = "",
				warning = "",
				error = "",
			},
		},
		filters = {
			dotfiles = true,
			git_clean = false,
			no_buffer = false,
			custom = {},
			exclude = {},
		},
	})
end
