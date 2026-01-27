# GOVERNANCE MAINTENANCE & PRUNING PROTOCOL

## 🛑 CRITICAL PRE-FLIGHT CHECK (RULE #0)

**BEFORE starting ANY governance maintenance workflow, verify repository context:**

**Repository Check:**

- **IF** the current repository is **NOT** "AgentGov":
  - **IMMEDIATELY REFUSE** and respond: "I cannot run governance maintenance in consumer projects. These are read-only governance imports from AgentGov. All governance changes must be made in the AgentGov repository."
  - **Do not proceed.** Do not ask for confirmation. Do not negotiate.

- **IF** the current repository **IS** "AgentGov":
  - Proceed with governance maintenance workflow below.

**How to Detect:**

- Check `.git/config` for repository name in the `url =` entry
- Check workspace files (e.g., `AgentGov.code-workspace`)
- Ask the user: "What repository are you working in?" if ambiguous

---

## 0. Invocation & Multi-Session Workflow

### Starting Governance Maintenance Mode

To begin a governance maintenance cycle, invoke with:

```text
Please start governance maintenance mode: scan all governance rules and produce an ADR-0001 format suspect list.
```

This triggers **Session 1** of a four-session workflow documented in `.github/adr/README.md`.

### ADR Numbering: Pre-Check Before Generation

Before Creating an ADR, Check Existing ADRs First:

Before generating any new ADR file:

1. **List the `.github/adr/` directory** to identify all existing ADRs (files matching `####-*.md` pattern, where `####` is a zero-padded number).
2. **Determine the next ADR number** by finding the highest existing ADR number and incrementing by 1.
3. **Use the correct filename format:** `NNNN-descriptive-title.md` (e.g., `0005-powershell-windows-compatibility.md`).
4. **Update the ADR header** to match: `# ADR-NNNN: Title`.

This prevents the manual renaming work after generation and ensures consistent numbering from the start.

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
