local run_projectionist_command = function(command)
  if vim.fn.exists(":" .. command) == 2 then
    vim.cmd(command)
  else
    vim.notify("No Projectionist alternate for this buffer", vim.log.levels.WARN)
  end
end

return {
  "tpope/vim-projectionist",
  lazy = false,
  config = function()
    local group = vim.api.nvim_create_augroup("eborsa-projectionist", { clear = true })

    vim.api.nvim_create_autocmd("User", {
      group = group,
      pattern = "ProjectionistDetect",
      callback = function()
        local projections = {
          ["*.py"] = {
            skeleton = "mod",
            alternate = "test_{}.py",
          },
          ["test_*.py"] = {
            skeleton = "case",
            alternate = "{}.py",
          },
          ["src/*.erl"] = {
            skeleton = "mod",
            alternate = "test/{}_tests.erl",
          },
          ["test/*_tests.erl"] = {
            skeleton = "case",
            alternate = "src/{}.erl",
          },
        }

        if vim.fn.findfile("mix.exs", ".;") ~= "" then
          projections["*"] = {
            dispatch = "mix test",
            start = "iex -S mix phx.server",
          }
          projections["lib/*.ex"] = {
            type = "lib",
            skeleton = "mod",
            alternate = "test/{}_test.exs",
          }
          projections["test/*_test.exs"] = {
            type = "test",
            skeleton = "case",
            alternate = "lib/{}.ex",
            dispatch = "mix test {file}`=v:lnum ? ':'.v:lnum : ''`",
          }
          projections["mix.exs"] = { type = "mix" }
          projections["config/*.exs"] = { type = "config" }
        end

        vim.fn["projectionist#append"](vim.fn.getcwd(), projections)
      end,
    })
  end,
  keys = {
    {
      "<leader>faa",
      function()
        run_projectionist_command("A")
      end,
      desc = "Alternate in current window",
    },
    {
      "<leader>fas",
      function()
        run_projectionist_command("AS")
      end,
      desc = "Alternate in horizontal split",
    },
    {
      "<leader>fav",
      function()
        run_projectionist_command("AV")
      end,
      desc = "Alternate in vertical split",
    },
  },
}
