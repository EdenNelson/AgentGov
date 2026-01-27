# GOVERNANCE MAINTENANCE & PRUNING PROTOCOL

## 0. Invocation & Multi-Session Workflow

### Starting Governance Maintenance Mode

To begin a governance maintenance cycle, invoke with:
```
Please start governance maintenance mode: scan all governance rules and produce an ADR-0001 format suspect list.
```

This triggers **Session 1** of a four-session workflow documented in `.github/adr/README.md`.

**Expected Output:** An ADR in `.github/adr/` with status `Proposed` containing a suspect list of problematic rules.

### Multi-Session Handoff

Each session reads the ADR from the previous session and appends its findings:

| Session | Input | Process | Output | ADR Update |
| --- | --- | --- | --- | --- |
| 1 | Governance files | Scan rules | Suspect list | Create ADR, status `Proposed` |
| 2 | ADR #NNNN | Design probe test | Test plan | Add `Test Plan` section |
| 3 | ADR #NNNN + probe | Execute test & refactor | Baseline + post-change results | Add `Execution Notes` section |
| 4 | ADR #NNNN + results | Validate & integrate | Final decision + governance update | Update status to `Accepted` or `Rejected` |

See `.github/adr/README.md` for full details.

---

## 1. Principle: "Chesterton's Fence"

Do not remove a rule until you understand why it was put there. Do not remove a rule until you can prove the system maintains the behavior without it.

## 2. The Pruning Workflow (Test-Driven)

### Step 1: Isolation

Identify the specific rule candidates for removal (e.g., "Section 4.2 is too verbose").

### Step 2: The "Probe" (Unit Test)

Construct a prompt specifically designed to **trigger the rule**.

- **Context:** Clear the chat. Load the current Standards.
- **Input:** A request that strictly violates the target rule.
- **Assertion:** The Agent must catch the violation.

### Step 3: The Refactor

- **Dedup:** Remove if covered by a parent standard.
- **Compress:** Rewrite to lower token count.
- **Delete:** Remove entirely (if suspecting obsolescence).

### Step 4: Regression Check

- Clear the chat.
- Load the **Modified** Standards.
- Re-run the **Probe**.
- **Pass:** Agent still catches the violation. -> **Commit.**
- **Fail:** Agent allows the violation. -> **Revert.**

## 3. Maintenance Log (Example)

| Date | Target Rule | Probe Prompt | Result | Action |
| :--- | :--- | :--- | :--- | :--- |
