#!/bin/bash

if [[ -z "$PLEX_TOKEN" ]]; then
  logger "Plex authentication toke is not set. Set PLEX_TOKEN in /etc/environment"
  exit 1
fi

# Check if Plex is streaming
PLEX_ACTIVITY=$(curl -sf http://localhost:32400/status/sessions?X-Plex-Token=$PLEX_TOKEN | grep -i 'mediacontainer.*size')

if [ $? -ne 0 ]; then
  logger "Failed to reach plex server from check_activity.sh"
  exit 1
fi

ACTIVE=
logger "Plex state response: $PLEX_ACTIVITY"
if [[ "$PLEX_ACTIVITY" != *'size="0"'* ]]; then
  echo "plex is active"
  ACTIVE="$ACTIVE plex"
fi

SSH_CONNECTIONS=$(ss -t state established '( dport = :ssh or sport = :ssh )' | tail -n +2)
if [[ -n "$SSH_CONNECTIONS" ]]; then
  echo "ssh is active"
  ACTIVE="$ACTIVE ssh"
fi

for APP in $ACTIVITY_APPS; do
  if pgrep "$APP" >/dev/null; then
    echo "$APP is active"
    ACTIVE="$ACTIVE $APP"
  fi
done

logger "Server activity with:$ACTIVE"
if [[ -z $ACTIVE ]]; then
  # No active streams, schedule shutdown
  if [ ! -f /run/systemd/shutdown/scheduled ]; then
    logger "No activity, shutting down in 5 minutes."
    # add 3 second grace.. cannot deactivate in the 5th minute otherwise
    sleep 3 && sudo shutdown -h +5 >/dev/null 2>&1
  else
    logger "No activity, shutting down timer active."
  fi
elif [ -f /run/systemd/shutdown/scheduled ]; then
  # Active streams, cancel any pending shutdown
  logger "Active Plex streams, cancel shutdown."
  sudo shutdown -c
fi
