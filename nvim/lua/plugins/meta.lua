local function directory_exists(dir)
  local stat = vim.loop.fs_stat(dir)
  if stat then
    return stat.type == "directory"
  else
    return false
  end
end

return {
  dir = "/usr/share/fb-editor-support/nvim",
  name = "meta.nvim",
  enabled = directory_exists("/usr/share/fb-editor-support/"),
}
