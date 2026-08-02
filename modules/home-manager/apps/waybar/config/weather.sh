#!/usr/bin/env bash

# Simple weather script using wttr.in
weather=$(curl -s "wttr.in/?format=%c+%t" 2>/dev/null)

if [[ -n $weather ]]; then
  weather_icon=$(echo "$weather" | awk '{print $1}')
  printf '{"text":"%s","tooltip":"%s"}\n' "$weather_icon" "$weather"
else
  printf '{"text":"","class":"unavailable"}\n'
fi
