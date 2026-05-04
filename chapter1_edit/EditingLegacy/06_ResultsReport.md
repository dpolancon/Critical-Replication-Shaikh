# Results Brief v0.2.2 — Chapter 1 Critical Replication

The critical replication produces three empirical results. First, Shaikh’s single-equation benchmark can be approximately reconstructed, but the reconstruction is conditional on restrictive closure choices. Second, opening the ARDL specification space shows that the single-equation benchmark is not unique: the retained admissible space remains dispersed. Third, the bivariate output–capital system does not survive the VECM admissibility gate, while a restricted trivariate rank-one system including exploitation does.

The empirical object is the same across the three stages. Actual output is observed. Productive capacity is estimated. Capacity utilization is constructed from observed output and the estimated productive-capacity benchmark:

$$
\hat{\mu}_t = \frac{Y_t}{\hat{Y}^p_t}.
$$

The results therefore do not ask whether a utilization path can be drawn. They ask whether the productive-capacity benchmark that generates that path remains reproducible, non-arbitrary, and admissible once the maintained assumptions are made explicit.

## 1. Stage S0: Single-Equation Reconstruction

Stage S0 reconstructs Shaikh’s benchmark using the ARDL specification closest to the original implementation. The immediate result is mixed. The specification can generate a utilization path close enough to Shaikh’s benchmark to treat the estimate as approximately recoverable. But the bounds-test results show that this recovery is fragile.

The five-case ARDL reconstruction gives the following results:

| PSS case | F-statistic | F p-value | $\hat{\theta}$ | Adjustment coefficient $\alpha$ | F-pass |
|---:|---:|---:|---:|---:|:---:|
| 1 | — | — | — | — | No |
| 2 | 2.208 | 0.356 | 0.836 | -0.137 | No |
| 3 | 0.937 | 0.832 | 0.836 | -0.137 | No |
| 4 | 4.297 | 0.120 | -0.423 | -0.393 | No |
| 5 | 6.136 | 0.110 | -0.423 | -0.393 | No |

The closest reconstruction comes from Case 2, where $\hat{\theta}=0.836$. This is close to Shaikh’s reported benchmark directionally, but it does not pass the F-bounds admissibility screen at the 10 percent level. Cases 4 and 5 produce a negative long-run elasticity, $\hat{\theta}=-0.423$, showing that deterministic specification changes the coefficient itself rather than merely shifting the level of the utilization path.

The substantive result is therefore not “S0 fails.” It is more precise: S0 recovers a plausible single-equation benchmark, but the recovery is not admissibility-secured. Approximate reconstruction and econometric admissibility come apart.

The S0 figures should be read in that light. The utilization comparison shows that a Shaikh-like path can be reconstructed. The five-case comparison shows that the path depends on deterministic handling. The capacity-benchmark figure shows how the estimated productive-capacity path sits against observed output. Together, they establish visible recovery under restrictive assumptions, not full replication.

## 2. Stage S1: ARDL Specification Geometry

Stage S1 asks whether the single-equation result remains stable once the ARDL specification space is opened.

The older backend results package reported a 500-specification ARDL lattice, with admissibility defined through the F-bounds screen. The current paper’s retained Stage S1 result is narrower and more relevant for the chapter’s argument: the retained admissible space contains 65 specifications, and the Pareto envelope contains 11 specifications. The paper’s Figure 4 reports these directly: grey points show all admissible specifications, $n=65$, while the orange envelope marks the retained Pareto set, $E_{S1}$, with $n=11$.

The retained envelope includes the following utilization-path specifications shown in the figure:

| Envelope specification |
|---|
| $(1,2,c2,s0)$ |
| $(1,2,c2,s1)$ |
| $(1,2,c2,s2)$ |
| $(2,2,c2,s2)$ |
| $(5,2,c2,s1)$ |
| $(5,3,c2,s1)$ |
| $(5,4,c2,s1)$ |
| $(5,5,c2,s1)$ |
| $(5,5,c2,s2)$ |
| $(5,5,c2,s3)$ |

