return {
  "mrcjkb/rustaceanvim",
  version = "^6",
  ft = { "rust" },
  config = function()
    vim.g.rustaceanvim = {
      server = {
        on_attach = function(client, bufnr)
          if vim.lsp.inlay_hint then
            vim.lsp.inlay_hint.enable(true, { bufnr })
          end

          vim.keymap.set(
            "n",
            "K", -- Override Neovim's built-in hover keymap with rustaceanvim's hover actions
            function()
              vim.cmd.RustLsp({ "hover", "actions" })
            end,
            { silent = true, buffer = bufnr }
          )
        end,
      },
    }
  end,
}
