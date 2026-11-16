return {
  "iamcco/markdown-preview.nvim",
  cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
  ft = { "markdown" },
  -- Run the preview server on mise's Node instead of the prebuilt binary,
  -- which is Intel-only on macOS and often fails to download.
  -- --no-package-lock keeps the plugin checkout clean for lazy updates.
  build = "cd app && npm install --no-fund --no-audit --no-package-lock",
  config = function()
    vim.g.mkdp_auto_start = 0
    vim.g.mkdp_auto_close = 1
    vim.g.mkdp_refresh_slow = 0
    vim.g.mkdp_browser = ""
    vim.g.mkdp_theme = "dark"
  end,
}
