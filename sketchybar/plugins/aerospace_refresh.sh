#!/bin/sh

# Refresh all workspace indicators by querying aerospace directly
FOCUSED=$(aerospace list-workspaces --focused 2>/dev/null || echo "")

for sid in $(aerospace list-workspaces --all 2>/dev/null); do
    WINDOWS=$(aerospace list-windows --workspace "$sid" --count 2>/dev/null || echo 0)

    if [ "$sid" = "$FOCUSED" ]; then
        sketchybar --set "space.$sid" \
            background.drawing=on \
            background.color=0xffa6da95 \
            label.color=0xff000000
    elif [ "$WINDOWS" -gt 0 ]; then
        sketchybar --set "space.$sid" \
            background.drawing=on \
            background.color=0x33ffffff \
            label.color=0xffffffff
    else
        sketchybar --set "space.$sid" \
            background.drawing=off \
            label.color=0x55ffffff
    fi
done
