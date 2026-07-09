# Editing System Status & Strategy Report

**Project:** Critical Replication of Shaikh's Capacity Utilization Measure (Chapter 1)  
**Date:** July 4, 2026  
**Status:** Restructured & Integrated Quality Gates  

---

## 📁 1. Restructured Repository File Map

The `chapter1_edit/` directory has been reorganized. Legacy passes (Passes 1–7), old workflows, and early comments matrices have been consolidated into `_failed_edit_archive/` to separate them from the active, controlled-change editing system.

```
chapter1_edit/
├── _failed_edit_archive/             <-- CONSOLIDATED ARCHIVE (Tidied)
│   ├── Failed_Passes_CH1_EditingSystem/
│   ├── Feedback_Matrix/
│   ├── editing_artifacts/
│   ├── WorkFlow.md
│   ├── README_UNPACK.md
│   └── CH1_HumanEditingBundle_2026_07_04_drop_at_repo_root.zip
├── Versions/
│   ├── WP_CriticalReplication_2.0/   <-- CLEAN STARTING POINT (v2.0)
│   └── WP_CriticalReplication_2.7_final_consistency/ <-- REFERENCE DIFF (v2.7)
├── 00_CurrentState/                  <-- Current version status, open problems
├── 03_FailureDiagnostics/            <-- Audit logs of jargon leaks and gaps
├── 04_EditorialContracts/            <-- Style, register, and econometric locks
├── 05_AgentSkills/                   <-- Bounded subagent configuration roles
├── 06_Workflows/                     <-- Controlled-change loops and checklists
├── 07_Experiments/                   <-- Authorized section-level rewrites (EXP_01)
├── 10_Handoffs/                      <-- This report and session handoffs
└── _CH1_EDITING_INTERFACE.md         <-- Obsidian Interface entry point
```

---

## 🧠 2. Assessment of the New Editing System Structure

The newly established folder architecture inside `chapter1_edit/` (the Obsidian vault) replaces the old linear pass sequence with a **controlled-change feedback system**.

### Why the Old System Failed:
* **Linear Pass Optimization:** The old sequence treated editing as a linear production chain (e.g., `Claim Lock -> Intro Rebuild -> Naturalization`). This meant that later passes rewrote text without double-checking the constraints of earlier passes.
* **Instruction Bleeding:** Because models processed global tasks from memory, they bled internal pipeline words (like "retained criteria" or "system-admissibility gates") directly into the visible LaTeX text.
* **Audit Blindness:** The final consistency audit only checked for logical contradictions, not for style, pacing, or register fit.

