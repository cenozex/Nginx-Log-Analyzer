#!/usr/bin/env bash
# Log Analyzer

# Color Codes
RED='\033[0;31m'
GREEN='\033[0;32m'
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
BOLD='\033[1m'
RESET='\033[0m'

COUNTS=5

divider()
{
    echo -e "${CYAN}────────────────────────────────────────────────────${RESET}"
}

header()
{
    divider
    echo -e "${BOLD}${YELLOW}   $1 ${RESET}"
    divider
}

header "Nginx Log Analyzer"
echo ""
header "Top ${COUNTS} IP addresses with the most requests"

awk '{print $1}' logfile.txt | sort | uniq -c | sort -nr |awk '{print $2 " - " $1 " requests"}' | head -n ${COUNTS}

header "Top ${COUNTS} most requested paths"

awk '{print $7}' logfile.txt | sort | uniq -c | sort -nr |awk '{print $2 " - " $1 " requests"}' | head -n ${COUNTS}

header "Top ${COUNTS} response status code"

grep -oE ' [1-5][0-9]{2} ' logfile.txt | sort | uniq -c | sort -rn | awk '{print $2 " - " $1 " requests"}' |  head -n $COUNTS 

header "Top ${COUNTS} user agents"

awk -F'"' '{print $6}' logfile.txt | sort | uniq -c | sort -nr | awk '{for(i=2;i<=NF;i++) printf "%s ", $i; print "-",$1,"requests"}' | head -n $COUNTS
