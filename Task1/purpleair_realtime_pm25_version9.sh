#!/bin/bash

# -------------------------------------------------------------------------
# PurpleAir – Cron-Ready Multi-Sensor Script
# -------------------------------------------------------------------------

# SET ABSOLUTE PATHS FOR CRON (Required for WSL/Linux)
# Use 'which jq' or 'which curl' to verify these paths on your system
JQ_CMD="/usr/bin/jq"
CURL_CMD="/usr/bin/curl"
DATE_CMD="/usr/bin/date"

# CONFIGURATION
API_KEY="8F6761C3-E821-11F0-B596-4201AC1DC123"
BASE_DIR="/mnt/c/Users/yagye/OneDrive/Documents/purpleair_data"
mkdir -p "$BASE_DIR"

# Generate Date/Log info using absolute paths
CURRENT_DATE=$($DATE_CMD +%Y%m%d)
LOG_FILE="$BASE_DIR/purpleair.log"

# 3. USER INPUT HANDLING
# Note: When using cron, indices are passed in the crontab line
if [ "$#" -lt 1 ]; then
    echo "$($DATE_CMD) No sensor indices provided." >> "$LOG_FILE"
    exit 1
fi

# LOOP THROUGH SENSORS
for SENSOR_INDEX in "$@"; do

    API_URL="https://api.purpleair.com/v1/sensors/${SENSOR_INDEX}"
    CSV_CURATED="$BASE_DIR/purpleair_${SENSOR_INDEX}_${CURRENT_DATE}.csv"
    CSV_FLAT="$BASE_DIR/purpleair_${SENSOR_INDEX}_${CURRENT_DATE}_FULL.csv"

    # API REQUEST
    JSON=$($CURL_CMD -s -X GET "$API_URL" \
      -H "X-API-Key: $API_KEY" \
      -H "Accept: application/json")

    if [ -z "$JSON" ] || [ "$JSON" == "null" ]; then
        echo "$($DATE_CMD) Empty API response for sensor $SENSOR_INDEX" >> "$LOG_FILE"
        continue
    fi

    # CURATED PARSING (Using absolute JQ)
    SENSOR_NAME=$(echo "$JSON" | "$JQ_CMD" -r '.sensor.name // "Unknown"')
    PM25_10MIN=$(echo "$JSON" | "$JQ_CMD" '.sensor.stats["pm2.5_10minute"] // "null"')
    PM25_NOW=$(echo "$JSON" | "$JQ_CMD" '.sensor."pm2.5" // "null"')
    PM10_NOW=$(echo "$JSON" | "$JQ_CMD" '.sensor."pm10.0" // "null"')
    TEMP=$(echo "$JSON" | "$JQ_CMD" '.sensor.temperature // "null"')
    HUMIDITY=$(echo "$JSON" | "$JQ_CMD" '.sensor.humidity // "null"')
    PRESSURE=$(echo "$JSON" | "$JQ_CMD" '.sensor.pressure // "null"')
    VOC=$(echo "$JSON" | "$JQ_CMD" '.sensor.voc // "null"')
    LAT=$(echo "$JSON" | "$JQ_CMD" '.sensor.latitude // "null"')
    LON=$(echo "$JSON" | "$JQ_CMD" '.sensor.longitude // "null"')

    # WRITE CURATED CSV
    if [ ! -f "$CSV_CURATED" ]; then
        echo "timestamp,sensor_name,sensor_index,lat,lon,pm2_5_10min,pm2_5_now,pm10_0_now,temp_f,humidity_pct,pressure_mb,voc" > "$CSV_CURATED"
    fi

    echo "$($DATE_CMD),$SENSOR_NAME,$SENSOR_INDEX,$LAT,$LON,$PM25_10MIN,$PM25_NOW,$PM10_NOW,$TEMP,$HUMIDITY,$PRESSURE,$VOC" >> "$CSV_CURATED"

	# ---------------------------
    # FULL JSON → FLATTENED CSV
    # ---------------------------
    if [ ! -f "$CSV_FLAT" ]; then
        # Generate Header and first data row
        echo "$JSON" | "$JQ_CMD" -r '
            [ paths(scalars) as $path 
              | { ($path | if .[0] == "sensor" then .[1:] else . end | join(".")): getpath($path) } 
            ] | add as $flat
            | ($flat | keys_unsorted) as $keys
            | ($keys | @csv), ([$flat[$keys[]]] | @csv)
        ' > "$CSV_FLAT"
    else
        # Append only the data row
        echo "$JSON" | "$JQ_CMD" -r '
            [ paths(scalars) as $path 
              | { ($path | if .[0] == "sensor" then .[1:] else . end | join(".")): getpath($path) } 
            ] | add as $flat
            | ($flat | keys_unsorted) as $keys
            | ([$flat[$keys[]]] | @csv)
        ' >> "$CSV_FLAT"
    fi

    echo "$($DATE_CMD) Data appended for $SENSOR_NAME ($SENSOR_INDEX)" >> "$LOG_FILE"
done