#!/usr/bin/env bash
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DATA_DIR="$REPO_DIR/data"

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

ok()   { echo -e "${GREEN}[ok]${NC}    $1"; }
warn() { echo -e "${YELLOW}[warn]${NC}  $1"; }
fail() { echo -e "${RED}[error]${NC} $1"; }

echo ""
echo "=== expressive-resume-ai setup ==="
echo ""

# ----- 1. Data Repo -----
echo "--- Setting up data/ ---"
if [ -e "$DATA_DIR" ]; then
    ok "found existing data/, leaving it untouched"
else
    mkdir -p "$DATA_DIR"
    cp -R "$REPO_DIR/src/scaffold/data/." "$DATA_DIR/"
    cp -R "$REPO_DIR/example/profile" "$DATA_DIR/profile"
    git -C "$DATA_DIR" init --quiet
    ok "created data/ from the scaffold and the example profile (git repo, no commits)"
    warn "data/profile/ is a fictional example: replace it with your own data (see README.md, Setup step 4)"
    warn "Restoring a backup? Delete data/ and clone your Data Repo into it (see README.md, Setup on another machine)"
fi

# ----- 2. Check LaTeX -----
echo ""
echo "--- Checking LaTeX installation ---"
if command -v latexmk &> /dev/null; then
    ok "latexmk found: $(command -v latexmk)"
else
    fail "latexmk not found. Please install a LaTeX distribution before continuing:"
    echo ""
    echo "  Linux:  sudo apt install texlive-full latexmk"
    echo "  macOS:  https://www.tug.org/mactex/  (then: brew install latexmk)"
    echo ""
    exit 1
fi

echo ""
echo -e "${GREEN}Setup complete. You're ready to build.${NC}"
echo ""
