#!bin/bash

sudo systemctl enable inactive-shutdown.service
sudo systemctl enable inactive-shutdown.timer
sudo systemctl start inactive-shutdown.service
sudo systemctl start inactive-shutdown.timer

# reload system to see changes (only needed when changeing service files)
sudo systemctl daemon-reload

# prevent: System is going down. Unprivileged users are not permitted to log in anymore.
# For technical details, see pam_nologin(8).
sudo rm -f /etc/nologin
if [[ -n $(sed -n 's/^account.*required.*pam_nologin.so/#&/p' /etc/pam.d/sshd) ]]; then
  sudo sed -i 's/^account.*required.*pam_nologin.so/#&/' /etc/pam.d/sshd
  sudo systemctl restart sshd
fi
