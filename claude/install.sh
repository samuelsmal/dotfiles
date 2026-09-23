#!/usr/bin/env bash
# Install Claude Code config from this dotfiles repo into ~/.claude.
#
# Why this exists instead of stow: ~/.claude mixes user config with Claude's
# runtime state (history, sessions, cache, projects, ...), and Claude rewrites
# settings.json at runtime — which clobbers stow symlinks. See claude/README.md.
#
# Strategy:
#   - Symlink user-authored, static config (hooks, skills, statusline,
#     CLAUDE.md, and agents/commands when present) so repo edits are live.
#   - settings.json is a portable BASELINE: copied only if missing. Claude owns
#     it at runtime, so we never symlink it and never clobber an existing one.
#   - settings.local.json is machine-local and is never touched.
#
# Idempotent. Re-running only fixes drift. Use --force to re-copy the
# settings.json baseline (backs the existing one up first).

set -euo pipefail

FORCE=0
[ "${1:-}" = "--force" ] && FORCE=1

# Resolve the directory this script lives in (the repo's claude/ package), so
# symlinks point at an absolute path regardless of the caller's cwd.
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]:-$0}")" && pwd)"
SRC="$SCRIPT_DIR/.claude"
DEST="$HOME/.claude"

log_ok()   { printf '[ok]   %s\n' "$*"; }
log_skip() { printf '[skip] %s\n' "$*"; }
log_err()  { printf '[err]  %s\n' "$*" >&2; }

# Symlink SRC/$1 -> DEST/$1, backing up any real file/dir already in the way.
link() {
  local rel="$1"
  local src="$SRC/$rel"
  local dest="$DEST/$rel"
  [ -e "$src" ] || { log_skip "missing in repo: $rel"; return 0; }
  mkdir -p "$(dirname "$dest")"
  if [ -L "$dest" ]; then
    [ "$(readlink "$dest")" = "$src" ] && { log_skip "already linked: $rel"; return 0; }
    rm "$dest"
  elif [ -e "$dest" ]; then
    mv "$dest" "$dest.bak"
    log_ok "backed up existing $rel -> $rel.bak"
  fi
  ln -s "$src" "$dest"
  log_ok "linked $rel"
}

# Symlink each top-level entry inside SRC/$1 into DEST/$1, preserving any
# entries that exist only on this machine (e.g. local-only skills/agents).
link_contents() {
  local dir="$1" entry
  [ -d "$SRC/$dir" ] || return 0
  mkdir -p "$DEST/$dir"
  for entry in "$SRC/$dir"/*; do
    [ -e "$entry" ] || continue
    link "$dir/$(basename "$entry")"
  done
}

# --- static, user-authored config: symlinked ---
link_contents hooks
link_contents skills
link_contents agents     # no-op until the repo tracks any
link_contents commands   # no-op until the repo tracks any
link statusline-command.sh
link CLAUDE.md

# executables (chmod the real files behind the symlinks)
[ -e "$SRC/statusline-command.sh" ]  && chmod +x "$SRC/statusline-command.sh"

# --- settings.json: portable baseline, copied (never symlinked) ---
if [ ! -e "$DEST/settings.json" ]; then
  cp "$SRC/settings.json" "$DEST/settings.json"
  log_ok "installed settings.json baseline"
elif [ "$FORCE" -eq 1 ]; then
  cp "$DEST/settings.json" "$DEST/settings.json.bak"
  cp "$SRC/settings.json" "$DEST/settings.json"
  log_ok "re-synced settings.json baseline (backup: settings.json.bak)"
else
  log_skip "settings.json exists — Claude manages it at runtime (use --force to re-sync baseline)"
fi

# settings.local.json is machine-local — never created or overwritten here.
[ -e "$DEST/settings.local.json" ] && log_skip "preserving machine-local settings.local.json"

log_ok "claude config installed"