### How the New System Prevents Failures:
* **Bounded Section-Level Experiments:** Rather than running global rewrites, all edits are authorized through bounded folders (e.g., [EXP_01_intro_genre_rebuild](file:///c:/ReposGitHub/Critical-Replication-Shaikh/chapter1_edit/07_Experiments/EXP_01_intro_genre_rebuild/)). An experiment is restricted to specific paragraphs and does not touch other sections, preventing system-wide drift.
* **Scaffold-to-Contract Controls:** Editing is governed by explicit markdown files:
  - [PROSE_REGISTER_CONTRACT.md](file:///c:/ReposGitHub/Critical-Replication-Shaikh/chapter1_edit/04_EditorialContracts/PROSE_REGISTER_CONTRACT.md) defines permitted terms.
  - [ECONOMETRIC_LOCKS.md](file:///c:/ReposGitHub/Critical-Replication-Shaikh/chapter1_edit/04_EditorialContracts/ECONOMETRIC_LOCKS.md) locks mathematical findings.
* **No-Edit Diagnostics Gate:** Before any rewrite is authorized, the model must perform a "No-Edit Intake" (e.g., [EXP_01_SELF_AUDIT_INTAKE.md](file:///c:/ReposGitHub/Critical-Replication-Shaikh/chapter1_edit/07_Experiments/EXP_01_intro_genre_rebuild/EXP_01_SELF_AUDIT_INTAKE.md)) to identify the specific failure layers, eligible text bounds, and success criteria.

---

## 🛠️ 3. Skills & Quality-Gate Status Report

We have integrated three tiers of editing skills and quality-gate tools:

### A. The Prose Register Gatekeeper
This gatekeeper detects internal agent-scaffolding terms and prevents them from appearing in visible prose.
* **The Lint Tool:** [check_jargon_leakage.py](file:///c:/ReposGitHub/academic-research-skills/scripts/check_jargon_leakage.py) runs locally. It parses LaTeX text (skipping comments) and checks it against a blocklist. If terms like `empirical object` or `system-admissibility gates` are found, it outputs a report and exits with code `1`, halting compilation or pipeline checks.
* **The Blocklist Config:** [jargon_leak_blocklist.json](file:///c:/ReposGitHub/academic-research-skills/academic-paper/references/jargon_leak_blocklist.json) stores the banned words and their preferred applied-econometrics alternatives.
* **The Skill:** The `/prose-register-critic` skill (defined at [SKILL.md](file:///c:/ReposGitHub/academic-research-skills/prose-register-critic/SKILL.md)) instructs writing agents to purge meta-commentary and write directly about empirical entities.

### B. Local Academic Skills (Project-Specific)
Located in [Critical-Replication-Shaikh/.agents/skills/](file:///c:/ReposGitHub/Critical-Replication-Shaikh/.agents/skills/), these represent regional expert reviewers:
* `/PE-phd-committee`: Simulates a UMass Amherst Political Economy dissertation committee (calibrated for Michael Ash, Deepankar Basu, and Kevin Young). It ensures heterodox macro modeling and time-series cointegration constraints are rigorous.
* `/advisor-reviewer`: Focuses on structural applied econometrics standards, checking for proper handling of the perpetual inventory method, ARDL specification spaces, and VECM identification.

### C. Core Academic Writing Skills (Global Library)
Reused from [academic-research-skills](file:///c:/ReposGitHub/academic-research-skills):
* `/academic-paper`: Coordinates drafting, outline design, and citation style compliance (APA 7 / Chicago).
* `/academic-paper-reviewer`: Simulates a 5-reviewer panel (EIC, peer reviewers, Devil's Advocate) to critique argument flow and methodology limits.

---

## 🔄 4. Strategy for Restarting the Edit on Version 2.0

Because Version 2.7 has been heavily contaminated with pipeline vocabulary (22 jargon leaks), we will restart the edit from the clean **Version 2.0** manuscript. 

```
[v2.0 Raw main.tex] ──► [check_jargon_leakage.py (Passes 2/2)]
       │
       ▼
[Section-by-Section EXP Loops] ◄──► [/prose-register-critic Audits]
       │
       ▼
[PE-phd-committee & Cointegration Check]
       │
       ▼
[Final Clean v3.0 Manuscript]
```

### Recommended Editing Workflow:

1. **Step 1: Baseline Verification**
   Verify the clean starting point of [WP_CriticalReplication_2.0/main.tex](file:///c:/ReposGitHub/Critical-Replication-Shaikh/chapter1_edit/Versions/WP_CriticalReplication_2.0/main.tex) by running the jargon check. It contains only **2 violations** (both are `candidate transformation elasticity`).
2. **Step 2: Section-by-Section Isolation**
   Do not run global rewrites. Authorize a separate experiment folder under `07_Experiments/` for each section:
   - `EXP_01`: Abstract & Introduction (purging the 2 initial violations and reframing the genre).
   - `EXP_02`: Section 3 Conceptual Framework.
   - `EXP_03`: Section 2.2 Political Economy boundary.
3. **Step 3: Prose Register Critic Sub-Loop**
   During the drafting of each section, invoke the `/prose-register-critic` agent. Mandate that it run the [check_jargon_leakage.py](file:///c:/ReposGitHub/academic-research-skills/scripts/check_jargon_leakage.py) script on the drafts. Any jargon found must be fixed before the draft is promoted.
4. **Step 4: Econometric & Theoretical Committee Review**
   Submit the candidate draft sections to `/PE-phd-committee` and `/advisor-reviewer` to ensure that rewriting for style has not softened the econometric rigor or altered the locked findings (such as the restricted trivariate VECM structure).
5. **Step 5: Cointegration Lock Validation**
   Confirm that the mathematical locks in [ECONOMETRIC_LOCKS.md](file:///c:/ReposGitHub/Critical-Replication-Shaikh/chapter1_edit/04_EditorialContracts/ECONOMETRIC_LOCKS.md) are fully preserved in the final combined LaTeX document before promotion to `v3.0_clean`.
