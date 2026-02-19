# ADR-0016: Context Loading Verification for Language Standards

## Status

Accepted

## Date

2026-01-30

## Context

The agent's context loading logic for language-specific standards (STANDARDS_BASH.md, STANDARDS_POWERSHELL.md, etc.) made assumptions about file presence instead of verifying actual file types exist. The conditional gate language "if Bash detected" was interpreted as inference permission rather than a verification requirement.

**Example Failure:** Agent loaded STANDARDS_BASH.md and claimed Bash files existed based on macOS environment context, then had to backtrack when pressed for file locations — no .sh files exist in the workspace.

**Contributing Factors:**

- macOS environment bias (Unix-based = bash assumption)
- Truncated workspace warnings treated as inference permission instead of verification triggers
- Cross-platform persona framing mentioning "bash or pwsh" subtly suggested Bash is always present
- Conditional gate "if detected" was interpreted as "probably load" instead of "verify then load"

## Decision

Enforce systematic verification before loading language-specific standards:

1. The `/context` command MUST run `file_search` for language-specific file patterns (`**/*.ps1`, `**/*.sh`, `**/*.py`) before loading corresponding standards
2. Context reports MUST explicitly state detection status with ✓/✗ notation
3. When loading standards without code presence (e.g., for governance review), transparent assumptions MUST be stated
4. Truncated workspace views trigger verification, not inference
5. "If detected" conditional gates mean "verify then load," not "probably load"

## Consequences

**Positive:**

- Eliminates false confidence in file presence claims
- Aligns with STANDARDS_CORE.md precision principle
- Improves user trust in context reports
- Prevents wasted time on non-existent codebases

**Negative:**

- Adds file_search overhead to `/context` command (minimal performance impact)
- Slightly more verbose context reports

**Risks:**

- None identified; improves accuracy without breaking existing workflows

## Compliance

- **Standards:** [COMPLETE] Aligns with STANDARDS_CORE.md precision principle ("trust verification over inference")
- **Governance:** [COMPLETE] Affects `.github/copilot-instructions.md`; follows SPEC_PROTOCOL hard gate (plan approved)

## Implementation Notes

**Modified Files:**

- `.github/copilot-instructions.md` (Command: /context section)

**Changes:**

- Add file_search verification step before loading language standards
- Update output format with ✓/✗ detection indicators
- Add transparent assumption clause for edge cases

**Source Plan:**

- `.github/prompts/scribe-plan-20260130-context-loading-verification.md`
