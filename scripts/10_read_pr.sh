#!/usr/bin/env bash
set -euo pipefail
source "$GITHUB_ACTION_PATH/scripts/_lib.sh"
: "${WORKDIR:?WORKDIR required}"
ensure_dir "$WORKDIR"


# 이벤트 페이로드(JSON)에서 PR 필드 추출
PR_TITLE=$(jq -r '.pull_request.title // ""' "$GITHUB_EVENT_PATH")
PR_BODY_RAW=$(jq -r '.pull_request.body // ""' "$GITHUB_EVENT_PATH")
PR_NUMBER=$(jq -r '.pull_request.number // empty' "$GITHUB_EVENT_PATH")
[ -z "${PR_NUMBER:-}" ] && die "No pull_request context. Run on pull_request events."


printf '%s' "$PR_TITLE" > "$WORKDIR/pr_title.txt"
printf '%s' "$PR_BODY_RAW" > "$WORKDIR/pr_body_raw.txt"
printf '%s' "$PR_NUMBER" > "$WORKDIR/pr_number.txt"