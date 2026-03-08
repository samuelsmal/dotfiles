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

  # Check for clean working tree
  if ! git diff --quiet --exit-code || ! git diff --cached --quiet --exit-code; then
    log_err "working tree has uncommitted changes — commit or stash first"
    exit 1
  fi

  # Read current version
  local current_version
  current_version=$(grep -oP '^VERSION="\K[^"]+' "$INSTALL_SH")
  log_ok "current version: ${current_version}"
  log_ok "new version:     ${version}"

  # Update VERSION in install.sh (portable across BSD and GNU sed)
  sed -i.bak "s/^VERSION=\".*\"/VERSION=\"${version}\"/" "$INSTALL_SH" && rm -f "${INSTALL_SH}.bak"
  log_ok "updated install.sh VERSION to ${version}"

  # Commit and tag
  git add "$INSTALL_SH"
  git commit -m "chore: bump version to v${version}"
  git tag "v${version}"

  log_ok "created tag v${version}"
  log_ok "done! Run 'git push && git push --tags' to publish."
}

main "$@"
