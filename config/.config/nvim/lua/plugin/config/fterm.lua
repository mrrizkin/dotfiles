---@diagnostic disable: missing-fields
local fterm = require("FTerm")

local M = {}

local default_dimensions = {
	height = 0.9,
	width = 0.9,
	x = vim.o.columns,
	y = vim.o.lines,
}

M.terminal = fterm

M.lazygit = fterm:new({
	ft = "fterm_lazygit",
	cmd = "lazygit",
	dimensions = default_dimensions,
})

M.filemanager = fterm:new({
	ft = "fterm_filemanager",
	cmd = "lf",
	dimensions = default_dimensions,
})

M.htop = fterm:new({
	ft = "fterm_htop",
	cmd = "htop",
	dimensions = default_dimensions,
})

M.ai = fterm:new({
	ft = "fterm_ai",
	cmd = "qwen",
	dimensions = default_dimensions,
})

return M
