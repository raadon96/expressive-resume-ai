#!/usr/bin/env bash
# Leak guard shared by hooks/pre-commit, hooks/pre-push and sync-up.sh.
# Sourced, never executed. Every rule reads the Personal Paths from sync.conf.
#
# Two rules, applied to a set of changed files and their diff:
#   1. Path rule   — Personal Paths (other than their .gitkeep) never travel with
#                    Shared Paths: a commit is either personal or shared.
#   2. String rule — a shared diff must not contain the high-signal personal
#                    strings from profile/contact.md (full name, email, phone,
#                    LinkedIn/GitHub handles). This is what catches personal data
#                    typed *into* a shared file.

GUARD_REPO_DIR="$(git rev-parse --show-toplevel)"
# shellcheck source=sync.conf
source "$GUARD_REPO_DIR/sync.conf"

RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

guard_fail() { echo -e "${RED}[guard]${NC} $1" >&2; }
guard_note() { echo -e "${YELLOW}[guard]${NC} $1" >&2; }

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

# contact_field <label>
# Prints the value of a "- **<label>:** value" line from CONTACT_TEXT.
contact_field() {
    printf '%s\n' "$CONTACT_TEXT" | sed -n "s/^- \*\*$1:\*\* *//p" | head -n 1 | sed 's/[[:space:]]*$//'
}

# load_contact
# Fills CONTACT_TEXT with profile/contact.md. Prefers the copy tracked on main:
# in a Private Fork the file is committed there, and a sync-up branch (cut from
# upstream/main) has no profile/ in its working tree at all. Falls back to the
# working-tree file (the Public Template Repo checkout, where it is untracked).
# Returns 1 when there is nothing to load.
load_contact() {
    local contact="$GUARD_REPO_DIR/profile/contact.md"
    if git cat-file -e main:profile/contact.md 2> /dev/null; then
        CONTACT_TEXT="$(git show main:profile/contact.md)"
    elif [ -f "$contact" ]; then
        CONTACT_TEXT="$(cat "$contact")"
    else
        return 1
    fi
}

# regex_escape <string>
# Escapes <string> for use inside a grep -E pattern.
regex_escape() {
    printf '%s' "$1" | sed 's/[][\.*^$+?(){}|\\/]/\\&/g'
}

# personal_patterns
# Prints one case-insensitive grep -E pattern per line, derived from
# profile/contact.md. Prints nothing when contact.md is missing or still
# byte-identical to the shipped example — the example is not personal data, and
# grepping for "John Doe" would flag the Examples and the Scaffold themselves.
personal_patterns() {
    local example="$GUARD_REPO_DIR/examples/profile/contact.md"
    load_contact || return 0
    if [ -f "$example" ] && [ "$CONTACT_TEXT" = "$(cat "$example")" ]; then
        return 0
    fi

    local first last email phone handle digits
    first="$(contact_field "First name")"
    last="$(contact_field "Last name")"
    email="$(contact_field "Email")"
    phone="$(contact_field "Phone")"

    if [ -n "$first" ] && [ -n "$last" ]; then
        echo "$(regex_escape "$first")[[:space:]]+$(regex_escape "$last")"
    fi
    [ -n "$email" ] && regex_escape "$email" && echo
    # Phone: match the last 8 digits regardless of spacing/punctuation — the
    # tail is what "+49 170 123 4567" and "0170-1234567" have in common.
    digits="$(printf '%s' "$phone" | tr -cd '0-9')"
    digits="${digits: -8}"
    if [ "${#digits}" -ge 6 ]; then
        printf '%s' "$digits" | sed 's/./&[^0-9]*/g; s/\[\^0-9\]\*$//'
        echo
    fi
    for handle in "$(contact_field "LinkedIn")" "$(contact_field "GitHub")"; do
        [ -n "$handle" ] || continue
        echo "(^|[^[:alnum:]_])$(regex_escape "$handle")([^[:alnum:]_]|$)"
    done
}

# grep_added_lines
# Reads a unified diff on stdin; prints the added lines that match any personal
# pattern. Returns 0 when there is at least one hit, 1 otherwise.
grep_added_lines() {
    local patterns
    patterns="$(personal_patterns)"
    if [ -z "$patterns" ]; then
        cat > /dev/null
        return 1
    fi
    grep '^+' | grep -v '^+++' | grep -E -i -f <(printf '%s\n' "$patterns")
}

# report_mixed
# Explains a refused mixed commit/push using PERSONAL_FILES and SHARED_FILES.
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

# report_strings <matching lines>
report_strings() {
    guard_fail "Refused: personal strings from profile/contact.md found in a shared change."
    echo "  Name, email, phone or handles must not end up in a Shared Path:" >&2
    echo "" >&2
    printf '    %s\n' "$1" | cut -c1-120 >&2
}

# guard_range <git log args...>
# Applies both rules to every commit in the given range (as git log would list
# it). Returns 1 with an explanation when the range must not reach upstream.
guard_range() {
    split_paths < <(git log --format= --name-only --no-renames "$@")
    if [ "${#PERSONAL_FILES[@]}" -gt 0 ]; then
        guard_fail "Refused: the following commits change a Personal Path."
        echo "  Only Shared Paths may reach the Public Template Repo:" >&2
        printf '    %s\n' "${PERSONAL_FILES[@]}" >&2
        return 1
    fi
    local hits
    if hits="$(git log -p --format= --no-color --no-renames -U0 "$@" | grep_added_lines)"; then
        report_strings "$hits"
        return 1
    fi
    return 0
}
