## Project URL
https://roadmap.sh/projects/simple-monitoring-dashboard

## Simple monitoring setup

### Script
Set script setup.sh to do the following:
- install ufw
- install netdata
- enable ufw and start netdata.service daemon
- open 19999 port (just in case, if we're going to see the dashboard from other machine)
### Setting up 
- Open /etc/netdata/netdata.conf
- By default your dashboard available only at the localhost
- we need to add 'bind to = 0.0.0.0', so this netdata dashboard will be available online (if you need it)
### Preparation of virtual network
- open subnet settings and your security list
- to make it available externally, you need to add Ingress rule (since we only be getting data from this port)
Source: 0.0.0.0/0
IP Protocol: TCP
Source Port Range: All
Destination Port Range: 19999
Allows: TCP traffic for port 19999
### Alerting in Netdata
https://learn.netdata.cloud/docs/alerts-&-notifications
Custom alerts need to be stored in /etc/netdata/health.d
1. Open notification config 
sudo ./edit-config health_alarm_notify.conf