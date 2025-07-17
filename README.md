# Devbox

A fast, modern development environment setup for macOS and Linux.

## Quick Start

```bash
git clone https://github.com/sjdweb/devbox.git
cd devbox
./bootstrap
```

## What's Included

### Core Tools
- **Shell**: Zsh + Zap (lightweight plugin manager) + Starship prompt
- **Editor**: Neovim with LazyVim (full IDE experience)
- **Terminal**: Ghostty (with Tokyo Night theme)
- **Version Management**:
  - Node.js via pnpm (`pnpm env use --global lts`)
  - Python via UV (`uv python install --default --preview`)
  - Go via system install
  - Other tools via asdf (currently just Neovim)

### Key Features
- Single configuration files work on both macOS and Linux
- 10x faster shell startup (no oh-my-zsh)
- Modern tooling (UV for Python, pnpm for Node.js)
- Minimal macOS defaults (Finder + Dock only)

### Browsers
- Firefox (primary)
- Brave, Chrome (secondary)

### Development
- Git, tmux, ripgrep, fzf
- Docker/Kubernetes tools (kubectl, k9s, helm)
- VSCode, Sublime Text (using their cloud sync)

## Structure

```
devbox/
├── bootstrap          # Main setup script
├── install/
│   ├── Brewfile      # macOS packages
│   ├── setup-macos.sh
│   ├── setup-linux.sh
│   ├── macos-defaults # Minimal Finder/Dock settings
│   └── macos-dock    # Dock app configuration
└── docker-compose.yml # Test environment

dotfiles/             # Separate repo, cloned during bootstrap
├── zshrc
├── config/
│   ├── nvim/        # LazyVim configuration
│   ├── ghostty/
│   └── starship.toml
└── ...
```

## Testing

Test the setup in Docker:

```bash
docker-compose up -d
docker exec -it devbox-test bash
cd /devbox && ./bootstrap
```

## Philosophy

- **Fast**: No unnecessary overhead, modern tools
- **Simple**: One way to do things, minimal configuration
- **Maintainable**: Easy to understand in a year
- **Cross-platform**: Same experience on macOS and Linux