#!/bin/bash

LOG="/var/log/snort/alert"
TARGET_SID="1000003"
BLOCKER="/usr/local/bin/block_ip.sh"

if [ ! -f "$LOG" ]; then
    echo "Snort alert file not found: $LOG"
    exit 1
fi

tail -F "$LOG" | while read -r line
do
    if echo "$line" | grep -q "$TARGET_SID"; then
        IP=$(echo "$line" | grep -oE '[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+' | head -1)

        if [ -n "$IP" ]; then
            echo "[+] Alert matched SID $TARGET_SID, blocking $IP"
            "$BLOCKER" "$IP" "$TARGET_SID"
        fi
    fi
done