The figure also marks Shaikh’s baseline specification, $m_0$, as inadmissible in the Stage S1 contest. This is important. The point is not that the ARDL space collapses into Shaikh’s original model. It does not. The point is that a non-empty admissible region exists, but it generates a dispersed family of long-run elasticity estimates and utilization paths.

The fit–complexity figure reports different information-criterion tangencies. AIC, HQ, and the BIC/ICOMP/RICOMP cluster do not all select the same point. This matters because the retained benchmark depends on the criterion used to select among admissible specifications.

Stage S1 therefore produces a genuine result:

| Stage S1 object | Result |
|---|---|
| Full ARDL contest | Opened across lag orders, deterministic cases, and dummy structures |
| Retained admissible set | 65 specifications |
| Pareto envelope | 11 specifications |
| Shaikh baseline $m_0$ | Marked as inadmissible in the retained contest |
| Elasticity result | Dispersed across retained envelope |
| Utilization result | Fan of recovered utilization paths, not one unique path |

The conclusion is diagnostic. Stage S1 does not destroy the single-equation strategy. It shows that the strategy remains viable but non-unique. The benchmark persists as a recoverable reduced-form object, but only under closure dependence rather than unique identification.

## 3. Stage S2: VECM System-Admissibility Screen

Stage S2 asks whether the long-run relation survives when estimated as a joint system.

The system screen is the central result of the critical replication. The bivariate output–capital system does not survive. The trivariate rank-one system including exploitation survives only in a restricted subset.

The Stage S2 admissibility screen is:

| System | Rank | Estimated | Failed rank gate | Failed stability gate | Admissible |
|---|---:|---:|---:|---:|---:|
| Bivariate: $X_t=(\ln Y,\ln K)'$ | $r=1$ | 36 | 36 | 4 | 0 |
| Trivariate: $X_t=(\ln Y,\ln K,\ln e)'$ | $r=1$ | 36 | 26 | 4 | 6 |
| Trivariate: $X_t=(\ln Y,\ln K,\ln e)'$ | $r=2$ | 36 | 29 | 7 | 0 |
| Total | — | 108 | 91 | 15 | 6 |

This is the key result. The bivariate output–capital system produces zero admissible specifications. The trivariate rank-one system produces six admissible specifications. The trivariate rank-two system produces zero admissible specifications.

The result is restrictive, not expansive. System estimation does not rescue the benchmark by producing a broad admissible region. It narrows the result sharply: only a restricted trivariate rank-one system survives.

## 4. Retained Stage S2 Trivariate Specifications

The six retained Stage S2 specifications are:

| Specification | $p$ | Dummy set | $k$ | $-2\log L$ | Long-run elasticity | $\alpha_y$ | $\alpha_k$ | $\alpha_e$ |
|---|---:|---|---:|---:|---:|---:|---:|---:|
| $(p1,d0,h2)$ | 1 | d0 | 12 | -916.1 | 0.913 | 0.057 | 0.089 | 0.007 |
| $(p1,d2,h2)$ | 1 | d2 | 15 | -926.1 | 0.971 | -0.032 | 0.094 | -0.488 |
| $(p1,d3,h2)$ | 1 | d3 | 18 | -950.4 | -0.814 | -0.024 | 0.050 | -0.426 |
| $(p2,d0,h2)$ | 2 | d0 | 21 | -1014.7 | 1.189 | 0.022 | 0.000 | 0.078 |
| $(p2,d2,h2)$ | 2 | d2 | 24 | -1018.6 | 0.727 | -0.005 | 0.000 | -0.019 |
| $(p2,d3,h2)$ | 2 | d3 | 27 | -1038.1 | 11.314 | -0.008 | -0.005 | 0.072 |

