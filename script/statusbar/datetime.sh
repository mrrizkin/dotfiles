#!/bin/bash

# DateTime script with clickable calendar
# Colors: Catppuccin Mocha
TIME_COLOR="#89b4fa" # Blue
DATE_COLOR="#cdd6f4" # Text
ICON_COLOR="#f5c2e7" # Pink

# Get current time and date
TIME=$(date '+%I:%M %p')
WEEKDAY=$(date '+%A')
DATE=$(date '+%d %B %Y')

# Remove leading zero from hour
TIME=$(echo "$TIME" | sed 's/^0//')

# Handle click events (dwm button clicks)
case $BLOCK_BUTTON in
1) # Left click - Open calendar
  if command -v gsimplecal >/dev/null 2>&1; then
    gsimplecal &
  elif command -v zenity >/dev/null 2>&1; then
    zenity --calendar --title="Calendar" --text="$(date '+%B %Y')" &
  elif command -v yad >/dev/null 2>&1; then
    yad --calendar --title="Calendar" &
  else
    # Fallback: create a simple calendar notification
    notify-send "$(date '+%B %Y')" "$(cal)" -t 5000
  fi
  ;;
2) # Middle click - Show date info
  notify-send "Date Info" "$(date '+%A, %B %d, %Y%n%Z %z%nWeek %V of %Y')" -t 3000
  ;;
3) # Right click - Show time zones
  notify-send "Time Zones" "$(
    date '+Local: %H:%M %Z%nUTC: '
    date -u '+%H:%M UTC'
  )" -t 3000
  ;;
esac

# Output formatted string
echo " $TIME $WEEKDAY, $DATE"
