#!/bin/bash

show_banner() {

clear

echo "================================================="
echo "      Automated Linux Server Health Monitor"
echo "================================================="
echo "Hostname : $(hostname)"
echo "Date     : $(date)"
echo "================================================="
echo

}

collect_system_info() {

HOSTNAME=$(hostname)

IP=$(hostname -I | awk '{print $1}')

UPTIME=$(uptime -p)

LOAD=$(uptime | awk -F'load average:' '{print $2}')

}

check_cpu() {

CPU=$(top -bn1 | grep "Cpu(s)" | awk '{print 100-$8}')

CPU=$(printf "%.0f" "$CPU")

}

check_memory() {

MEMORY=$(free | awk '/Mem:/ {printf("%.0f"), $3/$2 *100}')

}

check_disk() {

DISK=$(df / | awk 'END{print $5}' | sed 's/%//')

}

check_services() {

SERVICE_STATUS=""

for service in "${SERVICES[@]}"
do

if systemctl is-active --quiet "$service"
then
    SERVICE_STATUS+="[OK] $service is running\n"
else
    SERVICE_STATUS+="[FAIL] $service is NOT running\n"
fi

done

}

generate_report() {

REPORT_FILE="$REPORT_DIR/report_$(date +%F_%H-%M-%S).txt"

cat << EOF > "$REPORT_FILE"

====================================================
SERVER HEALTH REPORT
====================================================

Hostname       : $HOSTNAME

IP Address     : $IP

Date           : $(date)

CPU Usage      : $CPU%

Memory Usage   : $MEMORY%

Disk Usage     : $DISK%

Uptime         : $UPTIME

Load Average   : $LOAD

Services

$SERVICE_STATUS

====================================================

EOF

echo
echo "Report Generated"

echo "$REPORT_FILE"

}

write_log() {

echo "$(date) | CPU=$CPU% | MEM=$MEMORY% | DISK=$DISK%" >> "$LOG_FILE"

}
