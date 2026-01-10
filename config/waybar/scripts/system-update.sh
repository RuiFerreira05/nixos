#!/usr/bin/env bash

# Check if flatpak is installed
pkg_installed() {
    command -v "$1" &>/dev/null
}

# Trigger upgrade
if [ "$1" == "up" ]; then
    # Define the signal to refresh Waybar (matches your original script)
    trap 'pkill -RTMIN+20 waybar' EXIT

    # The command to run in the terminal
    # 1. Update system using 'nh' (Updates flake.lock AND rebuilds)
    # 2. Update Flatpaks if installed
    command="
    echo '--- ❄️ Updating NixOS System ❄️ ---';
    nh os switch --update;

    if command -v flatpak &>/dev/null; then
        echo -e '\n--- 📦 Updating Flatpaks 📦 ---';
        flatpak update -y;
    fi

    echo -e '\nDone! Press any key to exit...';
    read -n 1;
    "

    # Launch Kitty
    kitty --title " System Update" sh -c "${command}"
    exit 0
fi

# --- Count Updates ---

# 1. Flatpak Updates
# (This is the only thing we can count quickly without heavy CPU usage)
if pkg_installed flatpak; then
    flatpak_updates=$(flatpak remote-ls --updates | grep -c '^')
else
    flatpak_updates=0
fi

# 2. NixOS Updates
# Calculating pending NixOS updates requires evaluating the whole flake,
# which is too heavy for a status bar.
# We simply mark it as '?' or '0' until you manually update.
official_updates="?"

# Calculate total (Only counting flatpaks really)
total_updates=$flatpak_updates

# Tooltip Output
tooltip="<b>OS:</b> NixOS\n<b>Flatpak:</b> $flatpak_updates pending"

# Module Output
# If 0 flatpak updates, show "Up to date" icon
if [ $flatpak_updates -eq 0 ]; then
    echo "{\"text\":\"󰸟\", \"tooltip\":\"System is up to date (Flatpaks: 0)\", \"class\":\"updated\"}"
else
    # If updates exist, show the update icon and the count
    echo "{\"text\":\" $flatpak_updates\", \"tooltip\":\"$tooltip\", \"class\":\"pending\"}"
fi
