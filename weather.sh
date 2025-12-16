#!/bin/bash
#weather.sh: add ability to read simple config file
CONF="weather.conf"

# Read config if exists
if [ -f "$CONF" ]; then
    source "$CONF"
else
    echo "Config file $CONF not found!"
    exit 1
fi

# Example use (dummy command)
echo "Fetching weather for $CITY using $UNITS units..."
# curl "https://api.weather/api?city=$CITY&units=$UNITS&key=$APIKEY"