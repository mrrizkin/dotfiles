#!/bin/bash

# Fan info script for dwmblocks - ThinkPad T480s
# Place this script in your dwmblocks scripts directory
# Make it executable: chmod +x fan_info.sh
#
# Supports click actions via $BLOCK_BUTTON:
# Left click (1): Toggle display mode
# Middle click (2): Open detailed system monitor
# Right click (3): Show fan control menu
#
# Uses Nerd Font icons:
#  (nf-md-fan) - Fan icon
#  (nf-md-thermometer) - Temperature icon  
#  (nf-md-flash) - Speed/power icon
#  (nf-fa-tachometer_alt) - Alternative speed icon

get_fan_info() {
    local fan_file="/proc/acpi/ibm/fan"
    local temp_file="/proc/acpi/ibm/thermal"
    
    # Check if files exist
    if [[ ! -r "$fan_file" ]] || [[ ! -r "$temp_file" ]]; then
        echo "N/A"
        return 1
    fi
    
    # Get fan speed and level
    local fan_speed=$(grep "speed:" "$fan_file" | awk '{print $2}')
    local fan_level=$(grep "level:" "$fan_file" | awk '{print $2}')
    
    # Get CPU temperature (first sensor from thermal)
    local cpu_temp=$(grep "temperatures:" "$temp_file" | awk '{print $2}')
    
    # Format output based on preferences
    case "${1:-default}" in
        "minimal")
            # Just fan level and temp: "L6 42°"
            echo "L${fan_level} ${cpu_temp}°"
            ;;
        "compact")
            # Level, temp, RPM: "L6 42° 5000"
            echo "L${fan_level} ${cpu_temp}° ${fan_speed}"
            ;;
        "full")
            # Full info with nerd font icons: " L6  42°  5000"
            echo " L${fan_level} 󰔏 ${cpu_temp}° 󰈐 ${fan_speed}"
            ;;
        "full-alt")
            # Alternative icons: " L6  42°  5000"
            echo " L${fan_level} 󰔏 ${cpu_temp}° 󰈐 ${fan_speed}"
            ;;
        "icons-only")
            # Just icons with values: " 42°  5000"
            echo "󰔏 ${cpu_temp}° 󰈐 ${fan_speed}"
            ;;
        "temp-only")
            # Just temperature with icon: " 42°"
            echo "󰔏 ${cpu_temp}°"
            ;;
        "rpm-only")
            # Just RPM with icon: " 5000"
            echo "󰈐 ${fan_speed}"
            ;;
        "level-only")
            # Just fan level with icon: " L6"
            echo " L${fan_level}"
            ;;
        *)
            # Default: Level and temperature
            echo "Fan L${fan_level} ${cpu_temp}°C"
            ;;
    esac
}

# Color coding based on temperature (optional)
get_fan_info_colored() {
    local info=$(get_fan_info "$1")
    local temp_file="/proc/acpi/ibm/thermal"
    
    if [[ -r "$temp_file" ]]; then
        local cpu_temp=$(grep "temperatures:" "$temp_file" | awk '{print $2}')
        
        # Color codes for dwmblocks (modify based on your setup)
        if [[ $cpu_temp -lt 50 ]]; then
            echo "^c#50fa7b^$info^d^"  # Green - cool
        elif [[ $cpu_temp -lt 65 ]]; then
            echo "^c#f1fa8c^$info^d^"  # Yellow - warm
        elif [[ $cpu_temp -lt 80 ]]; then
            echo "^c#ffb86c^$info^d^"  # Orange - hot
        else
            echo "^c#ff5555^$info^d^"  # Red - very hot
        fi
    else
        echo "$info"
    fi
}

# Multi-sensor version (shows max temp from multiple sources)
get_detailed_fan_info() {
    local fan_file="/proc/acpi/ibm/fan"
    
    if [[ ! -r "$fan_file" ]]; then
        echo "N/A"
        return 1
    fi
    
    # Get fan info
    local fan_speed=$(grep "speed:" "$fan_file" | awk '{print $2}')
    local fan_level=$(grep "level:" "$fan_file" | awk '{print $2}')
    
    # Get temperatures from multiple sources
    local cpu_temp=0
    local max_temp=0
    
    # ThinkPad ACPI thermal
    if [[ -r "/proc/acpi/ibm/thermal" ]]; then
        cpu_temp=$(grep "temperatures:" "/proc/acpi/ibm/thermal" | awk '{print $2}')
        [[ $cpu_temp -gt $max_temp ]] && max_temp=$cpu_temp
    fi
    
    # CoreTemp sensors
    if [[ -d "/sys/class/hwmon/hwmon9" ]]; then
        for temp_file in /sys/class/hwmon/hwmon9/temp*_input; do
            if [[ -r "$temp_file" ]]; then
                local temp=$(($(cat "$temp_file") / 1000))
                [[ $temp -gt $max_temp ]] && max_temp=$temp
            fi
        done
    fi
    
    # Format output
    case "${1:-default}" in
        "detailed")
            echo " L${fan_level}  ${max_temp}°  ${fan_speed}rpm"
            ;;
        *)
            echo "L${fan_level} ${max_temp}°"
            ;;
    esac
}

