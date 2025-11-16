local function directory_exists(dir)
  local stat = vim.loop.fs_stat(dir)
  if stat then
    return stat.type == "directory"
  else
    return false
  end
end

return {
  "mrcjkb/rustaceanvim",
  version = "^6",
  ft = { "rust" },
  enabled = not directory_exists("/usr/share/fb-editor-support/"),
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
