#!/usr/bin/env bash
# Vendored from https://github.com/tomups/worktrees-scripts (wtremove.sh),
# itself based on https://github.com/llimllib/personal_code (rmtree).
#
# Local changes against upstream:
#
# 1. Upstream runs `rm -rf` on the directory and then `git branch -D`, which deliberately
#    bypasses git's refusal to drop a worktree holding uncommitted work, and force-deletes
#    the branch whether or not it is merged. Unmerged work went silently. Here the default
#    is `git worktree remove` + `git branch -d`, both of which refuse and say why; `-f`
#    restores the old behaviour for when you mean it.
#
# 2. Upstream derived the branch name from the directory name by turning every `_` back
#    into `/`, so a branch with a legitimate underscore (`feat/my_thing` -> directory
#    `feat_my_thing`) came back as `feat/my/thing` and deleted the wrong branch or none.
#    Here the branch is read from `git worktree list --porcelain`.

set -u

RED="\033[0;31m"
GREEN="\033[0;32m"
YELLOW="\033[0;33m"
CLEAR="\033[0m"
VERBOSE=
FORCE=

function usage {
    cat <<EOF
Usage: wtremove [-fvh] WORKTREE_NAME...
Remove a worktree, prune the worktree list, and delete its branch.

Refuses a worktree with uncommitted changes, and keeps a branch that is not
merged into HEAD, unless -f is given.

FLAGS:
  -h, --help     Print this help
  -v, --verbose  Verbose mode
  -f, --force    Discard uncommitted changes and force-delete the branch
EOF
    exit 1
}

function die {
    [ -n "$VERBOSE" ] && set +x
    printf '%b%s%b\n' "$RED" "$1" "$CLEAR"
    exit 1
}

function warn {
    printf '%b%s%b\n' "$YELLOW" "$1" "$CLEAR"
}

function note {
    printf '%b%s%b\n' "$GREEN" "$1" "$CLEAR"
}

# Absolute, symlink-resolved path, or empty if it does not exist.
function abs_path {
    ( cd "$1" 2>/dev/null && pwd -P )
}

# The branch checked out in the worktree at $1, read from git rather than guessed
# from the directory name. Empty if the worktree is detached or unknown to git.
function branch_for {
    local target=$1 path="" line
    while IFS= read -r line; do
        case $line in
            "worktree "*)
                path=${line#worktree }
                ;;
            "branch "*)
                if [ "$path" = "$target" ]; then
                    printf '%s\n' "${line#branch refs/heads/}"
                    return 0
                fi
                ;;
        esac
    done < <(git worktree list --porcelain)
    return 1
}

while true; do
    case ${1-} in
        help | -h | --help)
            usage
            ;;
        -v | --verbose)
            VERBOSE=true
            shift
            ;;
        -f | --force)
            FORCE=true
            shift
            ;;
        *)
            break
            ;;
    esac
done

[ $# -gt 0 ] || usage
[ -n "$VERBOSE" ] && set -x

git rev-parse --git-dir >/dev/null 2>&1 || die "Not inside a git repository"

# Run from a worktree and the trees are siblings; run from the bare root and they are children.
if [ "$(git rev-parse --is-inside-work-tree 2>/dev/null)" = true ]; then
    parent_dir=".."
    here=$(abs_path "$(git rev-parse --show-toplevel)")
else
    parent_dir="."
    here=
fi

while [ $# -gt 0 ]; do
    name=$1
    shift

    final_dir="$parent_dir/$name"
    if [ ! -d "$final_dir" ]; then
        warn "Unable to find directory $final_dir, skipping"
        continue
    fi

    target=$(abs_path "$final_dir")
    if [ -n "$here" ] && [ "$target" = "$here" ]; then
        die "$name is the worktree you are standing in. Run this from another one."
    fi

    branch=$(branch_for "$target") || branch=

    if [ -n "$FORCE" ]; then
        warn "removing $name (forced)"
        rm -rf "$final_dir"
        git worktree prune
        if [ -n "$branch" ]; then
            git branch -D "$branch"
        fi
        continue
    fi

    warn "removing $name"
    git worktree remove "$final_dir" || die \
        "$name has uncommitted changes. Commit them, or run: wtremove -f $name"
    git worktree prune

    if [ -z "$branch" ]; then
        note "removed $name (no branch to delete)"
        continue
    fi

    if git branch -d "$branch" 2>/dev/null; then
        note "removed $name and branch $branch"
    else
        warn "removed $name; kept branch $branch, which is not merged into HEAD."
        warn "Delete it with: git branch -D $branch"
    fi
done
