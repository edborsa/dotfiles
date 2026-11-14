local ok, spec = pcall(require, "eborsa.plugins.lsp.lsp")

if ok and type(spec.config) == "function" then
  spec.config()
end
