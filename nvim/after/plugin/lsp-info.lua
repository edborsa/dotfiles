if vim.fn.exists(":LspInfo") == 0 then
  vim.api.nvim_create_user_command("LspInfo", function()
    local current_buf = vim.api.nvim_get_current_buf()
    local current_clients = vim.lsp.get_clients({ bufnr = current_buf })
    local all_clients = vim.lsp.get_clients()
    local lines = {
      "LSP Info",
      "",
      "Current buffer: " .. current_buf,
      "Current filetype: " .. (vim.bo[current_buf].filetype ~= "" and vim.bo[current_buf].filetype or "<none>"),
      "",
      "Attached clients:",
    }

    if #current_clients == 0 then
      table.insert(lines, "  none")
    else
      for _, client in ipairs(current_clients) do
        table.insert(lines, "  - " .. client.name .. " (id " .. client.id .. ")")
        table.insert(lines, "    root: " .. (client.root_dir or "<none>"))
        table.insert(lines, "    cmd: " .. table.concat(client.config.cmd or {}, " "))
      end
    end

    table.insert(lines, "")
    table.insert(lines, "All running clients:")

    if #all_clients == 0 then
      table.insert(lines, "  none")
    else
      for _, client in ipairs(all_clients) do
        table.insert(lines, "  - " .. client.name .. " (id " .. client.id .. ")")
      end
    end

    vim.cmd("botright new")
    local buf = vim.api.nvim_get_current_buf()
    vim.bo[buf].buftype = "nofile"
    vim.bo[buf].bufhidden = "wipe"
    vim.bo[buf].swapfile = false
    vim.bo[buf].filetype = "lspinfo"
    vim.api.nvim_buf_set_name(buf, "LspInfo")
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
    vim.bo[buf].modifiable = false
  end, { desc = "Show LSP client information" })
end
