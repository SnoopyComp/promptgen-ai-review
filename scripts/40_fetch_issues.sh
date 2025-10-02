#!/usr/bin/env bash
set -euo pipefail
source "$GITHUB_ACTION_PATH/scripts/_lib.sh"
: "${WORKDIR:?WORKDIR required}"
: "${MAX_BYTES_ISSUE:?MAX_BYTES_ISSUE required}"
ensure_dir "$WORKDIR/issues"


if [ ! -s "$WORKDIR/issues.txt" ]; then
    # no issues
    exit 0
fi


while IFS= read -r issue_num; do
    [ -z "$issue_num" ] && continue
    if issue_json=$(gh issue view "$issue_num" --json number,title,body 2>/dev/null); then
        num=$(jq -r '.number' <<< "$issue_json")
        title=$(jq -r '.title // ""' <<< "$issue_json")
        body_raw=$(jq -r '.body // ""' <<< "$issue_json")
    else
        num="$issue_num"; title=""; body_raw=""
    fi
    body_trim=$(printf '%s' "$body_raw" | trim_bytes "$MAX_BYTES_ISSUE")
    {
        echo "### #$num — $title"
        [ -n "$body_trim" ] && printf '%s\n' "$body_trim" || echo "_(empty body)_"
        echo
    } > "$WORKDIR/issues/$issue_num.md"
done < "$WORKDIR/issues.txt"