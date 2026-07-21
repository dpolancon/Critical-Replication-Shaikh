# Section 4 Paragraph-by-Paragraph Micro-Outline Design Document

This document serves as a pass-through design artifact mapping the structural reorganization and narrative edits for Section 4 of Chapter 1 (`section4.tex`). It ensures that every paragraph is sequentially numbered, has a distinct narrative function, resolves the "Russian doll" repetition, and strictly enforces the **UMass Amherst Applied Econometrics & Political Economy Writing Guidelines** (BLUF, active voice, immediate variable definition, data-first visualization, specification-space mapping, and institutional grounding).

---

## 4.1 Econometric Framework and Staged Design (The Unified Foundation)
*   **Subsection Theme & Rhetorical Goal:** Define the mathematical and conceptual econometric architecture upfront. Define the ARDL UECM and Johansen VECM models once. Introduce the 3-stage roadmap (S0, S1, S2) conceptually so the reader understands our path before seeing results.
*   **UMass DNA/IZA Focus:** Immediate variable definitions, active voice, clear mathematical notation. No results or diagnostic filtering details belong here.

| New ID | Source ID | Concept / Function | Narrative Logic & Transition | UMass/IZA Calibration Action |
| :--- | :--- | :--- | :--- | :--- |
| **4.1** | Old 4.1 | Section introduction | Sets the empirical scope and states the main thesis (reproducing the capacity path). | **BLUF:** First sentence must state the empirical objective. Active voice. |
| **4.2** | Old 4.2 | Leontief capacity function | Formulates $Y_t = \mu_t R^n_t K_t$ under a capital-constrained regime. | Establishes the physical relationship before applying logarithms. | Define all variables ($Y_t, \mu_t, R^n_t, K_t$) immediately in this paragraph. |
| **4.3** | Old 4.3 | Level regression equation | Formulates the log-linear relation $\ln Y_t = \theta \ln K_t + \dots$. | Explains how we translate the physical production function into an empirical model. | Define the structural transformation elasticity $\theta$ and its meaning. |
| **4.4** | Old 4.4 | Subsection roadmap | Outlines the 7 new subsections to provide a clear reading path. | Prepares the reader for the transition from tools to data and results. | Replace old labels with new unique subsection labels (`_new`, `_design`). |
| **4.5** | Old 4.50 | Heinz Kurz theoretical framework | Discusses the choice-of-technique and why $\theta$ cannot be assumed to be constant. | Connects the econometric setup to classical distribution and class struggle. | **UMass DNA:** Frame distribution as an endogenous driver of the capital-capacity relation. |
| **4.6** | Old 4.5 | Single-equation ARDL introduction | Explains why ARDL is the starting point (handles nonstationary $I(1)$ series). | Moves from the general level relation to the specific single-equation tool. | Active voice: "We estimate..." instead of passive "estimation was performed." |
| **4.7** | Old 4.6 | ARDL(p, q) specification | Writes out the lag distribution model mathematically. | Establishes the lag structure that accounts for short-run frictions. | Define lag orders $p$ and $q$ immediately. Keep math notation simple. |
| **4.8** | Old 4.7 | Unrestricted ECM (UECM) | Re-expresses ARDL in differences and levels. | Shows how UECM isolates long-run adjustment from short-run noise. | **Dual-Layer:** Translate the error correction term $\phi_1$ as a physical restoring force. |
| **4.9** | Old 4.8 | Wald $F$-bounds test | Defines the null hypothesis of no level relationship. | Outlines the first statistical screen for cointegration. | Plain-English translation of the null $H_0: \phi_1 = \phi_2 = 0$ as spurious regression. |
| **4.10** | Old 4.9 | Joint exclusion restrictions | Formulates the Wald restrictions mathematically. | Provides the formal hypothesis tested by the bounds test. | Keep math clean. Avoid complex subscripts. |
| **4.11** | Old 4.10 | PSS critical value bounds | Explains why standard $F$ distributions fail under nonstationarity. | Justifies the need for the Pesaran, Shin, and Smith (PSS) asymptotic bounds. | Simplify explanation of PSS Case bounds. Use active voice. |
| **4.12** | Old 4.11 | $t$-bounds diagnostic | Defines the $t$-test on the error correction coefficient. | Outlines the secondary test to prevent degenerate cointegration. | Explain the economic necessity of verifying the speed-of-adjustment term. |
| **4.13** | Old 4.12 | One-sided alternative | Formulates $H_1: \phi_1 < 0$. | Show how a negative sign represents a stable restoring adjustment. | Plain-English translation of why a positive coefficient implies explosive divergence. |
| **4.14** | Old 4.13 | Recovery of elasticity $\hat{\theta}$ | Mathematical formula $\hat{\theta} = -\phi_2 / \phi_1$. | Explains how we recover the long-run parameter from the short-run regression. | Define the long-run elasticity coefficient clearly in-text. |
| **4.15** | Old 4.14 | Constructing utilization $\hat{\mu}_t$ | Shows how $\hat{\theta}$ and NIPA series construct the utilization index. | Bridges the econometric parameter to the historical capacity series. | Explain how utilization represents the realization of potential output. |
| **4.16** | Old 4.15 | Capacity path normalization | Explains how the series is anchored to historical peaks. | Details the final step in generating the utilization series. | Keep it brief. Eliminate robotic transition words. |
| **4.17** | Old 4.27 | Stage S0 conceptual design | Defines Stage S0 as the baseline reproduction. | Begins the description of our staged replication strategy. | Explain why reproducing Shaikh's baseline is our starting point. |
| **4.18** | Old 4.28 | Stage S0 parameters | Details the lag structure (4,3) and PSS Case I used by Shaikh. | Outlines the exact parameters of the baseline test. | **Forensic Transparency:** Be explicit about lag choices. |
| **4.19** | Old 4.29 | Stage S1 conceptual design | Defines Stage S1 as the multi-model specification grid. | Explains why we must test model stability across alternative choices. | **Specification Mapping:** Frame S1 as mapping the researcher's specification space. |
| **4.20** | Old 4.30 | S1 grid parameters | Details the lag lengths, trends, and dummy combinations. | Explains the combinatorics of the 500-model search. | Cut mathematical clutter. Keep the explanation intuitive. |
| **4.21** | Old 4.31 | S1 specification space $\mathcal{G}_{S1}$ | Mathematical formulation of the grid space. | Formalizes the combinatorial options. | Define the parameters $(p, q, c, s)$ in plain English. |
| **4.22** | Old 4.37 | S1 admissibility subset $\mathcal{A}_{S1}$ | Defines the $F$-bounds admissibility constraint. | Explains how we screen out spurious models. | Plain-English explanation of why we discard nonstationary models. |
| **4.23** | Old 4.38 | S1 information criteria | Introduces AIC, BIC, and RICOMP. | Outlines the criteria used to evaluate fit vs. complexity. | Define the deviance $L(m)$ and parameter penalty terms. |
| **4.24** | Old 4.39 | S1 IC neighborhoods | Formulates the subset of top-performing models. | Explains how we narrow down the 500 models. | Explain the fit-complexity trade-off in simple terms. |
| **4.25** | Old 4.40 | S1 Pareto frontier | Formulates the non-dominated fit-complexity envelope. | Formally defines the boundary of optimal specifications. | Plain-English definition of the Pareto envelope. |
| **4.26** | Old 4.41 | Parameter dispersion $\hat{\theta}(m)$ | Explains how parameter dispersion across models indicates risk. | Connects model selection to parameter uncertainty. | Define the parameter sensitivity concept clearly. |
| **4.27** | Old 4.42 | Utilization path dispersion $\hat{\mu}_t(m)$ | Explains how path dispersion impacts historical interpretations. | Shows the real-world stakes of specification sensitivity. | Injected UMass style: explain the practical stakes of path variance. |
| **4.28** | Old 4.43 | S1 design summary table | References the layout table. | Concludes the single-equation design portion. | Keep transition to VECM clean. |
| **4.29** | Old 4.44 | Stage S2 system VECM design | Establishes why we must test system-level feedback (endogeneity). | Introduces the system-level machinery. | **UMass DNA:** Explain why endogeneity requires a system approach (VECM). |
| **4.30** | Old 4.45 | Bivariate Johansen VECM | Formulates the multi-equation system for output and capital. | Establishes the mathematical system representation. | Define variables $X_t$ and parameters. Active voice. |
| **4.31** | Old 4.46 | Cointegration rank restriction | Formulates the impact matrix $\Pi = \alpha \beta'$. | Explains the long-run relation and adjustment feedback. | Define speed-of-adjustment $\alpha$ and cointegrating vector $\beta$. |
| **4.32** | Old 4.47 | S2 combinatoric VECM grid | Details the VAR lags and deterministic cases. | Outlines the system-level specification search. | Map the system specification space. |
| **4.33** | Old 4.48 | S2 specification space formulation | Mathematical formulation of the VECM grid. | Formalizes the system options. | Plain-English translation of VECM deterministic restrictions. |

