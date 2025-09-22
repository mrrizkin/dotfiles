return function()
	---------------------------------- CONFIG ------------------------------------
	local config = {
		ensure_installed = {
			"gopls",
			"lua_ls",
			"ts_ls",
		},
	}

	----------------------------------- MASON ------------------------------------
	local mason = require("mason")
	local mason_lsp = require("mason-lspconfig")
	local signature = require("lsp_signature")
	local virtual_lsp = require("lsp_lines")

	mason.setup()
	mason_lsp.setup({ ensure_installed = config.ensure_installed })
	signature.setup()
	virtual_lsp.setup()

	------------------------------------ LSP -------------------------------------
	local cmp_lsp = require("cmp_nvim_lsp")

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

	vim.lsp.config("lua_ls", {
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

	vim.lsp.config("gopls", {
		capabilities = capabilities,
		settings = {
			gopls = {
				gofumpt = true,
				completeUnimported = true,
				usePlaceholders = true,
				staticcheck = true,
				analyses = {
					unusedparams = true,
					nilness = true,
					packagecomment = false,
				},
			},
		},
	})

	vim.lsp.config("elixirls", {
		capabilities = capabilities,
	})

	vim.lsp.config("pyright", {
		capabilities = capabilities,
		settings = {
			python = {
				analysis = {
					autoSearchPaths = true,
					diagnosticMode = "strict",
					useLibraryCodeForTypes = true,
					extraPaths = {
						vim.fn.stdpath("data") .. "/lazy/github.com/nvim-treesitter/nvim-treesitter",
					},
				},
			},
		},
	})

	vim.lsp.config("svelte", {
		capabilities = capabilities,
	})

	vim.lsp.config("ts_ls", {
		capabilities = capabilities,
	})

	vim.diagnostic.config({
		signs = {
			text = {
				[vim.diagnostic.severity.ERROR] = " ",
				[vim.diagnostic.severity.WARN] = " ",
				[vim.diagnostic.severity.INFO] = " ",
				[vim.diagnostic.severity.HINT] = " ",
			},
		},
		virtual_text = false,
		virtual_lines = true,
		underline = true,
		float = {
			show_header = true,
			source = "if_many",
			border = "rounded",
			focusable = false,
		},
	})
end
