# Methods Brief v0.2.1 — Chapter 1 Critical Replication

Capacity utilization is not directly observed. Actual output is observed; productive capacity is not. The empirical problem is therefore not to choose among inherited utilization measures, but to estimate the productive-capacity benchmark against which observed output can be compared. Capacity utilization is constructed only after that benchmark has been estimated:

$$
\hat{\mu}_t = \frac{Y_t}{\hat{Y}^p_t}.
$$

Shaikh’s contribution begins from this problem. He does not defend the Federal Reserve Board series, the average workweek of capital, or any other utilization measure as the object to be adopted. He shifts the measurement problem into profitability accounting and estimates productive capacity from the long-run relation between output and capital (Shaikh, 2016). Within that route, utilization appears as the deviation of actual output from the capacity path implied by the estimated output–capital relation.

The critical replication developed here accepts the importance of that route but changes the object of scrutiny. In Shaikh’s presentation, the constructed utilization path carries much of the explanatory burden. This chapter asks what is assumed by the coefficient that generates the capacity path in the first place. Once interpreted through unbalanced growth, that coefficient is not merely an econometric parameter. It becomes a candidate transformation elasticity, $\theta$, linking capital accumulation to the formation of productive capacity.

The baseline relation is:

$$
y_t = a + bt + \theta k_t + \sum_j c_j D_{j,t} + \varepsilon_t,
$$

where $y_t$ is log real corporate output, $k_t$ is log real corporate capital stock, $D_{j,t}$ are historical break dummies, and $\varepsilon_t$ is the deviation from the estimated productive-capacity benchmark. The estimated benchmark is:

$$
\hat{Y}^p_t =
\exp\left(
\hat{a} + \hat{b}t + \hat{\theta}k_t + \sum_j \hat{c}_j D_{j,t}
\right).
$$

Estimated utilization is then constructed as:

$$
\hat{\mu}_t = \frac{Y_t}{\hat{Y}^p_t}.
$$

The sequence matters. Output is observed. Productive capacity is estimated. Utilization is constructed. The empirical result depends on the maintained relation, the closure, and the specification choices that make the benchmark estimable.

## 1. From Shaikh’s Estimate to Critical Replication

Shaikh’s original strategy treats the output–capital relation as a single-equation benchmark. Output is modeled conditionally on capital, and the long-run relation is used to construct the productive-capacity path. That is the strength of the approach: it gives capacity utilization an identification route rather than leaving it dependent on inherited survey instruments or physical proxies.

Its limitation is equally specific. The single-equation estimate treats $\theta$ as fixed across the sample. If $\theta$ only indexed a stable technical regularity, that restriction would be less consequential. But if $\theta$ measures the transformation of capital accumulation into productive capacity, then its stability cannot simply be assumed. The coefficient may be sensitive to closure choices, lag structure, deterministic specification, historical breaks, and the absence or presence of distributional variables.

The replication therefore proceeds in three steps. The first asks whether Shaikh’s benchmark can be approximately reconstructed. The second asks whether that reconstruction remains unique once the single-equation specification space is opened. The third asks whether the relation survives when output, capital, and distribution are estimated jointly as a system.

## 2. Stage S0: Single-Equation Reconstruction

Stage S0 asks a narrow question: can Shaikh’s single-equation ARDL benchmark be approximately reconstructed?

The stage estimates the long-run output–capital relation using an ARDL bounds-testing framework (Pesaran et al., 2001). This preserves the basic structure of Shaikh’s implementation: output is modeled conditionally on capital, short-run dynamics are allowed through lagged differences, and the long-run multipliers are used to construct the productive-capacity benchmark.

The relevant object is not only the coefficient $\hat{\theta}$. The stage also produces the implied path of productive capacity and the utilization path constructed from it. The reconstruction is therefore evaluated at two levels: whether the long-run relation can be reproduced, and whether the resulting utilization path approximates the benchmark Shaikh reports.

S0 is a faithful reconstruction test, not a robustness test. A successful S0 result shows that Shaikh’s estimate can be approximately reproduced under a comparable single-equation closure. It does not show that the benchmark is unique, that the coefficient is stable, or that the relation survives once the specification space is widened.

## 3. Stage S1: Opening the Single-Equation Space

Stage S1 asks whether the single-equation benchmark remains unique once the admissible ARDL specification space is opened.

