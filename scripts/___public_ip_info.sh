#!/bin/bash

sudo touch /var/log/my_public_ip.log

IP_ADDRESS=$(curl -S  ifconfig.me)
SAVED_IP=$(sudo cat /var/log/my_public_ip.log)

# Проверка IP
if [ -z "$IP_ADDRESS" ]; then
    exit 1
fi

if ! [[ "$IP_ADDRESS" =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
    exit 1
fi


if [ "$IP_ADDRESS" = "$SAVED_IP" ]; then
	exit 0
else
	echo $IP_ADDRESS | sudo tee /var/log/my_public_ip.log
	exit 1
fi 



