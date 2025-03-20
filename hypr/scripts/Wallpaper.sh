#!/bin/bash

WALLPAPER_DIR="$HOME/Wallpapers"
WALLPAPER_LIST="$HOME/.wallpaper_list"
LAST_USED_FILE="$HOME/.last_wallpaper"

# **Regenerate the wallpaper list every time to include new & remove deleted wallpapers**
find "$WALLPAPER_DIR" -type f | sort > "$WALLPAPER_LIST"

# Read the last used wallpaper
if [ -f "$LAST_USED_FILE" ]; then
    LAST_USED=$(cat "$LAST_USED_FILE")
else
    LAST_USED=""
fi

# **Ensure last wallpaper exists, otherwise reset it**
if [ -n "$LAST_USED" ] && ! grep -Fxq "$LAST_USED" "$WALLPAPER_LIST"; then
    LAST_USED=""
fi

# Get the next and next-next wallpaper
NEXT_WALLPAPER=""
NEXT_NEXT_WALLPAPER=""
FOUND_LAST=0

while IFS= read -r line; do
    if [ $FOUND_LAST -eq 1 ]; then
        if [ -z "$NEXT_WALLPAPER" ]; then
            NEXT_WALLPAPER="$line"
        else
            NEXT_NEXT_WALLPAPER="$line"
            break
        fi
    fi
    if [ "$line" = "$LAST_USED" ]; then
        FOUND_LAST=1
    fi
done < "$WALLPAPER_LIST"

# If no next wallpaper is found, restart from the first one
if [ -z "$NEXT_WALLPAPER" ]; then
    NEXT_WALLPAPER=$(head -n 1 "$WALLPAPER_LIST")
fi

# If no "next-next" wallpaper is found, restart from the first one
if [ -z "$NEXT_NEXT_WALLPAPER" ]; then
    NEXT_NEXT_WALLPAPER=$(head -n 1 "$WALLPAPER_LIST")
fi

# **Apply the next wallpaper**
hyprctl hyprpaper unload "$LAST_USED"
hyprctl hyprpaper preload "$NEXT_WALLPAPER"
hyprctl hyprpaper wallpaper "eDP-1,$NEXT_WALLPAPER"
hyprctl hyprpaper reload

# **Preload the wallpaper after the next one**
hyprctl hyprpaper preload "$NEXT_NEXT_WALLPAPER"

# Apply colors with `wal`
wal -i "$NEXT_WALLPAPER"
pywalfox update
# Save the current wallpaper for the next cycle
echo "$NEXT_WALLPAPER" > "$LAST_USED_FILE"

