#!/usr/bin/env bash

# Devbox Linux setup script
# Sets up a modern development environment on Linux (Ubuntu/Debian)

setup_echo() {
  local fmt="$1"; shift

  # shellcheck disable=SC2059
  printf "\n[SETUP] $fmt\n" "$@"
}

append_to_zshrc() {
  local text="$1" zshrc
  local skip_new_line="${2:-0}"

  if [ -w "$HOME/.zshrc.local" ]; then
    zshrc="$HOME/.zshrc.local"
  else
    zshrc="$HOME/.zshrc"
  fi

  if ! grep -Fqs "$text" "$zshrc"; then
    if [ "$skip_new_line" -eq 1 ]; then
      printf "%s\n" "$text" >> "$zshrc"
    else
      printf "\n%s\n" "$text" >> "$zshrc"
    fi
  fi
}

# shellcheck disable=SC2154
trap 'ret=$?; test $ret -ne 0 && printf "failed\n\n" >&2; exit $ret' EXIT

set -e

if [ ! -d "$HOME/bin/" ]; then
  mkdir "$HOME/bin"
fi

if [ ! -f "$HOME/.zshrc" ]; then
  touch "$HOME/.zshrc"
fi

# shellcheck disable=SC2016
append_to_zshrc 'export PATH="$HOME/bin:$PATH"'

setup_echo "Updating package lists..."
sudo apt-get update

setup_echo "Installing essential packages..."
sudo apt-get install -y \
  build-essential \
  curl \
  git \
  zsh \
  tmux \
  vim \
  ripgrep \
  fzf \
  jq \
  htop \
  tree \
  wget \
  unzip

# Install starship
if ! command -v starship >/dev/null; then
  setup_echo "Installing Starship prompt..."
  curl -sS https://starship.rs/install.sh | sh -s -- -y
fi


# Install asdf
if [ ! -d "$HOME/.asdf" ]; then
  setup_echo "Installing asdf version manager..."
  git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.14.0
fi

append_to_zshrc '# asdf version manager'
append_to_zshrc '. "$HOME/.asdf/asdf.sh"' 1
append_to_zshrc '. "$HOME/.asdf/completions/asdf.bash"' 1

# Install pnpm
if ! command -v pnpm >/dev/null; then
  setup_echo "Installing pnpm..."
  # Use env to ensure SHELL is set properly
  curl -fsSL https://get.pnpm.io/install.sh | env SHELL=/bin/bash sh -
fi

append_to_zshrc '# pnpm'
append_to_zshrc 'export PNPM_HOME="$HOME/.local/share/pnpm"' 1
append_to_zshrc 'case ":$PATH:" in' 1
append_to_zshrc '  *":$PNPM_HOME:"*) ;;' 1
append_to_zshrc '  *) export PATH="$PNPM_HOME:$PATH" ;;' 1
append_to_zshrc 'esac' 1

# Change default shell to zsh
if [ "$SHELL" != "/usr/bin/zsh" ]; then
  setup_echo "Changing default shell to zsh..."
  chsh -s /usr/bin/zsh
fi

setup_echo "Linux setup complete!"