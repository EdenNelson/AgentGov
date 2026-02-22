# PLAN: Document Multi-Agent Pipeline in Spec Protocol
-*Date:** February 21, 2026
-*Status:** Draft (Awaiting Approval)
-*Scope:** Governance enhancement—integrate 5-stage pipeline into spec-protocol.instructions.md
-*Breaking Change:** No (additive documentation only)
## Problem Statement
The repository contains 5 custom agents (Scribe, Code Planner, Edge Planner, Planning Architect, Architect) that form a research-to-implementation pipeline:
```
Scribe → Code Planner → Edge Planner → Planning Architect → Architect
   ↓           ↓              ↓                ↓              ↓
scribe-plan  code-context  risk-assessment  draft-plan  implementation
```
However, this pipeline is **not documented** in spec-protocol.instructions.md, creating multiple coherence issues:
1. **Spec Protocol §2.4** describes direct Scribe → Architect flow, not the 5-stage pipeline
2. **No activation mechanism** defined for intermediate agents
3. **No artifact lifecycle** documented (creation, review, promotion)
4. **No approval gates** for intermediate artifacts
5. **Tool capability mismatch** (agents declare `["read", "search", "edit"]` but need file creation)
6. **State mutation strategy** undefined (frontmatter status tagging vs. immutability)
7. **Draft-plan → plan promotion** workflow missing
## Analysis & Assessment
### Current State
-*What Exists:**
- 5 well-designed agent personas with clear roles
- Logical sequential workflow (internally coherent)
- Consistent naming convention (`<YYYYMMDD>-<topic>`)
- State management pattern (status tagging in frontmatter)
-*What's Missing:**
- Integration with Spec Protocol approval gates
- Activation commands and mode switching rules
- Artifact lifecycle and archive strategy
- Tool capability corrections
- Promotion workflow from draft-plan to plan
### Alternatives Considered
-*Option A: Document Full Pipeline (Recommended)**
- Preserves investment in 5-agent design
- Adds governance rigor to research phase
- Maintains separation of concerns (research vs. implementation)
- **Trade-off:** More complexity, longer learning curve
-*Option B: Simplify to Two-Agent**
- Merge Code/Edge/Planning into single "Research Agent"
- Reduces file proliferation, simpler activation
- **Trade-off:** Loses granular role specialization
-*Option C: Deprecate Pipeline**
- Keep only Scribe + Architect
- Simplest governance surface
- **Trade-off:** Loses systematic research framework for complex work
### Risks
1. **Complexity Risk:** Adding 5-stage pipeline may overwhelm users unfamiliar with AgentGov
2. **Activation UX:** Users need clear guidance when to use pipeline vs. direct Scribe → Architect
3. **Artifact Bloat:** 4+ files per requirement could clutter `.github/prompts/`
4. **Maintenance Burden:** More agents = more governance surface to maintain
### Mitigation Strategies
1. **Clear Decision Tree:** Document when to use pipeline (complex refactors, multi-system changes) vs. simple flow (single-file fixes, docs)
2. **Activation Commands:** Define `/codeplanner`, `/edgeplanner`, `/planningarchitect` or auto-chain option
3. **Archive Strategy:** Move completed pipeline artifacts to `.github/prompts/archive/<YYYYMMDD>-<topic>/`
4. **Tool Capability Fix:** Update agent frontmatter to include `create_file` capability
## Plan
### Stage 1: Update Agent Frontmatter (Tool Capabilities)
-*Objective:** Correct tool declarations for pipeline agents
-*Deliverables:**
- [ ] Update code-planner.agent.md: `tools: ["read", "search", "edit", "create_file"]`
- [ ] Update edge-planner.agent.md: `tools: ["read", "search", "edit", "create_file"]`
- [ ] Update planning-architect.agent.md: `tools: ["read", "search", "edit", "create_file"]`
-*Checkpoint:** Agent frontmatter matches actual capabilities
### Stage 2: Add §2.6 to spec-protocol.instructions.md
-*Objective:** Document multi-agent pipeline workflow
-*Deliverables:**
- [ ] New section: §2.6 "Multi-Agent Research Pipeline"
- [ ] Subsections:
  - §2.6.1 When to Use Pipeline vs. Direct Flow
  - §2.6.2 Pipeline Stages and Artifacts
  - §2.6.3 Activation Mechanism
  - §2.6.4 State Management and Frontmatter Status
  - §2.6.5 Artifact Lifecycle and Archive Strategy
  - §2.6.6 Promotion Workflow (draft-plan → plan)
