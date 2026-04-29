#!/usr/bin/env bash
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CLS_DIR="$REPO_DIR/src"
TEXMF_DIR="$HOME/texmf/tex/latex/expressive-resume-ai"
CLS_FILES=("Expressive.cls" "ExpressiveResume.cls" "ExpressiveCoverLetter.cls")

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

# ----- 1. Check LaTeX -----
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

# ----- 2. Symlink setup -----
echo ""
echo "--- Setting up .cls symlinks ---"

mkdir -p "$TEXMF_DIR"

all_ok=true
for cls in "${CLS_FILES[@]}"; do
    src="$CLS_DIR/$cls"
    dst="$TEXMF_DIR/$cls"

    if [ -L "$dst" ]; then
        current_target="$(readlink "$dst")"
        if [ "$current_target" = "$src" ]; then
            ok "$cls — already linked correctly, skipping"
        else
            warn "$cls — symlink exists but points to '$current_target' instead of '$src'"
            warn "       Run: ln -sf \"$src\" \"$dst\"  to fix manually"
            all_ok=false
        fi
    elif [ -e "$dst" ]; then
        warn "$cls — a non-symlink file already exists at '$dst'"
        warn "       Remove it manually and re-run this script"
        all_ok=false
    else
        ln -s "$src" "$dst"
        ok "$cls — symlink created"
    fi
done

# ----- 3. Refresh texmf index -----
echo ""
echo "--- Refreshing texmf index ---"
if mktexlsr "$HOME/texmf" &> /dev/null; then
    ok "mktexlsr completed"
else
    warn "mktexlsr failed — you may need to run it manually: mktexlsr ~/texmf"
fi

# ----- 4. Verify -----
echo ""
echo "--- Verifying ---"
if kpsewhich ExpressiveResume.cls &> /dev/null; then
    ok "LaTeX can find ExpressiveResume.cls"
else
    fail "LaTeX cannot find ExpressiveResume.cls — something went wrong"
    exit 1
fi

# ----- Summary -----
echo ""
if [ "$all_ok" = true ]; then
    echo -e "${GREEN}Setup complete. You're ready to build.${NC}"
else
    echo -e "${YELLOW}Setup completed with warnings. Review the messages above.${NC}"
fi
echo ""
