# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What This Is

A personal dotfiles repository managed with **GNU Stow** for symlinking and **freyr** (a custom bash script) for system setup, package installation, and migrations.

It manages the dotfiles in Linux and MacOs.

## Architecture

### Stow Packages (symlinked to `$HOME`)
Directories without a `_` prefix are stow packages. Each contains files mirroring the home directory structure:
- `git/` - `.gitconfig`, `.gitignore_global`
- `zsh/` - `.zshrc`, `.zsh/configs/*.zsh`, `.zsh/functions/*`
- `vim/` - `.vimrc`, `.vim/`
- `tmux/` - `.tmux.conf`
- `bin/` - `.bin/`, `.bash_profile`, `.profile`
- `claude/` - `.claude/settings.json`, statusline, hooks
- `karabiner/` - `.config/karabiner/karabiner.json` (macOS keyboard remapping)
- `ideavim/`, `js/`, `jupyter/`, `python/`, `stow/`

### Non-Stow Directories (`_` prefix)
Directories prefixed with `_` are managed by freyr, not stow:
- `_hosts/` - Host-specific setup scripts (abulafia, arion, tir)
- `_freyr/` - Helper scripts and migration system
- `_setup/`, `_ssh/`, `_system-settings/`, `_system-fixes/` - System configuration
- `_protonmail/`, `_thunderbird/`, `_tiddlywiki/` - App-specific config

### Zsh Configuration Structure
`.zshrc` loads configs modularly:
1. Prompt (pure prompt) from `~/.zsh/prompt/`
2. All `~/.zsh/configs/*.zsh` files (aliases, completion, editor, history, keybindings, path, various)
3. All `~/.zsh/functions/*` files (extract, g, version_bump)

## Key Commands

```bash
# Link all dotfiles to $HOME
stow -v git ideavim js jupyter python stow tmux vim zsh bin claude karabiner

# Link a single package
stow -v <package_name>

# Unlink a package
stow -D <package_name>

# Full system setup (Fedora/dnf-based)
./freyr --setup

# Run migrations
./freyr --migrate

# Update system packages
./freyr --update
```

## Conventions

- Stow ignore rules are in `stow/.stow-global-ignore` - excludes `.git`, swap files, README, LICENSE
- The `.gitignore` excludes vim spell files, wpa configs, jupyter workspaces, and `.version_lock`
- Host-specific configs go in `_hosts/<hostname>/`
- Freyr migrations live in `_freyr/migrations/` and must follow sequential order
