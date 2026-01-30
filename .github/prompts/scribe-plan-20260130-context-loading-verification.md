# Scribe Plan: Context Loading Verification for Language Standards

**Date:** 2026-01-30  
**Topic:** Agent context loading and language standards verification  
**Type:** Requirement Document (Pre-Planning Analysis)

---

## Problem Statement

The agent's context loading logic for language-specific standards (STANDARDS_BASH.md, STANDARDS_POWERSHELL.md, etc.) makes assumptions about file presence instead of verifying actual file types exist. When loading context, the agent infers which language standards to load based on environmental clues (macOS = bash), persona framing (cross-platform mentions), and logical reasoning, rather than using file_search to confirm actual code files are present.

**Example Failure:** Agent loaded STANDARDS_BASH.md, claimed Bash files existed, then had to backtrack when pressed for file locations — no .sh files exist in the workspace.

## User Intent

Enforce systematic verification before loading language-specific standards. The agent should:

1. Check for actual file presence using file_search (e.g., `**/*.ps1`, `**/*.sh`, `**/*.py`)
2. Report findings explicitly in context reports (✓ detected vs ✗ not detected)
3. Distinguish between verified facts and transparent assumptions
4. Treat truncated workspace views as verification triggers, not inference permission

## Contributing Factors (Agent's Confusion)

- **macOS environment bias:** Seeing "macOS" in system context triggered unconscious reasoning that "Unix-based = bash present"
- **Truncated workspace warning ignored:** The explicit note "view may be truncated, use tools to collect context" should have triggered verification but was treated as permission to infer instead
- **Cross-platform persona framing:** PERSONA.md mentions "PowerShell for Linux, macOS" and "bash or pwsh and a cron job," subtly suggesting Bash is always in the toolkit
- **Conditional gate misinterpreted:** Instructions state "STANDARDS_BASH.md (if Bash detected)" — the word "if" is a verification gate but was treated as "probably load" instead of "verify then load"

## Constraints

- Do not break existing context loading workflow (PERSONA.md, PROJECT_CONTEXT.md, SPEC_PROTOCOL.md, STANDARDS_CORE.md always load)
- Do not over-verify (no need to verify presence of PERSONA.md itself)
- Maintain clarity in context reports (users need to know what was loaded and why)
- Preserve chain-loading architecture (standards can still declare dependencies)

## Success Criteria

**We are done when:**

1. The `/context` command includes systematic file_search verification for language-specific standards before loading
2. Context reports explicitly state: "✓ Files detected and standards loaded" or "✗ No files detected; standards not loaded"
3. If the agent loads a language standard without verification, it states the assumption transparently (e.g., "STANDARDS_BASH.md loaded for governance context; no .sh files detected")
4. Truncated workspace views trigger verification, not inference
5. The agent no longer claims certainty about file presence without running file_search first

## Notes

- This aligns with STANDARDS_CORE.md's precision principle and the Pragmatic Architect's detail-orientation
- Trust workspace structure and file_search over logical inference
- The conditional "if detected" must mean "verify then load," not "probably load"
