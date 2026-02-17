# AgentGov Skills Manifest

This registry lists the official skills shipped with AgentGov. Each skill is a standalone package under `.github/skills/` and is intended for on-demand use.

## Skills

| Skill Name | Path | Purpose | Activation Guidance |
| --- | --- | --- | --- |
| persona-architect | .github/skills/persona-architect/SKILL.md | Pragmatic Architect persona and behavioral rules | Default mode or when explicit persona guidance is requested |
| persona-scribe | .github/skills/persona-scribe/SKILL.md | Scribe intake and requirements gathering | When `/scribe` is invoked or user requests intake-only mode |
| standards-core | .github/skills/standards-core/SKILL.md | Core standards and general orchestration rules | Always relevant for repository work when skills are enabled |
| standards-bash | .github/skills/standards-bash/SKILL.md | Bash scripting standards | When working on `.sh` files or shell automation |
| standards-powershell | .github/skills/standards-powershell/SKILL.md | PowerShell scripting standards | When working on `.ps1`, `.psm1`, `.psd1` files |
| standards-orchestration | .github/skills/standards-orchestration/SKILL.md | Consent gates, planning workflow, and orchestration rules | When work impacts user workflows or architecture |
| templates | .github/skills/templates/SKILL.md | ADR and migration templates | When authoring ADRs or migration guides |
| internal-governance | .github/skills/internal-governance/SKILL.md | AgentGov-only maintenance and consent checklist | Internal use only; do not distribute to consumer projects |

## Notes

- Skills are designed to be modular. Keep SKILL.md content in sync with canonical files during migration.
- Custom instructions remain the always-on baseline; skills should be loaded only when relevant.
