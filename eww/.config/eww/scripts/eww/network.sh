#!/bin/bash
INTERFACE="wlan0"

RX1=$(cat /sys/class/net/$INTERFACE/statistics/rx_bytes 2>/dev/null || echo 0)
TX1=$(cat /sys/class/net/$INTERFACE/statistics/tx_bytes 2>/dev/null || echo 0)
sleep 1
RX2=$(cat /sys/class/net/$INTERFACE/statistics/rx_bytes 2>/dev/null || echo 0)
TX2=$(cat /sys/class/net/$INTERFACE/statistics/tx_bytes 2>/dev/null || echo 0)

RX=$(( (RX2 - RX1) / 1024 ))
TX=$(( (TX2 - TX1) / 1024 ))

echo "󰁆 ${RX}KB/s 󰁞 ${TX}KB/s"
