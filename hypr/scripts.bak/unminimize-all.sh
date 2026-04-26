#!/bin/bash
# Restore all minimized windows to current workspace
hyprctl clients -j | jq -r \
    '.[] | select(.workspace.name == "special:minimized") | .address' | \
while read addr; do
    hyprctl dispatch movetoworkspace "e+0,address:$addr"
done
