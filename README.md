# IDS/IPS Project using Snort, Fail2Ban, iptables, and Splunk

## Project Overview

This project demonstrates a layered intrusion detection and prevention system in a virtual lab environment.

The system detects and blocks:
- Nmap/port scan activity using Snort on the gateway
- SSH brute-force attacks using Fail2Ban on the server
- Attacker traffic using iptables-based blocking
- Logs prepared for SIEM monitoring using Splunk

## Network Architecture

```text
Kali Attacker
192.168.10.10
     |
     |
Gateway Ubuntu
enp0s3: 192.168.10.1
enp0s8: 192.168.20.1
enp0s9: Internet/NAT
     |
     |
Ubuntu Server
192.168.20.10
```

Optional SIEM:

```text
Splunk SIEM
192.168.20.20 for forwarders
192.168.56.101 for browser access
```

## Tools Used

- Kali Linux
- Ubuntu Server
- Snort
- iptables
- Fail2Ban
- Hydra
- Nmap
- Splunk Enterprise / Splunk Universal Forwarder

## IDS/IPS Implementation

Snort was installed on the gateway to monitor network traffic between the attacker and server networks.

Custom Snort rules are stored in:

```text
config/snort_local_rules.txt
```

The Snort blocker script monitors `/var/log/snort/alert` and calls the blocking script when rule SID `1000003` is detected.

Scripts:

```text
scripts/snort_blocker.sh
scripts/block_ip.sh
```

## SSH Brute-force Protection

Fail2Ban was installed on the Ubuntu server to monitor `/var/log/auth.log`.

Configuration:

```text
config/fail2ban_jail.local.txt
```

Fail2Ban bans the attacker IP after repeated failed SSH login attempts.

## Attack Simulation

### Nmap Scan

```bash
nmap -Pn 192.168.20.10
```

### SSH Brute-force

```bash
hydra -l test -p wrong ssh://192.168.20.10
```

## Log Evidence

Important logs should be stored in the `logs/` folder:

```text
logs/auth_log.txt
logs/fail2ban.txt
logs/snort_alert.txt
logs/blocked_ips.txt
```

## Screenshots

Screenshots should be stored in the `screenshots/` folder:

```text
screenshots/nmap_attack.png
screenshots/hydra_attack.png
screenshots/snort_detection.png
screenshots/fail2ban_ban.png
screenshots/iptables_block.png
```

## Results

| Attack Type | Detection Tool | Blocking Tool | Evidence |
|---|---|---|---|
| Port scan | Snort | iptables script | Snort alert + blocked_ips log |
| SSH brute-force | Fail2Ban | Fail2Ban iptables rule | auth.log + fail2ban.log |

## Conclusion

This project demonstrates a complete security workflow:

```text
Attack → Detection → Blocking → Logging → SIEM-ready monitoring
```

The final system successfully demonstrates network-based IDS/IPS and host-based brute-force protection.
