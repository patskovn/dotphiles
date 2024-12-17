return {
  "patskovn/auto-dark-mode.nvim",
  config = {
    update_interval = 3000,
    server_port = 12142,
    set_dark_mode = function()
      local catpuccin = require("catppuccin")
      catpuccin.setup({
        flavour = "frappe",
      })
      vim.cmd.colorscheme("catppuccin")
    end,
    set_light_mode = function()
      local catpuccin = require("catppuccin")
      catpuccin.setup({
        flavour = "latte",
      })
      vim.api.nvim_set_option("background", "light")
      vim.cmd.colorscheme("catppuccin")
    end,
  },
}
