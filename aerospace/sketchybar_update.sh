#!/bin/bash
/opt/homebrew/bin/sketchybar --trigger aerospace_workspace_change FOCUSED_WORKSPACE="$AEROSPACE_FOCUSED_WORKSPACE" PREV_WORKSPACE="$AEROSPACE_PREV_WORKSPACE" 2>/tmp/sketchybar_trigger_err.log
