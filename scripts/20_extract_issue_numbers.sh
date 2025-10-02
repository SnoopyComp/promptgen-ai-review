#!/usr/bin/env bash
set -euo pipefail
source "$GITHUB_ACTION_PATH/scripts/_lib.sh"
: "${WORKDIR:?WORKDIR required}"
BODY="$WORKDIR/pr_body_raw.txt"
[ -f "$BODY" ] || die "Missing $BODY"


# close #123 / closes #123 / fix #123 / resolve #123 / bare #123
mapfile -t nums < <(grep -Eio '(close[sd]?|fix(e[sd])?|resolve[sd]?)?[[:space:]]*#[0-9]+' "$BODY" \
| grep -Eo '#[0-9]+' | tr -d '#' | awk '!seen[$0]++')


: > "$WORKDIR/issues.txt"
for n in "${nums[@]:-}"; do
    [ -n "$n" ] && echo "$n" >> "$WORKDIR/issues.txt"
done