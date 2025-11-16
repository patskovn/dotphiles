local function directory_exists(dir)
	local stat = vim.loop.fs_stat(dir)
	if stat then
		return stat.type == "directory"
	else
		return false
	end
end

return {
	"kdheepak/lazygit.nvim",
	lazy = true,
	enabled = not directory_exists("/usr/share/fb-editor-support/"),
	cmd = {
		"LazyGit",
		"LazyGitConfig",
		"LazyGitCurrentFile",
		"LazyGitFilter",
		"LazyGitFilterCurrentFile",
	},
	-- optional for floating window border decoration
	dependencies = {
		"nvim-lua/plenary.nvim",
	},
	-- setting the keybinding for LazyGit with 'keys' is recommended in
	-- order to load the plugin when the command is run for the first time
	keys = {
		{ "<leader>sl", "<cmd>LazyGitCurrentFile<cr>", desc = "LazyGit" },
	},
}
