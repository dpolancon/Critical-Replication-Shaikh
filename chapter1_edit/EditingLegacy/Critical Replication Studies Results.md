# Chapter 1 — Critical Replication Studies: Section Spine v0.1

## Purpose

This document records the current structural plan for revising the critical replication section of Chapter 1. It is not final prose. It is a working spine for turning the empirical material into a section that states the question, explains the operation, reports the result, and gives the bounded interpretation at each stage.

The section should read as an empirical argument, not as a technical appendix. Its task is to show how Shaikh’s capacity-utilization estimate behaves when the identifying restrictions behind it are reconstructed, varied, and tested as a system.

## 1. Section-Level Claim

Shaikh’s capacity-utilization benchmark can be approximately reconstructed in single-equation form, but it is not uniquely secured. Once the relation is estimated as a joint system, the bivariate output–capital specification does not survive the admissibility screen, while a restricted trivariate rank-one system including exploitation does.

This is the claim the section must carry.

The section should not say that Shaikh fails. It should not say that the trivariate result proves a completed theory of distribution. The result is narrower and stronger: the productive-capacity relation is feasible, fragile, non-unique, and distributionally conditioned.

## 2. Empirical Problem

The empirical problem should be stated before the methods are introduced.

- Actual output is observed.
- Productive capacity is not observed.
- Capacity utilization is constructed from observed output and an estimated productive-capacity benchmark.

The basic constructed object is:

$$
\hat{\mu}_t = \frac{Y_t}{\hat{Y}^p_t}.
$$

The key question is not whether a utilization path can be drawn. The key question is whether the productive-capacity benchmark that generates that path remains reproducible, non-arbitrary, and admissible once the maintained assumptions are made explicit.

## 3. Why Shaikh Matters Here

Shaikh matters because he shifts the problem away from inherited measurement instruments.

The Federal Reserve Board series, the average workweek of capital, and related physical proxies are not treated here as the objects to be chosen among. They are inherited measurement instruments. They can monitor slack or challenge official measures, but they do not by themselves identify the structural relation linking output, capital, productive capacity, and utilization.

Shaikh’s contribution is different. He estimates productive capacity from a long-run output–capital relation grounded in profitability accounting. Capacity utilization then appears as the deviation of actual output from the capacity path implied by that relation.

The critical replication accepts the importance of this route but changes the object of scrutiny. In Shaikh’s presentation, the constructed utilization path carries much of the explanatory burden. In this chapter, the central object of scrutiny is the coefficient that generates the capacity path.

Once interpreted through unbalanced growth, that coefficient is not merely an econometric elasticity. It becomes a candidate transformation elasticity, $\theta$, linking capital accumulation to the formation of productive capacity.

## 4. Core Relation

The baseline long-run relation is:

$$
y_t = a + bt + \theta k_t + \sum_j c_jD_{j,t} + \varepsilon_t,
$$

where:

- $y_t$ is log real corporate output;
- $k_t$ is log real corporate capital stock;
- $D_{j,t}$ are historical break dummies;
- $\theta$ is interpreted here as a transformation elasticity;
- $\varepsilon_t$ is the deviation from the estimated productive-capacity benchmark.

The estimated productive-capacity path is:

$$
\hat{Y}^p_t =
\exp\left(
\hat{a}
+
\hat{b}t
+
\hat{\theta}k_t
+
\sum_j \hat{c}_jD_{j,t}
\right).
$$

Capacity utilization is then constructed as:

$$
\hat{\mu}_t = \frac{Y_t}{\hat{Y}^p_t}.
$$

The sequence matters:

- output is observed;
- productive capacity is estimated;
- utilization is constructed;
- the coefficient anchoring the capacity path must be tested.

## 5. Proposed Section Architecture

The section should merge methods and results stage by stage. It should not place all methods first and all results afterward. Each stage should answer one question, explain one operation, report one result, and state one bounded implication.

