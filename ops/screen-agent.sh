#!/bin/bash
# screen-agent.sh — captures screen locally and sends to AdmiraNext Control server
# Usage: screen-agent.sh <machine-id> [interval-seconds] [server-url]
#
# Runs as a loop, capturing screen every N seconds and POSTing to the server.
# Install: copy to each machine and run via launchd or nohup.

MACHINE_ID="${1:?Usage: screen-agent.sh <machine-id> [interval] [server-url]}"
INTERVAL="${2:-30}"
SERVER="${3:-https://macmini.tail48b61c.ts.net}"

TMP_FILE="/tmp/tw_screen_agent.jpg"

echo "Screen agent started: machine=$MACHINE_ID interval=${INTERVAL}s server=$SERVER"

while true; do
  # Capture screen as JPEG (low quality for speed)
  screencapture -x -t jpg "$TMP_FILE" 2>/dev/null

  if [ -f "$TMP_FILE" ] && [ -s "$TMP_FILE" ]; then
    # Resize to max 960px wide for bandwidth
    sips -Z 960 "$TMP_FILE" --setProperty formatOptions 60 >/dev/null 2>&1

    # Upload to server
    HTTP_CODE=$(curl -s -o /dev/null -w "%{http_code}" \
      --max-time 10 \
      -X POST \
      -H "Content-Type: image/jpeg" \
      --data-binary @"$TMP_FILE" \
      "$SERVER/api/screenshots/$MACHINE_ID")

    if [ "$HTTP_CODE" = "200" ]; then
      echo "$(date +%H:%M:%S) OK ($MACHINE_ID)"
    else
      echo "$(date +%H:%M:%S) FAIL HTTP $HTTP_CODE"
    fi

    rm -f "$TMP_FILE"
  else
    echo "$(date +%H:%M:%S) screencapture failed"
  fi

  sleep "$INTERVAL"
done
