# Intent Parity Audit: Canonical Files → Skills

**Date:** 2026-02-18  
**Auditor:** Pragmatic Architect (automated audit)  
**Plan Reference:** `.github/prompts/plan-20260218-skill-migration-intent-validation.prompt.md`  
**Scope:** Validate intent parity between canonical governance files and skill mirrors

---

## Executive Summary

**Status:** [COMPLETE] PASS — All skill mirrors preserve canonical file intent

**Findings:**
- 8 skills audited
- 10 canonical files mapped
- 0 critical discrepancies found
- 0 missing sections detected
- 0 contradictions introduced
- Expected differences: YAML frontmatter, sync notes (intentional and documented)

**Recommendation:** Skills are production-ready and maintain full parity with canonical files.

---

## Stage 1: Inventory and Mapping

### Mapping Table: Canonical Files → Skills

| Canonical File | Skill Mirror | Status | Notes |
|---|---|---|---|
| PERSONA.md | `.github/skills/persona-architect/SKILL.md` | [COMPLETE] Mapped | 1:1 mapping |
| PERSONA_SCRIBE.md | `.github/skills/persona-scribe/SKILL.md` | [COMPLETE] Mapped | 1:1 mapping |
| STANDARDS_CORE.md | `.github/skills/standards-core/SKILL.md` | [COMPLETE] Mapped | 1:1 mapping |
| STANDARDS_BASH.md | `.github/skills/standards-bash/SKILL.md` | [COMPLETE] Mapped | 1:1 mapping |
| STANDARDS_POWERSHELL.md | `.github/skills/standards-powershell/SKILL.md` | [COMPLETE] Mapped | 1:1 mapping |
| STANDARDS_ORCHESTRATION.md | `.github/skills/standards-orchestration/SKILL.md` | [COMPLETE] Mapped | 1:1 mapping |
| CONSENT_CHECKLIST.md | `.github/skills/internal-governance/SKILL.md` | [COMPLETE] Mapped | Combined with GOVERNANCE_MAINTENANCE.md |
| GOVERNANCE_MAINTENANCE.md | `.github/skills/internal-governance/SKILL.md` | [COMPLETE] Mapped | Combined with CONSENT_CHECKLIST.md |
| ADR_TEMPLATE.md | `.github/skills/templates/SKILL.md` | [COMPLETE] Mapped | Combined with MIGRATION_TEMPLATE.md |
| MIGRATION_TEMPLATE.md | `.github/skills/templates/SKILL.md` | [COMPLETE] Mapped | Combined with ADR_TEMPLATE.md |

### Canonical-Only Files (No Skill Mirror)

| File | Reason |
|---|---|
| SPEC_PROTOCOL.md | Referenced by skills but not mirrored (remains canonical-only) |
| PROJECT_CONTEXT.md | Project-specific context, not governance (correctly excluded) |
| SKILLS_MANIFEST.md | Meta-documentation for skill system itself |
| README.md | Repository README (not governance) |

**Checkpoint 1 (Stage 1):** [COMPLETE] COMPLETE — All governance files accounted for and correctly mapped.

---

## Stage 2: Intent Parity Review

### Parity Checklist Results

#### 1. PERSONA.md → persona-architect/SKILL.md

**Section Coverage:**
- [COMPLETE] Identity
- [COMPLETE] Core Profile
- [COMPLETE] Working Relationship
- [COMPLETE] Input Decoding (Signal-to-Noise Protocol)
- [COMPLETE] Behavioral Guidelines
- [COMPLETE] Output Style
- [COMPLETE] Usage & Precedence
- [COMPLETE] Mode: The Adversarial Critic
- [COMPLETE] Institutional Memory (The ESD Reality)
- [COMPLETE] Execution Protocol (Implementation Phase)

