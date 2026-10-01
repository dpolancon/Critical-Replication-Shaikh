# FE03: Pass 1 — Overaccumulation & Latent Capacity Theory

**Pass Number:** 1 of 5  
**Target Manuscript:** `chapter1_edit/02_Versions/WP_CriticalReplication_3.0/section3.tex` (Paragraphs 3.17–3.20, Lines 101–120)  
**Associated Appendix:** `chapter1_edit/02_Versions/WP_CriticalReplication_3.0/AppendixODE/AppendixODE.tex`  
**Advisor Reference:** [FE01_Meeting_Summary.md](file:///c:/ReposGitHub/Critical-Replication-Shaikh/chapter1_edit/12_FinalEdits/FE01_Meeting_Summary.md#L45-L55), handwritten feedback Items 35, 37, 38 ([Feedback_Matrix.md](file:///c:/ReposGitHub/Critical-Replication-Shaikh/chapter1_edit/_failed_edit_archive/Feedback_Matrix/Feedback_Matrix.md))  
**Lexical Audit Status:** Disciplined via [FE08_Controlled_Pass_Steering_Loop.md](file:///c:/ReposGitHub/Critical-Replication-Shaikh/chapter1_edit/12_FinalEdits/FE08_Controlled_Pass_Steering_Loop.md) (Items L04–L08)

---

## 1. Advisor Critique & Editorial Goal

In the supervisory meeting, Michael Ash noted that the mathematical description of overaccumulation ($\theta < 1$) and the capital acceleration equation ($d\hat{k}/dt$) needed clearer economic motivation:
1. **Explain the Economic Mechanism:** Why do capitalists invest in 10% more capital when that investment yields only an 8% increase in productive capacity? Why do market signals not stop this process?
2. **Clarify the Acceleration Term:** Define $d\hat{k}/dt$ plainly as the rate of change of the net capital accumulation rate over time. Explain why institutional factors keep this rate within bounds over long periods.
3. **Single-Sector Model Scope:** Defend the regime classification in Table 1 while explicitly noting that a single-sector framework abstracts from Department I / Department II inter-sectoral flows.

---

## 2. Core Economic Mechanism

### A. The 10% vs. 8% Stylized Example
Assume gross capital stock grows at 10% ($g_K = 0.10$). If the transformation elasticity is $\theta = 0.8$, productive capacity grows at 8% ($g_{Y^p} = 0.08$):
* Over several production periods, capital accumulation outpaces capacity creation.
* The capacity-to-capital ratio ($Y^p / K$) declines by approximately 2% per period.
* This represents a supply-side imbalance: capital stock expands faster than the productive potential it generates, reducing normal capital productivity independently of short-run demand fluctuations.

### B. Why Market Signals Do Not Immediately Halt Investment
Capitalists continue to invest despite falling capital productivity because:
1. **Latent Capacity and Shift Work:** Productive capacity cannot be read directly from accounting books. Plant managers respond to demand variations by adjusting work shifts, machine operating speeds, and maintenance intervals. These operational adjustments mask the secular decline in capital productivity.
2. **Competitive Pressure:** Investment decisions are uncoordinated. An individual firm that cuts capital expenditure to protect its output–capital ratio loses market share and scale economies to competitors. Competition compels firms to invest even as aggregate profitability declines.
3. **Delayed Signals:** Current prices and capacity utilization ($\mu_t$) reflect current effective demand, which credit expansion can support for several years before excess capacity triggers an investment collapse.

### C. Institutional Bounding of the Acceleration Term ($d\hat{k}/dt$)
The dynamic path of net accumulation is given by:
$$\frac{d\hat{k}}{dt} = (\theta - 1)\,\hat{k}\,(\hat{k} + \delta)$$
* When $\theta = 0.8$, $(\theta - 1) = -0.2 < 0$, meaning the net accumulation rate decelerates toward stagnation.
* This deceleration does not continue indefinitely. Institutional responses eventually check the decline: bankruptcies and capital write-downs liquidate obsolete capacity, lower wages reduce unit costs, and state policy provides demand support.
* When $\theta > 1$, rapid accumulation is checked by labor shortages, rising real wages, and higher borrowing costs.

---

## 3. Disciplined LaTeX Replacement Block in `section3.tex`

### Target: Paragraphs 3.17–3.20 (Lines 101–120)
Replace lines 101–120 in [section3.tex](file:///c:/ReposGitHub/Critical-Replication-Shaikh/chapter1_edit/02_Versions/WP_CriticalReplication_3.0/section3.tex) with the following disciplined text:

```latex
\paragraph{3.17}
This regime classification uses a single-sector macroeconomic model. While this simplifies the analysis of stagnation tendencies driven by overaccumulation ($\theta < 1$), it abstracts from inter-sectoral flows. In Marx's reproduction schemas, disproportionality involves imbalances between Department~I (means of production) and Department~II (means of consumption). By setting aside inter-sectoral composition effects, our single-sector setup defines disproportionality as the divergence between capital accumulation and productive capacity creation when the transformation elasticity is non-unitary ($\theta \neq 1$). This provides an analytical baseline for our empirical replication while acknowledging that sectoral shifts are not modeled here.

\paragraph{3.18}
These regimes describe the dynamic tendencies of the accumulation process. When capital and capacity grow at different rates without autonomous technical change, the path of the net capital growth rate ($\hat{k} \equiv \dot{K}/K - \delta$) is described by an ordinary differential equation where the sign of $d\hat{k}/dt$ depends on $(\theta - 1)$ (the mathematical derivation and stability proofs are provided in Appendix~\ref{app:acc_dynamics}). Net accumulation decelerates under $\theta < 1$, accelerates under $\theta > 1$, and remains stationary under $\theta = 1$. This instability arises from the accounting relation between capital and capacity when $\theta \neq 1$, rather than from Harrodian demand fluctuations.

\paragraph{3.19}
The term $d\hat{k}/dt$ is a capital growth acceleration term, representing the rate of change of the net capital accumulation rate over time. Because the net accumulation rate cannot accelerate or decelerate indefinitely, institutional responses keep it within bounds over long periods. When accumulation accelerates ($\theta > 1$), rising wages, higher interest rates, and debt limits dampen further expansion. When accumulation decelerates ($\theta < 1$), the resulting stagnation triggers bankruptcies, capital devaluation, and wage reductions that eventually stabilize profitability, keeping the accumulation rate from falling without limit.

\paragraph{3.20}
To illustrate this dynamic, consider a stylized example where $\theta = 0.8$. Suppose the gross capital stock expands by $10\%$ ($g_K = 0.10$). With $\theta = 0.8$, the maximum productive capacity expands by only $8\%$ ($g_{Y^p} = 0.08$). Two factors explain why capitalists continue investing without immediate market corrections. First, productive capacity is a latent variable; managers adjust to short-run demand shifts through shift work, machine speedups, and deferred maintenance, which obscures the underlying decline in capital productivity. Second, competition compels firms to invest: an individual enterprise that curtails capital spending to protect capital productivity loses market share and scale economies to competitors. Firms therefore continue investing even as industry-wide profit margins decline. Assuming a baseline net accumulation rate of $\hat{k}_0 = 3\%$ ($0.03$) and depreciation of $\delta = 5\%$ ($0.05$), this capacity mismatch ($\theta - 1 = -0.2$) reduces normal capital productivity ($\hat{R}^n = -1.6\%$), causing net accumulation to decelerate at $d\hat{k}/dt = -0.048\%$ per year toward stagnation. Figure~\ref{fig:ode_phase_diagram} illustrates these phase dynamics alongside the explosive counterfactual ($\theta = 1.2$).
```

---

## 4. Verification Checklist for Pass 1

Before completing Pass 1:
* [ ] **Math Alignment:** Confirm that $\theta = 0.8$, $\hat{k}_0 = 0.03$, $\delta = 0.05$ yield $d\hat{k}/dt = (0.8 - 1)(0.03)(0.03 + 0.05) = -0.00048$ ($-0.048\%$ per year).
* [ ] **Cross-References:** Ensure Appendix cross-reference `\ref{app:acc_dynamics}` and Figure cross-reference `\ref{fig:ode_phase_diagram}` resolve without errors.
* [ ] **Lexical Check:** Verify that terms flagged in Item L04–L08 (`macroeconomic bounding`, `hard supply-side bottlenecks`, `rate-limiting factors`) do not appear in the replacement text.
* [ ] **Compilation Test:** Run `pdflatex -interaction=nonstopmode main.tex` to confirm clean compilation.
