# AgentGov - Context Document

## Project Purpose

AgentGov is a self-improving governance framework for AI agents. It develops canonical rules, standards, and patterns that define optimal AI behavior. The project practices "eating its own tail" — every session ingests the latest governance files from this repository, ensuring continuous improvement.

**Core Goal:** Build the best "brain" for AI agent behavior, iteratively refined through use and feedback.

**Portability:** These governance files are designed to be consumed by separate projects. Separate projects will ingest these canonical files and distribute them to new consumer projects. All governance references are written generically (referring to "this project" or "your project") to remain portable across different contexts.

## Framework Distribution & Scope

**AgentGov serves two distinct purposes:**

1. **Behavioral Framework (Distributed):** A reusable blueprint for how AI agents should operate, think, and interact. Consumer projects import and apply this framework to ensure consistent, high-quality agent behavior across governance and coding contexts.

   - The framework emphasizes planning discipline (SPEC_PROTOCOL.md), behavioral standards (PERSONA.md, STANDARDS_*.md), and architectural rigor (ADR_TEMPLATE.md).
   - Consumer projects use the framework to guide both governance agents (policy/process work) and coding agents (implementation work).
   - Sync these to consumer projects: PERSONA.md, PERSONA_SCRIBE.md, SPEC_PROTOCOL.md, STANDARDS_CORE.md, STANDARDS_BASH.md, STANDARDS_POWERSHELL.md, STANDARDS_ORCHESTRATION.md, ADR_TEMPLATE.md.

2. **AgentGov Meta-Governance (Internal Only):** Processes specific to managing AgentGov itself — approval gates for breaking changes, governance framework maintenance, and change documentation templates.

   - These processes are internal to AgentGov and not applied in consumer projects.
   - Do not sync to consumer projects: CONSENT_CHECKLIST.md, MIGRATION_TEMPLATE.md, GOVERNANCE_MAINTENANCE.md.

**Principle:** The behavioral framework ensures agents operate consistently; the meta-governance ensures AgentGov evolves responsibly. Consumer projects inherit the framework to maintain the same agent behavior standards, but they don't inherit AgentGov's internal change management procedures.

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

## References

- Governance chain-loading, commands, and activation live in [.cursorrules](.cursorrules)
- Coding standards: [STANDARDS_CORE.md](STANDARDS_CORE.md), [STANDARDS_POWERSHELL.md](STANDARDS_POWERSHELL.md), [STANDARDS_BASH.md](STANDARDS_BASH.md)
- Governance protocols: [SPEC_PROTOCOL.md](SPEC_PROTOCOL.md), [STANDARDS_ORCHESTRATION.md](STANDARDS_ORCHESTRATION.md), [CONSENT_CHECKLIST.md](CONSENT_CHECKLIST.md)
