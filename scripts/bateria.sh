#!/bin/bash

# Niveles de alerta
ADVERTENCIA=20
CRITICO=10

# Banderas para no spamear notificaciones
NOTIFICADO_ADV=false
NOTIFICADO_CRI=false

while true; do
    # Autodetectar la batería (normalmente BAT0 o BAT1 dependiendo de la marca de la laptop)
    BATERIA=$(ls /sys/class/power_supply/ | grep -i "BAT" | head -n 1)
    
    # Si no hay batería, salir del script
    if [ -z "$BATERIA" ]; then
        exit 0
    fi

    # Leer capacidad y estado (Cargando o Descargando)
    CAPACIDAD=$(cat /sys/class/power_supply/$BATERIA/capacity)
    ESTADO=$(cat /sys/class/power_supply/$BATERIA/status)

    if [ "$ESTADO" = "Discharging" ]; then
        if [ "$CAPACIDAD" -le "$CRITICO" ] && [ "$NOTIFICADO_CRI" = false ]; then
            # Notificación crítica (Usará el color1 de tu configuración de Mako)
            notify-send -u critical "¡Batería Crítica!" "Te queda el $CAPACIDAD%. Conecta el cargador de inmediato."
            NOTIFICADO_CRI=true
            NOTIFICADO_ADV=true
            
        elif [ "$CAPACIDAD" -le "$ADVERTENCIA" ] && [ "$CAPACIDAD" -gt "$CRITICO" ] && [ "$NOTIFICADO_ADV" = false ]; then
            # Notificación normal
            notify-send -u normal "Batería Baja" "Te queda el $CAPACIDAD% de energía."
            NOTIFICADO_ADV=true
        fi
    else
        # Si se conecta el cargador, reiniciamos las banderas
        NOTIFICADO_ADV=false
        NOTIFICADO_CRI=false
    fi

    # Pausa de 1 minuto antes de volver a comprobar
    sleep 60
done
