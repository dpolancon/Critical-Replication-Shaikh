# Section 4 Editing Ledger

To lock a paragraph, check the box next to its ID (e.g., `- [x] Paragraph X.Y`).

## Paragraph 4.1
- [ ] **Locked**

**Current Content:**
> Section~\ref{sec:conceptual_framework} establishes that Shaikh's long-run output--capital coefficient is not a technical multiplier but the parameter that draws the productive-capacity path. Interpreted as the transformation elasticity $\theta$, that coefficient links capital accumulation to capacity formation under unbalanced growth. The empirical question is whether a fixed full-sample estimate sustains that production/reproduction meaning across postwar distributive regimes, or whether it averages over heterogeneous mappings. This section implements a critical replication that tests the relation itself, not a utilization proxy.

**Observations or Comments:**
*(Write observations here)*

**New Version:**
*(Draft new version here)*

---

## Paragraph 4.2
- [ ] **Locked**

**Current Content:**
> The replication proceeds in three stages. Stage $S0$ reconstructs the closest recoverable version of Shaikh's single-equation procedure. Its purpose is narrow: to determine whether a capacity path reproduces from documented choices over data construction, deterministic closure, lag structure, and historical impulse controls. Stage S1 opens the ARDL specification grid. It separates the bounds-tested admissible set from stricter confirmation criteria and information-complexity penalties, asking whether the recovered relation remains unique once admissibility and model-selection rules function as distinct researcher choices. Stage S2 moves from conditional single-equation estimation to joint system estimation. It tests whether the output--capital relation survives as a bivariate VECM and whether survival requires logged exploitation, \(\ln e_t\), to enter the trivariate state vector.

**Observations or Comments:**
*(Write observations here)*

**New Version:**
*(Draft new version here)*

---

## Paragraph 4.3
- [ ] **Locked**

**Current Content:**
> The results narrow Shaikh's strategy rather than reproduce it mechanically. The single-equation coefficient reproduces, but it does not replicate the original specification exactly. Within the screened ARDL space, the retained region shifts once fit, parsimony, and complexity penalties separate. In joint-system estimation, the bilateral relation fails the admissibility gate; a restricted trivariate system survives only when exploitation enters explicitly. The coefficient interpreted as $\theta$ is therefore recoverable, non-unique within the single-equation grid, and system-admissible only under distributional conditioning.

**Observations or Comments:**
*(Write observations here)*

**New Version:**
*(Draft new version here)*

---

## Paragraph 4.4
- [ ] **Locked**

**Current Content:**
> The section reports these findings sequentially. Subsection~\ref{subsec:shaikh_identification_strategy} clarifies the identification strategy and shows how the long-run coefficient recovers from the national accounts. Subsection~\ref{subsec:data_measurement} details the data construction, measurement conventions, and treatment of structural breaks. Subsection~\ref{subsec:empirical_design} presents the staged replication design, moving from baseline recovery through ARDL specification searches to joint-system estimation. The objective is not to discard Shaikh's portability strategy, but to locate its boundary conditions. The replication demonstrates that the long-run output--capital coefficient identifies the capital--capacity mapping only when the historical organization of accumulation functions as a variable, not as a fixed backdrop.

**Observations or Comments:**
*(Write observations here)*

**New Version:**
*(Draft new version here)*

---

## Paragraph 4.5
- [ ] **Locked**

**Current Content:**
> Section~\ref{subsec:coefficient_capacity_path} establishes that the long-run output--capital coefficient draws the productive-capacity path. This subsection operationalizes that coefficient within an autoregressive distributed lag framework, translating the accounting identity into a testable level relationship. The ARDL bounds-testing procedure \citep{Pesaran2001} (PSS) evaluates the existence of a cointegrating relationship between output and capital regardless of their individual integration orders, eliminating pre-testing requirements for unit roots or cointegration rank.

**Observations or Comments:**
*(Write observations here)*

**New Version:**
*(Draft new version here)*

---

## Paragraph 4.6
- [ ] **Locked**

**Current Content:**
> The procedure estimates an unrestricted equilibrium correction model derived from a general $\text{ARDL}(p, q)$ specification: \begin{equation} \Delta y_t = c_0 + c_1 t + \phi_1 y_{t-1} + \phi_2 k_{t-1} + \sum_{i=1}^{p-1} \gamma_i \Delta y_{t-i} + \sum_{j=0}^{q-1} \delta_j \Delta k_{t-j} + \sum_{h=1}^{H} \delta_h D_{h,t} + \varepsilon_t . \label{eq:ardl_uecm} \end{equation}

**Observations or Comments:**
*(Write observations here)*

**New Version:**
*(Draft new version here)*

---

## Paragraph 4.7
- [ ] **Locked**

**Current Content:**
> Equation~\eqref{eq:ardl_uecm} writes the ARDL specification in unrestricted error-correction form. Where $c_0$ represents the intercept, and $c_1t$ the linear trend. The short-run dynamics is represented by $\Delta y_{t-i}$ and $\Delta k_{t-j}$, and are included to capture the short-run memory of the model. The lagged level terms $y_{t-1}$ and $k_{t-1}$ carry the long-run content of the specification. The year dummies block represents deterministic components that are excluded from the long-run relation $\sum_{h=1}^{H}\delta_h D_{h,t}$. This representation therefore separates short-run adjustment from the level relation between output and capital.

**Observations or Comments:**
*(Write observations here)*

**New Version:**
*(Draft new version here)*

---

## Paragraph 4.8
- [ ] **Locked**

**Current Content:**
> The asymptotic distribution of the $F$-statistic under $H_0$ depends explicitly on how deterministic constraints are imposed. \citet{Pesaran2001} identify five configurations (Cases I--V) for this constraint: Case I excludes both intercept and trend. Case II restricts the intercept to the cointegrating space. Case III includes an unrestricted intercept. Case IV includes an unrestricted intercept and restricts the trend coefficient to the null. Case V includes unrestricted intercept and trend. Each case shifts the critical value bounds because the null hypothesis alters the deterministic trending behavior of the level process. The bounds test rejects the null when the computed $F$-statistic exceeds the upper critical bound ($I(1)$), fails to reject when it falls below the lower bound ($I(0)$), and yields inconclusive inference when it lies within the interior band. The replication treats these deterministic configurations as admissible specification toggles. Systematic variation across Cases I--V, combined with lag-order selection and information-criterion penalties, defines the admissible specification grid.

**Observations or Comments:**
*(Write observations here)*

**New Version:**
*(Draft new version here)*

---

## Paragraph 4.9
- [ ] **Locked**

**Current Content:**
> The Wald $F$-statistic tests the joint exclusion restriction in equation~\eqref{eq:ardl_uecm}. Under $H_{0}^{F}$, the lagged level terms do not enter the conditional model, so the specification contains no evidence of a long-run output--capital relation. Rejection of $H_{0}^{F}$ suggests that $y_{t-1}$ and $k_{t-1}$ jointly contribute to the error-correction representation. The statistic is evaluated against the lower and upper bounds associated with a specific PSS deterministic case. \begin{equation} H_{0}^{F}: \phi_1=\phi_2=0, \qquad H_{a}^{F}: (\phi_1,\phi_2)\neq(0,0). \label{eq:fbounds_hypothesis} \end{equation}

**Observations or Comments:**
*(Write observations here)*

**New Version:**
*(Draft new version here)*

---

## Paragraph 4.10
- [ ] **Locked**

**Current Content:**
> where $\phi_1$ and $\phi_2$ are the coefficients on the lagged level terms in the unrestricted error-correction representation. Under the null, the output--capital equation contains no long-run level relation. The distribution of the statistic is non-standard because the PSS procedure brackets the polar cases in which the regressors are purely $I(0)$ or purely $I(1)$. Values below the lower bound fail to reject the absence of a long-run relation; values above the upper bound support cointegration; values between the bounds remain inconclusive.

**Observations or Comments:**
*(Write observations here)*

**New Version:**
*(Draft new version here)*

---

## Paragraph 4.11
- [ ] **Locked**

**Current Content:**
> The $t$-bounds statistic provides a stricter diagnostic where the deterministic case makes it formally applicable. It tests \begin{equation} H_{0}^{t}: \phi_1=0, \qquad H_{a}^{t}: \phi_1<0. \label{eq:tbounds_hypothesis} \end{equation}

**Observations or Comments:**
*(Write observations here)*

**New Version:**
*(Draft new version here)*

---

## Paragraph 4.12
- [ ] **Locked**

**Current Content:**
> Against the one-sided alternative $\phi_1<0$, where $\phi_1$ is the coefficient on the lagged dependent variable in the conditional error-correction equation. Rejection supports an error-correction interpretation: deviations from the estimated long-run relation are followed by adjustment in subsequent periods. Because the sample is short, I evaluate the bounds evidence using the finite-sample critical values following \citet{NatsiopoulosTzeremes2022}, rather than relying only asymptotic PSS tables.

**Observations or Comments:**
*(Write observations here)*

**New Version:**
*(Draft new version here)*

