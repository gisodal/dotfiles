#!/bin/bash

sudo apt update
sudo apt-get install dirmngr ca-certificates software-properties-common apt-transport-https curl -y
curl -fsSL https://downloads.plex.tv/plex-keys/PlexSign.key | sudo gpg --dearmor | sudo tee /usr/share/keyrings/plex.gpg
echo deb [signed-by=/usr/share/keyrings/plex.gpg] https://downloads.plex.tv/repo/deb public main | sudo tee /etc/apt/sources.list.d/plexmediaserver.list
sudo apt-get update
sudo apt-get install -y plexmediaserver

sudo systemctl start plexmediaserver
sudo systemctl enable plexmediaserver

sudo ufw allow 32400

sudo usermod -aG plex $USER
sudo usermod -aG $USER plex
sudo usermod -aG $USER root

cat <<EOF
Create tunnel to local machine: 
  > ssh {server-ip-address} -L 8888:localhost:32400
  > go to http://localhost:8888/web
EOF
