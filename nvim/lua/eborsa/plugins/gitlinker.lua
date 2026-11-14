return {
  "linrongbin16/gitlinker.nvim",
  keys = {
    {
      "<leader>gho",
      "<cmd>GitLink!<cr>",
      mode = { "n", "v" },
      desc = "Open in GitHub",
    },
    {
      "<leader>ghy",
      "<cmd>GitLink<cr>",
      mode = { "n", "v" },
      desc = "Copy GitHub link",
    },
  },
  opts = {},
}
