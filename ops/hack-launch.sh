#!/bin/bash
# hack-launch.sh — Deploy and launch hack simulation on all online council Macs
# Usage: hack-launch.sh        (launch on all)
#        hack-launch.sh stop   (kill all simulations)

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
HACK_SCRIPT="$SCRIPT_DIR/hack-sim.sh"
SSH_OPTS="-o ConnectTimeout=3 -o StrictHostKeyChecking=no -o BatchMode=yes"
REMOTE_PATH="/tmp/hack-sim.sh"

HOSTS=(MacBookAir16       MacBookProNegro14    MacBookAirPlata     MacMini              MacBookAirBlanco     MacBookAirAzul       MacBookAirCrema)
IPS=( 100.99.176.126     100.101.192.1        100.114.113.88      100.74.101.14        100.75.118.75        100.84.81.45         100.110.80.2)

echo "=== AdmiraNext Council — HACKEO ==="
echo ""

if [ "$1" = "stop" ]; then
    echo "Stopping hack simulations..."
    for i in "${!HOSTS[@]}"; do
        host="${HOSTS[$i]}"
        ip="${IPS[$i]}"
        echo -n "  $host ($ip)... "
        ssh $SSH_OPTS csilvasantin@"$ip" "pkill -f hack-sim.sh 2>/dev/null; osascript -e 'tell application \"Terminal\" to quit' 2>/dev/null" 2>/dev/null && echo "STOPPED" || echo "skip"
    done
    echo "Done."
    exit 0
fi

for i in "${!HOSTS[@]}"; do
    host="${HOSTS[$i]}"
    ip="${IPS[$i]}"
    echo -n "  $host ($ip)... "

    # Check if reachable
    if ! ssh $SSH_OPTS csilvasantin@"$ip" "echo ok" &>/dev/null; then
        echo "OFFLINE"
        continue
    fi

    # Upload hack script
    scp -q $SSH_OPTS "$HACK_SCRIPT" csilvasantin@"$ip":$REMOTE_PATH 2>/dev/null
    ssh $SSH_OPTS csilvasantin@"$ip" "chmod +x $REMOTE_PATH" 2>/dev/null

    # Open Terminal fullscreen and run the hack script
    ssh -f $SSH_OPTS csilvasantin@"$ip" "osascript -e '
tell application \"Terminal\"
    activate
    do script \"clear && bash /tmp/hack-sim.sh '"'"'$host'"'"' '"'"'$ip'"'"'\"
    delay 0.5
    tell application \"System Events\"
        tell process \"Terminal\"
            set frontmost to true
            delay 0.3
            keystroke \"f\" using {command down, control down}
        end tell
    end tell
end tell'" 2>/dev/null

    echo "LAUNCHED"
done

echo ""
echo "Hack simulation running on all online machines."
echo "Run '$0 stop' to kill all."
