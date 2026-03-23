#!/usr/bin/env bash
set -euo pipefail

export DISPLAY="${DISPLAY:-:0}"
export XAUTHORITY="${XAUTHORITY:-$HOME/.Xauthority}"

INTERNAL="eDP-1"
EXTERNAL="DP-2-3"

if xrandr | grep -q "^${EXTERNAL} connected"; then
  xrandr \
    --output "${INTERNAL}" --mode 1920x1080 --pos 0x0 --primary \
    --output "${EXTERNAL}" --mode 2560x1440 --pos 1920x0 --rate 59.95

else
  xrandr --auto
fi
