#!/bin/bash

# Install the custom package list
echo ":: Installing base-devel. ::"
sudo pacman -S --needed base-devel
echo ":: Cloning paru from github. ::"
git clone https://aur.archlinux.org/paru.git
echo ":: Building. ::"
cd paru
makepkg -si

echo ":: paru installed ::"
