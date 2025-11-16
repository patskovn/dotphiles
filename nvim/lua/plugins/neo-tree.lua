return {
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "MunifTanjim/nui.nvim",
    },
    config = function()
      vim.keymap.set("n", "<leader>j", ":Neotree filesystem reveal left<CR>", { noremap = true, silent = true })

      require("neo-tree").setup({
        filesystem = {
          window = {
            mappings = {
              ["<leader>p"] = "image_wezterm", -- " or another map
              Y = "copy_selector",
            },
          },
          commands = {
            image_wezterm = function(state)
              local node = state.tree:get_node()
              if node.type == "file" then
                require("image_preview").PreviewImage(node.path)
              end
            end,
            copy_selector = function(state)
              local node = state.tree:get_node()
              local filepath = node:get_id()
              local filename = node.name
              local modify = vim.fn.fnamemodify

              local vals = {
                ["BASENAME"] = modify(filename, ":r"),
                ["EXTENSION"] = modify(filename, ":e"),
                ["FILENAME"] = filename,
                ["PATH (CWD)"] = modify(filepath, ":."),
                ["PATH (HOME)"] = modify(filepath, ":~"),
                ["PATH"] = filepath,
                ["URI"] = vim.uri_from_fname(filepath),
              }

              local options = vim.tbl_filter(function(val)
                return vals[val] ~= ""
              end, vim.tbl_keys(vals))
              if vim.tbl_isempty(options) then
                vim.notify("No values to copy", vim.log.levels.WARN)
                return
              end
              table.sort(options)
              vim.ui.select(options, {
                prompt = "Choose to copy to clipboard:",
                format_item = function(item)
                  return ("%s: %s"):format(item, vals[item])
                end,
              }, function(choice)
                local result = vals[choice]
                if result then
                  vim.notify(("Copied: `%s`"):format(result))
                  vim.fn.setreg("+", result)
                end
              end)
            end,
          },
        },
        default_component_configs = {
          git_status = {
            symbols = {
              -- Change type
              added = "✚",
              deleted = "✖",
              modified = "",
              renamed = "󰁕",
              -- Status type
              untracked = "",
              ignored = "I",
              unstaged = "U",
              staged = "S",
              conflict = "",
            },
          },
        },
      })
    end,
  },
  { "kyazdani42/nvim-web-devicons" },
}
