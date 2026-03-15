# Clarification Report v1: GPIM, Government Assets, and Corporate Sector Scope

---

## Q1. GPIM Implementation by Asset Type

### Summary

The Geometric Perpetual Inventory Method (GPIM) is applied at **three levels of
aggregation** across the pipeline, each with different service lives, retirement rates,
and accumulation logic.

### 1A. Private Sector: Per-Asset GPIM (`44_build_kstock_private.R`)

GPIM is applied **separately to each of four asset types**, each with its own BEA
service life and declining-balance rate.

| Asset | Code | Service Life (L) | DB Rate | Ret Rate (1/L) | Dep Rate (DB/L) |
|-------|------|-------------------|---------|----------------|-----------------|
| Equipment | ME | 15 years | 1.65 | 0.0667 | 0.1100 |
| Structures | NRC | 38 years | 0.91 | 0.0263 | 0.0239 |
| Residential | RC | 50 years | 1.14 | 0.0200 | 0.0228 |
| Intellectual Property | IP | 5 years | 1.65 | 0.2000 | 0.3300 |

Source: `bea_service_life_params()` in `97_kstock_helpers.R:392-405`.

**Formulas applied per asset:**

1. **Implicit own-price deflator** (from BEA current-cost and chain-QI stocks):
   ```
   p^K_t = K^cc_t / K^chain_t,    rebased so p^K(2017) = 1.0
   ```

2. **Single deflation** (SFC-preserving, eq. 5):
   ```
   K^R_t = K^cc_t / p^K_t
   IG^R_t = IG^cc_t / p^K_t
   D^R_t = D^cc_t / p^K_t
   ```
   All three series deflated by the SAME own-price index. This preserves the
   stock-flow identity `K^R_t = K^R_{t-1} + IG^R_t - D^R_t` by construction.

3. **Depreciation rate** (theoretically correct, eq. 6):
   ```
   z_t = D^cc_t / (p^K_t * K^R_{t-1})
   ```

4. **Net stock forward accumulation** (eq. 5 with depreciation rate):
   ```
   K^R_net_t = IG^R_t + (1 - z_t) * K^R_net_{t-1}
   ```

5. **Gross stock forward accumulation** (eq. 5 with retirement rate):
   ```
   K^R_gross_t = IG^R_t + (1 - 1/L) * K^R_gross_{t-1}
   ```

6. **Initial gross stock** (steady-state approximation):
   ```
   K^G_0 = K^net_0 * (dep_rate / ret_rate)
   ```

7. **Retirement flows** (implied):
   ```
   Ret^R_t = (1/L) * K^R_gross_{t-1}
   ```

8. **Current-cost accumulation** (eq. 3, with survival-revaluation factor):
   ```
   z*_t = (1 - z_t) * (p^K_t / p^K_{t-1})
   K^cc_t = IG^cc_t + z*_t * K^cc_{t-1}
   ```

**Aggregation**: Current-cost and GPIM-real stocks are additive across assets.
Chain-weighted stocks are NOT additive (Whelan 2002 critique, notation.md section 2).

**SFC validation**: Each asset's net and gross stocks are validated against the
identity `K_t = K_{t-1} + I_t - D_t` (or `- Ret_t` for gross), with a tolerance
of 0.1% (`GDP_CONFIG$GPIM$sfc_tolerance = 0.001`).

**Convergence diagnostics**: For each asset, the script computes:
- Critical rate: `z* = g_pK / (1 + g_pK)` (eq. 15)
- Half-life: `tau_half = ln(2) / ln(1/z*)` (eq. 16)
- Regime classification: CONVERGENT if `z_avg > z*`

### 1B. Corporate Sector: Aggregate GPIM (`52_build_corp_kstock.R`)

GPIM is applied as a **single aggregate** for the corporate sector, NOT per-asset.

| Parameter | Value | Source |
|-----------|-------|--------|
| Service life (L_corp) | 35 years | Shaikh (2016) Appendix 6.8 |
| Retirement rate | 1/35 = 0.02857 | Uniform discard approximation |
| Depreciation rate | Time-varying dcorp(t) | BEA + eq. 6 (default) |

**Three toggle-able adjustments** (defined in `CORP_ADJ`, lines 33-37):

