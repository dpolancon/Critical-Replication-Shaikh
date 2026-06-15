# Chapter 1 — Critical Replication Studies: Executive Brief

## Core empirical problem

Capacity utilization is not directly observed. Actual output is observed; productive capacity is not. The empirical task is therefore to estimate a productive-capacity benchmark and construct utilization as:

$$
\hat{\mu}_t = \frac{Y_t}{\hat{Y}^p_t}.
$$

Shaikh’s contribution is not the choice of a better utilization proxy. His strategy estimates productive capacity from a long-run output--capital relation grounded in profitability accounting. This chapter accepts the importance of that route, but shifts the object of scrutiny from the constructed utilization path to the coefficient that generates the capacity path.

Read through the unbalanced-growth framework, that coefficient is a candidate transformation elasticity, $\theta$, linking capital accumulation to the formation of productive capacity.

## Identification relation

The baseline relation is:

$$
y_t = a + bt + \theta k_t + \sum_j c_jD_{j,t} + \varepsilon_t.
$$

From this relation, the estimated productive-capacity path is:

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
\right),
$$

and utilization is constructed as $\hat{\mu}_t = Y_t/\hat{Y}^p_t$.

The identification burden therefore falls on $\theta$: if it measures the transformation of accumulation into productive capacity, its stability, uniqueness, and admissibility cannot simply be assumed.

## Three-stage critical replication

| Stage | Question | Main result | Interpretation |
|---|---|---|---|
| **S0: ARDL reconstruction** | Can Shaikh’s benchmark be approximately reconstructed? | Case 2 gives $\hat{\theta}=0.836$, but no PSS case passes the F-bounds screen at 10%. | The benchmark is approximately recoverable, but not admissibility-secured. |
| **S1: ARDL specification geometry** | Is the single-equation benchmark unique? | 65 admissible specifications; 11-specification Pareto envelope; Shaikh baseline marked inadmissible. | The single-equation route remains viable, but produces a family of admissible paths, not one settled benchmark. |
| **S2: VECM system test** | Does the relation survive as a joint system? | Bivariate output--capital system: 0 admissible. Trivariate rank-one system with exploitation: 6 admissible. | The capacity relation is not self-sufficient as output--capital alone; it survives only when exploitation enters explicitly. |

## Main empirical finding

Shaikh’s capacity-utilization benchmark can be approximately reconstructed in single-equation form, but it is not uniquely secured. Once the relation is estimated as a joint system, the bivariate output--capital specification does not survive the admissibility screen, while a restricted trivariate rank-one system including exploitation does.

## Boundaries of the claim

The replication does **not** show that Shaikh’s strategy fails. It shows that the strategy is fragile.

It does **not** show that the utilization benchmark is arbitrary. It shows that the benchmark is closure-sensitive and non-unique.

It does **not** prove a completed theory of distributional determination. It shows that the retained capacity relation is distributionally conditioned.

## Figure sequence

1. **Net-to-gross capital-stock ratio:** shows why capital-stock construction matters for the estimated capacity benchmark.
2. **S0 utilization fan:** shows approximate reconstruction and closure sensitivity.
3. **S1 IC tangencies:** shows that different criteria select different retained specifications.
4. **S1 $\hat{\theta}$ distribution and utilization fan:** shows non-uniqueness of the estimated benchmark.
5. **S2 pooled VECM frontier:** shows that only trivariate rank-one specifications survive.
6. **S2 utilization and exploitation:** shows that the retained system links constructed utilization to exploitation without proving a full reserve-army law.

## Dissertation implication

The estimation of an unbalanced-growth parameter is feasible, but the recovered capacity relation is fragile, non-unique, and distributionally conditioned. Productive-capacity estimation therefore cannot be treated as a purely technical output--capital problem. Distribution must enter as part of the structural problem, not as an interpretation appended after the capacity benchmark has already been estimated.