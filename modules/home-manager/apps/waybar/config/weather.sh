#!/usr/bin/env bash

# Simple weather script using wttr.in
weather=$(curl -s "wttr.in/?format=%l:+%c+%t" 2>/dev/null)

if [[ -n $weather ]]; then
  # Extract icon and temp from "City: icon temp" format
  after_colon=$(echo "$weather" | sed 's/^.*: //')
  weather_icon=$(echo "$after_colon" | awk '{print $1}')
  weather_temp=$(echo "$after_colon" | awk '{print $2}')
  printf '{"text":"%s %s","tooltip":"%s"}\n' "$weather_icon" "$weather_temp" "$weather"
else
  printf '{"text":"","class":"unavailable"}\n'
fi
