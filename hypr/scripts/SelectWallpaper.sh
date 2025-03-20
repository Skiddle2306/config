# Set up trap to handle script exit
cleanup() {
    echo "Cleaning up..."
    exit 0
}
i=0
dir=/home/Ayush/Wallpapers/
for wallpaper in /home/Ayush/Wallpapers/*
do
  available_wallpaper[i]="${wallpaper:23}"
  ((i++))
done
# for wallpaper in "${available_wallpaper[@]}"
# do
#    echo "$wallpaper"
# done
theme=$(printf "%s\n" "${available_wallpaper[@]}" | wofi --dmenu --prompt "Select your Theme" --style ~/.config/wofi/style.css) 
if [[ -z "$theme" || $? -ne 0 ]]; then
    echo "No wallpaper selected. Exiting safely..."
    exit 1
fi
echo $theme
wal -i "$dir$theme"
hyprctl hyprpaper reload "eDP-1,$dir$theme"
pywalfox update