The information-criterion winners are also visible in the retained table. The $(p2,d0,h2)$ specification is marked as the BIC and ICOMP winner. The $(p2,d3,h2)$ specification is marked as the AIC and HQ winner.

This table matters because it prevents the results brief from becoming a slogan. The trivariate result is not simply “distribution matters.” The retained space is small, uneven, and sensitive. Most retained elasticities lie in a plausible neighborhood around the single-equation reconstruction, but one AIC/HQ-winning specification produces an extreme long-run elasticity of 11.314. That outlier is exactly why the result must remain bounded.

The admissible trivariate set supports the claim that the bivariate output–capital relation is not self-sufficient. It does not support the stronger claim that the trivariate system uniquely identifies a stable structural law.

## 5. Figure-Level Results

The figures carry the empirical argument and should not be treated as decoration.

Figure 3 places the retained Stage S1 specifications in fit–complexity space. It shows that Shaikh’s baseline specification is inadmissible in the Stage S1 contest and that different information criteria select different points on the retained frontier.

Figure 4 translates that contest into the substantive objects: the distribution of retained long-run elasticity estimates and the corresponding utilization fan. The left panel shows that the admissible set does not collapse to a single $\hat{\theta}$. The right panel shows that the resulting utilization paths form a family rather than a unique reconstructed series.

Figure 5 reports the fit–complexity locations of the six retained Stage S2 systems. The admissible region is small and sharply delimited: only trivariate rank-one specifications survive.

Figure 6 compares the capacity-utilization path implied by the focal trivariate VECM with Shaikh’s benchmark, the Federal Reserve series, and the exploitation rate. The figure is useful because it places the constructed utilization path and the distributional variable inside the same admissible system. It should be read as evidence of a distributionally mediated capacity-utilization relation, not as proof of a completed reserve-army law.

## 6. Cross-Stage Result

The cross-stage result is now concrete.

| Stage | Empirical object | Main result | Bound |
|---|---|---|---|
| S0 | ARDL reconstruction of Shaikh benchmark | Case 2 gives $\hat{\theta}=0.836$ and a plausible reconstructed path | Does not pass F-bounds admissibility at 10 percent |
| S1 | Open ARDL specification space | 65 admissible specifications; 11-specification Pareto envelope; dispersed elasticities and utilization fan | Benchmark remains non-unique |
| S2 bivariate | $X_t=(\ln Y,\ln K)'$ | 36 estimated; 0 admissible | Output–capital relation does not survive as self-sufficient system |
| S2 trivariate rank one | $X_t=(\ln Y,\ln K,\ln e)'$ | 36 estimated; 6 admissible | Survives only as restricted trivariate object |
| S2 trivariate rank two | $X_t=(\ln Y,\ln K,\ln e)'$ | 36 estimated; 0 admissible | No retained rank-two trivariate system |

The central empirical result is:

Shaikh’s capacity-utilization benchmark can be approximately reconstructed in single-equation form, but not uniquely secured. Once the relation is estimated as a joint system, the bivariate output–capital specification fails the admissibility gate, while a restricted trivariate rank-one system including exploitation survives.

## 7. Interpretation

The replication does not show that Shaikh’s benchmark is arbitrary. It shows that the benchmark is closure-sensitive.

It does not show that the single-equation strategy is useless. It shows that the strategy is fragile once admissibility and specification geometry are made explicit.

It does not show that distributional determination has been proven. It shows that the retained long-run system is not reducible to output and capital alone.

The strongest defensible formulation is therefore:

The estimation of an unbalanced-growth parameter is feasible, but the recovered capacity relation is fragile, non-unique, and distributionally conditioned.

## 8. Implication

The next step cannot simply apply Shaikh’s benchmark mechanically to another case. The replication shows that productive-capacity estimation cannot be treated as a purely technical output–capital problem. If the capacity relation survives system estimation only when exploitation enters explicitly, then Chapter 2 must estimate productive capacity with distribution included as part of the structural problem rather than appended after the fact.