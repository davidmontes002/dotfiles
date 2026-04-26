#!/bin/bash
# Minimize all windows on current workspace
current=$(hyprctl activeworkspace -j | jq -r '.id')

hyprctl clients -j | jq -r --argjson ws "$current" \
    '.[] | select(.workspace.id == $ws) | .address' | \
while read addr; do
    hyprctl dispatch movetoworkspacesilent "special:minimized,address:$addr"
done
