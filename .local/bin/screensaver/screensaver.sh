#!/bin/bash

export PATH="$HOME/.local/bin:/usr/local/bin:/usr/bin:/bin:$PATH"

if ! command -v tte &>/dev/null; then
  exit 1
fi

pgrep -f org.dhruvin.screensaver && exit 0

SCREENSAVER="$HOME/.local/bin/screensaver/ascii-saver.sh"

focused=$(hyprctl monitors -j | jq -r '.[] | select(.focused == true) | .name')

hypr_focus_monitor() {
  hyprctl dispatch focusmonitor "$1" >/dev/null
}

hypr_exec() {
  hyprctl dispatch exec -- bash -lc "$1" >/dev/null
}

for m in $(hyprctl monitors -j | jq -r '.[].name'); do
  hypr_focus_monitor "$m"
  sleep 0.2
  hyprctl dispatch exec -- \
    alacritty --class=org.dhruvin.screensaver \
    --config-file=$HOME/.config/alacritty/screensaver.toml \
    -e bash -lc "$SCREENSAVER" >/dev/null
  sleep 0.3
done

hypr_focus_monitor "$focused"
