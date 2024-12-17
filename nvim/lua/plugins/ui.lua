return {
  {
    "rcarriga/nvim-notify",
    keys = {
      {
        "<leader>uh",
        function()
          require("telescope").load_extension("notify")
          require("telescope").extensions.notify.notify()
        end,
        desc = "View messages history",
      },
    },
  },
}
