return {
	{
		"nvim-telescope/telescope.nvim",
		tag = "v0.1.9",
		dependencies = { "nvim-lua/plenary.nvim" },
		config = function()
			require("telescope").setup({
				defaults = {
					mappings = {
						n = {
							["d"] = require("telescope.actions").delete_buffer,
							["q"] = require("telescope.actions").close,
							["<C-c>"] = require("telescope.actions").close,
						},
					},
				},
			})
			local builtin = require("telescope.builtin")
			-- vim.keymap.set("n", "<leader>ff", builtin.find_files, {})
			vim.keymap.set("n", "gd", "<cmd>Telescope lsp_definitions initial_mode=normal theme=dropdown<cr>")
			vim.keymap.set("n", "<leader>fg", builtin.live_grep, {})
			vim.keymap.set("n", "<leader>fh", builtin.help_tags, {})
			vim.keymap.set("n", "<leader>fb", builtin.current_buffer_fuzzy_find, {})
			vim.keymap.set("n", "<leader>fe", "<cmd>Telescope diagnostics initial_mode=normal theme=dropdown<cr>", {})

			vim.keymap.set(
				"n",
				"<Tab>",
				"<cmd>Telescope buffers sort_mru=true sort_lastused=true initial_mode=normal theme=dropdown<cr>",
				{}
			)
		end,
	},
	{
		"nvim-telescope/telescope-ui-select.nvim",
		config = function()
			require("telescope").setup({
				extensions = {
					["ui-select"] = {
						require("telescope.themes").get_dropdown({}),
					},
				},
			})
			require("telescope").load_extension("ui-select")
		end,
	},
	{
		"nvim-telescope/telescope-fzf-native.nvim",
		build = "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release",
	},
}
