#!/bin/bash
# Restore last minimized window from special:minimized
addr=$(hyprctl clients -j | jq -r '[.[] | select(.workspace.name == "special:minimized")] | last | .address')

if [ "$addr" != "null" ] && [ -n "$addr" ]; then
    hyprctl dispatch movetoworkspace "e+0,address:$addr"
else
    echo "No minimized windows"
fi
