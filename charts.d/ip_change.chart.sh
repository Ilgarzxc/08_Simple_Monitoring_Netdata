#!/usr/bin/env bash

ip_change_check() {
    return 0
}

# CHART definition:
# CHART <chart_id> <context> <title> <units> <family> <category> <type> <priority> <update_every>
# - chart_id: unique identifier for the chart
# - context: optional grouping for similar charts (can be empty)
# - title: human‑readable chart title
# - units: measurement units displayed in the dashboard
# - family: logical grouping of related metrics
# - category: dashboard category
# - type: chart visualization type (line, area, stacked, etc.)
# - priority: sorting order (lower = higher priority)
# - update_every: how often Netdata updates this chart

# DIMENSION definition:
# DIMENSION <id> <name> <algorithm> <multiplier> <divisor>
# - id: internal dimension name
# - name: label shown in the dashboard
# - algorithm: how Netdata processes the value (absolute = raw value)
# - multiplier/divisor: scaling factors applied to the metric

ip_change_create() {
    cat <<EOF
CHART ip_change.ip '' 'Public IP Change' 'exit code' ip_change ip line 60000 1
DIMENSION exit exit absolute 1 300
EOF
}

# UPDATE block format:
# BEGIN <chart_id>
# SET <dimension_id> = <value>
# END
#
# - BEGIN: tells Netdata that a new data update starts for this chart
# - SET: assigns a numeric value to a specific dimension
# - END: marks the end of the update block
#
# Notes:
# - <value> must be a number (Netdata does not accept strings)
# - update() is called automatically based on the chart's update_every interval
# - every update must output a complete BEGIN/SET/END block


ip_change_update() {
    EXIT_CODE=$(bash /home/ubuntu/scripts/public_ip_info.sh)
    cat <<EOF
BEGIN ip_change.ip
SET exit = $EXIT_CODE
END
EOF
}

# HEREDOC explanation:
# cat <<EOF ... EOF is used to output a multi-line block of text.
# Everything between the markers is printed exactly as written.
# Variables inside the block (like $EXIT_CODE) are expanded by Bash.
# Netdata reads this output as the update() data stream.
#
# This is the cleanest way to generate:
# BEGIN <chart>
# SET <dimension> = <value>
# END
