#!/bin/bash
IMAGEN="$1"
LOG="/tmp/fondo.log"

echo "=== INICIO ===" > $LOG
echo "Imagen: $IMAGEN" >> $LOG

# 1. Fondo
echo "Aplicando fondo..." >> $LOG
awww img "$IMAGEN" --transition-type wipe >> $LOG 2>&1

# 2. Matugen (Con ruta absoluta al programa y a la configuración)
echo "Ejecutando Matugen..." >> $LOG
mkdir -p /home/cimi/.cache/colors
/usr/bin/matugen image "$IMAGEN" -m dark --prefer saturation -c /home/cimi/dotfiles/matugen/.config/matugen/config.toml >> $LOG 2>&1

# 3. Waybar
echo "Reiniciando Waybar..." >> $LOG
killall waybar
sleep 1
nohup waybar >> $LOG 2>&1 &

# 4. Notificaciones y Terminal
echo "Actualizando extras..." >> $LOG
pkill -USR1 kitty >> $LOG 2>&1

swaync-client -rs >> $LOG 2>&1

echo "=== FIN ===" >> $LOG
