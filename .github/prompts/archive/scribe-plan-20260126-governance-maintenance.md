# Governance Maintenance Workflow Gaps

## Problem Statement

The governance maintenance routine is incomplete and cannot be invoked end-to-end. Current guidance in GOVERNANCE_MAINTENANCE.md sketches pruning steps but does not provide an operational entrypoint or outputs for the multi-session workflow. There is no way to trigger a full scan, enumerate suspected problematic rules (invalid, superseded, conflicting, or token-wasting), or hand off findings for targeted review. It is unclear whether the existing file fully reflects the intended flow, and there is no documented path from suspect identification through validation and ADR creation.

## User Intent

Enable a governance maintenance mode that, when invoked, scans all governance rules and produces a plan file listing suspected problematic rules with a brief rationale. Subsequent agent sessions should (a) take one suspected rule and craft a test plan to evaluate impact before and after change, (b) execute the chosen change and record results, and (c) validate the results and, if they pass, integrate the change into governance and author an ADR. Each session should have a clear entry/exit and leave artifacts for the next session to continue.

## Constraints

- Avoid altering protected governance sources unless explicitly approved: GOVERNANCE_MAINTENANCE.md, .cursorrules, and Persona files.
- Changes to governance rules must follow the multi-session flow; no in-place edits without prior suspect listing and test planning.
- ADRs should capture context, rationale, and outcomes of accepted changes.

## Success Criteria

- A documented invocation path exists to start governance maintenance mode, producing a plan that lists all suspected rules with stated issues (invalid, superseded, conflicting, or token waste).
- Clear handoff artifacts exist between sessions: suspect list (session 1), per-rule test plan (session 2), execution notes/results (session 3), and validation/ADR (session 4).
- The workflow can be run repeatedly without manual patching, and governance files remain unchanged until validation passes and ADR is written.
- The process reduces ambiguity about rule state and prevents untracked governance changes.
