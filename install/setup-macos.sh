#!/usr/bin/env bash

# Devbox macOS setup script
# Sets up a modern development environment on macOS

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

# Detect Homebrew prefix (Apple Silicon only)
HOMEBREW_PREFIX="/opt/homebrew"

update_shell() {
  local shell_path;
  shell_path="$(which zsh)"

  setup_echo "Changing your shell to zsh ..."
  if ! grep "$shell_path" /etc/shells > /dev/null 2>&1 ; then
    setup_echo "Adding '$shell_path' to /etc/shells"
    sudo sh -c "echo $shell_path >> /etc/shells"
  fi
  chsh -s "$shell_path"
}

case "$SHELL" in
  */zsh)
    if [ "$(which zsh)" != '/bin/zsh' ] ; then
      update_shell
    fi
    ;;
  *)
    update_shell
    ;;
esac

if ! command -v brew >/dev/null; then
  setup_echo "Installing Homebrew ..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

  append_to_zshrc '# Homebrew setup'

  # shellcheck disable=SC2016
  append_to_zshrc 'eval "$(/opt/homebrew/bin/brew shellenv)"' 1

  eval "$($HOMEBREW_PREFIX/bin/brew shellenv)"
fi

setup_echo "Updating Homebrew formulae ..."
brew analytics off
brew update

setup_echo "Installing from Brewfile ..."
brew bundle --file="$HOME/.Brewfile"

setup_echo "Configuring asdf version manager ..."
append_to_zshrc '# asdf version manager'
append_to_zshrc '. /opt/homebrew/opt/asdf/libexec/asdf.sh' 1

setup_echo "Configuring pnpm ..."
append_to_zshrc '# pnpm'
append_to_zshrc 'export PNPM_HOME="$HOME/Library/pnpm"' 1
append_to_zshrc 'case ":$PATH:" in' 1
append_to_zshrc '  *":$PNPM_HOME:"*) ;;' 1
append_to_zshrc '  *) export PATH="$PNPM_HOME:$PATH" ;;' 1
append_to_zshrc 'esac' 1

setup_echo "macOS setup complete!"