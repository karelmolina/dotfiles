#!/bin/bash
# Log para diagnóstico
echo "$(date '+%H:%M:%S') CALLBACK EXECUTED: FOCUSED=$AEROSPACE_FOCUSED_WORKSPACE PREV=$AEROSPACE_PREV_WORKSPACE" >> /tmp/aerospace_callback.log
# Ejecutar sketchybar con ruta completa
/opt/homebrew/bin/sketchybar --trigger aerospace_workspace_change FOCUSED_WORKSPACE="$AEROSPACE_FOCUSED_WORKSPACE" PREV_WORKSPACE="$AEROSPACE_PREV_WORKSPACE"
