return {
	{
		"nvim-neo-tree/neo-tree.nvim",
		branch = "v3.x",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-tree/nvim-web-devicons",
			"MunifTanjim/nui.nvim",
		},
		config = function()
			vim.keymap.set("n", "<C-j>", ":Neotree filesystem reveal left<CR>", { noremap = true, silent = true })
		end,
	},
	{ "kyazdani42/nvim-web-devicons" },
}
