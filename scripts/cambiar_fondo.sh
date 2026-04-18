#!/bin/bash
IMAGEN="$1"
LOG="/tmp/fondo.log"

echo "=== INICIO ===" >$LOG
echo "Imagen: $IMAGEN" >>$LOG

# 1. Fondo
echo "Aplicando fondo..." >>$LOG
awww img "$IMAGEN" --transition-type wipe >>$LOG 2>&1

# 2. Matugen (Genera Waybar, Rofi, Kitty y bordes de Hyprland)
echo "Ejecutando Matugen..." >>$LOG
mkdir -p "$HOME/.cache/colors"
matugen image "$IMAGEN" -m dark --prefer saturation -c "$HOME/dotfiles/matugen/.config/matugen/config.toml" >>$LOG 2>&1

# 3. Waybar e Hyprland
echo "Reiniciando entorno..." >>$LOG
killall waybar
sleep 1
nohup waybar >>$LOG 2>&1 &
hyprctl reload >>$LOG 2>&1

# 4. Notificaciones y Terminal
echo "Actualizando extras..." >>$LOG
touch "$HOME/.config/kitty/kitty.conf"
pkill -USR1 kitty >>$LOG 2>&1
swaync-client -rs >>$LOG 2>&1

echo "=== FIN ===" >>$LOG
