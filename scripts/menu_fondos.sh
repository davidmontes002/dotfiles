#!/bin/bash

DIR="$HOME/dotfiles/fondos"

# Usamos un pipe directo hacia Rofi para evitar la advertencia de Bash
ELEGIDO=$(find "$DIR" -type f \( -iname "*.jpg" -o -iname "*.png" \) | while read -r img; do
    nombre=$(basename "$img")
    echo -en "$nombre\0icon\x1f$img\n"
done | rofi -dmenu -i -p "🖼️ Fondos" -show-icons -theme-str '
window { width: 60%; padding: 20px; border-radius: 12px; }
listview { columns: 4; lines: 2; spacing: 20px; flow: horizontal; }
element { orientation: vertical; padding: 10px; border-radius: 8px; }
element-icon { size: 180px; horizontal-align: 0.5; }
element-text { horizontal-align: 0.5; margin: 10px 0 0 0; }
')

# Si seleccionaste una imagen, ejecutamos el motor
if [ -n "$ELEGIDO" ]; then
    ~/dotfiles/scripts/cambiar_fondo.sh "$DIR/$ELEGIDO"
fi
