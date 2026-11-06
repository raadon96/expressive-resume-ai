#!/usr/bin/env bash
# Checks that src/read-profile.sh hides HTML comments and leaves the file alone.
# Fails on the first error.
set -euo pipefail

SCRIPT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)/src/read-profile.sh"
TMP_DIR="$(mktemp -d)"
trap 'rm -rf "$TMP_DIR"' EXIT
FILE="$TMP_DIR/project.md"

fail() { echo "[FAIL]  $1" >&2; exit 1; }
pass() { echo "[pass]  $1"; }

cat > "$FILE" <<'EOF'
## What I Did
- Built the pipeline

<!--
## Results
- 17% faster
-->
## Skills & Technologies
- Tools: Airflow<!-- , Hidden Tool -->, YOLO
EOF
cp "$FILE" "$FILE.orig"

output="$("$SCRIPT" "$FILE")"

[[ "$output" != *"## Results"* && "$output" != *"17% faster"* ]] ||
    fail "a multi-line comment was printed"
[[ "$output" == *"## What I Did"*"## Skills & Technologies"* ]] ||
    fail "the text around a multi-line comment is missing"
pass "a multi-line comment is removed"

[[ "$output" == *"- Tools: Airflow, YOLO"* ]] ||
    fail "an inline comment wasn't removed cleanly: $output"
pass "an inline comment is removed"

cmp -s "$FILE.orig" "$FILE" || fail "the source file changed"
pass "the source file is unchanged"

echo ""
echo "All read-profile tests passed."
