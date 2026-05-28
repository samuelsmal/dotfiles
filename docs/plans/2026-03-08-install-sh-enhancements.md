# install.sh Enhancements Implementation Plan

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers-extended-cc:executing-plans to implement this plan task-by-task.

**Goal:** Enhance install.sh with version display, git setup, shell aliases, and automated release tooling.

**Architecture:** Add VERSION variable and two new installer functions (install_git, install_aliases) to the existing install.sh pattern. A separate tag-release.sh script automates version bumping, committing, and tagging. A pre-commit hook warns about version mismatches.

**Tech Stack:** Bash, git hooks, curl for fetching configs from GitHub raw URL.

---

### Task 0: Add VERSION variable and display

**Files:**
- Modify: `install.sh:1-6` (add VERSION, print it in main)

**Step 1: Add VERSION variable after the shebang block**

```bash
#!/usr/bin/env bash
set -euo pipefail

VERSION="1.1.1"

REPO_RAW_URL="https://raw.githubusercontent.com/samuelsmal/dotfiles/master"
INSTALL_PREFIX=""
```

**Step 2: Add version display at start of main()**

In the `main()` function, add a version print right after argument parsing, before `check_os`:

```bash
  log_ok "dotfiles installer v${VERSION}"

  check_os
```

**Step 3: Verify manually**

Run: `bash install.sh --help`
Expected: Shows help (no crash from VERSION addition).

Run (on Ubuntu): `bash install.sh`
Expected: First line of output is `[ok] dotfiles installer v1.1.1`

**Step 4: Commit**

```bash
git add install.sh
git commit -m "feat(install): add VERSION variable and display at startup"
```

---

### Task 1: Create release script (`scripts/tag-release.sh`)

**Files:**
- Create: `scripts/tag-release.sh`

**Step 1: Create the scripts directory and release script**

```bash
#!/usr/bin/env bash
set -euo pipefail

# Usage: ./scripts/tag-release.sh <version>
# Example: ./scripts/tag-release.sh 1.2.0
#
# This script:
# 1. Validates the version format
# 2. Updates VERSION in install.sh
# 3. Commits the change
# 4. Creates git tag v<version>

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
INSTALL_SH="$REPO_ROOT/install.sh"

log_ok()  { printf '[ok]   %s\n' "$*"; }
log_err() { printf '[err]  %s\n' "$*" >&2; }

usage() {
  cat <<'EOF'
Usage: tag-release.sh <version>

Creates a release by updating install.sh VERSION, committing, and tagging.

  version   Semver version WITHOUT 'v' prefix (e.g. 1.2.0)

Example:
  ./scripts/tag-release.sh 1.2.0
EOF
}

main() {
  if [ $# -ne 1 ] || [ "$1" = "--help" ]; then
    usage
    exit 1
  fi

  local version="$1"

  # Validate version format (semver: X.Y.Z)
  if ! echo "$version" | grep -qE '^[0-9]+\.[0-9]+\.[0-9]+$'; then
    log_err "invalid version format: '$version' (expected X.Y.Z)"
    exit 1
  fi

  # Check tag doesn't already exist
  if git tag -l "v${version}" | grep -q "v${version}"; then
    log_err "tag v${version} already exists"
    exit 1
  fi

  # Check for clean working tree (except install.sh which we're about to modify)
  if ! git diff --quiet --exit-code -- ':!install.sh' || ! git diff --cached --quiet --exit-code; then
    log_err "working tree has uncommitted changes — commit or stash first"
    exit 1
  fi

  # Read current version
  local current_version
  current_version=$(grep -oP '^VERSION="\K[^"]+' "$INSTALL_SH")
  log_ok "current version: ${current_version}"
  log_ok "new version:     ${version}"

  # Update VERSION in install.sh
  sed -i "s/^VERSION=\".*\"/VERSION=\"${version}\"/" "$INSTALL_SH"
  log_ok "updated install.sh VERSION to ${version}"

  # Commit and tag
  git add "$INSTALL_SH"
  git commit -m "chore: bump version to v${version}"
  git tag "v${version}"

  log_ok "created tag v${version}"
  log_ok "done! Run 'git push && git push --tags' to publish."
}

main "$@"
```

**Step 2: Make it executable**

Run: `chmod +x scripts/tag-release.sh`

**Step 3: Verify**

Run: `./scripts/tag-release.sh --help`
Expected: Shows usage.

Run: `./scripts/tag-release.sh bad`
Expected: Error about invalid version format.

**Step 4: Commit**

