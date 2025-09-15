return function()
	local formatter = require("formatter")
	local default = require("formatter.defaults")

	local filetype = {}

	local function load_formatter(ft_pair, fmt_name)
		if type(ft_pair) == "string" then
			ft_pair = { ft_pair, ft_pair }
		end

		filetype[ft_pair[1]] = require("formatter.filetypes." .. ft_pair[2])[fmt_name]
	end

	load_formatter("lua", "stylua")
	load_formatter("json", "prettierd")
	load_formatter("html", "prettierd")
	load_formatter({ "svelte", "html" }, "prettierd")
	load_formatter({ "htmldjango", "html" }, "prettierd")
	load_formatter("css", "prettierd")
	load_formatter({ "sass", "css" }, "prettierd")
	load_formatter({ "scss", "css" }, "prettierd")
	load_formatter("javascript", "prettierd")
	load_formatter("javascriptreact", "prettierd")
	load_formatter("typescript", "prettierd")
	load_formatter("typescriptreact", "prettierd")
	load_formatter("terraform", "terraform_fmt")
	load_formatter("go", "gofumt")
	load_formatter("go", "goimports")
	load_formatter("go", "golines")
	load_formatter("sh", "shfmt")
	load_formatter("sql", "pgformat")
	load_formatter("toml", "taplo")
	load_formatter("rust", "rustfmt")
	load_formatter("dart", "dartformat")
	load_formatter("python", "black")

	filetype["php"] = function()
		if vim.fn.filereadable("artisan") == 0 or vim.fn.executable("./vendor/bin/pint") == 0 then
			return default.php_cs_fixer()
		end

		return {
			exe = "./vendor/bin/pint",
			args = {
				"--quiet",
			},
			stdin = false,
		}
	end

	filetype["astro"] = function()
		return {
			exe = "prettierd",
			args = { vim.api.nvim_buf_get_name(0) },
			stdin = true,
		}
	end

	filetype["blade"] = function()
		return {
			exe = "blade-formatter",
			args = {
				"--stdin",
				vim.fn.expand("%:p"),
			},
			stdin = true,
		}
	end

	filetype["*"] = require("formatter.filetypes.any").remove_trailing_whitespace

	formatter.setup({
		logging = false,
		filetype = filetype,
	})
end
