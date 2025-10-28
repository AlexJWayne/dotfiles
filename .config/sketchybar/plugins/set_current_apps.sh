
active_color=0xffffffff
inactive_color=0x66ffffff

current_app_pid=$(osascript -e 'tell application "System Events" to get unix id of first process whose frontmost is true')

current_workspace=$(aerospace list-workspaces --focused)
current_apps=$(aerospace list-windows --workspace "$current_workspace" --format '%{app-name}|%{app-pid}')
current_apps=$(echo "$current_apps" | sed 's/ //g' | sort -u | tail -r)

# Remove existing items
existing_items=$(sketchybar --query bar | jq -r '.items[]' | grep '^app\.')
for item in $existing_items; do
    sketchybar --remove "$item"
done

# Add new items
for app in $current_apps; do
    IFS='|'; read -r app_name app_pid <<< "$app"

    if [ "$app_pid" = "$current_app_pid" ]; then
        color=$active_color
        bg=on
    else
        color=$inactive_color
        bg=off
    fi


    if [ "$app_name" = "Arc" ]; then icon='󰖟';
    elif [ "$app_name" = "WezTerm" ]; then icon='';
    elif [ "$app_name" = "Zed" ]; then icon='󰅩';
    elif [ "$app_name" = "LogicPro" ]; then icon='󰎇';
    elif [ "$app_name" = "Spotify" ]; then icon='';
    elif [ "$app_name" = "Slack" ]; then icon='';
    elif [ "$app_name" = "MicrosoftOutlook" ]; then icon='󰴢';
    elif [ "$app_name" = "MicrosoftTeams" ]; then icon='󰊻';
    else icon='󰫈'
    fi

    sketchybar --add item app.$app_pid right \
                --set app.$app_pid \
                label="$app_name" \
                label.color=$color \
                icon=$icon \
                icon.color=$color \
                icon.padding_left=12 \
                label.align=center \
                label.padding_left=0 \
                label.padding_right=12 \
                background.color=0x66000000 \
                background.corner_radius=15 \
                background.height=30 \
                background.drawing=$bg


done
