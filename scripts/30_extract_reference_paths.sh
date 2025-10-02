#!/usr/bin/env bash
set -euo pipefail
source "$GITHUB_ACTION_PATH/scripts/_lib.sh"
: "${WORKDIR:?WORKDIR required}"
BODY="$WORKDIR/pr_body_raw.txt"
[ -f "$BODY" ] || die "Missing $BODY"


: > "$WORKDIR/refs.txt"
# reference={a, b/c.md}
while IFS= read -r line; do
inside="${line#*\{}"; inside="${inside%%}*}"
IFS=',' read -ra arr <<< "$inside"
for p in "${arr[@]}"; do
p_trim="$(echo "$p" | xargs)"
[ -n "$p_trim" ] && echo "$p_trim" >> "$WORKDIR/refs.txt"
done
done < <(grep -Eoi 'reference=\{[^}]+' "$BODY")