#!/usr/bin/env bash
set -euo pipefail
source "$GITHUB_ACTION_PATH/scripts/_lib.sh"
: "${WORKDIR:?WORKDIR required}"
: "${MAX_BYTES_REF:?MAX_BYTES_REF required}"
: "${FAIL_ON_MISSING:=false}"

ensure_dir "$WORKDIR/refs"


if [ ! -s "$WORKDIR/refs.txt" ]; then
    exit 0
fi


while IFS= read -r reference_path; do
    [ -z "$reference_path" ] && continue

  full_path="$GITHUB_WORKSPACE/$reference_path"
  output_path="$WORKDIR/refs/$(echo "$reference_path" | tr '/[:space:]:' '__-').txt"
    if [ -f "$full_path" ]; then
    {
      printf 'FILE: %s\n\n' "$reference_path"
      python3 "$GITHUB_ACTION_PATH/scripts/read_and_trim_file.py" "$MAX_BYTES_REF" "$full_path"
      printf '\n'
    } > "$output_path"
    else
        if [[ "${FAIL_ON_MISSING,,}" == "true" ]]; then
        die "Reference file not found: $reference_path"
        else
        printf 'FILE: %s (missing)\n\n' "$reference_path" > "$output_path"
        fi
    fi
done < "$WORKDIR/refs.txt"