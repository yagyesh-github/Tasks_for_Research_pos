#!/bin/bash

# -----------------------------------------
# PurpleAir PM2.5 – Multi-Sensor Daily Aggregation Script
# -----------------------------------------

API_KEY="8F6761C3-E821-11F0-B596-4201AC1DC123"	# API key generated at PurpleAir site
BASE_DIR="/mnt/c/Users/yagye/OneDrive/Documents/purpleair_data"
mkdir -p "$BASE_DIR"

DATE=$(date +%Y%m%d)
LOG_FILE="$BASE_DIR/purpleair.log"

# -------------------------------
# Check user input
# -------------------------------
if [ "$#" -lt 1 ]; then
    echo "Usage: $0 SENSOR_INDEX [SENSOR_INDEX ...]"
    exit 1
fi

# -------------------------------
# Loop through sensors
# -------------------------------
for SENSOR_INDEX in "$@"; do

    API_URL="https://api.purpleair.com/v1/sensors/${SENSOR_INDEX}"
    CSV_FILE="$BASE_DIR/purpleair_${SENSOR_INDEX}_${DATE}.csv"

    # API REQUEST
    JSON=$(curl -s -X GET "$API_URL" \
      -H "X-API-Key: $API_KEY" \
      -H "Accept: application/json")

    if [ -z "$JSON" ]; then
        echo "$(date) Empty API response for sensor $SENSOR_INDEX" >> "$LOG_FILE"
        continue
    fi

    # PARSE DATA
    SENSOR_NAME=$(echo "$JSON" | jq -r '.sensor.name')
    PM25_10MIN=$(echo "$JSON" | jq '.sensor.stats["pm2.5_10minute"]')
    PM25_NOW=$(echo "$JSON" | jq '.sensor."pm2.5"')
    PM10_NOW=$(echo "$JSON" | jq '.sensor."pm10.0"')
    TEMP=$(echo "$JSON" | jq '.sensor.temperature')
    HUMIDITY=$(echo "$JSON" | jq '.sensor.humidity')
    PRESSURE=$(echo "$JSON" | jq '.sensor.pressure')
    VOC=$(echo "$JSON" | jq '.sensor.voc')
    LAT=$(echo "$JSON" | jq '.sensor.latitude')
    LON=$(echo "$JSON" | jq '.sensor.longitude')

    if [ "$PM25_10MIN" = "null" ]; then
        echo "$(date) PM2.5 missing for sensor $SENSOR_INDEX" >> "$LOG_FILE"
        continue
    fi

    # WRITE HEADER IF FILE DOES NOT EXIST
    if [ ! -f "$CSV_FILE" ]; then
        echo "timestamp,sensor_name,sensor_index,lat,lon,pm2_5_10min,pm2_5_now,pm10_0_now,temp_f,humidity_pct,pressure_mb,voc" > "$CSV_FILE"
    fi

    # APPEND ROW
    echo "$(date),$SENSOR_NAME,$SENSOR_INDEX,$LAT,$LON,$PM25_10MIN,$PM25_NOW,$PM10_NOW,$TEMP,$HUMIDITY,$PRESSURE,$VOC" >> "$CSV_FILE"

    echo "$(date) Data appended for sensor $SENSOR_INDEX ($SENSOR_NAME)" >> "$LOG_FILE"

done
