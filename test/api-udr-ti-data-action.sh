#!/bin/bash

##########################
#
# usage:
# ./api-udr-ti-data-action.sh <action> [json-file]
#
# e.g. ./api-udr-ti-data-action.sh put ti-data-full.json
# JSON files are resolved under test/json; the default is ti-data.json.
#
##########################

set -e
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TI_DATA_JSON="$SCRIPT_DIR/json/${2:-ti-data.json}"

# ti data request
case "$1" in
    "put")
        curl -sS --fail-with-body --connect-timeout 5 --max-time 20 \
            -X PUT -H "Content-Type: application/json" --data-binary @"$TI_DATA_JSON" \
            http://udr.free5gc.org:8000/nudr-dr/v2/application-data/influenceData/1
        ;;
    "get")
        curl -X GET -H "Content-Type: application/json" \
            http://udr.free5gc.org:8000/nudr-dr/v2/application-data/influenceData
        ;;
    "delete")
        curl -X DELETE -H "Content-Type: application/json" \
            http://udr.free5gc.org:8000/nudr-dr/v2/application-data/influenceData/1
        ;;
    *)
        echo "error: invalid parameter"
        echo "usage: $0 [put|get|delete] [json-file]"
        exit 1
        ;;
esac
