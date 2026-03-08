#!/usr/bin/env bash
# Pre-commit hook: warns if install.sh is staged but VERSION wasn't updated
# via scripts/tag-release.sh
#
# Install: cp scripts/pre-commit-version-check.sh .git/hooks/pre-commit

# Only check if install.sh is staged
if ! git diff --cached --name-only | grep -q '^install.sh$'; then
  exit 0
fi

# Get the staged VERSION value from the diff
STAGED_VERSION=$(git diff --cached -- install.sh | grep -oP '^\+VERSION="\K[^"]+' || true)

# If VERSION line wasn't changed, no warning needed
if [ -z "$STAGED_VERSION" ]; then
  exit 0
fi

# Get latest tag for reference
LATEST_TAG=$(git describe --tags --abbrev=0 2>/dev/null || echo "none")

printf '\n[warn] install.sh VERSION changed to "%s" (latest tag: %s)\n' "$STAGED_VERSION" "$LATEST_TAG"
printf '[warn] If this is intentional, use: ./scripts/tag-release.sh %s\n\n' "$STAGED_VERSION"

# Warning only — don't block the commit
exit 0
