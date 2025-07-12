#!/usr/bin/env sh

######################################################################
# @author      : parin (parin@$HOSTNAME)
# @file        : install_aur_packages
# @created     : Saturday Jul 12, 2025 20:18:01 +07
#
# @description : 
######################################################################

echo "Installing needed packages..."
paru -S --noconfirm --needed --disable-download-timeout $(< packages-repository-aur.txt)

