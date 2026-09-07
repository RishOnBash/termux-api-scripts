#!/usr/bin/env bash

# script to monitor battery percentage via termux-battery-status
# and run this script every 00:00 and 06:00 to generate 
# an average battery drain during this period
# why this timeframe, well the phone will be left idle in my case

# Global vars.
BATTERY_PERCENT="$HOME/battery_percent.txt"
DRAIN_PERCENT="$HOME/battery_drain_percent.txt"
DATE=$(date +"%d/%m/%Y")
HOUR=$(date '+%H')
COUNT=$(wc -l < $DRAIN_PERCENT)
AVG_DRAIN="$HOME/average_drain.txt"
PERCENTAGE=$(termux-battery-status | grep "percentage" | tr -cd [0-9]) 

echo "$PERCENTAGE" >> "$BATTERY_PERCENT"

# at 12:00 append drain percentage difference to a specified file 
if (( HOUR == 6 )); then
    tail -n 2 $BATTERY_PERCENT | 
        awk 'NR==1{old=$1} NR==2{print "Drain: " old-$1 "%"}' >> \
        "$DRAIN_PERCENT"
    rm -f $BATTERY_PERCENT
fi

# generate weekly average battery drain
if (( COUNT == 7 )); then
    VALUE=$(awk '{print $2}' "$DRAIN_PERCENT" | tr -d '%')
    AVG=$(awk '{sum+=$1} END {if(NR>0) printf "%.1f", sum/NR}' <<< "$VALUE")
    
    # notify using Termux:API
    termux-notification --id "battery_audit" --title "Weekly Battery Report" \
        --content "Average Daily Drain: $AVG%"
    
    # save weekly report to file
    echo "[$DATE] Average Drain: $AVG%" >> "$AVG_DRAIN"
    rm -f "$DRAIN_PERCENT"
fi
