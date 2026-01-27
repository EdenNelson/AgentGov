# ADR Automation & Rule Bankruptcy Gaps

## Problem Statement

ADRs have not been observed so far, and it is unclear whether they are being produced or where they would appear. Governance changes—including interactive sessions—lack a documented, automatic ADR draft step, leaving decisions potentially undocumented. Guidance around "Governance Insolvency" and "Rule Bankruptcy" (strategic pruning/kill switch) is not codified in the ADR workflow, and the current ADR template may not support WONTFIX/DEPRECATED outcomes. It is unclear whether the spec or standards define how and when ADRs should be generated.

## User Intent

Establish a consistent, automated ADR workflow for all governance changes (including pruning/Rule Bankruptcy cases), with a standard location and naming convention. Ensure ADRs capture decisions such as deleting unenforceable rules, allow verdicts like WONTFIX/DEPRECATED, and tie into the governance maintenance flow so every governance change leaves a documented decision trail.

## Constraints

- User prefers a standardized ADR location; current location uncertain.
- Apply to all governance changes, even interactive agent sessions; avoid skipping ADRs.
- Do not modify governance or standards files until the code team proposes a concrete trigger and location.
- Improve documentation so triggers, locations, and verification steps are obvious.

## Success Criteria

- Defined trigger(s) for ADR creation covering governance changes and pruning/Rule Bankruptcy decisions.
- Standard ADR storage path and naming scheme agreed (e.g., ADR-XYZ-number-title.md).
- ADR template/workflow supports statuses like WONTFIX and DEPRECATED alongside Proposed/Accepted/Rejected.
- ADR generation fits into the multi-session governance flow so decisions are recorded before integration.
- Documentation clearly states when ADRs are produced, where they live, and how to verify their creation.