The motivation is straightforward. A single ARDL specification can reproduce a benchmark while hiding the extent to which the result depends on lag order, deterministic terms, and historical dummy structure. Stage S1 therefore estimates a lattice of ARDL specifications rather than treating one model as the privileged empirical object. The lattice varies the output lag order, the capital lag order, the deterministic case, and the subset of historical break dummies.

Each specification still estimates the same economic relation: output is modeled conditionally on capital in order to construct a productive-capacity benchmark. What changes is the set of maintained restrictions under which that benchmark is produced.

The admissibility gate asks whether each specification supports a levels relation. Retained specifications are then compared through information criteria and through the utilization paths they imply. The central output is not a single preferred model but an admissible region: a set of specifications that survive the statistical screen and generate alternative estimates of $\theta$ and $\hat{\mu}_t$.

This stage shifts the analysis from reconstruction to fragility. If the admissible space is non-empty but dispersed, Shaikh’s strategy remains viable but not uniquely secured. The issue is no longer whether the benchmark can be reconstructed. It is whether the reconstruction depends too strongly on the particular single-equation closure selected.

## 4. Stage S2: Estimating the Relation as a System

Stage S2 asks whether the output–capital relation survives when it is estimated jointly rather than conditionally.

The single-equation ARDL framework treats output as the dependent variable and capital as the conditioning variable. That structure is appropriate for reconstructing Shaikh’s benchmark, but it leaves open whether the long-run relation is robust as a system property. If the transformation of capital into productive capacity is shaped by accumulation, distribution, and adjustment dynamics, then the relation should not be tested only as a conditional equation.

The VECM representation is:

$$
\Delta X_t =
\Pi X_{t-1}
+
\sum_i \Gamma_i \Delta X_{t-i}
+
\Phi D_t
+
\varepsilon_t,
$$

with:

$$
\Pi = \alpha \beta'.
$$

Here, $\beta$ contains the long-run relation and $\alpha$ contains the adjustment coefficients. The VECM therefore asks whether a cointegrating relation exists among the variables when their long-run and short-run dynamics are estimated jointly (Johansen, 1991).

S2 estimates two system families. The first is the bivariate output–capital system:

$$
X_t = (y_t, k_t)'.
$$

This system tests whether the output–capital relation survives without an explicit distributional variable. The formulation is deliberate: the bivariate system does not prove that distribution is absent. It only excludes distribution as an explicit system variable.

The second is the trivariate system including exploitation:

$$
X_t = (y_t, k_t, e_t)'.
$$

Here, $e_t$ is the exploitation rate. Its inclusion tests whether the long-run capacity relation survives once distribution enters the system explicitly. This does not prove a complete theory of distributional determination. It asks whether the admissibility of the capacity relation depends on adding the distributional variable that the bivariate system leaves out.

## 5. Admissibility and Interpretation

The VECM stage is governed by an admissibility screen. A retained system must estimate successfully, support the relevant cointegration rank, satisfy the required dynamic conditions, and yield a relation that can be interpreted economically as a capacity relation.

The point of this screen is not to maximize the number of retained specifications. It is to avoid treating every estimated relation as meaningful merely because the software returns coefficients. A system can be statistically estimated and still fail to identify the empirical object at stake. The admissibility screen therefore protects the distinction between a numerical result and an interpretable capacity relation.

This is especially important because the chapter’s claim is bounded. The system exercise does not turn the trivariate relation into a completed theory of distribution. It tests whether the output–capital relation remains admissible when distribution is included explicitly. That is a narrower claim, but a stronger empirical test.

## 6. Why the Three Tests Matter

The three stages clarify what can and cannot be inferred from Shaikh’s capacity-utilization estimate.

S0 asks whether the benchmark can be approximately reconstructed in Shaikh’s own single-equation terms. S1 asks whether that reconstruction remains unique once the admissible ARDL space is opened. S2 asks whether the relation survives when the variables are estimated jointly, first as a bivariate output–capital system and then as a trivariate system including exploitation.

The cross-stage question is not simply whether $\theta$ is numerically stable across estimators. The stronger question is whether the productive-capacity relation remains reproducible, non-arbitrary, and admissible as the empirical structure is widened. Critical replication is therefore more than a computational check. It reconstructs the empirical object, varies the maintained assumptions, and tests whether the capacity benchmark survives increasingly demanding conditions.

The claim remains bounded. The exercise does not settle the theory of capacity utilization. It tests whether Shaikh’s estimated capacity benchmark can be reconstructed, whether it is unique within the single-equation space, and whether it survives system estimation once exploitation is included explicitly.