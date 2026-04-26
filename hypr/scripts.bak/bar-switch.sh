#!/bin/bash
# bar-switch.sh — alterna entre waybar e ironbar
# Uso: bar-switch.sh [waybar|ironbar]  (sin argumento: alterna)

STATE_FILE="$HOME/.config/hypr/.active_bar"
CURRENT=$(cat "$STATE_FILE" 2>/dev/null || echo "waybar")

TARGET="${1:-}"
if [[ -z "$TARGET" ]]; then
    TARGET=$( [[ "$CURRENT" == "waybar" ]] && echo "ironbar" || echo "waybar" )
fi

pkill -x waybar 2>/dev/null
pkill -x ironbar 2>/dev/null
sleep 0.3

echo "$TARGET" > "$STATE_FILE"

case "$TARGET" in
    waybar)  waybar & ;;
    ironbar) ironbar & ;;
    *)       echo "Uso: $0 [waybar|ironbar]"; exit 1 ;;
esac

notify-send "Bar" "Cambiado a $TARGET" --expire-time=2000
