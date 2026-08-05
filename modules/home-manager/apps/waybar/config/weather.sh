#!/usr/bin/env bash

weather=$(curl -s "wttr.in/?format=%C+%t" 2>/dev/null)

if [[ -n $weather ]]; then
  weather_temp=$(echo "$weather" | awk '{print $NF}')
  weather_condition=$(echo "$weather" | sed "s/ $weather_temp$//")

  case "$weather_condition" in
    "Sunny"|"Clear") icon="󰖙" ;;  # weather_sunny
    "Partly cloudy") icon="󰖖" ;;  # weather_partly_cloudy
    "Cloudy"|"Overcast") icon="󰖐" ;;  # weather_cloudy
    "Mist"|"Fog"|"Freezing fog") icon="󰖓" ;;  # weather_fog
    "Patchy rain nearby"|"Patchy rain possible") icon="󰖗" ;;  # weather_rainy
    "Light rain"|"Patchy light rain"|"Light rain shower"|"Moderate rain at times"|"Light drizzle"|"Patchy light drizzle") icon="󰖗" ;;
    "Moderate rain"|"Heavy rain"|"Heavy rain at times"|"Moderate or heavy rain shower"|"Torrential rain shower") icon="󰖗" ;;
    "Thunderstorm"|"Moderate or heavy rain with thunder"|"Patchy light rain with thunder"|"Thundery outbreaks in nearby") icon="󰖘" ;;  # weather_lightning_rainy
    "Light snow"|"Moderate snow"|"Heavy snow"|"Blizzard"|"Blowing snow"|"Patchy snow nearby"|"Light snow showers"|"Moderate or heavy snow showers") icon="󰖕" ;;  # weather_snowy
    "Light sleet"|"Moderate or heavy sleet"|"Patchy sleet nearby"|"Ice pellets"|"Light sleet showers"|"Moderate or heavy sleet showers") icon="󰖔" ;;  # weather_snowy_rainy
    "Hail"|"Moderate or heavy hail") icon="󰖒" ;;  # weather_hail
    "Light freezing rain"|"Moderate or heavy freezing rain") icon="󰖔" ;;
    *) icon="" ;;
  esac

  if [[ -n $icon ]]; then
    text="$icon $weather_temp"
  else
    text="$weather_temp"
  fi
  printf '{"text":"%s","tooltip":"%s"}\n' "$text" "$weather_condition $weather_temp"
else
  printf '{"text":"","class":"unavailable"}\n'
fi
