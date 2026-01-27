# ADR-0009: Restructure Governance Workflow to One ADR Per Rule Change

## Status

Accepted

## Date

2026-01-27

## Context

The initial governance maintenance workflow created a single ADR containing all suspect rules identified in a scan. When the workflow was invoked on 2026-01-27, it produced ADR-0005 with 9 suspect rules bundled together. This batch approach created several problems:

1. **Overwhelming scope:** Single ADR trying to test, validate, and decide on 9 independent rule changes
2. **Sequential bottleneck:** Each rule's test phase blocks the others
3. **Decision paralysis:** Difficult to accept some rules while rejecting others
4. **Testing complexity:** Single probe test cannot effectively validate multiple unrelated rules

The workflow needed restructuring to enable parallel processing and granular governance decisions.

## Decision

Restructure the governance maintenance workflow from **batch processing** (multiple rules per ADR) to **one ADR per rule change** (one rule per ADR). This allows:

- Each suspect rule to get its own ADR (ADR-0005, ADR-0006, ADR-0007, etc.)
- Independent four-session workflow for each rule
- Parallel testing and validation of unrelated rules
- Fine-grained accept/reject decisions per rule

### Changes Implemented

1. **GOVERNANCE_MAINTENANCE.md:** Updated §0 "Invocation & Multi-Session Workflow" to clarify one-ADR-per-rule approach
2. **.github/adr/README.md:** Updated governance ADR workflow table to reflect per-rule processing
3. **ADR_TEMPLATE.md:** Changed "Suspect List" to "Target Rule" section; added explicit note that governance ADRs focus on ONE rule only
4. **Process:** New pattern: Scan → Identify multiple suspects → Create separate ADR for each → Process independently

## Consequences

**Positive:**

- Each rule can be tested, rejected, or accepted independently without blocking others
- Parallel processing: Multiple ADRs can advance through sessions simultaneously
- Clearer decision records: Individual ADRs provide focused audit trails per rule
- Easier reviews: Smaller scope per ADR reduces cognitive load
- Scalability: Governance workflow now supports unlimited suspect rules without overwhelming single ADR

**Negative:**

- More ADR files in `.github/adr/` directory (9 files instead of 1 for same 9 rules)
- Slightly increased administrative overhead when reviewing related suspect rules
- More sequential ADR numbering consumption

**Risks:**

- None identified; this is a process improvement with backward compatibility

## Compliance

- **Standards:** Follows SPEC_PROTOCOL.md §7 "Governance & Standards Integration"
- **Governance:** Improves maintainability of GOVERNANCE_MAINTENANCE.md workflow
- **Workflow:** Enhances ADR discipline per ADR-0001

## Implementation Status

✅ **Completed:**
- Updated GOVERNANCE_MAINTENANCE.md with new workflow structure
- Updated .github/adr/README.md governance ADR table
- Updated ADR_TEMPLATE.md to enforce one-rule-per-ADR pattern
- Documented pattern with example ADR-0005 (originally batch, now restructured as example)

✅ **Ready for Testing:**
- Governance workflow ready to be invoked in new session
- Expected result: Multiple focused ADRs (one per suspect rule) instead of single batch ADR

## Next Invocation

When governance workflow is invoked in next session, it will:

1. Scan governance files and identify suspect rules
2. Create individual ADRs for each suspect (ADR-0005, ADR-0006, etc.)
3. Each ADR progresses independently through four-session workflow
4. No more overwhelming batch ADRs

## References

- [GOVERNANCE_MAINTENANCE.md](../../GOVERNANCE_MAINTENANCE.md) — Updated workflow
- [.github/adr/README.md](./README.md) — Updated ADR governance table
- [ADR_TEMPLATE.md](../../ADR_TEMPLATE.md) — Updated template guidance
- [ADR-0001: Establish Governance + ADR Integration Workflow](./0001-establish-governance-adr-workflow.md)
