#!/usr/bin/env bash
# Push-up: send shared improvements from this Private Fork to the Public
# Template Repo as a pull request, without ever carrying personal data.
#
#   ./sync-up.sh --list                 candidate commits (on main, not yet on
#                                       upstream/main, touching only Shared Paths)
#   ./sync-up.sh [--branch <name>] <commit>…
#                                       cherry-pick the given commits onto a new
#                                       branch off upstream/main, run the leak
#                                       guard, push the branch to upstream and
#                                       open a PR against its main
#
# Selection stays explicit: --list prints candidates for copy-paste, it never
# picks for you. Prefer building a shared change in the public checkout first
# and pulling it down (sync-down.sh) when you know up front it is shared.
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$REPO_DIR"

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

ok()   { echo -e "${GREEN}[ok]${NC}    $1"; }
warn() { echo -e "${YELLOW}[warn]${NC}  $1"; }
fail() { echo -e "${RED}[error]${NC} $1" >&2; exit 1; }
usage() { sed -n '2,/^set -euo/p' "${BASH_SOURCE[0]}" | sed '$d' | sed 's/^# \{0,1\}//'; exit 1; }

# shellcheck source=hooks/guard-lib.sh
source "$REPO_DIR/hooks/guard-lib.sh"

# ----- Arguments -----
MODE="pick"
BRANCH=""
COMMITS=()
while [ $# -gt 0 ]; do
    case "$1" in
        --list)   MODE="list" ;;
        --branch) [ $# -ge 2 ] || usage; BRANCH="$2"; shift ;;
        -h|--help) usage ;;
        -*)       usage ;;
        *)        COMMITS+=("$1") ;;
    esac
    shift
done

# ----- Preconditions -----
UPSTREAM_URL="$(git remote get-url upstream 2> /dev/null)" \
    || fail "no 'upstream' remote. Add the Public Template Repo first:
        git remote add upstream https://github.com/raadon96/expressive-resume-ai.git"

# owner/repo from either git@github.com:owner/repo.git or https://github.com/owner/repo(.git)
UPSTREAM_REPO="$(printf '%s' "$UPSTREAM_URL" | sed -E 's#^.*github\.com[:/]##; s#\.git$##')"

git fetch --quiet upstream
ok "fetched upstream"

# ----- --list: candidate commits -----
if [ "$MODE" = "list" ]; then
    echo ""
    echo "Commits on main not on upstream/main that touch only Shared Paths:"
    echo ""
    found=false
    while read -r sha; do
        split_paths < <(git show --format= --name-only --no-renames "$sha")
        [ "${#PERSONAL_FILES[@]}" -eq 0 ] || continue
        [ "${#SHARED_FILES[@]}" -gt 0 ] || continue
        git log -1 --format='  %h  %ad  %s' --date=short "$sha"
        found=true
    done < <(git rev-list --reverse main ^upstream/main)
    if [ "$found" = false ]; then
        echo "  (none)"
    fi
    echo ""
    echo "Push up with:  ./sync-up.sh <sha> [<sha>…]"
    exit 0
fi

# ----- Cherry-pick branch -----
[ "${#COMMITS[@]}" -gt 0 ] || usage

if [ -n "$(git status --porcelain)" ]; then
    fail "working tree is not clean — commit or stash first"
fi

for c in "${COMMITS[@]}"; do
    git rev-parse --verify --quiet "$c^{commit}" > /dev/null || fail "not a commit: $c"
done

if [ -z "$BRANCH" ]; then
    BRANCH="sync-up/$(date +%Y%m%d)-$(git rev-parse --short "${COMMITS[-1]}")"
fi
ORIGINAL_BRANCH="$(git branch --show-current)"

git switch --quiet -c "$BRANCH" upstream/main
ok "created $BRANCH from upstream/main"

if ! git cherry-pick "${COMMITS[@]}"; then
    warn "cherry-pick stopped on a conflict. Resolve it, then finish by hand:"
    echo "        git cherry-pick --continue"
    echo "        git push upstream $BRANCH"
    echo "        gh pr create -R $UPSTREAM_REPO --base main --head $BRANCH --fill"
    echo "  or abandon with:  git cherry-pick --abort && git switch $ORIGINAL_BRANCH && git branch -D $BRANCH"
    exit 1
fi
ok "cherry-picked ${#COMMITS[@]} commit(s)"

# ----- Leak guard (the pre-push hook runs it again on push; this fails earlier and louder) -----
if ! guard_range upstream/main..HEAD; then
    echo "" >&2
    echo "  Branch $BRANCH was NOT pushed. Inspect it, or drop it with:" >&2
    echo "        git switch $ORIGINAL_BRANCH && git branch -D $BRANCH" >&2
    exit 1
fi
ok "leak guard passed"

# ----- Push + PR -----
git push upstream "$BRANCH"
ok "pushed $BRANCH to upstream"

PR_URL="https://github.com/$UPSTREAM_REPO/compare/main...$BRANCH"
if command -v gh &> /dev/null && gh pr create -R "$UPSTREAM_REPO" --base main --head "$BRANCH" --fill; then
    ok "pull request opened"
else
    warn "could not open the PR with gh — open it by hand: $PR_URL"
fi

git switch --quiet "$ORIGINAL_BRANCH"
ok "back on $ORIGINAL_BRANCH (local branch $BRANCH kept until the PR is merged)"
