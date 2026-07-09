# PASS 02 Econometric Coherence

Date: 2026-07-03

## Version Audit

| Item | Finding |
|---|---|
| Controlling HAP standard | `C:\ReposGitHub\Critical-Replication-Shaikh\chapter1_edit\CH1_EditingSystem\STYLE_HAP_CriticalReplication.md` was read on 2026-07-03 and applied as the repo-local definition of HAP-style critical replication. |
| Source copied from | `C:\ReposGitHub\Critical-Replication-Shaikh\chapter1_edit\03_NewVersion\WP_CriticalReplication_2.1_claimlock` |
| New working version | `C:\ReposGitHub\Critical-Replication-Shaikh\chapter1_edit\03_NewVersion\WP_CriticalReplication_2.2_econcoherence` |
| Main TeX file | `main.tex` |
| Bibliography file | `references.bib` |
| Output PDF | `main.pdf` |
| Figure folders | `figures`; `appendixA\figures` |
| Table folders | `tables`; `appendixA\tables` |
| Build method | `latexmk -pdf -interaction=nonstopmode -halt-on-error main.tex` |
| Pass objective | Repair econometric coherence, notation consistency, LaTeX structural warnings, and claim severity without rewriting the chapter. |

## Updated Editorial Hierarchy

1. HAP critical-replication standard from `STYLE_HAP_CriticalReplication.md`.
2. Econometric coherence.
3. Political-economy measurement interpretation.
4. Historiographical mechanism discipline.
5. Qwen/AI-trace stress test only as subordinate surface diagnostic.

## Files Inspected

| File | Purpose |
|---|---|
| `WP_CriticalReplication_2.2_econcoherence\main.tex` | Main source; notation, admissibility, S2, conclusion, and data-construction edits |
| `WP_CriticalReplication_2.2_econcoherence\appendixA\appendixA.tex` | Hyperref and overfull-box fixes |
| `WP_CriticalReplication_2.2_econcoherence\main.log` | Warning audit before and after structural fixes |
| `WP_CriticalReplication_2.2_econcoherence\tables\tab_S2_retained_trivariate_specs.tex` | Source table for `theta=1.19` decision |
| `WP_CriticalReplication_2.2_econcoherence\references.bib` | Existing source support for historical/demand claims |
| `CH1_EditingSystem\PASS_01_EconometricCoherence.md` | Pass 1 boundary document |
| `CH1_EditingSystem\PASS_01_Report.md` | Pass 1 parked issues |

## Files Expected to be Edited

| File | Edit class |
|---|---|
| `main.tex` | Duplicate-label fixes, notation lock, admissibility definitions, S2 `theta=1.19` classification, data-construction cleanup, historical shock softening, conclusion calibration |
| `appendixA\appendixA.tex` | Hyperref bookmark fix and local appendix overfull-box fixes |
| `CH1_EditingSystem\PASS_02_*.md` | Pass 2 ledgers and report |

## Structural Warning Checkpoint

Pass 1 compile warnings included duplicate `cross_stage_synthesis` labels, `!h` float changes, a hyperref PDF-string warning, severe overfull boxes, and a float-only appendix page.

Structural fixes made:

- Renamed the methodological synthesis labels to `subsec:stage_design_synthesis` and `tab:stage_design_synthesis`.
- Changed local `[h!]` table placements to `[H]`.
- Fixed the appendix common-deflator PDF bookmark by giving it a text-only optional title.
- Shortened the severe overfull table/appendix entries without changing substantive content.

Checkpoint compile result: success. Duplicate-label warnings, float-specifier warnings, and hyperref PDF-string warnings were cleared. Remaining warnings are local overfull boxes and one appendix float-only page.
