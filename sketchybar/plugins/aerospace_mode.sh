#!/bin/sh

# Show the currently active AeroSpace mode in SketchyBar.
# Modes are defined in aerospace/aerospace.toml. When in "main" mode,
# the indicator is hidden to keep the bar clean.

MODE=$(aerospace list-modes --current 2>/dev/null || echo "main")

if [ "$MODE" = "main" ]; then
  sketchybar --set "$NAME" drawing=off
else
  sketchybar --set "$NAME" \
    drawing=on \
    label="$MODE" \
    icon.color=0xffffa6c9 \
    label.color=0xffffa6c9
fi
