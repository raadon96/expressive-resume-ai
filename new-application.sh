#!/usr/bin/env bash
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

ok()   { echo -e "${GREEN}[ok]${NC}    $1"; }
fail() { echo -e "${RED}[error]${NC} $1"; exit 1; }

if [ $# -ne 2 ]; then
    echo "Usage: ./new-application.sh <role> <company>"
    echo "Example: ./new-application.sh pydev yousician"
    exit 1
fi

ROLE="$1"
COMPANY="$2"
DATE_PREFIX="$(date +"%y.%m.%d")"
DIR_NAME="${DATE_PREFIX}_${ROLE}@${COMPANY}"
DATA_DIR="$REPO_DIR/data"
APP_DIR="$DATA_DIR/applications/$DIR_NAME"

if [ ! -d "$DATA_DIR" ]; then
    fail "no data/ found; run ./setup.sh first"
fi

if [ -d "$APP_DIR" ]; then
    fail "Directory already exists: data/applications/$DIR_NAME"
fi

mkdir -p "$APP_DIR"

cat > "$APP_DIR/description.md" << 'EOF'
# Job Description

<!-- Paste the job description here -->
EOF

ok "Created data/applications/$DIR_NAME"
echo ""
echo "Next steps:"
echo "  1. Paste the job description into data/applications/$DIR_NAME/description.md"
echo "  2. Run: /review-job data/applications/$DIR_NAME"
echo "  Or:   /review-job  (interactive — paste description directly into Claude)"
