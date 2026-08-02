#!/usr/bin/env bash

# Simple weather script using wttr.in
weather=$(curl -s "wttr.in/?format=%c+%t" 2>/dev/null)

if [[ -n $weather ]]; then
  weather_icon=$(echo "$weather" | awk '{print $1}')
  weather_temp=$(echo "$weather" | awk '{print $2}')
  printf '{"text":"%s %s","tooltip":"%s"}\n' "$weather_icon" "$weather_temp" "$weather"
else
  printf '{"text":"","class":"unavailable"}\n'
fi
