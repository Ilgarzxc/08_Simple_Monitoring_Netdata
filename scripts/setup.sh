#!/bin/bash

LOGFILE=/var/log/netdata.log

sudo apt update

NETDATA_INSTALLED=$(netdata -v | grep "netdata")
UFW_IS_INACTIVE=$(sudo ufw status | grep "Status: inactive")
PORT_ALLOWED=$(sudo ufw status | grep "19999" | grep "ALLOW")

if [ -z "$NETDATA_INSTALLED" ]; then
    sudo apt install netdata -y
    sudo systemctl start netdata
    echo "Netdata package has been installed" >> "$LOGFILE"
else
    exit 0
fi

if [ -n "$PORT_ALLOWED" ]; then
    sudo ufw allow 19999 #allow default port for netdata
    echo "Port 19999 opened" >> "$LOGFILE"
else
    exit 0
fi

if [ -n "$UFW_IS_INACTIVE" ]; then
    echo "y" | sudo ufw enable
    echo "Uncomplicated firewall enabled" >> "$LOGFILE"
else
    exit 0
fi