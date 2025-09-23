local telescope = require("telescope")
local luasnip = require("luasnip")
local suggestion = require("supermaven-nvim.completion_preview")
local fterm = require("plugin.config.fterm")
local utils = require("core.utils")

local keymaps = utils.keymaps
local map = utils.map
local nmap = utils.nmap
local imap = utils.imap
local vmap = utils.vmap
local tmap = utils.tmap

local function opts(desc)
	return { noremap = true, silent = true, desc = desc }
end

local maps = {
	-- general mappings
	nmap("<c-s>", "<cmd>w<cr>", opts("Save")),
	nmap("<c-w>", "<cmd>bd<cr>", opts("Close buffer")),
	tmap("<c-x>", "<C-\\><C-n>", opts("Exit terminal mode")),

	-- keep it centered
	nmap("<c-d>", "<c-d>zz", opts("Scroll down and keep cursor position")),
	nmap("<c-u>", "<c-u>zz", opts("Scroll up and keep cursor position")),

	-- undo breakpoints
	nmap("<m-j>", ":m .+1<cr>==", opts("Move current line down")),
	nmap("<m-k>", ":m .-2<cr>==", opts("Move current line up")),
	nmap("<m-j>", "<cmd>exec 'normal! m .+1<cr>=='<cr>", opts("Move current line down")),
	nmap("<m-k>", "<cmd>exec 'normal! m .-2<cr>=='<cr>", opts("Move current line up")),

	-- moving text
	vmap("<m-j>", ":m '>+1<cr>gv=gv", opts("Move selected text down")),
	vmap("<m-k>", ":m '<-2<cr>gv=gv", opts("Move selected text up")),
	imap("<m-j>", "<esc>:m .+1<cr>==a", opts("Move current line down")),
	imap("<m-k>", "<esc>:m .-2<cr>==a", opts("Move current line up")),
	nmap("<m-j>", ":m .+1<cr>==", opts("Move current line down")),
	nmap("<m-k>", ":m .-2<cr>==", opts("Move current line up")),

	-- quickfix
	nmap("<m-[>", "<cmd>cprev<cr>", opts("Previous Quickfix List Item")),
	nmap("<m-]>", "<cmd>cnext<cr>", opts("Next Quickfix List Item")),

	-- moving between windows
	nmap("<c-h>", "<c-w>h", opts("Move to window on the left")),
	nmap("<c-j>", "<c-w>j", opts("Move to window below")),
	nmap("<c-k>", "<c-w>k", opts("Move to window above")),
	nmap("<c-l>", "<c-w>l", opts("Move to window on the right")),

	-- manual indent selection
	vmap("<c-j>", "<gv", opts("Indent selection left")),
	vmap("<c-k>", "><gv", opts("Indent selection right")),

	-- horizontal scroll mouse
	map({ "n", "v", "i" }, "<S-ScrollWheelDown>", "zl6", opts("Scroll right")),
	map({ "n", "v", "i" }, "<S-ScrollWheelUp>", "zh6", opts("Scroll left")),

	-- LSP
	nmap("`", "<cmd>lua vim.lsp.buf.code_action()<cr>", opts("Code action")),
	nmap("K", "<cmd>lua vim.lsp.buf.hover()<cr>", opts("Hover")),
	nmap("<F2>", "<cmd>lua vim.lsp.buf.rename()<cr>", opts("Rename")),
	nmap("gD", "<cmd>lua vim.lsp.buf.declaration()<cr>", opts("Declaration")),
	nmap("gd", "<cmd>lua vim.lsp.buf.definition()<cr>", opts("Definition")),
	nmap("gt", "<cmd>lua vim.lsp.buf.type_definition()<cr>", opts("Type definition")),
	nmap("gi", "<cmd>lua vim.lsp.buf.implementation()<cr>", opts("Implementation")),
	nmap("gr", "<cmd>lua vim.lsp.buf.references()<cr>", opts("References")),
	nmap("<F3>", "<cmd>lua vim.lsp.buf.format()<cr>", opts("Format")),
	nmap("lwa", "<cmd>lua vim.lsp.buf.add_workspace_folder()<cr>", opts("Add workspace folder")),
	nmap("lwr", "<cmd>lua vim.lsp.buf.remove_workspace_folder()<cr>", opts("Remove workspace folder")),
	nmap(
		"lws",
		"<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<cr>",
		opts("List workspace folders")
	),

	-- LSP Diagnostics
	nmap("<leader>e", "<cmd>lua vim.diagnostic.open_float()<cr>", opts("Open diagnostics")),

	-- Telescope
	nmap("<c-p>", "<cmd>Telescope find_files hidden=true<cr>", opts("Find files")),
	nmap("<c-t>", "<cmd>Telescope commands<cr>", opts("Commands")),
	nmap("<m-t>", "<cmd>Telescope<cr>", opts("Telescope")),
	nmap("<m-b>", "<cmd>Telescope buffers<cr>", opts("Buffers")),
	nmap("<m-r>", function()
		telescope.extensions.live_grep_args.live_grep_args()
	end, opts("Live grep args")),
	nmap("<m-p>", "<cmd>Telescope live_grep<cr>", opts("Live grep")),

	-- Luasnip
	map({ "i", "s" }, "<c-j>", function()
		if luasnip.expand_or_jumpable() then
			luasnip.expand_or_jump()
		elseif suggestion.has_suggestion() then
			suggestion.on_accept_suggestion()
		end
	end, opts("Expand or jump snippet")),
	map({ "i", "s" }, "<c-k>", function()
		if luasnip.jumpable(-1) then
			luasnip.jump(-1)
		end
	end, opts("Jump to previous snippet")),
	map({ "i", "s" }, "<c-l>", function()
		luasnip.change_choice(1)
	end, opts("Change snippet choice")),

	-- Dadbod
	nmap("<m-d>", "<cmd>DBUIToggle<cr>", opts("Toggle dadbod")),

	-- Oil
	nmap("-", "<cmd>Oil<cr>", opts("Open parent directory")),

	-- FTerm
	nmap("<leader>tt", function()
		fterm.terminal:toggle()
	end, opts("Toggle terminal")),
	nmap("<leader>tg", function()
		fterm.lazygit:toggle()
	end, opts("Toggle lazygit")),
	nmap("<leader>tf", function()
		fterm.filemanager:toggle()
	end, opts("Toggle filemanager")),
	nmap("<leader>th", function()
		fterm.htop:toggle()
	end, opts("Toggle htop")),
	nmap("<leader>tc", function()
		fterm.ai:toggle()
	end, opts("Toggle ai")),

	-- Zen mode
	nmap("<leader>zz", "<cmd>ZenMode<cr>", opts("Toggle zen mode")),

	-- Nvim Tree
	nmap("<leader>f", "<cmd>NvimTreeToggle<cr>", opts("Toogle Neovim Tree")),
}

utils.ignore_keymaps({
	{ "n", "<C-l>" }, -- clear search highlight
	{ "n", "<c-l>" }, -- clear search highlight
})
keymaps(maps, {
	report_conflicts = true,
	abort_on_conflict = true,
	override_conflicts = true,
	log_level = "silent",
})
