# FE07: Pass 5 — Prose Hygiene & Deepankar Basu Review Readiness

**Pass Number:** 5 of 5  
**Target Manuscript:** `chapter1_edit/02_Versions/WP_CriticalReplication_3.0/section1.tex`, `section2.tex`, `section5.tex`  
**Supervisory Directive:** Preparation for Deepankar Basu Committee Review (5–10 Day Deadline, [FE01_Meeting_Summary.md](file:///c:/ReposGitHub/Critical-Replication-Shaikh/chapter1_edit/12_FinalEdits/FE01_Meeting_Summary.md#L15-L21))  
**Lexical Protocol Reference:** [AI_TRACE_LEXICAL_DISCIPLINE_PROTOCOL.md](file:///c:/ReposGitHub/Critical-Replication-Shaikh/chapter1_edit/12_FinalEdits/AI_TRACE_LEXICAL_DISCIPLINE_PROTOCOL.md)  
**Steering Loop Reference:** [FE08_Controlled_Pass_Steering_Loop.md](file:///c:/ReposGitHub/Critical-Replication-Shaikh/chapter1_edit/12_FinalEdits/FE08_Controlled_Pass_Steering_Loop.md)

---

## 1. Committee Context & Editorial Goal

As agreed in the supervisory meeting:
* **Timeline Constraint:** The revised draft must be ready for Deepankar Basu within 5 to 10 days. Deepankar will evaluate the paper on its econometric consistency (Johansen rank tests, parameter stability) and political-economic reasoning (Marxian reproduction, functional distribution, choice of technique).
* **Tone Calibration:** Remove machine-like rhetorical scaffolding. Phrases like `"therapeutic"`, `"empirical objects"`, `"black-box screening protocol"`, and `"candidate transformation elasticity"` must be replaced with standard economics terminology: *coefficients, test statistics, models, and series*.
* **Direct Opening:** The core contribution must be stated by the second paragraph of the Introduction, without preliminary throat-clearing.
* **Balanced Framing:** Shaikh’s contribution must be treated with analytical respect, framing the system results as clarifying the conditions under which capacity utilization can be identified.

---

## 2. Terminology Filter

Verify that the following terms are replaced across the manuscript:

```
┌────────────────────────────────────────────────────────────────────────────────────────┐
│                              Disciplined Terminology Filter                            │
├────────────────────────────────────────┬───────────────────────────────────────────────┤
│ Flagged / AI Phrase                    │ Disciplined Economics Phrase                  │
├────────────────────────────────────────┼───────────────────────────────────────────────┤
│ "therapeutic"                          │ "stabilizing" / "restorative"                 │
│ "empirical objects"                    │ "variables" / "series" / "estimates"          │
│ "deliberately stress test"             │ "systematically evaluate"                     │
│ "black-box screening protocol"         │ "specification grid"                          │
│ "candidate transformation elasticity"  │ "estimated output-capital elasticity (\hat{θ})"│
│ "system-admissibility gates"           │ "cointegration rank and stability criteria"   │
│ "Furthermore," / "Moreover,"           │ [Delete or vary transitions naturally]        │
│ "severe specification error"           │ "omitted variable bias"                       │
└────────────────────────────────────────┴───────────────────────────────────────────────┘
```

---

## 3. Disciplined Section Revisions

### A. Section 1 (Introduction): Opening Contribution
In [section1.tex](file:///c:/ReposGitHub/Critical-Replication-Shaikh/chapter1_edit/02_Versions/WP_CriticalReplication_3.0/section1.tex), ensure the opening clearly states the contribution:

```latex
Re-estimating Shaikh's single-equation model using US corporate data from 1947 to 2011 shows that baseline point estimates are approximately recoverable, though exact reproduction depends on data conventions and lag choices that are not fully detailed in the published tables. However, this single-equation stability does not hold in a multi-equation system. Bivariate output--capital Vector Error Correction Models (VECM) fail Johansen cointegration rank tests across the full post-war sample. The long-run output--capital relation survives only in a trivariate system that includes the logged rate of exploitation and historical shock controls in the cointegrating space. Rather than rejecting Shaikh's approach, our replication clarifies the empirical conditions—grounded in distribution-dependent choice of technique—under which a stable capacity utilization benchmark can be identified.
```

### B. Section 2 (Literature Review): Tone Calibration
In [section2.tex](file:///c:/ReposGitHub/Critical-Replication-Shaikh/chapter1_edit/02_Versions/WP_CriticalReplication_3.0/section2.tex):
* **Preserve Structure:** Keep all subheadings intact (Sections 2.1, 2.2, 2.3, 2.4).
* **Tone:** Avoid polemical rhetoric. Frame output-gap measurement as a monetary policy instrument that gained prominence during the inflation shocks of the 1970s.
* **Citation Fix:** Correct any typo in `Herdon` to `\citet{HerndonAshPollin2014}`.

### C. Section 5 (Conclusion): Evidential Calibration
In [section5.tex](file:///c:/ReposGitHub/Critical-Replication-Shaikh/chapter1_edit/02_Versions/WP_CriticalReplication_3.0/section5.tex):
* Avoid claiming that $\hat{\theta} < 1.0$ holds across all specifications without qualification.
* Note that trend-containing models produced $\hat{\theta} > 1.0$, but were excluded because time trends contaminate cointegrating vectors and generate economically implausible capacity trajectories.
* Conclude with the theoretical implication: capacity utilization cannot be treated as an isolated engineering parameter; in capitalist economies, it is conditioned by profitability, technical change, and functional distribution.

---

## 4. Pre-Flight Delivery Checklist for Deepankar Basu

Before sending the draft to Deepankar Basu and Michael Ash:

```
┌────────────────────────────────────────────────────────────────────────────────────────┐
│                        Pre-Flight Committee Submission Checklist                       │
├────┬───────────────────────────────┬──────────────────────────────────────────────────┤
│ No │ Check Item                    │ Verification Method                              │
├────┼───────────────────────────────┼──────────────────────────────────────────────────┤
│ 1  │ Compilation Cleanliness       │ 0 errors, 0 unresolved refs (??), 0 bad breaks   │
│ 2  │ Contribution Placement        │ Core claim stated in Abstract & Intro \S 1.2    │
│ 3  │ Sraffa-Kurz Grounding         │ Section 4.6 cites Kurz (1986) choice of technique│
│ 4  │ Accounting Relation           │ ln(e) = ln(π) - ln(ω) explicit in text           │
│ 5  │ Figure 5 Normalization        │ FRB series mean-normalized to 1.0; axis aligned  │
│ 6  │ Numerical Overaccumulation    │ 10% capital vs 8% capacity stated in \S 3.3      │
│ 7  │ Sample Reporting              │ Both 1947-07 (T=61) and 1947-11 (T=65) reported  │
│ 8  │ Lexical Filter Scan           │ Banned scaffolding terms absent from text        │
│ 9  │ Appendix Reference Integrity  │ Equations in AppendixODE match text references   │
│ 10 │ Document Layout               │ PDF compiles with publication-quality formatting │
└────┴───────────────────────────────┴──────────────────────────────────────────────────┘
```
