#!/bin/bash

echo "=== Devbox Setup Verification ==="
echo ""

# Colors for output
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

check_command() {
    if command -v "$1" >/dev/null 2>&1; then
        echo -e "${GREEN}✓${NC} $1 is installed: $(command -v $1)"
        return 0
    else
        echo -e "${RED}✗${NC} $1 is NOT installed"
        return 1
    fi
}

check_file() {
    if [ -f "$1" ] || [ -d "$1" ]; then
        echo -e "${GREEN}✓${NC} $1 exists"
        return 0
    else
        echo -e "${RED}✗${NC} $1 does NOT exist"
        return 1
    fi
}

check_symlink() {
    if [ -L "$1" ]; then
        target=$(readlink "$1")
        echo -e "${GREEN}✓${NC} $1 → $target"
        return 0
    else
        echo -e "${RED}✗${NC} $1 is NOT a symlink"
        return 1
    fi
}

echo "1. Shell Setup:"
echo "   Current shell: $SHELL"
check_command zsh
check_file ~/.zshrc
check_symlink ~/.zshrc

echo ""
echo "2. Development Tools:"
check_command git
check_command tmux
check_command vim
check_command nvim
check_command rg
check_command fzf
check_command starship

echo ""
echo "3. Version Management:"
check_command asdf
check_file ~/.asdf
check_command pnpm
check_file ~/.local/share/pnpm

echo ""
echo "4. Dotfiles:"
check_symlink ~/.gitconfig
check_symlink ~/.npmrc
check_symlink ~/.vimrc
check_symlink ~/.tmux.conf
check_file ~/dotfiles

echo ""
echo "5. Testing zsh configuration:"
if [ -f ~/.zshrc ]; then
    echo "   Sourcing ~/.zshrc..."
    zsh -c 'source ~/.zshrc && echo "   Zsh configuration loads successfully"' 2>&1
else
    echo -e "${RED}   Cannot test - ~/.zshrc not found${NC}"
fi

echo ""
echo "=== Verification Complete ==="
echo ""
echo "To fully test the setup:"
echo "1. Start a new zsh shell: zsh"
echo "2. Check if the prompt changed (starship)"
echo "3. Test pnpm: pnpm --version"
echo "4. Test asdf: asdf --version"