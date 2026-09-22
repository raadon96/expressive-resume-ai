#!/usr/bin/env bash
# Leak guard shared by hooks/pre-commit, hooks/pre-push and sync-up.sh.
# Sourced, never executed. Reads the Personal Paths from sync.conf.
#
# One rule: Personal Paths (other than their .gitkeep) never travel with Shared
# Paths. A commit is either personal or shared, so any shared commit can be
# cherry-picked to the Public Template Repo safely, and nothing personal can
# reach it.

GUARD_REPO_DIR="$(git rev-parse --show-toplevel)"
# shellcheck source=sync.conf
source "$GUARD_REPO_DIR/sync.conf"

RED='\033[0;31m'
NC='\033[0m'

guard_fail() { echo -e "${RED}[guard]${NC} $1" >&2; }

# is_personal_path <path>
# True when <path> lives under a Personal Path and is not that path's .gitkeep.
is_personal_path() {
    local path="$1" p
    for p in "${PERSONAL_PATHS[@]}"; do
        [ "$path" = "$p/.gitkeep" ] && return 1
        case "$path" in
            "$p"/*) return 0 ;;
        esac
    done
    return 1
}

# split_paths
# Reads one path per line on stdin; fills PERSONAL_FILES and SHARED_FILES.
split_paths() {
    PERSONAL_FILES=()
    SHARED_FILES=()
    local f
    while IFS= read -r f; do
        [ -n "$f" ] || continue
        if is_personal_path "$f"; then
            PERSONAL_FILES+=("$f")
        else
            SHARED_FILES+=("$f")
        fi
    done
}

# report_mixed
# Explains a refused mixed commit using PERSONAL_FILES and SHARED_FILES.
report_mixed() {
    guard_fail "Refused: Personal Paths and Shared Paths in the same change."
    echo "  Personal Paths must never share a commit with anything else, so any" >&2
    echo "  commit can be cherry-picked to the Public Template Repo safely." >&2
    echo "" >&2
    echo "  Personal:" >&2
    printf '    %s\n' "${PERSONAL_FILES[@]}" >&2
    echo "  Shared:" >&2
    printf '    %s\n' "${SHARED_FILES[@]}" >&2
}

# guard_range <git log args...>
# Refuses (returns 1, with an explanation) when any commit in the given range
# changes a Personal Path. Used for anything headed to the Public Template Repo.
guard_range() {
    split_paths < <(git log --format= --name-only --no-renames "$@")
    if [ "${#PERSONAL_FILES[@]}" -gt 0 ]; then
        guard_fail "Refused: the following commits change a Personal Path."
        echo "  Only Shared Paths may reach the Public Template Repo:" >&2
        printf '    %s\n' "${PERSONAL_FILES[@]}" >&2
        return 1
    fi
    return 0
}
