#!/bin/sh
#
# Add a city to cities.js

if [ "$#" -lt 4 ]; then
    echo "Usage: $0 cities-file city-name latitude longitude [date]" >&2
    exit 1
fi

if ! [ -f "$1" ]; then
    echo "$1 is not a file" >&2
    exit 1
fi

FILE="$1"
CITY="$2"
LATITUDE="$3"
LONGITUDE="$4"

NEW_CITY="name: '$CITY', latitude: $LATITUDE, longitude: $LONGITUDE, radius: 3, fillKey: 'city'"

if [ "$#" -gt 4 ]; then
    DATE="$5"
    NEW_CITY="${NEW_CITY}, date: '$DATE'"
fi

INSERT_LINE="        {${NEW_CITY}},\n"

sed -i -E "s/(\s+\])/$INSERT_LINE\1/" $FILE
