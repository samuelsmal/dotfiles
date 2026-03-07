```

              88                          ad88  88  88
              88                ,d       d8"    ""  88
              88                88       88         88
      ,adPPYb,88   ,adPPYba,  MM88MMM  MM88MMM  88  88   ,adPPYba,  ,adPPYba,
     a8"    `Y88  a8"     "8a   88       88     88  88  a8P_____88  I8[    ""
     8b       88  8b       d8   88       88     88  88  8PP"""""""   `"Y8ba,
888  "8a,   ,d88  "8a,   ,a8"   88,      88     88  88  "8b,   ,aa  aa    ]8I
888   `"8bbdP"Y8   `"YbbdP"'    "Y888    88     88  88   `"Ybbd8"'  `"YbbdP"'
```


# Overview

Personal dotfiles repository managed with **GNU Stow** for symlinking and **freyr** (a custom bash script) for system setup, package installation, and migrations. Works on both Linux (Fedora) and macOS.

## Structure

```
dotfiles/
├── freyr                       # setup, install & migration script
├── CLAUDE.md                   # instructions for Claude Code
│
│ # Stow packages (symlinked to $HOME)
├── bin/                        # ~/.bin/ scripts, .bash_profile, .profile
├── claude/                     # ~/.claude/ (settings, hooks, statusline)
├── git/                        # .gitconfig, .gitignore_global
├── ideavim/                    # .ideavimrc
├── js/                         # JS tooling config
├── jupyter/                    # Jupyter config
├── karabiner/                  # ~/.config/karabiner/ (macOS keyboard remapping)
├── nvim/                       # ~/.config/nvim/
├── python/                     # Python config
├── stow/                       # .stow-global-ignore
├── tmux/                       # .tmux.conf
├── zsh/                        # .zshrc, .zsh/configs/, .zsh/functions/
│
│ # Non-stow directories (managed by freyr)
├── _freyr/                     # helper scripts, utils, migrations
├── _guitar/                    # guitar-related config
├── _hosts/                     # host-specific setup (abulafia, arion, tir)
├── _iterm2/                    # iTerm2 config
├── _protonmail/                # ProtonMail bridge config
├── _setup/                     # system setup scripts
├── _ssh/                       # SSH setup
├── _system-fixes/              # system fix scripts
├── _system-settings/           # system settings (dconf, etc.)
└── _thunderbird/               # Thunderbird config
```

## Usage

```bash
# Link all stow packages to $HOME
stow -v bin claude git ideavim js jupyter karabiner nvim python stow tmux zsh

# Link a single package
stow -v <package>

# Unlink a package
stow -D <package>

# Full system setup
./freyr --setup

# Run migrations
./freyr --migrate

# Update system packages
./freyr --update

# See all options
./freyr -h
```

## Zsh Configuration

`.zshrc` loads configs modularly:
1. Prompt (pure prompt) from `~/.zsh/prompt/`
2. All `~/.zsh/configs/*.zsh` files (aliases, completion, editor, history, keybindings, path, various)
3. All `~/.zsh/functions/*` (extract, g, version_bump)

## Utility Scripts (`~/.bin/`)

- `toggle-theme` - switch between light/dark themes (nvim, tmux, iTerm2)
- `backup_system` - system backup
- `dev` - development environment launcher
- `load-ssh-keys` / `sshkeyloader` - SSH key management
- `pdf_compress` - PDF compression
- `start_default_programs` - launch default programs
- `start-or-switch-to` - focus or launch an application
