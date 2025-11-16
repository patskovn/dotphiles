local on_attach = function(client, bufnr)
  if client.server_capabilities.documentFormattingProvider then
    vim.cmd([[
        augroup LspFormatting
            autocmd! * <buffer>
            autocmd BufWritePre <buffer> silent noa w | lua vim.lsp.buf.format({async=false,timeout_ms=30000})
        augroup END
        ]])
  end
  if vim.lsp.inlay_hint then
    vim.lsp.inlay_hint.enable(true, { bufnr })
  end
end

local ok, meta = pcall(require, "meta")

if not ok then
  print("Module had an error")
else
  meta.setup()
  require("meta.lsp")
  local null_ls = require("null-ls")
  local servers = { "buck2@meta", "rust-analyzer@meta", "pyls@meta", "pyre@meta", "thriftlsp@meta", "cppls@meta" }
  for _, lsp in ipairs(servers) do
    require("lspconfig")[lsp].setup {
      on_attach = on_attach,
    }
  end

  null_ls.setup({
    on_attach = on_attach,
    sources = {
      meta.null_ls.diagnostics.arclint,
      meta.null_ls.formatting.arclint,
      meta.null_ls.diagnostics.rust_clippy,
    }
  })
  require('telescope').setup {
    extensions = {
      fzf = {
        fuzzy = true,                   -- false will only do exact matching
        override_generic_sorter = true, -- override the generic sorter
        override_file_sorter = true,    -- override the file sorter
        case_mode = "smart_case",       -- or "ignore_case" or "respect_case"
        -- the default case_mode is "smart_case"
      }
    }
  }
  require("telescope").load_extension("myles")
  require("telescope").load_extension("biggrep")
  require("telescope").load_extension("hg")
  require("telescope").load_extension("fzf")

  vim.keymap.set("n", "<leader>ff", "<cmd>Telescope myles<cr>", {})
  vim.keymap.set("n", "<leader>fg", "<cmd>Telescope biggrep<cr>", {})

  require("meta.hg").setup {
    line_blame = {
      enable = false, -- change to true if you want line blame to be displayed by default
      highlight = "Comment",
      prefix = string.rep(" ", 4),
    },
  }
  vim.keymap.set("n", "<leader>sl", "<cmd>HgSsl<cr>", {})
end
