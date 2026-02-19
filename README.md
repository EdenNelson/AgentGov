# AgentGov

![AgentGov Logo](logo.png) #AI

Self-improving governance framework for AI agents. Portable, token-efficient standards that chain-load on demand.

## Overview

**AgentGov** is a canonical governance framework that develops rules, standards, and patterns defining optimal AI agent behavior. The project practices self-improvement — every session ingests the latest governance artifacts from this repository, ensuring continuous refinement through use and feedback.

The framework is designed for portability: separate projects ingest distributed artifacts and apply them to ensure consistent, high-quality agent behavior across both governance (policy/process work) and coding (implementation work) contexts.

### Framework Composition

1. **Behavioral Framework (Distributed to Consumer Projects)**
   - Custom Agents: role-based personas (Architect, Scribe) with distinct tool access and working relationships
   - Path-specific Instructions: governance rules + language-specific standards (auto-load based on file patterns)
   - Skills: specialized, on-demand resources (design templates for ADRs/migrations)
   - Custom Instructions: governance baseline with core principles and activation commands

2. **AgentGov Meta-Governance (Internal Only)**
   - Internal approval and change management processes
   - Governance maintenance and pruning protocols
   - Planning artifacts and architectural decision records
   - *Not distributed to consumer projects*

**Principle:** The behavioral framework ensures agents operate consistently; meta-governance ensures AgentGov evolves responsibly.

## Architecture

.github/
├── copilot-instructions.md       [Ultra-slim baseline: guards + commands]
├── agents/
│   ├── architect.agent.md        [Pragmatic Architect: full tool access]
│   └── scribe.agent.md           [Scribe: read-only access]
├── instructions/
│   ├── spec-protocol.instructions.md          [Planning discipline - auto-load all files]
│   ├── general-coding.instructions.md         [Core principles - auto-load all files]
│   ├── orchestration.instructions.md          [Change management - auto-load all files]
│   ├── powershell.instructions.md             [PS standards - auto-load *.ps1,*.psm1,*.psd1]
│   ├── bash.instructions.md                    [Bash standards - auto-load *.sh]
│   └── templates.instructions.md               [Governance templates - auto-load *.md]
├── skills/
│   ├── templates/SKILL.md                      [ADR, migration design templates - on-demand]
│   └── internal-governance/SKILL.md            [Consent, maintenance, pruning - AgentGov-only]
├── prompts/
│   └── plan-*.prompt.md                        [Durable specs: persisted plans for all significant work]
└── adrs/
    └── ADR-*.md                                [Architectural decisions and governance choices]


## How to Use

### For Agents

1. **Baseline:** `.github/copilot-instructions.md` loads automatically (governance guards, core commands)
2. **Select Agent:** Choose from `.github/agents/` (Architect for full implementation, Scribe for read-only analysis)
3. **Auto-load:** Path-specific instructions (`.github/instructions/`) auto-load based on file patterns (all files get governance rules; code files get language standards)
4. **On-demand:** Load skills (`.github/skills/`) explicitly when needed (design work, maintenance tasks)

### For Planners & Contributors

1. **Plan First:** For significant changes, draft a persisted plan: `.github/prompts/plan-<YYYYMMDD>-<topic>.prompt.md`
2. **Get Approval:** Submit written plan for explicit user approval before implementation
3. **Record Decisions:** Document architectural choices as ADRs in `.github/adrs/`
4. **Document Changes:** For user-facing changes, provide step-by-step migration guidance

### For Governance Maintenance

1. Review governance rules with the pruning protocol
2. Record governance changes as ADRs
3. Retire obsolete rules via the Clinic workflow (RCA → Deprecation)

## Distribution

Consumer projects (e.g., Sync-AgentGov) inherit this framework via `.github/sync-manifest.json`:

- **Inherits:** All Custom Agents, Path-specific Instructions, and public Skills (templates)
- **Excludes:** Internal-governance skill, plans, ADRs (AgentGov-specific)
- **Removes:** Legacy artifacts with safety gates (requires replacement resources before deletion)

The behavioral framework ensures agents operate consistently across all consuming projects while meta-governance remains internal to AgentGov.

### Sync Manifest Schema

The `.github/sync-manifest.json` defines what gets distributed to consumer projects:

```json
{
  "version": 1,
  "files": [
    ".github/copilot-instructions.md"
  ],
  "agents": {
    "root": ".github/agents"
  },
  "instructions": {
    "root": ".github/instructions"
  },
  "skills": {
    "root": ".github/skills",
    "exclude": ["internal-governance"]
  },
  "hooks": {
    "root": ".github/hooks"
  },
  "scripts": {
    "root": ".github/scripts"
  },
  "remove": [
    {
      "path": "LEGACY_FILE.md",
      "requires": ".github/replacement/FILE.md"
    }
  ]
}
```

**Infrastructure Categories:**

1. **files**: Individual baseline files (synced directly)
2. **agents**: All `*.agent.md` files from agents directory
3. **instructions**: All `*.instructions.md` files from instructions directory
4. **skills**: All `SKILL.md` files from skill subdirectories (with exclusions)
5. **hooks**: All files from hooks directory (quality validation system)
6. **scripts**: All files from scripts directory (validation tooling)
7. **remove**: Legacy files to clean up in consumer projects (with safety gates)

**Discovery Pattern:**
- agents/instructions: Flat discovery (all `*.agent.md`/`*.instructions.md`)
- skills: One level deep (`*/SKILL.md`)
- hooks/scripts: All files in directory

**Exclusions:**
- `skills.exclude` array: skill names to skip (e.g., `internal-governance`)

**Removal Safety:**
- Deprecated files are only removed if their `requires` replacement exists
- Prevents breaking consumer projects during transitions

## Quick Reference

- **Explicit Planning:** See `.github/instructions/spec-protocol.instructions.md` for the Spec Protocol hard gate
- **Consent & Breaking Changes:** Covered in governance instructions; use `/gov` command for workflows
- **Architecture Decisions:** Record in `.github/adrs/` using ADR format
- **Framework Philosophy:** See PROJECT_CONTEXT.md
