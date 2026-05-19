#!/bin/bash
set -e

set -a
source .env
set +a

TODAY=$(date +%F)

mkdir -p data/raw logs


FILE="data/raw/raw_footballflow_${TODAY}.json"

LOG_FILE="logs/fetch_${TODAY}.log"

echo "$(date)| SCRIPT STARTED" >> "$LOG_FILE"
if [ -f "$FILE" ] && [ $(stat -c%s "$FILE") -gt 100 ]; then 
    echo "$(date) | SKIPPED |FILE ALREADY EXISTS : $FILE" >> "$LOG_FILE"
    echo "SKIPPED"
    exit 0
fi
URL="${BASE_URL}/competitions/PL/matches?dateFrom=${TODAY}&dateTo=${TODAY}"

TEMP_FILE=$(mktemp)

HTTP_STATUS=$( curl -s \
    -H  "X-Auth-Token: $API_KEY" \
    -o  "$TEMP_FILE" \
    -w "%{http_code}" \
    "$URL")


if [ "$HTTP_STATUS" -eq 200 ] ; then

   mv "$TEMP_FILE" "$FILE"
   echo  "$(date) | SUCCESS |  HTTP $HTTP_STATUS  | SAVED TO $FILE" >> "$LOG_FILE"
else
    ERROR_MESSAGE=$( cat "$TEMP_FILE" )
    echo "$(date) | ERROR | HTTP $HTTP_STATUS | $ERROR_MESSAGE" >> "$LOG_FILE"
    rm  -f "$TEMP_FILE"
fi
