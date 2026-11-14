local keymap = vim.keymap.set

local function notify(message, level)
  vim.notify(message, level or vim.log.levels.INFO)
end

local function run_command(command)
  return function()
    local ok, err = pcall(vim.cmd, command)

    if not ok then
      notify(err, vim.log.levels.WARN)
    end
  end
end

local function toggle_window_option(option)
  return function()
    vim.wo[option] = not vim.wo[option]
    notify(option .. ": " .. tostring(vim.wo[option]))
  end
end

local function toggle_global_option(option)
  return function()
    vim.o[option] = not vim.o[option]
    notify(option .. ": " .. tostring(vim.o[option]))
  end
end

local function toggle_background()
  vim.o.background = vim.o.background == "dark" and "light" or "dark"
  notify("background: " .. vim.o.background)
end

local function toggle_colorcolumn()
  vim.wo.colorcolumn = vim.wo.colorcolumn == "" and "80" or ""
  notify("colorcolumn: " .. (vim.wo.colorcolumn == "" and "off" or vim.wo.colorcolumn))
end

local function toggle_virtualedit()
  vim.o.virtualedit = vim.o.virtualedit == "" and "all" or ""
  notify("virtualedit: " .. (vim.o.virtualedit == "" and "off" or vim.o.virtualedit))
end

local function toggle_crosshairs()
  local enabled = not (vim.wo.cursorline and vim.wo.cursorcolumn)
  vim.wo.cursorline = enabled
  vim.wo.cursorcolumn = enabled
  notify("crosshairs: " .. tostring(enabled))
end

local function toggle_quickfix()
  for _, win in ipairs(vim.fn.getwininfo()) do
    if win.quickfix == 1 then
      vim.cmd("cclose")
      return
    end
  end

  vim.cmd("botright copen")
end

local function toggle_executable()
  local file = vim.fn.expand("%:p")

  if file == "" then
    notify("No file in current buffer", vim.log.levels.WARN)
    return
  end

  local permissions = vim.fn.getfperm(file)

  if permissions == "" then
    notify("Cannot read permissions for " .. file, vim.log.levels.WARN)
    return
  end

  local executable = permissions:sub(3, 3) == "x"
  local chmod_arg = executable and "u-x" or "u+x"

  vim.system({ "chmod", chmod_arg, file }, { text = true }, function(result)
    vim.schedule(function()
      if result.code == 0 then
        notify((executable and "Removed executable bit: " or "Added executable bit: ") .. vim.fn.fnamemodify(file, ":~:."))
      else
        notify(result.stderr, vim.log.levels.ERROR)
      end
    end)
  end)
end

keymap("n", "]q", run_command("cnext"), { desc = "Next quickfix item" })
keymap("n", "[q", run_command("cprevious"), { desc = "Previous quickfix item" })
keymap("n", "]Q", run_command("clast"), { desc = "Last quickfix item" })
keymap("n", "[Q", run_command("cfirst"), { desc = "First quickfix item" })

keymap("n", "]b", run_command("bnext"), { desc = "Next buffer" })
keymap("n", "[b", run_command("bprevious"), { desc = "Previous buffer" })
keymap("n", "]B", run_command("blast"), { desc = "Last buffer" })
keymap("n", "[B", run_command("bfirst"), { desc = "First buffer" })

keymap("n", "]a", run_command("next"), { desc = "Next arg" })
keymap("n", "[a", run_command("previous"), { desc = "Previous arg" })
keymap("n", "]A", run_command("last"), { desc = "Last arg" })
keymap("n", "[A", run_command("first"), { desc = "First arg" })

keymap("n", "<leader>tob", toggle_background, { desc = "Toggle background" })
keymap("n", "<leader>toc", toggle_window_option("cursorline"), { desc = "Toggle cursorline" })
keymap("n", "<leader>tod", toggle_window_option("diff"), { desc = "Toggle diff" })
keymap("n", "<leader>toe", toggle_colorcolumn, { desc = "Toggle colorcolumn" })
keymap("n", "<leader>toh", toggle_global_option("hlsearch"), { desc = "Toggle hlsearch" })
keymap("n", "<leader>toi", toggle_global_option("ignorecase"), { desc = "Toggle ignorecase" })
keymap("n", "<leader>tol", toggle_window_option("list"), { desc = "Toggle list" })
keymap("n", "<leader>ton", toggle_window_option("number"), { desc = "Toggle number" })
keymap("n", "<leader>tor", toggle_window_option("relativenumber"), { desc = "Toggle relativenumber" })
keymap("n", "<leader>tos", toggle_window_option("spell"), { desc = "Toggle spell" })
keymap("n", "<leader>tou", toggle_window_option("cursorcolumn"), { desc = "Toggle cursorcolumn" })
keymap("n", "<leader>tov", toggle_virtualedit, { desc = "Toggle virtualedit" })
keymap("n", "<leader>tow", toggle_window_option("wrap"), { desc = "Toggle wrap" })
keymap("n", "<leader>tox", toggle_crosshairs, { desc = "Toggle crosshairs" })
keymap("n", "<leader>tq", toggle_quickfix, { desc = "Toggle quickfix" })
keymap("n", "<leader>tx", toggle_executable, { desc = "Toggle executable bit" })