---

## 4.2 Data, Measurement, and Stylized Facts (The Raw Material)
*   **Subsection Theme & Rhetorical Goal:** Ground the econometrics in physical and historical reality. Introduce the data sources, GPIM capital stock recursion, and key measurement conventions.
*   **UMass DNA/IZA Focus:** **Descriptive Macro Grounding (Rule E)** and **Data-First Visualization (Rule B)**. Present stylized facts and raw historical trends (growth rates, log levels plots) *before* parametric regressions are evaluated.

| New ID | Source ID | Concept / Function | Narrative Logic & Transition | UMass/IZA Calibration Action |
| :--- | :--- | :--- | :--- | :--- |
| **4.34** | Old 4.16 | Data sources & sample | Details the BEA NIPA tables and period (1947-2011). | Introduces the dataset used for the replication. | **Forensic Transparency:** Justify the sample window. |
| **4.35** | Old 4.17 | Gross vs net capital stock | Justifies why we replicate Shaikh's gross capital stock choice. | Outlines the measurement choices for the capital variable. | Define KGCcorp and KNCcorp clearly. |
| **4.36** | Old 4.18 | GPIM accumulation formula | Formulates the Perpetual Inventory Method recursion. | Details the physical construction of the capital stock series. | Define gross investment ($IG_t$) and depreciation rate ($z_t$). |
| **4.37** | Old 4.19 | Price deflator `pKN` | Discusses deflation of GVA and capital by the implicit price index. | Details the price adjustments needed for real variables. | Explain why `pKN` is GPIM-consistent. |
| **4.38** | Old 4.20 | Financial services correction | Details the correction for imputed financial intermediation (FISIM). | Resolves national account distortions in corporate GVA. | Explain the institutional meaning of the FISIM correction. |
| **4.39** | Old 4.21 | Measurement implications | Explains why measurement conventions are part of the strategy. | Concludes the measurement discussion. | Active voice. Remove robotic transitions. |
| **4.40** | Old 4.22 | **Stylized Facts & Growth Rates** | **Descriptive Grounding:** Present raw post-war growth rates (GVA 3.0%, K 4.1%, L 1.3%). | Establishes the physical divergence of output and capital. | **Promoted Edit:** Clear the %TODO. Integrate verified growth rates. |
| **4.41** | Old 4.23 | **Log levels plot (Figure 4.1)** | **Data-First Visualization:** Visualizes $y_t$ and $k_t$ log levels. | Let the raw historical trends speak for themselves before regressions. | Refer to Figure 4.1. Keep text descriptive. |

