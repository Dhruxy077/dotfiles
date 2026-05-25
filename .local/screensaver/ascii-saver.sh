#!/bin/bash

ASCII_FILE="$HOME/.local/bin/screensaver/logo.txt"

# ASCII_FILE="${HOME}/Desktop/workspace/logo.txt"

[[ ! -f "$ASCII_FILE" ]] && {
  echo "Error: ASCII file not found at $ASCII_FILE"
  exit 1
}

exit_screensaver() {
  tput cnorm
  pkill -x tte 2>/dev/null
  clear
  exit 0
}

trap exit_screensaver SIGINT SIGTERM SIGHUP SIGQUIT

printf '\033]11;rgb:00/00/00\007' # force black background
tput civis                        # hide cursor

tty=$(tty 2>/dev/null)

while true; do
  tte -i "$ASCII_FILE" \
    --frame-rate 120 \
    --canvas-width 0 \
    --canvas-height 0 \
    --anchor-canvas c \
    --anchor-text c \
    --reuse-canvas \
    --random-effect \
    --no-eol \
    --no-restore-cursor &

  while pgrep -t "${tty#/dev/}" -x tte >/dev/null; do
    if read -n1 -t 1 </dev/tty; then
      exit_screensaver
    fi
  done
done
