#!/usr/bin/env bash

# loop wallpapers from a given directory
# and iterate for given time, default 10 seconds

WALL_PATH="$1"
TIME="${2:-10}"

if [[ -z "$WALL_PATH" || ! -d "$WALL_PATH" ]]; then
    echo "Error: Provide valid directory path!"
    echo "Usage: $0 path/to/wallpaper_directory"
    exit 1
fi

termux-wake-lock
while true; do
    for IMG in $WALL_PATH/*; do
        termux-wallpaper -f "$IMG"
        sleep $TIME
    done
done
