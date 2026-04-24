#!/bin/bash
pkill -f eww
pkill -f notifications.py
sleep 0.5
eww daemon --force-wayland
sleep 0.5
~/.config/eww/scripts/daemon_notify/notifications.py &
eww open notifications_popup
eww open control_center
