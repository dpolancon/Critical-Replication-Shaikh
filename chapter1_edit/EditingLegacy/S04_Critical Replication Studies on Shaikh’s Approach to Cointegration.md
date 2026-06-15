# 4 Critical Replication Studies on Shaikh’s Approach to Cointegration — Brief Version

## Section result

- Capacity utilization is not directly observed.
- Actual output is observed.
- Productive capacity is estimated.
- Capacity utilization is constructed as:

$$
\hat{\mu}_t = \frac{Y_t}{\hat{Y}^p_t}.
$$

- Shaikh’s contribution is not a better utilization proxy.
- His route estimates productive capacity from a long-run output--capital relation grounded in profitability accounting.
- This replication tests whether the coefficient anchoring that capacity path can be treated as robustly identified.
- Read through the unbalanced-growth framework, that coefficient is a candidate transformation elasticity, $\theta$.

The critical replication produces three results:

- **S0:** Shaikh’s benchmark can be approximately reconstructed in single-equation form, but the recovery is fragile.
- **S1:** Opening the ARDL specification space shows that the benchmark is not unique.
- **S2:** The bivariate output--capital system does not survive; a restricted trivariate rank-one system including exploitation does.

---

## 4.1 Identification Object

The baseline relation is:

$$
y_t = a + bt + \theta k_t + \sum_j c_jD_{j,t} + \varepsilon_t.
$$

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

Estimated utilization is then:

$$
\hat{\mu}_t = \frac{Y_t}{\hat{Y}^p_t}.
$$

The sequence is decisive:

- output is observed;
- productive capacity is estimated;
- utilization is constructed;
- $\theta$ anchors the estimated capacity path.

If $\theta$ measures the transformation of capital accumulation into productive capacity, its stability, uniqueness, and admissibility cannot be assumed.

---

## 4.2 Data and Measurement

| Layer | Object | Status |
|---|---|---|
| Observed | Corporate output; corporate capital stock | Inputs to the output--capital relation |
| Estimated | Productive-capacity benchmark, $\hat{Y}^p_t$ | Constructed from the long-run relation |
| Constructed | Capacity utilization, $\hat{\mu}_t$ | Ratio of observed output to estimated productive capacity |

- The replication uses annual U.S. corporate-sector data.
- Output and capital are placed in a consistent real accounting frame.
- Historical break dummies enter the single-equation and system specifications.
- The exploitation rate enters only at the VECM stage as the explicit distributional variable.

![Figure 1. Net-to-gross corporate capital-stock ratio, 1947--2011.](figures/fig_net_to_gross_ratio.pdf)

**Figure 1. Net-to-gross corporate capital-stock ratio, 1947--2011.** The figure reports $\psi_t = K^{N,C}_{BEA}/K^{G,C}_{GPIM}$, comparing the BEA official net corporate capital stock with Shaikh’s GPIM-adjusted gross corporate capital stock. The estimated productive-capacity benchmark depends directly on the capital series anchoring the output--capital relation.

---

## 4.3 Stage S0: Single-Equation Reconstruction

### Question

- Can Shaikh’s benchmark be approximately reconstructed in single-equation form?

### Result

| PSS case | F p-value | $\hat{\theta}$ | F-pass |
|---:|---:|---:|:---:|
| 2 | 0.356 | 0.836 | No |
| 3 | 0.832 | 0.836 | No |
| 4 | 0.120 | -0.423 | No |
| 5 | 0.110 | -0.423 | No |

### Reading

- Case 2 gives $\hat{\theta}=0.836$.
- This supports approximate recovery of Shaikh’s benchmark.
- Cases 4 and 5 reverse the sign of $\hat{\theta}$.
- No case passes the F-bounds screen at the 10 percent level.
- S0 therefore shows approximate reconstruction, not full replication.

![Figure 2. Capacity-utilization fan, Stage S0.](figures/fig_S0_cu_fan.pdf)

**Figure 2. Capacity-utilization fan, Stage S0.** The figure compares Shaikh’s ARDL(2,4) benchmark under alternative long-run closures with IC-preferred specifications and with the Federal Reserve utilization series. A Shaikh-like utilization path can be reconstructed, but the path depends on long-run closure, deterministic treatment, and dummy handling.

### S0 takeaway

- Shaikh’s benchmark is recoverable as a restricted single-equation object.
- The recovery remains fragile and not admissibility-secured.

---

## 4.4 Stage S1: ARDL Specification Geometry

### Question

- Is the single-equation benchmark unique once the admissible ARDL space is opened?

### Result

| Stage S1 object | Result |
|---|---|
| Retained admissible set | 65 specifications |
| Pareto envelope | 11 specifications |
| Shaikh baseline $m_0$ | Marked as inadmissible |
| Information criteria | Select different retained points |
| Utilization paths | Fan of constructed paths |

