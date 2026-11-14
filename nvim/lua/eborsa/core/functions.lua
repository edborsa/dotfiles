local M = {}

function M.get_file_reference(str)
  str = str or vim.fn.expand("<cWORD>")

  local fname = str:gsub(":%d+$", "")
  if vim.fn.filereadable(fname) == 0 then
    vim.notify('"' .. fname .. '" is not a readable file', vim.log.levels.WARN)
    return nil
  end

  local line = vim.api.nvim_get_current_line()
  local escaped_fname = vim.pesc(fname)
  local line_number_patterns = {
    ":(%d+)",
    "%s*@%s*(%d+)",
    "%s*%((%d+)%)",
    "%s*%(line%s*(%d+)%)",
    "%s+(%d+)",
  }

  for _, pattern in ipairs(line_number_patterns) do
    local lnum = line:match(escaped_fname .. pattern)
    if lnum then
      return { fname = fname, lnum = tonumber(lnum) }
    end
  end

  return { fname = fname }
end

function M.clear_invisible_buffers()
  local visible_buffers = {}
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    visible_buffers[vim.api.nvim_win_get_buf(win)] = true
  end

  for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
    if visible_buffers[bufnr] == nil then
      pcall(vim.cmd.bdelete, bufnr)
    end
  end
end

function M.break_line(max_length)
  local line_number = vim.fn.line(".")
  local line = vim.fn.getline(line_number)

  if #line <= max_length then
    vim.notify("Line is already " .. #line .. " characters (max: " .. max_length .. ")", vim.log.levels.WARN)
    return
  end

  local indent = line:match("^%s*") or ""
  local content = line:match("^%s*(.-)%s*$") or ""
  local lines = {}
  local current_line = ""

  for word in content:gmatch("%S+") do
    local candidate = current_line == "" and word or (current_line .. " " .. word)

    if #(indent .. candidate) <= max_length then
      current_line = candidate
    else
      if current_line ~= "" then
        table.insert(lines, indent .. current_line)
        current_line = word
      else
        table.insert(lines, indent .. word)
      end
    end
  end

  if current_line ~= "" then
    table.insert(lines, indent .. current_line)
  end

  if #lines > 0 then
    vim.fn.setline(line_number, lines[1])
    for index = 2, #lines do
      vim.fn.append(line_number + index - 2, lines[index])
    end
    vim.notify("Broke line into " .. #lines .. " lines", vim.log.levels.INFO)
  end
end

function M.get_visual_context()
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "x", false)

  local start_line = vim.fn.line("'<")
  local end_line = vim.fn.line("'>")
  local lines = vim.api.nvim_buf_get_lines(0, start_line - 1, end_line, false)
  local filename = vim.fn.expand("%:~:.")
  local filetype = vim.bo.filetype

  return "`"
    .. filename
    .. "` (lines "
    .. start_line
    .. "-"
    .. end_line
    .. "):\n\n```"
    .. filetype
    .. "\n"
    .. table.concat(lines, "\n")
    .. "\n```\n\n"
end

function M.copy_visual_context()
  vim.fn.setreg("+", M.get_visual_context())
  vim.notify("Copied visual context to clipboard", vim.log.levels.INFO)
end

return M
