# Section 3: Conceptual Framework (Full Revised Draft)

This file contains the full draft of Section 3, including the brief roadmap opening, the nurtured subsections (upgraded using the previous drafts as inputs), and the unchanged paragraphs for continuity.

---

## Section Outset (Roadmap Opening)

### Paragraph 3.1

The conceptual framework of capacity utilization rests on a fundamental accounting challenge: while aggregate output is directly observed, the productive ceiling remains a latent, unobservable variable. This measurement problem is deeply entangled with the critique of aggregate production functions. Rather than trying to identify physical laws of production or marginal productivities through neoclassical functions, we follow Shaikh's methodology which estimates capacity utilization from the long-run relation between aggregate output and capital stock. Because this estimated path serves as the denominator for the capacity utilization index, the properties of the resulting series depend entirely on the stability of the output--capital coefficient driving the long-run relation between them. To analyze this capacity ceiling, we ground this relationship in an aggregate Leontief production structure with fixed labor-capital proportions, which is standard toolkit of the political economy of growth and distribution modeling. This framework treats capacity utilization not as a constant, but as a variable output-capital ratio that deviates from its normal ceiling.\footnote{Although we treat the capacity transformation elasticity, $\theta$, as a technological parameter in this chapter, subsequent chapters will endogenize $\theta$ to show how distributive struggles and changes in the wage share shape the long-run capacity ceiling.}
### Paragraph 3.2

To map this conceptual framework, this section proceeds as follows. First, we analyze the capital-to-capacity relationship within an aggregate Leontief production structure. Second, we evaluate the algebraic identity trap under the Solow-Shaikh critique, demonstrating the misspecification problem of omitting distribution. Third, we relax the balanced-growth assumption to define accumulation regimes and analyze capital accumulation instability. Finally, we analyze the trend-stabilized closure, using Okishio's viability criteria and the double-misspecification framework to show how exogenous trends mask the endogeneity of technical change and distribution.

---

## Subsection 3.1: Production Function and Productive Capacities

The empirical validity of a capacity-utilization series depends strictly on the stability of the parameter that generates the fitted capacity path. While \citet{Shaikh2016} avoids direct physical proxies, his empirical output-capital relation can be grounded in a standard classical Leontief production function:
\begin{equation}
Y_t = \min \{ A_t L_t, \mu_t R^n_t K_t \},
\end{equation}

