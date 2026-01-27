# Archive: Superseded Prompt Artifacts

This directory contains scribe reports and plan artifacts that have been superseded by newer decisions or implementations.

**Purpose:** Maintain a queryable history of analysis and planning that informed current governance and architecture decisions.

**Retention:** Archived files are preserved for audit trail and historical context. They are not active working documents.

## Current Archives

- `scribe-plan-20260126-governance-maintenance.md` — Analysis of governance maintenance workflow gaps (superseded by ADR-0001)
- `scribe-plan-20260126-adr-automation.md` — Analysis of ADR automation gaps (superseded by ADR-0001)

## How Artifacts Become Archived

1. A **scribe** documents analysis before planning
2. A **plan** is drafted based on the scribe
3. Once the plan is approved and implemented (resulting in an ADR with status `Accepted`), the scribe and plan artifacts are archived
4. The ADR becomes the permanent decision record; scribes and plans serve as supporting analysis

## Querying Archives

To understand why a decision was made, check the corresponding ADR in `.github/adr/`, which will reference archived scribe files in its "Prior Analysis" section.
