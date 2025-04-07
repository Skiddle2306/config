i=0
dir=/home/Ayush/Wallpapers/
for wallpaper in /home/Ayush/Wallpapers/*
do
  available_wallpaper[i]="${wallpaper:23}"
  ((i++))
done
((i--))
j=$(shuf -i 0-$i -n 1)
echo $j
dir=/home/Ayush/Wallpapers/
theme=${available_wallpaper[j]}
echo "$dir$theme"
wal -i "$dir$theme"
hyprctl hyprpaper reload "eDP-1,$dir$theme"
pywalfox update
