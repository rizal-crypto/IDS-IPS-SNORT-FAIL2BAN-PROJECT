#!/bin/bash

# Gateway interfaces:
# enp0s3 = Kali side / 192.168.10.1
# enp0s8 = Server side / 192.168.20.1
# enp0s9 = Internet/NAT interface

echo 1 > /proc/sys/net/ipv4/ip_forward

iptables -F
iptables -t nat -F

iptables -P FORWARD ACCEPT

iptables -t nat -A POSTROUTING -o enp0s9 -j MASQUERADE

iptables -A FORWARD -i enp0s3 -o enp0s8 -j ACCEPT
iptables -A FORWARD -i enp0s8 -o enp0s3 -j ACCEPT

iptables -A FORWARD -i enp0s8 -o enp0s9 -j ACCEPT
iptables -A FORWARD -i enp0s9 -o enp0s8 -m state --state RELATED,ESTABLISHED -j ACCEPT
