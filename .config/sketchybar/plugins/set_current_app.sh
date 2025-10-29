active_color=0xffffffff
inactive_color=0x66ffffff

current_app_pid=$(osascript -e 'tell application "System Events" to get unix id of first process whose frontmost is true')
existing_items=$(sketchybar --query bar | jq -r '.items[]' | grep '^app\.')

for item in $existing_items; do
    if [ "$item" = "app.$current_app_pid" ]; then
        color=$active_color
        bg=0x66000000
    else
        color=$inactive_color
        bg=0x11000000
    fi

    sketchybar --animate sine 4 \
        --set "$item" \
        label.color="$color" \
        icon.color="$color" \
        background.color=$bg \
        background.corner_radius=15 \
        background.height=30

done