---

## 4.3 The Admissibility Strategy (The Rules of the Game)
*   **Subsection Theme & Rhetorical Goal:** Outline the triple-layered admissibility gate (F-bounds, t-bounds, VECM system triple gate). Explain the diagnostic screens that filter out invalid specifications.
*   **UMass DNA/IZA Focus:** **Specification-Space Mapping (Rule D)**. Make explicit that residual nonstationarity implies a spurious regression ("statistical hallucination").

| New ID | Source ID | Concept / Function | Narrative Logic & Transition | UMass/IZA Calibration Action |
| :--- | :--- | :--- | :--- | :--- |
| **4.42** | Old 4.24 | Admissibility conceptual definition | Defines admissibility as the gatekeeper against spurious regressions. | Establishes the "rules of the game" before reporting results. | **Promoted Edit:** Implement the "Triple-Layer Explanation." |
| **4.43** | Old 4.25 | Math of cointegration safeguard | Explains how stationary residuals guarantee an ECM restoring force. | Outlines the statistical stakes of admissibility. | **Promoted Edit:** Clear explanation of $I(1)$ vs. $I(0)$ residuals. |
| **4.44** | Old 4.26 | Staged screening roadmap | Introduces the sequential screening (S0, S1, S2). | Connects the admissibility gates to our 3 stages. | Active voice. Keep it brief. |
| **4.45** | Old 4.32 | $F$-bounds diagnostic screen | Defines the primary screen for level relationships. | Establishes the mathematical $F$-bounds gate. | Define the $F$-bounds test criteria clearly. |
| **4.46** | Old 4.33 | $F$-bounds test p-value | Formulates $p_F(m) \le 0.10$. | Specifies the critical threshold for the first screen. | Plain-English translation of why we reject $p_F > 0.10$. |
| **4.47** | Old 4.34 | $t$-bounds diagnostic screen | Defines the secondary screen for dynamic error correction. | Establishes the mathematical $t$-bounds gate. | Define the $t$-bounds test criteria clearly. |
| **4.48** | Old 4.35 | $t$-bounds test p-value | Formulates $p_t(m) \le 0.10$. | Specifies the critical threshold for the second screen. | Plain-English translation of why we reject $p_t > 0.10$. |
| **4.49** | Old 4.36 | Joint single-equation condition | Formulates the combined $F$- and $t$-bounds gate. | Formalizes the total single-equation admissibility condition. | Keep math clean. Avoid complex subscripts. |
| **4.50** | Old 4.49 | VECM system admissibility gate | Defines the system gate (reduced rank, eigenvalues). | Establishes the rules for system-level VECM tests. | Plain-English translation of the companion matrix eigenvalues gate. |

