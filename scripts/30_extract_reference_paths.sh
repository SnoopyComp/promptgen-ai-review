#!/usr/bin/env bash
set -euo pipefail
source "$GITHUB_ACTION_PATH/scripts/_lib.sh"
: "${WORKDIR:?WORKDIR required}"
PR_BODY_FILE="$WORKDIR/pr_body_raw.txt"
[ -f "$PR_BODY_FILE" ] || die "Missing $PR_BODY_FILE"


: > "$WORKDIR/refs.txt"
python3 "$GITHUB_ACTION_PATH/scripts/parse_reference_paths.py" "$PR_BODY_FILE" > "$WORKDIR/refs.txt"
