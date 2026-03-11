#!/usr/bin/env bash

################################################################################
# dotfiles
#
# This script symlinks dotfiles from the devbox/dotfiles directory into the
# home directory and sets up application configs.
################################################################################

dotfiles_echo() {
  local fmt="$1"; shift

  # shellcheck disable=SC2059
  printf "\n[DOTFILES] $fmt\n" "$@"
}

set -e

DEVBOX_DIR="${DEVBOX_DIR:-$HOME/devbox}"
DOTFILES_DIR="$DEVBOX_DIR/dotfiles"
CONFIG_DIR=$HOME/.config

# Clean up old standalone dotfiles repo if it exists
if [ -d "$HOME/dotfiles" ] && [ "$HOME/dotfiles" != "$DOTFILES_DIR" ]; then
  dotfiles_echo "Found old ~/dotfiles directory. Backing up to ~/dotfiles_old..."
  mv "$HOME/dotfiles" "$HOME/dotfiles_old"
fi

files="gitconfig gitignore_global gitmessage hushlogin npmrc zshrc tmux.conf"

dotfiles_echo "Installing dotfiles..."

for file in $files; do
  if [ -f "$HOME/.$file" ] && [ ! -L "$HOME/.$file" ]; then
    dotfiles_echo ".$file already present. Backing up..."
    cp "$HOME/.$file" "$HOME/.${file}_backup"
  fi
  dotfiles_echo "-> Linking $DOTFILES_DIR/$file to $HOME/.$file..."
  ln -nfs "$DOTFILES_DIR/$file" "$HOME/.$file"
done

dotfiles_echo "Setting up LazyVim..."

if [ ! -d "$CONFIG_DIR" ]; then
  mkdir -p "$CONFIG_DIR"
fi

# Remove old Neovim config if it exists (and isn't already our symlink)
NVIM_DIR=$CONFIG_DIR/nvim
if [ -d "$NVIM_DIR" ] && [ ! -L "$NVIM_DIR" ]; then
  dotfiles_echo "Backing up existing Neovim config..."
  mv "$NVIM_DIR" "$NVIM_DIR.backup.$(date +%Y%m%d_%H%M%S)"
fi

dotfiles_echo "-> Linking $DOTFILES_DIR/config/nvim to $CONFIG_DIR/nvim..."
ln -nfs "$DOTFILES_DIR/config/nvim" "$CONFIG_DIR/nvim"

dotfiles_echo "Setting up Starship configuration..."
dotfiles_echo "-> Linking $DOTFILES_DIR/config/starship.toml to $CONFIG_DIR/starship.toml..."
ln -nfs "$DOTFILES_DIR/config/starship.toml" "$CONFIG_DIR/starship.toml"

dotfiles_echo "Setting up Ghostty configuration..."
if [ ! -d "$CONFIG_DIR/ghostty" ]; then
  mkdir -p "$CONFIG_DIR/ghostty"
fi
dotfiles_echo "-> Linking $DOTFILES_DIR/config/ghostty/config to $CONFIG_DIR/ghostty/config..."
ln -nfs "$DOTFILES_DIR/config/ghostty/config" "$CONFIG_DIR/ghostty/config"

dotfiles_echo "Dotfiles installation complete!"
