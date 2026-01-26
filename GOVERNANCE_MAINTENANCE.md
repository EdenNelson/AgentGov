# GOVERNANCE MAINTENANCE & PRUNING PROTOCOL

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
