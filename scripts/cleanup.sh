#!/bin/bash

LOGFILE=/var/log/netdata.log

sudo systemctl stop netdata.service

if command -v netdata >/dev/null 2>&1; then
    sudo apt purge netdata -y
    echo "Netdata package has been removed" >> "$LOGFILE"
else
    echo "Netdata package already deleted" >> "$LOGFILE"
fi 

PORT_ALLOWED=$(sudo ufw status | grep "19999" | grep "ALLOW")

if [ -n "$PORT_ALLOWED" ]; then
    sudo ufw deny 19999 #deny default port for netdata
    echo "Port 19999 closed" >> "$LOGFILE"
else
    echo "Port 19999 was already closed" >> "$LOGFILE"
fi

sudo rm -rf /usr/libexec/netdata/ /etc/netdata/ /var/lib/netdata /var/cache/netdata /var/log/netdata /opt/netdata /usr/sbin/netdata /etc/systemd/system/netdata.service /var/run/netdata

sudo systemctl daemon-reload