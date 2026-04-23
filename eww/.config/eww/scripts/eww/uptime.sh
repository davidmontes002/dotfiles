#!/bin/bash
uptime_raw=$(uptime -p)
uptime_clean=${uptime_raw#"up "}
translated=$(echo "$uptime_clean" | sed \
    -e 's/minutes\?/min/g' \
    -e 's/hours\?/hr/g' \
    -e 's/days\?/días/g')
echo "󰅐 $translated"