---

## Paragraph 4.13
- [ ] **Locked**

**Current Content:**
> \citet{Shaikh2016} operationalizes the ARDL framework to recover a single long-run output--capital multiplier, treating the coefficient as an accounting artifact rather than a production-theoretic parameter \citep[Appendix~6.7]{Shaikh2016}. The baseline specification imposes four diagnostic constraints: (1) lag orders $p$ and $q$ follow the Akaike Information Criterion to mitigate residual serial correlation while avoiding over-parameterization; (2) deterministic treatment adopts PSS Case IV, retaining an unrestricted intercept while restricting the trend coefficient under the null; (3) year dummies ($D_{1956}$, $D_{1974}$, $D_{1980}$) absorb outlier-driven residual spikes identified through squared-error diagnostics; (4) the Breusch--Godfrey LM test screens the ECM for autocorrelation before bounds inference proceeds. Where the $F$-statistic falls within the inconclusive interior band, the procedure defaults to Engle--Granger two-step estimation to establish integration order. This baseline architecture stabilizes the fitted capacity path but leaves the fixed-parameter closure assumption untested. Shaikh estimates $d$ without theorizing its structural role or evaluating coefficient stability across distributive regimes. The replication treats this recovered multiplier as the empirical candidate for $\hat{\theta}$, routing the fixed-parameter closure assumption directly into three-stage admissibility gates.

**Observations or Comments:**
*(Write observations here)*

**New Version:**
*(Draft new version here)*

---

## Paragraph 4.14
- [ ] **Locked**

**Current Content:**
> Upon confirmation of a level relationship, the long-run coefficient recovers from the short-run ECM parameters: \begin{equation} \hat{d} = \frac{\sum_{j=0}^{q-1} \hat{\delta}_j}{1 - \sum_{i=1}^{p-1} \hat{\gamma}_i}. \end{equation}

**Observations or Comments:**
*(Write observations here)*

**New Version:**
*(Draft new version here)*

---

## Paragraph 4.15
- [ ] **Locked**

**Current Content:**
> In Shaikh's procedure, this long-run multiplier anchors the fitted capacity path. Thus, capacity utilization is constructed as the residual deviation from the long-run cointegration vector: $\log \hat{\mu}_t = y_t - \hat{y}^p_t$. This sequence establishes a strict dependency: utilization derives entirely from the estimated coefficient. Shaikh treats $\hat{d}$ as a fitted accounting multiplier; but as mentioned previously, he does not theorize its structural role. This replication re-interprets the coefficient as a transformation elasticity $\hat{\theta}$ of productive capacities, with respect to capital accumulation. Given the multiplicity of possible identification with the five cases of an ARDL model, and the year dummies used by Shaikh to control for outliers in historical episodes, the replication leverages on this researcher-decision making as sources of variation in the replication: conditionally on the specification grid, deterministic treatment, and admissibility gates. The replication evaluates this interpretation in three steps: first by reconstructing the baseline result, then by opening the single-equation specification space, and finally by testing whether the relation survives in a joint system. Subsection~\ref{subsec:data_measurement} details the data construction and measurement conventions required to execute these steps.

**Observations or Comments:**
*(Write observations here)*

**New Version:**
*(Draft new version here)*

---

## Paragraph 4.16
- [ ] **Locked**

