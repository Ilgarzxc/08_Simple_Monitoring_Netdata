#!/bin/bash

LOGFILE=/var/log/netdata.log

sudo apt update
# Check if stress is installed
if ! command -v stress >/dev/null 2>&1; then
    sudo apt install stress -y
    echo "Stress package has been installed" >> "$LOGFILE"
else
    echo "Stress package already installed" >> "$LOGFILE"
fi

echo "CPU stress test is going to start..." >> "$LOGFILE"
stress --cpu 8 --timeout 300
echo "CPU stress test completed..." >> "$LOGFILE"