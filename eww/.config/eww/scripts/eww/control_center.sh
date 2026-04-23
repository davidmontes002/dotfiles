#!/bin/bash
STATE_FILE="/tmp/eww_control_center"
estado="close"

[[ -f "$STATE_FILE" ]] && estado=$(<"$STATE_FILE")

if [[ "$1" == "--toggle" ]]; then
    if [[ "$estado" == "open" ]]; then
        eww update show_control_center=false
        echo "close" > "$STATE_FILE"
    else
        eww update show_control_center=true
        echo "open" > "$STATE_FILE"
    fi
fi