### Paragraph 3.3
where $Y_t$ is aggregate output, $L_t$ is employment, $K_t$ is the capital stock, $A_t$ is labor productivity, $R^n_t$ is the unobserved normal capacity-capital ratio (which is Shaikh's original symbol for capital productivity at normal capacity utilization, $Y^p_t / K_t$), and $\mu_t$ is capacity utilization. In a capital-constrained regime where labor is not binding due to the reserve army of labor, this production function simplifies to $Y_t = \mu_t R^n_t K_t$. Taking natural logarithms yields:

\begin{equation}
\ln Y_t = \ln K_t + \ln R^n_t + \ln \mu_t.
\end{equation}

This aggregate Leontief specification hides a concrete workplace-level transmission mechanism. At the shop-floor level, the conversion of the capital stock $K_t$ into potential capacity ($Y^p_t = R^n_t K_t$) is not a passive technical constant. Rather, it is determined by the speed of machinery, the organization of shifts, and the physical intensity of labor. This conversion rate, captured in the normal capacity-capital ratio $R^n_t$, changes over time as capitalists introduce labor-saving technical modifications to increase labor discipline. Once potential capacity is established, the production of actual output $Y_t$ is mediated by capacity utilization $\mu_t$, which reflects the pace of market demand. Class struggle over the length and intensity of the workday directly moderates these conversions, determining both the maximum potential output capitalists can extract from a given capital stock and the actual rate of utilization they can sustain.

### Paragraph 3.4
Isolating the long-run capacity path requires modeling the unobserved normal capacity--capital ratio ($\ln R^n_t$). \citet{Shaikh2016} proposes a linear function of a deterministic time trend and the observed capital stock:
\begin{equation}
\ln R^n_t = bt + c \ln K_t.
\end{equation}

### Paragraph 3.5
Substituting this definition into the Leontief-derived log relation yields the estimable single-equation level relation:
\begin{equation}
y_t = a + bt + d\,k_t + \varepsilon_t,
\qquad d \equiv 1+c,
\end{equation}

### Paragraph 3.6
Within this regression, $y_t$ and $k_t$ represent the natural logarithms of unscaled output and capital, while $d$ represents the long-run output--capital elasticity. The constant $a$ absorbs initial conditions and fixed measurement discrepancies in the levels of output and capital. The linear trend component ($bt$) is conventionally interpreted as a measure of autonomous technical change. If the underlying long-run behavior is instead driven by a proportional growth relation ($g_{Y^p} = \theta g_K$), this level trend might obscure an ommited variable bias imposed by a theoretical misspecification of the theoretical model. 

### Paragraph 3.7
The fitted path of productive capacity follows directly from the recovered long-run components:
\begin{equation}
\hat{y}^p_t = \hat{a} + \hat{b}t + \hat{d}\,k_t.
\end{equation}

### Paragraph 3.8
Capacity utilization is then constructed as the deviation of realized output from this long-run capacity path:
\begin{equation}
\ln \hat{\mu}_t = y_t - \hat{y}^p_t,
\qquad
\hat{\mu}_t = \frac{Y_t}{\hat{Y}^p_t}.
\end{equation}

### Paragraph 3.9
This estimation sequence establishes a direct functional dependency, where the constructed utilization series inherits its level, timing, and variance from the estimated parameter $\hat{d}$. Consequently, different single-equation specifications yield divergent $\hat{d}$ estimates, producing contradictory trajectories for both capacity and utilization. Because the model forces a dynamic accumulation process into a rigid accounting identity, the empirical sensitivity of this parameter raises an immediate identification problem. Structural measurement therefore rests on evaluating whether this long-run multiplier captures a genuine behavioral law of production, or whether it operates merely as an algebraic placeholder that absorbs omitted historical variation.

---

## Subsection 3.2: Laws of Algebra and Laws of Production

### Paragraph 3.10
The estimated long-run coefficient $d$ operates as the transformation elasticity ($\theta \equiv \partial \ln Y^p / \partial \ln K$) anchoring the profit-rate decomposition of \citet{Shaikh2016}. Because the normal rate of profit relies directly on the constructed capacity--capital ratio, the structural integrity of the entire empirical operationalization of his theoretical contributions rests on this specific parameter. While the aggregate accounting identity deterministically organizes these profit magnitudes, it leaves the underlying behavioral mechanism translating capital accumulation into productive capacity undefined. Following the analytical standard of \citet{Shaikh1974}, an accounting identity that leaves its core behavioral mechanism undefined mechanically mimics a structural production law. As previously stated, this entails a misspecification risk: the inclusion of a trend variable might partially absorb historical and institutional variation overlooked in Shaikh's formulation.

### Paragraph 3.11
Evaluating Shaikh's capacity regression reveals that it is vulnerable to the very critique he leveled against Solow's aggregate production function. In his seminal critique, \citet{Shaikh1974} showed that the high fit of aggregate production functions is a mathematical byproduct of the underlying value-added accounting identity ($p_tY_t \equiv W_t + P_t = w_t L_t + r_t K_t$) under a constant wage share, rather than proof of physical substitution laws. As elaborated by \citet{Felipe2005}, aggregate regressions using constant-price monetary data do not identify physical production laws, but instead approximate this value identity. Applying this critique to Shaikh's own capacity regression reveals a similar limitation: since the output--capital ratio is linked by identity to the rate of profit ($r_t$) and the profit share ($\pi_t$) via $Y_t/K_t = r_t/\pi_t$, taking logarithms yields $y_t - k_t = \ln r_t - \ln \pi_t$. When we estimate the level relation over a period of shifting profit shares and class struggle, the deterministic trend $bt$  does not necessarily identify an autonomous technological change component, rather distributive variation. The long-run coefficient $d$ must adjust to satisfy the accounting identity, mimicking a stable physical relation while masking changes in the rate of exploitation.

### Paragraph 3.12
To ground this value identity trap in post-war US history (1947–2011) using the original data tables by \citet{Shaikh2016}, we observe that while real gross value added grew at an average annual rate of 3.3\% and the real gross capital stock grew at 4.4\%, the output-to-capital ratio remained stable in the long run but fluctuated around a historical average of 0.53 (or 0.48 if using net value added). Imposing a constant long-run capital coefficient over this entire period averages across structurally heterogeneous historical regimes—such as the Post-War Golden Age (1947–1973) profit squeeze and the subsequent neoliberal wage stagnation (1983–2011). Because the single-equation model excludes these distributional variables, the estimated capital coefficient is contaminated by this omitted historical variation. Thus, the output--capital relationship appears stable only because it mathematically averages across structurally distinct historical regimes. 

### Paragraph 3.13
We must also address a key econometric limitation of estimating this transformation elasticity. The capital stock series $K_t$ is constructed using the perpetual inventory method, which is notoriously subject to measurement errors regarding depreciation, asset pricing, and retirement patterns. Econometrically, measurement error in the right-hand-side variable ($k_t$) introduces a classical errors-in-variables problem. This error biases the estimated elasticity parameter $\theta$ (and the long-run coefficient $d$) downward toward zero. When interpreting the empirical estimates of $\theta$, we must treat them as lower-bound estimates of the true transformation elasticity, acknowledging that capital stock measurement errors make the observed capacity response appear more sluggish than it is in reality.

---

## Subsection 3.3: Balanced vs. Unbalanced Growth: Accumulation Regimes and Capital Accumulation Instability

### Paragraph 3.14
Marx's schemas of reproduction provide the analytical benchmark for proportional macroeconomic growth \citep{Okishio2022}. Smooth capitalist reproduction requires strict material proportions: commodities must sell, surplus value must be realized, and the material composition of output must match the input requirements of continuous capital accumulation \citep{Basu2022}. Because real capitalist economies routinely violate these proportions, smooth reproduction remains an analytical abstraction rather than a historical description. To isolate the supply-side relation between capital and capacity, the long-run classical closure ($\mu = 1$) holds demand instability constant \citep{Foley1985}. Alternatively, canonical post-Keynesian models enforce a balanced-growth baseline by assuming a unitary transformation elasticity ($\theta = 1$) in the long run. Combined with demand fluctuations, this unitary assumption generates the characteristic properties of the Harrodian knife-edge.

### Paragraph 3.15
Introducing an unbalanced growth closure ($\theta \neq 1$) achieves long-run identification by treating proportional accumulation as suggested by \citet{Okishio2022}, as a restrictive special case of equilibrium accumulation trajectory. Relaxing the unitary assumption shifts the analytical focus away from the classical closure ($\mu = 1$). Under a non-unitary parameter, systematic instability is an inherent feature of capacity formation, distinct from temporary deviations driven by demand. The transformation elasticity ($\theta$) governs the long-run development of productive capacity independently of short-run demand stabilization. In this setup, $\theta$ acts as a structural parameter, where the interest of this critical replication lies. Its endogenization to distributive conflict is beyond the scope of this chapter, but will be tackled in the next chapter of this dissertation. 
### Paragraph 3.16
Defining the transformation elasticity as $\theta \equiv \partial \ln Y^p / \partial \ln K$, the analytical properties of the accumulation system depend on whether this parameter deviates from unity. Table~\ref{tab:growth_regimes} defines three macroeconomic regimes bounded by these conditions.

\begin{table}[H]
\centering
\caption{Accumulation Regimes and the Productive-Capacity Relation}
\label{tab:growth_regimes}
\small
\begin{tabular}{@{}>{\raggedright\arraybackslash}p{3.2cm}>{\centering\arraybackslash}p{1.8cm}>{\raggedright\arraybackslash}p{4.2cm}>{\raggedright\arraybackslash}p{4.0cm}@{}}
\toprule
Regime & Parameter Condition & Long-Run Relation $(\hat{Y}^p,\hat{K})$ & System Tendency \\
\midrule
\midrule
Balanced Growth & $\theta = 1.0$ & Capital and capacity expand proportionally & Knife-edge baseline \\
Overaccumulation & $\theta < 1.0$ & Capital expands faster than productive capacity & Accumulation decelerates toward stagnation \\
Excess Capacity & $\theta > 1.0$ & Productive capacity expands faster than capital & Accumulation accelerates without supply-side limits \\
\bottomrule
\end{tabular}
\caption*{\small Note: This table defines the theoretical regimes governing the system.}
\end{table}

### Paragraph 3.17
We frame this regime classification under a single-sector macroeconomic bounding; while this simplifies the analysis of stagnation tendencies ($\theta < 1$) and overaccumulation, it represents a key analytical boundary. The debates around Marx's reproduction schemas on disproportionality emphasize the material and value balances between Department I (means of production) and Department II (means of consumption). By abstracting from these sectoral flows, our single-sector framework constrains the concept of disproportionality to the structural decoupling of capital accumulation and capacity expansion in terms of unbalanced growth: between capital stock and productive capacities, under the assumption that the only source of demand that builds productive capacities is accumulation demand. Unbalanced growth is represented by a non-unitary transformation elasticity ($\theta \neq 1$). This serves as a simplified  baseline to work under a single sector macroeconomic framework for our empirical replication and subsequent chapters of the dissertation, while acknowledging that sectoral imbalances are abstracted from our analysis. 

### Paragraph 3.18
These regimes represent the analytical limits of the accumulation process. Under an unbalanced growth closure without autonomous technical change, the dynamic path of the net capital growth rate ($\hat{k} \equiv \dot{K}/K - \delta$) is governed by an ordinary differential equation where the sign of $d\hat{k}/dt$ depends on the magnitude of $(\theta - 1)$ (the formal mathematical derivation and stability proofs are provided in Appendix~\ref{app:acc_dynamics}). Net accumulation decelerates under $\theta < 1$, accelerates under $\theta > 1$, and remains stationary under $\theta = 1$. This instability reflects the accounting laws of capital accumulation under a non-unitary transformation elasticity, distinct from Harrodian demand-driven dynamics.

### Paragraph 3.19
Formally, $d\hat{k}/dt$ is a capital growth acceleration term, representing the rate of change of the net capital accumulation rate over time. Because a perpetual acceleration or deceleration of capital growth is economically impossible over long horizons, this term must remain bounded near zero over the long run. In historical capitalist economies, this bounding is enforced by rate-limiting and temporary institutional factors. When accumulation accelerates too rapidly ($\theta > 1$), it hits bottlenecks like labor cost inflation (wage barriers), central bank interest rate hikes (monetary policy shifts), and financial leverage limits (capital market constraints). Conversely, when accumulation slows down ($\theta < 1$), state interventions, bankruptcy reorganizations, and cheapened capital assets eventually bound the stagnation tendency, preventing the acceleration term from diverging infinitely from zero.

### Paragraph 3.20
To illustrate this dynamic instability qualitatively using the original replication data structures of \citet{Shaikh2016}, consider a stylized example under both overaccumulation and explosive growth regimes. Let the baseline net capital growth rate be $\hat{k}_0 = 3\%$ (0.03) and the depreciation rate be $\delta = 5\%$ (0.05), implying a gross growth rate of capital of $8\%$. If we assume a unitary transformation elasticity ($\theta = 1$) under a balanced-growth baseline, the capacity ceiling expands proportionally at $8\%$ and the net accumulation rate remains stationary ($d\hat{k}/dt = 0$). However, if the transformation elasticity is non-unitary, say $\theta = 0.8$, the system experiences overaccumulation. Here, a $1\%$ growth in capital relative to capacity formation entails a $0.2\%$ capacity mismatch ($\theta - 1 = -0.2$). This mismatch induces a persistent downward drag on capital accumulation (normal capital productivity decays at $\hat{R}^n = -1.6\%$), decelerating the net accumulation rate at a rate of $d\hat{k}/dt = -0.128\%$ per year toward stagnation. Conversely, if the transformation elasticity is $\theta = 1.2$, capacity expands at $9.6\%$, causing normal capital productivity to rise ($\hat{R}^n = +1.6\%$) and the net accumulation rate to accelerate at $d\hat{k}/dt = +0.128\%$ per year, driving the system into an unbounded, explosive trajectory (as detailed in Appendix~\ref{app:acc_dynamics}). This dynamic instability is illustrated in Figure~\ref{fig:ode_phase_diagram}, which plots the phase diagram for both regimes.

\begin{figure}[H]
    \centering
    \caption{Capital accumulation dynamics under unbalanced growth}
    \includegraphics[width=0.92\linewidth]{figures/fig_S3_phase_diagram_capital_capacity_dynamics.pdf}
    \caption*{\small Note: Panel A plots the overaccumulation regime ($\theta = 0.8 < 1.0$) where capital acceleration is negative ($d\hat{k}/dt < 0$ for $\hat{k} > -\delta$), pushing the net accumulation rate toward the stable stagnation equilibrium at $\hat{k}^* = -\delta$. Panel B plots the explosive growth regime ($\theta = 1.2 > 1.0$) where capital acceleration is positive ($d\hat{k}/dt > 0$ for $\hat{k} > -\delta$), causing the accumulation rate to diverge. Both panels show the initial condition $\hat{k}_0 = 3\%$ where $d\hat{k}/dt = \mp 0.128\%$, consistent with the numerical example in \S\ref{subsec:balanced_unbalanced_growth}.}
    \label{fig:ode_phase_diagram}
\end{figure}

### Paragraph 3.21
While effective demand and distributive conflict retain their analytical relevance, they are abstracted from in this initial formulation. Institutional and macroeconomic forces dampen, accelerate, or redirect the underlying long-run tendency but do not generate it. The differential dynamics in Appendix~\ref{app:acc_dynamics} imply a regime-dependent trajectory, yet the empirical single-equation model restricts $\theta$ to a time-invariant constant. Evaluating whether this parameter invariance holds historically establishes the exact structural implications of the fixed-parameter closure.

## Subsection 3.4: Trend Stabilization, Okishio's Viability, and the Double-Misspecification Trap

### Paragraph 3.22
Previously we have argued that econometrically, the inclusion of a time trend might absorb variation arising from distributive conflict and distinct historical configurations. Hence, we analyze the inclusion of a time trend under an unbalanced growth closure ($g_{Y^p} = \theta g_K$) and its consequences for dynamic stability. As established in the phase dynamics, a system experiencing overaccumulation ($\theta < 1$) forces the net accumulation rate to decay to zero. Using the same accounting identities that drive dynamic stability, we can show that introducing a deterministic level trend ($b$) under an unbalanced growth closure ($g_{Y^p} = \theta g_K + b$) stabilizes the system.

### Paragraph 3.23
Substituting this extended closure into the acceleration identity transforms the system into a quadratic ordinary differential equation:
\begin{equation}
\frac{d\hat{k}}{dt} = (\hat{k} + \delta)\left[(\theta - 1)\hat{k} + b\right].
\end{equation}

### Paragraph 3.24
This specification shifts the equilibrium structure of the accumulation process. The stagnation limit ($\hat{k}^* = 0$) is replaced by a new interior root:
\begin{equation}
\hat{k}^* = \frac{b}{1 - \theta}.
\end{equation}

### Paragraph 3.25
Under overaccumulation ($\theta < 1$) with positive autonomous technical progress ($b > 0$), this equilibrium is locally stable. The depreciation rate ($\delta$) anchors the negative root, while the ratio $b / (1 - \theta)$ scales autonomous progress against the structural imbalance.

### Paragraph 3.26
The analysis of technical change by \citet{Basu2022} shows why treating this trend-stabilized steady state as a smooth, exogenously determined path is problematic. Okishio's framework establishes that capitalists only adopt new production techniques if they satisfy a cost-reducing viability criterion at prevailing prices and wages. Crucially, the introduction of these labor-saving techniques is not an exogenous constant ($b$), but is endogenously driven by wage bargaining and class struggle on the shop floor. When capitalists mechanize to restore labor discipline in response to wage increases, they alter the organic composition of capital. Thus, technical change and the capacity ceiling are endogenously linked to distribution, meaning that the stabilization trend ($b$) cannot be treated as a neutral, exogenous technological parameter. Restricting it to a constant masks the feedback loops between wage conflict, technical choice, and macroeconomic viability.

### Paragraph 3.27
The statistical validity of the capacity utilization series relies on establishing a stable cointegrating relation between output, capital, and the deterministic trend. Omitting distributive conflict while including the exogenous trend introduces a double misspecification. As \citet{Basu2020} demonstrates, when an econometric model excludes a relevant variable—in this case, distributive conflict and its influence on the choice of technique \citep{Kurz1986}—while including an irrelevant proxy like a deterministic time trend, the estimator for the capital coefficient suffers from compound bias. Because the trend mathematically absorbs the unobserved shifts in distribution, this indirect bias channel compromises the recovered elasticity parameter $\theta$, making it a passive statistical fit rather than a stable production relation.

### Paragraph 3.28
Estimating this relation over Shaikh's sample imposes a rigid temporal constraints. This  restriction forces both the elasticity ($\theta$) and the trend ($b$) to act as time-invariant constants across shifting institutional configurations. The classical long-run closure ($\mu = 1$) isolates theoretical capital-to-capacity relations \citep{Foley1985} or smooth reproduction paths \citep{Okishio2022, Basu2022}. Because real capitalist economies routinely violate these strict proportionality conditions, imposing time-invariance forces the recovered parameters to mathematically average across structurally heterogeneous historical periods.

### Paragraph 3.29
Looking at the actual post-war historical trajectory of the US economy (1947–2011) using the original data tables by \citet{Shaikh2016}, these theoretical regimes correspond to distinct accumulation phases. During the Post-War Golden Age (1947–1973), the US corporate sector experienced rapid capital accumulation alongside strong output growth and a stable output--capital ratio, with the real gross capital stock expanding at an average annual rate of 5.4\% and real gross value added growing at 4.4\%. This period represents a relatively balanced accumulation path. During the transition of the stagflation crisis (1974–1982), the growth of the real capital stock remained relatively high at 4.8\% (driven by energy-related investments and structural restructuring), while real output growth slowed significantly to 2.7\%, causing the output-capital ratio to collapse from its Golden Age average of 0.65 to 0.47. Subsequently, in the neoliberal era (1983–2011), the rate of capital accumulation fell to an average of 3.3\% annually, while real output grew at 2.7\%, and the output--capital ratio remained volatile. This structural shift in how capital accumulation translates to productive capacity suggests a change in the underlying transformation elasticity $\theta$. Imposing a time-invariant parameter over this entire 64-year span averages across these distinct historical periods, masking these structural shifts.

### Paragraph 3.30
The next section~\ref{sec:replication_strategy} implements an analytical stress test across three distinct stages to identify the conditions under which Shaikh's single-equation ARDL estimation fails to identify cointegration. Stage S0 establishes a baseline of reproducibility using the original data tables by \citet{Shaikh2016} and lag lengths. Stage S1 implements an admissibility test by estimating a grid of 500 ARDL specifications, mapping parameter sensitivity to researcher choices—such as lag structures, information-criterion penalties, and historical dummy variables. Stage S2 estimates the long-run relationship using a Vector Error Correction Model (VECM) to determine whether joint system stability holds in a bivariate setting, or if it requires the logged rate of exploitation ($e_t = \ln[\pi_t / (1 - \pi_t)]$ ) to establish a stable cointegrating relationship.