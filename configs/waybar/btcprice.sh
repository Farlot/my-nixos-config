#!/usr/bin/env bash

# API endpoint for CoinGecko (no API key needed for simple price)
API_URL="https://api.coingecko.com/api/v3/simple/price?ids=bitcoin&vs_currencies=usd"

# Fetch data from the API
response=$(/run/current-system/sw/bin/curl -s "$API_URL") # <--- ABSOLUTE PATH FOR CURL

# Extract the Bitcoin price in USD using jq
price=$(echo "$response" | /run/current-system/sw/bin/jq -r '.bitcoin.usd') # <--- ABSOLUTE PATH FOR JQ

# Check if price is not null or empty
if [ -n "$price" ] && [ "$price" != "null" ]; then
    # Format the price for Waybar
    printf '{"text": "%.0f USD", "tooltip": "Current BTC Price"}' "$price"
else
    # Handle error case: API call failed or price not found
    echo '{"text": "BTC N/A", "class": "error", "tooltip": "Failed to fetch BTC price"}'
fi
