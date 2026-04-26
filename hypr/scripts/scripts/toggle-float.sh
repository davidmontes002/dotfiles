#!/bin/bash
# toggle-float.sh — togglefloating con resize inteligente para sidebar en DP-1
#
# En monitor 0 (DP-1): al flotar ajusta el ancho descontando el sidebar (380px)
# En otros monitores: togglefloating normal

WINDOW=$(hyprctl activewindow -j)
IS_FLOAT=$(echo "$WINDOW" | jq -r '.floating')
MONITOR=$(echo "$WINDOW" | jq -r '.monitor')

if [ "$IS_FLOAT" = "false" ]; then
    hyprctl dispatch togglefloating
    if [ "$MONITOR" = "0" ]; then
        sleep 0.05
        # DP-1 lógico: 2400x1350 | sidebar: x=2010 w=380 | waybar: 50px reservado
        # ancho: sidebar_x(2010) - gap_izq(15) - gap_der(15) = 1980
        # alto:  monitor(1350) - waybar(50) - gap_top(15) - gap_bot(15) = 1270
        hyprctl dispatch resizeactive exact 1980 1270
        hyprctl dispatch moveactive exact 15 65
    fi
else
    hyprctl dispatch togglefloating
fi
