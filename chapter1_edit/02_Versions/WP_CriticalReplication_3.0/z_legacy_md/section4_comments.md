# Section 4 Editing Ledger

To lock a paragraph, check the box next to its ID (e.g., `- [x] Paragraph X.Y`).

## Paragraph 4.1
- [x] **Locked**

**Current Content:**
> This section presents a critical macroeconomic replication of Shaikh's output--capital relation to verify whether its long-run coefficient identifies a stable capacity benchmark. In Section~\ref{sec:conceptual_framework}, we established that this coefficient is not a neutral engineering multiplier; rather, it functions as a transformation elasticity ($\theta$) linking capital accumulation to capacity formation. Economically, this means that the parameter represents how accumulation changes the potential output ceiling under conditions of unbalanced growth. We test whether a single, full-sample estimation can capture this relationship across different post-war distributive regimes, or whether it averages over historically and institutionally distinct production structures. By testing the cointegrating relation directly rather than relying on a pre-fabricated utilization index, we subject the underlying classical capacity theory to a rigorous empirical test.

**Observations or Comments:**
*(Write observations here)*

**New Version:**
*(Draft new version here)*

---

## Paragraph 4.2
- [x] **Locked**

**Current Content:**
> We execute this critical investigation across three sequential stages of increasing econometric generality. In Stage S0, we reconstruct the closest empirical counterpart to Shaikh's baseline single-equation model to verify its basic numerical reproducibility. Stage S1 lifts the baseline's rigid specification choices by estimating a combinatoric grid of 500 Autoregressive Distributed Lag (ARDL) models, mapping how the estimated transformation elasticity ($\hat{\theta}$) shifts under alternative lag structures, trend configurations, and outlier controls. Finally, Stage S2 transitions the analysis from single-equation models to system-level estimations, testing whether the output--capital relation survives as a stable Vector Error Correction Model (VECM) and checking whether it requires the rate of exploitation ($e_t$) to establish system-level cointegration.

**Observations or Comments:**
*(Write observations here)*

**New Version:**
*(Draft new version here)*

---

## Paragraph 4.3
- [x] **Locked**

**Current Content:**
> Our findings show that while Shaikh's baseline coefficient is numerically reproducible, it is neither structurally unique nor stable in isolation. In the single-equation grid search, the estimated elasticity ranges from 0.65 to 0.92 depending on how we penalize model complexity, indicating that the baseline point estimate is highly sensitive to researcher choices. More importantly, the standalone output--capital relation fails system-level cointegration tests, proving that a stable long-run relationship cannot be identified in a bivariate setting. The output--capital relation achieves system stability only within a trivariate framework that includes the rate of exploitation, showing that the long-run conversion of capital to capacity is structurally conditioned by the historical distribution of income between wages and profits.

**Observations or Comments:**
*(Write observations here)*

**New Version:**
*(Draft new version here)*

---

## Paragraph 4.4
- [x] **Locked**

**Current Content:**
> We present these results sequentially across seven subsections. First, Subsection~\ref{subsec:econometric_framework_design} outlines the mathematical framework and staged design. Subsection~\ref{subsec:data_measurement} details the data construction, measurement conventions, and stylized facts. Subsection~\ref{subsec:admissibility_strategy} defines the admissibility filters and diagnostic screens. Subsections~\ref{subsec:S0_reproducibility_new}, \ref{subsec:S1_admissible_spec_new}, and \ref{subsec:S2_vecm} present the empirical results for Stages S0, S1, and S2, respectively. Finally, Subsection~\ref{subsec:cross_stage_synthesis_design_new} provides a cross-stage econometric synthesis.

**Observations or Comments:**
*(Write observations here)*

**New Version:**
*(Draft new version here)*

---

## Paragraph 4.5
- [x] **Locked**

**Current Content:**
> We formalize this progressive, multi-stage testing sequence in Table~\ref{tab:cross_stage_synthesis_design}, which outlines the design object, specification space, and diagnostic criteria for each stage. By moving from a single-point reconstruction (S0) to a combinatorial specification grid (S1), we systematically map how parameter estimates react to changes in the model's complexity. The transition to joint system estimation (S2) then tests whether these single-equation relationships survive as self-sufficient economic attractors once we allow for bidirectional feedbacks. This staged architecture allows us to separate the statistical fit of the model from the historical and institutional validity of its derived capacity path.

**Observations or Comments:**
*(Write observations here)*

**New Version:**
*(Draft new version here)*

---

## Paragraph 4.6
- [x] **Locked**

**Current Content:**
> We write the output--capital relation as an Autoregressive Distributed Lag (ARDL) model to identify the long-run transformation elasticity ($\theta$). To evaluate whether output ($y_t$) and capital ($k_t$) share a stable long-run equilibrium, we use the bounds-testing procedure developed by \citet{Pesaran2001}. Cointegration means that although output and capital drift over time as nonstationary series, they are tied together by a structural attraction force that prevents them from drifting apart indefinitely. This framework detects this cointegrating relationship regardless of whether the individual series are integrated of order zero ($I(0)$) or one ($I(1)$), eliminating the need for fragile unit-root pre-testing.

**Observations or Comments:**
*(Write observations here)*

**New Version:**
*(Draft new version here)*

---

## Paragraph 4.7
- [x] **Locked**

**Current Content:**
> We estimate this relationship using an unrestricted error correction model (UECM) derived from a general $\text{ARDL}(p, q)$ specification: \begin{equation} \Delta y_t = c_0 + c_1 t + \pi_y y_{t-1} + \pi_k k_{t-1} + \sum_{i=1}^{p-1} \psi_{y,i} \Delta y_{t-i} + \sum_{j=0}^{q-1} \psi_{k,j} \Delta k_{t-j} + \sum_{h=1}^{H} \delta_h D_{h,t} + \varepsilon_t . \label{eq:ardl_uecm} \end{equation}

**Observations or Comments:**
*(Write observations here)*

**New Version:**
*(Draft new version here)*

---

## Paragraph 4.8
- [x] **Locked**

**Current Content:**
> This unrestricted error-correction representation separates the short-run adjustment dynamics from the long-run level relationship. In equation~\eqref{eq:ardl_uecm}, $c_0$ is the constant intercept, $c_1 t$ is a deterministic linear time trend, and $\varepsilon_t$ is an independent and identically distributed error term. The differenced terms $\Delta y_{t-i}$ and $\Delta k_{t-j}$ capture short-run memory and cyclical frictions, where $p$ and $q$ represent the lag lengths of output and capital. The lagged level terms $y_{t-1}$ and $k_{t-1}$ contain the long-run cointegrating relationship. The historical impulse dummies $D_{h,t}$ act as short-run shock absorbers, preventing outlier events (like the 1974 oil shock) from distorting the underlying long-run relationship.

**Observations or Comments:**
*(Write observations here)*

**New Version:**
*(Draft new version here)*

---

## Paragraph 4.9
- [x] **Locked**

**Current Content:**
> The statistical distribution of the bounds test depends on how we restrict the constant and linear trend in the model. \citet{Pesaran2001} outline five deterministic configurations (Cases I through V) that determine how the constant $c_0$ and time trend $t$ enter the equation. These cases range from Case I (no constant, no trend) to Case V (unrestricted constant and unrestricted trend), including intermediate cases where constants or trends are restricted to the long-run cointegrating space. Since these deterministic components alter the asymptotic behavior of the nonstationary variables, each case requires a different set of critical value bounds. We treat these five configurations as specification choices that alter the statistical boundaries of our cointegration test.

**Observations or Comments:**
*(Write observations here)*

**New Version:**
*(Draft new version here)*

---

## Paragraph 4.10
- [x] **Locked**

**Current Content:**
> We use a joint Wald $F$-bounds test to evaluate the null hypothesis that no long-run relationship exists between output and capital. The null hypothesis ($H_0^F$) asserts that the coefficients on the lagged level terms are jointly zero, meaning there is no cointegration: \begin{equation} H_{0}^{F}: \pi_y=\pi_k=0, \qquad H_{a}^{F}: (\pi_y,\pi_k)\neq(0,0). \label{eq:fbounds_hypothesis} \end{equation}

**Observations or Comments:**
*(Write observations here)*

