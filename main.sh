#!/bin/bash

#### Variables
hosts=$(cat ./hosts)
hosts_count=$(cat ./hosts | grep -c "[A-Za-z0-9]")
counter=1

# Sets color for text
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m'

#### Pre-Actions/Files
> ./down

#### Script Execution
for c in $hosts
do

    # Message and formatting.
    clear
    echo -e "${GREEN}Pinging Devices! Please be patient:${NC} ${YELLOW}$counter|$hosts_count${NC}"

    # Main Script
    if ! ping -c 2 -W 2 "$c" &> /dev/null; then
        echo "$c" >> ./down
    fi

    # Increaeses counter
    ((counter++))
done

#### Final Readout
if [ -s ./down ]; then # Checks to see if file is empty
    echo -e "\n${YELLOW}The Following devices are down:${NC}"
    cat ./down
else
    echo -e "${GREEN}All devices are online!${NC}"
fi
