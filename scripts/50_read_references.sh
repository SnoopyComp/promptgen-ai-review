#!/usr/bin/env bash
set -euo pipefail
source "$GITHUB_ACTION_PATH/scripts/_lib.sh"
: "${WORKDIR:?WORKDIR required}"
: "${MAX_REF:?MAX_REF required}"
: "${FAIL_ON_MISSING:=false}"
ensure_dir "$WORKDIR/refs"


if [ ! -s "$WORKDIR/refs.txt" ]; then
exit 0
fi


while IFS= read -r rp; do
[ -z "$rp" ] && continue
full="$GITHUB_WORKSPACE/$rp"
if [ -f "$full" ]; then
lang=$(lang_from_ext "$rp")
{
echo "### $rp"
echo "\`\`\`$lang"
python3 - "$MAX_REF" "$full" << 'PY'
import sys, pathlib
maxb=int(sys.argv[1]); path=pathlib.Path(sys.argv[2])
data=path.read_bytes()
if len(data)<=maxb:
sys.stdout.buffer.write(data)
else:
sys.stdout.buffer.write(data[:maxb])
sys.stdout.write("\n\n[...truncated...]\n")
PY
echo "\`\`\`"
echo
} > "$WORKDIR/refs/$(echo "$rp" | tr '/' '_').md"
else
if [[ "${FAIL_ON_MISSING,,}" == "true" ]]; then
die "Reference file not found: $rp"
else
{
echo "### $rp (missing)"
echo
} > "$WORKDIR/refs/$(echo "$rp" | tr '/' '_').md"
fi
fi
done < "$WORKDIR/refs.txt"