local autocmd = vim.api.nvim_create_autocmd

autocmd({ "BufRead", "BufNewFile" }, {
	pattern = "*.templ",
	callback = function()
		vim.opt.filetype = "templ"
	end,
})
