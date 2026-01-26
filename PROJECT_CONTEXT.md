# AgentGov - Context Document

## Project Purpose

AgentGov is a self-improving governance framework for AI agents. It develops canonical rules, standards, and patterns that define optimal AI behavior. The project practices "eating its own tail" — every session ingests the latest governance files from this repository, ensuring continuous improvement.

**Core Goal:** Build the best "brain" for AI agent behavior, iteratively refined through use and feedback.

**Portability:** These governance files are designed to be consumed by separate projects. Separate projects will ingest these canonical files and distribute them to new consumer projects. All governance references are written generically (referring to "this project" or "your project") to remain portable across different contexts.

## Governance Framework Files

This project maintains these canonical governance files:

- **PERSONA.md**: Interaction model, tone, and behavioral constraints
- **STANDARDS_CORE.md**: Core coding principles, markdown compliance, API patterns
- **STANDARDS_BASH.md**: Bash-specific coding rules
- **STANDARDS_POWERSHELL.md**: PowerShell-specific coding rules
- **STANDARDS_ORCHESTRATION.md**: Consent gates and change management
- **SPEC_PROTOCOL.md**: Hard gate between architectural planning and implementation
- **CONSENT_CHECKLIST.md**: User approval gates for breaking changes
- **.cursorrules**: Dynamic context ingestion and rule loading

These files are **canonical** — they evolve in this project and define optimal AI agent behavior. Each new session loads the latest versions, creating a feedback loop where the project continuously improves itself.

---

## Dynamic Chain-Load Architecture

### Concept

Governance standards are loaded dynamically in response to work patterns, not upfront in bulk. Each standards file declares its own activation conditions and chains to the next file when triggered.

### How It Works

1. **Initial Load (.cursorrules):** Base tier only
   - PERSONA.md
   - PROJECT_CONTEXT.md
   - SPEC_PROTOCOL.md
   - Detected language standards (e.g., STANDARDS_POWERSHELL.md if PowerShell detected)

2. **Dynamic Chaining:** Standards files contain activation metadata
   - Each file declares: `DO NOT LOAD UNTIL: [condition]`
   - Each file declares: `CHAINS TO: [next file]`
   - When condition is triggered by user work, the file loads
   - That file may declare a chain to another file

3. **Chain Propagation:** Happens in response to actual patterns
   - User writes a loop → STANDARDS_POWERSHELL_LOOPS.md auto-loads
   - Loop error handling needed → STANDARDS_POWERSHELL_ERROR_HANDLING.md auto-loads
   - Refactoring begins → STANDARDS_MIGRATION.md auto-loads
   - Security review triggered → STANDARDS_SECURITY.md auto-loads

### Example Chain in Action

```text
.cursorrules loads: STANDARDS_POWERSHELL_CORE.md
↓
Rule in CORE declares:
  DO NOT LOAD UNTIL: Loop patterns detected
  CHAINS TO: STANDARDS_POWERSHELL_LOOPS.md
↓
User code uses loops
↓
STANDARDS_POWERSHELL_LOOPS.md auto-loads
↓
Rule in LOOPS declares:
  DO NOT LOAD UNTIL: Error handling needed
  CHAINS TO: STANDARDS_POWERSHELL_ERROR_HANDLING.md
↓
User implements try-catch
↓
STANDARDS_POWERSHELL_ERROR_HANDLING.md auto-loads
```

### Token Efficiency

- Only standards relevant to current work load
- Chains activate on-demand, not preemptively
- Legacy script refactoring loads only needed governance
- External projects consume minimal context

### Implementation

Each standards file includes metadata section stating:

- Current purpose/scope
- `DO NOT LOAD UNTIL: [specific pattern/condition]`
- `CHAINS TO: [next file in sequence]` (if applicable)

### Scaling as Complexity Increases

As AgentGov grows, standards files split to maintain efficiency:

1. **Detection:** Scaling routine monitors file size and complexity metrics
2. **Threshold:** When complexity exceeds defined threshold (TBD), file is marked for splitting
3. **Split:** Monolithic file divides into focused sub-standards
   - Example: `STANDARDS_POWERSHELL.md` → `STANDARDS_POWERSHELL_CORE.md` + `STANDARDS_POWERSHELL_LOOPS.md` + `STANDARDS_POWERSHELL_ERROR_HANDLING.md`
4. **Chain Update:** New chain metadata and `.cursorrules` auto-update to reflect structure

This ensures governance scales with project complexity without token bloat.

---

## Coding Standards

- Refer to [STANDARDS_CORE.md](STANDARDS_CORE.md) for Core coding rules.
- Refer to [STANDARDS_POWERSHELL.md](STANDARDS_POWERSHELL.md) for powershell-specific coding rules.
- Refer to [STANDARDS_BASH.md](STANDARDS_BASH.md) for Bash-specific coding rules.

## Governance & Specification Protocol

- Refer to [SPEC_PROTOCOL.md](SPEC_PROTOCOL.md) for Explicit State Reification and the hard gate between architectural thinking and code generation.
- Refer to [STANDARDS_ORCHESTRATION.md](STANDARDS_ORCHESTRATION.md) for Consent Gate and Non-Ephemeral Planning requirements.
- Refer to [CONSENT_CHECKLIST.md](CONSENT_CHECKLIST.md) for user approval gates on breaking changes.

## Working Modes

Use these commands to signal context and ensure proper pre-flight checks:

### `/gov` - Governance Framework Mode

**Scope:** Work on governance framework (PERSONA, STANDARDS, SPEC_PROTOCOL, CONSENT_CHECKLIST, .cursorrules)

- **Pre-Flight:** Verify SPEC_PROTOCOL.md compliance; ensure plan exists and is approved for significant changes
- **Constraints:** These are canonical files; changes affect all downstream projects
- **Markdown:** Enforce strict markdown compliance per STANDARDS_CORE.md
- **Think First:** Consider impact on all downstream projects before proposing changes