| Toggle | Default | Effect |
|--------|---------|--------|
| ADJ_1: BEA 1993 depletion | TRUE | Uses theoretically correct z_t (eq. 6) vs. Whelan-Liu (eq. 8) |
| ADJ_2: BEA 1993 initial | TRUE | Scales initial K by IRS/BEA ratio 0.793 |
| ADJ_3: IRS scrapping | FALSE | Great Depression book-value correction (requires missing `irs_book_value.csv`) |

**Net stock accumulation** (same formula as 1A, but with aggregate depreciation):
```
dcorp(t) = DEPCcorp(t) / (pKN(t)/100 * KNR_{t-1})     [ADJ_1 ON: eq. 6]
dcorp(t) = DEPCcorp(t) / KNC_{t-1}                      [ADJ_1 OFF: eq. 8, biased]

K^R_net_t = IGR_t + (1 - dcorp_t) * K^R_net_{t-1}
K^cc_net_t = K^R_net_t * (pKN_t / 100)
```

**Gross stock accumulation** (same formula, retirement rate):
```
K^G_0 = K^net_0 * (median(dcorp) / ret_corp)
K^R_gross_t = IGR_t + (1 - 1/35) * K^R_gross_{t-1}
K^cc_gross_t = K^R_gross_t * (pKN_t / 100)
```

**Deflator**: Own-price implicit deflator for corporate K:
```
KNR = chain_QI_index * KNC(base_year) / 100
pKN = (KNC / KNR) * 100
```

### 1C. Private vs. Corporate Comparison

| Aspect | Private (44) | Corporate (52) |
|--------|-------------|----------------|
| Granularity | Per-asset (ME, NRC, RC, IP) | Aggregate (L=35) |
| Service lives | 4 different (5-50 yr) | 1 aggregate (35 yr) |
| Depreciation rate | Per-asset from BEA | Aggregate from BEA |
| Gross stock | Full GPIM forward accumulation | Full GPIM forward accumulation |
| SFC validation | Per-asset check | Aggregate check |
| Shaikh adjustments | 4 toggles (script 46) | 3 toggles (in-script) |

---

## Q2. Government Assets: Treatment Under GPIM

### Summary

Government assets receive **partial GPIM treatment**: single-deflation for net stocks
(SFC-preserving), but only an **approximate** gross stock — NOT a full
forward-accumulated GPIM gross stock.

### 2A. What the Government Pipeline Does (`45_build_kstock_government.R`)

**Data source**: BEA Fixed Assets Section 7, Tables 7.1-7.4 (FAAt701-704)

> **Note**: The config previously mapped `govt_*` to FAAt601-604 (which are actually
> Section 6: Private FA by Legal Form). This was corrected to FAAt701-704 (Section 7:
> Government Fixed Assets) in the API code fix commit.

**Asset breakdown**: 8 sub-categories, extracted by line number:

| Asset | Line | Description |
|-------|------|-------------|
| Defense_Total | 2 | National defense (total) |
| Defense_NRC | 3 | National defense: Structures |
| Defense_ME | 4 | National defense: Equipment |
| Defense_IP | 5 | National defense: IP products |
| Nondefense_Total | 6 | Nondefense (total) |
| Nondefense_NRC | 7 | Nondefense: Structures |
| Nondefense_ME | 8 | Nondefense: Equipment |
| Nondefense_IP | 9 | Nondefense: IP products |

**GPIM operations applied:**

1. **Own-price implicit deflator**: `p_K = K_net_cc / K_net_chain`, rebased to 2017=1.0
2. **Single deflation** (SFC-preserving): `K_net_real = K_net_cc / p_K` (same for IG, D)
3. **SFC validation**: Implicit in the GPIM deflation — identity holds by construction

**Gross stock — APPROXIMATE only:**
```r
K_gross_cc = K_net_cc + D_cc       # line 149-150 in script
```

This is a **one-period approximation**, NOT a forward-accumulated GPIM gross stock
using retirement rates (as done for private and corporate assets). The full GPIM gross
stock would require:
```
K^G_t = IG_t + (1 - 1/L_govt) * K^G_{t-1}
```
with a government-specific service life. This is not implemented.

### 2B. Why Government Gets Simplified Treatment

1. **No per-asset service lives defined** for government sub-categories in the config.
   `bea_service_life_params()` only covers ME, NRC, RC, IP for private assets.
2. Government capital typically has different service lives (military equipment may
   have shorter lives; government structures may be longer-lived).
