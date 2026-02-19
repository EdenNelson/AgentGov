# SCRIBE PLAN: Context Cliff Prevention & Token Awareness

**Date:** February 18, 2026  
**Scribe Session:** Interactive intake with user  
**Repository:** AgentGov  
**Status:** Requirements captured; ready for Architect review

---

## Problem Statement

### Issue #1: Context Cliff & Loss of Work State

**What is broken:**
- Agents hit token limits ("the cliff") and become incapable of continuing work
- No automatic audit trail preservation means work state is lost at the cliff
- Current state persistence is not durable enough to enable seamless cross-session resumption
- When an agent session ends due to token exhaustion, the next agent must start from scratch

**User pain points:**
- Work is lost when hitting token limits unexpectedly
- No continuous audit trail across agent sessions
- Cannot resume complex multi-stage work after hitting the cliff
- Handoff between agents is manual and error-prone

### Issue #2: Token Usage Visibility Gap

**What is missing:**
- Users have no proactive visibility into token consumption during sessions
- Agents do not automatically report token usage as threshold is approached
- Users discover token limits only when hitting the cliff (too late)

**User pain points:**
- Surprise cliff scenarios (no warning before running out of tokens)
- Cannot plan work sessions around token budget
- No early warning system to pause work before cliff

### Issue #3: User Verification of Compliance

**What is needed:**
- Users need self-service mechanisms to verify agent compliance with governance rules
- Specifically: testing whether agents actually follow token reporting thresholds
- Broadly: mechanisms to audit agent behavior against governance standards

**User pain points:**
- "Trust but verify" - users cannot easily validate agent behavior
- No simple way to test if rules are being followed
- Compliance gaps are discovered too late (after failures occur)

### Issue #4: Proactive Reporting Compliance Gap

**What is broken:**
- Agents acknowledge token reporting rules when instructed
- Agents fail to maintain proactive reporting across subsequent responses
- Reporting only occurs when explicitly prompted by user
- Acknowledgment ≠ Enforcement (behavior does not persist)

**User pain points:**
- Rules are acknowledged but not consistently applied
- Users must repeatedly request token usage instead of receiving automatic updates
- "Proactive" behavior degrades to "reactive on-demand" over conversation

---

## User Intent

### Primary Goals

1. **Avoid the context cliff:** Prevent work loss when approaching token limits
2. **Maintain continuous audit trail:** Enable work to resume seamlessly across agent sessions
3. **Enable seamless handoff:** One agent stops cleanly; next agent picks up exactly where work stopped
4. **Proactive token awareness:** Users should receive automatic token usage reports before approaching limits
5. **Verify compliance:** Users should be able to test and validate agent governance behavior

### Specific Desired Behaviors

**At 75% Token Usage (Context Cliff Prevention):**
- Agent automatically detects threshold crossing
- Agent immediately saves checkpoint artifact containing:
  - Current work status (completed, in-progress, remaining)
  - All decisions made so far
  - Next steps and remaining work
  - Full resumption context (no gaps)
- Agent stops cleanly after checkpoint save
- Next agent session reads checkpoint and continues from exact stopping point
- No user intervention required for checkpoint process

**At 15% Token Usage (Proactive Visibility):**
- Agent automatically reports token usage at start of every response
- Reporting begins when crossing 15% threshold (30,000 tokens of 200,000 budget)
- Reporting continues automatically for all subsequent responses
- No user prompting required to maintain reporting

**For Compliance Verification:**
- Users can test agent behaviors themselves
- Verification mechanisms are simple and accessible
- Users can confirm rules are being followed without developer tools

---

## Constraints

### What We Must Avoid

1. **Manual checkpointing:** User should not need to remember to save progress
2. **Incomplete checkpoints:** Saved state must contain full resumption context (no guessing what was intended)
3. **Silent failures:** Token limit reached without warning or checkpoint save
4. **Reactive-only reporting:** Token usage should be proactive, not on-demand
5. **Compliance theater:** Rules that are acknowledged but not enforced

### Technical Unknowns (Exploration Needed)

- **Subagent capability:** User is exploring whether subagents can be used for checkpoint-and-resume pattern
- **Token counter access:** Whether agents have programmatic access to token usage data
- **Persistence mechanism:** Where checkpoints should be saved (`.github/prompts/`? dedicated checkpoint directory?)
- **Artifact naming:** Convention for checkpoint files vs. plan files vs. scribe-plan files

### Open Questions for Architect

1. **Checkpoint artifact structure:** What format/schema should checkpoint files use?
2. **Resumption protocol:** How does next agent discover and load checkpoint?
3. **Subagent integration:** Can/should subagents be used for this pattern?
4. **Testing framework:** How should compliance testing be designed?
5. **Enforcement mechanism:** How can proactive reporting be made durable across conversation turns?

---

## Success Criteria

### We Are Done When:

**For Context Cliff Prevention (75% checkpoint):**
- [ ] Agent automatically detects 75% token usage threshold
- [ ] Checkpoint is saved without user intervention
- [ ] Checkpoint contains complete resumption context (status, decisions, next steps, full context)
- [ ] Agent stops cleanly after checkpoint save
- [ ] New agent session can resume seamlessly from saved checkpoint
- [ ] Users can test checkpoint behavior and verify it works

**For Token Usage Visibility (15% reporting):**
- [ ] Agent automatically reports token usage when crossing 15% threshold
- [ ] Token usage is reported at start of every subsequent response
- [ ] Reporting continues without user prompting
- [ ] Users can verify proactive reporting is working correctly

**For Compliance Verification:**
- [ ] Users have self-service test mechanisms for verifying agent compliance
- [ ] Test mechanisms are documented and accessible
- [ ] Users can validate token reporting, checkpoint behavior, and other governance rules

**For Proactive Reporting Enforcement:**
- [ ] Agents maintain proactive behaviors across conversation turns
- [ ] Acknowledgment of rules translates to durable enforcement
- [ ] Compliance gaps are caught early (not discovered after failures)

---

## Handoff Notes for Architect

**Provenance:** This is a requirements document (scribe-plan), not a technical specification.

**User's Spark:** "I want agents to automatically write their progress to a plan or whatever appropriate artifact document whenever they reach 75% token usage."

**Translation to Paper Trail:** User wants automatic checkpoint-and-resume capability to prevent work loss at token limits, plus proactive token visibility, plus mechanisms to verify compliance.

**No Technical Solutioning Here:** The Scribe intentionally did not:
- Design the checkpoint artifact schema
- Specify implementation approach (subagents vs. other patterns)
- Define API/interfaces for resumption protocol
- Propose testing framework architecture

**That is the Architect's job.**

**Next Step:** Architect should read this scribe-plan, analyze the codebase for current state, reclassify/reframe problems if needed (per SPEC_PROTOCOL §2.4), and draft a technical plan (`plan-*.md`) with stages, checkpoints, and implementation approach.

---

## References

- SPEC_PROTOCOL.md § 2.4 (Scribe-Plan Ingestion & Architect Analysis)
- SPEC_PROTOCOL.md § 5 (Session Persistence & Recovery)
- STANDARDS_ORCHESTRATION.md (Governance enforcement patterns)
