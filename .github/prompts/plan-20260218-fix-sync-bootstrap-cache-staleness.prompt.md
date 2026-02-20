# PLAN: Fix Sync Script Bootstrap Cache Staleness for Hook Configurations

**Date:** February 18, 2026  
**Status:** Awaiting Approval  
**Scope:** Bug fix in Sync-AgentGov.ps1; affects all consumer projects  
**Priority:** High (blocking hook functionality in consumer projects)  

---

## Problem Statement

The `Sync-AgentGov.ps1` script caches governance files (including hook configurations) in `.github/prompts/bootstrap-cache/` for recovery if remote fetch fails. However, the cached hook configuration files contain an outdated format that does not match the current AgentGov specification.

**Symptoms in Consumer Projects:**
- `.github/prompts/bootstrap-cache/.github/hooks/quality-validation.json` uses old property names:
  - `"PostToolUse"` (uppercase) instead of `"preToolUse"` / `"postToolUse"` (lowercase)
  - `"command"` property instead of `"bash"`
  - `"timeout"` instead of `"timeoutSec"`
  - Missing `"version": 1`
- This forces the agent to load stale hook config, causing hooks not to trigger
- User workaround: manually delete the bootstrap cache; fresh download from AgentGov works

**Root Cause:**
The bootstrap cache was populated at some earlier point (likely before hook config schema was finalized) and never refreshed. The caching logic in `Sync-GovernanceFile()` only updates cache if remote file hash differs, but this assumes cache content is initially correct.

**Impact:**
- Hooks fail silently in consumer projects
- PowerShell signatures don't get stripped (hook is supposed to run `prep-file.sh`)
- Users must manually delete `.github/prompts/bootstrap-cache/` to get working hooks
- Sync script is the source of the problem, not a consumer project issue

---

## Analysis & Assessment

### Current State

1. **Sync Script Behavior:**
   - Line 90: Creates CacheDir at `.github/prompts/bootstrap-cache/`
   - Lines ~965-975: Syncs all governance files (including hooks) to both target AND cache
   - Caching logic: Only update if remote content is newer (hash comparison)

2. **Hook Configuration Evolution:**
   - Old format: `PostToolUse`, `command`, `timeout` (used in cache)
   - Current format: `preToolUse`/`postToolUse`, `bash`, `timeoutSec`, `"version": 1` (in AgentGov)
   - Schema is defined in AgentGov `.github/hooks/quality-validation.json`

3. **Why Cache Became Stale:**
   - Likely created before schema was finalized
   - No validation of cache content format
   - No TTL/refresh policy for cached hook configs
   - Consumer projects inherit the stale cache from Sync-AgentGov

### Trade-off Analysis

| Option | Pros | Cons |
|--------|------|------|
| **A: Force refresh cache** | Guarantees latest config | Extra network calls; slower bootstrap |
| **B: Exclude hooks from cache** | Always fetch fresh; no stale config | No recovery if AgentGov unavailable |
| **C: Validate & regenerate cache** | Detects stale format; regenerates if needed | Complex validation logic |
| **D: Delete cache, start fresh** | Simple; immediate fix | Requires manual cleanup in all consumer projects |

### Selected Approach

**Hybrid: Exclude hooks from bootstrap cache (Option B) + Validate on load (Option C)**

- **Why:** Hook configurations are critical for CI/CD integrity. Fresh-only strategy is safer than relying on stale cache.
- **Rationale:** Hooks change more frequently than other governance files (e.g., instructions, skills); caching stale hook config is riskier than caching stale documentation.
- **Fallback:** If remote fetch fails, agent can still activate with default behavior (hooks disabled is safer than hooks firing with wrong config).

### Risk Assessment

- **Risk Level:** Low (governance file, no user data at stake)
- **Affected Surfaces:** Consumer project bootstrap; hook triggering in agent
- **Rollback:** Delete bootstrap-cache; re-run Sync-AgentGov.ps1
- **Testing:** Run on Sync-AgentGov itself; verify `.github/hooks/quality-validation.json` loads correctly

---

## Plan: Implementation Stages

### STAGE 1: Update Sync-AgentGov.ps1 to Exclude Hooks from Bootstrap Cache

**Objective:**  
Modify `Sync-GovernanceFile()` to skip caching for hook-related files.

**Deliverables:**
- [ ] Identify hook file paths (`.github/hooks/*.json`)
- [ ] Add skip-cache logic for hook files in `Sync-GovernanceFile()` function
- [ ] Ensure non-hook files continue to use cache (e.g., instructions, skills)
- [ ] Add verbose logging for cache skip decisions

**Checkpoint:** Hook files are synced but NOT cached; non-hook files continue using cache

**Code Location:** `/Users/nelson/Documents/GitHub/Sync-AgentGov/Sync-AgentGov.ps1`, function `Sync-GovernanceFile()` (~lines 700-800)

---

### STAGE 2: Add Hook Configuration Validation (Optional Safety Net)

**Objective:**  
Ensure loaded hook config matches current schema; regenerate if stale.

**Deliverables:**
- [ ] Create validation function `Test-HookConfigFormat()` to check for required properties
- [ ] Add validation after hook file is loaded
- [ ] If validation fails, log warning and continue without caching

**Checkpoint:** Hook config validation is in place; stale configs are detected

**Code Location:** New helper function in Sync-AgentGov.ps1

---

### STAGE 3: Clean Up Stale Bootstrap Caches in Existing Consumer Projects

**Objective:**  
Remove old bootstrap caches so fresh downloads take effect.

**Deliverables:**
- [ ] Document cleanup step in README or MIGRATION_NOTES
- [ ] Provide script or manual instructions to delete `.github/prompts/bootstrap-cache/`
- [ ] Verify hooks work after cleanup

**Checkpoint:** Consumer projects have fresh bootstrap state

---

### STAGE 4: Test and Validate Fix

**Objective:**  
Verify hook functionality works correctly with fix applied.

**Deliverables:**
- [ ] Run Sync-AgentGov.ps1 on Sync-AgentGov project
- [ ] Verify `.github/prompts/bootstrap-cache/` does NOT contain hook files
- [ ] Run Sync-AgentGov.ps1 on a consumer project (e.g., AgentGov-StaffImport)
- [ ] Verify hooks trigger correctly for PowerShell file modifications
- [ ] Confirm signature stripping works end-to-end

**Checkpoint:** Hooks fire and signatures strip in consumer projects

---

## Consent Gate

- **Breaking Change:** No  
- **User-Facing Impact:** No (internal bootstrap fix)
- **Consumer Project Impact:** Yes (hooks will work correctly)
- **Migration Required:** No (automatic on next Sync-AgentGov.ps1 run)

**Approval Requested:**
- Should we exclude hooks from bootstrap cache to ensure freshness?
- Is validation/regeneration of stale hook config necessary, or is skip-cache sufficient?

---

## Persistence & Recovery

- **Plan Artifact:** `.github/prompts/plan-20260218-fix-sync-bootstrap-cache-staleness.prompt.md`
- **Implementation Location:** `/Users/nelson/Documents/GitHub/Sync-AgentGov/Sync-AgentGov.ps1`
- **If Session Crashes:** Read this plan, resume from last completed stage checkpoint

---

## References

- **Root Cause Discovery:** Consumer projects had `.github/prompts/bootstrap-cache/.github/hooks/quality-validation.json` with old format
- **Related Issue:** PowerShell signature stripping not working due to hooks not firing
- **AgentGov Hook Schema:** `.github/hooks/quality-validation.json`
- **Specrc:** spec-protocol.instructions.md § 2–4