**Rules and Constraints:**
- [COMPLETE] All behavioral rules preserved (No Fluff, Defensive Coding, Explain "Why", Zero-Defect Documentation, Maximum 2 Questions)
- [COMPLETE] Governance Protection (Rule #0) intact
- [COMPLETE] Institutional constraints preserved (One-Man Army, UDM, Zero-Cost Architecture)

**Deviations:**
- [COMPLETE] YAML frontmatter added (expected, intentional)
- [COMPLETE] Sync note added: "This skill mirrors PERSONA.md. Keep this content in sync with the canonical file." (expected, intentional)

**Links and References:**
- [COMPLETE] All cross-references preserved (STANDARDS_CORE, SPEC_PROTOCOL)

**Verdict:** [COMPLETE] PASS — Full intent parity

---

#### 2. PERSONA_SCRIBE.md → persona-scribe/SKILL.md

**Section Coverage:**
- [COMPLETE] Role
- [COMPLETE] Prime Directives (The Firewall)
- [COMPLETE] The Intake Loop
- [COMPLETE] Output Artifact: The Scribe Plan

**Rules and Constraints:**
- [COMPLETE] NO CODE firewall preserved
- [COMPLETE] NO TECHNICAL SOLUTIONING preserved
- [COMPLETE] LISTEN directive preserved
- [COMPLETE] Max Questions constraint preserved (3 high-yield questions)

**Deviations:**
- [COMPLETE] YAML frontmatter added (expected, intentional)
- [COMPLETE] Sync note added (expected, intentional)

**Links and References:**
- [COMPLETE] All cross-references preserved

**Verdict:** [COMPLETE] PASS — Full intent parity

---

#### 3. STANDARDS_CORE.md → standards-core/SKILL.md

**Section Coverage:**
- [COMPLETE] 1. GENERAL PRINCIPLES
  - [COMPLETE] 1.1 Core Values
  - [COMPLETE] 1.2 AI Interaction & Context
  - [COMPLETE] 1.3 Markdown Hygiene
  - [COMPLETE] 1.4 File Boundaries (Governance Location)
- [COMPLETE] 2. API & ENDPOINT ORCHESTRATION
  - [COMPLETE] 2.1 "Check Before Act"
  - [COMPLETE] 2.2 Resiliency
  - [COMPLETE] 2.3 Authentication
- [COMPLETE] 3. QUALITY ASSURANCE (REFLEXION PROTOCOL)
  - [COMPLETE] 3.1 The Silent Review
  - [COMPLETE] 3.2 The Reflexion Tag

**Rules and Constraints:**
- [COMPLETE] Correctness, Clarity, Idempotence > Brevity
- [COMPLETE] Spec Protocol Requirement preserved
- [COMPLETE] Idempotency requirement preserved
- [COMPLETE] Markdown hygiene rules preserved (CommonMark, blank lines, language tags, final newline, no emojis)
- [COMPLETE] Reflexion Protocol preserved

**Deviations:**
- [COMPLETE] YAML frontmatter added (expected, intentional)
- [COMPLETE] Sync note added (expected, intentional)

**Links and References:**
- [COMPLETE] All cross-references preserved (SPEC_PROTOCOL.md, STANDARDS_ORCHESTRATION.md, PROJECT_CONTEXT.md, Powershell.instructions.md)

**Verdict:** [COMPLETE] PASS — Full intent parity

---

#### 4. STANDARDS_BASH.md → standards-bash/SKILL.md

**Section Coverage:**
- [COMPLETE] 1. BASH STANDARDS
  - [COMPLETE] 1.1 The "Safety Net" Header
  - [COMPLETE] 1.2 Logic & Syntax
  - [COMPLETE] 1.3 Cleanup

**Rules and Constraints:**
- [COMPLETE] Strict mode directives preserved (`set -euo pipefail`, `IFS=$'\n\t'`)
- [COMPLETE] Rationale for Bash 4.x preserved
- [COMPLETE] Variable quoting rules preserved
- [COMPLETE] Conditional preference preserved (`[[ ... ]]`)
- [COMPLETE] `printf` over `echo` preserved
- [COMPLETE] `trap` cleanup requirement preserved

**Deviations:**
- [COMPLETE] YAML frontmatter added (expected, intentional)
- [COMPLETE] Sync note added (expected, intentional)

**Links and References:**
- [COMPLETE] No external links in this skill (self-contained)

**Verdict:** [COMPLETE] PASS — Full intent parity

---

#### 5. STANDARDS_POWERSHELL.md → standards-powershell/SKILL.md

**Section Coverage:**
- [COMPLETE] Scope
- [COMPLETE] General Principles
- [COMPLETE] File Encoding and Line Endings (CRITICAL)
  - [COMPLETE] Default Requirements (LF)
  - [COMPLETE] When CRLF Is Required (Legacy 5.1)
  - [COMPLETE] CRLF Marker Convention
  - [COMPLETE] Rationale
  - [COMPLETE] Agent Decision Logic
- [COMPLETE] Logging and Messaging
- [COMPLETE] Cmdlet and Parameter Usage
  - [COMPLETE] Parameter Usage Examples
  - [COMPLETE] Path Construction Details
  - [COMPLETE] Function Parameters
  - [COMPLETE] Loop Constructs
- [COMPLETE] Error Handling
- [COMPLETE] Comment-Based Help
- [COMPLETE] Naming and Style
- [COMPLETE] Script Structure Decision Tree
- [COMPLETE] External Executables
- [COMPLETE] Dynamic Names
- [COMPLETE] AI Context Management
- [COMPLETE] Enforcement

**Rules and Constraints:**
- [COMPLETE] LF default, CRLF only when explicitly required
- [COMPLETE] `Write-Verbose` for logging
- [COMPLETE] Full cmdlet names and explicit parameters
- [COMPLETE] `Join-Path` for path construction
- [COMPLETE] `[CmdletBinding()]` requirement
- [COMPLETE] Error handling with `-ErrorAction Stop` and try/catch
- [COMPLETE] ASCII hyphens only in string literals (with ADR-0014 reference)
- [COMPLETE] Script structure decision tree preserved
- [COMPLETE] Region-based structure guidance preserved
- [COMPLETE] begin/process/end block triggers preserved

**Deviations:**
- [COMPLETE] YAML frontmatter added (expected, intentional)
- [COMPLETE] Sync note added (expected, intentional)

**Links and References:**
- [COMPLETE] All cross-references preserved (PROJECT_CONTEXT.md, Powershell.instructions.md, ADR-0014)

**Verdict:** [COMPLETE] PASS — Full intent parity

---

#### 6. STANDARDS_ORCHESTRATION.md → standards-orchestration/SKILL.md

**Section Coverage:**
- [COMPLETE] 1. Change Management & User Consent
  - [COMPLETE] 1.1 Consent Gate (Mandatory)
  - [COMPLETE] 1.2 Required Approval Flow
  - [COMPLETE] 1.3 Migration & Documentation
  - [COMPLETE] 1.4 Examples
  - [COMPLETE] 1.5 Scope Enforcement
- [COMPLETE] 2. Resources
- [COMPLETE] 3. ARCHITECTURAL SPECIFICATION: THE SPEC PROTOCOL
  - [COMPLETE] 3.1 Spec Protocol Overview
  - [COMPLETE] 3.2 Reference Documentation
- [COMPLETE] 4. NON-EPHEMERAL PLANNING
  - [COMPLETE] 4.1 Mandatory Planning for Significant Changes
  - [COMPLETE] 4.2 Plan Prompt Location & Naming
  - [COMPLETE] 4.3 Plan Prompt Minimum Contents
- [COMPLETE] 5. VERIFICATION PROTOCOL (TEST-DRIVEN GENERATION)
  - [COMPLETE] 5.1 The "Verify-First" Mandate
  - [COMPLETE] 5.2 Implementation Pattern (V-I-V)
- [COMPLETE] 6. ADVERSARIAL REVIEW PROTOCOL (THE TRIAD)
  - [COMPLETE] 6.1 Purpose
  - [COMPLETE] 6.2 The Review Workflow
  - [COMPLETE] 6.3 Audit Scope
- [COMPLETE] 7. ARCHITECTURAL DECISION RECORDS (ADR)
  - [COMPLETE] 7.1 Storage Standard
  - [COMPLETE] 7.2 When to Write an ADR
  - [COMPLETE] 7.3 The ADR Workflow
- [COMPLETE] 8. RECURSIVE OPTIMIZATION (THE CLINIC)
  - [COMPLETE] 8.1 Purpose
  - [COMPLETE] 8.2 The "Clinic" Workflow

**Rules and Constraints:**
- [COMPLETE] Consent Gate non-bypassable
- [COMPLETE] Breaking change approval flow preserved
- [COMPLETE] Spec Protocol hard gate preserved
- [COMPLETE] Non-ephemeral planning requirement preserved
- [COMPLETE] Plan persistence to `.github/prompts/` preserved
- [COMPLETE] Plan naming convention preserved (`plan-<YYYYMMDD>-<topic>.prompt.md`)
- [COMPLETE] Exemptions for minor changes preserved
- [COMPLETE] V-I-V pattern preserved
- [COMPLETE] Adversarial review workflow preserved (/review trigger)
- [COMPLETE] ADR workflow preserved
- [COMPLETE] Clinic workflow preserved (/retro trigger)

**Deviations:**
- [COMPLETE] YAML frontmatter added (expected, intentional)
- [COMPLETE] Sync note added (expected, intentional)
- [WARNING] Minor wording difference: canonical says "audit trail is complete", skill says "Commits link back to plan; audit trail is complete". This is a clarification, not a contradiction.

**Links and References:**
- [COMPLETE] All cross-references preserved (SPEC_PROTOCOL.md, STANDARDS_CORE.md, PROJECT_CONTEXT.md, CONSENT_CHECKLIST.md, MIGRATION_TEMPLATE.md, ADR_TEMPLATE.md)

**Verdict:** [COMPLETE] PASS — Full intent parity (minor clarification acceptable)

---

#### 7. CONSENT_CHECKLIST.md + GOVERNANCE_MAINTENANCE.md → internal-governance/SKILL.md

**Section Coverage (CONSENT_CHECKLIST.md):**
- [COMPLETE] Pre-Change Analysis (Required Before Approval)
- [COMPLETE] Approval Gate
- [COMPLETE] Implementation Phase (After Approval)
- [COMPLETE] References

**Section Coverage (GOVERNANCE_MAINTENANCE.md):**
- [COMPLETE] [CRITICAL] CRITICAL PRE-FLIGHT CHECK (RULE #0)
- [COMPLETE] 0. Invocation & Multi-Session Workflow
  - [COMPLETE] Starting Governance Maintenance Mode
  - [COMPLETE] ADR Numbering: Pre-Check Before Generation
  - [COMPLETE] Multi-Session Handoff
- [COMPLETE] 1. Principle: "Chesterton's Fence"
- [COMPLETE] 2. The Pruning Workflow (Test-Driven)
  - [COMPLETE] Step 1: Isolation
  - [COMPLETE] Step 2: The "Probe" (Unit Test)
  - [COMPLETE] Step 3: The Refactor
  - [COMPLETE] Step 4: Regression Check
- [COMPLETE] 3. Maintenance Log (Example)

**Rules and Constraints:**
- [COMPLETE] Repository check (RULE #0) preserved
- [COMPLETE] Plan persistence requirement preserved
- [COMPLETE] Approval gate workflow preserved
- [COMPLETE] Consent checklist items preserved
- [COMPLETE] ADR numbering pre-check preserved
- [COMPLETE] Multi-session handoff table preserved
- [COMPLETE] Chesterton's Fence principle preserved
- [COMPLETE] Test-driven pruning workflow preserved

**Deviations:**
- [COMPLETE] YAML frontmatter added (expected, intentional)
- [COMPLETE] Sync note added (expected, intentional)
- [COMPLETE] Two canonical files combined into one skill (expected, intentional — both are AgentGov-only governance maintenance content)

**Links and References:**
- [COMPLETE] All cross-references preserved (SPEC_PROTOCOL.md, STANDARDS_ORCHESTRATION.md, MIGRATION_TEMPLATE.md, `.github/adr/README.md`)

**Verdict:** [COMPLETE] PASS — Full intent parity

---

#### 8. ADR_TEMPLATE.md + MIGRATION_TEMPLATE.md → templates/SKILL.md

**Section Coverage (ADR_TEMPLATE.md):**
- [COMPLETE] Status
- [COMPLETE] Date
- [COMPLETE] Context
- [COMPLETE] Decision
- [COMPLETE] Consequences
- [COMPLETE] Compliance
- [COMPLETE] For Governance Maintenance ADRs (Optional Sections)
  - [COMPLETE] Suspect List (Phase 1)
  - [COMPLETE] Test Plan (Phase 2)
  - [COMPLETE] Execution Notes (Phase 3)
  - [COMPLETE] Validation Results (Phase 4)

**Section Coverage (MIGRATION_TEMPLATE.md):**
- [COMPLETE] Summary
- [COMPLETE] Affected Surfaces
- [COMPLETE] Who Is Impacted
- [COMPLETE] Architectural Planning (Agent Reference)
- [COMPLETE] Steps to Migrate
- [COMPLETE] Examples (Before → After)
- [COMPLETE] Rollback Strategy
- [COMPLETE] Validation
- [COMPLETE] Notes

**Rules and Constraints:**
- [COMPLETE] ADR status values preserved (Proposed, Accepted, Rejected, Deprecated, WONTFIX)
- [COMPLETE] ADR structure preserved
- [COMPLETE] Migration template structure preserved
- [COMPLETE] Governance maintenance ADR extensions preserved

**Deviations:**
- [COMPLETE] YAML frontmatter added (expected, intentional)
- [COMPLETE] Sync note added (expected, intentional)
- [COMPLETE] Two canonical files combined into one skill (expected, intentional — both are templates for governance artifacts)

**Links and References:**
- [COMPLETE] All cross-references preserved (SPEC_PROTOCOL.md, STANDARDS_CORE.md)

**Verdict:** [COMPLETE] PASS — Full intent parity

---

**Checkpoint 2 (Stage 2):** [COMPLETE] COMPLETE — All pairs validated for intent parity.

---

## Stage 3: Report and Recommendations

### Parity Summary

| Canonical File(s) | Skill Mirror | Parity Verdict | Discrepancies |
|---|---|---|---|
| PERSONA.md | persona-architect | [COMPLETE] PASS | None |
| PERSONA_SCRIBE.md | persona-scribe | [COMPLETE] PASS | None |
| STANDARDS_CORE.md | standards-core | [COMPLETE] PASS | None |
| STANDARDS_BASH.md | standards-bash | [COMPLETE] PASS | None |
| STANDARDS_POWERSHELL.md | standards-powershell | [COMPLETE] PASS | None |
| STANDARDS_ORCHESTRATION.md | standards-orchestration | [COMPLETE] PASS | Minor clarification (audit trail wording) |
| CONSENT_CHECKLIST.md + GOVERNANCE_MAINTENANCE.md | internal-governance | [COMPLETE] PASS | None |
| ADR_TEMPLATE.md + MIGRATION_TEMPLATE.md | templates | [COMPLETE] PASS | None |

### Drift Details

**No critical drift detected.** All skills preserve canonical file intent.

**Minor Clarifications (Non-Breaking):**
1. **standards-orchestration/SKILL.md:** Added clarification "Commits link back to plan;" to audit trail statement. This is an explicit restatement of intent, not a new requirement.

### Recommended Follow-Up Actions

**Immediate:**
- [COMPLETE] No action required. Skills are production-ready.

**Future-Proofing (Optional):**
1. **Hash Tracking:** Consider adding a simple hash or last-modified timestamp to skill frontmatter to detect post-audit canonical changes.
   - **Example:** Add `canonical_hash: <sha256>` or `last_sync: 2026-02-18` to YAML frontmatter.
   - **Benefit:** Enables quick detection of drift without full re-audit.

2. **Automated Sync Check:** Create a CI/CD step or script to compare canonical files and skills.
   - **Example:** `.github/scripts/validate-skill-parity.sh`
   - **Benefit:** Catches accidental drift before distribution.

3. **Sync Workflow Documentation:** Document the process for updating canonical files and re-syncing skills.
   - **Location:** Add to `GOVERNANCE_MAINTENANCE.md` or create `SKILLS_SYNC_WORKFLOW.md`.
   - **Benefit:** Clear guidance for future governance edits.

---

## Repeatable Verification Workflow

For future audits, follow this workflow:

### 1. Prepare Mapping Table

List all canonical governance files and their skill mirrors. Identify canonical-only files and justify exclusions.

**Command:** `ls -1 *.md | grep -E "(PERSONA|STANDARDS|CONSENT|GOVERNANCE|ADR_TEMPLATE|MIGRATION_TEMPLATE)"`

### 2. Compare Content by Section

For each pair:
- Read canonical file sections
- Read skill file sections
- Verify section headings match
- Verify rules/constraints match (intent, not verbatim)
- Document any omissions, additions, or contradictions

**Checklist per pair:**
- [ ] Section coverage matches (no missing major headings)
- [ ] Rules and constraints preserved (same intent)
- [ ] No new rules introduced without justification
- [ ] No contradictions introduced
- [ ] Links and references still accurate
- [ ] Any deviation is documented with rationale

### 3. Generate Parity Report

Create a summary table with verdicts (PASS/FAIL) and discrepancy details.

**Template:** Use this audit report as a template for future audits.

### 4. Identify Drift Triggers

After future canonical file edits:
- Check if skills were updated in the same commit
- If not, flag for sync review
- Optionally: Use git hooks to enforce skill updates when canonical files change

---

## Validation Metrics

**Audit Completeness:**
- [COMPLETE] 10/10 canonical governance files mapped
- [COMPLETE] 8/8 skills audited
- [COMPLETE] 100% section coverage verified
- [COMPLETE] 0 missing sections
- [COMPLETE] 0 contradictions
- [COMPLETE] 0 critical discrepancies

**Expected Differences (All Justified):**
- [COMPLETE] YAML frontmatter (intentional skill metadata)
- [COMPLETE] Sync notes ("This skill mirrors...") (intentional maintenance guidance)
- [COMPLETE] File combination (CONSENT_CHECKLIST + GOVERNANCE_MAINTENANCE into internal-governance; ADR_TEMPLATE + MIGRATION_TEMPLATE into templates) (intentional consolidation for related content)

**Parity Verdict:** [COMPLETE] PASS — 100% intent parity across all skill mirrors

---

## Conclusion

The skill migration successfully preserves canonical file intent. All governance rules, constraints, workflows, and references are intact. Skills are production-ready and safe for distribution to consumer projects.

**Approval Status:** Pending user review.

**Checkpoint 3 (Stage 3):** [COMPLETE] COMPLETE — Audit report generated and recommendations provided.

---

**Audit Completed:** 2026-02-18  
**Auditor Signature:** Pragmatic Architect  
**Plan Reference:** `.github/prompts/plan-20260218-skill-migration-intent-validation.prompt.md`