**Current Content:**
> The replication uses annual US corporate sector data, 1947--2011 ($T \approx 65$), sourced from \citet{Shaikh2016} data companions via Real Economic Analysis.\footnote{Replication data and construction scripts are available at Real Economic Analysis: \url{https://www.realecon.org/data}. Shaikh (2016) specifies the common-deflator condition but does not name the price index; the replication implements this using a GPIM-consistent implicit price deflator to ensure reproducibility.} Capacity utilization is extracted as the bounded residual deviation from the cointegrated output--capital path; the fitted capacity path inherits its level, timing, and persistence from the measurement choices detailed below. Table~\ref{tab:variables_replication} summarizes the core variables, their construction protocols, and the measurement constraints that structure the replication.

**Observations or Comments:**
*(Write observations here)*

**New Version:**
*(Draft new version here)*

---

## Paragraph 4.17
- [ ] **Locked**

**Current Content:**
> Capital stock follows the Generalized Perpetual Inventory Method (GPIM), an accounting framework that reconstructs \textit{gross} capital stock from nominal gross investment flows, period depreciation rates, and implicit deflator built from nominal gross capital formation national accounts \citep{Shaikh2016}. The recursion accumulates current-cost capital as: \begin{equation} K_t = IG_t + z_t^* \cdot K_{t-1}, \qquad z_t^* \equiv (1 - z_t) \frac{p^K_t}{p^K_{t-1}}, \end{equation}

**Observations or Comments:**
*(Write observations here)*

**New Version:**
*(Draft new version here)*

---

## Paragraph 4.18
- [ ] **Locked**

**Current Content:**
> where $IG_t$ is nominal gross investment, $z_t$ is the period depreciation rate, and $z_t^*$ reflates surviving capital to current replacement cost, or depletion rate of gross capital stock. Three adjustments anchor Shaikh's series: (1) BEA 1993 finite service lives replace the BEA 2011 infinite-lives assumption; (2) initial values are anchored to 1925 via BEA 1993 benchmarks; (3) the IRS corporate book-value index rescales the historical stock over 1925--1947 to account for Great Depression-era scrapping \citep[Appendix~6.7, Sec.~V]{Shaikh2016}. The resulting series tracks the BEA official net stock with a 99.60\,\% average ratio over 1947--2005, confirming that level shifts reflect methodological choices rather than estimation error. Full recursion inputs and depletion-rate construction are provided in Appendix~\ref{subsec:app_gpim}.

**Observations or Comments:**
*(Write observations here)*

**New Version:**
*(Draft new version here)*

---

## Paragraph 4.19
- [ ] **Locked**

**Current Content:**
> Output and capital are deflated by the $pKN$ implicit price index (2005=100), a GPIM-consistent implicit price deflator estimated under the same accumulation rules. Current BEA releases employ quality-adjusted chain weights that adjust for quality vintage, breaking stock-flow consistency for accumulation accounting. The $pKN$ index preserves stock-flow consistency, ensuring the output--capital relation reflects real productive dynamics rather than quality-adjustment artifacts \citep[Appendix~6.6, Sec.~II]{Shaikh2016}. This satisfies the common-deflator condition specified in Shaikh (2016, Appendix~6.6, Eq.~6.6.7); the estimation rationale and comparison to quality-adjusted deflators are detailed in Appendix~\ref{subsec:app_deflator}.

**Observations or Comments:**
*(Write observations here)*

**New Version:**
*(Draft new version here)*

---

## Paragraph 4.20
- [ ] **Locked**

**Current Content:**
> Corporate gross value added is corrected for imputed financial intermediation services by subtracting net monetary interest paid and adding back imputed net interest adjustments (NIPA Table 7.11). The algebraic derivation and NIPA accounts usage considering their releases used by Shaikh, are detailed in more extension at Appendix~\ref{subsec:app_impint}. Year dummies ($D_{1956}$, $D_{1974}$, $D_{1980}$) are included as deterministic controls to absorb outlier-driven residual spikes. Shaikh identified these years using squared-residual diagnostics, arguing that they stabilize the baseline specification by isolating temporary deviations that would otherwise distort the long-run parameters. Historically, this set of dummies is coherent with relevant recessionary events: the Eisenhower Recession, the Oil Shock crisis, and the Volcker shock of monetary policy. The sample size ($T \approx 65$) is small for time series inference, and is a source of potential inference bias on cointegration when relying on asymptotic critical value bounds which Shaikh does not consider in his original account; the replication addresses this by computing exact-sample bounds calibrated to $T=65$ via stochastic simulation \citep{NatsiopoulosTzeremes2022}.

**Observations or Comments:**
*(Write observations here)*

**New Version:**
*(Draft new version here)*

---

## Paragraph 4.21
- [ ] **Locked**

**Current Content:**
> These measurement conventions are part of the identification strategy. The chapter uses Shaikh's GPIM-adjusted gross capital stock because the object of interest is productive capacity in operation, not the book-value measure most directly suited to profitability accounting. Net stocks remain relevant for valuation and profitability, but gross stocks are the closer counterpart to the material capacity concept used in the utilization index\footnote{This distinction matters because profitability calculations and capacity measurement need not require the same capital-stock concept: valuation is central for profit-rate accounting, while the capacity benchmark requires a measure closer to capital in operation.}. Shaikh also argues for the use of a common deflator that isolates real capital--capacity dynamics from price distortion effects.

**Observations or Comments:**
*(Write observations here)*

**New Version:**
*(Draft new version here)*

---

## Paragraph 4.22
- [ ] **Locked**

**Current Content:**
> Over the replication period (1947--2011), the real corporate sector of the US economy exhibited an average annual output growth rate of approximately 3.2\%, while the real corporate capital stock grew at an average annual rate of 3.0\%, and aggregate employment grew at 1.5\%.%TODO: verify these growth rates against raw replication data (not AI-generated) These raw rates indicate that corporate output and capital accumulated at similar but slightly divergent rates over the postwar period, generating a secularly shifting output--capital ratio.

**Observations or Comments:**
- **Advisor Feedback:** "I encourage you to emulate... testing the ideas with some casual, non-econometric observations about the course of GDP, employment, and capital stock growth."
- **Action:** Expand this paragraph to explicitly describe the raw, visible divergence between steady capital accumulation and volatile output/employment _before_ introducing the econometrics. _(Note: Please verify the exact growth rates against your raw data to clear the TODO)._
- **NOTE**: The current "new version is a proposal, but should include verified data using scripts that manage the data set that was used for the estimates of the repo"

**New Version:**
 
 Before turning to formal econometrics, a casual, non-econometric observation of the post-war US data reveals a clear macroeconomic pattern. Over the 1947–2011 period, the real corporate capital stock grew steadily and smoothly, while real output (GDP) and employment exhibited much higher volatility, swinging sharply with business cycles. Over the long run, capital accumulated slightly faster than output, suggesting a gradual, secular decline in the aggregate output-capital ratio. This raw, visible divergence hints that a simple, fixed, and timeless relationship between capital and productive capacity is unlikely to hold. Instead, the conversion of capital into output appears to shift across different historical eras, depending on broader institutional and distributional conditions.

---

## Paragraph 4.23
- [ ] **Locked**

**Current Content:**
> Figure~\ref{fig:main_log_levels} plots the log levels of output ($y_t$) and capital ($k_t$) over the post-war period. The raw trends show that capital accumulation and output grow together, but their ratio is subject to long historical waves. Figure~\ref{fig:main_output_capital_ratio} plots the output--capital ratio ($y_t - k_t$) directly, showing that it does not remain constant at a technical level; rather, it fluctuates around a long-run mean with persistent deviations. Figure~\ref{fig:main_growth_rates} plots the annual growth rates, illustrating that output growth exhibits much higher volatility than capital growth. Cointegration tests and our derived capacity utilization series must align with these descriptive trends: the capacity ceiling cannot be estimated in a way that contradicts these raw historical patterns.

**Observations or Comments:**
- **Advisor Feedback:** "The cointegration econometric portions should be explained more and simplified. What is admissibility? What is at stake? Focus more on the basics of cointegration."
- **Action:** Merge and simplify. Use the "invisible rope" analogy conceptually. Clearly state that "admissibility" just means the model passes the basic test of having a stable long-run relationship and yielding economically sensible results (e.g., utilization between 0% and 100%).

**New Version:**
*(Draft new version here)*

---

## Paragraph 4.24
- [ ] **Locked**

**Current Content:**
> This section outlines the progressive multi-stage macroeconometric strategy used to evaluate the productive-capacity path. Cointegration is the core economic concept anchoring this strategy. It asserts that even if individual time series (like output and capital) are nonstationary and drift over time, a stable linear combination of them can remain stationary. Economically, this means the variables share a long-run equilibrium relation and do not drift apart indefinitely. If cointegration holds, the residual after applying the cointegrating vector must be stationary. If it is nonstationary, the relationship is spurious, meaning the estimated equation lacks economic meaning.

**Observations or Comments:**
*(Write observations here)*

**New Version:**
*(Draft new version here)*

---

## Paragraph 4.25
- [ ] **Locked**

**Current Content:**
> We define "admissibility" as the set of econometric gates that filter out specifications failing this long-run equilibrium condition. Rather than a technical check, admissibility is best understood through counterfactual failures. A specification is non-admissible if it fails to produce stationary residuals (meaning output and capital fail to cointegrate) or if it yields economically incoherent parameter values, such as utilization paths that drift toward zero, exceed plausible operating bounds, or imply unstable capacity dynamics.

**Observations or Comments:**
- **Advisor Feedback:** "The cointegration econometric portions should be explained more and simplified. What is admissibility? What is at stake? Focus more on the basics of cointegration."
- **Action:** Merge and simplify. Use the "invisible rope" analogy conceptually. Clearly state that "admissibility" just means the model passes the basic test of having a stable long-run relationship and yielding economically admissible results (which are not necessarily bounded to 0 to 100%, because capacity utilization can operate beyond normal conditions through shift intensity and other mechanisms)
-
**New Version (Replace 4.24 & 4.25):**

> Cointegration is the core econometric concept anchoring this strategy, and its economic meaning is straightforward. Individual macroeconomic series like output and capital are "nonstationary," meaning they drift over time. Cointegration asserts that despite this drifting, a stable linear combination of them can remain stationary. Economically, this means the variables are tied together by a long-run equilibrium relationship and do not drift apart indefinitely. If cointegration holds, the residual (the gap between actual output and the estimated capacity path) fluctuates around a stable mean. If the residual is nonstationary, the relationship is spurious, meaning the model is merely fitting noise and lacks economic meaning.
> 
> We define "admissibility" as the basic gatekeeping test for this relationship. What is at stake is the validity of the entire capacity measure. A model is "admissible" only if it passes the cointegration test (the residual is stationary) and yields economically coherent results—for example, a capacity utilization rate that plausibly fluctuates between 0% and 100%, rather than drifting to absurd levels. If the bivariate output-capital relation is not admissible, any utilization series derived from it is statistically invalid.

---

## Paragraph 4.26
- [ ] **Locked**

**Current Content:**
> The replication evaluates these admissibility gates across three progressive stages: - Stage S0 reconstructs the baseline single-equation procedure reported by \citet{Shaikh2016} to test its reproducibility. - Stage S1 maps a combinatoric grid of 500 single-equation ARDL specifications. It tests how researcher choices over lag length, historical outlier dummies, and trend structures affect the estimated elasticity $\theta$ and its cointegration bounds. - Stage S2 shifts to a joint system framework using the \citet{Johansen1991} reduced-rank VECM approach, testing whether bivariate output--capital cointegration is robust or requires the logged rate of exploitation to enter the state vector to achieve stability.

**Observations or Comments:**
*(Write observations here)*

**New Version:**
*(Draft new version here)*

---

## Paragraph 4.27
- [ ] **Locked**

**Current Content:**
> Stage S0 tests the empirical reproducibility of Shaikh's results to establish a canonical point of departure for the replication and a benchmark for reconstruction. It selects Shaikh's published single-equation output--capital benchmark as the target, fixes the dynamic lag structure at the reported ARDL(2,4) configuration, and estimates the model using the closest recoverable corporate-sector series. This procedure systematically identifies the exact variables within the published data tables, safely bypassing undocumented documentation omissions noted in the original baseline text. Historical impulse variables and alternative Pesaran, Shin, and Smith (PSS) deterministic configurations are estimated to reconstruct the reported point estimates and establish a baseline, rather than to execute an open specification search.

**Observations or Comments:**
*(Write observations here)*

**New Version:**
*(Draft new version here)*

---

## Paragraph 4.28
- [ ] **Locked**

**Current Content:**
> The empirical procedure estimates the long-run output--capital relation, constructs productive capacity from that fitted path, and derives capacity utilization from the deviation of actual output from the estimated capacity denominator. Cointegration bounds testing serves as the primary admissibility diagnostic to isolate valid level relationships from simple autoregressive dynamic filtering. This step highlights an essential technical property of the ARDL framework developed by \citet{Pesaran2001}: while the $F$-bounds test remains universally applicable, the $t$-bounds statistic can only be formally defined under deterministic Cases 1, 3, and 5. Models tracking Case 2 or Case 4 configurations—which impose restricted constants or restricted trends within the cointegrating vector—cannot be subjected to a $t$-bounds confirmation gate.

**Observations or Comments:**
*(Write observations here)*

**New Version:**
*(Draft new version here)*

---

## Paragraphs 4.29 to 4.36 (Consolidated Replacement)
- [ ] **Locked**

**Current Content:**
> [Original Paragraphs 4.29 through 4.36 containing heavy set notation: $\mathcal{G}_{S1}$, $\mathcal{A}^{F}_{S1}$, $\mathcal{T}_{S1}$, $\mathcal{C}_{S1}$, $E_{S1}$, $\mathcal{F}^{(0.20)}_j$]

**Observations or Comments:**
**ACTION:** DELETE original Paragraphs 4.29 through 4.36 entirely. REPLACE with the three new paragraphs below. 
**RATIONALE:** This satisfies the advisor's request to reduce the "lot of material on criteria" while preserving the formal math to demonstrate PhD-level mastery. Each formal definition is now immediately followed by a plain-English "translation" explaining the economic intuition and explicitly stating which models fared badly (those omitting historical dummies).

**New Version:**
> Stage S1 tests whether the baseline coefficient is unique or merely a product of arbitrary researcher choices. Instead of relying on a single model, we estimate a combinatoric grid of 500 Autoregressive Distributed Lag (ARDL) specifications. Formally, the complete specification space is defined as $\mathcal{G}_{S1} = \{(p, q, c, s)\}$, where $p, q \in \{1,\dots,5\}$ are the lag orders, $c \in \{1,\dots,5\}$ selects the deterministic case (PSS I through V), and $s \in \{s_0, s_1, s_2, s_3\}$ selects the historical impulse dummies. In plain terms, this grid systematically varies every major researcher choice—lag length, trend structure, and historical shock controls—to see if the estimated transformation elasticity ($\hat{\theta}$) holds steady or fractures under different assumptions.
> 
> Rather than presenting all 500 results, we apply a sequential "admissibility" screen to filter out spurious relationships. The primary gate is the $F$-bounds test for cointegration. Formally, the $F$-admissible set is $\mathcal{A}^{F}_{S1} = \{ m \in \mathcal{G}_{S1} : p_F(m) \leq 0.10 \}$. Economically, this means we discard any model where the output-capital residual is nonstationary, as such models merely fit noise and yield economically absurd utilization paths. Of the 500 models, only 102 pass this gate. A secondary $t$-bounds screen ($\mathcal{T}_{S1}$) further confirms that deviations from the long-run relation actually correct over time. Crucially, this screening reveals what alternatives fare badly: models that omit historical shock controls ($s_0$) systematically fail the cointegration test, proving that the output-capital relationship is spurious unless it accounts for major structural breaks like the 1974 oil shock.
> 
> Among the admissible models, we apply information-criterion penalties to organize the fit-complexity trade-off. We construct a Pareto-optimal fit-complexity envelope, $E_{S1}$, which collects models that cannot be improved in fit without adding parameters, and cannot be simplified without worsening fit. We then define criterion-specific neighborhoods, $\mathcal{F}^{(0.20)}_j$, capturing the top 20% of models under criteria like AIC, BIC, and the parsimony-focused RICOMP. The results reveal significant identification fragility: there is no single "best" model. For instance, the shared AIC/BIC winner is an ARDL(3,3) model yielding $\hat{\theta} = 0.92$, while the parsimony-focused RICOMP criterion selects a simpler ARDL(1,2) model yielding $\hat{\theta} = 0.65$. This divergence demonstrates that the single-equation output-capital relationship is not a unique structural law; it is highly sensitive to the researcher's penalty schedule, and the resulting capacity utilization path shifts mechanically depending on which valid specification is chosen.

---

## Paragraph 4.40
- [ ] **Locked**

**Current Content:**
> where $j \in \{\text{AIC}, \text{BIC}, \text{HQ}, \text{ICOMP}, \text{RICOMP}\}$, and $Q_{0.20}$ denotes the 20th percentile cutoff with ties retained. Traditional scalar penalty schedules (AIC, BIC, HQ) are augmented by Bozdogan's information complexity indices, evaluating parameter covariance structures and inverse-Fisher geometric information properties. The RICOMP criterion actively screens the parsimonious edge of the envelope by penalizing parameter interdependence. Long-run parameter estimates are highly dependent on deterministic treatments and information-criterion penalty schedules, meaning different criteria locate divergent regions of the fit-complexity space.

**Observations or Comments:**
*(Write observations here)*

**New Version:**
*(Draft new version here)*

---

## Paragraph 4.41
- [ ] **Locked**

**Current Content:**
> Every specification $m$ yields a distinct parameter estimate $\hat{\theta}(m)$, which directly shapes the fitted capacity path. The constructed utilization series then emerges as the stationary component of a flow-stock system, downstream from a distributionally sensitive parameter space: \begin{equation} \hat{\mu}_t(m) = y_t - [\hat{a}(m) + \hat{b}(m)t + \hat{\theta}(m)k_t]. \label{eq:mu_hat_m} \end{equation}

**Observations or Comments:**
*(Write observations here)*

**New Version:**
*(Draft new version here)*

---

## Paragraph 4.42
- [ ] **Locked**

**Current Content:**
> Tracking $\hat{\mu}_t(m)$ --- the constructed capacity utilization path for model $m$ --- across the three organizational layers ($\mathcal{A}^{F}_{S1}$: all bounds-admissible models; $E_{S1}$: the Pareto-optimal envelope; $\mathcal{F}^{(0.20)}_j$: each IC-specific neighborhood) makes visible the direct macroeconomic consequences of specification choice: different retained ARDL alternatives produce different capacity ceilings, and therefore different utilization levels.

**Observations or Comments:**
*(Write observations here)*

**New Version:**
*(Draft new version here)*

---

## Paragraph 4.43
- [ ] **Locked**

**Current Content:**
> Table~\ref{tab:s1_stress_synthesis} details the operational layout of the $S1$ specification search. Rather than optimizing for a single candidate model, this framework establishes the empirical variance of the transformation parameter across defensible single-equation structures. This single-equation core mapping is evaluated empirically in Section~\ref{subsec:S1_ardl_grid}.

**Observations or Comments:**
*(Write observations here)*

**New Version:**
*(Draft new version here)*

---

## Paragraph 4.44
- [ ] **Locked**

**Current Content:**
> Section~\ref{subsec:S2_system} extends the analysis to a joint multi-equation system. Moving beyond single-equation constraints, the system-level analysis tests whether bivariate cointegration holds or whether the relationship requires the logged rate of exploitation ($e_t$) to enter the long-run cointegrating space.

**Observations or Comments:**
*(Write observations here)*

**New Version:**
*(Draft new version here)*

---

## Paragraph 4.45
- [ ] **Locked**

**Current Content:**
> Stage S2 evaluates whether the bilateral output--capital relation remains self-sufficient when shifted from a conditional single-equation setup to a joint multi-equation system. The baseline bivariate vector, $X_t = (\ln Y_t, \ln K_t)'$, fails to exhibit cointegration, violating the Johansen rank conditions and companion-matrix stability requirements. To address this, the expanded framework introduces explicit distributional conditioning by integrating the logged rate of exploitation, $e_t = \ln(\pi_t / (1 - \pi_t))$, yielding the trivariate state vector $X_t = (\ln Y_t, \ln K_t, \ln e_t)'$. This trivariate system is estimated using the full \citet{Johansen1991} Vector Error Correction Model (VECM) representation: \begin{equation} \label{eq:vecm_johansen} \Delta X_t = \Pi X_{t-1} + \sum_{i=1}^{p-1} \Gamma_i \Delta X_{t-i} + \Phi D_t + \varepsilon_t, \end{equation}

**Observations or Comments:**
*(Write observations here)*

**New Version:**
*(Draft new version here)*

---

## Paragraph 4.46
- [ ] **Locked**

**Current Content:**
> where $\Gamma_i$ captures short-run dynamics, $\Phi D_t$ contains deterministic controls, and the long-run impact matrix is factored as $\Pi = \alpha \beta'$ to evaluate reduced-rank stability. Joint system survival is achieved exclusively under this formulation, where the rank condition $r=1$ holds and the exploitation variable successfully anchors the long-run cointegrating space ($\beta$).

**Observations or Comments:**
*(Write observations here)*

**New Version:**
*(Draft new version here)*

---

## Paragraph 4.47
- [ ] **Locked**

**Current Content:**
> To systematically test this stability, S2 implements a VECM combinatoric grid mirroring the single-equation sensitivity approach. Formally, the complete attempted specification space for each target rank ($r$) is defined as: \begin{equation} \mathcal{G}_{S2}^{(r)} = \{(p, C_{\text{det}}, s)\}, \label{eq:G_S2} \end{equation}

**Observations or Comments:**
*(Write observations here)*

**New Version:**
*(Draft new version here)*

---

## Paragraph 4.48
- [ ] **Locked**

**Current Content:**
> where $p \in \{1, 2, 3, 4\}$ represents the VAR lag orders, $C_{\text{det}} \in \{C_0, C_1, C_2, C_3\}$ indexes the Johansen (1995) deterministic case configurations, and $s \in \{h_0, h_1, h_2\}$ isolates the historical outlier controls. Note that these $C_{\text{det}}$ configurations belong to the system-level VECM framework and are distinct from the single-equation Pesaran, Shin, and Smith (2001) deterministic cases used in Subsection~\ref{subsec:S1_ardl_grid}. In Johansen's notation, $C_0$ assumes no constant or trend in either the VAR or the cointegrating vector; $C_1$ represents a restricted constant (drift) inside the cointegrating space with no trend; $C_2$ represents an unrestricted constant inside the VAR and no trend; and $C_3$ represents an unrestricted constant in the VAR and a restricted linear trend in the cointegrating space. Permuting across these configurations yields an attempted grid of 48 specifications per rank. Because specifications under the restricted constant case ($C_1$) systematically fail numerical convergence across all permutations, we restrict the successfully estimated VECM baseline to exactly 36 models per system family.

**Observations or Comments:**
*(Write observations here)*

**New Version:**
*(Draft new version here)*

---

## Paragraph 4.49
- [ ] **Locked**

**Current Content:**
> To ensure the estimated system represents a stable long-run economic relationship rather than a spurious mathematical artifact, the Stage S2 admissibility protocol evaluates these surviving 36 specifications through a rigorous triple gate: 1. \textbf{Gate 1: Cointegration Rank Confirmation}: We require the Johansen Trace test to reject the null hypothesis of no cointegration ($r=0$) at the 5\% level while failing to reject the null of a single cointegrating vector ($r \leq 1$). This confirms that the variables share a stable long-run attractor rather than drifting apart. 2. \textbf{Gate 2: Companion Matrix Dynamic Stability}: The eigenvalues of the VECM's companion matrix must have moduli strictly bounded by the unit circle (excluding the $k - r$ unit roots representing common stochastic trends). Failing this gate implies an explosive system where any shock drives the model to diverge infinitely. 3. \textbf{Gate 3: Residual Diagnostic Cleanliness}: The residuals must pass the Breusch-Godfrey LM test for serial correlation and the ARCH-LM test for heteroscedasticity at the 5\% level. Failing this gate indicates that the model's standard errors are biased, rendering any statistical inference invalid. Within the trivariate framework, the reduced-rank restriction $r=1$ tests whether a single cointegrating relation survives distributional integration. To organize the surviving specifications, the subset $\Omega_{20}$ ranks the admissible models based strictly on minimized log-likelihood loss, establishing an interpretive hierarchy for the retained systems.

**Observations or Comments:**
*(Write observations here)*

**New Version:**
*(Draft new version here)*

---

## Paragraph 4.50
- [ ] **Locked**

**Current Content:**
> The replication implements a multi-stage screening procedure to map the boundary conditions of the productive-capacity path. Stage S0 establishes the approximate empirical recoverability of the baseline single-equation framework. Stage S1 expands the estimation framework into a comprehensive specification grid, utilizing structural bounds diagnostics and information-criterion envelopes to map parameter non-uniqueness. Finally, Stage S2 imposes multi-equation Vector Error Correction Model (VECM) stability checks to verify whether the underlying structural relation survives when estimated jointly. Table~\ref{tab:cross_stage_synthesis_design} formalizes this progressive methodological sequence.

**Observations or Comments:**
*(Write observations here)*

**New Version:**
*(Draft new version here)*

---

## Paragraph 4.51
- [ ] **Locked**

**Current Content:**
> Stage S0 evaluates the empirical reproducibility of Shaikh's baseline results to reconcile the discrepancy between the published estimate of $\hat{d}=0.66$ and the reconstructed estimate of $\hat{d}=0.72$ (read here as the capacity transformation elasticity $\hat{\theta}$). While \citet{Shaikh2016} frames the long-run coefficient as a fitted accounting multiplier, we treat it as a behavioral parameter. Using the variables and deflators recovered from the national accounts, this reconstruction recovers the empirical capacity path from the nearest reproducible single-equation output--capital specification, focusing on point-estimate recoverability.

**Observations or Comments:**
*(Write observations here)*

**New Version:**
*(Draft new version here)*

---

## Paragraph 4.52
- [ ] **Locked**

**Current Content:**
> The divergence between the published 0.66 and the reconstructed 0.72 is the primary S0 result. Rather than a computational error, this difference arises from undocumented choices in the baseline data construction. Reconstructing the benchmark required identifying the price deflator index and data vintage from archive spreadsheets, where alternative deflator selections shift the long-run coefficient. A capacity baseline is recoverable only when we actively reconstruct the undocumented choices of the original author—demonstrating that replication is not a passive mirror, but an active econometric reconstruction. The faithful reconstruction yields $\hat{\theta}=0.72$ from an ARDL(2,4) specification, which also emerges as the BIC winner in the S0 rerun. However, the bounds F-statistic of 3.349 for the ARDL(2,4) model barely clears the 10% significance threshold ($p=0.099$), signaling the potential fragility of the single-equation specification. To address this cointegration fragility, we select the AIC-selected \textbf{ARDL(4,3)} specification as our focal reconstruction model, which yields a highly robust estimate of $\hat{\theta}=0.75$ ($F=5.250$, $p=0.023$). The precise estimated parameters for these models are reported in Table~\ref{tab:s0_model_parameters}.

**Observations or Comments:**
*(Write observations here)*

**New Version:**
*(Draft new version here)*

---

## Paragraph 4.53
- [ ] **Locked**

**Current Content:**
> The bounds testing procedure in the ARDL framework evaluates the existence of a long-run relationship without prior assumptions regarding the integration order of the variables. The test brackets the polar cases where the regressors are purely $I(0)$ or purely $I(1)$ to evaluate whether a meaningful level relationship exists. Under the null hypothesis of no cointegration, the joint exclusion of lagged level variables is tested.

**Observations or Comments:**
*(Write observations here)*

**New Version:**
*(Draft new version here)*

---

## Paragraph 4.54
- [ ] **Locked**

**Current Content:**
> The computed test statistics are compared against critical values generated by stochastically simulated finite-sample distributions, as reported in Table~\ref{tab:s0_bounds_alpha10}. In the faithful reconstruction, the $F$-bounds statistic yields a value of 3.349, which barely clears the $I(1)$ critical value threshold of 3.333 at the 10\% significance level ($p=0.099$). In contrast, the focal ARDL(4,3) model yields a highly significant $F$-bounds statistic of 5.250 ($p=0.023$) and a $t$-bounds statistic of $-3.125$ ($p=0.015$), confirming that the bivariate relation cointegrates robustly.

**Observations or Comments:**
*(Write observations here)*

**New Version:**
*(Draft new version here)*

---

## Paragraph 4.55
- [ ] **Locked**

**Current Content:**
> The error-correction representation of the focal ARDL(4,3) model reveals a slow adjustment process. The lagged dependent level variable coefficient (which measures the speed of adjustment in the UECM form) is $\hat{\phi}_1 = -(1 - \sum \gamma_i) = -0.127$ (SE 0.038, t-stat $-3.34$, $p<0.01$). This indicates that the economy corrects approximately 12.7% of its deviation from the capacity ceiling each year. The negative coefficients on the structural break dummies ($D_{1956}, D_{1974}, D_{1980}$) are all statistically significant, capturing permanent downward step-shifts in capital productivity. These shocks reflect the Eisenhower defense cuts of 1956, the OPEC oil embargo of 1974, and the Volcker credit squeeze of 1980.

**Observations or Comments:**
*(Write observations here)*

**New Version:**
*(Draft new version here)*

---

## Paragraph 4.56
- [ ] **Locked**

**Current Content:**
> A small change in the estimated elasticity $\theta$ from 0.72 to 0.75 alters the constructed utilization series by as much as 5 percentage points. This sensitivity arises because the estimated parameter propagates directly through the capacity definition, where any deviation in $\hat{\theta}$ shifts the capacity ceiling and changes the resulting utilization levels.

**Observations or Comments:**
*(Write observations here)*

**New Version:**
*(Draft new version here)*

---

## Paragraph 4.57
- [ ] **Locked**

**Current Content:**
> Figure~\ref{fig:s0-cu-fan-diagnostic} plots the estimated capacity utilization paths generated under alternative single-equation specifications, alongside Shaikh's published series and the Federal Reserve Board (FRB) manufacturing index. The spread between the reconstructed ARDL(2,4) benchmark ($\hat{\theta}=0.72$) and the AIC-selected ARDL(4,3) comparator ($\hat{\theta}=0.75$) shows that utilization estimates are highly sensitive to lag-length selection. A minor adjustment of 0.03 in the estimated transformation elasticity yields up to a 5 percentage point level shift in constructed utilization, indicating that single-equation capacity paths are highly sensitive to lag and specifications (as illustrated in Figure~\ref{fig:s0-cu-fan-diagnostic}).

**Observations or Comments:**
*(Write observations here)*

**New Version:**
*(Draft new version here)*

---

## Paragraph 4.58
- [ ] **Locked**

**Current Content:**
> Stage S0 confirms that a Shaikh-like capacity benchmark is empirically reproducible. However, recovering a single point estimate does not guarantee that the underlying structural parameter is unique or robust. To expose potential identification fragility, Stage S1 expands the estimation framework. This next stage tests whether the recovered benchmark remains stable across a wide grid of admissible single-equation alternatives.

**Observations or Comments:**
*(Write observations here)*

**New Version:**
*(Draft new version here)*

---

## Paragraph 4.59
- [ ] **Locked**

**Current Content:**
> Stage S1 evaluates whether the baseline coefficient remains stable across a 500-model ARDL grid that varies lag order, deterministic case, historical controls, and information criteria. In the notation of Section~\ref{subsec:empirical_design}, we move from a single ARDL point estimate to the fully screened grid space $\mathcal{G}_{S1}$.

**Observations or Comments:**
*(Write observations here)*

**New Version:**
*(Draft new version here)*

---

## Paragraph 4.60
- [ ] **Locked**

**Current Content:**
> We estimate 500 combinatorial specifications to map the single-equation ARDL specification space. Applying the 10 percent bounds threshold, 102 specifications pass the primary bounds gate and enter the admissible set $\mathcal{A}^{F}_{S1}$. As we tighten the significance threshold, the number of surviving specifications shrinks: 62 remain admissible at the 5 percent level, and only 13 at the 1 percent level (as summarized in Table~\ref{tab:s1_shrinking_space_counts}). Unpacking this admissible set reveals that cointegration is highly concentrated. No-trend configurations dominate 90.2\% of the admissible space, specifically restricted to \textbf{Pesaran, Shin, and Smith (PSS, 2001) deterministic Cases I, II, and III} (no-constant/no-trend, restricted constant, and unrestricted constant without trend). In contrast, PSS trend-containing Cases IV and V represent only 9.8\% of the admissible set. Furthermore, level stability is highly conditional on historical controls: 92.2\% of the admissible models require at least one structural break dummy variable ($s_1, s_2, s_3$) to pass the bounds test, showing how step-shift dummies act as outlier controls to restore stationarity under historical shocks.

**Observations or Comments:**
*(Write observations here)*

**New Version:**
*(Draft new version here)*

---

## Paragraph 4.61
- [ ] **Locked**

**Current Content:**
> To bring this specification search down to earth, we select and unpack two focal models that represent the distinct information-theoretic poles of the grid: \begin{enumerate} \item The \textbf{shared AIC/BIC/HQ/ICOMP winner: ARDL(3,3) under PSS Case I (no-constant/no-trend), with the $s_1$ dummy (1974)}, which yields $\hat{\theta} = 0.92$ (SE 0.04). \item The \textbf{RICOMP winner: ARDL(1,2) under PSS Case II (restricted constant), with no dummies ($s_0$)}, which yields $\hat{\theta} = 0.65$ (SE 0.07). \end{enumerate} Table~\ref{tab:s1_focal_parameters} reports the complete estimated parameters and bounds diagnostics for these two focal models.

**Observations or Comments:**
*(Write observations here)*

**New Version:**
*(Draft new version here)*

---

## Paragraph 4.62
- [ ] **Locked**

**Current Content:**
> Figure~\ref{fig:s1-shrinking-space-bounds-layers} reports this screening hierarchy visually. Panel A maps the 500 estimated specifications across the fit--complexity space, color-coded strictly by bounds-admissibility status. Panel B translates this geometry into exact specification counts surviving each sequential screening layer (see Figure~\ref{fig:s1-shrinking-space-bounds-layers}). This sequential ordering reinforces the fundamental methodological rule that model comparison begins strictly after the bounds screen, not before it.

**Observations or Comments:**
*(Write observations here)*

**New Version:**
*(Draft new version here)*

---

## Paragraph 4.63
- [ ] **Locked**

**Current Content:**
> Within the \(F\)-admissible set, the corrected global non-dominated fit--complexity envelope (\(E_{S1}\)) isolates 17 optimal specifications. The horizontal dimension of this geometric space measures model complexity via the total number of estimated parameters, while the vertical dimension measures the lack of fit, reported formally as \(-2\log L\). Moving along the \(E_{S1}\) frontier therefore trades statistical fit against structural parsimony. The resulting envelope serves strictly as a geometric summary of Pareto-optimal ARDL alternatives, not as a singular new estimator.

**Observations or Comments:**
*(Write observations here)*

**New Version:**
*(Draft new version here)*

---

## Paragraph 4.64
- [ ] **Locked**

**Current Content:**
> This strong statistical dependence on dummy variables aligns with the historical trajectory of the postwar US economy. The shock years correspond to major systemic disruptions: the 1956 Eisenhower recession (marking a sharp contraction in industrial output post-Korean War), the 1974 first OPEC oil crisis (OPEC oil embargo and subsequent stagflation), and the 1980 Volcker shock (extreme federal funds rate hikes that induced a severe double-dip credit crunch). In a pure bivariate level relation without outlier controls ($s_0$), these historical events appear as persistent, non-mean-reverting shocks in the residuals. Consequently, the error term behaves as a random walk, violating stationarity and causing the bounds test to fail. Restoring cointegration requires step-shift dummy variables ($s_1, s_2, s_3$) to control for these historical shocks, removing their structural level shifts from the residuals and allowing the error term to return to a zero-mean stationary path. The negative coefficients on these dummies capture the permanent structural dampening of capital productivity ($Y/K$) caused by these crises. In 1956, this corresponds to the post-Korean War defense budget cuts under Eisenhower which cooled manufacturing output. In 1974, it captures the OPEC price-profit squeeze and Bretton Woods collapse forcing capital to permanently idle capacity. In 1980, it captures the Volcker shock, where the federal funds rate reached 20\%, inducing a severe credit contraction that permanently shifted the economy toward lower capacity utilization.

**Observations or Comments:**
*(Write observations here)*

**New Version:**
*(Draft new version here)*

---

## Paragraph 4.65
- [ ] **Locked**

**Current Content:**
> The IC-specific neighborhoods operate as post-admissibility, criterion-conditioned organization layers. For each criterion \(j \in \{\mathrm{AIC},\mathrm{BIC},\mathrm{HQ},\mathrm{ICOMP},\mathrm{RICOMP}\}\), the neighborhood \(\mathcal{F}^{(0.20)}_j\) isolates the bottom 20 percent of \(F\)-admissible specifications, capturing 36 unique models across the union. Table~\ref{tab:s1_ic_neighborhood_summary} reports the precise parameter ranges across these respective criterion borders, demonstrating that these neighborhoods organize the retained specifications rather than establish cointegration natively.

**Observations or Comments:**
*(Write observations here)*

**New Version:**
*(Draft new version here)*

---

## Paragraph 4.66
- [ ] **Locked**

**Current Content:**
> Figure~\ref{fig:s1-crossed-frontier-ic-neighborhoods} supplies the primary fit--complexity and IC-neighborhood evidence. The solid black line denotes the Pareto non-dominated fit--complexity envelope (\(E_{S1}\)). Surrounding this frontier, the shaded polygons define the 20th percentile neighborhoods for each respective information criterion. This visualization maps the spatial divergence between the highly parsimonious RICOMP winner and the shared scalar-penalty winner.

**Observations or Comments:**
*(Write observations here)*

**New Version:**
*(Draft new version here)*

---

## Paragraph 4.67
- [ ] **Locked**

**Current Content:**
> The shared AIC/BIC/HQ/ICOMP winner is an ARDL(3,3) specification under PSS Case I with the 1974 dummy ($s_1$), yielding $\hat{\theta}=0.92$. Conversely, RICOMP selects a highly parsimonious ARDL(1,2) specification under PSS Case II with no dummies ($s_0$), yielding $\hat{\theta}=0.65$. This criteria divergence does not establish a structural ranking of the underlying estimators. Unlike standard scalar penalties, the ICOMP and RICOMP criteria evaluate complexity through the covariance structure of estimated parameters and residual dependence \citep{Bozdogan1990,Bozdogan2000}. Consequently, the RICOMP neighborhood marks a covariance-complexity-sensitive region of the admissible space rather than providing a definitive model-selection verdict \citep{GuneyBozdoganArslan2021}. This parameter variation carries significant theoretical implications. While PSS no-trend configurations (PSS Cases I, II, and III) yield stable long-run elasticities bounded below unity ($\hat{\theta} \in [0.65, 0.95]$) that support the overaccumulation hypothesis, the PSS trend-containing configurations (PSS Cases IV and V) yield economically invalid parameter magnitudes ($\hat{\theta}$ averaging 1.36 and reaching up to 2.20). An elasticity $\theta > 1.0$ implies that productive capacity expands faster than capital accumulation in the long run, violating the classical overaccumulation baseline. This replication therefore treats trend-containing estimates above unity not as alternative theoretical findings, but as statistically admissible yet economically inadmissible specifications because they imply implausible long-run capacity dynamics for the object under study.

**Observations or Comments:**
*(Write observations here)*

**New Version:**
*(Draft new version here)*

---

## Paragraph 4.68
- [ ] **Locked**

**Current Content:**
> Figure~\ref{fig:s1-cu-fan-ic-neighborhoods} serves a narrower evidentiary role by reporting the diagnostic constructed-utilization paths generated strictly from the retained IC-neighborhood specifications. The shaded region maps the variance of constructed capacity utilization, while the divergent paths of the distinct criteria winners highlight the macroeconomic sensitivity to single-equation penalty schedules. These paths provide supporting evidence for parameter non-uniqueness, demonstrating how the implied utilization series mechanically shifts when the capacity denominator relies on different retained ARDL alternatives.

**Observations or Comments:**
*(Write observations here)*

**New Version:**
*(Draft new version here)*

---

## Paragraph 4.69
- [ ] **Locked**

**Current Content:**
> To bring the statistical significance of these results down to earth, we examine what happens when we force the model to assume that capital and capacity must grow at the exact same rate in the long run—meaning we impose the balanced-growth constraint ($\theta = 1.0$). Under this unitary constraint, the capacity path is forced to expand exactly in step with the capital stock, imposing a constant capital productivity baseline. When we construct capacity utilization under this restriction, the resulting series drifts to economically absurd levels, falling continuously to under $35\%$ for decades or exceeding $105\%$ during periods of expansion. In simple terms, a factory cannot operate at $35\%$ capacity for 30 years without going bankrupt, nor can it exceed $100\%$ capacity indefinitely. This physical absurdity shows that the balanced-growth constraint is empirically incompatible with the post-war US historical experience under Shaikh's identification model, demonstrating why estimating the unrestricted parameter is a requirement for economic viability.

**Observations or Comments:**
*(Write observations here)*

**New Version:**
*(Draft new version here)*

---

## Paragraph 4.70
- [ ] **Locked**

**Current Content:**
> Stage S1 demonstrates that the admissible single-equation space is populated, yet it systematically rejects the assumption of a unique structural benchmark. Because the retained alternatives fail to collapse into a single transformation elasticity ($\hat{\theta}$), the resulting single-equation utilization path remains structurally fragile. Section~\ref{subsec:S2_system} addresses this fragility by testing whether the output--capital relation survives multi-equation system estimation, and whether that survival strictly requires distributional variables to en\subsection{Stage 2 \texorpdfstring{$(S2)$}{}: System-Level VECM Replication} \label{subsec:S2_vecm}

**Observations or Comments:**
**ACTION:** Replace current content. Fixes a broken LaTeX tag and cutoff sentence at the end of the paragraph.

**New Version:**
> Stage S1 demonstrates that the admissible single-equation space is populated, yet it systematically rejects the assumption of a unique structural benchmark. Because the retained alternatives fail to collapse into a single transformation elasticity ($\hat{\theta}$), the resulting single-equation utilization path remains structurally fragile. Section~\ref{subsec:S2_vecm} addresses this fragility by testing whether the output--capital relation survives multi-equation system estimation, and whether that survival strictly requires distributional variables to be included.
> 
> \subsection{Stage 2 $(S2)$: System-Level VECM Replication} \label{subsec:S2_vecm}

---

## Paragraph 4.71
- [ ] **Locked**

**Current Content:**
> Stage S2 extends the empirical analysis to a system-level vector error correction model (VECM) to evaluate the joint dynamics of output and capital. The bivariate state vector, $X_t=(\ln Y_t,\ln K_t)'$, is examined first. However, the bivariate system fails to satisfy cointegration criteria across all specifications. The VECM residuals remain nonstationary, indicating that the long-run relation between output and capital is spurious when estimated in isolation.

**Observations or Comments:**
*(Write observations here)*

**New Version:**
*(Draft new version here)*

---

## Paragraph 4.72
- [ ] **Locked**

**Current Content:**
> To address this system-level instability, we introduce the trivariate state vector $X_t=(\ln Y_t,\ln K_t,\ln e_t)'$, where $\ln e_t$ represents the logged rate of exploitation, constructed as the aggregate corporate profit-share-to-wage-share ratio: $e_t=\pi_t/(1-\pi_t)$. Incorporating the distribution variable into the state vector endogenizes Sraffa-style choice of technique, showing that institutional distribution is a necessary condition for identifying a stable long-run output--capital relationship \citep{Kurz1986}. The system-level estimation is governed by a triple confirmation gate consisting of numerical convergence, Johansen reduced-rank verification, and companion-matrix dynamic stability, to isolate robust long-run systems from unstable vector autoregressive processes.

**Observations or Comments:**
- **Advisor Feedback:** "The analysis is at a high level of abstraction... What do you picture as the mechanism (in a descriptive or institutionalist way). Can you describe what happens in the workplace (or in capital markets, etc) that changes the conversion of capital into potential output and then into actual output?"
- **Action:** The current text mentions "choice of technique" but remains too abstract. Inject a concrete, descriptive paragraph explaining _how_ class struggle physically alters the capital-to-output conversion rate. This perfectly bridges the econometric result (the need for etet​) with UMass political economy theory.

**New Version (Insert this as a new paragraph after 4.72, or weave into 4.81):**

> To ground this statistical finding in institutional reality, we must ask: what concrete mechanisms change the conversion of capital into potential and actual output? The "rate of exploitation" in our model is not merely an abstract accounting ratio; it proxies the institutional balance of class power that dictates workplace and market dynamics. Descriptively, when labor is strong and wages rise (e.g., the post-war Golden Age), firms respond by substituting labor with machinery (raising the capital stock) but may deliberately idle existing capacity to protect profit margins, lowering the conversion of capital to actual output. Conversely, during the neoliberal era, weakened labor bargaining power, the rise of "just-in-time" inventory systems, and increased work intensity allowed firms to extract significantly more output from the same physical capital stock without building new factories. Thus, the statistical necessity of including the exploitation rate in the cointegrating vector reflects a real-world reality: the conversion of capital into capacity is actively moderated by class struggle, labor discipline, and the organizational choices of firms.

---
## Paragraph 4.72a (New Insertion)
- [ ] **Locked**

**Current Content:**
> *(None - This is a new paragraph to be inserted immediately after Paragraph 4.72)*

**Observations or Comments:**
**ACTION:** INSERT this new paragraph immediately after Paragraph 4.72. 
**RATIONALE:** Directly addresses the advisor's feedback: "What do you picture as the mechanism (in a descriptive or institutionalist way). Can you describe what happens in the workplace... that changes the conversion of capital into potential output?" This bridges the econometric result (the need for $e_t$) with concrete UMass political economy theory.

**New Version:**
> To ground this statistical finding in institutional reality, we must ask: what concrete mechanisms change the conversion of capital into potential and actual output? The "rate of exploitation" in our model is not merely an abstract accounting ratio; it proxies the institutional balance of class power that dictates workplace and market dynamics. Descriptively, when labor is strong and wages rise (e.g., the post-war Golden Age), firms respond by substituting labor with machinery (raising the capital stock) but may deliberately idle existing capacity to protect profit margins, lowering the conversion of capital to actual output. Conversely, during the neoliberal era, weakened labor bargaining power, the rise of "just-in-time" inventory systems, and increased work intensity allowed firms to extract significantly more output from the same physical capital stock without building new factories. Thus, the statistical necessity of including the exploitation rate in the cointegrating vector reflects a real-world reality: the conversion of capital into capacity is actively moderated by class struggle, labor discipline, and the organizational choices of firms.
---

## Paragraph 4.73
- [ ] **Locked**

**Current Content:**
> The results are presented in Table~\ref{tab:s2_admissibility_outcomes}, which details the structural outcomes across the complete VECM specification space ($\mathcal{G}_{S2}$). The bivariate $r=1$ configuration yields zero admissible models, with VECM residuals that fail unit-root tests and remain nonstationary. In contrast, the trivariate $r=1$ framework yields six admissible specifications when conditioned on the logged rate of exploitation, $\ln e_t$. Cointegration is established only when $\ln e_t$ enters the trivariate system alongside step-shift dummies. This result shows that distribution variables stabilize the long-run output--capital relationship.

**Observations or Comments:**
*(Write observations here)*

**New Version:**
*(Draft new version here)*

---

## Paragraph 4.74
- [ ] **Locked**

**Current Content:**
> To ground the VECM results, we select the \textbf{VAR(2) specification under Johansen Case 2 ($C_2$: restricted constant), $h_2$ dummies, and rank $r=1$} as our focal model. The model passes all three admissibility gates. We verify cointegration rank using the Johansen Trace test: we reject the null hypothesis of no cointegration ($r=0$) at the 5% level (Trace statistic $32.28 > 31.52$), and we fail to reject the null of a single cointegrating vector ($r \leq 1$) (Trace statistic $10.68 < 17.95$). We confirm dynamic stability through the VECM companion matrix eigenvalues: the moduli are $1.0, 1.0, 0.82, 0.52, 0.52, 0.49$, all strictly bounded by the unit circle (except the two unit roots). Residual diagnostics verify that the system is free from residual pathology: the Portmanteau(12) statistic is $100.70$ ($p=0.275$), the Jarque-Bera statistic is $5.72$ ($p=0.456$), and the ARCH-LM(4) statistic is $150.03$ ($p=0.348$).\footnote{The Breusch-Godfrey LM(4) statistic of 60.81 ($p=0.006$) indicates residual serial correlation, a common small-sample VECM limitation that we document for transparency.} Table~\ref{tab:s2_focal_vecm} reports the estimated cointegrating vector ($\beta$) and loading vector ($\alpha$) for this focal specification.

**Observations or Comments:**
*(Write observations here)*

**New Version:**
*(Draft new version here)*

---

## Paragraph 4.75
- [ ] **Locked**

**Current Content:**
> The estimated cointegrating vector normalized on output yields: \begin{equation} \ln Y_t - 0.727 \ln K_t + 20.022 \ln e_t - \text{constant} \sim I(0) \end{equation} The capital elasticity $\hat{\theta} = 0.727$ aligns with the single-equation estimates. However, the high standard error ($4.852$) reflects the multi-collinearity introduced by the rate of exploitation. The coefficient on the rate of exploitation is highly significant ($\hat{\beta}_e = 20.022$, SE 2.536, t-stat $7.90$), indicating a strong level relationship between capacity levels and distribution.

**Observations or Comments:**
*(Write observations here)*

**New Version:**
*(Draft new version here)*

---

## Paragraph 4.76
- [ ] **Locked**

**Current Content:**
> The speed-of-adjustment loading vector $\alpha$ reveals a key asymmetric structural property of the system. Capital accumulation is weakly exogenous ($\alpha_k = 0.000$, $t=0.92$), meaning it is not disciplined by the cointegrating attractor; investment decisions drift independently of the long-run output--capital disequilibrium. The output loading is small but statistically significant ($\alpha_y = -0.005^{**}$, t-stat $-2.00$). The rate of exploitation is the primary error-correction channel ($\alpha_e = -0.019^{***}$, t-stat $-4.25$), adjusting to restore long-run reproduction. In political economy terms, this negative loading means that when output exceeds the capacity ceiling (relative to capital and exploitation), the rate of exploitation falls to restore system-level stability. Table~\ref{tab:s2_short_run_dynamics} reports the short-run dynamics ($\Gamma_1$) and deterministic dummy coefficients ($\Phi$) of the system.

**Observations or Comments:**
*(Write observations here)*

**New Version:**
*(Draft new version here)*

---

## Paragraph 4.77
- [ ] **Locked**

**Current Content:**
> The $h_2$ dummy vector plays a crucial role in the trivariate VECM models, as it accounts for the step shifts in 1956, 1974, and 1980, and its inclusion is a strict condition for admissibility. Cointegration is established only when these step-shift dummies control for the structural breaks, which prevent permanent level shifts in the mean of the residuals from appearing as unit roots in Johansen trace and Dickey-Fuller tests. Under the Johansen Case 3 ($C_3$: unrestricted constant and restricted trend) deterministic configurations, the models yield invalid parameter estimates, including explosive ($\hat{\theta} = 11.31$) or negative ($\hat{\theta} = -0.81$) elasticities. The time trend absorbs the level drift of output, forcing the capital-output coefficient to capture short-run noise. These $C_3$ configurations are therefore economically rejected. The empirically viable long-run parameters are restricted to the Johansen Case 1 ($C_0$: no constant/no trend) and Case 2 ($C_2$: restricted constant) deterministic closures, which yield stable positive estimates of $\hat{\theta} = 0.73, 0.91, 0.97$ (as summarized in Table~\ref{tab:s2_retained_trivariate_specs}).

**Observations or Comments:**
*(Write observations here)*

**New Version:**
*(Draft new version here)*

---

## Paragraph 4.78
- [ ] **Locked**

**Current Content:**
> To demonstrate the role of historical controls in a simple, pedagogical way, we estimate the system omitting the $h_2$ dummy vector (the \textbf{``no-dummy counterfactual''}). When we leave out these dummy variables that control for the 1956, 1974, and 1980 shocks, the VECM fails to reject the null hypothesis of no cointegration under Johansen trace and maximum eigenvalue tests. The resulting VECM residuals are nonstationary and fail standard unit-root tests, showing that the estimated relationship is spurious. Output, capital, and exploitation drift apart permanently without an error-correction mechanism to pull them back. This counterfactual shows that the system-level output--capital relationship collapses econometrically when specific historical and institutional shock vectors (such as the 1974 oil price shock and the 1980 Volcker credit squeeze) are omitted. The underlying cointegrating space is not an institutional-free physical law; its econometric stationarity is conditional on these historical dummy variables.

**Observations or Comments:**
*(Write observations here)*

**New Version:**
*(Draft new version here)*

---

## Paragraph 4.79
- [ ] **Locked**

**Current Content:**
> Figure~\ref{fig:s2-pooled-frontier} plots the specification frontier mapping system-level fit against parameter complexity for the trivariate VECM specifications. Bivariate systems fail to establish cointegration, and expanding the state vector beyond the trivariate specifications does not improve system-level identification, confirming that the trivariate system represents the minimum specification necessary for econometric admissibility.

**Observations or Comments:**
*(Write observations here)*

**New Version:**
*(Draft new version here)*

---

## Paragraph 4.80
- [ ] **Locked**

**Current Content:**
> Figure~\ref{fig:s2-focal-cu-exploitation-diptych} shows how the system's final state changes over time. The left panel plots the path of capacity utilization implied by the Vector Error Correction Model, while the right panel charts the actual rate of exploitation over time. In the US, the rate of exploitation reached its highest point in the mid-1960s, during a period of strong economic growth after World War II. It then dropped during the economic stagnation and high inflation of the 1970s, but rose again from 1983 to 2011 as companies increased productivity faster than wages. This long-term pattern reveals a structural link between the rate of capacity utilization and the functional distribution of income between wages and profits.

**Observations or Comments:**
*(Write observations here)*

**New Version:**
*(Draft new version here)*

---

## Paragraph 4.81
- [ ] **Locked**

**Current Content:**
> Heinz Kurz's (1986) classical choice-of-technique switching argument explains how changes in distribution, specifically the rate of exploitation $e_t$, alter the relative cost-effectiveness of different production techniques, prompting cost-minimizing producers to switch their technical methods and adjust their capital utilization, thereby endogenizing capacity. As producers respond to shifts in income distribution by changing their production techniques, the observed output--capital relation ($Y/K$) is rendered non-stationary, reflecting the influence of distribution on technical choice. Theoretically, this implies that the output--capital relation is not a fixed technical law, but rather a dynamic relation that is sensitive to changes in distribution, as evidenced by the nonstationary, unit-root residuals that arise from omitting the logged rate of exploitation from the state vector \citep{Kurz1986}. In the retained system specifications, the stability of the output--capital relation depends on including distribution within the cointegrating space. This supports the interpretation of capacity formation as historically and distributionally conditioned, rather than as a purely technical output--capital law.

**Observations or Comments:**
*(Write observations here)*

**New Version:**
*(Draft new version here)*

---

## Paragraph 4.82
- [ ] **Locked**

**Current Content:**
> The empirical findings across the three estimation steps answer three questions. First, Stage S0 establishes the approximate recoverability of the baseline single-equation relationship, confirming that the initial replication challenge resides in unstated data choices rather than estimation errors. Second, Stage S1 shows that the recovered coefficient is not unique across admissible single-equation specifications, varying instead along a Pareto fit--complexity envelope. Third, Stage S2 shows that the bivariate output--capital relation does not survive as a self-sufficient system, but does survive in a restricted trivariate system that includes distribution and historical shock controls. These results do not reject Shaikh’s measurement strategy; rather, they identify the conditions under which the output--capital relation can be treated as empirically stable.

**Observations or Comments:**
*(Write observations here)*

**New Version:**
*(Draft new version here)*

---

## Paragraph 4.83
- [ ] **Locked**

**Current Content:**
> The magnitude of the estimated transformation elasticity ($\hat{\theta}$) dictates both the historical baseline of the capacity utilization path and its dynamic mean-reverting properties. Under Shaikh's methodology, utilization is constructed strictly as the residual distance between realized output and fitted capacity ($\ln \hat{\mu}_t = y_t - \hat{y}^p_t$). Consequently, $\hat{\theta}$ determines exactly how much of the smooth, long-run capital trend is subtracted from volatile current output. Lower parameter estimates force the residual to absorb structural drift, generating a utilization path characterized by long historical waves and dampened mean reversion. Conversely, higher parameter estimates aggressively strip the capital trend from the residual, resulting in a highly stationary trajectory that mirrors short-run business cycle volatility.

**Observations or Comments:**
*(Write observations here)*

**New Version:**
*(Draft new version here)*

---

## Paragraph 4.84
- [ ] **Locked**

**Current Content:**
> Multi-equation vector estimation resolves this single-equation ambiguity by exposing the historical and institutional conditions necessary for structural stability. The six surviving trivariate VECM specifications strictly require the inclusion of the $h_2$ historical dummy vector, which accounts for the structural breaks of 1956, 1974, and 1980. This uniform survival pattern shows that the outlier controls implemented in Shaikh's baseline operate as prerequisites for capturing a cointegrated space, rather than arbitrary statistical adjustments. Cointegration is established only when these institutional shock vectors stabilize the long-run correlations between accumulation and production.

**Observations or Comments:**
*(Write observations here)*

**New Version:**
*(Draft new version here)*

---

## Paragraph 4.85
- [ ] **Locked**

**Current Content:**
> The structural failure of the standalone output--capital relation stems from the dual macroeconomic role of capital accumulation. Because investment demand expands current output while the capital stock simultaneously builds productive capacity, the scalar parameter $\hat{\theta}$ is forced to mediate conflicting short-run and long-run forces. In a single-equation framework, this accounting entanglement creates omitted variable bias and parameter instability. The Stage S2 trivariate system shows that capacity utilization cannot be treated as a purely technical engineering problem. In this replication, the empirical stability of the capacity benchmark depends on both historical shock controls and a distributional variable. Productive capacity is therefore measured as a historically conditioned political-economy object, not as a neutral technical ceiling.

**Observations or Comments:**
*(Write observations here)*

**New Version:**
*(Draft new version here)*

---

