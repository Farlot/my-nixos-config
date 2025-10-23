#!/usr/bin/env bash

LATENCY=$(ping -c 3 8.8.8.8 | tail -1 | awk '{print $4}' | cut -d '/' -f 2)

if [[ -z "$LATENCY" ]]; then
    echo "{\"text\": \" Down\", \"tooltip\": \"No Internet Connectivity\", \"class\": \"down\"}"
else
    TEXT="${LATENCY}ms"
    if (( $(echo "$LATENCY > 150" | bc -l) )); then
        CLASS="poor"
    elif (( $(echo "$LATENCY > 50" | bc -l) )); then
        CLASS="average"
    else
        CLASS="good"
    fi
    echo "{\"text\": \" ${TEXT}\", \"tooltip\": \"Latency: ${TEXT}\", \"class\": \"${CLASS}\"}"
fi
