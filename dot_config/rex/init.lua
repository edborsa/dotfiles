-- Rex config, migrated from ~/.config/tmux/tmux.conf (prefix ctrl+s) and ~/.config/ghostty/config.
-- cmd+k keeps Rex's default (session picker).

-- tmux.conf:18  send the prefix through to the application
rex.bind("ctrl+s>ctrl+s", "pane.send_key", { key = "ctrl+s" })

-- tmux.conf:63  send ctrl+l (clear) to the pane
rex.bind("ctrl+s>ctrl+l", "pane.send_key", { key = "ctrl+l" })

-- tmux.conf:64-65  splits
rex.bind("ctrl+s>\\", "pane.split", { direction = "right" })
rex.bind("ctrl+s>-", "pane.split", { direction = "down" })

-- Vim keys instead of arrows.

-- Move between panes: ctrl+s, then h/j/k/l
rex.bind("ctrl+s>h", "pane.focus.left")
rex.bind("ctrl+s>j", "pane.focus.down")
rex.bind("ctrl+s>k", "pane.focus.up")
rex.bind("ctrl+s>l", "pane.focus.right")

-- Resize mode: ctrl+s, then shift+r. Inside it, h/j/k/l resize a little,
-- shift+h/j/k/l a lot, = evens the panes out, esc or enter leaves.
-- Exclusive, so stray keys don't type into the terminal while resizing.
rex.mode("resize", { exclusive = true })
rex.bind("ctrl+s>shift+r", "client.mode.enter", { name = "resize" })
rex.bind("resize/h", "pane.resize", { amount = 2, direction = "left" })
rex.bind("resize/l", "pane.resize", { amount = 2, direction = "right" })
rex.bind("resize/j", "pane.resize", { amount = 1, direction = "down" })
rex.bind("resize/k", "pane.resize", { amount = 1, direction = "up" })
rex.bind("resize/shift+h", "pane.resize", { amount = 10, direction = "left" })
rex.bind("resize/shift+l", "pane.resize", { amount = 10, direction = "right" })
rex.bind("resize/shift+j", "pane.resize", { amount = 5, direction = "down" })
rex.bind("resize/shift+k", "pane.resize", { amount = 5, direction = "up" })
rex.bind("resize/=", "pane.balance")
rex.bind("resize/enter", "client.mode.exit")

-- Quick resize: ctrl+s, then shift+h/j/k/l (one step per press; use resize mode above to repeat).
-- Needs the prefix: bare shift+hjkl would type capitals, and ctrl+hjkl are backspace,
-- newline, kill-line and clear in the shell and Neovim.
rex.bind("ctrl+s>shift+h", "pane.resize", { amount = 5, direction = "left" })
rex.bind("ctrl+s>shift+l", "pane.resize", { amount = 5, direction = "right" })
rex.bind("ctrl+s>shift+j", "pane.resize", { amount = 3, direction = "down" })
rex.bind("ctrl+s>shift+k", "pane.resize", { amount = 3, direction = "up" })

-- tmux.conf:77-79  tabs
rex.bind("ctrl+s>c", "client.tab.new")
rex.bind("alt+u", "client.tab.previous")
rex.bind("alt+i", "client.tab.next")

-- tmux.conf:82  reload config
rex.bind("ctrl+s>r", "client.config.reload")

-- tmux.conf:84  copy mode (vi keys: hjkl, v to select, y to yank, / to search)
rex.bind("ctrl+s>esc", "pane.copy_mode.enter")

-- tmux.conf:83  split down (tmux also ran tmux-sessionizer in the new pane; not migrated)
rex.bind("ctrl+s>ctrl+j", "pane.split", { direction = "down" })
