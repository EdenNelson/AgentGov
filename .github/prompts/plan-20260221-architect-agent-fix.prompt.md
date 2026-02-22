# PLAN: Align Architect Agent Profile with GitHub Custom Agent Schema

**Date:** February 21, 2026
**Status:** Approved
**Approved:** Approved by Eden Nelson on 2026-02-21
**Scope:** Governance file fix (.github/agents/architect.agent.md)

## Problem Statement
The architect agent profile is not compliant with GitHub custom agent schema because the YAML frontmatter contains non-YAML content and missing required properties. This can cause parsing failures and inconsistent behavior in custom agent tooling. The file also needs markdown hygiene fixes to comply with repository standards.

## Analysis & Assessment
- **Impact:** Invalid frontmatter can prevent agent discovery or cause metadata parsing errors. Markdown violations can fail validation.
- **Risk:** Low when corrected, but must follow governance hard gate and preserve intent.
- **Alternatives:** Recreate from scratch (risk of content drift). Preferred approach: minimally normalize frontmatter and fix markdown structure while preserving content.
- **Constraints:** Governance files require a plan and explicit approval. Markdown hygiene rules apply.

## Plan

### Stage 1: Normalize Frontmatter

**Deliverables:**

- [ ] Replace non-YAML comments with proper YAML keys
- [ ] Ensure `name` and `description` exist
- [ ] Add `tools` list or document if intentionally omitted
- [ ] Ensure YAML delimiters are correct

**Checkpoint:** Frontmatter parses as valid YAML and aligns with GitHub agent profile schema.

### Stage 2: Fix Markdown Hygiene

**Deliverables:**

- [ ] Add required blank lines before and after headings and lists
- [ ] Fix list indentation and structure for CommonMark compliance
- [ ] Remove any stray formatting artifacts

**Checkpoint:** File passes markdown validation for formatting rules.

### Stage 3: Verify Integrity

**Deliverables:**

- [ ] Confirm content intent is preserved
- [ ] Confirm only .github/agents/architect.agent.md is modified

**Checkpoint:** Clean diff limited to the target agent file.

## Consent Gate

- **Breaking change:** No
- **User-facing impact:** Improved agent parsing and markdown compliance
- **Approval required:** Yes (governance file change)

## Persistence & Recovery

- Plan saved at: `.github/prompts/plan-20260221-architect-agent-fix.prompt.md`
- If session stops: resume by reading this plan and starting at Stage 1

## References

- [Creating custom agents](https://docs.github.com/en/copilot/how-tos/use-copilot-agents/coding-agent/create-custom-agents)
- [spec-protocol.instructions.md](.github/instructions/spec-protocol.instructions.md)
- [orchestration.instructions.md](.github/instructions/orchestration.instructions.md)
- [markdown.instructions.md](.github/instructions/markdown.instructions.md)
