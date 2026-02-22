#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

# Markdown fixer: auto-corrects common markdown issues per markdown.instructions.md
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
    sed -i '' 's/\r$//' "$file"
  }
fi

# Fix 1: Replace prohibited emojis with text equivalents per markdown.instructions.md §2.2
sed -i '' 's/✅/[COMPLETE]/g' "$file"
sed -i '' 's/⏳/[PENDING]/g' "$file"
sed -i '' 's/❌/[REJECTED]/g' "$file"
sed -i '' 's/⚠️/[WARNING]/g' "$file"
sed -i '' 's/🛑/[CRITICAL]/g' "$file"
sed -i '' 's/🔍/[REVIEW]/g' "$file"
sed -i '' 's/📝/[NOTE]/g' "$file"
sed -i '' 's/💡/[TIP]/g' "$file"

# Fix 2: Convert Setext-style headings (=== and ---) to ATX-style (#, ##)
# Only convert if previous line has text content (not a horizontal rule)
# Process with awk to handle multi-line patterns
awk '
  NR > 1 && /^[=]+\s*$/ && prev_content !~ /^[[:space:]]*$/ {
    # Previous line was a level 1 heading (Setext style)
    # Only convert if prev line had actual text
    prev_line = prev_content
    sub(/^[=]+\s*$/, "")  # Clear this line
    print "# " prev_line
    prev_content = ""
    next
  }
  NR > 1 && /^[-]{3,}\s*$/ && prev_content !~ /^[[:space:]]*$/ && prev_content !~ /^#{1,6}\s/ {
    # Previous line was a level 2 heading (Setext style)
    # Only convert if:
    # - previous line had text (not blank)
    # - previous line is not already an ATX heading
    # - current line has 3+ dashes (Setext underline)
    prev_line = prev_content
    sub(/^[-]{3,}\s*$/, "")  # Clear this line
    print "## " prev_line
    prev_content = ""
    next
  }
  {
    if (NR > 1 && prev_content != "") {
      print prev_content
    }
    prev_content = $0
  }
  END {
    if (prev_content != "") print prev_content
  }
' "$file" > "${file}.tmp" && mv "${file}.tmp" "$file"

# Fix 3: Normalize unordered list markers (* and + to -)
# Preserve indentation, only match list markers (require space after marker)
# This prevents matching **bold** or *italic* at start of line
sed -i '' 's/^\(\s*\)\* /\1- /g' "$file"
sed -i '' 's/^\(\s*\)+ /\1- /g' "$file"

# Fix 4: Normalize blank lines around ATX headings (one blank line before and after)
# Use awk for multi-line pattern matching and reconstruction
awk '
  {
    if ($0 ~ /^#{1,6}\s/) {
      # This is a heading
      if (NR > 1 && prev_line != "" && prev_line !~ /^[[:space:]]*$/) {
        # Previous line is not blank; add blank line before heading
        print ""
      }
      print $0
      skip_next_blank = 0
    } else if (prev_line ~ /^#{1,6}\s/ && $0 ~ /^[[:space:]]*$/) {
      # Previous line was heading, current is blank; keep it
      print $0
      skip_next_blank = 1
    } else if (prev_line ~ /^#{1,6}\s/ && $0 !~ /^[[:space:]]*$/) {
      # Previous line was heading, current is content; ensure exactly one blank line
      print ""
      print $0
      skip_next_blank = 0
    } else if (skip_next_blank && $0 ~ /^[[:space:]]*$/) {
      # Skip extra blank lines after heading
      skip_next_blank = 1
    } else {
      print $0
      skip_next_blank = 0
    }
    prev_line = $0
  }
' "$file" > "${file}.tmp" && mv "${file}.tmp" "$file"

# Fix 5: Remove trailing whitespace from all lines
sed -i '' 's/[[:space:]]*$//' "$file"

# Fix 6: Ensure file ends with exactly one newline
if [[ -n "$(tail -c 1 "$file")" ]]; then
  printf '\n' >> "$file"
fi

exit 0