**New Version:**
*(Draft new version here)*

---

## Paragraph 4.11
- [x] **Locked**

**Current Content:**
> Under this hypothesis, $\pi_y$ and $\pi_k$ are the coefficients on the lagged levels of output and capital. If the null is true, the regression is spurious because the residuals remain nonstationary ($I(1)$), meaning we find no evidence of cointegration, rendering any derived capacity path econometrically invalid. To evaluate the Wald statistic, we use the critical bounds generated by \citet{Pesaran2001}. These bounds establish two thresholds: a lower bound assuming all variables are $I(0)$, and an upper bound assuming all variables are $I(1)$. We reject the null of no cointegration only when the computed $F$-statistic exceeds the upper bound, confirming that the output--capital relation has a stationary residual.

**Observations or Comments:**
*(Write observations here)*

**New Version:**
*(Draft new version here)*

---

## Paragraph 4.12
- [x] **Locked**

**Current Content:**
> We apply the $t$-bounds test as a secondary confirmation screen to ensure that the cointegrating relationship is stable. The Wald $F$-test can sometimes find pseudo-cointegration if only one of the lagged level variables is significant. The $t$-bounds test evaluates the null hypothesis that the coefficient on the lagged dependent variable ($\pi_y$) is zero: \begin{equation} H_{0}^{t}: \pi_y=0, \qquad H_{a}^{t}: \pi_y<0. \label{eq:tbounds_hypothesis} \end{equation}

**Observations or Comments:**
*(Write observations here)*

**New Version:**
*(Draft new version here)*

---

## Paragraph 4.13
- [x] **Locked**

**Current Content:**
> We test this against the one-sided alternative hypothesis ($\pi_y < 0$), which requires the error-correction coefficient to be negative. A negative speed-of-adjustment coefficient acts as a restoring force: when actual output drifts away from its long-run capacity path, the system adjusts by pulling output back toward the equilibrium. If $\pi_y$ is positive or zero, the system is explosive or has no memory. Given our relatively short sample period ($T \approx 65$), we use finite-sample critical bounds from \citet{NatsiopoulosTzeremes2022} rather than asymptotic tables to prevent over-stating cointegration significance.

**Observations or Comments:**
*(Write observations here)*

**New Version:**
*(Draft new version here)*

---

## Paragraph 4.14
- [x] **Locked**

**Current Content:**
> To recover the long-run transformation elasticity ($\theta$), we must distinguish the underlying levels ARDL model from its error-correction representation. We write the general levels $\text{ARDL}(p, q)$ specification as: \begin{equation} y_t = a_0 + a_1 t + \sum_{i=1}^p \alpha_i y_{t-i} + \sum_{j=0}^q \beta_j k_{t-j} + \sum_{h=1}^H \delta_h D_{h,t} + \varepsilon_t . \label{eq:ardl_levels} \end{equation} From this levels model, the long-run multiplier ($d$) is recovered as the sum of the capital stock coefficients normalized by the output lag coefficients: \begin{equation} \hat{d} = \frac{\sum_{j=0}^q \hat{\beta}_j}{1 - \sum_{i=1}^p \hat{\alpha}_i} . \label{eq:d_levels} \end{equation} This levels ratio represents the steady-state multiplier where the dynamic adjustment processes have fully settled. In his baseline estimation, Shaikh treats this parameter as a constant technical coefficient mapping capital directly to potential capacity. Under our conceptual framework, however, we interpret this long-run coefficient as a capacity transformation elasticity, $\theta$, which is historically and distributionally conditioned.\footnote{Shaikh's original exposition \citep{Shaikh2016} seldom discusses the parameter $d$ as an elasticity, treating it instead as a fixed accounting coefficient. We interpret this long-run multiplier $d$ as the empirical proxy for the capacity transformation elasticity $\theta$ under conditions of unbalanced growth. For clarity, we retain the notation $d$ when replicating Shaikh's ARDL specifications directly, and transition to $\theta$ when developing our conceptual and system VECM extensions.}

**Observations or Comments:**
*(Write observations here)*

**New Version:**
*(Draft new version here)*

---

## Paragraph 4.15
- [x] **Locked**

**Current Content:**
> We map this levels specification directly to the unrestricted error correction model (UECM) in Equation~\eqref{eq:ardl_uecm} by reparameterizing the level variables around their first-difference representations. In the UECM, the speed-of-adjustment coefficient $\pi_y$ and the level capital coefficient $\pi_k$ relate to the levels parameters by $\pi_y = -(1 - \sum_{i=1}^p \alpha_i)$ and $\pi_k = \sum_{j=0}^q \beta_j$. Thus, the long-run multiplier is recovered from the conditional UECM parameters as the ratio: \begin{equation} \hat{d} = -\frac{\pi_k}{\pi_y} . \label{eq:d_recovery} \end{equation} This UECM ratio is mathematically identical to the levels ratio in Equation~\eqref{eq:d_levels}. A common pitfall in error-correction estimations is to calculate this long-run multiplier using the short-run differenced parameters from the UECM rather than the levels parameters. We ensure that only the levels coefficients enter the long-run relation to avoid such bias, correcting the notation to represent the true long-run cointegrating levels relation.

**Observations or Comments:**
*(Write observations here)*

**New Version:**
*(Draft new version here)*

---

## Paragraph 4.16
- [x] **Locked**

**Current Content:**
> In Shaikh's procedure, this long-run multiplier anchors the fitted capacity path. Capacity utilization is then the residual deviation from the long-run cointegration vector: $\log \hat{\mu}_t = y_t - \hat{y}^p_t$. This design makes utilization dependent on the estimated coefficient. Shaikh treats the coefficient as a fitted accounting multiplier, but he does not theorize its structural role. We re-interpret the coefficient as a transformation elasticity $\hat{\theta}$ of productive capacities with respect to capital accumulation, subject to the specification grid, deterministic treatment, and admissibility gates. We evaluate this elasticity across three stages: we reconstruct the baseline result (Stage S0), open the single-equation specification space (Stage S1), and test whether the relation survives in a joint system (Stage S2). Subsection~\ref{subsec:data_measurement} details the data construction and measurement conventions required to execute these steps. An econometric limitation of this single-equation setup is that if the capital stock ($k_t$) is measured with error due to the approximations of the Perpetual Inventory Method, the estimated elasticity $\hat{\theta}$ will be biased downward. Measurement error occurs because physical capacity changes are mediated by workplace organization, labor intensity, and speedups, which standard NIPA capital stock metrics cannot capture. The replication evaluates this baseline point model while explicitly testing this parameter's stability across a broader specification grid.

**Observations or Comments:**
*(Write observations here)*

**New Version:**
*(Draft new version here)*

---

## Paragraph 4.17
- [x] **Locked**

**Current Content:**
> In Stage S0, we test the reproducibility of Shaikh's baseline results to establish a benchmark for our replication. We target his published single-equation model, fix the lag structure at the reported ARDL(2,4) configuration, and estimate the parameters using the closest recoverable corporate-sector data. We identify the variables directly from his published data tables, resolving documentation discrepancies in the original text. We estimate these baseline parameters across alternative deterministic configurations and historical impulse controls to reconstruct his point estimates, rather than to search for alternative specifications.

**Observations or Comments:**
*(Write observations here)*

**New Version:**
*(Draft new version here)*

---

## Paragraph 4.18
- [x] **Locked**

**Current Content:**
> This procedure estimates the long-run relationship, constructs the potential capacity path, and calculates capacity utilization as the residual deviation of actual output from that path. We use cointegration bounds tests to distinguish genuine long-run relations from spurious correlations generated by autoregressive filtering. Here, we encounter a technical limitation of the ARDL framework: while the $F$-bounds test applies to all five deterministic cases, the $t$-bounds test is only defined for Cases I, III, and V. Specifications under Case II or Case IV (which restrict the constants or trends to the cointegration space) cannot be screened using the $t$-bounds gate.

**Observations or Comments:**
*(Write observations here)*

**New Version:**
*(Draft new version here)*

---

## Paragraph 4.19
- [x] **Locked**

