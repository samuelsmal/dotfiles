#!/usr/bin/env bash
# Free disk space taken by Xcode and SwiftPM build output across every worktree of a repo.
#
# A directory is removed only when git reports it as ignored AND its name is a known build
# directory (see is_build_dir), so tracked or merely untracked work is never touched. Xcode's
# per-workspace folders in DerivedData are matched to the repo by the WorkspacePath in their
# info.plist, or, when Xcode wrote none, by the name of an .xcodeproj/.xcworkspace in the repo.

set -u

RED="\033[0;31m"
GREEN="\033[0;32m"
YELLOW="\033[0;33m"
BOLD="\033[1m"
CLEAR="\033[0m"
VERBOSE=
DRY_RUN=
YES=
SKIP_DERIVED=

function usage {
    cat <<EOF
Usage: wtclean [-nydvh] [PATH...]
Remove build output (build/, build-*/, DerivedData/, .build/) from every worktree of a
repository, together with the repo's folders in Xcode's DerivedData.

Without PATH, cleans the repository you are standing in (a worktree or the bare root).
A PATH is a repository, or a directory whose direct children are repositories, so
\`wtclean ~/proj/50_priv\` sweeps them all.

Lists what it found with sizes and asks before deleting anything.

FLAGS:
  -h, --help             Print this help
  -v, --verbose          Verbose mode
  -n, --dry-run          List only, delete nothing
  -y, --yes              Delete without asking
  -d, --no-derived-data  Leave ~/Library/Developer/Xcode/DerivedData alone
EOF
    exit 1
}

function die {
    [ -n "$VERBOSE" ] && set +x
    printf '%b%s%b\n' "$RED" "$1" "$CLEAR" >&2
    exit 1
}

function warn {
    printf '%b%s%b\n' "$YELLOW" "$1" "$CLEAR" >&2
}

function note {
    printf '%b%s%b\n' "$GREEN" "$1" "$CLEAR"
}

function is_build_dir {
    case $(basename "$1") in
        build | build-* | DerivedData | .build) return 0 ;;
        *) return 1 ;;
    esac
}

function human {
    awk -v k="$1" 'BEGIN {
        split("K M G T", u, " "); i = 1
        while (k >= 1024 && i < 4) { k /= 1024; i++ }
        printf (i == 1 ? "%d%s" : "%.1f%s"), k, u[i]
    }'
}

function size_kb {
    du -sk "$1" 2>/dev/null | awk '{print $1}'
}

function derived_data_root {
    local custom
    custom=$(defaults read com.apple.dt.Xcode IDECustomDerivedDataLocation 2>/dev/null) || custom=
    printf '%s\n' "${custom:-$HOME/Library/Developer/Xcode/DerivedData}"
}

# Worktree paths of the repo containing $1, one per line, bare repo excluded.
function worktrees_of {
    git -C "$1" worktree list --porcelain | awk '
        /^worktree / { path = substr($0, 10) }
        /^bare$/     { path = "" }
        /^$/         { if (path != "") print path; path = "" }
        END          { if (path != "") print path }'
}

# Repo roots to clean, one per line: the arguments themselves, or their direct children.
function resolve_repos {
    local arg child
    for arg in "$@"; do
        [ -d "$arg" ] || { warn "No such directory: $arg, skipping"; continue; }
        if git -C "$arg" rev-parse --git-dir >/dev/null 2>&1; then
            printf '%s\n' "$arg"
            continue
        fi
        for child in "$arg"/*/; do
            git -C "$child" rev-parse --git-dir >/dev/null 2>&1 && printf '%s\n' "${child%/}"
        done
    done
}

CANDIDATES=()
SEEN_REPOS=()

function add_candidate {
    local c
    for c in "${CANDIDATES[@]+"${CANDIDATES[@]}"}"; do
        [ "$c" = "$1" ] && return 0
    done
    CANDIDATES+=("$1")
}

function collect_repo {
    local repo=$1 common wt rel name dd plist ws base

    common=$(git -C "$repo" rev-parse --path-format=absolute --git-common-dir 2>/dev/null) || return 0
    for wt in "${SEEN_REPOS[@]+"${SEEN_REPOS[@]}"}"; do
        [ "$wt" = "$common" ] && return 0
    done
    SEEN_REPOS+=("$common")

    local worktrees=() names=()
    while IFS= read -r wt; do
        [ -d "$wt" ] && worktrees+=("$wt")
    done < <(worktrees_of "$repo")

    for wt in "${worktrees[@]+"${worktrees[@]}"}"; do
        while IFS= read -r -d '' rel; do
            rel=${rel%/}
            [ -d "$wt/$rel" ] && is_build_dir "$rel" && add_candidate "$wt/$rel"
        done < <(git -C "$wt" ls-files -z --others --ignored --exclude-standard --directory)

        while IFS= read -r name; do
            names+=("$(basename "${name%.*}")")
        done < <(find "$wt" -maxdepth 2 \( -name '*.xcodeproj' -o -name '*.xcworkspace' \) \
                     -not -path '*.xcodeproj/*' 2>/dev/null)
    done

    [ -n "$SKIP_DERIVED" ] && return 0
    dd=$(derived_data_root)
    [ -d "$dd" ] || return 0

    for plist in "$dd"/*/; do
        plist=${plist%/}
        case $plist in *.noindex) continue ;; esac
        ws=$(/usr/libexec/PlistBuddy -c 'Print :WorkspacePath' "$plist/info.plist" 2>/dev/null) || ws=
        if [ -n "$ws" ]; then
            for wt in "${worktrees[@]+"${worktrees[@]}"}"; do
                case $ws in "$wt" | "$wt"/*) add_candidate "$plist" ;; esac
            done
            continue
        fi
        # No info.plist: Xcode names the folder <workspace>-<28 letter hash>.
        base=$(basename "$plist")
        for name in "${names[@]+"${names[@]}"}"; do
            [[ $base =~ ^${name}-[a-z]{28}$ ]] && add_candidate "$plist"
        done
    done
}

while true; do
    case ${1-} in
        help | -h | --help) usage ;;
        -v | --verbose) VERBOSE=true; shift ;;
        -n | --dry-run) DRY_RUN=true; shift ;;
        -y | --yes) YES=true; shift ;;
        -d | --no-derived-data) SKIP_DERIVED=true; shift ;;
        -[!-]?*)
            # Split bundled short flags: -nd -> -n -d
            flags=${1#-}
            shift
            set -- $(printf -- '-%s ' $(echo "$flags" | fold -w1)) "$@"
            ;;
        -*) warn "Unknown flag: $1"; usage ;;
        *) break ;;
    esac
done

[ -n "$VERBOSE" ] && set -x

if [ $# -eq 0 ]; then
    git rev-parse --git-dir >/dev/null 2>&1 || die "Not inside a git repository. Pass a PATH."
    set -- "$PWD"
fi

while IFS= read -r repo; do
    collect_repo "$repo"
done < <(resolve_repos "$@")

if [ ${#CANDIDATES[@]} -eq 0 ]; then
    note "Nothing to clean."
    exit 0
fi

total=0
tilde='~'
echo ""
for c in "${CANDIDATES[@]}"; do
    kb=$(size_kb "$c")
    kb=${kb:-0}
    total=$((total + kb))
    printf '%8s  %s\n' "$(human "$kb")" "${c/#$HOME/$tilde}"
done
printf '\n%b%8s  total%b\n\n' "$BOLD" "$(human "$total")" "$CLEAR"

[ -n "$DRY_RUN" ] && exit 0

if pgrep -xq Xcode; then
    warn "Xcode is running. Close the affected projects first, or Xcode may rebuild into them."
fi

if [ -z "$YES" ]; then
    [ -t 0 ] || die "Not a terminal; pass -y to delete without asking."
    printf 'Delete these %d directories? [y/N] ' "${#CANDIDATES[@]}"
    read -r answer
    case $answer in
        y | Y | yes) ;;
        *) warn "Aborted, nothing deleted."; exit 1 ;;
    esac
fi

failed=0
for c in "${CANDIDATES[@]}"; do
    rm -rf "$c" || { warn "Could not remove $c"; failed=1; }
done

if [ $failed -eq 0 ]; then
    note "Freed $(human "$total")."
else
    warn "Some directories were not removed; see above."
    exit 1
fi
