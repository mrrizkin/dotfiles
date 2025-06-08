#!/bin/bash

# Battery script with color coding
# Colors: Catppuccin Mocha
FULL_COLOR="#a6e3a1"     # Green
GOOD_COLOR="#f9e2af"     # Yellow
LOW_COLOR="#f38ba8"      # Red
CHARGING_COLOR="#89b4fa" # Blue

# Find battery
BATTERY=$(ls /sys/class/power_supply/ | grep -E "BAT|bat" | head -n1)

if [ -z "$BATTERY" ]; then
  echo " AC"
  exit 0
fi

BATTERY_PATH="/sys/class/power_supply/$BATTERY"
CAPACITY=$(cat "$BATTERY_PATH/capacity" 2>/dev/null || echo "0")
STATUS=$(cat "$BATTERY_PATH/status" 2>/dev/null || echo "Unknown")

# Determine icon based on capacity
if [ "$CAPACITY" -ge 90 ]; then
  ICON="󰁹"
elif [ "$CAPACITY" -ge 75 ]; then
  ICON="󰂁"
elif [ "$CAPACITY" -ge 50 ]; then
  ICON="󰁿"
elif [ "$CAPACITY" -ge 25 ]; then
  ICON="󰁼"
else
  ICON="󰁺"
fi

# Determine color based on status and capacity
if [ "$STATUS" = "Charging" ] || [ "$STATUS" = "Full" ]; then
  if [ "$CAPACITY" -ge 95 ]; then
    COLOR="$FULL_COLOR"
    ICON="󰂅"
  else
    COLOR="$CHARGING_COLOR"
    if [ "$CAPACITY" -ge 90 ]; then
      ICON="󰂋"
    elif [ "$CAPACITY" -ge 75 ]; then
      ICON="󰂊"
    elif [ "$CAPACITY" -ge 50 ]; then
      ICON="󰂉"
    elif [ "$CAPACITY" -ge 25 ]; then
      ICON="󰂇"
    else
      ICON="󰢜"
    fi
  fi
elif [ "$CAPACITY" -ge 80 ]; then
  COLOR="$FULL_COLOR"
elif [ "$CAPACITY" -ge 30 ]; then
  COLOR="$GOOD_COLOR"
else
  COLOR="$LOW_COLOR"
fi

# Handle click events
case $BLOCK_BUTTON in
1) # Left click - Detailed battery info
  VOLTAGE=$(cat "$BATTERY_PATH/voltage_now" 2>/dev/null | awk '{print $1/1000000 "V"}' || echo "N/A")
  POWER=$(cat "$BATTERY_PATH/power_now" 2>/dev/null | awk '{print $1/1000000 "W"}' || echo "N/A")
  HEALTH=$(cat "$BATTERY_PATH/health" 2>/dev/null || echo "N/A")

  notify-send "Battery Details" \
    "Status: $STATUS
Capacity: $CAPACITY%
Voltage: $VOLTAGE
Power: $POWER
Health: $HEALTH" -t 4000
  ;;
3) # Right click - Power management
  rofi_launcher power &
  ;;
esac

# Output formatted string
echo "$ICON $CAPACITY%"
