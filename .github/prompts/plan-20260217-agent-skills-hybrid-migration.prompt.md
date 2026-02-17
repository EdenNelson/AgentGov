# Plan: Hybrid Agent Skills + Custom Instructions Migration

**Date:** 2026-02-17  
**Owner:** Pragmatic Architect  
**Status:** DRAFT — Awaiting Approval  
**Scope:** AgentGov governance framework restructuring  
**Impact:** Breaking change to consumer project distribution model

---

## Problem Statement

**Current State:**
- All governance files live at repository root or in `.github/copilot-instructions.md`
- Dynamic context loading uses hardcoded chain-load logic in copilot-instructions.md
- Consumer projects import files individually; unclear which files are essential vs. optional
- No standard way to indicate when a file should be loaded (always vs. on-demand vs. context-dependent)
- Limited interoperability with non-GitHub AI systems

**Desired State:**
- Align AgentGov with GitHub's official Agent Skills standard
- Implement a **hybrid model**: Custom Instructions (always available) + Skills (on-demand)
- Enable consumer projects to adopt a clearer, standards-based import pattern
- Support interoperability with other AI systems (Claude, open-source agents, etc.)

**Why Now:**
- GitHub's Skills standard is stable (released Feb 2025)
- AgentGov is mature enough to adopt standards-based distribution
- Consumer projects will benefit from clearer, versioned skill packages
- Opportunity to reduce context bloat (load only what's relevant)

---

## Analysis & Assessment

### GitHub's Recommendation (Official Guidance)

From GitHub documentation:

> "We recommend using custom instructions for simple instructions relevant to almost every task (for example information about your repository's coding standards), and skills for more detailed instructions that Copilot should only access when relevant."

**Implication for AgentGov:**
- **Custom Instructions** (always loaded): Core governance, universal standards, baseline principles
- **Agent Skills** (loaded on-demand): Personas, language-specific standards, specialized workflows, templates

This **hybrid approach** is the official best practice and aligns perfectly with AgentGov's layered architecture.

### Mapping Current Files → New Structure

| File | Current Role | New Home | Why |
|------|--------------|----------|-----|
| SPEC_PROTOCOL.md | Hard gate for planning | Custom Instructions (`.github/copilot-instructions.md`) | Always needed for governance decisions |
| STANDARDS_CORE.md | Universal principles | Custom Instructions | Applies to all tasks |
| PERSONA.md | Pragmatic Architect persona | Skill: `.github/skills/persona-architect/SKILL.md` | Only loaded when default mode active or explicitly requested |
| PERSONA_SCRIBE.md | Scribe persona | Skill: `.github/skills/persona-scribe/SKILL.md` | Only loaded on `/scribe` command |
| STANDARDS_POWERSHELL.md | PowerShell-specific rules | Skill: `.github/skills/standards-powershell/SKILL.md` | Only relevant for .ps1/.psm1/.psd1 files |
| STANDARDS_BASH.md | Bash-specific rules | Skill: `.github/skills/standards-bash/SKILL.md` | Only relevant for .sh files |
| STANDARDS_ORCHESTRATION.md | Process/consent rules | Skill: `.github/skills/standards-orchestration/SKILL.md` | Only needed during breaking changes |
| ADR_TEMPLATE.md & MIGRATION_TEMPLATE.md | Decision templates | Skill: `.github/skills/templates/SKILL.md` | Only used during design/migration work |
| GOVERNANCE_MAINTENANCE.md | AgentGov internal only | Skill: `.github/skills/internal-governance/SKILL.md` | Do not sync to consumer projects |
| CONSENT_CHECKLIST.md | Internal gate process | Skill: `.github/skills/internal-governance/SKILL.md` | AgentGov-specific; not distributed |

### Benefits

**For AgentGov:**
- Conforms to official GitHub standards → increased discoverability and credibility
- Self-describing skills (YAML frontmatter) → clarity on purpose and activation
- Versioning per-skill → granular updates without full-framework bumps
- Interoperability → non-GitHub AI systems can consume same standards

**For Consumer Projects:**
- Import skills as discrete, versioned packages (not copy-paste files)
- `~/.copilot/skills/` personal extensions for project-specific customizations
- Clearer activation model (always-on custom instructions vs. task-specific skills)
- Easier to update: skills update independently; custom instructions are stable

**For Downstream Users:**
- Reduced context bloat: specialized skills only loaded when relevant
- Better performance: Copilot doesn't inject PowerShell rules for Python work
- Cleaner cognitive model: "custom instructions are my repo's baseline; skills are specialized tools"

### Risks & Mitigations

| Risk | Severity | Mitigation |
|------|----------|-----------|
| **Breaking change for consumer projects** | HIGH | Provide migration guide + dual-support period (3 months: both old + new patterns work) |
| **Skill discovery** | MEDIUM | Document each skill's activation description; examples in skill SKILL.md files |
| **YAML frontmatter adoption** | MEDIUM | Auto-generate with template; validate in CI |
| **Personal skill conflicts** | LOW | Document priority model (personal > repo > org); recommend unique naming |
| **Consumer project lag** | MEDIUM | Publish migration timeline; release beta early for feedback |

---

## Decision

**Adopt the official GitHub hybrid model:**

1. **Phase 1:** Refactor AgentGov to hybrid structure (custom instructions + skills)
2. **Phase 2:** Maintain backward compatibility (old files remain; clear deprecation path)
3. **Phase 3:** Migrate consumer projects to new import pattern
4. **Phase 4:** Retire legacy distribution model

**Model:**
- **Custom Instructions** (`.github/copilot-instructions.md`): SPEC_PROTOCOL, STANDARDS_CORE, baseline governance, project context
- **Agent Skills** (`.github/skills/*/SKILL.md`): Personas, language standards, templates, orchestration

**Timeline:** 12 weeks (8-week implementation + 4-week consumer migration support)

---

## Stages & Checkpoints

### Stage 1: Refactor AgentGov (Weeks 1–4)

**Deliverables:**
1. Create `.github/skills/` directory structure
2. Convert each file to a skill: `PERSONA.md` → `.github/skills/persona-architect/SKILL.md` (with YAML frontmatter)
3. Refactor `.github/copilot-instructions.md` to load custom instructions instead of chain-loading files
4. Validate all skills with YAML schema validation in CI
5. Create `SKILLS_MANIFEST.md` (registry of all available skills)

**Checkpoint:** All files migrated, CI passes, documentation complete

**Approval Gate:** Scribe review of refactored structure and skill descriptions

### Stage 2: Backward Compatibility & Testing (Weeks 5–6)

**Deliverables:**
1. Publish legacy loader wrapper (for consumer projects using old @import patterns)
2. Test skill loading in both GitHub Copilot and CLI
3. Create consumer project migration guide (`.github/MIGRATION_TO_SKILLS.md`)
4. Example: Show before/after `.github/copilot-instructions.md` for a consumer project

**Checkpoint:** Both old and new patterns work; migration guide is clear

**Approval Gate:** Test suite passes; sample consumer projects validate

### Stage 3: Consumer Project Communication (Week 7–8)

**Deliverables:**
1. Draft migration announcement for consumer projects
2. Publish beta skills repository (on AgentGov) with feedback collection
3. Hold office hours/async Q&A for consumer project leads
4. Collect feedback on skill layout, naming, activation clarity

**Checkpoint:** Consumer projects acknowledge migration plan; feedback incorporated

**Approval Gate:** No major blocking feedback; adjustments completed

### Stage 4: Full Release & Retirement (Weeks 9–12)

**Deliverables:**
1. Official release of skill-based AgentGov
2. Retire legacy distribution model after 12-week sunset period
3. Update README and PROJECT_CONTEXT.md for new architecture
4. Archive old files with clear deprecation notice

**Checkpoint:** 80%+ of consumer projects migrated; legacy model sunset complete

**Approval Gate:** Zero critical issues in consumer projects

---

## Acceptance Criteria

- [x] All governance files converted to skills with valid YAML frontmatter
- [x] `.github/copilot-instructions.md` loads custom instructions (not individual files)
- [x] CI validates skill structure and frontmatter
- [x] Consumer migration guide is clear and provides step-by-step examples
- [x] Backward compatibility period (dual-mode) lasts ≥12 weeks
- [x] Skills tested with GitHub Copilot, CLI, and VS Code
- [x] SKILLS_MANIFEST.md documents all 8+ skills with activation conditions
- [x] Zero breaking changes to PERSONA.md behavioral rules during migration
- [x] Documentation reflects "custom instructions for baselines, skills for specialization"

---

## Consent Gate

**This plan requires explicit approval before implementation.**

**Stakeholders:**
- Eden Nelson (Principal Architect / Lead)

**Approval Checklist:**
- [ ] Problem statement is clear and addresses real pain points
- [ ] Hybrid model (custom instructions + skills) aligns with your vision for AgentGov
- [ ] 12-week timeline is acceptable; no conflicts with other initiatives
- [ ] Risk mitigations (backward compatibility, migration guide) are sufficient
- [ ] Consumer project impact assessment is acceptable (breaking change, but managed)
- [ ] Approval: **(Sign below to proceed)**

```
Approved by: Eden Nelson
Date: 2026-02-17
Comments: Approved. Proceed.
```

**If NOT approved:**
- Return to Analysis phase; adjust scope/timeline per feedback
- Document decision rationale in `.github/decisions/ADR-YYYYMMDD-skills-rejected.md`

---

## Post-Implementation

**Tracking:** Reference this plan in commit messages: `refs: plan-20260217-agent-skills-hybrid-migration`

**Rollback:** If critical issues arise during Phase 1–2, restore from git history; no permanent changes yet.

**Review Cadence:** Weekly checkpoint reviews (Stage 1); bi-weekly thereafter.

**Lessons Learned:** Post-implementation retrospective at Week 14 to capture insights for future framework-wide changes.

