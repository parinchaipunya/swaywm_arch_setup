#!/bin/bash

username="$(logname)"

# Check for sudo
if [ "$EUID" -ne 0 ]; then
    echo "This script must be run with sudo."
    exit 1
fi

# Install the custom package list
echo "Installing paru..."
sudo pacman -S --needed base-devel
git clone https://aur.archlinux.org/paru.git
cd paru
makepkg -si

echo "Installing needed packages..."
sudo pacman -S --noconfirm --needed --disable-download-timeout $(< packages-repository.txt)

# Deploy user configs
echo "Deploying user configs..."
rsync -a .config "/home/${username}/"
rsync -a .local "/home/${username}/"
rsync -a home_config/ "/home/${username}/"
# Restore user ownership
chown -R "${username}:${username}" "/home/${username}"

# Deploy system configs
echo "Deploying system configs..."
rsync -a --chown=root:root etc/ /etc/
rsync -a --chown=root:root usr/ /usr/

# Enable the Greetd service
echo "Enabling the Greetd service..."
systemctl -f enable greetd.service
systemctl enable --now bluetooth.service
systemctl enable --now NetworkManager.service

echo "Change default shell to zsh..."
sudo chsh -s $(which zsh)


echo "Installation complete."
