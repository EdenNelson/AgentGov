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

## References

- Governance chain-loading, commands, and activation live in [.cursorrules](.cursorrules)
- Coding standards: [STANDARDS_CORE.md](STANDARDS_CORE.md), [STANDARDS_POWERSHELL.md](STANDARDS_POWERSHELL.md), [STANDARDS_BASH.md](STANDARDS_BASH.md)
- Governance protocols: [SPEC_PROTOCOL.md](SPEC_PROTOCOL.md), [STANDARDS_ORCHESTRATION.md](STANDARDS_ORCHESTRATION.md), [CONSENT_CHECKLIST.md](CONSENT_CHECKLIST.md)
