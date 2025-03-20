#!/bin/bash

# Check if a network is already connected
current_ssid=$(nmcli -t -f ACTIVE,SSID dev wifi | grep '^yes' | cut -d: -f2)

if [ -n "$current_ssid" ]; then
    choice=$(echo -e "Disconnect\nChange Network" | wofi --dmenu --prompt "Connected to: $current_ssid")

    if [[ "$choice" == "Disconnect" ]]; then
        nmcli c down "$current_ssid"
        notify-send "Disconnected from $current_ssid"
        exit 0
    elif [[ "$choice" != "Change Network" ]]; then
        exit 0
    fi
fi

# Get list of saved Wi-Fi networks that have successfully connected before
mapfile -t saved_ssids < <(nmcli -t -f NAME connection show --active | sort -u)

# Get available Wi-Fi networks
mapfile -t available_ssids < <(nmcli -t -f SSID device wifi list | grep -v '^$' | sort -u)

# Combine saved and available networks, ensuring no duplicates
ssid_list=()
for ssid in "${saved_ssids[@]}"; do
    if [[ ! " ${ssid_list[*]} " =~ " $ssid " ]]; then
        ssid_list+=("$ssid (Saved)")
    fi
done
for ssid in "${available_ssids[@]}"; do
    if [[ ! " ${ssid_list[*]} " =~ " $ssid " ]]; then
        ssid_list+=("$ssid")
    fi
done

# Check if there are any networks to display
if [ ${#ssid_list[@]} -eq 0 ]; then
    notify-send "No Wi-Fi networks found."
    exit 1
fi

# Show menu with saved networks first using wofi
selected_entry=$(printf "%s\n" "${ssid_list[@]}" | wofi --dmenu --prompt "Select Wi-Fi" --location=3 --y=30)

# Extract the actual SSID (remove "(Saved)" label)
selected_ssid="${selected_entry// (Saved)/}"

if [ -n "$selected_ssid" ]; then
    # Check if the SSID is actually saved with valid credentials
    if [[ "$selected_entry" == *"(Saved)"* ]]; then
        # Try connecting automatically
        nmcli connection up "$selected_ssid"

        # Check if connection was successful
        if nmcli -t -f ACTIVE,SSID dev wifi | grep -q "^yes:$selected_ssid$"; then
            notify-send "Connected to $selected_ssid"
            exit 0
        else
            notify-send "Connection failed. Trying again..."
        fi
    fi

    # If no saved connection or failed attempt, ask for password
    while true; do
        wifi_password=$(wofi --dmenu --password --prompt "Enter Wi-Fi Password for $selected_ssid")

        if [ -z "$wifi_password" ]; then
            notify-send "Connection cancelled."
            exit 1
        fi

        # Try connecting with password
        nmcli device wifi connect "$selected_ssid" password "$wifi_password"

        # Check if connection was successful
        if nmcli -t -f ACTIVE,SSID dev wifi | grep -q "^yes:$selected_ssid$"; then
            notify-send "Connected to $selected_ssid"
            exit 0
        else
            notify-send "Connection failed. Incorrect password?"
        fi
    done
fi
