i=0
ssid_list=$(nmcli -t -f SSID device wifi list | grep -v '^$' | sort -u )
declare -a available_ssid
# echo "$ssid_list"
while read ssid
do
    # echo "$ssid"
    available_ssid[i]="$ssid"
    # echo "$available_ssid[i]"
    ((i++))
    echo "LINE: '${ssid}'"
done <<< "$ssid_list"

# for ssid in "${available_ssid[@]}"
# do
#    echo "$ssid"
# done
selected_entry=$(printf "%s\n" "${ssid_list[@]}" | wofi --dmenu --prompt "Select Wi-Fi" --location=3 --y=30)
echo "$selected_entry"