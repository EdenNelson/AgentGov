# PLAN: Fix Code Planner Agent Frontmatter and Formatting

**Date:** February 21, 2026
**Status:** Approved
**Approved:** Approved by Eden Nelson on 2026-02-21
**Scope:** Governance file fix (.github/agents/code-planner.agent.md)

## Problem Statement
The code-planner agent file contains invalid YAML frontmatter and markdown formatting corruption, which breaks agent metadata parsing and renders content incorrectly. This must be corrected to restore proper agent behavior and documentation readability.

## Analysis & Assessment
- **Impact:** Governance file parsing may fail due to malformed frontmatter (invalid keys, stray tokens). Rendering issues reduce clarity for users.
- **Risk:** Low functional risk once corrected, but requires strict governance change controls.
- **Alternatives:** Leave as-is (not acceptable; breaks parsing). Recreate file from a canonical template (risk of content drift). Preferred approach: minimal, exact fixes to frontmatter keys and markdown list formatting while preserving intent.
- **Constraints:** Must follow governance hard gate and markdown standards; changes must be auditable.

## Plan
### Stage 1: Inspect and Normalize Frontmatter
**Deliverables:**
- [ ] Replace malformed frontmatter keys with valid YAML (`name`, `description`, `tools`)
- [ ] Remove stray tokens and ensure proper `---` delimiters

**Checkpoint:** Frontmatter parses as valid YAML and matches expected agent schema.

### Stage 2: Fix Formatting Corruption in Body
**Deliverables:**
- [ ] Repair broken list markers in the Output Artifact section
- [ ] Remove stray corruption artifacts (e.g., orphaned characters)
- [ ] Preserve original intent and content

**Checkpoint:** Markdown renders cleanly and content matches intended structure.

### Stage 3: Verify File Integrity
**Deliverables:**
- [ ] Re-open file and confirm no unintended changes
- [ ] Ensure no other governance files modified

**Checkpoint:** Clean diff limited to .github/agents/code-planner.agent.md.

## Consent Gate
- **Breaking change:** No
- **User-facing impact:** Improves agent metadata parsing and documentation formatting
- **Approval required:** Yes (governance file change)

## Persistence & Recovery
- Plan saved at: `.github/prompts/plan-20260221-code-planner-agent-fix.prompt.md`
- If session stops: resume by reading this plan and starting at Stage 1

## References
- [spec-protocol.instructions.md](.github/instructions/spec-protocol.instructions.md)
- [orchestration.instructions.md](.github/instructions/orchestration.instructions.md)
- [general-coding.instructions.md](.github/instructions/general-coding.instructions.md)
