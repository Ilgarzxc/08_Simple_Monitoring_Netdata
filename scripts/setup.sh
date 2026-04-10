#!/bin/bash

LOGFILE=/var/log/netdata.log

sudo apt update

NETDATA_INSTALLED=$(netdata -v | grep "netdata")
UFW_INSTALLED=$(ufw --version | grep "ufw")
UFW_IS_INACTIVE=$(sudo ufw status | grep "Status: inactive")

if [ -z "$NETDATA_INSTALLED" ]; then
    sudo apt install netdata -y
    sudo systemctl start netdata.service
    echo "Netdata package has been installed and activated" >> "$LOGFILE"
else
    echo "Netdata already installed" >> "$LOGFILE"
fi

if [ -z "$UFW_INSTALLED" ]; then
    sudo apt install ufw -y
    echo "Uncomplicated firewall has been installed" >> "$LOGFILE"
fi

if [ -n "$UFW_IS_INACTIVE" ]; then
    echo "y" | sudo ufw enable
    echo "Uncomplicated firewall enabled" >> "$LOGFILE"
else
    echo "Uncomplicated firewall already installed" >> "$LOGFILE"
fi

PORT_ALLOWED=$(sudo ufw status | grep "19999" | grep "ALLOW")

if [ -z "$PORT_ALLOWED" ]; then
    sudo ufw allow 19999 #allow default port for netdata
    echo "Port 19999 opened" >> "$LOGFILE"
else
    echo "Port 19999 was already open" >> "$LOGFILE"
fi