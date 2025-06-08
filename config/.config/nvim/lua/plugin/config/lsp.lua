return function()
	---------------------------------- CONFIG ------------------------------------
	local config = {
		ensure_installed = {
			"gopls",
			"lua_ls",
		},
	}

	----------------------------------- MASON ------------------------------------
	local mason = require("mason")
	local mason_lsp = require("mason-lspconfig")

	mason.setup()
	mason_lsp.setup({ ensure_installed = config.ensure_installed })

	------------------------------------ LSP -------------------------------------
	local lspconfig = require("lspconfig")
	local cmp_lsp = require("cmp_nvim_lsp")
	local utils = require("core.utils")

	-- LSP settings
	local capabilities = cmp_lsp.default_capabilities(vim.lsp.protocol.make_client_capabilities())
	capabilities.textDocument.completion.completionItem = {
		documentationFormat = { "markdown", "plaintext" },
		snippetSupport = true,
		preselectSupport = true,
		insertReplaceSupport = true,
		labelDetailsSupport = true,
		deprecatedSupport = true,
		commitCharactersSupport = true,
		tagSupport = { valueSet = { 1 } },
		resolveSupport = {
			properties = {
				"documentation",
				"detail",
				"additionalTextEdits",
			},
		},
	}

	lspconfig.lua_ls.setup({
		settings = {
			Lua = {
				diagnostics = { globals = { "vim" } },
				workspace = {
					library = {
						[vim.fn.expand("$VIMRUNTIME/lua")] = true,
						[vim.fn.expand("$VIMRUNTIME/lua/vim/lsp")] = true,
						[vim.fn.stdpath("data") .. "/lazy"] = true,
					},
				},
			},
		},
		capabilities = capabilities,
	})

	lspconfig.gopls.setup({
		capabilities = capabilities,
		cmd = { "gopls" },
		filetypes = { "go", "gomod", "gowork", "gotmpl" },
		root_dir = lspconfig.util.root_pattern("go.mod", "go.work", ".git"),
		settings = {
			gopls = {
				gofumpt = true,
				completeUnimported = true,
				usePlaceholders = true,
				staticcheck = true,
				analyses = { unusedparams = true },
			},
		},
	})

	lspconfig.ts_ls.setup({
		capabilities = capabilities,
	})

	utils.set_diagnostic_sign({
		Error = " ",
		Warn = " ",
		Hint = " ",
		Info = " ",
	})

	vim.diagnostic.config({
		underline = true,
		float = {
			show_header = true,
			source = "if_many",
			border = "rounded",
			focusable = false,
		},
	})
end