Proposed structure:

- 4 Critical Replication Studies on Shaikh’s Approach to Cointegration
- 4.1 Shaikh’s Identification Strategy
- 4.2 Data and Measurement
- 4.3 Stage S0: Single-Equation Reconstruction
- 4.4 Stage S1: ARDL Specification Geometry
- 4.5 Stage S2: System-Level VECM Replication
- 4.6 Cross-Stage Synthesis

## 6. Section 4 Opening

The section should open from the empirical problem, not from the architecture of the study.

Possible opening logic:

- Capacity utilization cannot be treated as a directly observed series.
- Shaikh’s route estimates productive capacity from the long-run relation between output and capital.
- The critical replication asks whether the coefficient anchoring that capacity path can be treated as robustly identified.
- The empirical sequence tests reconstruction, uniqueness, and system admissibility.

The opening should avoid technical inventory language. It should not begin with file names, scripts, package outputs, or grid dimensions. Those details belong in an appendix unless they carry the argument directly.

## 7. Subsection 4.1 — Shaikh’s Identification Strategy

Reader question: What exactly is Shaikh estimating, and why does this chapter scrutinize the coefficient rather than only the constructed utilization path?

Operation:

- Present Shaikh’s route through profitability accounting.
- Explain that productive capacity is estimated from a long-run output–capital relation.
- Explain that utilization is constructed as the deviation of actual output from the implied capacity path.
- Introduce $\theta$ as the chapter’s interpretation of the coefficient anchoring that path.

Required distinction:

Shaikh constructs utilization as a residual deviation from the long-run output–capital relation. This chapter scrutinizes the coefficient that generates the capacity path in the first place.

Bounded implication:

If $\theta$ measures the transformation of accumulation into productive capacity, its stability, uniqueness, and admissibility cannot simply be assumed.

## 8. Subsection 4.2 — Data and Measurement

Reader question: What data enter the replication, and what objects are observed, estimated, or constructed?

Main text content:

- U.S. corporate sector.
- Annual postwar sample.
- Corporate output.
- Corporate capital stock.
- Common deflator.
- Historical break dummies.
- Exploitation rate for the trivariate system.
- Estimated productive capacity.
- Constructed utilization.

Move detailed replication logistics to an appendix or backend note:

- full CSV inventory;
- script names;
- package orchestration;
- seed values;
- complete lattice output;
- full VECM grid.

Bounded implication:

Data construction matters because the capacity benchmark is not observed. The estimated path depends on the real accounting frame, the capital stock series, and the maintained relation used to construct $\hat{Y}^p_t$.

## 9. Subsection 4.3 — Stage S0: Single-Equation Reconstruction

Reader question: Can Shaikh’s benchmark be approximately reconstructed in single-equation form?

Operation:

Stage S0 estimates the long-run output–capital relation using an ARDL bounds-testing framework. Output is modeled conditionally on capital, short-run dynamics are allowed through lagged differences, and the long-run multipliers are used to construct the productive-capacity benchmark.

Result to report:

| PSS case | F-statistic | F p-value | $\hat{\theta}$ | Adjustment coefficient $\alpha$ | F-pass |
|---:|---:|---:|---:|---:|:---:|
| 1 | — | — | — | — | No |
| 2 | 2.208 | 0.356 | 0.836 | -0.137 | No |
| 3 | 0.937 | 0.832 | 0.836 | -0.137 | No |
| 4 | 4.297 | 0.120 | -0.423 | -0.393 | No |
| 5 | 6.136 | 0.110 | -0.423 | -0.393 | No |

Figure role:

The S0 figure should show whether a Shaikh-like utilization path can be reconstructed. The figure should be read together with the bounds results.

Interpretation:

S0 shows approximate recovery under restrictive conditions. Case 2 gives $\hat{\theta}=0.836$, which is close enough to treat the benchmark as empirically recoverable. But no case passes the F-bounds screen at the 10 percent level. The result is therefore not full replication.