```bash
git add scripts/tag-release.sh
git commit -m "feat: add tag-release.sh for automated version management"
```

---

### Task 2: Add git pre-commit hook for version mismatch warning

**Files:**
- Create: `scripts/pre-commit-version-check.sh` (the hook logic)
- Modify: `install.sh` (document hook setup in usage or comments)

**Step 1: Create the hook script**

This is a standalone script that can be installed as a pre-commit hook. It warns (does not block) if install.sh is staged and VERSION doesn't look intentionally bumped via the release script.

```bash
#!/usr/bin/env bash
# Pre-commit hook: warns if install.sh is staged but VERSION wasn't updated
# via scripts/tag-release.sh
#
# Install: cp scripts/pre-commit-version-check.sh .git/hooks/pre-commit

# Only check if install.sh is staged
if ! git diff --cached --name-only | grep -q '^install.sh$'; then
  exit 0
fi

# Get the staged VERSION value
STAGED_VERSION=$(git diff --cached -- install.sh | grep -oP '^\+VERSION="\K[^"]+' || true)

# If VERSION line wasn't changed, no warning needed
if [ -z "$STAGED_VERSION" ]; then
  exit 0
fi

# Check if this looks like a release script commit (commit message check happens later,
# so we check if tag-release.sh is likely the caller by checking parent process)
LATEST_TAG=$(git describe --tags --abbrev=0 2>/dev/null || echo "none")

printf '\n[warn] install.sh VERSION changed to "%s" (latest tag: %s)\n' "$STAGED_VERSION" "$LATEST_TAG"
printf '[warn] If this is intentional, use: ./scripts/tag-release.sh %s\n\n' "$STAGED_VERSION"

# Warning only — don't block the commit
exit 0
```

**Step 2: Make it executable**

Run: `chmod +x scripts/pre-commit-version-check.sh`

**Step 3: Install the hook locally for this repo**

Run: `cp scripts/pre-commit-version-check.sh .git/hooks/pre-commit && chmod +x .git/hooks/pre-commit`

Note: This only applies to this local clone. Users who clone the repo would need to run this manually or we could add a setup step. The tag-release.sh script bypasses this naturally since it makes the commit itself.

**Step 4: Commit**

```bash
git add scripts/pre-commit-version-check.sh
git commit -m "feat: add pre-commit hook for version mismatch warning"
```

---

### Task 3: Add `install_git()` function

**Files:**
- Modify: `install.sh` (add function after `install_claude_code`, update `main`)

**Step 1: Add the install_git function**

Insert after `install_claude_code()`:

```bash
install_git() {
  log_ok "setting up git..."

  # Install git binary if missing
  if command -v git >/dev/null 2>&1; then
    log_skip "git already installed ($(git --version))"
  elif has_sudo; then
    sudo apt-get update -qq
    sudo apt-get install -y -qq git
    log_ok "installed git via apt"
  else
    log_err "git requires sudo to install via apt — skipping"
    return 1
  fi

  # Fetch gitconfig and gitignore_global
  fetch_config "git/.gitconfig" "$HOME/.gitconfig"
  fetch_config "git/.gitignore_global" "$HOME/.gitignore_global"

  # Prompt for user identity
  local current_name current_email name email

  current_name=$(git config --global user.name 2>/dev/null || true)
  current_email=$(git config --global user.email 2>/dev/null || true)

  printf 'Git user name'
  [ -n "$current_name" ] && printf ' [%s]' "$current_name"
  printf ': '
  read -r name
  [ -z "$name" ] && name="$current_name"

  printf 'Git user email'
  [ -n "$current_email" ] && printf ' [%s]' "$current_email"
  printf ': '
  read -r email
  [ -z "$email" ] && email="$current_email"

  if [ -n "$name" ]; then
    git config --global user.name "$name"
    log_ok "set git user.name = $name"
  fi
  if [ -n "$email" ]; then
    git config --global user.email "$email"
    log_ok "set git user.email = $email"
  fi

  log_ok "git setup complete"
}
```

**Step 2: Add `git` to the main() case statement**

Update the `--only` case and the default run:

```bash
  case "$only" in
    "") install_tmux; install_neovim; install_claude_code; install_git; install_aliases ;;
    tmux) install_tmux ;;
    neovim) install_neovim ;;
    claude) install_claude_code ;;
    git) install_git ;;
    aliases) install_aliases ;;
    *) log_err "unknown tool: $only (use tmux, neovim, claude, git, aliases)"; exit 1 ;;
  esac
```

