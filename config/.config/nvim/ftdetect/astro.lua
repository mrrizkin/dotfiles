local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

local astro_group = augroup("AstroFileRelated", { clear = true })
autocmd({ "BufRead", "BufNewFile" }, {
	pattern = "*.astro",
	group = astro_group,
	callback = function()
		vim.opt.filetype = "astro"
	end,
})
