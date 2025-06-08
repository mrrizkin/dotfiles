#!/bin/bash

# Cloudflare WARP status monitor
# Colors: Catppuccin Mocha
CONNECTED_COLOR="#a6e3a1"    # Green
CONNECTING_COLOR="#f9e2af"   # Yellow
DISCONNECTED_COLOR="#6c7086" # Gray
ERROR_COLOR="#f38ba8"        # Red
WARP_PLUS_COLOR="#89b4fa"    # Blue

# Check if warp-cli is installed
if ! command -v warp-cli >/dev/null 2>&1; then
  echo ""
  exit 0
fi

# Get WARP status
STATUS_OUTPUT=$(warp-cli status 2>/dev/null)
if [ $? -ne 0 ]; then
  echo " Not Running"
  exit 0
fi

REGISTRATION_STATUS=$(warp-cli registration show 2>/dev/null)
if [ $? -ne 0 ]; then
  echo " Not Running"
  exit 0
fi

# Parse status
STATUS=$(echo "$STATUS_OUTPUT" | grep "Status update:" | awk '{print $3}')
ACCOUNT_TYPE=$(echo "$REGISTRATION_STATUS" | grep "Account type:" | awk '{print $3}')

# Determine icon and text based on status
case "$STATUS" in
"Connected")
  if [ "$ACCOUNT_TYPE" = "WARP+" ]; then
    ICON="󰅠"
    TEXT="WARP+"
    COLOR="$WARP_PLUS_COLOR"
  else
    ICON="󱇱"
    TEXT="WARP"
    COLOR="$CONNECTED_COLOR"
  fi
  ;;
"Connecting")
  ICON="󰔪"
  TEXT="Connecting"
  COLOR="$CONNECTING_COLOR"
  ;;
"Disconnected")
  ICON="󰧠"
  TEXT="Off"
  COLOR="$DISCONNECTED_COLOR"
  ;;
*)
  ICON=""
  TEXT="Unknown"
  COLOR="$ERROR_COLOR"
  ;;
esac

# Handle click events
case $BLOCK_BUTTON in
1) # Left click - Toggle WARP connection
  if [ "$STATUS" = "Connected" ]; then
    warp-cli disconnect >/dev/null 2>&1
    notify-send "WARP" "Disconnecting..." -t 2000
  else
    warp-cli connect >/dev/null 2>&1
    notify-send "WARP" "Connecting..." -t 2000
  fi
  # Force update dwmblocks after toggle
  pkill -RTMIN+10 dwmblocks 2>/dev/null
  ;;
2) # Middle click - Show detailed status
  DETAILED_STATUS=$(warp-cli status 2>/dev/null)
  notify-send "WARP Status" "$DETAILED_STATUS" -t 5000
  ;;
3) # Right click - WARP settings menu
  OPTIONS=" Connect\n Disconnect\n Settings\n Registration"
  CHOICE=$(echo -e "$OPTIONS" | rofi -dmenu -i -p "  WARP" \
    -theme ~/.config/rofi/catppuccin-mocha.rasi \
    -no-custom -format "s" -window-title "WARP Menu")

  case "$CHOICE" in
  " Connect")
    warp-cli connect >/dev/null 2>&1
    notify-send "WARP" "Connecting..." -t 2000
    ;;
  " Disconnect")
    warp-cli disconnect >/dev/null 2>&1
    notify-send "WARP" "Disconnecting..." -t 2000
    ;;
  " Settings")
    SETTINGS=$(warp-cli settings 2>/dev/null)
    notify-send "WARP Settings" "$SETTINGS" -t 6000
    ;;
  " Registration")
    REG_INFO=$(warp-cli registration show 2>/dev/null)
    notify-send "WARP Registration" "$REG_INFO" -t 6000
    ;;
  esac
  # Force update after any action
  pkill -RTMIN+10 dwmblocks 2>/dev/null
  ;;
esac

# Output formatted string
echo "$ICON $TEXT"
