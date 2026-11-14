local function open_quickfix()
  if not pcall(vim.cmd, "Copen!") then
    vim.cmd("copen")
  end
end

local function root_has(file)
  local current_file = vim.api.nvim_buf_get_name(0)
  local start = current_file ~= "" and vim.fs.dirname(current_file) or vim.uv.cwd()

  return vim.fs.find(file, { upward = true, path = start })[1] ~= nil
end

local function register_task(prefix, vim_command, key, task)
  if type(task) ~= "table" or not task[1] then
    return
  end

  local command = task[1]
  local lhs = prefix .. key
  local rhs = task.wait and (":" .. vim_command .. " " .. command .. " ") or ("<cmd>" .. vim_command .. " " .. command .. "<cr>")
  local desc = task.desc and (task.desc .. " (" .. command .. ")") or command

  vim.keymap.set("n", lhs, rhs, { desc = desc })
end

local function register_task_group(prefix, vim_command, group)
  if group.root_file and not root_has(group.root_file) then
    return
  end

  local ok, which_key = pcall(require, "which-key")
  if ok and group.desc then
    which_key.add({ { prefix, group = group.desc } })
  end

  local tasks = group.tasks or {}

  if type(tasks) == "table" then
    for key, task in pairs(tasks) do
      register_task(prefix, vim_command, key, task)
    end

    if group.default and tasks[group.default] then
      register_task(prefix, vim_command, "<cr>", tasks[group.default])
    end
  elseif type(tasks) == "function" then
    for key, task in pairs(group.parent_tasks or {}) do
      local command = tasks(task[1])

      if command then
        register_task(prefix, vim_command, key, { command, desc = task.desc })
      end
    end
  end

  for key, subgroup in pairs(group) do
    if type(subgroup) == "table" and not subgroup[1] and key ~= "tasks" and key ~= "parent_tasks" then
      subgroup.parent_tasks = tasks
      register_task_group(prefix .. key, vim_command, subgroup)
    end
  end
end

local mix_groups = {
  i = {
    root_file = "mix.exs",
    desc = "Init (Elixir)",
    default = "s",
    tasks = {
      s = { "mix setup", desc = "Setup" },
    },
  },
  p = {
    root_file = "mix.exs",
    desc = "Phoenix (Elixir)",
    default = "s",
    tasks = {
      s = { "iex -S mix phx.server", desc = "Server" },
      r = { "mix phx.routes", desc = "Routes" },
    },
    g = {
      desc = "Generators",
      tasks = {
        c = { "mix phx.gen.context", desc = "Context", wait = true },
        h = { "mix phx.gen.html", desc = "HTML", wait = true },
        j = { "mix phx.gen.json", desc = "JSON", wait = true },
        l = { "mix phx.gen.live", desc = "LiveView", wait = true },
      },
    },
  },
  c = {
    root_file = "mix.exs",
    desc = "Compile (Elixir)",
    default = "d",
    tasks = {
      d = { "mix compile", desc = "Dev" },
      t = { "MIX_ENV=test mix compile", desc = "Test" },
    },
    w = {
      desc = "Warnings as errors",
      tasks = function(command)
        return command .. " --warnings-as-errors"
      end,
    },
  },
  d = {
    root_file = "mix.exs",
    desc = "Deps (Elixir)",
    default = "g",
    tasks = {
      g = { "mix deps.get", desc = "Get" },
      a = { "mix deps.audit", desc = "Audit" },
      u = { "mix deps.unlock --check-unused", desc = "Check unused" },
      r = { "mix hex.audit", desc = "Check retired" },
      o = { "mix hex.outdated", desc = "Check outdated" },
    },
  },
  e = {
    root_file = "mix.exs",
    desc = "Ecto (Elixir)",
    default = "u",
    tasks = {
      u = { "mix ecto.migrate", desc = "Migrate" },
      b = { "mix ecto.rollback", desc = "Rollback" },
      d = { "mix ecto.drop", desc = "Drop" },
      c = { "mix ecto.create", desc = "Create" },
      s = { "mix ecto.setup", desc = "Setup" },
      r = { "mix ecto.reset", desc = "Reset" },
      l = { "mix ecto.load", desc = "Load" },
      i = { "mix run priv/repo/seeds.exs", desc = "Insert seeds" },
      g = { "mix ecto.gen.migration", desc = "Generate migration", wait = true },
    },
    t = {
      desc = "Test env",
      tasks = function(command)
        if command == "mix ecto.gen.migration" then
          return nil
        end

        return "MIX_ENV=test " .. command
      end,
    },
  },
  f = {
    root_file = "mix.exs",
    desc = "Format (Elixir)",
    default = "a",
    tasks = {
      a = { "mix format", desc = "All files" },
      c = { "mix format %", desc = "Current file" },
    },
  },
  h = {
    root_file = "mix.exs",
    desc = "Help (Elixir)",
    default = "s",
    tasks = {
      d = { "mix doctor", desc = "Doctor" },
      s = { "mix hex.search", desc = "Search docs", wait = true },
      w = { "mix docs --warnings-as-errors", desc = "Docs warnings" },
    },
  },
  l = {
    root_file = "mix.exs",
    desc = "Linters (Elixir)",
    default = "c",
    tasks = {
      c = { "mix credo", desc = "Credo" },
      s = { "mix sobelow --config", desc = "Sobelow" },
      t = { "mix dialyzer", desc = "Dialyzer" },
    },
  },
  t = {
    root_file = "mix.exs",
    desc = "Test (Elixir)",
    default = "a",
    tasks = {
      a = { "mix test", desc = "All" },
      c = { "mix coveralls", desc = "Coverage" },
      h = { "mix coveralls.html", desc = "HTML coverage" },
      i = { "mix test.interactive", desc = "Interactive" },
      p = { "mix precommit", desc = "Precommit" },
    },
    w = {
      desc = "Warnings as errors",
      tasks = function(command)
        return command .. " --warnings-as-errors"
      end,
    },
  },
}

local function register_mix_groups(prefix, vim_command)
  for key, group in pairs(mix_groups) do
    register_task_group(prefix .. key, vim_command, group)
  end
end

return {
  "tpope/vim-dispatch",
  dependencies = {
    "folke/which-key.nvim",
  },
  lazy = false,
  init = function()
    vim.g.dispatch_compilers = { elixir = "exunit" }
  end,
  config = function()
    local ok, which_key = pcall(require, "which-key")

    if ok then
      which_key.add({
        { "<leader>`", group = "Dispatch" },
        { "<leader>'", group = "Start" },
        { "<leader>m", group = "Make" },
      })
    end

    vim.keymap.set("n", "<leader>mq", open_quickfix, { desc = "Open quickfix" })
    vim.keymap.set("n", "<leader>m<cr>", "<cmd>Make<cr>", { desc = "Make" })
    vim.keymap.set("n", "<leader>m<space>", ":Make ", { desc = "Make command" })
    vim.keymap.set("n", "<leader>`<cr>", "<cmd>Dispatch<cr>", { desc = "Dispatch" })
    vim.keymap.set("n", "<leader>`<space>", ":Dispatch ", { desc = "Dispatch command" })
    vim.keymap.set("n", "<leader>'<cr>", "<cmd>Start<cr>", { desc = "Start" })
    vim.keymap.set("n", "<leader>'<space>", ":Start ", { desc = "Start command" })

    register_mix_groups("<leader>m", "Make")
    register_mix_groups("<leader>`", "Dispatch")
    register_mix_groups("<leader>'", "Start")
  end,
}
