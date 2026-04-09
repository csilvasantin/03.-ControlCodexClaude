#!/bin/bash
# hack-open-terminal.sh — Opens Terminal maximized/fullscreen with hack-sim.sh
# Uploaded to remote Mac and executed there.
# Usage: hack-open-terminal.sh <hostname> <ip>

HOST="$1"
IP="$2"

# Step 1: Open Terminal, run hack script, maximize window (always works, no Accessibility needed)
osascript -e "
tell application \"Terminal\"
    activate
    do script \"export TERM=xterm-256color; clear && bash /tmp/hack-sim.sh '$HOST' '$IP'\"
    delay 0.5
    set bounds of front window to {0, 0, 3000, 2000}
end tell"

# Step 2: Try native fullscreen (Ctrl+Cmd+F) with a hard 3s timeout
# This needs Accessibility permissions — if they're missing, it hangs forever,
# so we run it in background and kill it after 3 seconds
(
    osascript -e '
tell application "System Events"
    tell process "Terminal"
        set frontmost to true
        delay 0.2
        keystroke "f" using {command down, control down}
    end tell
end tell' 2>/dev/null
) &
FS_PID=$!
sleep 3
kill $FS_PID 2>/dev/null
wait $FS_PID 2>/dev/null
exit 0
