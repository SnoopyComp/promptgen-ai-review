#!/usr/bin/env bash
set -euo pipefail
source "$GITHUB_ACTION_PATH/scripts/_lib.sh"
: "${WORKDIR:?WORKDIR required}"
: "${OUT:?OUT required}"
: "${MAX_PR:?MAX_PR required}"
: "${USE_ISSUE:?USE_ISSUE}"
: "${USE_REFERENCE:?USE_REFERENCE}"
: "${REVIEW_INSTRUCTIONS:?REVIEW_INSTRUCTIONS}"

PR_TITLE=$(cat "$WORKDIR/pr_title.txt")
PR_NUMBER=$(cat "$WORKDIR/pr_number.txt")
PR_BODY_TRIM=$(cat "$WORKDIR/pr_body_trim.txt")

use_issue="${USE_ISSUE,,}"
use_ref="${USE_REFERENCE,,}"

scope_line="Use only the PR details included below."
if [[ "$use_issue" == "true" && "$use_ref" == "true" ]]; then
  scope_line="Use the PR details, the linked issue(s), and the reference files included below."
elif [[ "$use_issue" == "true" && "$use_ref" != "true" ]]; then
  scope_line="Use the PR details and the linked issue(s) included below."
elif [[ "$use_issue" != "true" && "$use_ref" == "true" ]]; then
  scope_line="Use the PR details and the reference files included below."
fi

{
    echo "#LLM Code Review Prompt"
    echo

    # Instructions (always present)
    echo "## Instructions"
    cat <<EOF
You are a senior software engineer acting as a code reviewer.
Scope: $scope_line
Focus on correctness, security, performance, readability, edge cases, and test coverage. Prefer minimal, concrete suggestions.
If a section titled "User Instructions" appears below, you must follow it strictly.
EOF
    echo

    # User-provided instructions (optional, must be followed)
    if [ -n "$REVIEW_INSTRUCTIONS" ]; then
        echo "### User Instructions"
        printf '%s\n\n' "$REVIEW_INSTRUCTIONS"
    fi

    # Associated Issue (conditional)
    if [[ "$use_issue" == "true" ]]; then
        echo "## Associated Issue"
        if [ -d "$WORKDIR/issues" ] && ls "$WORKDIR/issues"/*.md >/dev/null 2>&1; then
            cat "$WORKDIR/issues"/*.md
        else
            echo "_No issues referenced via PR body._"
            echo
        fi
        echo
    fi


    echo "##PR"
    echo "###Title: $PR_TITLE"
    echo
    echo "###PR number: $PR_NUMBER"
    echo
    echo "###PR body:"
    printf '%s\n\n' "$PR_BODY_TRIM"


    # Reference
    if [[ "$use_ref" == "true" ]]; then
        echo "## Reference"
        if ls "$WORKDIR/refs"/*.txt >/dev/null 2>&1; then
            cat "$WORKDIR/refs"/*.txt
        else
            echo "_No reference markers found. Add \`reference={path}\` in PR body._"
        fi
        echo
    fi
} > "$OUT"