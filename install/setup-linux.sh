#!/usr/bin/env bash

# Devbox Linux setup script
# Installs system-level packages and sets default shell to zsh.
# Tool-level setup (starship, asdf, pnpm, etc.) is handled by bootstrap.

setup_echo() {
  local fmt="$1"; shift

  # shellcheck disable=SC2059
  printf "\n[SETUP] $fmt\n" "$@"
}

# shellcheck disable=SC2154
trap 'ret=$?; test $ret -ne 0 && printf "failed\n\n" >&2; exit $ret' EXIT

set -e

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
  jq \
  htop \
  tree \
  wget \
  unzip

# Install fzf from GitHub releases (apt version is too old, lacks --zsh support)
if ! command -v fzf >/dev/null || ! fzf --zsh &>/dev/null; then
  setup_echo "Installing fzf from GitHub releases..."
  FZF_VERSION=$(curl -s https://api.github.com/repos/junegunn/fzf/releases/latest | grep '"tag_name"' | sed -E 's/.*"v?([^"]+)".*/\1/')
  ARCH=$(uname -m)
  case $ARCH in
    x86_64) FZF_ARCH="amd64" ;;
    aarch64) FZF_ARCH="arm64" ;;
    *) setup_echo "Unsupported architecture for fzf: $ARCH" ;;
  esac
  if [ -n "$FZF_ARCH" ]; then
    curl -Lo /tmp/fzf.tar.gz "https://github.com/junegunn/fzf/releases/download/v${FZF_VERSION}/fzf-${FZF_VERSION}-linux_${FZF_ARCH}.tar.gz"
    mkdir -p /tmp/fzf-install
    tar -C /tmp/fzf-install -xzf /tmp/fzf.tar.gz
    sudo install -m 755 /tmp/fzf-install/fzf /usr/local/bin/fzf
    rm -rf /tmp/fzf.tar.gz /tmp/fzf-install
  fi
fi

# Change default shell to zsh
if [ "$SHELL" != "$(which zsh)" ]; then
  setup_echo "Changing default shell to zsh..."
  sudo chsh -s "$(which zsh)" "$USER"
fi

setup_echo "Linux setup complete!"
