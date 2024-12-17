return {
  {
    "williamboman/mason.nvim",
    config = function()
      require("mason").setup()
    end,
  },
  {
    "williamboman/mason-lspconfig.nvim",
    config = function()
      require("mason").setup()
      require("mason-lspconfig").setup({
        ensure_installed = {
          "lua_ls",
          "gopls",
          "html",
          "jsonls",
          "rust_analyzer",
          "dockerls",
          "ts_ls",
        },
      })
    end,
  },
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      {
        "aznhe21/actions-preview.nvim",
        dependencies = {
          "nvim-telescope/telescope.nvim",
        },
        config = function()
          require("actions-preview").setup({
            backend = { "telescope" },
            telescope = vim.tbl_extend("force", require("telescope.themes").get_dropdown(), {}),
          })
        end,
      },
    },
    config = function()
      local capabilities = require("cmp_nvim_lsp").default_capabilities()
      local lspconfig = require("lspconfig")
      local actions_preview = require("actions-preview")

      lspconfig.html.setup({
        capabilities = capabilities,
      })
      lspconfig.jsonls.setup({
        capabilities = capabilities,
      })
      lspconfig.lua_ls.setup({
        capabilities = capabilities,
      })
      lspconfig.dockerls.setup({
        capabilities = capabilities,
      })
      lspconfig.gopls.setup({
        capabilities = capabilities,
      })
      lspconfig.ts_ls.setup({
        capabilities = capabilities,
        settings = {
          completions = {
            completeFunctionCalls = true,
          },
        },
      })

      vim.keymap.set("n", "K", vim.lsp.buf.hover, {})
      vim.keymap.set("n", "gd", vim.lsp.buf.definition, {})
      vim.keymap.set("n", "<leader>e", function()
        vim.diagnostic.open_float(0, { scope = "line" })
      end, {})
      vim.api.nvim_set_keymap("n", "<leader>rn", "<cmd>lua vim.lsp.buf.rename()<CR>", {})
      vim.keymap.set({ "n", "v" }, "<leader>ca", function()
        -- Request code actions for whole line
        local start_pos = vim.api.nvim_win_get_cursor(0)
        local row = start_pos[1]
        local range = {
          start = { row, 0 },
          ["end"] = { row, 999999 },
        }
        actions_preview.code_actions({
          range = range,
        })
      end, {})
    end,
    opts = {
      inlay_hints = { enabled = true },
      setup = {
        rust_analyzer = function()
          return true
        end,
      },
    },
  },
  {
    "lvimuser/lsp-inlayhints.nvim",
    config = function()
      require("lsp-inlayhints").setup()
    end,
  },
}