**Step 3: Update usage()**

```bash
usage() {
  cat <<EOF
Usage: install.sh [OPTIONS]

Sets up tmux, neovim, Claude Code, git, and shell aliases on Ubuntu Linux.

Options:
  --help          Show this help message
  --only TOOL     Install only one tool (tmux, neovim, claude, git, aliases)
  --version       Show version
EOF
}
```

Also add `--version` to argument parsing:

```bash
      --version) printf 'dotfiles installer v%s\n' "$VERSION"; exit 0 ;;
```

**Step 4: Commit**

```bash
git add install.sh
git commit -m "feat(install): add git setup with config fetch and user prompt"
```

---

### Task 4: Add `install_aliases()` function

**Files:**
- Modify: `install.sh` (add function, already wired in Task 3's case statement)

**Step 1: Add the install_aliases function**

Insert after `install_git()`:

```bash
install_aliases() {
  log_ok "setting up shell aliases..."

  local aliases_file="$HOME/.dotfiles_aliases.sh"

  cat > "$aliases_file" << 'ALIASES'
# Dotfiles shell aliases — managed by install.sh
# Do not edit manually; re-run install.sh to update.

# Navigation
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."
alias -- -="cd -"

# ls / tree (use eza if available, fallback to system ls)
if command -v eza >/dev/null 2>&1; then
  alias l='eza -lh'
  alias la='eza -lha'
  alias ls='eza'
  alias tree='eza --tree --long'
else
  alias l='ls -lh'
  alias la='ls -lha'
fi

# Misc
alias mkdir="mkdir -p"
alias path='echo $PATH | tr -s ":" "\n"'
alias please='sudo $(fc -ln -1)'

# vim -> nvim (if available)
if command -v nvim >/dev/null 2>&1; then
  alias vim='nvim'
fi

# Git
alias ga='git add '
alias gap='git add -p'
alias gps='git push'
alias gpl='git pull'
alias gcm='git commit -m '

# Docker (if available)
if command -v docker >/dev/null 2>&1; then
  alias d="docker"
  alias d_a="docker attach"
  alias d_m="docker rm"
  alias d_lc="docker ps"
  alias d_li="docker images"
  alias d_rm_all_containers='docker rm $(docker ps -a -q)'
  alias d_rm_all_images='docker rmi $(docker images -q)'
  alias d_stop_all='docker stop $(docker ps -a -q)'
fi

# Kubectl (if available)
if command -v kubectl >/dev/null 2>&1; then
  alias k="kubectl"
fi
ALIASES

  log_ok "wrote $aliases_file"

  # Idempotently add source line to shell rc files
  local source_line='. "$HOME/.dotfiles_aliases.sh"'

  for rc_file in "$HOME/.bashrc" "$HOME/.zshrc"; do
    if [ -f "$rc_file" ]; then
      if ! grep -qF '.dotfiles_aliases.sh' "$rc_file"; then
        printf '\n# Dotfiles aliases\n%s\n' "$source_line" >> "$rc_file"
        log_ok "added source line to $rc_file"
      else
        log_skip "source line already in $rc_file"
      fi
    else
      log_skip "$rc_file does not exist — skipping"
    fi
  done

  log_ok "aliases setup complete (restart shell or run: source $aliases_file)"
}
```

**Step 2: Commit**

```bash
git add install.sh
git commit -m "feat(install): add shell aliases with graceful tool detection"
```

---

### Task 5: Final integration and testing

**Files:**
- Modify: `install.sh` (final review)
- Modify: `docs/plans/2026-03-08-install-sh-enhancements-design.md` (mark complete)

**Step 1: Run shellcheck on install.sh**

Run: `shellcheck install.sh`
Expected: No errors (warnings about `SC2086` for intentional word splitting in aliases are acceptable).

**Step 2: Run shellcheck on tag-release.sh**

Run: `shellcheck scripts/tag-release.sh`
Expected: No errors.

**Step 3: Verify --help and --version**

Run: `bash install.sh --help`
Expected: Updated help text showing all tools.

Run: `bash install.sh --version`
Expected: `dotfiles installer v1.1.1`

**Step 4: Verify tag-release.sh validation**

Run: `./scripts/tag-release.sh bad-version`
Expected: Error about invalid format.

Run: `./scripts/tag-release.sh 1.1.1`
Expected: Error that tag already exists.

**Step 5: Commit any fixes**

```bash
git add install.sh scripts/
git commit -m "fix(install): address shellcheck findings"
```
