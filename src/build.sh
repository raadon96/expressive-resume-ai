#!/usr/bin/env bash
# Builds each .tex file into a PDF next to it with the Tool Repo's latexmkrc and
# prints its page count. Paths are relative to the working directory.
# No -e: a failed build must not stop the remaining files
set -uo pipefail

# Found from this script's path: inside the Data Repo, git rev-parse resolves
# to data/ (ADR-0001)
RC_FILE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/latexmkrc"

if [ $# -eq 0 ]; then
    echo "Usage: src/build.sh <file.tex> [<file.tex>…]"
    echo "Example: src/build.sh data/applications/<dir>/resume.tex data/applications/<dir>/coverletter.tex"
    exit 1
fi

failed=0
for tex in "$@"; do
    if [[ "$tex" != *.tex ]]; then
        echo "$tex: not a .tex file" >&2
        failed=1
        continue
    fi
    if [ ! -f "$tex" ]; then
        echo "$tex: no such file" >&2
        failed=1
        continue
    fi
    dir="$(dirname "$tex")"
    name="$(basename "$tex" .tex)"
    if output="$(cd "$dir" && latexmk -pdf -interaction=nonstopmode -halt-on-error \
            -r "$RC_FILE" "$name.tex" 2>&1)"; then
        # The latexmkrc cleanup sub prints "<name>.pdf: N pages"
        count="$(grep -m1 -F "$name.pdf: " <<< "$output" | sed 's/^.*: //')"
        echo "${tex%.tex}.pdf: ${count:-built, no page count}"
    else
        echo "${tex%.tex}.pdf: build failed" >&2
        # The log stays on failure: cleanup only runs after a successful build
        if [ -f "$dir/$name.log" ]; then
            grep -A 4 '^!' "$dir/$name.log" >&2
        else
            tail -n 20 <<< "$output" >&2
        fi
        failed=1
    fi
done
exit "$failed"
