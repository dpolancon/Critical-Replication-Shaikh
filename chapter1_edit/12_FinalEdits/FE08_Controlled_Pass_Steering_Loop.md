# FE08: Controlled Pass Steering Loop & Lexical Audit Ledger

**Protocol Reference:** [AI_TRACE_LEXICAL_DISCIPLINE_PROTOCOL.md](file:///c:/ReposGitHub/Critical-Replication-Shaikh/chapter1_edit/12_FinalEdits/AI_TRACE_LEXICAL_DISCIPLINE_PROTOCOL.md)  
**Target Folder:** `chapter1_edit/12_FinalEdits/`  
**Target Manuscript:** `chapter1_edit/02_Versions/WP_CriticalReplication_3.0/`  
**Purpose:** Establish an operational, sequential loop to discipline and steer all Chapter 1 editing passes before applying edits to the manuscript.

---

## 1. The Iterative Pass Steering Loop

To prevent stylistic drift, machine-like cadence, and rhetorical inflation, every editing pass must cycle through the following five-step control loop:

```
┌────────────────────────────────────────────────────────────────────────────────────────┐
│                               The 5-Step Steering Loop                                 │
├───────┬───────────────────────────────┬────────────────────────────────────────────────┤
│ Step  │ Action                        │ Operational Gate / Check                       │
├───────┼───────────────────────────────┼────────────────────────────────────────────────┤
│ L1    │ Pre-Pass Lexical Audit        │ Match proposed LaTeX/diff against the 11       │
│       │                               │ pattern families in the Lexical Protocol.      │
├───────┼───────────────────────────────┼────────────────────────────────────────────────┤
│ L2    │ Classification & Ledgering    │ Classify flagged terms into A (retain),        │
│       │                               │ B (review), C (rewrite). Enter into ledger.    │
├───────┼───────────────────────────────┼────────────────────────────────────────────────┤
│ L3    │ Patch Execution               │ Apply only Category C rewrites and vetted B    │
│       │                               │ edits to the target `.tex` or `.R` file.       │
├───────┼───────────────────────────────┼────────────────────────────────────────────────┤
│ L4    │ Compilation Verification      │ Compile `main.tex` via pdflatex; verify 0      │
│       │                               │ errors, 0 broken refs, clean layout.           │
├───────┼───────────────────────────────┼────────────────────────────────────────────────┤
│ L5    │ Post-Pass De-tracing Check    │ Run regex scan for banned scaffolding; verify  │
│       │                               │ meaning and empirical results are unchanged.   │
└───────┴───────────────────────────────┴────────────────────────────────────────────────┘
```

---

## 2. Master Lexical Audit Ledger (Across Artifacts FE02–FE07)

Following Section 14 of [AI_TRACE_LEXICAL_DISCIPLINE_PROTOCOL.md](file:///c:/ReposGitHub/Critical-Replication-Shaikh/chapter1_edit/12_FinalEdits/AI_TRACE_LEXICAL_DISCIPLINE_PROTOCOL.md), every proposed modification in notes `FE02` through `FE07` has been audited and cataloged below:

| ID | Artifact & Location | Exact Phrase / Pattern | Pattern Family | Class | Proposed Disciplined Action | Meaning Preserved? | Execute? |
|:---|:---|:---|:---|:---|:---|:---|:---|
| **L01** | `FE02` \S 1 | `"Five-Pass Sequential Pipeline"` | BRANDED_JARGON | C | Replace with `"Five Sequential Editing Stages"` | Yes | YES |
| **L02** | `FE02` \S 2 | `"Pre-Flight Quality Gates"` | BRANDED_JARGON | C | Replace with `"Pre-Pass Verification Checks"` | Yes | YES |
| **L03** | `FE02` \S 2 | `"Git Safety Lock"` | BRANDED_JARGON | C | Replace with `"Version Control Guardrails"` | Yes | YES |
| **L04** | `FE03` \S 3 (3.17) | `"macroeconomic bounding... analytical boundary"` | BOUNDARY | C | Replace with `"single-sector model; it abstracts from inter-sectoral flows"` | Yes | YES |
| **L05** | `FE03` \S 3 (3.18) | `"Under an unbalanced growth closure without..."` | NOMINALIZATION | B | Replace with `"When capital and capacity grow at different rates..."` | Yes | YES |
| **L06** | `FE03` \S 3 (3.18) | `"distinct from Harrodian demand-driven knife-edge"` | CONTRAST | C | Replace with `"arises from the capital-capacity relation, not Harrodian demand"` | Yes | YES |
| **L07** | `FE03` \S 3 (3.19) | `"economically impossible over historical horizons"` | INTENSIFIER | C | Replace with `"cannot continue indefinitely"` | Yes | YES |
| **L08** | `FE03` \S 3 (3.19) | `"hard supply-side bottlenecks... rate-limiting"` | BRANDED_JARGON | C | Replace with concrete factors: `"rising wages, higher interest rates, credit limits"` | Yes | YES |
| **L09** | `FE04` \S 2 | `"Value-Added Identity Trap"` | BRANDED_JARGON | C | Replace with `"Value-Added Accounting Identity"` | Yes | YES |
| **L10** | `FE04` \S 3 (4.14) | `"fundamental patterns... extreme sensitivity... profound institutional divergence"` | INTENSIFIER / TRIAD | C | Remove stacked adjectives; state: `"highlights lag sensitivity and divergence between measures"` | Yes | YES |
| **L11** | `FE04` \S 3 (4.15) | `"fragile anchors for structural analysis"` | INTENSIFIER | C | Replace with `"depend heavily on lag specification"` | Yes | YES |
| **L12** | `FE04` \S 3 (4.16) | `"chronic capitalist overaccumulation... mechanically erase"` | INTENSIFIER / POLEMIC | C | Replace with direct empirical statement on falling output-capital ratio | Yes | YES |
| **L13** | `FE05` \S 2 | `"The Permutation Trap"` | BRANDED_JARGON | C | Replace with `"Econometric Limits of Distributive Permutations"` | Yes | YES |
| **L14** | `FE05` \S 3 (4.41) | `"cannot be identified as an isolated, purely technical engineering law"` | CONTRAST / INTENSIFIER | C | Replace with: `"Because bivariate residuals are nonstationary, distribution enters the model"` | Yes | YES |
| **L15** | `FE05` \S 3 (4.42) | `"The theoretical necessity of entering ln(e)..."` | NOMINALIZATION | B | Replace with: `"The justification for including ln(e)..."` | Yes | YES |
| **L16** | `FE05` \S 3 (4.43) | `"Crucially, the coefficient on the exploitation rate is highly statistically significant"` | SIGNPOST / INTENSIFIER | C | Remove `"Crucially"` and `"highly"`; report: `"The coefficient is statistically significant"` | Yes | YES |
| **L17** | `FE05` \S 3 (4.44) | `"This confirms that at the system level..."` | CLAIM_STRENGTH | C | Replace `"confirms"` with `"indicates"` or `"shows"` | Yes | YES |
| **L18** | `FE06` \S 3 (4.1) | `"What is at stake in admissibility is straightforward..."` | SIGNPOST | C | State directly: `"An admissible specification produces stationary residuals and stable roots"` | Yes | YES |
| **L19** | `FE06` \S 3 (4.46) | `"is not an immutable physical constant... mask this underlying fragility"` | POLEMIC / CONTRAST | C | Replace with neutral econometric report on 1947–2007 vs. 1947–2011 sensitivity | Yes | YES |
| **L20** | `FE06` \S 3 (4.47) | `"Remarkably, all six surviving specifications..."` | INTENSIFIER | C | Delete `"Remarkably"`; state: `"All six surviving specifications share..."` | Yes | YES |

---

## 3. Disciplined Pre-Pass Verification Protocol

Before applying any individual pass to `WP_CriticalReplication_3.0`:

1. **Check Against Section 1 Protected Terms:**
   * Verify that technical Marxian and econometric concepts remain intact: `transformation elasticity`, `normal capacity utilization`, `rate of exploitation`, `wage share`, `profit rate`, `Johansen trace test`, `companion matrix eigenvalues`, `Sraffa-Kurz choice of technique`, `reserve army of labor`.
2. **Eliminate Category C Rhetorical Fillers:**
   * Verify that no sentence begins with `"Taken together,"`, `"Importantly,"`, `"Crucially,"`, or `"At stake here is"`.
3. **Calibrate Causal Claims (Section 8):**
   * Change any instance of `proves`, `confirms`, `establishes`, or `demonstrates` to evidential verbs: `records`, `shows`, `indicates`, or `is consistent with`.
4. **Enforce Human Cadence (Section 12):**
   * Ensure paragraphs do not all end with grand philosophical punchlines or colon-led summaries. Vary sentence length naturally.

---

## 4. Pass Sign-Off and Execution Order

The steering loop enforces sequential sign-offs. No pass may proceed until the preceding pass has passed its verification check and received ledger confirmation:

- [x] **Loop Stage 1 (`FE03`):** Theory & Overaccumulation — *Executed, Verified & Compiled (58 pages)*
- [x] **Loop Stage 2 (`FE04`):** Figure 5 & Data Alignment — *Executed, Verified & Compiled (58 pages)*
- [x] **Loop Stage 3 (`FE05`):** Exploitation Rate & Sraffa Bridge — *Executed, Verified & Compiled (58 pages)*
- [x] **Loop Stage 4 (`FE06`):** Admissibility & Sample Windows — *Executed, Verified & Compiled (58 pages)*
- [x] **Loop Stage 5 (`FE07`):** Prose Hygiene & Basu Review — *Executed, Verified & Compiled (58 pages)*
