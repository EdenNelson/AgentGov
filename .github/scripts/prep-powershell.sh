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

  has_signature=false
  if grep -qE '^# SIG # Begin signature block[[:space:]]*$' "$file"; then
    has_signature=true
  fi

  # Create temp file in SAME directory as target to ensure atomic mv
  # Use PID and RANDOM for uniqueness; avoid cross-filesystem non-atomic move
  file_dir=$(dirname "$file")
  file_name=$(basename "$file")
  temp_file="${file_dir}/.${file_name}.$$.$RANDOM.tmp"

  awk '
    BEGIN { in_sig = 0; found_start = 0; found_end = 0 }
    /^# SIG # Begin signature block[[:space:]]*$/ { in_sig = 1; found_start = 1; next }
    /^# SIG # End signature block[[:space:]]*$/ { in_sig = 0; found_end = 1; next }
    !in_sig { print }
    END {
      if (found_start && !found_end) {
        exit 2
      }
    }
  ' "$file" > "$temp_file" || {
    rm -f "$temp_file"
    printf 'Malformed signature block: %s\n' "$file" >&2
    errors=1
    continue
  }

  # Atomic replacement: only move if content changed
  # cmp -s returns 0 if files are identical (no change needed)
  if ! cmp -s "$temp_file" "$file"; then
    # Preserve original file permissions before atomic swap
    chmod --reference="$file" "$temp_file" 2>/dev/null || true
    
    # Atomic move operation (same filesystem guarantees atomicity)
    if ! mv "$temp_file" "$file"; then
      rm -f "$temp_file"
      printf 'Failed to update file: %s\n' "$file" >&2
      errors=1
      continue
    fi
  else
    # No changes needed, clean up temp file
    rm -f "$temp_file"
  fi
done

if [[ $errors -ne 0 ]]; then
  exit 1
fi

# Force filesystem sync to ensure file changes are written to disk before returning
# This prevents "file is newer" conflicts when the agent/editor checks the file immediately
if command -v sync &>/dev/null; then
  sync
fi
sleep 5
exit 0
