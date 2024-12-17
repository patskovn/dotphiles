return {
  "mrcjkb/rustaceanvim",
  version = "^5", -- Recommended
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
        end,
      },
    }
  end,
}
