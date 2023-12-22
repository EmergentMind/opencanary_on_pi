# Installing opencanary on a Raspberry Pi

This is a small repo to help auotmate re-installation of Thinkst OpenCanary on a Raspberry Pi and assumes that you have a working configuration file.
I decided to write this when the SD card on my original install died and I wanted a faster way of deploying again in the future.

You can find info about OpenCanary here:

- <https://opencanary.readthedocs.io/>
- <https://github.com/thinkst/opencanary>

Shout out to Michael Van Delft. When I originally set up my honeypot, I found some useful information on his blog: <https://xo.tc/installing-opencanary-on-a-raspberry-pi.html>

## Requirements and Assumptions

### opencanary.conf

The configuration file included in this repo is just a copy of the default that opencanary generates.
As stated above, the assumption is you have a working config file already established.
You can edit the one provided here or replace it with your own as you see fit.
There is plenty of good info available in the official documentation about how to setup your config:
<https://opencanary.readthedocs.io/en/latest/starting/configuration.html>

### User settings on the device

When setting up your RaspberryPi you must have a username `pi`. The initialization script and service rely on that.
The preparation steps below include a very quick rundown of how to set up the device. There are plenty of detailed guides out there but this does assume you know how to create SSH keys beforehand.

### OS

I used Raspberry Pi OS, this may also work with other debian based distros but you may run into issues with the systemd service. You can read more about how others have set up a service for various distros on the thinkst github: <https://github.com/thinkst/opencanary/issues/73>

## Preparation

### Set up your Raspberry Pi with an OS and an SSH key

There are numerous ways to do this. The easiest way I've found is to use the Raspberry Pi Imager `rpi-imager`.

1. Install `rpi-imager` on your computer
1. Insert an SD card into your computer
1. Run `rpi-imager`
1. Select the model of Raspberry Pi you havek
1. Select `Raspberry Pi OS (other) > Raspberry Pi OS Lite (32-bit)`
1. Select the sotrage location of SD card you inserted
1. Click `Next`
1. Use the following OS Customization settings:
   - Set hostname: yourhostname
   - Username: pi !This must be set to pi for the script to work!
     - Password= your password
   - Services:
     - Enable SSH
     - Allow public-key authentication only
     - Set authorized_keys for 'pi': your public key
1. Follow the remaining prompts to write the image to the SD card
1. Insert the SD card into your Raspberry Pi, connect it to the network, and power it on
1. Wait for it to do its initial boot up and connect to the network

### Copy the required files to the Raspberry Pi

You'll need you to have the following files onto the device:

- opencanary.init.sh
- opencanary.conf
- opencanary.service

To do so you can use scp: `$ scp opencanary.init.sh .opencanary.conf opencanary.service pi@[ip address]:[home pi](/home/pi)`

## Running the script

1. Connect to the device via SSH:
   `$ ssh pi@[ip address]`
1. If you're prone to typos, the first thing to do is set the terminal to linux so you can use backspace.
   `$ export TERM="linux"`
1. Once you're connected to the Raspberry Pi, you need to make the script executable
   `$ chmod +x opencanary.init.sh`
1. Then you can run it
   `$ ./opencanary.init.sh`
1. Wait for the script to finish running. It will take quite some time to install all of the packages, start the virutal environment, and start the service. If it seems to be hanging, just give it some more time.
1. Once the script is complete and the service is running, you should receive several notifications to email or whatever service you decided on.

The service is enabled so it will automatically start whenever the device boots.
