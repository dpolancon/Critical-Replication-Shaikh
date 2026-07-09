# Workflow — Section Rebuild Loop

## Governing rule

No more “next pass because the last pass ended.”

Only run a new loop when the system can state:

- what failed;
- which layer owns the failure;
- which paragraphs are eligible;
- what benchmark will prove the revision is better;
- what would count as a failed experiment.

## Loop structure

1. Intake.
2. Diagnosis.
3. Paragraph lock.
4. Layered assessment.
5. Candidate rewrite.
6. Self-test.
7. Delta test.
8. Promotion decision.
9. Handoff.

## Forbidden actions

No staging, no commit, no push, no global rewrite, and no edits outside paragraph lock.
