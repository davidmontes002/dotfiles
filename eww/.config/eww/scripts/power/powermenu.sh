#!/bin/bash
toggle_widget() {
    local widget="$1"
    eww open "$widget" --toggle
}

widgets=("powermenu")
for widget in "${widgets[@]}"; do
    toggle_widget "$widget"
done
