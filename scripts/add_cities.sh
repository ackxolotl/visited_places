#!/bin/sh
#
# Add cities to cities.js interactively

if [ "$#" -lt 1 ]; then
    echo "Usage: $0 cities-file" >&2
    exit 1
fi

if ! [ -f "$1" ]; then
    echo "$1 is not a file" >&2
    exit 1
fi

FILE="$1"
CITIES=$(grep -o 'city' $FILE | wc -l)

echo "Cities file contains $CITIES cities. Add more cities now .."

while true; do
    echo -n "City: "
    read CITY
    echo -n "Latitude: "
    read LATITUDE
    echo -n "Longitude: "
    read LONGITUDE
    echo -n "Date: "
    read DATE

    if grep -q $CITY $FILE; then
        echo -n "City already in cities file. Add anyway? [N/y]: "
        read ADD_CITY

        if [ "$ADD_CITY" != "y" ]; then
            continue
        fi
    fi

    NEW_CITY="name: '$CITY', latitude: $LATITUDE, longitude: $LONGITUDE, radius: 3, fillKey: 'city'"
    if [ ! -z "$DATE" ]; then
        NEW_CITY="${NEW_CITY}, date: '$DATE'"
    fi

    INSERT_LINE="        {${NEW_CITY}},\n"
    sed -i -E "s/(\s+\])/$INSERT_LINE\1/" $FILE

    CITIES_NOW=$(grep -o 'city' $FILE | wc -l)
    if [ $CITIES_NOW -eq $((CITIES+1)) ]; then
        echo "City successfully added. Add another city ..."
    else
        echo "City not added for unknown reasons :-/"
        exit 1
    fi

    CITIES=$CITIES_NOW
done
