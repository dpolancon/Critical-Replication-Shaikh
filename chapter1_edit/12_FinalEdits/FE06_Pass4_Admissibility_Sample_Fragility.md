# FE06: Pass 4 — Cointegration Admissibility & Sample Window Sensitivity

**Pass Number:** 4 of 5  
**Target Manuscript:** `chapter1_edit/02_Versions/WP_CriticalReplication_3.0/section4.tex` (Paragraphs 4.1–4.2, Lines 95–115; Paragraphs 4.45–4.47, Lines 620–660)  
**Associated Document:** [output/S2_vecm/S2_BUNDLE_INTERPRETATION.md](file:///c:/ReposGitHub/Critical-Replication-Shaikh/output/S2_vecm/S2_BUNDLE_INTERPRETATION.md)  
**Advisor Reference:** [FE01_Meeting_Summary.md](file:///c:/ReposGitHub/Critical-Replication-Shaikh/chapter1_edit/12_FinalEdits/FE01_Meeting_Summary.md#L30-L37), handwritten feedback Items 43, 44, 49, 56 ([Feedback_Matrix.md](file:///c:/ReposGitHub/Critical-Replication-Shaikh/chapter1_edit/_failed_edit_archive/Feedback_Matrix/Feedback_Matrix.md))  
**Lexical Audit Status:** Disciplined via [FE08_Controlled_Pass_Steering_Loop.md](file:///c:/ReposGitHub/Critical-Replication-Shaikh/chapter1_edit/12_FinalEdits/FE08_Controlled_Pass_Steering_Loop.md) (Items L18–L20)

---

## 1. Advisor Critique & Editorial Goal

In the supervisory meeting, Michael Ash noted:
1. **Demystify Admissibility:** Rather than presenting admissibility as a complex procedural protocol, explain it simply in terms of residual stationarity: nonstationary residuals mean spurious regression.
2. **De-emphasize Information Criterion Counts:** Focus on whether models pass cointegration and dynamic stability tests, rather than detailing every AIC, BIC, HQ, and ICOMP comparison.
3. **Report Sample Sensitivity Openly:** Explain why the bivariate system produces 12 cointegrating specifications over 1947–2007 ($T=61$), but 0 over 1947–2011 ($T=65$).
4. **Use Illustrative Counterfactuals:** Present the $\theta = 1$ restriction in S1 and the no-dummy specification in S2 as pedagogical examples that clarify what fails when standard assumptions are imposed.

---

## 2. Econometric Criteria Summary

```
┌────────────────────────────────────────────────────────────────────────────────────────┐
│                          Cointegration Admissibility Criteria                          │
├─────────────────────┬──────────────────────────────┬───────────────────────────────────┤
│ Model Class         │ Statistical Test             │ Economic Consequence of Failure   │
├─────────────────────┼──────────────────────────────┼───────────────────────────────────┤
│ Single-Equation     │ Pesaran et al. (2001)        │ Residuals contain a unit root;    │
│ ARDL (Stage S1)     │ F-statistic > Upper Bound    │ estimated capacity ceiling drifts │
│                     │                              │ arbitrarily away from output.     │
├─────────────────────┼──────────────────────────────┼───────────────────────────────────┤
│ Multi-Equation      │ 1. Maximum likelihood solves │ Fails rank test: no cointegrating │
│ VECM (Stage S2)     │ 2. Johansen trace p < 0.05   │ vector exists; unstable companion │
│                     │ 3. Companion eigenvalues ≤ 1 │ matrix implies explosive system.  │
└─────────────────────┴──────────────────────────────┴───────────────────────────────────┘
```

### Sample Window Sensitivity
* Over **1947–2007** ($T=61$, pre-Great Recession), bivariate $(\ln Y, \ln K)$ models yield 12 cointegrating specifications with $\hat{\theta} \in [0.88, 0.91]$.
* Extending the sample to **1947–2011** ($T=65$) includes the 2008–2011 contraction. Output fell sharply while the capital stock adjusted slowly, producing nonstationary residuals. Consequently, the Johansen trace test fails to reject $r=0$ at the 5% level across all 48 bivariate models.
* The trivariate system $(\ln Y, \ln K, \ln e)$ maintains cointegration over the full 1947–2011 sample across 6 specifications, all of which require step dummies for 1956, 1974, and 1980.

---

## 3. Disciplined LaTeX Replacement Block in `section4.tex`

### Target: Paragraphs 4.1–4.2 (Lines 95–115) — Defining Admissibility
Replace lines 95–115 in [section4.tex](file:///c:/ReposGitHub/Critical-Replication-Shaikh/chapter1_edit/02_Versions/WP_CriticalReplication_3.0/section4.tex) with the following disciplined text:

```latex
\paragraph{4.1}
In this chapter, an admissible specification is one that produces stationary residuals and stable dynamic roots. If an estimated model fails cointegration, its residuals contain a unit root, meaning output and capital drift apart without a long-run equilibrium. Capacity utilization series derived from non-cointegrated specifications are spurious, as the estimated capacity ceiling wanders away from actual output.

\paragraph{4.2}
For single-equation ARDL models (Stages~S0 and~S1), admissibility requires the specification to pass the \citet{Pesaran2001} bounds test: the Wald $F$-statistic must exceed the upper critical bound at the 5\% level. For multi-equation models (Stage~S2), admissibility requires three conditions: convergence of the maximum likelihood estimation, rejection of the zero-rank null hypothesis in the Johansen trace test at the 5\% level ($r=1$), and dynamic stability of the companion matrix (all eigenvalues strictly within the unit circle). Specifications failing any of these conditions are excluded from model comparison.
```

### Target: Paragraphs 4.45–4.47 (Lines 620–660) — Sample Window Sensitivity
Replace lines 620–660 in [section4.tex](file:///c:/ReposGitHub/Critical-Replication-Shaikh/chapter1_edit/02_Versions/WP_CriticalReplication_3.0/section4.tex) with the following disciplined text:

```latex
\paragraph{4.45}
A key result of our system-level estimation is that the bivariate VECM yields zero admissible specifications over the full post-war period (1947--2011, $T=65$). Across the 48 bivariate specifications estimated over alternative lag lengths and deterministic trends, the Johansen trace test fails to reject the null hypothesis of no cointegration ($r=0$) at the 5\% level.

\paragraph{4.46}
Re-estimating the grid over Shaikh's pre-crisis sample period (1947--2007, $T=61$) shows that this bivariate failure reflects sample sensitivity. Over the pre-2008 sample, the bivariate system yields 12 admissible specifications, producing an estimated elasticity of $\hat{\theta} \in [0.88, 0.91]$. Adding the four years of the Great Recession (2008--2011) disrupts this relation: the sharp fall in value added relative to a slow-depreciating capital stock introduces persistent drift into the residuals, causing bivariate cointegration to break down. We report both sample outcomes to clarify this sensitivity: single-equation models that report cointegration over the full sample without testing system rank miss this post-2007 divergence.

\paragraph{4.47}
In contrast to the bivariate models, the trivariate system including the logged exploitation rate ($\ln e_t$) identifies cointegration over the full 1947--2011 period, producing six admissible specifications at rank $r=1$. All six surviving specifications include step dummies for 1956, 1974, and 1980 ($h_2$). Estimating the specification without dummies ($h_0$) yields zero admissible models across all lag orders. This shows that identifying a cointegrating relationship requires controlling for major institutional shocks: the post-Korean War downturn, the 1974 oil and profitability crisis, and the 1980 Volcker monetary tightening.
```

---

## 4. Verification Checklist for Pass 4

Before completing Pass 4:
* [ ] **Count Check:** Confirm that 0/48 bivariate models pass in $T=65$, 12/48 in $T=61$, and 6/96 trivariate models pass in $T=65$, matching `output/S2_vecm/S2_BUNDLE_INTERPRETATION.md`.
* [ ] **Counterfactual Terms:** Ensure the $\theta = 1$ restriction and no-dummy models are described as illustrative examples.
* [ ] **Lexical Check:** Verify that terms flagged in Items L18–L20 (`What is at stake`, `immutable physical constant`, `Remarkably`) do not appear.
* [ ] **Compilation Test:** Run `pdflatex -interaction=nonstopmode main.tex` to confirm clean compilation.
