active_color=0xffffffff
inactive_color=0x66ffffff

current_app_pid=$(osascript -e 'tell application "System Events" to get unix id of first process whose frontmost is true')
existing_items=$(sketchybar --query bar | jq -r '.items[]' | grep '^app\.')

for item in $existing_items; do
    if [ "$item" = "app.$current_app_pid" ]; then
        color=$active_color
        bg=on
    else
        color=$inactive_color
        bg=off
    fi
    sketchybar --set "$item" \
    label.color="$color" \
    icon.color="$color" \
    background.drawing="$bg"

done
