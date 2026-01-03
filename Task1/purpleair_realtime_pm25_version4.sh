#!/bin/bash

# -----------------------------------------
# PurpleAir PM2.5 – Daily Aggregation Script
# -----------------------------------------

API_KEY="8F6761C3-E821-11F0-B596-4201AC1DC123"  # API key generated at PurpleAir site
SENSOR_INDEX="211511" 							# Refers to Woolf Hall Sensor, Arlington
API_URL="https://api.purpleair.com/v1/sensors/${SENSOR_INDEX}"

BASE_DIR="/mnt/c/Users/yagye/OneDrive/Documents/purpleair_data" # Change as per use
mkdir -p "$BASE_DIR"

DATE=$(date +%Y%m%d)
CSV_FILE="$BASE_DIR/purpleair_${SENSOR_INDEX}_${DATE}.csv"
LOG_FILE="$BASE_DIR/purpleair.log"

# API REQUEST
JSON=$(curl -s -X GET "$API_URL" \
  -H "X-API-Key: $API_KEY" \
  -H "Accept: application/json")

if [ -z "$JSON" ]; then
    echo "$(date) Empty API response" >> "$LOG_FILE"
    exit 1
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

# Validation check
if [ "$PM25_10MIN" = "null" ]; then
    echo "$(date) Critical data (PM2.5) missing from API response" >> "$LOG_FILE"
    exit 1
fi

# WRITE HEADER IF FILE DOES NOT EXIST
if [ ! -f "$CSV_FILE" ]; then
    echo "timestamp,sensor_name,sensor_index,lat,lon,pm2_5_10min,pm2_5_now,pm10_0_now,temp_f,humidity_pct,pressure_mb,voc" > "$CSV_FILE"
fi

# ---- APPEND ROW ----
echo "$(date),$SENSOR_NAME,$SENSOR_INDEX,$LAT,$LON,$PM25_10MIN,$PM25_NOW,$PM10_0_NOW,$TEMP,$HUMIDITY,$PRESSURE,$VOC" >> "$CSV_FILE"

echo "$(date) Row appended to $CSV_FILE (Sensor: $SENSOR_NAME)" >> "$LOG_FILE"
