#!/usr/bin/env bash

filled=("󰎡 " "󰎤 " "󰎧 " "󰎪 " "󰎭 " "󰎱 " "󰎳 " "󰎶 " "󰎹 " "󰎼 " "󰽽 ")

empty=("󰎣 " "󰎦 " "󰎩 " "󰎬 " "󰎮 " "󰎰 " "󰎵 " "󰎸 " "󰎻 " "󰎾 " "󰽾 ")

# Function to check workspaces and output status
update_workspaces() {
  workspaces=$(i3-msg -t get_workspaces)

  # Get sorted list of workspace numbers that exist
  nums=$(echo "$workspaces" | jq -r '.[].num' | sort -n)

  # Show only workspaces that exist
  for i in $nums; do
    workspace=$(echo "$workspaces" | jq -e ".[] | select(.num == $i)")

    if echo "$workspace" | jq -e ".urgent" >/dev/null 2>&1; then
      # Urgent
      echo -n "%{F#FB4934}${filled[i]}%{F-}"
    elif echo "$workspace" | jq -e ".focused" >/dev/null 2>&1; then
      # Focused
      echo -n "%{F#BDAE93}${filled[i]}%{F-}"
    else
      # Exists but not focused
      echo -n "%{F#BDAE93}${empty[i]}%{F-}"
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
