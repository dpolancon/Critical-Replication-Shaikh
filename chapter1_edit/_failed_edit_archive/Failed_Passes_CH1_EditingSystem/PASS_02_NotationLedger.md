# PASS 02 Notation Ledger

Notation lock:

- `d` = long-run output-capital coefficient recovered from the empirical level relation.
- `\hat{d}` = estimated empirical coefficient.
- `\theta` = theoretical transformation elasticity of productive capacity with respect to capital.
- `\hat{\theta}` = interpretation of `\hat{d}` as an estimated candidate transformation elasticity after the theoretical mapping is stated.
- `b` = deterministic trend / autonomous growth component in the trend-stabilized closure.
- `c` = coefficient governing the dependence of the normal capacity-capital ratio on capital.
- `Y^p_t` = productive capacity.
- `\mu_t` = true latent capacity utilization.
- `\hat{\mu}_t` = constructed utilization index.

| Symbol | Location | Current meaning | Intended meaning | Issue | Edit required |
|---|---|---|---|---|---|
| `\theta` | Abstract; intro; conceptual framework; S1/S2 results; conclusion | Candidate transformation elasticity and theoretical elasticity | Theoretical transformation elasticity | Mostly correct, but some result claims treated it as directly estimated everywhere | Calibrated prose to make `\hat{d}` the empirical estimate and `\hat{\theta}` the interpretation |
| `\hat{\theta}` | S0 table, S1 IC table, S2 retained table, conclusion | Reported long-run parameter estimates | Estimated candidate transformation elasticity after mapping from `\hat{d}` | Needed economic-admissibility gate | Added S2 classification and conclusion calibration |
| `d` | Eq. `shaikh_regression`; ARDL architecture; S2 deterministic labels | Empirical coefficient; also used as deterministic branch label `d0` etc. | Empirical long-run output-capital coefficient | Conflict with deterministic-case index | Changed generic deterministic index from `c` to `\chi`; clarified `d0` labels are VECM branch labels, not coefficient `d` |
| `\hat{d}` | Eq. for long-run coefficient; fitted capacity path | Estimated long-run coefficient | Estimated empirical coefficient | Needed distinction from `\hat{\theta}` | Revised ARDL paragraph to say `\hat{d}` becomes `\hat{\theta}` only under the chapter's interpretation |
| `b` | Normal capacity-capital relation; trend-stabilized closure | Deterministic trend; autonomous growth component | Deterministic trend / autonomous growth component | Acceptable but needed explicit lock | Added sentence identifying `b` as deterministic trend or autonomous growth component |
| `c` | Normal capacity-capital relation; S1/S2 grid index before edit | Coefficient in `R^n`; deterministic case index | Coefficient governing capital dependence of `R^n_t` | Ambiguous because `c` also indexed deterministic cases | Changed deterministic-case index to `\chi` in S1/S2 grids and table |
| `R^n_t` | Conceptual framework | Unobserved normal capacity-capital ratio | Same | No issue | No equation change |
| `Y^p_t` | Conceptual framework and fitted capacity path | Productive capacity | Same | No issue | No equation change |
| `\mu_t` | Leontief relation and conceptual definitions | True latent capacity utilization | Same | No issue | No equation change |
| `\hat{\mu}_t` | Constructed utilization equation; S1 utilization fan | Constructed utilization index | Same | No issue | No equation change |

Decision: no equation rewrite was required except the notation-index substitutions in the specification grids, because the previous index notation conflicted with the locked meaning of `c`.

