if status is-interactive
    # Commands to run in interactive sessions can go here
end
eval "$(/opt/homebrew/bin/brew shellenv)"

# PATH (fish_add_path skips directories that don't exist on this machine)
fish_add_path -gaP ~/.local/bin        # pipx, Claude Code and other user binaries
fish_add_path -gP ~/.local/opt/claude
fish_add_path -gaP ~/.docker/bin       # Docker Desktop

# Found commands in blue (fish >= 4.3 defaults to plain text)
set -g fish_color_command blue

# Give each tmux pane its own nvim server socket
if set -q TMUX
    alias nvim="nvim --listen /tmp/nvim-server-$(tmux display-message -p '#D').pipe"
end

if test -n "$NVIM_LISTEN_ADDRESS"
    alias nvim="nvr -cc split --remote-wait +'set bufhidden=wipe'"
    set -x VISUAL "nvr -cc split --remote-wait +'set bufhidden=wipe'"
    set -x EDITOR "nvr -cc split --remote-wait +'set bufhidden=wipe'"
else
    set -x VISUAL "nvim"
    set -x EDITOR "nvim"
end

export CLAUDE_CODE_NO_FLICKER=1

# y: run yazi, and cd to the folder you were in when you quit it
function y
    set tmp (mktemp -t "yazi-cwd.XXXXXX")
    yazi $argv --cwd-file="$tmp"
    if set cwd (command cat -- "$tmp"); and [ -n "$cwd" ]; and [ "$cwd" != "$PWD" ]
        builtin cd -- "$cwd"
    end
    rm -f -- "$tmp"
end
