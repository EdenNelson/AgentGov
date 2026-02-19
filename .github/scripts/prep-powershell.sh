#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

# Strip Authenticode signature blocks from PowerShell files

if [[ $# -lt 1 ]]; then
  printf 'Usage: %s <powershell-file> [more-files...]\n' "$0" >&2
  exit 1
fi

errors=0

for file in "$@"; do
  if [[ ! -f "$file" ]]; then
    printf 'File not found: %s\n' "$file" >&2
    errors=1
    continue
  fi

  case "$file" in
    *.ps1|*.psm1|*.psd1)
      ;;
    *)
      continue
      ;;
  esac

  if ! grep -q '^# SIG # Begin signature block$' "$file"; then
    continue
  fi

  tmp_file=$(mktemp)
  trim_file=$(mktemp)

  awk '
    BEGIN { in_sig = 0; found_start = 0; found_end = 0 }
    /^# SIG # Begin signature block$/ { in_sig = 1; found_start = 1; next }
    /^# SIG # End signature block$/ { in_sig = 0; found_end = 1; next }
    !in_sig { print }
    END {
      if (found_start && !found_end) {
        exit 2
      }
    }
  ' "$file" > "$tmp_file" || {
    rm -f "$tmp_file" "$trim_file"
    printf 'Malformed signature block: %s\n' "$file" >&2
    errors=1
    continue
  }

  awk '
    { lines[NR] = $0 }
    END {
      n = NR
      while (n > 0 && lines[n] ~ /^[[:space:]]*$/) {
        n--
      }
      for (i = 1; i <= n; i++) {
        print lines[i]
      }
      print ""
      print ""
    }
  ' "$tmp_file" > "$trim_file"

  mv "$trim_file" "$file"
  rm -f "$tmp_file"
  printf 'Stripped signature block: %s\n' "$file"
  done

if [[ $errors -ne 0 ]]; then
  exit 1
fi

exit 0