3. The primary analytical focus of this project is the **corporate sector** (Shaikh
   2016 Chapter 6), making detailed government GPIM a lower priority.
4. Government capital enters the total economy aggregation (`47_assemble_dataset.R`)
   but is not the subject of the cointegration analysis (scripts 20-24).

### 2C. Government in Total Economy Assembly

The government K stocks are combined with private K stocks in `47_assemble_dataset.R`
via simple addition (current-cost):
```
K_total_cc = K_private_cc + K_govt_cc
```

Government capital does NOT receive the Shaikh adjustments from script 46
(Depression scrapping, WWII interpolation, GPIM deflation toggle, quality critique).

---

## Q3. Nonfinancial Domestic Corporate Capital Stock

### Summary

The current pipeline defines the **corporate sector as ALL corporate business**
(financial + nonfinancial combined). A nonfinancial-only breakdown is **partially
available** from BEA data but not yet extracted.

### 3A. What Exists Now

**Output flow** (from NIPA Table 1.14 = T11400, script 51):

The script currently extracts **lines 1-11 only**, which cover **"Domestic Corporate
Business"** — this is ALL corporate (financial + nonfinancial combined):

| Line | Variable | Description |
|------|----------|-------------|
| 1 | GVAcorpnipa | Gross Value Added, domestic corporate |
| 2 | DEPCcorp | Consumption of fixed capital, corporate |
| 3 | VAcorpnipa | Net Value Added, corporate |
| 4 | ECcorp | Compensation of employees, corporate |
| 7 | Tcorp | Taxes on production and imports |
| 8 | NOScorpnipa | Net Operating Surplus, corporate |
| 11 | Pcorpnipa | Corporate profits with IVA + CCAdj |

**Capital stock** (from BEA Fixed Assets Tables 6.1-6.4 = FAAt601-604, script 52):

The script extracts the first line matching `"corporate"` in the line descriptions
of Section 6 tables. Section 6 = "Private Fixed Assets by Industry Group and Legal
Form of Organization." The "Corporate business" line captures ALL corporate entities.

**Exploitation and profit** (script 53): Ratios derived from the above — implicitly
all-corporate scope.

### 3B. What NIPA Table 1.14 Actually Contains

The full title is: **"Gross Value Added of Domestic Corporate Business in Current
Dollars AND Gross Value Added of Nonfinancial Domestic Corporate Business in Current
and Chained Dollars"**

The table has TWO sections:

| Section | Lines (approx.) | Scope |
|---------|----------------|-------|
| Section A | 1-12 | Domestic Corporate Business (ALL corporate) |
| Section B | 13+ | **Nonfinancial Domestic Corporate Business** |

Section B mirrors Section A's structure but restricted to the nonfinancial subsector.
FRED series for the nonfinancial corporate subset include:

| FRED ID | Description |
|---------|-------------|
| A455RC1A027NBEA | Gross value added, nonfinancial corporate |
| B456RC | CFC, nonfinancial corporate |
| B461RC | Wages and salaries, nonfinancial corporate |

**Key implication**: The nonfinancial corporate output flow (GVA, NVA, EC, NOS, etc.)
IS available from the same NIPA table already fetched — it just requires extracting
the higher-numbered lines (13+).

### 3C. What About Nonfinancial Corporate Capital Stock?

BEA Fixed Assets Section 6 tables (FAAt601-604) organize data by **Industry Group AND
Legal Form**. The industry-group dimension provides:

- All private → Corporate business → **Financial industries** vs. **Nonfinancial industries**

The "Nonfinancial corporate" sub-line exists within these tables at a higher line number
than the "Corporate business" total line. The exact line number must be validated at
runtime (the `load_corp_line()` function in script 52 searches for `"corporate"` in
line descriptions but currently takes the **first** match, which is "Corporate business"
total).

**To extract nonfinancial corporate K**, the script would need to:
1. Search for lines containing `"nonfinancial"` AND `"corporate"` in Section 6 tables
2. Or search for the specific line description pattern used by BEA (e.g.,
   `"Nonfinancial"` as a sub-line under `"Corporate business"`)

### 3D. Can We Build Nonfinancial Corporate from Current Data?

**Yes, with modifications.** Here is the assessment:

| Component | Available? | Source | Action Required |
|-----------|-----------|--------|-----------------|
| GVA (NFC) | YES | NIPA T1.14 lines 13+ | Extract higher-numbered lines in script 51 |
| NVA (NFC) | YES | NIPA T1.14 lines 13+ | Same |
| EC (NFC) | YES | NIPA T1.14 lines 13+ | Same |
| NOS (NFC) | YES | NIPA T1.14 lines 13+ | Same |
| CFC (NFC) | YES | NIPA T1.14 lines 13+ | Same |
| K_net (NFC) | LIKELY | FAAt601 sub-line | Validate line number for "Nonfinancial corporate" |
| K_chain (NFC) | LIKELY | FAAt602 sub-line | Same |
| DEP (NFC) | LIKELY | FAAt604 sub-line | Same |
| IG (NFC) | LIKELY | FAAt607 sub-line | Same |
| K_gross (NFC) | BUILDABLE | GPIM from above | Apply GPIM with NFC-specific parameters |

**Corresponding output flow for nonfinancial corporate K:**
The natural pairing is GVA_nfc (from NIPA T1.14 Section B) with K_nfc (from FAAt601
nonfinancial corporate line). The output-capital ratio `R_nfc = GVA_nfc / K_nfc`
is the key variable for the cointegration analysis.

### 3E. Shaikh's Original Scope

Shaikh (2016) Chapter 6 uses "corporate" as an aggregate. The canonical dataset
(`Shaikh_canonical_series_v1.csv`) has 32 columns with no financial/nonfinancial
distinction. The `VAcorp`, `KGCcorp`, `exploit_rate` etc. all refer to the corporate
aggregate.

However, the imputed interest adjustment in script 51 already uses **nonfinancial
corporate** interest data from NIPA T7.11:
- Line 53: Nonfinancial corporate imputed interest paid
- Line 74: Nonfinancial corporate imputed interest received

This creates a **scope mismatch**: the interest adjustment is nonfinancial-specific
but applied to all-corporate GVA. This is consistent with Shaikh's method (the
adjustment removes financial intermediation from the corporate aggregate), but it
means the resulting `VAcorp` is not purely all-corporate nor purely nonfinancial
corporate — it is a hybrid.

---

## Q4. Summary of Gaps and Recommendations

### Confirmed Correct
- GPIM per-asset implementation for private sector (4 asset types, full SFC)
- GPIM aggregate implementation for corporate sector (L=35, 3 toggles, full SFC)
- NIPA table codes (T11400, T71100, T10104) — corrected in prior commit
- BEA Fixed Assets Section 6 = Private FA by Legal Form (not government)

### Gaps Identified

| Gap | Severity | Description |
|-----|----------|-------------|
| Government gross K is approximate | Low | Uses `K_gross = K_net + D`, not full GPIM forward accumulation |
| No nonfinancial corporate split | Medium | Pipeline extracts all-corporate, but NFC data is available in same BEA tables |
| Interest adjustment scope mismatch | Low | NFC interest adjustment applied to all-corporate GVA (matches Shaikh's method) |
| Government table codes untested | Medium | FAAt701-704 mapping is corrected in config but never runtime-validated |
| NIPA T1.14 line numbers hardcoded | Low | Lines 1-11 assumed for all-corporate; NFC lines (13+) not yet discovered |

### Recommended Next Steps

1. **Runtime discovery of NFC lines**: Add a `discover_nfc_lines()` function that
   searches NIPA T1.14 and FAAt601-604 for lines containing `"nonfinancial"` to
   confirm availability and exact line numbers.

2. **Dual-scope extraction**: Modify scripts 51-52 to extract BOTH all-corporate
   (lines 1-11) AND nonfinancial corporate (lines 13+) series, storing both in
   the output dataset with clear column naming (`GVAcorp` vs `GVAcorp_nfc`).

3. **Government gross K upgrade** (optional): Implement full GPIM forward accumulation
   for government assets with government-specific service lives, if needed for
   total-economy analysis.

---

*Clarification Report v1 | 2026-03-15*
*Files examined: `97_kstock_helpers.R`, `44_build_kstock_private.R`,
`45_build_kstock_government.R`, `46_shaikh_adjustments.R`, `50_fetch_bea_corporate.R`,
`51_build_corp_output.R`, `52_build_corp_kstock.R`, `53_build_corp_exploitation.R`,
`54_assemble_corp_dataset.R`, `40_gdp_kstock_config.R`*
