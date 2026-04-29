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
APP_DIR="$REPO_DIR/applications/$DIR_NAME"

if [ -d "$APP_DIR" ]; then
    fail "Directory already exists: applications/$DIR_NAME"
fi

mkdir -p "$APP_DIR"

cat > "$APP_DIR/description.md" << 'EOF'
# Job Description

<!-- Paste the job description here -->
EOF

cat > "$APP_DIR/notes.md" << 'EOF'
# Notes

<!-- Interview prep, conversation logs, follow-up items -->
EOF

ok "Created applications/$DIR_NAME"
echo ""
echo "Next steps:"
echo "  1. Paste the job description into applications/$DIR_NAME/description.md"
echo "  2. Run: /review-job applications/$DIR_NAME"
echo "  Or:   /review-job  (interactive — paste description directly into Claude)"