Local takeaway:

Shaikh’s benchmark is recoverable as a restricted single-equation object, but the recovery is not admissibility-secured.

## 10. Subsection 4.4 — Stage S1: ARDL Specification Geometry

Reader question: Is the single-equation benchmark unique once the admissible ARDL specification space is opened?

Operation:

Stage S1 estimates a wider ARDL specification space. The specifications vary lag order, deterministic treatment, and historical dummy structure. Each retained specification estimates the same economic relation: output is modeled conditionally on capital in order to construct a productive-capacity benchmark.

Result to report:

| Stage S1 object | Result |
|---|---|
| Retained admissible set | 65 specifications |
| Pareto envelope | 11 specifications |
| Shaikh baseline $m_0$ | Marked as inadmissible in the retained contest |
| Information criteria | Different criteria select different retained points |
| Elasticity estimates | Dispersed across retained envelope |
| Utilization paths | Fan of constructed paths, not one unique series |

Figure role:

Figure 3 should show the fit–complexity space and information-criterion tangencies.

Figure 4 should show the distribution of retained $\hat{\theta}$ estimates and the utilization fan. The reading should make clear that the admissible space does not collapse to one specification.

Interpretation:

S1 does not destroy the single-equation strategy. It shows that the strategy is viable but non-unique. The benchmark persists as a family of admissible reconstructions rather than as a uniquely identified capacity path.

Local takeaway:

The single-equation route remains empirically viable, but the recovered benchmark is closure-sensitive and non-unique.

## 11. Subsection 4.5 — Stage S2: System-Level VECM Replication

Reader question: Does the output–capital relation survive when estimated jointly as a system?

Operation:

Stage S2 estimates the relation as a VECM. The point is to test whether the long-run relation survives when output, capital, and distribution are modeled jointly rather than with output modeled conditionally on capital.

The VECM is:

$$
\Delta X_t =
\Pi X_{t-1}
+
\sum_i \Gamma_i\Delta X_{t-i}
+
\Phi D_t
+
\varepsilon_t,
$$

with:

$$
\Pi = \alpha\beta'.
$$

Here, $\beta$ contains the long-run relation and $\alpha$ contains the adjustment coefficients.

The bivariate system is:

$$
X_t = (y_t,k_t)'.
$$

The trivariate system is:

$$
X_t = (y_t,k_t,e_t)'.
$$

where $e_t$ is the exploitation rate.

Required wording:

Use “bivariate output–capital system.” Do not use “bilateral system.”

Use “without an explicit distributional variable.” Do not write “without distributional effects.”

Result to report:

| System | Rank | Estimated | Failed rank gate | Failed stability gate | Admissible |
|---|---:|---:|---:|---:|---:|
| Bivariate: $X_t=(\ln Y,\ln K)'$ | $r=1$ | 36 | 36 | 4 | 0 |
| Trivariate: $X_t=(\ln Y,\ln K,\ln e)'$ | $r=1$ | 36 | 26 | 4 | 6 |
| Trivariate: $X_t=(\ln Y,\ln K,\ln e)'$ | $r=2$ | 36 | 29 | 7 | 0 |
| Total | — | 108 | 91 | 15 | 6 |

Retained trivariate specifications:

| Specification | Long-run elasticity | Reading |
|---|---:|---|
| $(p1,d0,h2)$ | 0.913 | Near single-equation neighborhood |
| $(p1,d2,h2)$ | 0.971 | Near single-equation neighborhood |
| $(p1,d3,h2)$ | -0.814 | Sign reversal under dummy structure |
| $(p2,d0,h2)$ | 1.189 | BIC/ICOMP winner |
| $(p2,d2,h2)$ | 0.727 | Plausible retained value |
| $(p2,d3,h2)$ | 11.314 | Extreme AIC/HQ winner |

Figure role:

