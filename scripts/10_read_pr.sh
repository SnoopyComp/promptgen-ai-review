#!/usr/bin/env bash
set -euo pipefail
source "$GITHUB_ACTION_PATH/scripts/_lib.sh"
: "${WORKDIR:?WORKDIR required}"
: "${MAX_BYTES_PR:?MAX_BYTES_PR required}"
ensure_dir "$WORKDIR"

#Debug
echo "EVENT_NAME=$GITHUB_EVENT_NAME"
jq '{has_pull_request: has("pull_request"), pr_keys: (.pull_request|keys?)}' "$GITHUB_EVENT_PATH"

# 이벤트 페이로드(JSON)에서 PR 필드 추출
PR_TITLE=$(jq -r '.pull_request.title // ""' "$GITHUB_EVENT_PATH")
PR_BODY_RAW=$(jq -r '.pull_request.body // ""' "$GITHUB_EVENT_PATH")
PR_NUMBER=$(jq -r '.pull_request.number // empty' "$GITHUB_EVENT_PATH")
[ -z "${PR_NUMBER:-}" ] && die "No pull_request context. Run on pull_request events."

PR_BODY_TRIM=$(printf '%s' "$PR_BODY_RAW" | trim_bytes "$MAX_BYTES_PR")

printf '%s' "$PR_TITLE" > "$WORKDIR/pr_title.txt"
printf '%s' "$PR_BODY_RAW" > "$WORKDIR/pr_body_raw.txt"
printf '%s' "$PR_BODY_TRIM" > "$WORKDIR/pr_body_trim.txt"
printf '%s' "$PR_NUMBER" > "$WORKDIR/pr_number.txt"