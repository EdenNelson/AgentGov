# Quality Validation Hooks - Quick Start

## What Was Created

A complete PostToolUse hook system that automatically validates file edits:

```text
.github/
├── hooks/
│   ├── quality-validation.json       ← Hook configuration (auto-loads in VS Code)
│   └── README.md                     ← Full documentation
├── scripts/
│   ├── validate-file.sh              ← Hook dispatcher [✓ tested]
│   ├── validate-markdown.sh          ← Markdown validator [✓ tested]
│   ├── validate-bash.sh              ← Bash validator [✓ tested]
│   └── validate-powershell.sh        ← PowerShell validator
└── config/
    └── markdownlint.json             ← Markdown linting rules
```

## How It Works

1. **Agent edits a file** (create, replace, multi-replace)
2. **PostToolUse hook fires automatically** in VS Code
3. **Dispatcher routes to validator** based on file extension
4. **Validator checks compliance:**
   - [COMPLETE] **Pass:** Agent continues normally
   - [REJECTED] **Fail:** Error context injected → Agent fixes automatically

## Validation Rules

### Markdown (`*.md`)

- CommonMark spec compliance
- Blank lines around headings/lists
- Language tags in code blocks (`\`\`\`bash` not `\`\`\``)
- Final newline, no emojis

### Bash (`*.sh`)

- Shebang: `#!/bin/bash`
- Strict mode: `set -euo pipefail`
- IFS declaration: `IFS=$'\n\t'`
- (Plus shellcheck if installed)

### PowerShell (`*.ps1`, `*.psm1`, `*.psd1`)

- **PSScriptAnalyzer static analysis** (**REQUIRED**):
  - Cmdlet best practices
  - Parameter validation
  - Performance issues
  - Security checks
- Line endings: LF (default) or CRLF with marker
- Encoding: UTF-8
- Use `Write-Verbose` not `Write-Host`
- Explicit parameter names

**Note:** PowerShell validation will **fail** if PSScriptAnalyzer is not installed.

## Testing

```bash
# Test validators manually
.github/scripts/validate-markdown.sh README.md
.github/scripts/validate-bash.sh .github/scripts/validate-file.sh
.github/scripts/validate-powershell.sh script.ps1

# Test hook dispatcher
echo '{"tool_name": "replace_string_in_file", "tool_input": {"filePath": "README.md"}}' | \
  .github/scripts/validate-file.sh
```

## Installation of Enhanced Tools (Optional)

Markdown and Bash validation work with basic fallback checks. For deeper analysis:

```bash
# Markdown (enhanced validation)
npm install -g markdownlint-cli

# Bash (catches subtle issues)  
brew install shellcheck  # macOS
# or: apt-get install shellcheck  # Linux
```

## PowerShell Validation (REQUIRED)

**PSScriptAnalyzer is mandatory for PowerShell file validation:**

```bash
pwsh -Command "Install-Module -Name PSScriptAnalyzer -Scope CurrentUser -Force"
```

**PSScriptAnalyzer provides:**

- Static code analysis with Error and Warning severity levels
- Rule-based checks (PSAvoidUsingCmdletAliases, PSUseDeclaredVarsMoreThanAssignments, etc.)
- Security and performance issue detection
- Best practice enforcement

**Without PSScriptAnalyzer, PowerShell file edits will trigger validation failures with installation instructions.**

## Viewing Hook Activity

**Output Panel:**

- Open: Cmd+Shift+U (Mac) or Ctrl+Shift+U (Windows/Linux)
- Select: **GitHub Copilot Chat Hooks**
- View: Real-time validation results

**Diagnostics:**

- Right-click in Chat view → **Diagnostics**
- Check: **hooks** section for loaded hooks

## Temporarily Disable

```bash
# Disable all validation
mv .github/hooks/quality-validation.json \
   .github/hooks/quality-validation.json.disabled

# Re-enable
mv .github/hooks/quality-validation.json.disabled \
   .github/hooks/quality-validation.json
```

## Integration with AgentGov Standards

This system enforces:

- **SPEC_PROTOCOL § 2.3** (Completion Validation)
  - "Run linters on all new and modified files"
  - "No file with lint/compliance errors can be marked complete"

- **GENERAL_CODING § 1.3** (Markdown Hygiene)
  - CommonMark specification compliance
  - Blank lines, language tags, final newlines

- **BASH_STANDARDS § 1.1** (Safety Net Header)
  - Strict mode: `set -euo pipefail`
  - IFS declaration

- **POWERSHELL_STANDARDS § File Encoding**
  - LF line endings (idempotency by default)
  - UTF-8 encoding
  - Explicit parameter names

## What Happens During Agent Sessions

```text
┌─────────────────────────────────────┐
│ Agent: edit file (markdown/bash/ps1)│
└─────────────────┬───────────────────┘
                  ↓
         ┌────────────────┐
         │ PostToolUse Hook│  [Auto-fires]
         └────────┬────────┘
                  ↓
         ┌────────────────┐
         │   Dispatcher    │  [Routes by extension]
         └────────┬────────┘
                  ↓
         ┌────────────────┐
         │    Validator    │  [Checks compliance]
         └────────┬────────┘
                  ↓
         ┌────────────────┐
    [COMPLETE]  │      Pass       │  → Continue
         └────────────────┘
                  OR
         ┌────────────────┐
    [REJECTED]  │      Fail       │  → Inject error context
         └────────┬────────┘
                  ↓
         ┌────────────────┐
         │ Agent Auto-Fixes│  [Uses injected context]
         └─────────────────┘
```

## Status

- [COMPLETE] PostToolUse hook configured
- [COMPLETE] Dispatcher script tested
- [COMPLETE] Markdown validator tested
- [COMPLETE] Bash validator tested
- [COMPLETE] PowerShell validator created
- [COMPLETE] Markdownlint config created
- [COMPLETE] Full documentation written
- [COMPLETE] Integration with AgentGov governance verified

## Next Steps

The system is ready to use immediately. VS Code will auto-load hooks from `.github/hooks/*.json` when:

- VS Code 1.109.3+ is installed
- Agent hooks are enabled (org policy)
- Files are edited via agent tools

No additional setup required!

## Learn More

- Full docs: [.github/hooks/README.md](.github/hooks/README.md)
- PSScriptAnalyzer guide: [.github/hooks/PSSCRIPTANALYZER-GUIDE.md](.github/hooks/PSSCRIPTANALYZER-GUIDE.md)
- VS Code hooks: [Agent hooks documentation](https://code.visualstudio.com/docs/copilot/customization/hooks)
- AgentGov standards: [.github/instructions/](.github/instructions/)
