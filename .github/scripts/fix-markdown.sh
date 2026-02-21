#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

# Markdown fixer: auto-corrects common markdown issues
# Purpose: Clean up files automatically before validation
# Args: $1 = file path

if [[ $# -lt 1 ]]; then
  printf 'Usage: %s <markdown-file>\n' "$0" >&2
  exit 1
fi

file="$1"

if [[ ! -f "$file" ]]; then
  printf 'File not found: %s\n' "$file" >&2
  exit 1
fi

# Ensure file ends with LF (not CRLF)
if file "$file" | grep -q 'CRLF'; then
  dos2unix "$file" 2>/dev/null || {
    # Fallback: use sed to convert CRLF to LF
    sed -i '' 's/$//' "$file"
  }
fi

# Fix 1: Replace prohibited emojis with text equivalents
# Must handle each emoji separately for reliable sed replacement
sed -i '' \
  's/✅/[COMPLETE]/g' \
  "$file"

sed -i '' \
  's/⏳/[PENDING]/g' \
  "$file"

sed -i '' \
  's/❌/[REJECTED]/g' \
  "$file"

sed -i '' \
  's/⚠️/[WARNING]/g' \
  "$file"

sed -i '' \
  's/🛑/[CRITICAL]/g' \
  "$file"

sed -i '' \
  's/🔍/[INVESTIGATE]/g' \
  "$file"

sed -i '' \
  's/📝/[NOTE]/g' \
  "$file"

sed -i '' \
  's/💡/[IDEA]/g' \
  "$file"

# Fix 2: Ensure file ends with exactly one newline (no blank lines at EOF)
# Remove all trailing whitespace first
sed -i '' -e :a -e '/^\s*$/d;N;ba' "$file" 2>/dev/null || true

# Then ensure single trailing newline
if [[ -n "$(tail -c 1 "$file")" ]]; then
  printf '\n' >> "$file"
fi

# Fix 3: Remove trailing whitespace from all lines
sed -i '' 's/[[:space:]]*$//' "$file"

# Fix 4: Ensure consistent spacing around fenced code blocks
# Add blank line before ```
sed -i '' '/^```/i\
' "$file" 2>/dev/null || true

# Success
exit 0
