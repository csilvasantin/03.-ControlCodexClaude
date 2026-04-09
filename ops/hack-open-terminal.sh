#!/bin/bash
# hack-open-terminal.sh — Opens Terminal fullscreen with hack-sim.sh
# Uploaded to remote Mac and executed there.
# Usage: hack-open-terminal.sh <hostname> <ip>

HOST="$1"
IP="$2"

osascript <<EOF
tell application "Terminal"
    activate
    do script "clear && bash /tmp/hack-sim.sh '$HOST' '$IP'"
    delay 1
    tell application "System Events"
        tell process "Terminal"
            set frontmost to true
            delay 0.5
            keystroke "f" using {command down, control down}
        end tell
    end tell
end tell
EOF
