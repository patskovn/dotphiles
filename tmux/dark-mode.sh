#!/bin/sh
# Reports the current macOS appearance.
#   dark-mode.sh           prints "dark" or "light"
#   dark-mode.sh is-dark   exits 0 when dark, 1 when light
#
# Prefers is_dark_mode_server, the same daemon nvim's auto-dark-mode polls, so
# both stay on one answer. Falls back to asking macOS when it isn't running.

PORT=12142

mode=$(curl -s --connect-timeout 1 --max-time 1 "http://127.0.0.1:$PORT" 2>/dev/null)

case "$mode" in
  dark | light) ;;
  *)
    if [ "$(defaults read -g AppleInterfaceStyle 2>/dev/null)" = "Dark" ]; then
      mode=dark
    else
      mode=light
    fi
    ;;
esac

if [ "$1" = "is-dark" ]; then
  [ "$mode" = dark ]
else
  echo "$mode"
fi
