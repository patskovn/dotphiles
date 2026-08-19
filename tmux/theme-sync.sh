#!/bin/sh
# Keeps @catppuccin_flavor in step with the macOS appearance and re-applies the
# theme when it changes. Pass -f to re-apply even if the flavor already matches.
#
# Runs from status-format[0] on every status refresh, so it must stay quiet:
# anything printed here lands in the status bar.

PLUGIN_DIR="$HOME/.tmux/plugins/tmux-catpuccin"

dark_flavor=$(tmux show -gv @catppuccin_dark_flavor 2>/dev/null)
light_flavor=$(tmux show -gv @catppuccin_light_flavor 2>/dev/null)
[ -n "$dark_flavor" ] || dark_flavor=frappe
[ -n "$light_flavor" ] || light_flavor=latte

if "$HOME/.dotfiles/tmux/dark-mode.sh" is-dark; then
  want=$dark_flavor
else
  want=$light_flavor
fi

current=$(tmux show -gv @catppuccin_flavor 2>/dev/null)
if [ "$current" = "$want" ] && [ "$1" != "-f" ]; then
  exit 0
fi

tmux set -g @catppuccin_flavor "$want"

# The theme files assign with `set -ogq`, which refuses to overwrite an option
# that already has a value, so the previous flavor's palette has to be cleared
# before the new one will take. Every option a theme file sets is an @thm_*.
tmux show -g | awk '/^@thm_/ { print $1 }' | while read -r opt; do
  tmux set -gu "$opt"
done

tmux source-file "$PLUGIN_DIR/catppuccin_tmux.conf"
tmux refresh-client -S
