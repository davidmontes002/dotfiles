#!/bin/bash
MONITOR=$(hyprctl monitors -j | python3 -c "
import json, sys
monitors = json.load(sys.stdin)
for m in monitors:
    if m.get('focused'):
        print(m['name'])
        break
")
hyprswitch gui --mod-key alt --key tab --close default --reverse-key mod=shift --ignore-workspaces --show-workspaces-on-all-monitors
