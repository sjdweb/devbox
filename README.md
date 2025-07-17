Devbox
======

A cross-platform bootstrap script for setting up a modern development environment on macOS and Linux.

## What is Devbox?

Devbox automates the setup of a new development machine with:
- Modern shell environment (Zsh + Starship prompt)
- Essential development tools
- Consistent configurations across macOS and Linux
- Fast, maintainable setup process

## Prerequisites

### macOS
- macOS Sequoia or later (Apple Silicon optimized)
- Sign in to iCloud (for Mac App Store apps)
- Install Xcode Command Line Tools:
  ```sh
  xcode-select --install
  ```

### Linux (Ubuntu/Debian)
- Ubuntu 20.04+ or Debian 11+
- sudo access

## Installation

Clone this repository and run the bootstrap script:

```sh
git clone https://github.com/sjdweb/devbox.git ~/Code/devbox
cd ~/Code/devbox
./bootstrap
```

## What Does It Install?

### Core Tools (All Platforms)
- **Shell**: Zsh with Starship prompt (fast, minimal)
- **Version Management**: asdf (for Python, Node, Ruby, etc.)
- **Node.js**: pnpm for package management and Node version control
- **Editor**: Neovim (with optional LazyVim configuration)
- **Utilities**: ripgrep, fzf, bat, delta, tmux, git

### macOS Specific
- Homebrew package manager
- Browsers: Firefox (primary), Brave, Chrome
- Development apps: iTerm2, Ghostty, Raycast
- Fonts: JetBrains Mono (with Nerd Font variant)
- Mac App Store apps: Slack

### Dotfiles Integration
The bootstrap script clones and installs dotfiles from:
```
https://github.com/sjdweb/dotfiles
```

## Key Improvements

- **10x faster shell startup** - No Oh-My-Zsh overhead
- **Instant Node switching** - pnpm instead of nvm
- **Cross-platform** - Single bootstrap for macOS and Linux
- **Modern tools** - Starship, delta, bat, etc.
- **Simplified** - One tool (asdf) for all version management

## Post-Installation

1. Restart your shell (or computer on macOS)
2. Configure git with your personal info:
   ```sh
   git config --global user.name "Your Name"
   git config --global user.email "your.email@example.com"
   ```
3. Set up asdf plugins as needed:
   ```sh
   asdf plugin add nodejs
   asdf plugin add python
   ```

## Customization

- Personal shell configuration: `~/.zshrc.local`
- Personal git configuration: `~/.gitconfig.local`

## License

MIT License - see LICENSE file for details.