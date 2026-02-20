#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

# PreToolUse hook dispatcher: prep files before edits

input=$(cat)

tool_name=$(printf '%s' "$input" | jq -r '.tool_name // empty')
tool_input=$(printf '%s' "$input" | jq -r '.tool_input // {}')

if [[ "$tool_name" != "replace_string_in_file" && \
      "$tool_name" != "create_file" && \
      "$tool_name" != "multi_replace_string_in_file" && \
      "$tool_name" != "edit_notebook_file" ]]; then
  printf '{"continue": true}\n'
  exit 0
fi

files=()
if [[ "$tool_name" == "multi_replace_string_in_file" ]]; then
  while IFS= read -r file; do
    if [[ -n "$file" ]]; then
      files+=("$file")
    fi
  done < <(printf '%s' "$tool_input" | jq -r '.replacements[]?.filePath // empty' | sort -u)
else
  file=$(printf '%s' "$tool_input" | jq -r '.filePath // empty')
  if [[ -n "$file" ]]; then
    files=("$file")
  fi
fi

if [[ ${#files[@]} -eq 0 ]]; then
  printf '{"continue": true}\n'
  exit 0
fi

ps_files=()
for file in "${files[@]}"; do
  # Don't skip non-existent files: preToolUse runs BEFORE tool creates the file
  # If file doesn't exist yet but matches *.ps1|*.psm1|*.psd1, include it
  case "$file" in
    *.ps1|*.psm1|*.psd1)
      ps_files+=("$file")
      ;;
  esac
done

if [[ ${#ps_files[@]} -eq 0 ]]; then
  printf '{"continue": true}\n'
  exit 0
fi

# prep-powershell.sh handles non-existent files gracefully:
# - If file doesn't exist, it skips it (no-op)
# - If file exists, it processes it
if ! output=$(.github/scripts/prep-powershell.sh "${ps_files[@]}" 2>&1); then
  message=$(printf '%s\n' "PreToolUse: PowerShell prep failed." "$output" | jq -Rs .)
  printf '{\n'
  printf '  "hookSpecificOutput": {\n'
  printf '    "hookEventName": "PreToolUse",\n'
  printf '    "additionalContext": %s\n' "$message"
  printf '  },\n'
  printf '  "continue": false\n'
  printf '}\n'
  exit 0
fi

printf '{"continue": true}\n'
exit 0
