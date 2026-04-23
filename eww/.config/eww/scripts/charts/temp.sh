#!/usr/bin/env bash
temp=$(sensors 2>/dev/null | awk '/Package id 0/ {gsub(/\+|°C/,"",$4); print int($4); exit}')
if [[ -z "$temp" ]]; then
    temp=$(sensors 2>/dev/null | awk '/Tctl/ {gsub(/\+|°C/,"",$2); print int($2); exit}')
fi
if [[ -z "$temp" && -r /sys/class/thermal/thermal_zone0/temp ]]; then
    temp=$(( $(cat /sys/class/thermal/thermal_zone0/temp) / 1000 ))
fi
echo "${temp:-0}"
