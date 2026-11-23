return {
  "catppuccin/nvim",
  name = "catppuccin",
  priority = 1000,
  config = function()
    require("catppuccin").setup({
      flavour = "mocha", -- latte, frappe, macchiato, mocha
      transparent_background = false, -- set to true if you would like to enable transparency
      integrations = {
        cmp = true,
        gitsigns = true,
        nvimtree = true,
        telescope = { enabled = true },
        treesitter = true,
        which_key = true,
        indent_blankline = { enabled = true },
        native_lsp = { enabled = true },
        mason = true,
      },
    })

    vim.cmd.colorscheme("catppuccin")
  end,
}
