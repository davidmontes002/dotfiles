#!/bin/bash
# Espera a que swww-daemon esté listo
sleep 1

WALL_LIGHT="/usr/share/wallpapers/Next/contents/images/5120x2880.png"
WALL_DARK="/usr/share/wallpapers/Next/contents/images_dark/5120x2880.png"

# Monitor principal (DP-1): wallpaper oscuro
swww img "$WALL_DARK" \
    --outputs DP-1 \
    --transition-type grow \
    --transition-pos 0.5,0.5 \
    --transition-duration 1.5

# Monitor secundario (HDMI-A-1): wallpaper claro
swww img "$WALL_LIGHT" \
    --outputs HDMI-A-1 \
    --transition-type grow \
    --transition-pos 0.5,0.5 \
    --transition-duration 1.5
