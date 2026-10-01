# FE04: Pass 2 — Figure 5 Audit & FRB Series Alignment

**Pass Number:** 2 of 5  
**Target Manuscript:** `chapter1_edit/02_Versions/WP_CriticalReplication_3.0/section4.tex` (Paragraphs 4.14–4.16, Lines 345–365)  
**Associated Script & Figure:** `codes/20_S0_override_v8_FigureFAN.R` / `figures/fig_S0_cu_fan_diagnostic.png`  
**Advisor Reference:** [FE01_Meeting_Summary.md](file:///c:/ReposGitHub/Critical-Replication-Shaikh/chapter1_edit/12_FinalEdits/FE01_Meeting_Summary.md#L32-L37), handwritten feedback Items 51 & 52 ([Feedback_Matrix.md](file:///c:/ReposGitHub/Critical-Replication-Shaikh/chapter1_edit/_failed_edit_archive/Feedback_Matrix/Feedback_Matrix.md))  
**Lexical Audit Status:** Disciplined via [FE08_Controlled_Pass_Steering_Loop.md](file:///c:/ReposGitHub/Critical-Replication-Shaikh/chapter1_edit/12_FinalEdits/FE08_Controlled_Pass_Steering_Loop.md) (Items L09–L12)

---

## 1. Advisor Critique & Editorial Goal

In the supervisory meeting, Michael Ash emphasized:
1. **Visual Divergence in Figure 5:** The Federal Reserve Board (FRB) manufacturing utilization series (plotted alongside Shaikh's published series and our reconstructed models) showed substantial divergence, especially after 1973.
2. **Axis Scaling and Normalization:** The FRB series is reported as a percentage fluctuating around 80%, while Shaikh’s index is an index number centered around 1.0. Displaying these on separate or uncalibrated scales creates visual confusion.
3. **Explaining the Differences:** The text must explain *why* these series diverge: the FRB series measures operating rates within existing plant capacity, whereas Shaikh's series reflects the long-run relation between aggregate output and gross capital stock.

---

## 2. Comparison of Methods

```
┌────────────────────────────────────────────────────────────────────────────────────────┐
│                        Comparison of Capacity Utilization Series                       │
├─────────────────────┬──────────────────────────────┬───────────────────────────────────┤
│ Dimension           │ Shaikh Cointegrated Index    │ Federal Reserve Board (FRB) Index │
├─────────────────────┼──────────────────────────────┼───────────────────────────────────┤
│ Theoretical Focus   │ Classical-Marxian surplus    │ Short-run cyclical inflation      │
│                     │ approach                     │ pressure                          │
├─────────────────────┼──────────────────────────────┼───────────────────────────────────┤
│ Data Construction   │ Cointegrating output-capital │ Plant operating rate surveys      │
│                     │ residual                     │ (Census / McGraw-Hill)            │
├─────────────────────┼──────────────────────────────┼───────────────────────────────────┤
│ Secular Trend       │ Allows long-run trend drift  │ Mean-reverting by design (~80%)   │
├─────────────────────┼──────────────────────────────┼───────────────────────────────────┤
│ Post-1973 Trajectory│ Downward drift due to lower  │ Returns to historical average     │
│                     │ output-capital ratio         │ after cyclical contractions       │
└─────────────────────┴──────────────────────────────┴───────────────────────────────────┘
```

### Normalization Method
In `codes/20_S0_override_v8_FigureFAN.R`:
* Both series are mean-normalized to 1.0 over 1947–2011:
  $$u^{\text{norm}}_{t} = \frac{u_t}{\bar{u}}$$
* This centers the FRB series around 1.0 (varying between 0.85 and 1.10), matching the scale of Shaikh’s cointegrated index and avoiding dual-axis distortions.

---

## 3. Disciplined LaTeX Replacement Block in `section4.tex`

### Target: Paragraphs 4.14–4.16 (Lines 345–365)
Replace lines 345–365 in [section4.tex](file:///c:/ReposGitHub/Critical-Replication-Shaikh/chapter1_edit/02_Versions/WP_CriticalReplication_3.0/section4.tex) with the following disciplined text:

```latex
\paragraph{4.14}
Figure~\ref{fig:s0-cu-fan-diagnostic} plots the reconstructed single-equation capacity utilization paths alongside Shaikh's published series and the Federal Reserve Board (FRB) manufacturing utilization benchmark. To allow direct comparison, each series is mean-normalized to unity over the 1947--2011 sample period. The comparison illustrates two patterns: the sensitivity of single-equation capacity paths to lag specification, and the divergence between survey-based and cointegration-based measures.

\paragraph{4.15}
The difference between the reconstructed ARDL(2,4) benchmark ($\hat{\theta}=0.72$) and the AIC-selected ARDL(4,3) specification ($\hat{\theta}=0.75$) shows that utilization estimates depend on lag length. A change of $0.03$ in the estimated transformation elasticity shifts the constructed capacity utilization path by up to $5$ percentage points across the cycle. Because the elasticity parameter determines the denominator of the utilization index ($Y_t / \hat{Y}^p_t$), small differences in specification alter the historical level of the index, showing that single-equation point estimates depend heavily on lag choices.

\paragraph{4.16}
The divergence between Shaikh's cointegrated index and the Federal Reserve Board series is also evident after 1973. While both series capture cyclical downturns (1958, 1974, 1982, and 2008), their secular trends differ. The FRB series is constructed from survey operating rates relative to existing plant capacity, which makes it mean-reverting around an 80\% operating rate. In contrast, Shaikh's measure reflects the output--capital relation across successive investment cycles. Because capital accumulation outpaced capacity expansion ($\hat{\theta} < 1$), the output--capital ratio fell after 1973, producing the persistent downward shift observed in Shaikh's utilization series.
```

---

## 4. Script Adjustments in `codes/20_S0_override_v8_FigureFAN.R`

Verify that lines 168–182 of [codes/20_S0_override_v8_FigureFAN.R](file:///c:/ReposGitHub/Critical-Replication-Shaikh/codes/20_S0_override_v8_FigureFAN.R) apply the mean normalization:

```r
# Mean-normalize FRB to match index baseline of 1.0
df_plot$uFRB_norm <- df_plot$uFRB / mean(df_plot$uFRB, na.rm = TRUE)
```

Ensure the legend labels read:
* `Shaikh Published uK`
* `Federal Reserve Board (Normalized)`
* `Reconstructed ARDL(2,4)`
* `AIC Selected ARDL(4,3)`

---

## 5. Verification Checklist for Pass 2

Before completing Pass 2:
* [ ] **Scale Inspection:** Verify that `figures/fig_S0_cu_fan_diagnostic.png` has its y-axis labeled `Capacity Utilization Index (Mean = 1.0)`.
* [ ] **Legend Clarity:** Confirm that the Federal Reserve line is clearly distinguished from Shaikh's line in the legend.
* [ ] **Lexical Check:** Ensure terms flagged in Items L10–L12 (`fundamental patterns`, `extreme sensitivity`, `profound institutional divergence`, `mechanically erase`) are absent from the text.
* [ ] **Compilation Test:** Run `pdflatex -interaction=nonstopmode main.tex` to confirm clean formatting.
