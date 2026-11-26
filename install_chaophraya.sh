#!/bin/bash
# Build and install chaophraya (the river 0.5 window manager) for the current user.
#
# Source: $CHAOPHRAYA_SRC (default ~/projects/chaophraya). If it doesn't exist and
# $CHAOPHRAYA_REPO is set, it is cloned from there first.
# Installs to ~/.local/bin/chaophraya (start-chaophraya puts that on PATH).
# Needs: rust (cargo) and river from packages-repository.txt.
#
# Run as your user, not root:   ./install_chaophraya.sh

set -e

if [ "$EUID" -eq 0 ]; then
    echo "Run this as your user, not root (it installs into ~/.local)."
    exit 1
fi

SRC="${CHAOPHRAYA_SRC:-$HOME/projects/chaophraya}"

if [ ! -d "$SRC" ]; then
    if [ -n "$CHAOPHRAYA_REPO" ]; then
        echo ":: Cloning chaophraya from $CHAOPHRAYA_REPO ::"
        mkdir -p "$(dirname "$SRC")"
        git clone "$CHAOPHRAYA_REPO" "$SRC"
    else
        echo "chaophraya source not found at $SRC."
        echo "Set CHAOPHRAYA_SRC to its path, or CHAOPHRAYA_REPO to a git URL to clone."
        exit 1
    fi
fi

command -v cargo >/dev/null || { echo "cargo not found: install 'rust' first."; exit 1; }

echo ":: Building chaophraya (release) from $SRC ::"
cargo install --locked --path "$SRC/crates/chaophraya" --root "$HOME/.local"

echo ":: Checking the config ::"
"$HOME/.local/bin/chaophraya" check-config || echo "(fix the config above, or stow the chaophraya dotfiles package)"

echo ":: chaophraya installed to $HOME/.local/bin ::"
