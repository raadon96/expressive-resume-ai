#!/usr/bin/env bash
# Prints a Profile file without its HTML comments, for reading it as a source
# for writing. The file stays unchanged.
# One file per call: combined output could exceed Claude Code's Bash output limit.
set -euo pipefail

if [ $# -ne 1 ]; then
    echo "Usage: src/read-profile.sh <file>"
    echo "Example: src/read-profile.sh data/profile/experience.md"
    exit 1
fi

# Perl is there wherever documents build: latexmk is a Perl script
perl -0pe 's/<!--.*?-->//gs' "$1"
