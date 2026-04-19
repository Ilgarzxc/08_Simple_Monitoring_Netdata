## Project URL
https://roadmap.sh/projects/simple-monitoring-dashboard

## Project Structure

- scripts/
  - setup.sh – install and configure Netdata
  - test_dashboard.sh – simulate system load
  - cleanup.sh – remove Netdata

- alerts/
  - cpu_usage_80.conf – CPU usage alert
  - ip_changed.conf – alert when public IP changes
  - disabled_default_alerts.conf – disables default alerts

- charts.d/
  - ip_change.chart.sh – custom chart for tracking public IP

## Simple monitoring setup
This project demonstrates how to set up a simple monitoring system using Netdata.

It includes:
- automated installation
- firewall configuration
- external dashboard access
- custom charts
- alerting system

This project also includes a custom chart that tracks public IP changes.

A corresponding alert is triggered when the IP changes, allowing you to detect:
- ISP changes
- VPN reconnects
- server network changes

## How to Run

```bash
git clone https://github.com/Ilgarzxc/08_Simple_Monitoring_Netdata
cd <repo directory>
chmod +x scripts/*.sh
# install and start monitoring
./scripts/setup.sh

# (optional) simulate load
./scripts/test_dashboard.sh

# (optional) cleanup
./scripts/cleanup.sh
```

### Script

Set script setup.sh to do the following:
- install ufw
- install netdata
- enable ufw and start netdata.service daemon
- open 19999 port (just in case, if we're going to see the dashboard from another machine)

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
### Security Note
Opening port 19999 to 0.0.0.0/0 is not recommended for production.
Consider restricting access by IP or using a VPN.

### Charts

If you would like to create a custom chart for further alerting setup and visualization, you need to create executable file in `/usr/libexec/netdata/charts.d`
Naming convention of these files: {chartname}.chart.sh
We need to add three functions:
- check() - set a status of metrics (1 or 0; inactive or active)
- create() - create a metrics, dimension and update frequency
- update() - data provisioning to the metrics (in my case it was a source script)

### Alerting in Netdata

https://learn.netdata.cloud/docs/alerts-&-notifications
Custom alerts need to be stored in /etc/netdata/health.d
1. Open notification config 
`sudo ./edit-config health_alarm_notify.conf`
and set up email address for receiving the alerts
2. Create alerts according to your requirements (examples can be found in alerts folder of this repository)
3. Disable some default alerts (if needed, to avoid duplicates) with file in directory /etc/netdata/health.d
4. Reload alerts and configuration with `sudo netdatacli reload-health` command 

### Dashboard setup

https://learn.netdata.cloud/docs/dashboards-and-charts/tabs/dashboards
Open  http://localhost:19999/ or http://{your-server-ip}:19999/ 
1. Sign in and create an account
2. Generate bearer token to confirm an access `sudo cat /var/lib/netdata/netdata_random_session_id` 
3. Now you can change dashboard settings and work with UI with the relevant access rights.

## Room for improvement
- add alerting via email