return {
	"dmtrKovalenko/fff.nvim",
	build = "cargo build --release",
	opts = {
		debug = {
			enabled = true,
		},
	},
	lazy = false,
	keys = {
		{
			"<leader>ff",
			function()
				require("fff").find_files()
			end,
			desc = "FFFind files",
		},
	},
	config = function()
		require("fff").setup({
			keymaps = {
				close = "<C-c>",
			},
		})
	end,
}
