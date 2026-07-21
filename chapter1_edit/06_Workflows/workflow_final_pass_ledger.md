# Workflow — Final Pass Ledger

## Master Ledger
`comments_final_pass.md` is the single source of truth for all v3.0 edits.

## Governing Rules
1. Per-section ledgers (`section*_comments.md`) are LEGACY. Do not read or write them.
2. All new edits are proposed in `comments_final_pass.md`.
3. Lock state is authoritative: `[x]` = locked (do not touch), `[ ]` = unlocked (eligible).
4. No edit may be applied to `.tex` without first being recorded in the master ledger.

## Workflow Steps
1. **Review**: Read the master ledger entry for the target paragraph.
2. **Critique**: Verify the "Observations or Comments" section captures advisor and structural feedback.
3. **Draft**: Write or refine the "New Version" block.
4. **Lock decision**: Leave unlocked for batch application, or lock to protect from changes.
5. **Apply**: Run `python apply_final_pass.py` (simulates edits in dry-run mode). Once reviewed, run `python apply_final_pass.py --apply` to modify `.tex` files.
6. **Compile**: Run `latexmk` on `main.tex` to verify no compilation errors.
7. **Handoff**: Update `session_handoff.md` with what was applied.

## Forbidden Actions
- No edits to `.tex` files outside the master ledger pipeline.
- No running `generate_comments_ledger.py` (legacy).
- No running `apply_comments_ledger.py` (legacy).
