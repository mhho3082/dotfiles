#!/bin/bash

# Function to check workspaces and output status
update_workspaces() {
    workspaces=$(i3-msg -t get_workspaces)

    # Get largest workspace index
    if echo "$workspaces" | jq -e ".[] | select(.num > 5)" >/dev/null; then
        last=10
    else
        last=5
    fi

    # Update icon of each workspace
    for i in $(seq 1 $last); do
        workspace=$(echo "$workspaces" | jq -e ".[] | select(.num == $i)")

        if echo "$workspace" | jq -e ".focused" >/dev/null; then
            # Primary
            echo -n '%{F#83A598}%{F-} '
        elif echo "$workspace" | jq -e ".urgent" >/dev/null; then
            # Urgent
            echo -n '%{F#FB4934}%{F-} '
        elif [ -n "$workspace" ]; then
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
