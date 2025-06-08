local autocmd = vim.api.nvim_create_autocmd

autocmd({ "BufRead", "BufNewFile" }, {
	pattern = "*.blade.php",
	callback = function()
		vim.opt.filetype = "blade"
	end,
})
