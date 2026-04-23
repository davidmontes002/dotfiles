#!/bin/bash
if [[ -z "$1" ]]; then
    eww close powermenu
    exit 0
fi

ACTION="$1"

confirm() {
    zenity --question --title="¿Estás seguro?" --text="$1"
    return $?
}

case "$ACTION" in
    "poweroff")
        if confirm "¿Apagar el sistema?"; then
            systemctl poweroff
        fi
        ;;
    "reboot")
        if confirm "¿Reiniciar el sistema?"; then
            systemctl reboot
        fi
        ;;
    "lock")
        eww close powermenu
        sleep 0.3
        hyprlock
        ;;
    "suspend")
        if confirm "¿Suspender el sistema?"; then
            eww close powermenu
            sleep 0.2
            systemctl suspend
        fi
        ;;
    "logout")
        if confirm "¿Cerrar sesión?"; then
            hyprctl dispatch exit 0
        fi
        ;;
    "cancel")
        eww close powermenu
        ;;
esac
