#!/usr/bin/env bash
set -euo pipefail


ensure_dir(){ mkdir -p "$1"; }


die(){ echo "[ERROR] $*" >&2; exit 1; }


# 바이트 기준 안전 트림 (UTF-8)
trim_bytes(){
local max="$1"; shift || true
python3 - "$max" << 'PY'
import sys
maxb=int(sys.argv[1])
data=sys.stdin.buffer.read()
if len(data)<=maxb:
    sys.stdout.buffer.write(data)
else:
    sys.stdout.buffer.write(data[:maxb])
    sys.stdout.buffer.write(b"\n\n[...truncated...]\n")
PY
}

lang_from_ext(){
  local p="$1"; local ext="${p##*.}"; local lang=""
  # lowercasing with bash 4+, fallback 처리 가능
  local lower="${ext,,}"

  case "$lower" in
    js) lang=javascript;;
    jsx) lang=javascript;;
    ts) lang=typescript;;
    tsx) lang=typescript;;
    json) lang=json;;
    yml|yaml) lang=yaml;;
    md|markdown) lang=markdown;;
    puml|plantuml) lang=puml;;
    java) lang=java;;
    kt|kts) lang=kotlin;;
    py) lang=python;;
    sh|bash) lang=bash;;
    sql) lang=sql;;
    go) lang=go;;
    rs) lang=rust;;
    cpp|cc|cxx|hpp|hxx) lang=cpp;;
    c|h) lang=c;;
    cs) lang=csharp;;
    html) lang=html;;
    css) lang=css;;
    xml) lang=xml;;
    toml) lang=toml;;
    ini|cfg) lang=ini;;
    csv) lang=csv;;
    proto) lang=proto;;
    swift) lang=swift;;
    php) lang=php;;
    rb) lang=ruby;;
    scala) lang=scala;;
  esac
  echo "$lang"
}