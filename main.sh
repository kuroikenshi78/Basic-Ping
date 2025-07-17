#!/bin/bash

#### Variables
hosts=$(cat ./hosts)
hosts_count=$(grep -c "[A-Za-z0-9]" ./hosts)
counter=1
bar_width=50

# Sets color for text
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m'

#### Pre-Actions/Files
> ./down

#### Initial Message
clear
echo -e "${GREEN}Pinging Devices! Please be patient!${NC}"

#### Script Execution
for c in $hosts
do

    # Main Script
    if ! ping -c 2 -W 2 "$c" &> /dev/null; then
        echo "$c" >> ./down
    fi

    # Dynamic Progress Bar
    filled=$(( counter * bar_width / hosts_count ))
    bar=$(printf '#%.0s' $(seq 1 $filled))
    empty=$(( bar_width - filled ))
    spaces=$(printf ' %.0s' $(seq 1 $empty))

    printf "\r[%-50s] %d/%d" "$bar$spaces" "$counter" "$hosts_count"

    # Increaeses counter
    ((counter++))
done

#### Final Readout
if [ -s ./down ]; then # Checks to see if file is empty
    echo ""
    echo -e "\n${YELLOW}The Following devices are down:${NC}"
    cat ./down
else
    echo -e "${GREEN}All devices are online!${NC}"
fi
