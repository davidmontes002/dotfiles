#!/bin/bash
# Hot corners:
#   - Esquina superior izquierda (DP-1)   → activa hyprexpo
#   - Esquina superior derecha (HDMI-A-1) → activa hyprexpo

COOLDOWN=1  # segundos entre activaciones
last_trigger=0

# Coordenadas reales según hyprctl monitors:
# HDMI-A-1: 1920x1080 at 2328x0
MON2_X_START=2328
MON2_Y_START=0
MON2_X_END=$((MON2_X_START + 1920))   # 4248
MON2_Y_END=$((MON2_Y_START + 5))      # 5

echo "Hotcorner script iniciado. Mon2 top-right: x >= $((MON2_X_END - 5)), y <= $MON2_Y_END"

while true; do
    # Obtener posición del cursor
    pos=$(hyprctl cursorpos 2>/dev/null)
    x=$(echo "$pos" | awk -F',' '{print $1}' | tr -d ' ')
    y=$(echo "$pos" | awk -F',' '{print $2}' | tr -d ' ')

    now=$(date +%s)
    diff=$((now - last_trigger))

    # Esquina superior izquierda de DP-1 (monitor principal en 0x0)
    if [[ "$x" -le 5 && "$y" -le 5 && "$diff" -ge "$COOLDOWN" ]]; then
        echo "[DEBUG] Trigger DP-1 Top-Left ($x,$y)"
        hyprctl dispatch hyprexpo:expo toggle
        last_trigger=$now
        sleep 0.8

    # Esquina superior derecha de HDMI-A-1 (segundo monitor en 2328x0)
    elif [[ "$x" -ge $((MON2_X_END - 5)) && "$y" -le "$MON2_Y_END" && "$diff" -ge "$COOLDOWN" ]]; then
        echo "[DEBUG] Trigger HDMI-A-1 Top-Right ($x,$y)"
        hyprctl dispatch hyprexpo:expo toggle
        last_trigger=$now
        sleep 0.8
    fi

    sleep 0.1
done
