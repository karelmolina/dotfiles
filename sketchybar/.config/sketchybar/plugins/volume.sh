#!/bin/sh

# The volume_change event supplies a $INFO variable with the current volume percentage

if [ "$SENDER" = "volume_change" ]; then
  VOLUME="$INFO"

  # Nerd Font icons
  case "$VOLUME" in
    [6-9][0-9]|100) ICON="󰕾"
    ;;
    [3-5][0-9]) ICON="󰖀"
    ;;
    [1-9]|[1-2][0-9]) ICON="󰕿"
    ;;
    *) ICON="󰖁"
  esac

  sketchybar --set "$NAME" icon="$ICON" label="$VOLUME%"
fi
