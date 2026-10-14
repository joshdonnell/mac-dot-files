#!/bin/bash

# Total CPU use across all cores, as a percentage of the whole machine
CORES="$(sysctl -n hw.ncpu)"
CPU="$(ps -A -o %cpu= | awk -v cores="$CORES" '{ sum += $1 } END { printf "%d", sum / cores }')"

sketchybar --set "$NAME" label="$CPU%"
