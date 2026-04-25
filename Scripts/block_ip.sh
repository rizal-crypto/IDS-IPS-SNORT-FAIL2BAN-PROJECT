#!/bin/bash

IP="$1"
SID="${2:-unknown}"
LOGFILE="/var/log/blocked_ips.log"

if [ -z "$IP" ]; then
    echo "Usage: $0 <ip> [sid]"
    exit 1
fi

TIMESTAMP=$(date -u +"%Y-%m-%dT%H:%M:%SZ")

iptables -C FORWARD -s "$IP" -j DROP 2>/dev/null || iptables -I FORWARD 1 -s "$IP" -j DROP
iptables -C INPUT -s "$IP" -j DROP 2>/dev/null || iptables -I INPUT 1 -s "$IP" -j DROP

echo "time=$TIMESTAMP action=block src_ip=$IP sid=$SID method=iptables" >> "$LOGFILE"
logger -t ips-blocker "time=$TIMESTAMP action=block src_ip=$IP sid=$SID method=iptables"

echo "[+] Blocked $IP"
