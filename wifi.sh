#!/usr/bin/env bash

# echo "Wifi: $(nmcli -t -f active,ssid dev wifi | egrep '^yes' | cut -d\' -f2)"
nmcli dev wifi list

read -p "Enter an ssid to connect to: " ssid

security=$(nmcli -f ssid,security dev wifi list | grep "$ssid" | awk '{print $2}')

if [ "$security" == "none" ]; then
    nmcli dev wifi connect "$ssid"
else
    read -s -p "Enter password: " password
    echo
    nmcli dev wifi connect "$ssid" password "$password"
fi
