#!/bin/bash
get_volume() {
    if pactl get-sink-mute @DEFAULT_SINK@ | grep -q "yes"; then
        echo "muted"
    else
        pactl get-sink-volume @DEFAULT_SINK@ | grep -oP '\d+%' | head -1 | tr -d '%'
    fi
}

get_volume
pactl subscribe | grep --line-buffered "on sink" | while read -r _; do
    get_volume
done
