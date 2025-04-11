#!/bin/bash

export TZ=Europe/Amsterdam
ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ >/etc/timezone

sudo apt update
sudo DEBIAN_FRONTEND=noninteractive apt-get install dirmngr ca-certificates software-properties-common apt-transport-https curl -y
curl -fsSL https://downloads.plex.tv/plex-keys/PlexSign.key | sudo gpg --dearmor | sudo tee /usr/share/keyrings/plex.gpg
echo deb [signed-by=/usr/share/keyrings/plex.gpg] https://downloads.plex.tv/repo/deb public main | sudo tee /etc/apt/sources.list.d/plexmediaserver.list
sudo apt-get update
sudo apt-get install -y plexmediaserver

if command -v systemctl >/dev/null && [ -d /run/systemd/system ]; then
  sudo systemctl start plexmediaserver
  sudo systemctl enable plexmediaserver
else
  echo "Systemd not detected. Service will need to be started manually."
  # Alternative service start method for non-systemd environments
  sudo service plexmediaserver start || true
fi

if command -v ufw >/dev/null; then
  sudo ufw allow 32400
fi

if id -u plex >/dev/null 2>&1; then
  sudo usermod -aG plex $USER
  sudo usermod -aG $USER plex
  sudo usermod -aG $USER root
fi

cat <<EOF
Create tunnel to local machine: 
  > ssh {server-ip-address} -L 8888:localhost:32400
  > go to http://localhost:8888/web
EOF
