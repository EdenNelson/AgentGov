# PLAN: Remove Markdown Linting Infrastructure

**Date:** 2026-01-24
**Author:** GitHub Copilot
**Status:** AWAITING APPROVAL
**Scope:** Remove linting tooling and simplify to behavioral directive

---

## PROBLEM STATEMENT

The markdown linting infrastructure (workflow, scripts, VS Code config) was created to catch non-compliant markdown generation. However, this misses the point: the AI should generate compliant markdown from the start, not rely on post-generation validation. The tooling adds process overhead without fixing the root cause (AI behavior).

---

## PROPOSAL

Remove all linting infrastructure and replace with simple directive: "Generate all markdown following CommonMark specification."

---

## FILES TO DELETE

1. `.github/workflows/markdown-lint.yml` - CI workflow
2. `.github/scripts/md-validate.sh` - Local validation script
3. `.markdownlint.json` - Linter configuration
4. `.vscode/settings.json` - VS Code markdown settings (or remove markdownlint section only)
5. `.vscode/extensions.json` - Extension recommendations (or remove markdownlint extension only)

---

## FILES TO MODIFY

### .github/instructions/general-coding.instructions.md

**Remove:** Section 1.3 "Markdown Compliance Checklist" (entire section, ~200 tokens)

**Replace with:** Simple directive in appropriate section:

```markdown
All markdown files must follow CommonMark specification. Key requirements:
- Blank line before/after headings and lists
- Language specified for fenced code blocks
- Final newline at end of file
```

---

## IMPACT ASSESSMENT

**Benefits:**

- Removes process overhead
- Simplifies governance (200 tokens saved in .github/instructions/general-coding.instructions.md)
- Forces correct behavior instead of catching errors

**Risks:**

- No automated catching of markdown violations
- Relies on AI to generate compliant markdown (which is what user expects)

---

## EXECUTION STEPS

1. Delete 5 files listed above
2. Update .github/instructions/general-coding.instructions.md to remove checklist, add simple directive
3. Verify no other files reference the linting infrastructure

---

## NEXT STEPS

User approval required before execution.
