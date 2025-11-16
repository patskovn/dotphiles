local ok, _ = pcall(require, "meta")

if not ok then
  require("load/load_private")
else
  require("load/load_meta")
end
