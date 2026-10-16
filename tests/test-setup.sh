#!/usr/bin/env bash
# Walks the setup steps in docs/guides/setup.md in a temp copy of the repo, so
# the real data/ stays untouched. A temp HOME and no TEXINPUTS/TEXMFHOME keep
# classes linked into a real ~/texmf by an older setup.sh from masking a broken
# src/latexmkrc.
# Fails on the first error. Linux only (GNU find), like CI.
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TMP_DIR="$(mktemp -d)"
trap 'rm -rf "$TMP_DIR"' EXIT
WORK_DIR="$TMP_DIR/expressive-resume-ai"
EXAMPLE_APP="26.04.26_mleng@examplecompany"

step() { echo ""; echo "=== $1 ==="; }
fail() { echo "[FAIL]  $1" >&2; exit 1; }
pass() { echo "[pass]  $1"; }
# Prints a path relative to the temp repo
rel() { echo "${1#"$WORK_DIR"/}"; }

# Prints a listing of every path under data/ with its size and modification time
snapshot_data() {
    (cd "$WORK_DIR/data" && find . -printf '%p %s %T@\n' | sort)
}

# Builds .tex files through src/build.sh from a working directory and checks
# each PDF exists and its page count line was printed
build_pdfs() {
    local cwd="$1" tex pdf output
    shift
    for tex in "$@"; do rm -f "$cwd/${tex%.tex}.pdf"; done
    output="$(cd "$cwd" && "$WORK_DIR/src/build.sh" "$@")" ||
        { echo "$output"; fail "src/build.sh $* failed in $(rel "$cwd")"; }
    echo "$output"
    for tex in "$@"; do
        pdf="${tex%.tex}.pdf"
        [ -f "$cwd/$pdf" ] || fail "no PDF built for $(rel "$cwd/$tex")"
        [[ "$output" == *"$pdf: "[0-9]*" page"* ]] || fail "no page count printed for $pdf"
        pass "built $(rel "$cwd/$pdf")"
    done
}

# The working tree minus everything gitignored, as CI would see it after committing.
# safe.directory: the checkout may belong to another user (CI container, Dev Container).
step "Copying the repo to $WORK_DIR"
mkdir -p "$WORK_DIR"
(
    cd "$REPO_DIR"
    git -c safe.directory="$REPO_DIR" ls-files -z -co --exclude-standard |
        while IFS= read -r -d '' f; do
            # Tracked files deleted in the working tree are still listed
            if [ -e "$f" ]; then printf '%s\0' "$f"; fi
        done |
        tar --null -T - -cf - | tar -xf - -C "$WORK_DIR"
)
[ ! -e "$WORK_DIR/data" ] || fail "data/ was copied into the temp repo"

export HOME="$TMP_DIR/home"
mkdir -p "$HOME"
unset TEXINPUTS TEXMFHOME

step "1. ./setup.sh"
"$WORK_DIR/setup.sh"
[ -d "$WORK_DIR/data" ] || fail "data/ missing"
git -C "$WORK_DIR/data" rev-parse --git-dir > /dev/null || fail "data/ is not a git repo"
[ "$(git -C "$WORK_DIR/data" rev-parse --show-toplevel)" = "$WORK_DIR/data" ] ||
    fail "data/ is not its own git repo"
# Process substitution, so fail exits the script and not a pipeline subshell
while IFS= read -r f; do
    cmp -s "$WORK_DIR/src/scaffold/data/$f" "$WORK_DIR/data/$f" ||
        fail "data/${f#./} differs from the Scaffold"
done < <(cd "$WORK_DIR/src/scaffold/data" && find . -type f)
diff -r "$WORK_DIR/example/profile" "$WORK_DIR/data/profile" > /dev/null ||
    fail "data/profile/ differs from example/profile/"
pass "data/ is a git repo with the Scaffold files and the example profile"

# The builds below then prove the classes come from src/latexmkrc
if kpsewhich ExpressiveResume.cls > /dev/null; then
    fail "LaTeX finds ExpressiveResume.cls without src/latexmkrc"
fi
pass "LaTeX can't find the classes without src/latexmkrc"

step "2. Building with src/build.sh"
build_pdfs "$WORK_DIR" src/scaffold/application/resume.tex src/scaffold/application/coverletter.tex
mkdir -p "$WORK_DIR/data/applications"
cp -R "$WORK_DIR/example/applications/$EXAMPLE_APP" "$WORK_DIR/data/applications/"
build_pdfs "$WORK_DIR" "data/applications/$EXAMPLE_APP/resume.tex"
# From inside the Data Repo, where git rev-parse can't find the Tool Repo
build_pdfs "$WORK_DIR/data" "applications/$EXAMPLE_APP/coverletter.tex"
build_pdfs "$WORK_DIR" example/templates/MLEng/resume.tex
if (cd "$WORK_DIR" && src/build.sh missing.tex > /dev/null); then
    fail "src/build.sh succeeded on a missing file"
fi
pass "src/build.sh fails on a missing file"

step "3. ./setup.sh again"
before="$(snapshot_data)"
"$WORK_DIR/setup.sh"
[ "$before" = "$(snapshot_data)" ] || fail "re-running setup.sh changed data/"
pass "re-run succeeded and left data/ untouched"

echo ""
echo "All setup tests passed."
