#!/bin/bash

username="$(logname)"

# Check for sudo
if [ "$EUID" -ne 0 ]; then
    echo "This script must be run with sudo."
    exit 1
fi

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

# Build chaophraya (river 0.5 window manager) as the user, into ~/.local/bin.
# greetd's session-sel starts it by default ([enter]); [s] falls back to sway.
echo "Building chaophraya..."
sudo -u "$username" -H ./install_chaophraya.sh || echo "chaophraya not installed: run ./install_chaophraya.sh later (sway still works)."

# Enable the Greetd service
echo "Enabling the Greetd service..."
systemctl -f enable greetd.service
systemctl enable --now bluetooth.service
systemctl enable --now NetworkManager.service
systemctl enable --now cups.service

# Change default shell to zsh
echo "Change default shell to zsh..."
sudo chsh -s $(which zsh) $username

# Setup vimplug
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim


echo "Installation complete."
