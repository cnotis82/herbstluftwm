#!/bin/bash
# Based on http://openweathermap.org/current

API_KEY="f35dbde3a568267aa14b89a30f45a290"

# Check on http://openweathermap.org/find
CITY_ID="264371"

URGENT_LOWER=0
URGENT_HIGHER=30

ICON_SUNNY=""
ICON_CLOUDY=""
ICON_RAINY=""
ICON_STORM=""
ICON_SNOW=""
ICON_FOG=""

SYMBOL_CELSIUS="℃"

WEATHER_URL="http://api.openweathermap.org/data/2.5/weather?id=${CITY_ID}&appid=${API_KEY}&units=metric"


WEATHER_INFO=$(wget -qO- "${WEATHER_URL}")

WEATHER_MAIN=$(echo "${WEATHER_INFO}" | grep -o -e '\"main\":\"[A-Z][a-z]*\"' | awk -F ':' '{print $2}' | tr -d '"')
WEATHER_TEMP=$(echo "${WEATHER_INFO}" | grep -o -e '\"temp\":\-\?[0-9]*' | awk -F ':' '{print $2}' | tr -d '"')

if [[ "${WEATHER_MAIN}" = *Snow* ]]; then
  echo "${ICON_SNOW} ${WEATHER_MAIN}, ${WEATHER_TEMP}${SYMBOL_CELSIUS}"
  echo "${ICON_SNOW} ${WEATHER_MAIN}, ${WEATHER_TEMP}${SYMBOL_CELSIUS}"
elif [[ "${WEATHER_MAIN}" = *Rain* ]] || [[ "${WEATHER_MAIN}" = *Drizzle* ]]; then
  echo "${ICON_RAINY} ${WEATHER_MAIN}, ${WEATHER_TEMP}${SYMBOL_CELSIUS}"
  echo "${ICON_RAINY} ${WEATHER_MAIN}, ${WEATHER_TEMP}${SYMBOL_CELSIUS}"
elif [[ "${WEATHER_MAIN}" = *Clouds* ]]; then
  echo "${ICON_CLOUDY} ${WEATHER_MAIN}, ${WEATHER_TEMP}${SYMBOL_CELSIUS}"
  echo "${ICON_CLOUDY} ${WEATHER_MAIN}, ${WEATHER_TEMP}${SYMBOL_CELSIUS}"
elif [[ "${WEATHER_MAIN}" = *Clear* ]]; then
  echo "${ICON_SUNNY} ${WEATHER_MAIN}, ${WEATHER_TEMP}${SYMBOL_CELSIUS}"
  echo "${ICON_SUNNY} ${WEATHER_MAIN}, ${WEATHER_TEMP}${SYMBOL_CELSIUS}"
elif [[ "${WEATHER_MAIN}" = *Fog* ]] || [[ "${WEATHER_MAIN}" = *Mist* ]]; then
  echo "${ICON_FOG} ${WEATHER_MAIN}, ${WEATHER_TEMP}${SYMBOL_CELSIUS}"
  echo "${ICON_FOG} ${WEATHER_MAIN}, ${WEATHER_TEMP}${SYMBOL_CELSIUS}"
elif [[ "${WEATHER_MAIN}" = *Thunderstorm* ]]; then
  echo "${ICON_STORM} ${WEATHER_MAIN}, ${WEATHER_TEMP}${SYMBOL_CELSIUS}"
  echo "${ICON_STORM} ${WEATHER_MAIN}, ${WEATHER_TEMP}${SYMBOL_CELSIUS}"
else
  echo "${WEATHER_MAIN} ${WEATHER_TEMP}${SYMBOL_CELSIUS}"
  echo "${WEATHER_MAIN} ${WEATHER_TEMP}${SYMBOL_CELSIUS}"
fi

if [[ "${WEATHER_TEMP}" -lt "${URGENT_LOWER}" ]] || [[ "${WEATHER_TEMP}" -gt "${URGENT_HIGHER}" ]]; then
  echo "#FF0000";
fi
notify-send "${WEATHER_MAIN} ${WEATHER_TEMP} ${SYMBOL_CELSIUS}"
exit 0;
