return {
	"mrcjkb/rustaceanvim",
	version = "^4", -- Recommended
	ft = { "rust" },
	dependencies = {
		{
			"lvimuser/lsp-inlayhints.nvim",
			opts = {},
		},
	},
	config = function()
		vim.g.rustaceanvim = {
			tools = {
				hover_actions = {
					auto_focus = true,
				},
			},
			server = {
				on_attach = function(client, bufnr)
					require("lsp-inlayhints").on_attach(client, bufnr)
					require("lsp-inlayhints").show()
					vim.lsp.inlay_hint(bufnr, true)
				end,
			},
		}
	end,
}
