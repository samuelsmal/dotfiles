# install.sh Enhancements Design

Date: 2026-03-08

## Overview

Enhance `install.sh` with version display, git setup, shell aliases, and a release script for automated version management.

## 1. Version Display

- Hardcoded `VERSION="1.1.1"` at top of `install.sh`
- Print version at start of `main()`
- Never manually edited — managed by `scripts/tag-release.sh`

## 2. Release Script (`scripts/tag-release.sh`)

- Takes version argument: `./scripts/tag-release.sh 1.2.0`
- Updates `VERSION=` line in `install.sh` via sed
- Commits: `chore: bump version to v1.2.0`
- Creates git tag `v1.2.0`
- Refuses if tag already exists

Safety net: git pre-commit hook warns if `install.sh` is staged and VERSION doesn't match latest tag (reminder to use release script, not a blocker).

## 3. Git Setup (`install_git()`)

- Prompt user for `user.name` and `user.email` (show current `git config --global` values as defaults)
- Fetch full `.gitconfig` and `.gitignore_global` from repo
- Override `user.name` and `user.email` via `git config --global`

## 4. Shell Aliases (`install_aliases()`)

- Write `~/.dotfiles_aliases.sh` with portable aliases:
  - Navigation: `..`, `...`, `....`, `.....`, `-`
  - ls/tree: default to system `ls`, use `eza` if available
  - git: `ga`, `gap`, `gps`, `gpl`, `gcm`
  - docker: `d`, `d_a`, `d_m`, `d_lc`, `d_li`, batch rm/stop aliases
  - kubectl: `k`
  - misc: `mkdir -p`, `please`, `path`, `vim=nvim` (if nvim available)
- Idempotently append `source ~/.dotfiles_aliases.sh` to `~/.bashrc` and `~/.zshrc` (if they exist)
- Re-running `install.sh` overwrites aliases file; source line already present

## 5. CLI Changes

- Add `git` and `aliases` to `--only` options
- Update `usage()` help text
- Default run installs all: tmux, neovim, claude, git, aliases
