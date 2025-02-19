#!/bin/bash

SCRIPT_DIR=$(dirname "$(realpath "$0")")
SCRIPT_NAME=$(basename "$0")
PREFIX="[$SCRIPT_DIR/$SCRIPT_NAME]"

function log() {
  logger "$PREFIX $@"
}

if [[ -z "$PLEX_TOKEN" ]]; then
  log "Plex authentication toke is not set. Set PLEX_TOKEN in /etc/environment"
  exit 1
fi

# Check if Plex is streaming
PLEX_ACTIVITY=$(curl -sf http://localhost:32400/status/sessions?X-Plex-Token=$PLEX_TOKEN | grep -i 'mediacontainer.*size')

if [ $? -ne 0 ]; then
  log "Failed to reach plex server from check_activity.sh"
  exit 1
fi

ACTIVE=
log "Plex state response: $PLEX_ACTIVITY"
if [[ "$PLEX_ACTIVITY" != *'size="0"'* ]]; then
  ACTIVE="$ACTIVE plex"
fi

SSH_CONNECTIONS=$(ss -t state established '( dport = :ssh or sport = :ssh )' | tail -n +2)
if [[ -n "$SSH_CONNECTIONS" ]]; then
  echo "ssh is active"
  ACTIVE="$ACTIVE ssh"
fi

log "Server activity with:$ACTIVE"
if [[ -z $ACTIVE ]]; then
  # No active streams, schedule shutdown
  if [ ! -f /run/systemd/shutdown/scheduled ]; then
    log "No activity, shutting down in 5 minutes."
    sudo shutdown -h +5 >/dev/null 2>&1
  else
    log "No activity, shutting down timer active."
  fi
elif [ -f /run/systemd/shutdown/scheduled ]; then
  # Active streams, cancel any pending shutdown
  log "Active Plex streams, cancel shutdown."
  sudo shutdown -c
fi