**Current Content:**
> In Stage S1, we expand the single-equation model into a combinatoric grid of 500 different specifications. By varying the lag lengths, deterministic trends, and outlier controls, we evaluate how researcher choices affect the cointegration test results and the estimated elasticity. This approach shifts our focus from a single preferred model to the entire space of possible specifications, showing how sensitive the capacity path is to modeling assumptions.

**Observations or Comments:**
*(Write observations here)*

**New Version:**
*(Draft new version here)*

---

## Paragraph 4.20
- [x] **Locked**

**Current Content:**
> We allow the output and capital lags to vary freely from 1 to 5 ($p, q \in \{1, \dots, 5\}$). We estimate each lag combination across all five deterministic cases, combined with four alternative blocks of historical dummy variables ($s_0$ through $s_3$). These dummies control for major post-war shocks: the 1956 Eisenhower recession, the 1974 oil crisis, and the 1980 Volcker monetary contraction. Permuting these options yields 500 unique models. Formally, the specification space is: \begin{equation} \mathcal{G}_{S1} = \{(p,q,c,s)\}, \label{eq:G_S1} \end{equation}

**Observations or Comments:**
*(Write observations here)*

**New Version:**
*(Draft new version here)*

---

## Paragraph 4.21
- [x] **Locked**

**Current Content:**
> In this grid $\mathcal{G}_{S1}$, each element $(p, q, c, s)$ represents a single model. The indices $p$ and $q$ set the lag orders, $c$ determines the PSS case configuration, and $s$ indicates which outlier controls are active.

**Observations or Comments:**
*(Write observations here)*

**New Version:**
*(Draft new version here)*

---

## Paragraph 4.22
- [x] **Locked**

