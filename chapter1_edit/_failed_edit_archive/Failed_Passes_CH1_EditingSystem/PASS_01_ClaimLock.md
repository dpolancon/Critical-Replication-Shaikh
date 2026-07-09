# PASS 01 Claim Lock

Date: 2026-07-02

## Scope

First controlled claim-lock pass for Chapter 1. The pass protects `WP_CriticalReplication_2.0` and works only in the copied manuscript folder:

`C:\ReposGitHub\Critical-Replication-Shaikh\chapter1_edit\03_NewVersion\WP_CriticalReplication_2.1_claimlock`

## Repository Audit

| Item | Finding |
|---|---|
| Controlled source folder | `chapter1_edit\03_NewVersion\WP_CriticalReplication_2.0` |
| Main TeX file | `main.tex` |
| Bibliography file | `references.bib` |
| Figure folders | `figures`; `appendixA\figures` |
| Table folders | `tables`; `appendixA\tables` |
| Included TeX modules | `AppendixODE\AppendixODE.tex`; `appendixA\appendixA.tex` |
| Output PDF | `main.pdf` |
| Existing compile artifacts | `main.aux`, `main.bbl`, `main.blg`, `main.log`, `main.out`, `main.pdf` |
| Existing control diff/pass report | No pass report found in the versioned `2.0` folder. Broader `chapter1_edit` contains many feedback notes and older manuscript versions. |
| Baseline compile evidence | Existing `main.log` reports `Output written on main.pdf (53 pages, 1895269 bytes)`. Warnings include multiply defined labels for `subsec:cross_stage_synthesis` and `tab:cross_stage_synthesis`, one float placement warning, one hyperref PDF-string warning, and one float-only page warning. |

## Governing Claim

Shaikh's capacity path is arithmetically recoverable, but the structural parameter that generates it is not self-sufficient. Once interpreted as a transformation elasticity, the output-capital coefficient is sensitive to admissible ARDL choices and becomes system-admissible only when distribution and historical shock vectors enter the long-run system.

## Pass Boundary

This pass does not perform a global prose rewrite. It locks claims, records replication and econometric risks, runs the Qwen anti-smoothing scan as a subordinate diagnostic, and applies only minimal claim-severity edits to the copied `main.tex`.

