# Stock-Flow Consistency of the Generalized Perpetual Inventory Method

**Diego Polanco | UMass Amherst | March 2026**

---

## 1. Purpose

This brief documents that Shaikh's Generalized Perpetual Inventory Method
(GPIM) preserves the stock-flow consistency (SFC) condition that national
accounting identities require: nominal output equals the sum of nominal
expenditure components, and the same additive structure must hold when
quantities are deflated into real terms.  The evidence below shows that the
BEA's chain-weighted quantity indexes violate this condition, and the
violation introduces a systematic secular bias into the output-capital ratio
(Y/K) — the central variable in the ARDL cointegrating relationship
estimated by Shaikh (2016).

## 2. The chain-weighting problem

BEA chain-weighted (Fisher-ideal) quantity indexes are *non-additive*.
Real GDP does not equal the sum of real expenditure components.  This
non-additivity propagates into the perpetual inventory identity

    K_t = K_{t-1} + I_t − D_t

because real investment I_t (chain-weighted) is not consistent with the
change in the real capital stock K_t (also chain-weighted, but via a
different aggregation path).  The wedge between the two grows over time
whenever relative prices shift — precisely the condition met by the
hedonic-price revolution in IT equipment after the mid-1980s.

Shaikh's GPIM avoids this by deflating *all* nominal magnitudes — output,
investment, depreciation, and the capital stock — with a single
investment-goods price deflator.  Additive consistency is preserved by
construction.

## 3. Evidence from the data

The file `csv/capital_ratio_analysis.csv` contains the output-capital ratio
under three deflation regimes (GPIM, chain-weighted, and nominal
current-cost) for the US economy, 1929–2024 (T = 96).

### 3.1 Log divergence

The log divergence

    δ_t  ≡  ln(Y/K)_GPIM  −  ln(Y/K)_chain

measures the cumulative effect of the deflation regime on the Y/K trend.
Over the full sample:

| Statistic | Value |
|-----------|-------|
| Full-sample trend | −0.0164 per decade |
| 1947 value | −11.07 |
| 2024 value | −11.21 |
| Range | [−11.34, −10.85] |

The divergence is *not* constant.  It widens from −10.85 in 1953 to −11.34
in 1934, narrows during WWII, then trends downward again after 1973.
Post-1985 the drift reverses modestly (+0.015/decade), reflecting the
stabilization of relative asset prices after the initial hedonic shock.

The key implication: chain-weighted capital stocks grow *faster* than
GPIM-deflated stocks over any period in which the investment-goods deflator
falls relative to the GDP deflator.  This inflates K relative to Y and
biases Y/K downward — a spurious signal of capital deepening that does not
correspond to any real accumulation dynamic.

### 3.2 Index comparison (1947 = 1)

Indexing both Y/K series to 1947 = 1 makes the trend divergence visible
despite the large level difference (the GPIM Y/K is in real units per
current-cost dollar of capital, hence tiny in absolute terms):

- GPIM Y/K rises from 1.00 (1947) to 2.15 (2024) — a doubling.
- Chain Y/K rises from 1.00 (1947) to 2.47 (2024) — a steeper path.

The chain-weighted series overshoots because it underdeflates the capital
stock in periods of falling relative equipment prices.

See: `figures/fig_yk_gpim_vs_chain.{png,pdf}`

### 3.3 Period trends

Under GPIM deflation the log output-capital ratio shows:

- **Fordism (1947–1973)**: rising Y/K (capital-saving technical change).
- **Post-Fordism (1974–2011)**: declining Y/K (capital deepening dominates
  output growth).

These trends are qualitatively consistent with Shaikh's (2016) periodization
and with the classical-Marxian prediction that the output-capital ratio
exhibits long swings rather than a monotonic trend.

See: `figures/fig_yk_period_trends.{png,pdf}`

## 4. Implication for the critical replication

The ARDL model in Shaikh (2016) estimates a cointegrating relationship
between log output (lnY) and log capital (lnK).  The long-run coefficient θ
is the elasticity of output with respect to capital — equivalently, the
long-run Y/K ratio in log-linear form.

If the capital stock is measured under a deflation regime that does not
preserve SFC, the residual of the cointegrating equation absorbs the
deflator-wedge drift.  This can:

1. Bias θ toward values that reflect relative-price artifacts rather than
   real production technology.
2. Weaken or destroy the cointegration finding by injecting a deterministic
   trend into what should be a stationary residual.

Shaikh's use of current-cost gross capital (KGCcorp, deflated by the
BEA investment deflator pIGcorpbea) is equivalent to GPIM deflation for
the corporate sector.  The SFC condition holds by construction, and the
cointegrating residual is free of deflator-regime artifacts.

## 5. Figures

| Figure | Description |
|--------|-------------|
| `fig_yk_gpim_vs_chain` | Y/K indexed to 1947=1 under GPIM and chain-weighted deflation |
| `fig_ln_divergence` | Log divergence δ_t with linear trend overlay |
| `fig_yk_period_trends` | ln(Y/K) under GPIM with Fordism and Post-Fordism trend lines |

## 6. Data source

`csv/capital_ratio_analysis.csv` — generated by
`codes/out_pipeline/49_capital_ratio_analysis.R` from the master dataset
assembled by the 40-series GDP/capital-stock pipeline.

---

*End of brief.*
