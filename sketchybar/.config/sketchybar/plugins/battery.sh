#!/bin/sh

PERCENTAGE="$(pmset -g batt | grep -Eo '\d+%' | cut -d% -f1)"
CHARGING="$(pmset -g batt | grep 'AC Power')"

if [ "$PERCENTAGE" = "" ]; then
  exit 0
fi

# Nerd Font icons
case "$PERCENTAGE" in
  9[0-9]|100) ICON=""
  ;;
  [6-8][0-9]) ICON=""
  ;;
  [3-5][0-9]) ICON=""
  ;;
  [1-2][0-9]) ICON=""
  ;;
  *) ICON=""
esac

if [ "$CHARGING" != "" ]; then
  ICON=""
fi

# Low battery warning color
if [ "$PERCENTAGE" -le 20 ] && [ "$CHARGING" = "" ]; then
  sketchybar --set "$NAME" icon="$ICON" label="${PERCENTAGE}%" icon.color=0xffff4444 label.color=0xffff4444
else
  sketchybar --set "$NAME" icon="$ICON" label="${PERCENTAGE}%" icon.color=0xffffffff label.color=0xffffffff
fi