![Figure 3. Information-criterion tangencies in the Stage S1 ARDL specification space.](figures/fig_S1_ic_tangencies.pdf)

**Figure 3. Information-criterion tangencies in the Stage S1 ARDL specification space.** AIC, HQ, and the BIC/ICOMP/RICOMP cluster select different points on the retained frontier. Shaikh’s baseline specification, $m_0$, is marked as inadmissible.

![Figure 4. Distribution of $\hat{\theta}$ and constructed utilization fan across the Stage S1 Pareto envelope.](figures/fig_S1_theta_and_cu_fan.pdf)

**Figure 4. Distribution of $\hat{\theta}$ and constructed utilization fan across the Stage S1 Pareto envelope.** The retained specifications generate a distribution of $\hat{\theta}$ estimates and a fan of constructed utilization paths. The benchmark remains a family of admissible reconstructions rather than one uniquely identified series.

### S1 takeaway

- The single-equation strategy remains viable.
- It does not yield a unique benchmark.
- The recovered utilization path is closure-sensitive.

---

## 4.5 Stage S2: System-Level VECM Replication

### Question

- Does the output--capital relation survive when estimated jointly as a system?

### System definitions

Bivariate output--capital system:

$$
X_t = (y_t,k_t)'.
$$

Trivariate system including exploitation:

$$
X_t = (y_t,k_t,e_t)'.
$$

### Admissibility result

| System | Rank | Estimated | Admissible |
|---|---:|---:|---:|
| Bivariate: $X_t=(\ln Y,\ln K)'$ | $r=1$ | 36 | 0 |
| Trivariate: $X_t=(\ln Y,\ln K,\ln e)'$ | $r=1$ | 36 | 6 |
| Trivariate: $X_t=(\ln Y,\ln K,\ln e)'$ | $r=2$ | 36 | 0 |

![Figure 5. Retained VECM specifications in Stage S2 fit--complexity space.](figures/fig_S2_pooled_frontier.pdf)

**Figure 5. Retained VECM specifications in Stage S2 fit--complexity space.** Only six trivariate rank-one specifications survive the admissibility screen. No bivariate output--capital specification survives.

### Retained trivariate values

| Specification | Long-run elasticity |
|---|---:|
| $(p1,d0,h2)$ | 0.913 |
| $(p1,d2,h2)$ | 0.971 |
| $(p1,d3,h2)$ | -0.814 |
| $(p2,d0,h2)$ | 1.189 |
| $(p2,d2,h2)$ | 0.727 |
| $(p2,d3,h2)$ | 11.314 |

### Reading

- The bivariate output--capital system produces no admissible specifications.
- The trivariate rank-one system produces six admissible specifications.
- The retained trivariate set is narrow and uneven.
- Most retained values remain near the single-equation neighborhood, but one retained value is extreme.
- The result supports distributional conditioning, not a completed theory of distributional determination.

![Figure 6. Capacity utilization and exploitation rate, U.S. corporate sector, 1947--2011.](figures/fig_S2_focal_cu_exploitation.pdf)

**Figure 6. Capacity utilization and exploitation rate, U.S. corporate sector, 1947--2011.** The figure compares the VECM-implied utilization path with Shaikh’s benchmark, the Federal Reserve utilization series, and the exploitation rate. The retained admissible system links constructed utilization to exploitation, but the figure should not be read as proving a stable reserve-army law.

### S2 takeaway

- The bivariate output--capital system does not survive.
- A restricted trivariate rank-one system including exploitation does.
- The capacity relation is not reducible to output and capital alone.

---

## 4.6 Cross-Stage Synthesis

| Stage | Result | Bound |
|---|---|---|
| S0 | Approximate single-equation recovery | Not admissibility-secured |
| S1 | Non-empty admissible ARDL space | Non-unique retained benchmark |
| S2 bivariate | Zero admissible specifications | Output--capital system not self-sufficient |
| S2 trivariate rank one | Six admissible specifications | Restricted survival with exploitation |
| S2 trivariate rank two | Zero admissible specifications | No retained rank-two system |

### Main conclusion

- The replication does not refute Shaikh’s strategy.
- It sharpens its conditions.
- Shaikh’s benchmark is recoverable, but not uniquely secured.
- The single-equation route produces a family of admissible reconstructions.
- The system-level test shows that the bivariate output--capital relation does not survive.
- A restricted trivariate rank-one system including exploitation does survive.

### Final formulation

- Estimating an unbalanced-growth parameter is feasible.
- The recovered capacity relation is:
  - fragile;
  - non-unique;
  - distributionally conditioned.

### Transition implication

- Productive-capacity estimation cannot be treated as a purely technical output--capital problem.
- Distribution must enter as part of the structural problem, not as an interpretation appended after the capacity benchmark is estimated.