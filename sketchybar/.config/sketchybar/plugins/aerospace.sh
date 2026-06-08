#!/bin/sh

SID="$1"

# FOCUSED_WORKSPACE comes from the aerospace exec-on-workspace-change callback.
# Fallback to querying aerospace directly if not set (e.g. on initial load).
FOCUSED="${FOCUSED_WORKSPACE:-$(aerospace list-workspaces --focused 2>/dev/null)}"

# Count windows in this workspace
WINDOWS=$(aerospace list-windows --workspace "$SID" --count 2>/dev/null || echo 0)

if [ "$SID" = "$FOCUSED" ]; then
    # Currently focused workspace — green highlight
    sketchybar --set "$NAME" \
        background.drawing=on \
        background.color=0xffa6da95 \
        label.color=0xff000000
elif [ "$WINDOWS" -gt 0 ]; then
    # Has windows but not focused — subtle highlight
    sketchybar --set "$NAME" \
        background.drawing=on \
        background.color=0x33ffffff \
        label.color=0xffffffff
else
    # Empty workspace — dimmed
    sketchybar --set "$NAME" \
        background.drawing=off \
        label.color=0x55ffffff
fi
