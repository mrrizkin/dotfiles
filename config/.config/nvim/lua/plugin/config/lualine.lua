return function()
	local lualine = require("lualine")
	local supermaven = require("supermaven-nvim.api")

	local lsp_progress = {
		"lsp_progress",
		separators = {
			component = " ",
			progress = " | ",
			percentage = { pre = "", post = "%% " },
			title = { pre = "", post = ": " },
			lsp_client_name = { pre = "[", post = "]" },
			spinner = { pre = "", post = "" },
			message = { commenced = "In Progress", completed = "Completed" },
		},
		display_components = {
			"lsp_client_name",
			"spinner",
			{ "title", "percentage", "message" },
		},
		timer = {
			progress_enddelay = 500,
			spinner = 1000,
			lsp_client_name_enddelay = 1000,
		},
		spinner_symbols = { "□", "■", "□", "■", "□", "■", "□", "■" },
	}

	local supermaven_status = {
		function()
			local is_running = supermaven.is_running()
			if is_running then
				return "🤖"
			else
				return "🧠"
			end
		end,
	}

	local lsp_status = {
		function()
			local msg = ""
			local buf_ft = vim.api.nvim_get_option_value("filetype", { buf = 0 })
			local clients = vim.lsp.get_clients()
			if next(clients) == nil then
				return msg
			end
			for _, client in ipairs(clients) do
				local filetypes = client.config.filetypes
				if filetypes and vim.fn.index(filetypes, buf_ft) ~= -1 then
					return client.name
				end
			end
			return msg
		end,
		icon = " ",
	}

	local database_status = {
		function()
			return vim.fn["db_ui#statusline"]({
				show = { "db_name", "schema", "table" },
				separator = "  ",
			})
		end,
		icon = " ",
	}

	local options = {
		icons_enabled = true,
		theme = "catppuccin",
		component_separators = { left = "", right = "" },
		section_separators = { left = "", right = "" },
		disabled_filetypes = { statusline = {}, winbar = {} },
		ignore_focus = {},
		always_divide_middle = true,
		globalstatus = true,
		refresh = {
			statusline = 1000,
			tabline = 1000,
			winbar = 1000,
		},
	}

	local sections = {
		lualine_a = { "mode" },
		lualine_b = { "branch", "diff", "diagnostics" },
		lualine_c = { "filename" },
		lualine_x = { supermaven_status, lsp_progress, lsp_status, database_status, "filetype" },
		lualine_y = { "encoding", "fileformat" },
		lualine_z = { "location" },
	}

	local inactive_sections = {
		lualine_a = {},
		lualine_b = {},
		lualine_c = { "filename" },
		lualine_x = { "location" },
		lualine_y = {},
		lualine_z = {},
	}

	---@diagnostic disable-next-line: undefined-field
	lualine.setup({
		options = options,
		sections = sections,
		inactive_sections = inactive_sections,
		tabline = {},
		winbar = {},
		inactive_winbar = {},
		extensions = {},
	})
end
