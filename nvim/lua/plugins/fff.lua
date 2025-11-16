local function directory_exists(dir)
  local stat = vim.loop.fs_stat(dir)
  if stat then
    return stat.type == "directory"
  else
    return false
  end
end

return {
	"dmtrKovalenko/fff.nvim",
	build = "cargo build --release",
  enabled = not directory_exists("/usr/share/fb-editor-support/"),
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