---

## 4.4 Stage 0 (S0) Results (Baseline Reconstruction)
*   **Subsection Theme & Rhetorical Goal:** Detail the baseline single-equation reconstruction findings, highlighting the sensitivity and fragility of the point estimate (reproducing the divergence from Shaikh's 0.66 to our 0.72/0.75).
*   **UMass DNA/IZA Focus:** **Forensic Transparency (Rule A)**.

| New ID | Source ID | Concept / Function | Narrative Logic & Transition | UMass/IZA Calibration Action |
| :--- | :--- | :--- | :--- | :--- |
| **4.51** | Old 4.51 | S0 baseline replication results | Reports the replication of Shaikh's ARDL(4,3) model. | Starts the presentation of empirical results. | **BLUF:** First sentence must state the S0 outcome. |
| **4.52** | Old 4.52 | Reconciling the divergence | Unpacks why our reconstructed elasticity is 0.72 instead of 0.66. | Forensic transparency: explain the database differences. | Discuss NIPA revisions and data coverage differences. |
| **4.53** | Old 4.53 | F-bounds test statistics | Reports the computed $F$-bounds statistic for Shaikh's model. | Confirms cointegration for the baseline case. | Report statistics. Define critical value boundaries. |
| **4.54** | Old 4.54 | t-bounds test statistics | Reports the computed $t$-bounds statistic for the baseline. | Verifies the presence of a restoring adjustment. | Report statistics. Define critical value boundaries. |
| **4.55** | Old 4.55 | Error-correction speed | Reports the speed-of-adjustment coefficient ($-0.117$). | Unpacks the dynamic properties of the baseline model. | Explain the economic meaning of the adjustment rate. |
| **4.56** | Old 4.56 | Sensitivity analysis | Shows how a shift from 0.72 to 0.75 alters the capacity path. | Illustrates the physical stakes of parameter sensitivity. | Explain how elasticity alters the utilization index. |
| **4.57** | Old 4.57 | Utilization path fan plot | Visualizes the S0 utilization paths (Figure 4.2). | visually demonstrates the S0 findings. | Refer to Figure 4.2. Keep text descriptive. |
| **4.58** | Old 4.58 | S0 summary | Concludes Stage S0. | Prepares the reader for the multi-model grid search. | Active voice. Remove robotic transitions. |

---

## 4.5 Stage 1 (S1) Results (Admissible-Specification Stress Test)
*   **Subsection Theme & Rhetorical Goal:** Report the combinatorial grid search outcomes, fit-complexity Pareto envelopes, and information-criterion neighborhoods.
*   **UMass DNA/IZA Focus:** **Specification-Space Mapping (Rule D)**. Report the divergence of criteria (AIC/BIC vs. RICOMP) and explicitly state what alternatives fared badly.

| New ID | Source ID | Concept / Function | Narrative Logic & Transition | UMass/IZA Calibration Action |
| :--- | :--- | :--- | :--- | :--- |
| **4.59** | Old 4.59 | S1 introduction | Introduces the 500-model ARDL specification grid results. | Starts the presentation of S1 findings. | **BLUF:** State the main outcome of the grid search first. |
| **4.60** | Old 4.60 | Grid results & counts | Reports how many models pass the admissibility screens (102/500). | Visualizes the shrinking of the specification space. | Frame the count as mapping the specification space. |
| **4.61** | Old 4.61 | Selecting focal models | Unpacks two focal models: AIC/BIC winner vs. RICOMP winner. | Compares optimal models to show parameter dispersion. | Contrast the AIC/BIC winner (0.92) with RICOMP (0.65). |
| **4.62** | Old 4.62 | Shrinking space plot (Figure 4.3) | Reports the screening hierarchy visually. | visualizes the admissibility screens. | Refer to Figure 4.3. Keep text descriptive. |
| **4.63** | Old 4.63 | Pareto frontier analysis | Analyzes the global non-dominated fit-complexity envelope. | Explains the boundary of optimal specifications. | Define the Pareto envelope. Keep explanation intuitive. |
| **4.64** | Old 4.64 | Role of historical dummy controls | Shows what alternatives fared badly (models without dummies fail). | Illustrates the necessity of accounting for structural breaks. | **Radical Transparency:** Explain why models without dummies fail. |
| **4.65** | Old 4.65 | IC neighborhoods analysis | Details the criterion-specific neighborhoods. | Explains the model selection outcomes. | Explain how criteria weight complexity differently. |
| **4.66** | Old 4.66 | Fit-complexity plot (Figure 4.4) | Visualizes the IC-neighborhoods and frontier. | visualizes the model selection results. | Refer to Figure 4.4. Keep text descriptive. |
| **4.67** | Old 4.67 | AIC/BIC winner model parameters | Reports the lag structure and elasticity of the winner. | Unpacks the properties of the best-fit model. | Report statistics. Define critical value boundaries. |
| **4.68** | Old 4.68 | Neighborhoods path fan plot | Visualizes the capacity utilization paths (Figure 4.5). | visually demonstrates the S1 parameter fragility. | Refer to Figure 4.5. Keep text descriptive. |
| **4.69** | Old 4.69 | Statistical significance | Shows how parameter dispersion impacts the capacity benchmark. | Concludes the single-equation results. | Highlight the stakes of parameter sensitivity. |
| **4.70** | Old 4.70 | Transition to Stage S2 | Explains the single-equation fragility and transitions to VECM. | Bridges S1 results to S2 system results. | **Promoted Edit:** Clean up the transition to S2. |

---

## 4.6 Stage 2 (S2) Results (System-Level VECM Replication)
*   **Subsection Theme & Rhetorical Goal:** Report the system-level VECM outcomes. Detail the failure of the bivariate system and the success of the trivariate system when the exploitation rate ($e_t$) is introduced.
*   **UMass DNA/IZA Focus:** **Endogenous Class Struggle & Distribution (Rule C)** and **Institutional Deconstruction of Indicators (Rule F)**. Ground the cointegrating vector in workplace labor discipline, choice of technique, and shift speedups.

| New ID | Source ID | Concept / Function | Narrative Logic & Transition | UMass/IZA Calibration Action |
| :--- | :--- | :--- | :--- | :--- |
| **4.71** | Old 4.71 | S2 bivariate VECM results | Reports the failure of the bivariate system. | Starts the presentation of S2 system findings. | **BLUF:** State the bivariate VECM failure first. |
| **4.72** | Old 4.72 | Trivariate system introduction | Introduces the trivariate system with the exploitation rate $e_t$. | Establishes the distribution variable as the stabilizer. | Define variables $X_t = (\ln Y_t, \ln K_t, \ln e_t)'$ immediately. |
| **4.73** | New Workplace | **Workplace Mechanism** | **UMass DNA:** Explains how class struggle alters capital conversion. | Bridges econometric VECM stability to shop-floor reality. | **Promoted Edit:** Ground the exploitation rate in labor discipline. |
| **4.74** | Old 4.73 | Johansen trace test results | Reports the trace test statistics and cointegration rank. | Confirms cointegration in the trivariate system (Table 4.5). | Report statistics. Define critical value boundaries. |
| **4.75** | Old 4.74 | Selecting the focal VAR(2) | Unpacks the focal trivariate model parameters. | Details the best-performing system specification. | Justify the VAR(2) specification choice. |
| **4.76** | Old 4.75 | Cointegrating vector normalized | Reports the long-run relation normalized on output. | Shows the estimated elasticity and exploitation coefficients. | Report statistics. Define critical value boundaries. |
| **4.77** | Old 4.76 | Speed-of-adjustment loading | Reports the feedback loading coefficients $\alpha$. | Unpacks the dynamic adjustment properties of the system. | Explain the economic meaning of the loading rates. |
| **4.78** | Old 4.77 | Role of the $h_2$ dummy | Details the impact of historical shock controls in VECM. | Illustrates the necessity of accounting for structural breaks. | Explain the role of historical controls. |
| **4.79** | Old 4.78 | Counterfactual VECM results | Shows what alternatives fared badly (VECM without dummies). | Illustrates the fragility of models without historical controls. | **Radical Transparency:** Explain why models without dummies fail. |
| **4.80** | Old 4.79 | Pooled system fit plot (Figure 4.6) | Visualizes system fit vs. parsimony. | visualizes the system specification space. | Refer to Figure 4.6. Keep text descriptive. |
| **4.81** | Old 4.80 | Dual path plot (Figure 4.7) | Visualizes utilization and exploitation paths. | visually demonstrates the S2 system results. | Refer to Figure 4.7. Keep text descriptive. |
| **4.82** | Old 4.81 | Theoretical resolution | Connects the trivariate VECM results to Sraffa-Kurz theory. | Concludes the Stage S2 results presentation. | Active voice. Remove robotic transitions. |

---

## 4.7 Cross-Stage Econometric Synthesis (Methodological Boundaries)
*   **Subsection Theme & Rhetorical Goal:** Integrate findings across stages into a cohesive critique. Show that parameter estimates must be historically and distributionally conditioned.
*   **UMass DNA/IZA Focus:** Measured, authoritative academic prose that summarizes the empirical boundaries.

| New ID | Source ID | Concept / Function | Narrative Logic & Transition | UMass/IZA Calibration Action |
| :--- | :--- | :--- | :--- | :--- |
| **4.83** | Old 4.82 | Cross-stage synthesis questions | Outlines the three questions answered by our staged replication. | Starts the cross-stage synthesis. | **BLUF:** First sentence must state the synthesis objective. |
| **4.84** | Old 4.83 | Elasticity magnitude impact | Discusses how the estimated $\theta$ alters the capacity utilization path. | Illustrates the real-world stakes of the parameter range. | Explain how elasticity alters the utilization index. |
| **4.85** | Old 4.84 | VECM system resolution | Explains how system estimation resolves single-equation ambiguity. | Shows why the trivariate system is the most robust model. | Frame distribution as the key to identifying capacity. |
| **4.86** | Old 4.85 | Dual macroeconomic roles | Connects distribution to aggregate demand and capacity formation. | Concludes Section 4 with a theoretical synthesis. | Active voice. Strong final sentence grounding the econometrics. |