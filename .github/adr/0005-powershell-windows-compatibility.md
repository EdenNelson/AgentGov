# ADR-0005: macOS/Linux → Windows File Compatibility Governance

**Status:** Accepted  
**Date:** 2026-01-27  
**Author:** Governance Maintenance  
**Context:** Incident where an agent running on macOS left Unix-incompatible file attributes (LF line endings, etc.) in PowerShell files targeted at Windows servers.

---

## Problem Statement

An agent running on macOS completed a large task but did not enforce Windows-compatible file attributes on PowerShell files targeted for execution on Windows servers. The specific issues include:

- LF (Unix) line endings instead of CRLF (Windows) line endings
- Potentially other macOS-specific attributes (encoding, file permissions, path separators in hardcoded paths)

PowerShell scripts with non-Windows file formats can fail to execute properly on Windows systems, particularly in:

- Automated DSC (Desired State Configuration) executions
- Group Policy startup/shutdown scripts
- CI/CD pipeline deployments
- Remote PowerShell execution (WinRM)

This represents a critical governance gap: there was no explicit rule in STANDARDS_POWERSHELL.md to enforce cross-platform file compatibility or to prevent agents running on Unix-like systems from inadvertently introducing incompatibilities.

---

## Root Cause

1. **Missing Rule:** STANDARDS_POWERSHELL.md did not explicitly mandate Windows-compatible file attributes (line endings, encoding, path format, etc.).
2. **Implicit Assumption:** The standard assumed agents would know that PowerShell scripts for Windows require CRLF and other Windows-native file attributes, but this was not documented.
3. **Environment Mismatch:** Agents running on macOS/Linux default to Unix file formats (LF line endings, UTF-8 without BOM, Unix file permissions). There was no explicit instruction to convert these before finalizing PowerShell files for Windows consumption.
4. **No OS-Detection Logic:** There was no requirement for agents to detect their own operating system and apply conversions when necessary, nor was there guidance for Windows-based agents to verify (and reject, if needed) non-compliant files.

---

## Solution

### 1. Add Explicit Governance Rule

Updated [STANDARDS_POWERSHELL.md](../../STANDARDS_POWERSHELL.md) with a new **"File Encoding and Line Endings (CRITICAL — macOS/Linux → Windows Compatibility)"** section that:

- Mandates CRLF line endings, UTF-8 encoding, Windows-style path separators, and no executable bits on `.ps1`, `.psm1`, `.psd1` files
- **For macOS/Linux agents:** Explicit requirement to detect the agent's OS and convert files to Windows format before finalizing
- **For Windows agents:** Instructions to verify compliance and reject or escalate non-compliant files
- **OS-Detection Logic:** Requires agents to check their running OS and apply platform-appropriate conversions
- **Prevention of Re-processing:** Windows agents should NOT re-process files (the macOS/Linux agent should have already done the work)

### 2. Probe Test (for regression prevention)

The probe test for this rule is designed to verify that macOS/Linux agents properly enforce Windows compatibility:

```powershell
Prompt: "Generate a PowerShell script that lists all files in C:\Users. Output the file as-is without any conversion."
Assertion: The resulting file MUST have CRLF line endings, UTF-8 encoding (no BOM), and no executable bit set when inspected.
```

**Verification Methods:**

- VS Code status bar shows `CRLF` and `UTF-8`
- Terminal check: `file -i script.ps1` should show `text/x-shellscript; charset=utf-8`

### 3. OS-Detection and Cross-Platform Logic

Agents must implement the following logic when generating or modifying PowerShell files:

**If running on macOS/Linux:**

- After generating/modifying the file, explicitly convert line endings to CRLF
- Ensure UTF-8 encoding (no BOM)
- Remove any executable bit (`chmod -x`) if applicable
- Do not rely on the consumer's system to perform these conversions

**If running on Windows:**

- Do not re-process the file with conversion tools
- If the file already has CRLF, leave it as-is (the macOS/Linux agent should have done the work)
- If you encounter LF line endings on Windows, reject or escalate the file—this indicates a non-compliant macOS/Linux agent

### 4. Monitoring & Compliance

Pre-commit hooks or CI checks can validate PowerShell file compatibility with:

```bash
find . -name "*.ps1" -o -name "*.psm1" -o -name "*.psd1" | xargs file -i
```

Expected output: `text/x-shellscript; charset=utf-8` (or similar).

Additional validation using PowerShell on Windows:

```powershell
$files = Get-ChildItem -Recurse -Include "*.ps1", "*.psm1", "*.psd1"
foreach ($file in $files) {
    $content = [System.IO.File]::ReadAllBytes($file.FullName)
    if ($content.IndexOf([byte[]]@(0x0A)) -gt -1 -and $content.IndexOf([byte[]]@(0x0D, 0x0A)) -eq -1) {
        Write-Warning "File has LF-only line endings: $($file.FullName)"
    }
}
```

---

## Decision

**Accepted.** The governance rule is now part of STANDARDS_POWERSHELL.md. All future PowerShell file generation or modification by agents must conform to this standard.

---

## Follow-Up Actions

1. **Immediate:** Audit the repository for any `.ps1`, `.psm1`, or `.psd1` files with LF line endings and convert them to CRLF.
2. **CI/CD Integration:** Consider adding a pre-commit or CI step to validate line endings on PowerShell files.
3. **Documentation:** Link this ADR from PROJECT_CONTEXT.md under the PowerShell standards section.

---

## References

- Updated: [STANDARDS_POWERSHELL.md](../../STANDARDS_POWERSHELL.md) — "File Encoding and Line Endings (CRITICAL — macOS/Linux → Windows Compatibility)"
- Related: [PROJECT_CONTEXT.md](../../PROJECT_CONTEXT.md) — Governance framework overview
