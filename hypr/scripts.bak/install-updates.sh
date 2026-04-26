#!/usr/bin/env bash
#     _             _        _   _           _       _
#    / \   _ __ ___| |__    | | | |_ __   __| | __ _| |_ ___  ___
#   / _ \ | '__/ __| '_ \   | | | | '_ \ / _` |/ _` | __/ _ \/ __|
#  / ___ \| | | (__| | | |  | |_| | |_) | (_| | (_| | ||  __/\__ \
# /_/   \_\_|  \___|_| |_|   \___/| .__/ \__,_|\__,_|\__\___||___/
#                                  |_|

sleep 0.5
clear
figlet -f smslant "Arch Updates"
echo

if gum confirm "DO YOU WANT TO START THE UPDATE NOW?"; then
    echo
    echo ":: Iniciando actualización..."
    echo
    yay
elif [ $? -eq 130 ]; then
    exit 130
else
    echo
    echo ":: Actualización cancelada."
    sleep 1
    exit
fi

echo
echo ":: Buscando actualizaciones de Flatpak..."
flatpak update
echo

echo ":: Actualizando contador de updates..."
arch-update -c

pkill -RTMIN+1 waybar

echo ":: ¡Listo! Presiona [ENTER] para cerrar."
read
