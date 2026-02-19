#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

# PowerShell validator: checks line endings, encoding, and best practices
# Args: $1 = file path

if [[ $# -lt 1 ]]; then
  printf 'Usage: %s <powershell-file>\n' "$0" >&2
  exit 1
fi

file="$1"

if [[ ! -f "$file" ]]; then
  printf 'File not found: %s\n' "$file" >&2
  exit 1
fi

errors=()

# Check 1: Line endings should be LF by default (unless REQUIRES-CRLF marker present)
if grep -q 'REQUIRES-CRLF' "$file"; then
  # CRLF is required for this file
  if ! file "$file" | grep -q 'CRLF'; then
    errors+=("File marked REQUIRES-CRLF but uses LF line endings")
  fi
else
  # LF is required (default)
  if file "$file" | grep -q 'CRLF'; then
    errors+=("File uses CRLF line endings (should use LF unless marked REQUIRES-CRLF)")
  fi
fi

# Check 2: Should be UTF-8 encoded
if ! file -b --mime-encoding "$file" | grep -qE 'utf-8|us-ascii'; then
  errors+=("File encoding is not UTF-8")
fi

# Check 3: Basic PowerShell best practices
# Check for Write-Host (should prefer Write-Verbose)
if grep -E '^\s*Write-Host\s' "$file" | grep -qv '^\s*#'; then
  errors+=("Found Write-Host (prefer Write-Verbose for diagnostic messages)")
fi

# Check 4: Should use explicit parameter names
if grep -E '(Get-ChildItem|Get-Content|Set-Content|Copy-Item|Move-Item|Remove-Item)\s+[^-]' "$file" | grep -qv '^\s*#'; then
  errors+=("Found cmdlets without explicit parameter names (use -Path, -Filter, etc.)")
fi

# CRITICAL: PSScriptAnalyzer validation (REQUIRED for PowerShell files)
pssa_available=false
pssa_used=false

if ! command -v pwsh &>/dev/null; then
  errors+=("CRITICAL: PowerShell (pwsh) is not installed")
  errors+=("Install: brew install powershell")
elif ! pwsh -NoProfile -Command "Get-Module -ListAvailable -Name PSScriptAnalyzer" &>/dev/null; then
  errors+=("CRITICAL: PSScriptAnalyzer module is not installed")
  errors+=("PowerShell files REQUIRE PSScriptAnalyzer for comprehensive validation")
  errors+=("Install: pwsh -Command \"Install-Module -Name PSScriptAnalyzer -Scope CurrentUser -Force\"")
else
  pssa_available=true
  pssa_used=true
  
  # Run PSScriptAnalyzer with comprehensive severity levels
  ps_validation=$(pwsh -NoProfile -Command "
    Import-Module PSScriptAnalyzer -ErrorAction Stop
    \$results = Invoke-ScriptAnalyzer -Path '$file' -Severity Error,Warning -ExcludeRule PSAvoidUsingWriteHost
    if (\$results) {
      \$results | ForEach-Object {
        \$severity = \$_.Severity
        \$line = \$_.Line
        \$rule = \$_.RuleName
        \$message = \$_.Message
        Write-Output \"[\$severity] Line \$line (\$rule): \$message\"
      }
      exit 1
    } else {
      exit 0
    }
  " 2>&1) || {
    errors+=("PSScriptAnalyzer issues detected:")
    errors+=("$ps_validation")
  }
fi

# Report errors
if [[ ${#errors[@]} -gt 0 ]]; then
  printf 'PowerShell validation failed:\n' >&2
  for err in "${errors[@]}"; do
    printf '  - %s\n' "$err" >&2
  done
  printf '\nPowerShell standards require:\n' >&2
  printf '  - Line endings: LF (default) or CRLF with REQUIRES-CRLF marker\n' >&2
  printf '  - Encoding: UTF-8 without BOM\n' >&2
  printf '  - Use Write-Verbose instead of Write-Host\n' >&2
  printf '  - Use explicit parameter names (-Path, -Filter, etc.)\n' >&2
  printf '  - Use Join-Path for path construction\n' >&2
  printf '  - PSScriptAnalyzer must be installed (comprehensive validation REQUIRED)\n' >&2
  exit 1
fi

# Success: PSScriptAnalyzer validation passed
printf 'PowerShell validation passed (PSScriptAnalyzer): %s\n' "$file"
exit 0
