#!/bin/bash

# Load configuration
source config.conf

# Load all functions
source functions.sh

show_banner

collect_system_info

check_cpu

check_memory

check_disk

check_services

generate_report

write_log
