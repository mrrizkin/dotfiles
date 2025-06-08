local opt = vim.opt
local g = vim.g

------------------------------------ GLOBAL ------------------------------------
g.mapleader = " "
g.maplocalleader = ","

-- Disable some providers
for _, v in ipairs({ "node", "perl", "python", "python3", "ruby" }) do
	g["loaded_" .. v .. "_provider"] = 0
end

----------------------------------- OPTIONS ------------------------------------
opt.laststatus = 3
opt.showmode = false
opt.showcmd = true

opt.clipboard = "unnamedplus"
opt.cursorline = true

-- Indenting
opt.expandtab = true
opt.smarttab = true
opt.smartindent = true
opt.tabstop = 2
opt.softtabstop = 2
opt.shiftwidth = 2

opt.fillchars = { eob = " " }
opt.ignorecase = true
opt.smartcase = true
opt.mouse = "a"

-- Numbers
opt.number = true
opt.relativenumber = true
opt.numberwidth = 3
opt.ruler = true

-- Disable nvim intro
opt.shortmess:append("sI")

opt.signcolumn = "yes"
opt.splitbelow = true
opt.splitright = true
opt.termguicolors = true

opt.background = "dark"
opt.undofile = true
opt.synmaxcol = 200
opt.confirm = true
opt.lazyredraw = true
opt.showmatch = true
opt.hlsearch = false
opt.incsearch = true

opt.wrap = false
opt.colorcolumn = "81"
opt.completeopt = "menu,menuone,noselect"

opt.hidden = true
opt.swapfile = false
opt.backup = false
opt.writebackup = false

opt.scrolloff = 8
opt.list = false
opt.listchars = "eol:¬,tab:▏ ,trail:~,extends:>,precedes:<,nbsp:␣"
opt.modeline = false
opt.timeoutlen = 300

opt.wildignore = "*/node_modules/*,*/tmp/*,*.so,*.swp,*.zip,*.pyc,*.db,*.sqlite"

opt.foldenable = false
-- opt.foldmethod = "expr"
-- opt.foldcolumn = "auto:3"
-- opt.foldexpr = "nvim_treesitter#foldexpr()"

-- interval for writing swap file to disk
opt.updatetime = 250

-- disable cursor blinking
opt.guicursor:append("a:blinkoff0")

-- go to previous/next file with h,l,left arrow and right arrow
-- when cursor reaches end/beginning of line
opt.whichwrap:append("<>[]hl")

----------------------------------- AUTOCMDS -----------------------------------
local autocmd = vim.api.nvim_create_autocmd

autocmd("BufWritePost", {
	pattern = "*",
	command = "silent! FormatWrite",
})

----------------------------------- COMMANDS -----------------------------------
local newcmd = vim.api.nvim_create_user_command

-- Reload vimrc
newcmd("Reload", "source $MYVIMRC | redraw! | echomsg 'Reloaded'", {})

-- Format buffer with LSP
newcmd("FormatLSP", function()
	vim.lsp.buf.formatting()
end, {})

-- Abbreviations
vim.cmd("cnoreabbrev W! w!")
vim.cmd("cnoreabbrev Q! q!")
vim.cmd("cnoreabbrev Qall! qall!")
vim.cmd("cnoreabbrev Wq wq")
vim.cmd("cnoreabbrev Wa wa")
vim.cmd("cnoreabbrev wQ wq")
vim.cmd("cnoreabbrev WQ wq")
vim.cmd("cnoreabbrev W w")
vim.cmd("cnoreabbrev Q q")
vim.cmd("cnoreabbrev Qall qall")
