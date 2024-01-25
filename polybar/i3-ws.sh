#!/bin/bash

# Function to check workspaces and output status
update_workspaces() {
    # Get largest workspace index
    if i3-msg -t get_workspaces | jq -e ".[] | select(.num > 5)" >/dev/null
    then
        last=10
    else
        last=5
    fi

    # Update icon of each workspace
    for i in $(seq 1 $last); do
        if i3-msg -t get_workspaces | jq -e ".[] | select(.num == $i) | .focused" >/dev/null
        then
            # Primary
            echo -n '%{F#83A598}%{F-} '
        elif i3-msg -t get_workspaces | jq -e ".[] | select(.num == $i) | .urgent" >/dev/null
        then
            # Urgent
            echo -n '%{F#FB4934}%{F-} '
        elif i3-msg -t get_workspaces | jq -e ".[] | select(.num == $i)" >/dev/null
        then
            # Filled
            echo -n '%{F#BDAE93}%{F-} '
        else
            # Empty
            echo -n '%{F#BDAE93}%{F-} '
        fi
    done
    echo
}

# Initial update
update_workspaces

# Subscribe to workspace events with i3-msg
i3-msg -t subscribe -m '[ "workspace" ]' | while read -r event; do
    update_workspaces
done
