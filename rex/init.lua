-- Rex config, migrated from tmux, Ghostty and iTerm2.

-- cmd+k: clear the terminal (your choice); session picker moves to shift+cmd+k.
rex.bind("cmd+k", "com.superlogical.terminal.clear")
rex.bind("shift+cmd+k", "session.switch")

-- tmux (~/.tmux.conf), prefix ctrl+s
rex.bind("ctrl+s>ctrl+s", "pane.send_key", { key = "ctrl+s" })
rex.bind("ctrl+s>r", "client.config.reload")
rex.bind("ctrl+s>shift+'", "pane.split", { direction = "down" })
rex.bind("ctrl+s>shift+5", "pane.split", { direction = "right" })
rex.bind("ctrl+s>c", "client.tab.new")
-- Option-key bindings (bind -n), spelled as the keys that type them on a US layout
rex.bind("alt+h", "pane.focus", { direction = "left" })  -- ˙
rex.bind("alt+l", "pane.focus", { direction = "right" }) -- ¬
rex.bind("alt+k", "pane.focus", { direction = "up" })    -- ˚
rex.bind("alt+j", "pane.focus", { direction = "down" })  -- ∆
rex.bind("alt+[", "client.tab.previous")                 -- “
rex.bind("alt+]", "client.tab.next")                     -- ‘
rex.bind("alt+-", "session.previous")                    -- –
rex.bind("alt+=", "session.next")                        -- ≠

-- Ghostty (~/.config/ghostty/config)
rex.bind("shift+enter", "pane.send_key", { key = "alt+enter" }) -- text:\x1b\r

-- iTerm2 (GlobalKeyMap)
-- cmd+left/right (Karabiner turns caps+cmd+h/l into these): start/end of line.
-- Pane focus stays on alt+h/j/k/l.
rex.bind("cmd+left", "pane.send_key", { key = "home" })
rex.bind("cmd+right", "pane.send_key", { key = "end" })
rex.bind("shift+cmd+right", "client.tab.move", { direction = "forward" })
rex.bind("shift+cmd+left", "client.tab.move", { direction = "backward" })

-- Agent prompts (rex.ui actions), from the mac mini
-- Approver prompt for Claude Code (rex.ui test)
rex.action{
  name = "approve",
  title = "Approve tool call",
  args = { tool = "string", detail = "string" },
  run = function(ctx, args)
    local choice, why = rex.ui.pick{
      title = "Claude wants: " .. args.tool,
      confirm = "Decide",
      timeout = 90,
      items = {
        { id = "allow", title = "Allow", subtitle = args.detail, icon = "star" },
        { id = "deny",  title = "Deny",  subtitle = args.detail, icon = "gear" },
      },
    }
    if choice == nil then return { behavior = "deny", reason = why } end
    return { behavior = choice }
  end,
}

-- Generic question from an agent: list of options (+ free text) or plain text input
rex.action{
  name = "ask",
  title = "Ask a question",
  args = { question = "string", options = "string?" },  -- options: "a|b|c"
  run = function(ctx, args)
    if args.options and args.options ~= "" then
      local items = {}
      for opt in string.gmatch(args.options, "[^|]+") do items[#items+1] = opt end
      local r, why = rex.ui.pick{ title = args.question, items = items,
        allow_other = true, placeholder = "Pick one or type your own answer", timeout = 300 }
      if r == nil then return { answer = nil, reason = why } end
      if type(r) == "table" then return { answer = r.text, typed = true } end
      return { answer = r }
    end
    local r, why = rex.ui.input{ title = args.question, placeholder = "Type your answer", timeout = 300 }
    if r == nil then return { answer = nil, reason = why } end
    return { answer = r }
  end,
}
