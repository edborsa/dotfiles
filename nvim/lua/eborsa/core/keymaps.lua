vim.g.mapleader = " "

local keymap = vim.keymap -- for conciseness
local functions = require("eborsa.core.functions")

keymap.set("i", "jk", "<ESC>", { desc = "Exit insert mode with jk" })

keymap.set("n", "<leader>nh", ":nohl<CR>", { desc = "Clear search highlights" })

-- increment/decrement numbers
keymap.set("n", "<leader>+", "<C-a>", { desc = "Increment number" }) -- increment
keymap.set("n", "<leader>-", "<C-x>", { desc = "Decrement number" }) -- decrement

-- window management
keymap.set("n", "<leader>sv", "<C-w>v", { desc = "Split window vertically" }) -- split window vertically
keymap.set("n", "<leader>sh", "<C-w>s", { desc = "Split window horizontally" }) -- split window horizontally
keymap.set("n", "<leader>se", "<C-w>=", { desc = "Make splits equal size" }) -- make split windows equal width & height
keymap.set("n", "<leader>sx", "<cmd>close<CR>", { desc = "Close current split" }) -- close current split window

keymap.set("n", "<leader>yf", function()
  local filename = vim.fn.expand("%")
  vim.fn.setreg("+", filename)
  vim.notify("Copied filename: " .. filename, vim.log.levels.INFO)
end, { desc = "Yank filename" })

keymap.set("n", "<leader>yl", function()
  local location = vim.fn.expand("%") .. ":" .. vim.fn.line(".")
  vim.fn.setreg("+", location)
  vim.notify("Copied location: " .. location, vim.log.levels.INFO)
end, { desc = "Yank filename and line" })

keymap.set("v", "<leader>yc", functions.copy_visual_context, { desc = "Yank visual context" })

keymap.set("n", "<leader>cb", function()
  vim.ui.input({ prompt = "Max line length: ", default = "79" }, function(input)
    local max_length = tonumber(input)
    if max_length and max_length > 0 then
      functions.break_line(max_length)
    elseif input then
      vim.notify("Invalid length: must be a positive number", vim.log.levels.ERROR)
    end
  end)
end, { desc = "Break line" })

keymap.set("n", "<leader>bc", functions.clear_invisible_buffers, { desc = "Clear invisible buffers" })
