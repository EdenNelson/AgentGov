# ADR-0018: PowerShell CRLF Requirement for Legacy 5.1 Compatibility

**Date:** January 30, 2026  
**Status:** Accepted  
**Deciders:** Eden Nelson

---

## Problem

STANDARDS_POWERSHELL.md previously mandated CRLF line endings for all PowerShell files, which conflicts with the desired default of idempotency and cross-platform consistency. PowerShell 7+ accepts LF/CRLF, but legacy Windows PowerShell 5.1 requirements exist only in specific contexts (Group Policy, DSC). The standard needed to reflect conditional CRLF usage rather than a blanket mandate.

---

## Decision

**Adopt a conditional CRLF policy with idempotency by default.**

- **Default:** Use LF for cross-platform idempotency.
- **Conditional CRLF:** Use CRLF only when explicitly required for legacy Windows PowerShell 5.1 contexts (Group Policy startup/shutdown scripts, DSC) or when explicitly stated by project context.
- **Marker Convention:** Scripts that require CRLF must declare it with a clear header marker.

---

## Consequences

### Positive

- Preserves idempotency by default across platforms
- Maintains legacy 5.1 compatibility when explicitly required
- Makes CRLF usage intentional and auditable

### Negative

- Requires explicit signaling when CRLF is needed
- Mixed environments must be deliberate about legacy targeting

---

## Implementation

### Changes Made

- Updated STANDARDS_POWERSHELL.md to set LF as the default for idempotency and require CRLF only when explicitly needed for legacy 5.1 contexts.
- Streamlined agent decision logic: removed platform-specific conversion instructions and VS Code user guidance; replaced with simple trigger detection (marker, PROJECT_CONTEXT.md, or user request).

### Files Modified

- [STANDARDS_POWERSHELL.md](../../STANDARDS_POWERSHELL.md) (File Encoding and Line Endings section)

---

## Related

- [Plan: Conditional CRLF for PowerShell 5.1 + Idempotency by Default](../prompts/plan-20260130-powershell-crlf-conditional-idempotency.prompt.md)
- [ADR-0005: PowerShell Windows Compatibility](0005-powershell-windows-compatibility.md)
