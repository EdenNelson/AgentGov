# PLAN: Implement Auto-Fix Hook System for Quality Validation

**Date:** February 21, 2026  
**Status:** Pending Approval  
**Scope:** Tooling enhancement (non-breaking; internal only)

## Problem Statement

Validators detect issues but don't fix them, causing repeated Agent calls just to correct simple problems (emoji replacement, trailing newlines, whitespace). This creates friction and wastes tokens.

We have existing hook infrastructure in `.github/hooks/quality-validation.json` but it only validates. We can extend it to **auto-fix** before validation.

## Analysis & Assessment

**Options:**
1. Keep validators passive (status quo) — high friction
2. Add auto-fixes to every validator — complex and redundant logic
3. Create fixer scripts in the hook pipeline (recommended) — clean separation of concerns

**Rationale for Option 3:**
- Fixers live separately from validators (single responsibility)
- Hook runs fixer BEFORE validator: fix → validate → report
- Agent never sees validation failures for auto-fixable issues
- Reduces Token waste and friction

**Risk:** Low—fixers only handle non-ambiguous transformations; validators remain authoritative check

## Plan

### Stage 1: Create Fixer Scripts

**Deliverables:**
- [ ] `.github/scripts/fix-file.sh` — dispatcher (routes by file type)
- [ ] `.github/scripts/fix-markdown.sh` — emoji replacement, trailing newlines, whitespace
- [ ] `.github/scripts/fix-powershell.sh` — line ending normalization, trailing newlines
- [ ] All scripts executable (chmod +x)

**Checkpoint:** All three scripts created and executable; no bash validation errors

### Stage 2: Wire Fixers into Hook Pipeline

**Deliverables:**
- [ ] Update `.github/hooks/quality-validation.json`
- [ ] Add `fix-file.sh` step **before** `validate-file.sh` in `postToolUse` array

**Checkpoint:** Hook config updated; `postToolUse` has two steps: fix → validate

### Stage 3: Verify Workflow

**Deliverables:**
- [ ] Manual test: edit markdown file with emoji, commit, verify emoji is replaced
- [ ] Validate that fixer doesn't break valid files

**Checkpoint:** Fixer workflow confirmed working

## Consent Gate

**Breaking change:** No  
**User-facing impact:** None (internal tooling)  
**Developer impact:** Positive—fewer validation failures on fixable issues  
**Token impact:** Positive—fewer Agent calls needed  

**Approved:** [✓] Approved by Eden Nelson on 2026-02-21

## References

- Existing hook infrastructure: `.github/hooks/quality-validation.json`
- Dispatcher pattern: `.github/scripts/validate-file.sh` (template)
- Related standards: bash.instructions.md
