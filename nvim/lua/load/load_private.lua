require("mason-lspconfig").setup({
	ensure_installed = {
		"lua_ls",
		"gopls",
		"html",
		"jsonls",
		"dockerls",
		"ts_ls",
		"rust_analyzer",
	},
	automatic_enable = {
		exclude = { "rust_analyzer" },
	},
})

local capabilities = require("cmp_nvim_lsp").default_capabilities()

vim.lsp.config("html", {
	capabilities = capabilities,
})
vim.lsp.config("jsonls", {
	capabilities = capabilities,
})
vim.lsp.config("lua_ls", {
	capabilities = capabilities,
})
vim.lsp.config("dockerls", {
	capabilities = capabilities,
})

vim.lsp.config("gopls", {
	capabilities = capabilities,
	on_attach = function(client, bufnr)
		if vim.lsp.inlay_hint then
			vim.lsp.inlay_hint.enable(true, { bufnr })
		end
	end,
	settings = {
		gopls = {
			hints = {
				parameterNames = true,
				assignVariableTypes = true,
			},
		},
	},
})
vim.lsp.config("ts_ls", {
	capabilities = capabilities,
	settings = {
		completions = {
			completeFunctionCalls = true,
		},
	},
})