Figure 5 should show the retained VECM systems in fit–complexity space. Its role is to show that the admissible region is narrow and trivariate.

Figure 6 should compare the VECM-implied utilization path, Shaikh’s benchmark, the Federal Reserve series, and the exploitation rate. Its role is to show that the retained admissible system links the constructed utilization path to exploitation inside the same system.

Interpretation:

The bivariate output–capital system does not survive. This does not make S0 or S1 meaningless. It shows that the output–capital relation is not self-sufficient once the empirical object is posed as a joint long-run system.

The restricted trivariate rank-one system survives. This does not prove a completed theory of distributional determination. It shows that the capacity relation survives only when exploitation enters explicitly.

Local takeaway:

The system-level result is the strongest result of the replication: the capacity relation is not reducible to output and capital alone.

## 12. Subsection 4.6 — Cross-Stage Synthesis

Reader question: What does the full replication establish, and what remains unresolved?

Stage results:

| Stage | Result | Bound |
|---|---|---|
| S0 | Approximate single-equation recovery | Not admissibility-secured |
| S1 | Non-empty admissible ARDL space | Non-unique retained benchmark |
| S2 bivariate | Zero admissible specifications | Output–capital system not self-sufficient |
| S2 trivariate rank one | Six admissible specifications | Restricted survival with exploitation |
| S2 trivariate rank two | Zero admissible specifications | No retained rank-two system |

Synthesis:

The critical replication does not refute Shaikh’s strategy. It sharpens its conditions.

Shaikh’s benchmark is recoverable, but not uniquely secured. The single-equation route produces a family of admissible reconstructions, not a settled utilization path. The system-level test then shows that the output–capital relation does not survive as a bivariate system, while a restricted trivariate rank-one system including exploitation does.

Final formulation:

The estimation of an unbalanced-growth parameter is feasible, but the recovered capacity relation is fragile, non-unique, and distributionally conditioned.

## 13. Figure and Table Plan

Main text tables:

| Table | Purpose |
|---|---|
| S0 five-case ARDL bounds summary | Shows approximate recovery and weak bounds support |
| S1 retained-envelope summary | Shows non-uniqueness in single-equation space |
| S2 admissibility screen | Shows bivariate failure and trivariate rank-one survival |
| Retained trivariate specifications | Shows what actually survives |

Main text figures:

| Figure | Purpose |
|---|---|
| S0 utilization comparison | Shows approximate path recovery |
| S1 fit–complexity tangencies | Shows criterion-specific selection |
| S1 elasticity distribution and utilization fan | Shows non-uniqueness of $\theta$ and $\hat{\mu}_t$ |
| S2 retained VECM systems | Shows narrow trivariate survival |
| Focal trivariate utilization/exploitation comparison | Shows distributional conditioning in the retained system |

Appendix or backend:

- full ARDL lattice;
- full VECM grid;
- script and package inventory;
- seed values;
- complete CSV list;
- obsolete bivariate-confirmation language from older backend outputs;
- unused rotation diagnostics.

## 14. Language Controls

Use:

- productive-capacity benchmark;
- constructed utilization path;
- transformation elasticity;
- single-equation reconstruction;
- admissible ARDL space;
- bivariate output–capital system;
- trivariate rank-one system including exploitation;
- distributionally conditioned capacity relation.

Avoid:

- potential output, when referring to Shaikh’s object;
- capital-output elasticity, as the main interpretation of $\theta$;
- recovered mechanically;
- bilateral system;
- without distributional effects;
- proves distributional determination;
- Shaikh fails;
- benchmark collapses.

## 15. Working Rule for the Revision

Each empirical stage should follow the same sequence:

1. State the question.
2. Explain the operation.
3. Report the result.
4. Read the figure or table.
5. State the bounded implication.

This keeps the section clear without turning it into a replication manual. The section should show the empirical work in motion: reconstruction, opening of the specification space, and system-level testing.