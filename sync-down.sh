#!/usr/bin/env bash
# Pull-down: bring the Public Template Repo's improvements into this Private Fork.
#
#   git fetch upstream && git merge upstream/main   (into main)
#
# Merge, never rebase: the fork's main is a pushed, durable store — rebasing
# would force-push and replay every personal commit through conflicts. Upstream
# never tracks anything under a Personal Path, so the merge cannot conflict
# with your profile or applications.
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$REPO_DIR"

RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'

ok()   { echo -e "${GREEN}[ok]${NC}    $1"; }
fail() { echo -e "${RED}[error]${NC} $1" >&2; exit 1; }

if ! git remote get-url upstream &> /dev/null; then
    fail "no 'upstream' remote. Add the Public Template Repo first:
        git remote add upstream https://github.com/raadon96/expressive-resume-ai.git"
fi

if [ "$(git branch --show-current)" != "main" ]; then
    fail "switch to main first (git switch main) — pull-down merges into main only"
fi

if [ -n "$(git status --porcelain)" ]; then
    fail "working tree is not clean — commit or stash first"
fi

git fetch upstream
ok "fetched upstream"

if git merge-base --is-ancestor upstream/main HEAD; then
    ok "main already contains upstream/main — nothing to merge"
    exit 0
fi

git merge --no-edit upstream/main
ok "merged upstream/main into main — push when ready: git push origin main"
