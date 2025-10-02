#!/usr/bin/env bash
set -euo pipefail
source "$GITHUB_ACTION_PATH/scripts/_lib.sh"
: "${WORKDIR:?WORKDIR required}"
: "${OUT:?OUT required}"
: "${MAX_PR:?MAX_PR required}"


PR_TITLE=$(cat "$WORKDIR/pr_title.txt")
PR_NUMBER=$(cat "$WORKDIR/pr_number.txt")
PR_BODY_TRIM=$(cat "$WORKDIR/pr_body_trim.txt")


{
    echo "# LLM Review Prompt"
    echo

    echo "## Associated Issue"
    if [ -d "$WORKDIR/issues" ] && ls "$WORKDIR/issues"/*.md >/dev/null 2>&1; then
        cat "$WORKDIR/issues"/*.md
    else
        echo "_No issues referenced via PR body._"
        echo
    fi


    echo "## PR"
    echo "Title: $PR_TITLE"
    echo
    echo "PR number: $PR_NUMBER"
    echo
    echo "PR body"
    printf '%s\n\n' "$PR_BODY_TRIM"


    echo "## Reference"
    if [ -d "$WORKDIR/refs" ] && ls "$WORKDIR/refs"/*.md >/dev/null 2>&1; then
        cat "$WORKDIR/refs"/*.md
    else
        echo "_No reference markers found. Add \`reference={path}\` in PR body._"
    fi
} > "$OUT"