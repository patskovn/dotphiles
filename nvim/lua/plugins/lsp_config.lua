return {
	{
		"williamboman/mason.nvim",
		config = function()
			require("mason").setup()
		end,
	},
	{
		"williamboman/mason-lspconfig.nvim",
	},
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			{
				"aznhe21/actions-preview.nvim",
				dependencies = {
					"nvim-telescope/telescope.nvim",
				},
				config = function()
					require("actions-preview").setup({
						backend = { "telescope" },
						telescope = vim.tbl_extend("force", require("telescope.themes").get_dropdown(), {}),
					})
				end,
			},
		},
		config = function()
			vim.keymap.set("n", "K", vim.lsp.buf.hover, {})
			-- vim.keymap.set("n", "gd", vim.lsp.buf.definition, {})
			vim.keymap.set("n", "<leader>e", function()
				vim.diagnostic.open_float(0, { scope = "line" })
			end, {})
			vim.api.nvim_set_keymap("n", "<leader>rn", "<cmd>lua vim.lsp.buf.rename()<CR>", {})

			local actions_preview = require("actions-preview")
			vim.keymap.set({ "n", "v" }, "<leader>ca", function()
				-- Request code actions for whole line
				local start_pos = vim.api.nvim_win_get_cursor(0)
				local row = start_pos[1]
				local range = {
					start = { row, 0 },
					["end"] = { row, 999999 },
				}
				actions_preview.code_actions({
					range = range,
				})
			end, {})
		end,
		opts = {
			inlay_hints = { enabled = true },
			format = {
				timeout_ms = 2500,
			},
			setup = {
				rust_analyzer = function()
					return true
				end,
			},
		},
	},
}
