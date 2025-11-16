local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("vim-options")
require("lazy").setup("plugins")
require("load/load_main")

local orig_util_open_floating_preview = vim.lsp.util.open_floating_preview

vim.lsp.util.open_floating_preview = function(contents, syntax, opts, ...)
  opts = opts or {}
  opts.border = opts.border or "rounded"
  return orig_util_open_floating_preview(contents, syntax, opts, ...)
end

local lsp_rrors_diag_ns = vim.api.nvim_create_namespace("lsp_error_line_highlight")

local function highlight_error_lines(diagnostics)
  local width = vim.api.nvim_get_option("columns")

  for _, d in ipairs(diagnostics) do
    local bufnr = d.bufnr
    if d.severity == vim.diagnostic.severity.ERROR and vim.api.nvim_buf_is_loaded(bufnr) then
      local lnum = d.lnum

      -- Get current line length and pad the rest with spaces
      local line = vim.api.nvim_buf_get_lines(bufnr, lnum, lnum + 1, false)[1] or ""
      local pad = width - #line
      local virt_text = { { string.rep(" ", pad > 0 and pad or 0), "LspErrorLine" } }

      vim.api.nvim_buf_set_extmark(bufnr, lsp_rrors_diag_ns, lnum, 0, {
        hl_group = "LspErrorLine",
        end_row = lnum + 1,
        hl_mode = "combine",
      })

      -- Highlight rest of the line with padded virtual text
      vim.api.nvim_buf_set_extmark(bufnr, lsp_rrors_diag_ns, lnum, #line, {
        virt_text = virt_text,
        virt_text_pos = "overlay",
      })
    end
  end
end

vim.diagnostic.handlers["patskovn_highlight_bg"] = {
  show = function(namespace, bufnr, diagnostics, opts)
    highlight_error_lines(diagnostics)
  end,
  hide = function(namespace, bufnr)
    vim.api.nvim_buf_clear_namespace(bufnr, lsp_rrors_diag_ns, 0, -1)
  end,
}

vim.keymap.set("n", "<leader>ih", function()
  local bufnr = vim.api.nvim_get_current_buf()
  local enabled = vim.lsp.inlay_hint.is_enabled({ bufnr = bufnr })

  vim.lsp.inlay_hint.enable(not enabled, { bufnr = bufnr })

  if not enabled then
    vim.notify("Inlay hints enabled", vim.log.levels.INFO)
  else
    vim.notify("Inlay hints disabled", vim.log.levels.INFO)
  end
end, { desc = "Toggle Inlay Hints" })
