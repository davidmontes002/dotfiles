#!/bin/bash

# Recibimos la imagen desde Rofi
IMAGEN="$1"

# 1. Aplicamos el fondo con awww
awww img "$IMAGEN" --transition-type wipe

# 2. Extraemos colores con Pywal
wal -q -i "$IMAGEN"

# 3. Reiniciamos Waybar para que lea los nuevos colores
killall waybar
hyprctl dispatch exec waybar

# 4. Recargamos los colores de las notificaciones flotantes
makoctl reload