**Current Content:**
> Admissibility screens filter out models that fail cointegration tests, but they do not identify a single correct parameter. The remaining models reveal a disciplined non-uniqueness, suggesting that a single technical production law does not exist. To organize the cointegrating models, we construct a fit-complexity envelope ($E_{S1}$) that identifies the optimal trade-off between statistical fit and parameter count: \begin{equation} E_{S1} = \{ m \in \mathcal{A}^{F}_{S1} : \nexists m' \in \mathcal{A}^{F}_{S1} \text{ with } L(m') \leq L(m) \text{ and } K(m') \leq K(m) \}, \label{eq:E_S1} \end{equation}

**Observations or Comments:**
*(Write observations here)*

**New Version:**
*(Draft new version here)*

---

## Paragraph 4.23
- [x] **Locked**

**Current Content:**
> In this setup, $L(m) = -2\log\hat{\ell}(m)$ is the model deviance (where lower values mean better fit) and $K(m)$ is the number of estimated parameters. A model lies on the envelope $E_{S1}$ only if no other cointegrating model fits the data better while using fewer parameters.

**Observations or Comments:**
*(Write observations here)*

**New Version:**
*(Draft new version here)*

---

## Paragraph 4.24
- [x] **Locked**

**Current Content:**
> We also define information-criterion neighborhoods ($\mathcal{F}^{(0.20)}_j$) to capture competitive specifications that sit slightly off the strict Pareto frontier: \begin{equation} \mathcal{F}^{(0.20)}_j = \{ m \in \mathcal{A}^{F}_{S1} : IC_j(m) \leq Q_{0.20}(IC_j \mid \mathcal{A}^{F}_{S1}) \}, \label{eq:F_j} \end{equation}

**Observations or Comments:**
*(Write observations here)*

**New Version:**
*(Draft new version here)*

---

## Paragraph 4.25
- [x] **Locked**

**Current Content:**
> Here, $j$ indexes the criteria used to evaluate the models: the Akaike Information Criterion (AIC), Bayesian Information Criterion (BIC), Hannan-Quinn (HQ), and Bozdogan's Information Complexity Index (ICOMP) along with its robust variant (RICOMP). While AIC and BIC penalize the number of parameters, ICOMP and RICOMP penalize parameter interdependence and covariance complexity. This variety of criteria helps us see how different penalty structures select different long-run elasticity estimates across the specification space.

**Observations or Comments:**
*(Write observations here)*

**New Version:**
*(Draft new version here)*

---

## Paragraph 4.26
- [x] **Locked**

**Current Content:**
> Each specification $m$ yields a distinct estimate of the transformation elasticity $\hat{\theta}(m)$, which determines the slope of the capacity path. We construct the capacity utilization series for each model as: \begin{equation} \hat{\mu}_t(m) = y_t - [\hat{a}(m) + \hat{b}(m)t + \hat{\theta}(m)k_t]. \label{eq:mu_hat_m} \end{equation}

**Observations or Comments:**
*(Write observations here)*

**New Version:**
*(Draft new version here)*

---

## Paragraph 4.27
- [x] **Locked**

**Current Content:**
> Comparing these utilization paths across the different model sets shows how modeling choices directly impact our capacity measurements. Selecting different cointegrating specifications shifts the estimated capacity ceiling, altering the calculated rate of capacity utilization.

**Observations or Comments:**
*(Write observations here)*

**New Version:**
*(Draft new version here)*

---

## Paragraph 4.28
- [x] **Locked**

**Current Content:**
> Table~\ref{tab:s1_stress_synthesis} summarizes the structure of this single-equation specification search. We report the empirical results of this grid search in Subsection~\ref{subsec:S1_admissible_spec_new}.

**Observations or Comments:**
*(Write observations here)*

**New Version:**
*(Draft new version here)*

---

## Paragraph 4.29
- [x] **Locked**

**Current Content:**
> We extend this analysis to a joint multi-equation system in Stage S2. Transitioning to a system framework allows us to test whether bivariate cointegration holds when output and capital are both treated as endogenous, and whether establishing a stable long-run relationship requires including the rate of exploitation ($e_t$).

**Observations or Comments:**
*(Write observations here)*

**New Version:**
*(Draft new version here)*

---

## Paragraph 4.30
- [x] **Locked**

**Current Content:**
> Stage S2 tests whether the output--capital relation remains stable in a multi-equation system. If output and capital are cointegrated, a simple bivariate vector $X_t = (\ln Y_t, \ln K_t)'$ should exhibit a stable cointegrating relationship under Johansen's rank tests. However, as we show in the results section, this bivariate system fails to cointegrate. We resolve this by introducing the logged rate of exploitation, $e_t = \ln(\pi_t / (1 - \pi_t))$, to form the trivariate vector $X_t = (\ln Y_t, \ln K_t, \ln e_t)'$. We estimate this trivariate system using a standard Vector Error Correction Model (VECM): \begin{equation} \label{eq:vecm_johansen} \Delta X_t = \Pi X_{t-1} + \sum_{i=1}^{p-1} \Gamma_i \Delta X_{t-i} + \Phi D_t + \varepsilon_t, \end{equation}

**Observations or Comments:**
*(Write observations here)*

**New Version:**
*(Draft new version here)*

---

## Paragraph 4.31
- [x] **Locked**

**Current Content:**
> In equation~\eqref{eq:vecm_johansen}, $\Gamma_i$ represents the short-run dynamics, $D_t$ contains deterministic components and dummies, and $\Pi$ is the long-run impact matrix. We factor this matrix as $\Pi = \alpha \beta'$, where $\beta$ contains the long-run cointegrating vectors and $\alpha$ contains the adjustment speeds. A stable cointegrating relation exists only when the matrix has a reduced rank of $r=1$, and the exploitation variable enters the cointegrating space $\beta$.

**Observations or Comments:**
*(Write observations here)*

**New Version:**
*(Draft new version here)*

---

## Paragraph 4.32
- [x] **Locked**

**Current Content:**
> We test the stability of this system by estimating a grid of VECM specifications, varying the lag structures, trend configurations, and outlier dummies. For each target rank $r$, the tried specification space is: \begin{equation} \mathcal{G}_{S2}^{(r)} = \{(p, C_{\text{det}}, s)\}, \label{eq:G_S2} \end{equation}

**Observations or Comments:**
*(Write observations here)*

**New Version:**
*(Draft new version here)*

---

## Paragraph 4.33
- [x] **Locked**

**Current Content:**
> Here, $p$ represents the VAR lag orders (from 1 to 4), $C_{\text{det}}$ indexes the four deterministic configurations, and $s$ select the outlier dummies. In this system setup, $C_0$ assumes no constant or trend; $C_1$ restricts the constant to the cointegrating space; $C_2$ includes an unrestricted constant; and $C_3$ adds a linear trend restricted to the cointegrating space. These four cases are distinct from the single-equation PSS configurations. Permuting these choices yields 48 attempted models. We exclude the restricted constant models ($C_1$) because they systematically fail to converge, leaving 36 estimated models in our final grid.

**Observations or Comments:**
*(Write observations here)*

**New Version:**
*(Draft new version here)*

---

## Paragraph 4.34
- [x] **Locked**

**Current Content:**
> We use annual US corporate sector data from 1947 to 2011 ($T = 65$), sourced from the data companion in \citet{Shaikh2016}.\footnote{Replication data and construction scripts are available at: \url{https://www.realecon.org/data}. While Shaikh specifies a common-deflator condition, he does not name the price index; we implement a GPIM-consistent price deflator to ensure reproducibility.} Capacity utilization is the residual deviation of actual output from the cointegrated output--capital path. The level, timing, and persistence of our capacity path depend on these measurement choices. Table~\ref{tab:variables_replication} summarizes the variables, their construction, and the measurement constraints that structure this replication.

**Observations or Comments:**
*(Write observations here)*

**New Version:**
*(Draft new version here)*

---

## Paragraph 4.35
- [x] **Locked**

**Current Content:**
> To reconstruct the gross capital stock, we use the Generalized Perpetual Inventory Method (GPIM) following \citet{Shaikh2016}. This accounting framework calculates capital stock from nominal gross investment flows, annual depreciation rates, and an implicit deflator built from gross capital formation accounts. The recursion accumulates current-cost capital as: \begin{equation} K_t = IG_t + z_t^* \cdot K_{t-1}, \qquad z_t^* \equiv (1 - z_t) \frac{p^K_t}{p^K_{t-1}}, \end{equation}

**Observations or Comments:**
*(Write observations here)*

**New Version:**
*(Draft new version here)*

---

## Paragraph 4.36
- [x] **Locked**

**Current Content:**
> In this recursion, $IG_t$ is nominal gross investment, $z_t$ is the annual depreciation rate, and $z_t^*$ reflates surviving capital to current replacement cost. We follow Shaikh's three specific adjustments to construct this series: we replace the BEA 2011 infinite-lives assumption with BEA 1993 service lives, anchor the initial values to 1925 benchmarks, and rescale the historical stock over 1925--1947 using the IRS corporate book-value index to account for scrapping during the Great Depression \citep[Appendix~6.7]{Shaikh2016}. Our constructed series closely tracks the BEA official net stock with a 99.60\% average ratio over 1947--2005, confirming that differences in levels reflect these methodological choices rather than measurement error. Appendix~\ref{subsec:app_gpim} contains the full recursion inputs and depreciation rates.

**Observations or Comments:**
*(Write observations here)*

**New Version:**
*(Draft new version here)*

---

## Paragraph 4.37
- [x] **Locked**

**Current Content:**
> We deflate both output and capital by the $pKN$ price index (2005=100) to maintain stock-flow consistency. Standard BEA releases use quality-adjusted chain weights that alter the measured volume of investment across generations of capital, which breaks the physical accounting of capital accumulation. The $pKN$ index avoids these quality-adjustment artifacts, ensuring that our output--capital relation reflects real productive capacity rather than statistical adjustments \citep[Appendix~6.6]{Shaikh2016}. This approach satisfies the common-deflator condition and isolates real capacity dynamics. We detail this deflation rationale and compare it to quality-adjusted deflators in Appendix~\ref{subsec:app_deflator}.

**Observations or Comments:**
*(Write observations here)*

**New Version:**
*(Draft new version here)*

---

## Paragraph 4.38
- [x] **Locked**

**Current Content:**
> We adjust corporate gross value added to correct for imputed financial intermediation services (FISIM) by subtracting net monetary interest paid and adding back imputed net interest adjustments from NIPA Table 7.11. We provide the algebraic derivation in Appendix~\ref{subsec:app_impint}. We also include year dummies ($D_{1956}$, $D_{1974}$, $D_{1980}$) as shock absorbers to control for large historical breaks: the 1956 Eisenhower recession, the 1974 oil crisis, and the 1980 Volcker monetary contraction. These dummies prevent temporary shocks from distorting our long-run elasticity estimates. Since our sample size ($T = 65$) is relatively small, relying on asymptotic critical values could bias our cointegration tests. We address this limitation by computing finite-sample bounds calibrated to our exact sample length ($T=65$) using stochastic simulations \citep{NatsiopoulosTzeremes2022}.

**Observations or Comments:**
*(Write observations here)*

**New Version:**
*(Draft new version here)*

---

## Paragraph 4.39
- [x] **Locked**

**Current Content:**
> These measurement choices are central to our empirical strategy. We use Shaikh's GPIM-adjusted gross capital stock because our goal is to measure physical capacity in operation rather than the financial value of assets. While net capital stock measures are appropriate for calculating profit rates and asset valuation, gross capital stock closer matches the physical ability of capital to produce output.\footnote{This distinction is critical: financial valuation dominates profit-rate calculations, but capacity benchmarks require a measure of physical capital in use.} By using gross capital stock, we ensure that the estimated capacity benchmark is not distorted by accounting depreciation rules or market asset revaluations, which make net capital stock growth rates more volatile than physical capacity changes. The specific recursion parameters and service-lives adjustments used to construct this gross stock are detailed in Appendix~\ref{subsec:app_gpim}. Deflating both output and capital with the same price index further ensures that our estimates reflect real productive capacity rather than shifts in relative prices.

**Observations or Comments:**
*(Write observations here)*

**New Version:**
*(Draft new version here)*

---

## Paragraph 4.40
- [x] **Locked**

**Current Content:**
> Before running parametric regressions, the raw post-war US data show a clear macroeconomic pattern. Between 1947 and 2011, the real corporate gross capital stock grew at an average annual rate of 4.1\%, while real output expanded at 3.0\%, and employment grew at only 1.3\%. This gap shows that capital accumulated faster than output, causing a secular decline in the output--capital ratio. This pattern is not unique to the United States. It mirrors the broader post-war experience of advanced OECD economies, where capital deepening did not yield proportional increases in output over the long run. Cross-country empirical work on Marx-biased technical change—defined by a rising capital-labor ratio ($K/L$) and a falling capital productivity ($Y/K$)—confirms that this pattern is the dominant trend across advanced capitalist economies \citep{Marquetti2003, Basu2010}. Using the Extended Penn World Tables, these studies demonstrate that for Western Europe, Southern Europe, Japan, and Oceania, labor productivity rises primarily through mechanization and capital-using, labor-saving technical change, which systematically depresses the output--capital ratio. This non-causal, descriptive commonality suggests that a fixed, technical relationship between capital and productive capacity is unlikely to hold. Instead, the conversion of capital to capacity appears to be a historically conditioned, distribution-sensitive process.

**Observations or Comments:**
- **Advisor Feedback:** "I encourage you to emulate... testing the ideas with some casual, non-econometric observations about the course of GDP, employment, and capital stock growth."
- **Action:** Expand this paragraph to explicitly describe the raw, visible divergence between steady capital accumulation and volatile output/employment _before_ introducing the econometrics. _(Note: Please verify the exact growth rates against your raw data to clear the TODO)._
- **NOTE**: The current "new version is a proposal, but should include verified data using scripts that manage the data set that was used for the estimates of the repo"

**New Version:**
*(Draft new version here)*

---

## Paragraph 4.41
- [x] **Locked**

**Current Content:**
> We plot these post-war trends in Figures \ref{fig:main_log_levels}, \ref{fig:main_output_capital_ratio}, and \ref{fig:main_growth_rates}. While output and capital grow together over the long run (Figure \ref{fig:main_log_levels}), their ratio is subject to long historical waves rather than remaining constant (Figure \ref{fig:main_output_capital_ratio}). As shown in Figure \ref{fig:main_growth_rates}, output growth exhibits much higher volatility than capital accumulation. Economically, this lower volatility of capital stock growth is a standard macroeconomic stylized fact, but it is further pronounced here because we use gross capital stock (capital in operation) rather than net capital stock. Net capital stock growth rates are inherently more volatile because they incorporate short-run changes in financial book value, market revaluations, and accelerated accounting depreciation. In contrast, our GPIM-constructed gross capital stock remains insulated from these valuation shocks, reflecting the smoother physical survival of productive assets. Because capacity is a physical ceiling representing what capital can actually produce in use, gross capital stock is the theoretically correct anchor, whereas net capital stock measures the depreciated financial value of assets. Any estimated capacity utilization path must be consistent with these descriptive patterns; the parametric cointegration tests we run below must explain these raw historical movements rather than contradict them.

**Observations or Comments:**
- **Advisor Feedback:** "The cointegration econometric portions should be explained more and simplified. What is admissibility? What is at stake? Focus more on the basics of cointegration."
- **Action:** Merge and simplify. Use the "invisible rope" analogy conceptually. Clearly state that "admissibility" just means the model passes the basic test of having a stable long-run relationship and yielding economically sensible results (e.g., utilization between 0% and 100%).

**New Version:**
*(Draft new version here)*

---

## Paragraph 4.42
- [x] **Locked**

**Current Content:**
> Having established the raw US corporate sector trends, we now define the formal admissibility strategy used to screen our specifications. Admissibility serves as our gatekeeping diagnostic, ensuring that any capacity model we analyze represents a genuine long-run attractor rather than a spurious correlation. If output and capital fail to cointegrate, the residuals remain nonstationary, meaning the model merely fits noise and the derived capacity utilization series is a statistical artifact. We apply this filter sequentially: the single-equation models in Stage S1 must pass the Wald F-bounds test and the t-bounds error-correction screen, while the multi-equation VECMs in Stage S2 must satisfy cointegration rank, dynamic stability, and residual diagnostics.

**Observations or Comments:**
*(Write observations here)*

**New Version:**
*(Draft new version here)*

---

## Paragraph 4.43
- [x] **Locked**

**Current Content:**
> Our first screen uses the joint $F$-bounds test to filter out specifications that fail to show a long-run relationship. A model is $F$-admissible if its Wald statistic rejects the null hypothesis of no cointegration at the 10\% significance level. Formally, we define the $F$-admissible set $\mathcal{A}^{F}_{S1}$ as: \begin{equation} \mathcal{A}^{F}_{S1} = \{ m \in \mathcal{G}_{S1} : p_F(m) \leq 0.10 \}, \label{eq:A_F_S1} \end{equation}

**Observations or Comments:**
*(Write observations here)*

**New Version:**
*(Draft new version here)*

---

## Paragraph 4.44
- [x] **Locked**

**Current Content:**
> In this definition, $p_F(m)$ is the $p$-value of the Wald bounds test for model $m$, measuring the probability of the null hypothesis of no long-run relationship. If this probability is 10\% or less, the specification enters our admissible pool. We discard any model that yields a Wald statistic below the lower critical bound or within the inconclusive interior band.

**Observations or Comments:**
*(Write observations here)*

**New Version:**
*(Draft new version here)*

---

## Paragraph 4.45
- [x] **Locked**

**Current Content:**
> The secondary screen uses the $t$-bounds test to verify error-correction stability. Because the $t$-bounds statistic is only defined for deterministic Cases I, III, and V, we allow specifications using Cases II and IV to bypass this test without penalty. The $t$-admissible set $\mathcal{T}_{S1}$ is: \begin{equation} \mathcal{T}_{S1} = \{ m \in \mathcal{A}^{F}_{S1} : p_t(m) \leq 0.10 \text{ if defined} \}, \label{eq:T_S1} \end{equation}

**Observations or Comments:**
*(Write observations here)*

**New Version:**
*(Draft new version here)*

---

## Paragraph 4.46
- [x] **Locked**

**Current Content:**
> Here, $p_t(m)$ is the $p$-value for the one-sided $t$-test on the error-correction coefficient $\pi_y$. A significant negative coefficient confirms that output adjusts back toward the long-run capacity ceiling after a shock, rather than drifting away permanently. To identify specifications that pass both the Wald and error-correction tests at the stricter 5\% level, we define the Strong Cointegration Space $\mathcal{C}_{S1}$ as: \begin{equation} \mathcal{C}_{S1} = \{ m \in \mathcal{T}_{S1} : p_F(m) \leq 0.05 \text{ and } p_t(m) \leq 0.05 \}, \label{eq:C_S1} \end{equation}

**Observations or Comments:**
*(Write observations here)*

**New Version:**
*(Draft new version here)*

---

## Paragraph 4.47
- [x] **Locked**

**Current Content:**
> The joint condition $p_F(m) \leq 0.05$ and $p_t(m) \leq 0.05$ requires both the level relationship and the speed-of-adjustment to be highly significant. To illustrate what is at stake in these screens, we run a "no-dummy" counterfactual specification where we omit the historical shock controls ($D_{1956}$, $D_{1974}$, $D_{1980}$). Omitting these dummies causes the residuals to remain nonstationary ($I(1)$) across all lag profiles, failing the cointegration bounds tests. This counterfactual proves that without controlling for major historical breaks, the output--capital relation appears spurious, demonstrating why these admissibility gates are necessary to filter out statistical artifacts.

**Observations or Comments:**
*(Write observations here)*

**New Version:**
*(Draft new version here)*

---

## Paragraph 4.48
- [x] **Locked**

**Current Content:**
> In Stage S2, we evaluate the surviving models through a triple-gate system to ensure the estimates represent a stable multi-equation attractor rather than a spurious correlation. First, the Cointegration Rank Gate requires the Johansen Trace test to confirm a single cointegrating vector ($r=1$) at the 5\% level, showing that the variables share a common long-run path. Second, the Dynamic Stability Gate requires all eigenvalues of the VECM companion matrix to lie strictly inside the unit circle (excluding the unit roots of the common trends), filtering out explosive models where temporary shocks cause output to diverge infinitely. Third, the Residual Diagnostic Gate requires the model residuals to pass tests for serial correlation and heteroscedasticity at the 5\% level, ensuring our statistical inference is unbiased. In the trivariate family, the rank condition $r=1$ checks whether output and capital cointegrate once we include income distribution. We rank the surviving VECMs using their log-likelihood values to identify the best-fitting systems.

**Observations or Comments:**
*(Write observations here)*

**New Version:**
*(Draft new version here)*

---

## Paragraph 4.49
- [x] **Locked**

**Current Content:**
> In Stage S0, we evaluate the reproducibility of Shaikh's baseline results to reconcile the discrepancy between his published multiplier of 0.66 and our reconstructed estimate of 0.72. We interpret this long-run output--capital coefficient as the capacity transformation elasticity $\theta$. While Shaikh treats this parameter as a simple accounting multiplier, we view it as a behavioral parameter representing how capital accumulation translates into potential output capacity. Using the variables and deflators recovered from the national accounts, we reconstruct the capacity path from the closest reproducible single-equation model.

**Observations or Comments:**
*(Write observations here)*

**New Version:**
*(Draft new version here)*

---

## Paragraph 4.50
- [x] **Locked**

**Current Content:**
> This divergence between the published 0.66 and our reconstructed 0.72 is our first major finding. This gap is not a calculation error; it arises from undocumented choices in the original data construction. Reconstructing his benchmark required tracing the exact price deflators and data vintages through archive spreadsheets, where alternative deflator selections shift the coefficient. This shows that forensic replication is an active econometric reconstruction rather than a passive mirror. The closest reconstruction yields an elasticity of $\hat{\theta}=0.72$ from an ARDL(2,4) specification, which matches the model selected by the Bayesian Information Criterion (BIC). However, this ARDL(2,4) model yields an $F$-bounds statistic of 3.349, which barely clears the 10\% significance threshold ($p=0.099$). To address this cointegration fragility, we select the AIC-chosen ARDL(4,3) specification as our focal model. This model yields a more stable estimate of $\hat{\theta}=0.75$ and cointegrates at the 5\% level ($F=5.250$, $p=0.023$). We report the parameters for both models in Table~\ref{tab:s0_bounds_alpha10}.

**Observations or Comments:**
*(Write observations here)*

**New Version:**
*(Draft new version here)*

---

## Paragraph 4.51
- [x] **Locked**

**Current Content:**
> We report the bounds test statistics and finite-sample critical values for both specifications in Table~\ref{tab:s0_bounds_alpha10}. By using stochastically simulated finite-sample distributions rather than asymptotic tables, we ensure that our cointegration thresholds are calibrated to our sample size. In the faithful ARDL(2,4) reconstruction, the $F$-bounds statistic of 3.349 barely clears the 10\% critical value threshold of 3.333 ($p=0.099$). In contrast, our focal ARDL(4,3) model yields a highly significant $F$-bounds statistic of 5.250 ($p=0.023$) and a $t$-bounds statistic of $-3.125$ ($p=0.015$), confirming that the relationship cointegrates robustly.

**Observations or Comments:**
*(Write observations here)*

**New Version:**
*(Draft new version here)*

---

## Paragraph 4.52
- [x] **Locked**

**Current Content:**
> The error-correction estimates for the focal ARDL(4,3) model show a slow adjustment process back to the capacity path. The speed of adjustment coefficient $\hat{\pi}_y$ is $-0.127$ (SE 0.038, $t = -3.34$, $p < 0.01$), meaning the economy corrects only 12.7\% of its deviation from the capacity ceiling each year. The negative coefficients on our historical dummies ($D_{1956}$, $D_{1974}$, $D_{1980}$) are all statistically significant, capturing permanent step-shifts in capital productivity. These shifts correspond to major institutional disruptions: the 1956 Eisenhower defense cuts, the 1974 OPEC oil crisis, and the 1980 Volcker monetary contraction.

**Observations or Comments:**
*(Write observations here)*

**New Version:**
*(Draft new version here)*

---

## Paragraph 4.53
- [x] **Locked**

**Current Content:**
> A small change in the estimated transformation elasticity $\theta$ from 0.72 to 0.75 alters the constructed capacity utilization series by up to 5 percentage points. This sensitivity occurs because the elasticity acts as the exponent of the capital stock in our capacity function, so minor changes in the parameter shift the entire capacity ceiling. This amplification shows why point-estimate replication is insufficient: small differences in specification translate into large differences in historical interpretation. We illustrate this sensitivity in Figure~\ref{fig:s0-cu-fan-diagnostic}, which plots the capacity utilization paths generated by these two models, alongside Shaikh's published series and the Federal Reserve Board (FRB) manufacturing index. The gap between the reconstructed ARDL(2,4) path ($\hat{\theta}=0.72$) and the ARDL(4,3) focal path ($\hat{\theta}=0.75$) highlights how minor differences in lag structures shift the utilization series, showing that single-equation capacity paths are fragile benchmarks for policy analysis.

**Observations or Comments:**
*(Write observations here)*

**New Version:**
*(Draft new version here)*

---

## Paragraph 4.54
- [x] **Locked**

**Current Content:**
> Stage S0 confirms that we can numerically reproduce a capacity path similar to Shaikh's. However, recovering a single point estimate does not guarantee that the parameter is unique or stable across other specifications. To test this parameter's sensitivity, we transition to Stage S1 and estimate a broader grid of single-equation models.

**Observations or Comments:**
*(Write observations here)*

**New Version:**
*(Draft new version here)*

---

## Paragraph 4.55
- [x] **Locked**

**Current Content:**
> In Stage S1, we estimate a 500-model ARDL grid to evaluate whether the baseline output--capital coefficient remains stable when we vary modeling choices. Out of the 500 estimated specifications, 102 models pass the primary cointegration bounds test at the 10\% significance level. Tightening the significance threshold to 5\% reduces the admissible pool to 62 models, and only 13 survive at the 1\% level (Table~\ref{tab:s1_shrinking_space_counts}). Two patterns emerge from this admissible set. First, cointegration is concentrated in no-trend configurations: PSS Cases I, II, and III (which exclude a linear time trend) account for 90.2\% of the cointegrating models, while trend-containing Cases IV and V account for only 9.8\%. Second, cointegration depends heavily on historical controls. Over 92\% of the cointegrating models require at least one structural dummy variable ($D_{1956}$, $D_{1974}$, or $D_{1980}$) to pass the bounds test, showing that the long-run relation is unstable without controls for historical breaks.

**Observations or Comments:**
*(Write observations here)*

**New Version:**
*(Draft new version here)*

---

## Paragraph 4.56
- [x] **Locked**

**Current Content:**
> To illustrate these results, we compare two focal models that represent the opposite edges of our specification space. The first is the model selected by the standard AIC, BIC, HQ, and ICOMP criteria: an ARDL(3,3) specification under PSS Case I (no constant, no trend) with the 1974 dummy, yielding a high elasticity estimate of $\hat{\theta} = 0.92$ (SE 0.04). The second is the model selected by the robust RICOMP criterion: a parsimonious ARDL(1,2) specification under PSS Case II (restricted constant) with no dummies, yielding a much lower elasticity estimate of $\hat{\theta} = 0.65$ (SE 0.07). We report the parameters and diagnostics for these two models in Table~\ref{tab:s1_focal_parameters}.

**Observations or Comments:**
*(Write observations here)*

**New Version:**
*(Draft new version here)*

---

## Paragraph 4.57
- [x] **Locked**

**Current Content:**
> We visualize this screening process in Figure~\ref{fig:s1-shrinking-space-bounds-layers}. Panel A maps all 500 specifications across the fit-complexity space, color-coded by their cointegration status. Panel B tracks the number of surviving specifications at each diagnostic layer. This sequence reinforces the methodological rule that we must screen models for cointegration before comparing their fit or complexity.

**Observations or Comments:**
*(Write observations here)*

**New Version:**
*(Draft new version here)*

---

## Paragraph 4.58
- [x] **Locked**

**Current Content:**
> Within the cointegrating set, we construct a fit-complexity envelope ($E_{S1}$) containing 17 optimal specifications. This envelope represents the Pareto frontier where we cannot improve a model's fit without adding parameters, and we cannot simplify it without worsening its fit. The envelope serves as a geometric summary of the best-performing single-equation alternatives rather than a single preferred model.

**Observations or Comments:**
*(Write observations here)*

**New Version:**
*(Draft new version here)*

---

## Paragraph 4.59
- [x] **Locked**

**Current Content:**
> The heavy reliance on dummy variables matches the historical shocks of the post-war US economy. The shock years mark major disruptions: the 1956 Eisenhower recession (following defense cuts after the Korean War), the 1974 OPEC oil embargo (inducing stagflation), and the 1980 Volcker interest rate shock (triggering a credit crunch). Bivariate models that omit these dummy variables yield nonstationary residuals because these crises act as permanent shifts in the output--capital relation. Restoring a stationary error term requires these step-shift dummies to control for the structural drops in capital productivity. Specifically, the negative dummy coefficients capture the permanent dampening of capital productivity ($Y/K$) caused by these crises: the post-Korean War manufacturing slowdown in 1956, the OPEC price-profit squeeze forcing capacity to idle in 1974, and the Volcker shock pushing interest rates to 20\% and permanently lowering capacity utilization in 1980.

**Observations or Comments:**
*(Write observations here)*

**New Version:**
*(Draft new version here)*

---

## Paragraph 4.60
- [x] **Locked**

**Current Content:**
> We define information-criterion neighborhoods ($\mathcal{F}^{(0.20)}_j$) to organize the cointegrating specifications. For each criterion, the neighborhood collects the top 20\% of cointegrating models, resulting in a union of 36 unique specifications. Table~\ref{tab:s1_ic_neighborhood_summary} reports the parameter ranges across these neighborhoods, illustrating how different model-selection criteria organize the specification space.

**Observations or Comments:**
*(Write observations here)*

**New Version:**
*(Draft new version here)*

---

## Paragraph 4.61
- [x] **Locked**

**Current Content:**
> Figure~\ref{fig:s1-crossed-frontier-ic-neighborhoods} maps these criterion neighborhoods against the fit-complexity envelope. The solid line represents the Pareto frontier ($E_{S1}$), while the shaded areas show the neighborhoods for each criterion. This map highlights the spatial divergence between the parsimonious models selected by RICOMP and the more complex models selected by AIC and BIC.

**Observations or Comments:**
*(Write observations here)*

**New Version:**
*(Draft new version here)*

---

## Paragraph 4.62
- [x] **Locked**

**Current Content:**
> This criteria divergence reveals that different information-theoretic penalties locate very different regions of the specification space. AIC and BIC penalize the number of parameters, selecting the complex ARDL(3,3) model with $\hat{\theta}=0.92$. In contrast, ICOMP and RICOMP penalize parameter interdependence and covariance complexity, selecting the parsimonious ARDL(1,2) model with $\hat{\theta}=0.65$. This parameter variation has significant theoretical stakes. While no-trend configurations (PSS Cases I, II, and III) yield stable elasticities below unity ($\hat{\theta} \in [0.65, 0.95]$) that support the overaccumulation hypothesis, trend-containing configurations (Cases IV and V) yield elasticities averaging 1.36 and reaching up to 2.20. An elasticity $\theta > 1$ implies that productive capacity expands faster than capital accumulation in the long run, violating basic physical constraints. We discard these trend-containing models not because they fail statistical bounds tests, but because they imply implausible long-run capacity dynamics.

**Observations or Comments:**
*(Write observations here)*

**New Version:**
*(Draft new version here)*

---

## Paragraph 4.63
- [x] **Locked**

**Current Content:**
> Figure~\ref{fig:s1-cu-fan-ic-neighborhoods} plots the utilization paths generated by these different cointegrating models. The shaded fan shows the variance of constructed capacity utilization, while the divergent paths of the AIC and RICOMP winners highlight how model selection choices mechanically alter our historical interpretation of capacity realization.

**Observations or Comments:**
*(Write observations here)*

**New Version:**
*(Draft new version here)*

---

## Paragraph 4.64
- [x] **Locked**

**Current Content:**
> To illustrate the physical stakes of these estimates, we run a counterfactual model imposing the balanced-growth constraint ($\theta = 1.0$), forcing capacity to grow in lockstep with capital. Under this constraint, the constructed capacity utilization series drifts to economically absurd levels, falling continuously to under 35\% for decades and exceeding 105\% during cyclical peaks. A corporate sector cannot operate at 35\% capacity for thirty years without widespread bankruptcy, nor can it operate above 100\% capacity indefinitely. This physical absurdity shows that the balanced-growth assumption is incompatible with the post-war US historical experience, confirming that we must estimate the elasticity $\theta$ freely to obtain a viable capacity utilization series.

**Observations or Comments:**
*(Write observations here)*

**New Version:**
*(Draft new version here)*

---

## Paragraph 4.65
- [x] **Locked**

**Current Content:**
> Stage S1 shows that while many single-equation specifications pass cointegration tests, they yield very different estimates of the transformation elasticity ($\hat{\theta}$). Because these models do not converge to a single parameter, any capacity path derived from a single-equation model remains fragile. In Subsection~\ref{subsec:S2_vecm}, we address this limitation by testing whether the output--capital relation survives in a joint multi-equation VECM system, and whether stability requires us to include the rate of exploitation.

**Observations or Comments:**
*(Write observations here)*

**New Version:**
*(Draft new version here)*

---

## Paragraph 4.66
- [x] **Locked**

**Current Content:**
> In Stage S2, we transition to a system-level Vector Error Correction Model (VECM) to evaluate the joint dynamics of output and capital. We first estimate a bivariate system using the state vector $X_t = (\ln Y_t, \ln K_t)'$. However, this bivariate relation fails to cointegrate across all lag profiles, trend configurations, and dummy structures. The residuals remain nonstationary ($I(1)$), proving that the long-run relation between output and capital is spurious when estimated in isolation.

**Observations or Comments:**
*(Write observations here)*

**New Version:**
*(Draft new version here)*

---

## Paragraph 4.67
- [x] **Locked**

**Current Content:**
> To resolve this system-level instability, we expand the state vector to a trivariate system $X_t = (\ln Y_t, \ln K_t, \ln e_t)'$, where $e_t = \pi_t / (1 - \pi_t)$ is the rate of exploitation, measured as the corporate profit-share-to-wage-share ratio. By including this distribution variable, we account for Sraffa-style choices of technique, where changes in the distribution of income alter how firms organize production and utilize their capital stock \citep{Kurz1986}. We screen the trivariate specifications using our triple-gate validation system (Johansen rank confirmation, companion matrix stability, and residual diagnostics) to filter out unstable VAR processes. To ground these statistics in institutional reality, we trace how workplace dynamics alter the conversion of capital to output. The rate of exploitation ($e_t$) is not an abstract accounting ratio; it proxies the balance of class power that dictates shop-floor discipline. When labor is strong and wages rise, as during the post-war Golden Age, firms respond by substituting labor with machinery, which increases the capital stock. However, they may also deliberately idle capacity to protect profit margins, lowering the conversion of capital to output. Conversely, during the neoliberal era, weakened labor unions, "just-in-time" inventory speedups, and increased work intensity allowed firms to extract more output from the same physical capital stock without building new factories. The statistical necessity of including the exploitation rate in our cointegrating vector reflects this reality: the conversion of capital to capacity is actively moderated by class struggle and the organizational choices of firms.

**Observations or Comments:**
*(Write observations here)*

**New Version:**
*(Draft new version here)*

---

## Paragraph 4.68
- [x] **Locked**

**Current Content:**
> We summarize these system-level outcomes in Table~\ref{tab:s2_admissibility_outcomes}. All 36 bivariate specifications fail to cointegrate. In contrast, the trivariate family yields six admissible models when we include the rate of exploitation and our historical dummy variables. These results prove that the output--capital relation achieves system stability only when we account for income distribution.

**Observations or Comments:**
*(Write observations here)*

**New Version:**
*(Draft new version here)*

---

## Paragraph 4.69
- [x] **Locked**

**Current Content:**
> To ground the VECM results, we select the VAR(2) specification under Johansen Case 2 ($C_2$: restricted constant), $h_2$ dummies, and rank $r=1$ as our focal model. The model passes all three admissibility gates. We verify cointegration rank using the Johansen Trace test: we reject the null hypothesis of no cointegration ($r=0$) at the 5\% level (Trace statistic $32.28 > 31.52$), and we fail to reject the null of a single cointegrating vector ($r \leq 1$) (Trace statistic $10.68 < 17.95$). We confirm dynamic stability through the VECM companion matrix eigenvalues: the moduli are $1.0, 1.0, 0.82, 0.52, 0.52, 0.49$, all strictly bounded by the unit circle (except the two unit roots). Residual diagnostics verify that the system is free from residual pathology: the Portmanteau(12) statistic is $100.70$ ($p=0.275$), the Jarque-Bera statistic is $5.72$ ($p=0.456$), and the ARCH-LM(4) statistic is $150.03$ ($p=0.348$).\footnote{The Breusch-Godfrey LM(4) statistic of 60.81 ($p=0.006$) indicates residual serial correlation, a common small-sample VECM limitation that we document for transparency.} We report the estimated cointegrating vector ($\beta$) and loading vector ($\alpha$) in the following paragraphs.

**Observations or Comments:**
*(Write observations here)*

**New Version:**
*(Draft new version here)*

---

## Paragraph 4.70
- [x] **Locked**

**Current Content:**
> Normalizing the cointegrating vector on output yields: \begin{equation} \ln Y_t - 0.727 \ln K_t + 20.022 \ln e_t - c_0 \sim I(0) \label{eq:s2_cointegrating_vector} \end{equation} The estimated capital elasticity $\hat{\theta} = 0.727$ matches our single-equation results. The large standard error ($4.852$) reflects the multicollinearity between the capital stock and the rate of exploitation over the post-war period. The coefficient on the rate of exploitation is highly significant ($\hat{\beta}_e = 20.022$, SE 2.536, $t = 7.90$), showing a strong level relationship between productive capacity and income distribution.

**Observations or Comments:**
**ACTION:** Replace current content. Fixes a broken LaTeX tag and cutoff sentence at the end of the paragraph.

**New Version:**
*(Draft new version here)*

---

## Paragraph 4.71
- [x] **Locked**

**Current Content:**
> The adjustment speeds ($\alpha$) show a structural asymmetry in the system. Capital accumulation is weakly exogenous ($\alpha_k = 0.000$, $t = 0.92$), meaning that investment decisions do not respond to long-run deviations from the output--capital relation; instead, investment drifts independently of the long-run equilibrium. The output equation adjusts slowly but significantly ($\alpha_y = -0.005$, $t = -2.00$). The primary channel of error correction is the rate of exploitation ($\alpha_e = -0.019$, $t = -4.25$). Economically, this means that when output exceeds the capacity ceiling (relative to capital and exploitation), the rate of exploitation falls to restore system stability. This finding of weak exogeneity in capital accumulation ($\alpha_k = 0.000$) provides empirical support for the Sraffian position in the classical-heterodox debate. By showing that investment does not adjust to error-correction signals of capacity utilization disequilibrium, the data reject the Neo-Kaleckian view of investment adapting endogenously to demand-induced utilization gaps. However, because our long-run coefficient represents a non-unitary transformation elasticity ($\hat{\theta} = 0.727 < 1.0$), this Sraffian exogeneity is accompanied by structural overaccumulation. Under this interpretation, the secular instability of unbalanced growth and the exogeneity of capital accumulation act as counteracting forces that may cancel each other out in the long run. This potential canceling obscures the resolution of the debate between Sraffian and Neo-Kaleckian models, a result that is invisible when working under a balanced-growth baseline with a fixed output--capital ratio. We report the short-run dynamics ($\Gamma_1$) and deterministic dummy coefficients ($\Phi$) in Table~\ref{tab:s2_short_run_dynamics}.

**Observations or Comments:**
*(Write observations here)*

**New Version:**
*(Draft new version here)*

---

## Paragraph 4.72
- [x] **Locked**

**Current Content:**
> The historical dummy variables are essential for establishing system-level cointegration. Cointegration holds only when we include the step-shift dummies to control for structural breaks, preventing permanent shifts in the mean of the residuals from appearing as unit roots. Under the trend-containing Johansen Case 3 ($C_3$) configurations, the models yield invalid parameter estimates, including negative ($\hat{\theta} = -0.81$) or explosive ($\hat{\theta} = 11.31$) elasticities. In these configurations, the linear trend absorbs the long-run growth of output, forcing the capital coefficient to fit short-run cyclical noise. We therefore reject these trend-containing models. The economically viable models are restricted to no-trend Cases $C_0$ and $C_2$, which yield stable, positive elasticity estimates ranging from 0.73 to 0.97 (Table~\ref{tab:s2_retained_trivariate_specs}).

**Observations or Comments:**
*(Write observations here)*

**New Version:**
*(Draft new version here)*

---

## Paragraph 4.73
- [x] **Locked**

**Current Content:**
> To illustrate the role of historical controls, we run a "no-dummy" counterfactual where we omit the dummy variables. When we leave out these shock controls, the VECM fails to reject the null hypothesis of no cointegration under both Johansen trace and maximum eigenvalue tests. The residuals remain nonstationary ($I(1)$), proving that the estimated relationship is spurious. Output, capital, and exploitation drift apart permanently without a restoring force. This counterfactual demonstrates that the output--capital relation is not an institution-free physical law; its stability depends on controlling for major post-war shocks like the 1974 oil crisis and the 1980 Volcker credit contraction.

**Observations or Comments:**
**ACTION:** Promoted new paragraph.
**RATIONALE:** Bridges the statistical VECM results (the rate of exploitation $e_t$) with concrete UMass Amherst choice-of-technique and workplace labor-discipline dynamics.

**New Version:**
*(Draft new version here)*

---

## Paragraph 4.74
- [x] **Locked**

**Current Content:**
> We plot the system-level fit-complexity frontier in Figure~\ref{fig:s2-pooled-frontier}. Bivariate systems fail to cointegrate, and adding variables beyond the rate of exploitation does not improve system-level identification. This confirms that the trivariate system is the minimum specification necessary for econometric admissibility.

**Observations or Comments:**
*(Write observations here)*

**New Version:**
*(Draft new version here)*

---

## Paragraph 4.75
- [x] **Locked**

**Current Content:**
> Figure~\ref{fig:s2-focal-cu-exploitation-diptych} plots the constructed rate of capacity utilization alongside the rate of exploitation. In the United States, the rate of exploitation peaked in the mid-1960s, declined during the stagflation of the 1970s, and rose steadily from 1983 to 2011 as wage growth lagged behind productivity. This trajectory reveals a structural link between capacity utilization and the functional distribution of income, showing that the long-run realization of capacity is conditioned by class struggle.

**Observations or Comments:**
*(Write observations here)*

**New Version:**
*(Draft new version here)*

---

## Paragraph 4.76
- [x] **Locked**

**Current Content:**
> This connection aligns with Heinz Kurz's (1986) classical choice-of-technique argument. Kurz explains that changes in income distribution alter the cost-effectiveness of different production techniques. In response, firms switch technical methods and adjust capacity utilization, endogenizing the capacity ceiling. Since firms respond to distribution shifts by changing their techniques, the output--capital ratio ($Y/K$) undergoes structural shifts that make the bivariate relation nonstationary. This explains why omitting the rate of exploitation from the system yields nonstationary residuals. The stability of the output--capital relation depends on including income distribution in the cointegrating space, showing that capacity utilization is a distributionally conditioned object rather than a technical law.

**Observations or Comments:**
*(Write observations here)*

**New Version:**
*(Draft new version here)*

---

## Paragraph 4.77
- [x] **Locked**

**Current Content:**
> Our findings across the three stages of this critical replication yield three key results. In Stage S0, we confirm that Shaikh's baseline results are numerically reproducible, proving that the initial replication challenge lies in undocumented deflator choices rather than calculation errors. In Stage S1, we show that the recovered capital-capacity elasticity is not unique, varying from 0.65 to 0.95 along a fit-complexity envelope. In Stage S2, we prove that the output--capital relation cannot survive in a bivariate system, but cointegrates within a trivariate VECM that includes income distribution and historical shock controls. Rather than rejecting Shaikh's capacity measurement strategy, these results establish the specific historical and institutional conditions under which the output--capital relation is stable. We summarize this cross-stage synthesis in Table~\ref{tab:cross_stage_synthesis}.

**Observations or Comments:**
*(Write observations here)*

**New Version:**
*(Draft new version here)*

---

## Paragraph 4.78
- [x] **Locked**

**Current Content:**
> The value of the estimated transformation elasticity ($\hat{\theta}$) dictates both the level of our capacity utilization path and its long-run trend. Since utilization is the residual difference between actual output and fitted capacity, the elasticity determines how much of the long-run capital trend we subtract from output. A lower elasticity estimate (such as RICOMP's 0.65) forces the residual to absorb structural drift, generating a utilization path characterized by long historical waves and slow error correction. A higher elasticity estimate (such as AIC's 0.92) strips the capital trend from the residual, resulting in a highly stationary utilization series that mirrors short-run business cycles. This variation highlights how technical specification choices shape our historical interpretation of capacity realization.

**Observations or Comments:**
*(Write observations here)*

**New Version:**
*(Draft new version here)*

---

## Paragraph 4.79
- [x] **Locked**

**Current Content:**
> System-level VECM estimations resolve the single-equation ambiguity by exposing the historical and institutional conditions needed for stability. All six surviving trivariate models require the historical dummy vector ($D_{1956}$, $D_{1974}$, $D_{1980}$). This pattern shows that the outlier controls in Shaikh's baseline are not arbitrary adjustments; they are necessary to capture a stable cointegrating space. Cointegration holds only when we control for these major historical crises, which stabilize the long-run relationship between capital accumulation and output.

**Observations or Comments:**
*(Write observations here)*

**New Version:**
*(Draft new version here)*

---

## Paragraph 4.80
- [x] **Locked**

**Current Content:**
> The collapse of the standalone output--capital relation stems from the dual role of capital accumulation. Investment demand expands current output in the short run, while the physical capital stock expands productive capacity in the long run. The parameter $\theta$ is forced to mediate these conflicting forces. In a single-equation framework, this entanglement creates parameter instability. The system-level VECM results prove that capacity utilization is not a simple engineering multiplier. In this replication, a stable capacity path depends on both historical shock controls and income distribution. Productive capacity must be measured as a historically conditioned political-economy object rather than a neutral technical ceiling.

**Observations or Comments:**
*(Write observations here)*

**New Version:**
*(Draft new version here)*

---