- [ ] Workflow diagram (ASCII art)
- [ ] Decision tree (simple vs. complex work)
-*Checkpoint:** Pipeline workflow fully documented with clear activation rules
### Stage 3: Update copilot-instructions.md
-*Objective:** Add activation commands for pipeline agents
-*Deliverables:**
- [ ] Add commands: `/codeplanner`, `/edgeplanner`, `/planningarchitect`
- [ ] Update `/context` command to report active pipeline agent
- [ ] Add "Agent Chaining" subsection explaining auto-progression
- [ ] Update "Persona Activation & Mode Switching" to include pipeline agents
-*Checkpoint:** Users can activate and verify pipeline agent context
### Stage 4: Update Architect Execution Protocol
-*Objective:** Align Architect agent with pipeline integration
-*Deliverables:**
- [ ] Update architect.agent.md "Execution Protocol" section
- [ ] Add check: "Is there a draft-plan-*.md from Planning Architect?"
- [ ] Define priority: draft-plan > scribe-plan (if both exist)
- [ ] Clarify when to read scribe-plan directly vs. through pipeline
-*Checkpoint:** Architect agent correctly ingests pipeline artifacts
### Stage 5: Document Archive Strategy
-*Objective:** Prevent `.github/prompts/` clutter
-*Deliverables:**
- [ ] Create `.github/prompts/archive/` directory structure
- [ ] Document archival rules in spec-protocol.instructions.md §2.6.5
- [ ] Pattern: After plan approval, move all artifacts to `archive/<YYYYMMDD>-<topic>/`
- [ ] Exception: Keep final `plan-*.md` in root for audit trail
-*Checkpoint:** Clear rules for artifact lifecycle and cleanup
### Stage 6: Update Spec Protocol §2.4 (Scribe-Plan Ingestion)
-*Objective:** Reconcile §2.4 with pipeline workflow
-*Deliverables:**
- [ ] Clarify §2.4 describes "Direct Flow" (Scribe → Architect)
- [ ] Add reference: "For complex work, see §2.6 Multi-Agent Pipeline"
- [ ] Maintain Architect as classification authority in both flows
-*Checkpoint:** No contradiction between §2.4 and §2.6
## Consent Gate
-*Change Type:** Non-breaking (additive documentation only)
-*Impact Assessment:**
- **User-facing:** New activation commands, clearer workflow options
- **Governance:** Expanded spec-protocol.instructions.md, updated copilot-instructions.md
- **Backward Compatibility:** Existing Scribe → Architect flow unchanged
-*User Action Required:** None (optional workflow, not mandatory)
-*Approval Requested:**
- [ ] Approve documenting 5-stage pipeline in Spec Protocol
- [ ] Approve tool capability corrections for pipeline agents
- [ ] Approve activation commands and archive strategy
-*Approved by:** Eden Nelson
-*Date:** 2026-02-21
## Persistence & Recovery
-*Artifacts Created:**
1. Updated agent files: code-planner.agent.md, edge-planner.agent.md, planning-architect.agent.md, architect.agent.md
2. Updated spec-protocol.instructions.md (new §2.6, revised §2.4)
3. Updated copilot-instructions.md (activation commands)
-*Recovery Strategy:**
- All changes in one commit: "Document multi-agent pipeline per plan-20260221-multiAgentPipelineDocumentation.prompt.md"
- Checkpoints allow partial completion if session crashes
- Plan artifact persists in `.github/prompts/` for reference
## Expected Outcomes
1. **Pipeline Integration:** Full documentation of 5-stage research workflow
2. **Clear Activation:** Users know when and how to use pipeline vs. direct flow
3. **Tool Correctness:** Agent capabilities match actual usage
4. **Artifact Management:** Archive strategy prevents directory bloat
5. **No Regressions:** Existing Scribe → Architect flow remains unchanged
## References
- **spec-protocol.instructions.md** §2.4 (Scribe-Plan Ingestion & Architect Analysis)
- **copilot-instructions.md** (Persona Activation & Mode Switching)
- **.github/agents/** (all 5 agent personas)
- **Agent Review (this session):** Comprehensive analysis of pipeline coherence