# Click handling functions
handle_left_click() {
    # Cycle through display modes
    local state_file="/tmp/fan_dwmblock_state"
    local current_mode="minimal"
    
    if [[ -r "$state_file" ]]; then
        current_mode=$(cat "$state_file")
    fi
    
    case "$current_mode" in
        "minimal") echo "compact" > "$state_file" ;;
        "compact") echo "full" > "$state_file" ;;
        "full") echo "full-alt" > "$state_file" ;;
        "full-alt") echo "icons-only" > "$state_file" ;;
        "icons-only") echo "temp-only" > "$state_file" ;;
        "temp-only") echo "rpm-only" > "$state_file" ;;
        "rpm-only") echo "level-only" > "$state_file" ;;
        "level-only") echo "minimal" > "$state_file" ;;
        *) echo "minimal" > "$state_file" ;;
    esac
    
    # Refresh dwmblocks
    pkill -RTMIN+10 dwmblocks
}

handle_middle_click() {
    # Open detailed system monitor (choose your preferred tool)
    if command -v btop >/dev/null 2>&1; then
        setsid -f "$TERMINAL" -e btop
    elif command -v htop >/dev/null 2>&1; then
        setsid -f "$TERMINAL" -e htop
    elif command -v top >/dev/null 2>&1; then
        setsid -f "$TERMINAL" -e top
    else
        # Fallback: show detailed fan info in terminal
        setsid -f "$TERMINAL" -e bash -c "
            echo 'ThinkPad T480s Fan Information:'
            echo '================================'
            cat /proc/acpi/ibm/fan
            echo
            echo 'Thermal Information:'
            cat /proc/acpi/ibm/thermal
            echo
            echo 'Hardware Sensors:'
            sensors 2>/dev/null || echo 'sensors command not available'
            echo
            echo 'Press any key to close...'
            read -n 1
        "
    fi
}

handle_right_click() {
    # Show fan control menu using dmenu/rofi
    local menu_cmd="dmenu -p 'Fan Control:'"
    
    # Use rofi if available (prettier)
    if command -v rofi >/dev/null 2>&1; then
        menu_cmd="rofi -dmenu -p 'Fan Control'"
    fi
    
    local choice=$(echo -e "Auto\nLevel 0 (Off)\nLevel 1 (Quiet)\nLevel 2 (Low)\nLevel 3 (Medium-Low)\nLevel 4 (Medium)\nLevel 5 (Medium-High)\nLevel 6 (High)\nLevel 7 (Max)\nFull Speed\nShow Details" | $menu_cmd)
    
    case "$choice" in
        "Auto")
            echo "level auto" | sudo tee /proc/acpi/ibm/fan >/dev/null
            notify-send "Fan Control" "Set to automatic mode"
            ;;
        "Level 0 (Off)")
            echo "level 0" | sudo tee /proc/acpi/ibm/fan >/dev/null
            notify-send "Fan Control" "Set to level 0 (off)"
            ;;
        "Level 1 (Quiet)")
            echo "level 1" | sudo tee /proc/acpi/ibm/fan >/dev/null
            notify-send "Fan Control" "Set to level 1 (quiet)"
            ;;
        "Level 2 (Low)")
            echo "level 2" | sudo tee /proc/acpi/ibm/fan >/dev/null
            notify-send "Fan Control" "Set to level 2 (low)"
            ;;
        "Level 3 (Medium-Low)")
            echo "level 3" | sudo tee /proc/acpi/ibm/fan >/dev/null
            notify-send "Fan Control" "Set to level 3 (medium-low)"
            ;;
        "Level 4 (Medium)")
            echo "level 4" | sudo tee /proc/acpi/ibm/fan >/dev/null
            notify-send "Fan Control" "Set to level 4 (medium)"
            ;;
        "Level 5 (Medium-High)")
            echo "level 5" | sudo tee /proc/acpi/ibm/fan >/dev/null
            notify-send "Fan Control" "Set to level 5 (medium-high)"
            ;;
        "Level 6 (High)")
            echo "level 6" | sudo tee /proc/acpi/ibm/fan >/dev/null
            notify-send "Fan Control" "Set to level 6 (high)"
            ;;
        "Level 7 (Max)")
            echo "level 7" | sudo tee /proc/acpi/ibm/fan >/dev/null
            notify-send "Fan Control" "Set to level 7 (maximum)"
            ;;
        "Full Speed")
            echo "level full-speed" | sudo tee /proc/acpi/ibm/fan >/dev/null
            notify-send "Fan Control" "Set to full speed (WARNING: Out of spec!)"
            ;;
        "Show Details")
            handle_middle_click
            ;;
    esac
    
    # Refresh dwmblocks after fan change
    sleep 1
    pkill -RTMIN+10 dwmblocks
}

get_current_display_mode() {
    local state_file="/tmp/fan_dwmblock_state"
    if [[ -r "$state_file" ]]; then
        cat "$state_file"
    else
        echo "minimal"
    fi
}

# Handle BLOCK_BUTTON clicks
if [[ -n "$BLOCK_BUTTON" ]]; then
    case "$BLOCK_BUTTON" in
        1) handle_left_click ;;
        2) handle_middle_click ;;
        3) handle_right_click ;;
    esac
    exit 0
fi

# Normal display logic
if [[ -n "$1" ]]; then
    # Command line argument provided
    case "$1" in
        "colored")
            get_fan_info_colored "${2:-default}"
            ;;
        "detailed")
            get_detailed_fan_info "detailed"
            ;;
        *)
            get_fan_info "$1"
            ;;
    esac
else
    # No argument - use stored display mode
    # local display_mode=$(get_current_display_mode)
    get_fan_info "$(get_current_display_mode)"
fi
