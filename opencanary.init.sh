#!/bin/bash

# Set up a sane terminal
export TERM=linux
echo "export TERM=linux" >> ~/.bashrc
sudo chsh -s /bin/bash pi

# Disable password based logins, challenge response authentication, and PAM
sudo sed -i 's/#PasswordAuthentication yes/PasswordAuthentication no/g' /etc/ssh/sshd_config
sudo sed -i 's/PasswordAuthentication yes/PasswordAuthentication no/g' /etc/ssh/sshd_config
sudo sed -i 's/#ChallengeResponseAuthentication yes/ChallengeResponseAuthentication no/g' /etc/ssh/sshd_config
sudo sed -i 's/ChallengeResponseAuthentication yes/ChallengeResponseAuthentication no/g' /etc/ssh/sshd_config
sudo sed -i 's/#UsePAM no/UsePAM no/g' /etc/ssh/sshd_config
sudo sed -i 's/UsePAM yes/UsePAM no/g' /etc/ssh/sshd_config

# Update and install the required packages, including optional modules
sudo apt update -y
sudo apt install python3-pip python3-dev libffi-dev libssl-dev libjpeg-dev zlib1g-dev libcap2-bin \
	virtualenv samba git ftp git -y

# Create and activate the virtual environment for OpenCanary
virtualenv env/
echo "starting virtual environment"
. env/bin/activate

# From the virtual environment install OpenCanary and optional modules
pip3 install scapy pcapy-ng
pip3 install opencanary

# Initialize the default OpenCanary configuration file
opencanaryd --copyconfig

# Replace the config with our custom file that was copied to the device during the preparation steps
# We'll be running the systemd service as root later on so opencanary won't be looking for the config in the pi user's home directory. We do this because there is senstive information in the covnfig and we'll be making it readable only by root
sudo mv ~/opencanary.conf /etc/opencanaryd/opencanary.conf
sudo chmod 700 /etc/opencanaryd/opencanary.conf

# We want the honeypot to be up after a reboot so lets set up a systemd service
# the service file that ships with OpenCanary isn't quite what we want to we'll use the one we scped to ~/ instead	
sudo mv ~/opencanary.service /etc/systemd/system/opencanary.service

# Now we want to enable and start the service
sudo systemctl enable opencanary.service
sudo systemctl start opencanary.service

# if this worked correctly, and your notification settings in .opencanary.conf are correct, you should get several notifications about services starting
# If you don't get any notifications, check the log file at /var/tmp/opencanary.log