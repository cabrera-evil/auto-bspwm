#!/usr/bin/env bash

NOTIFY_ICON=/usr/share/icons/Numix-Circle/48@2x/apps/system-software-update.svg

# Function to get the number of available updates
get_total_updates() {
    UPDATES=$(apt list --upgradable 2>/dev/null | grep -c "upgradable")
}

# Function to send notifications based on the number of updates
send_notification() {
    if hash dunstify &>/dev/null; then
        case $UPDATES in
        [5-9][0-9] | [1-9][0-9][0-9]*)
            dunstify -r 2593 -u critical -i $NOTIFY_ICON \
                "You really need to update!!" "$UPDATES New packages"
            ;;
        [2-4][0-9])
            dunstify -r 2593 -u normal -i $NOTIFY_ICON \
                "You should update soon" "$UPDATES New packages"
            ;;
        [3-9])
            dunstify -r 2593 -u low -i $NOTIFY_ICON \
                "You have updates" "$UPDATES New packages"
            ;;
        esac
    fi
}

# Main loop
while true; do
    get_total_updates
    send_notification

    while ((UPDATES > 0)); do
        echo " $UPDATES"
        sleep 5
        get_total_updates
    done

    while ((UPDATES == 0)); do
        echo " None"
        sleep 1800
        get_total_updates
    done
done
