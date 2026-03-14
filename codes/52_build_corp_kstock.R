############################################################
# 52_build_corp_kstock.R — Build Corporate Capital Stock
#
# Implements Shaikh's GPIM for corporate K stock with three
# toggle-able adjustments:
#   ADJ_1: BEA 1993 depletion rates (dcorpstar vs Whelan-Liu)
#   ADJ_2: BEA 1993 initial values (scale by IRS/BEA ratio)
#   ADJ_3: IRS book value correction (Great Depression scrapping)
#
# Source authority:
#   Shaikh (2016) Appendix 6.8, Tables II.1-II.5
#   GPIM_Formalization_v3.md §1, §6
#
# Output: data/processed/corp_kstock_series.csv
#
# Requires: dplyr, readr
# Sources:  40_gdp_kstock_config.R, 99_utils.R, 97_kstock_helpers.R
############################################################

rm(list = ls())

library(dplyr)
library(readr)

source(here::here("codes/40_gdp_kstock_config.R"))
source(here::here("codes/99_utils.R"))
source(here::here("codes/97_kstock_helpers.R"))

## ----------------------------------------------------------
## Adjustment toggles
## ----------------------------------------------------------

CORP_ADJ <- list(
  ADJ1_BEA1993_DEPLETION = TRUE,    # Use dcorpstar (eq. 6) vs Whelan-Liu (eq. 8)
  ADJ2_BEA1993_INITIAL   = TRUE,    # Scale 1925 initial value by IRS/BEA ratio ~0.793
  ADJ3_IRS_SCRAPPING     = FALSE    # IRS book value correction (needs external file)
)

cat("=== CORPORATE CAPITAL STOCK CONSTRUCTION ===\n")
cat(sprintf("ADJ_1 (BEA 1993 depletion rates):   %s\n", CORP_ADJ$ADJ1_BEA1993_DEPLETION))
cat(sprintf("ADJ_2 (BEA 1993 initial values):     %s\n", CORP_ADJ$ADJ2_BEA1993_INITIAL))
cat(sprintf("ADJ_3 (IRS Depression scrapping):     %s\n", CORP_ADJ$ADJ3_IRS_SCRAPPING))

## ----------------------------------------------------------
## Corporate retirement rate (GPIM §1)
## Shaikh uses L_corp ≈ 35 years for corporate aggregate
## ----------------------------------------------------------

L_corp   <- 35
ret_corp <- 1 / L_corp  # = 0.02857

cat(sprintf("\nCorporate service life: %d years\n", L_corp))
cat(sprintf("Corporate retirement rate: %.4f\n", ret_corp))

## ----------------------------------------------------------
## Load BEA Fixed Assets data (corporate lines)
## ----------------------------------------------------------

load_corp_line <- function(table_label, var_name) {
  path <- file.path(GDP_CONFIG$INTERIM_BEA_PARSED,
                    sprintf("%s.csv", table_label))
  stopifnot(file.exists(path))
  df <- read_csv(path, show_col_types = FALSE)

  ## Find corporate line (search for "corporate" in line_desc)
  corp_lines <- df |>
    filter(grepl("corporate", line_desc, ignore.case = TRUE)) |>
    distinct(line_number, line_desc)

  if (nrow(corp_lines) == 0) {
    stop(sprintf("No 'corporate' line found in %s. Available lines:\n%s",
                 table_label,
                 paste(sprintf("  %d: %s",
                               (df |> distinct(line_number, line_desc))$line_number,
                               (df |> distinct(line_number, line_desc))$line_desc),
                       collapse = "\n")))
  }

  ## Use first corporate match (typically line 9)
  corp_ln <- corp_lines$line_number[1]
  cat(sprintf("  %s -> line %d: '%s'\n",
              table_label, corp_ln, corp_lines$line_desc[1]))

  series <- df |>
    filter(line_number == corp_ln) |>
    select(year, !!var_name := value) |>
    arrange(year)

  series
}

cat("\n--- Extracting corporate lines ---\n")
KNCcorpbea_df  <- load_corp_line("corp_net_cc",    "KNCcorpbea")
KNRIndx_df     <- load_corp_line("corp_net_chain", "KNRIndxcorpbea")
KNHcorpbea_df  <- load_corp_line("corp_net_hist",  "KNHcorpbea")
DEPCcorp_df    <- load_corp_line("corp_dep_cc",    "DEPCcorp_fa")
IGCcorpbea_df  <- load_corp_line("corp_inv_cc",    "IGCcorpbea")

## Merge all BEA series
bea <- KNCcorpbea_df |>
  left_join(KNRIndx_df, by = "year") |>
  left_join(KNHcorpbea_df, by = "year") |>
  left_join(DEPCcorp_df, by = "year") |>
  left_join(IGCcorpbea_df, by = "year") |>
  arrange(year) |>
  filter(!is.na(KNCcorpbea), !is.na(IGCcorpbea))

cat(sprintf("\nMerged BEA corporate data: %d observations, %d-%d\n",
            nrow(bea), min(bea$year), max(bea$year)))

## ----------------------------------------------------------
## Deflator construction (Shaikh Appendix 6.8, Table II.1)
## ----------------------------------------------------------

## Real net stock: KNRcorpbea = chain QI index × KNCcorpbea[base_year] / 100
## Chain QI is index with base year = 100
base_year_chain <- 2012  # BEA chain QI typically uses 2012=100; validate below

## Detect the base year: find year where chain QI index ≈ 100
chain_base_candidates <- bea |>
  mutate(diff_from_100 = abs(KNRIndxcorpbea - 100)) |>
  filter(diff_from_100 < 1) |>
  arrange(diff_from_100)

if (nrow(chain_base_candidates) > 0) {
  base_year_chain <- chain_base_candidates$year[1]
  cat(sprintf("Detected chain QI base year: %d (index = %.2f)\n",
              base_year_chain, chain_base_candidates$KNRIndxcorpbea[1]))
} else {
  cat(sprintf("WARNING: No year with chain QI ≈ 100 found. Using %d as base.\n",
              base_year_chain))
}

## Convert chain QI index to levels (constant base_year_chain dollars)
KNCcorpbea_base <- bea$KNCcorpbea[bea$year == base_year_chain]
if (length(KNCcorpbea_base) == 0) {
  stop(sprintf("Base year %d not found in data", base_year_chain))
}

bea <- bea |>
  mutate(
    ## Real net stock in constant base_year_chain dollars
    KNRcorpbea = KNRIndxcorpbea * KNCcorpbea_base / 100,

    ## Implicit price deflator for net corporate K stock
    ## pKN = (KNCcorpbea / KNRcorpbea) * 100
    pKN = (KNCcorpbea / KNRcorpbea) * 100
  )

cat(sprintf("pKN range: [%.2f, %.2f]\n",
            min(bea$pKN, na.rm = TRUE), max(bea$pKN, na.rm = TRUE)))

## ----------------------------------------------------------
## Depreciation rate construction
## ----------------------------------------------------------

bea <- bea |>
  mutate(
    KNRcorpbea_lag = lag(KNRcorpbea),
    KNCcorpbea_lag = lag(KNCcorpbea)
  )

if (CORP_ADJ$ADJ1_BEA1993_DEPLETION) {
  ## ADJ_1: Theoretically correct depreciation rate (eq. 6)
  ## dcorpstar(t) = DEPCcorp(t) / (pKN(t)/100 * KNRcorpbea(t-1))
  cat("\nUsing ADJ_1: BEA 1993 theoretically correct depreciation rate (dcorpstar)\n")
  bea <- bea |>
    mutate(
      dcorp = gpim_depreciation_rate(DEPCcorp_fa, pKN / 100, KNRcorpbea_lag)
    )
} else {
  ## Whelan-Liu approximation (eq. 8)
  ## dcorp_WL(t) = DEPCcorp(t) / KNCcorpbea(t-1)
  cat("\nUsing Whelan-Liu approximate depreciation rate\n")
  bea <- bea |>
    mutate(
      dcorp = gpim_whelan_liu_rate(DEPCcorp_fa, KNCcorpbea_lag)
    )
}

cat(sprintf("dcorp median: %.4f | range: [%.4f, %.4f]\n",
            median(bea$dcorp, na.rm = TRUE),
            min(bea$dcorp, na.rm = TRUE),
            max(bea$dcorp, na.rm = TRUE)))

## ----------------------------------------------------------
## Net stock accumulation (GPIM eq. 5)
## K^R_net_t = (IGCcorpbea_t / (pKN_t/100)) + (1 - dcorpstar_t) * K^R_net_{t-1}
## ----------------------------------------------------------

## Real investment
bea <- bea |>
  mutate(IGRcorpbea = IGCcorpbea / (pKN / 100))

## Initial value
first_year_idx <- which(!is.na(bea$dcorp))[1]
if (is.na(first_year_idx)) first_year_idx <- 2  # skip first row (no lag)

## For GPIM, we need an initial real net stock value
## Use the BEA value from the first available year
K0_R_net <- bea$KNRcorpbea[first_year_idx - 1]

if (CORP_ADJ$ADJ2_BEA1993_INITIAL) {
  ## ADJ_2: Scale initial value by IRS/BEA ratio ≈ 0.793
  ## (Shaikh 1947 KNCcorp ≈ 77.77 vs BEA KNCcorpbea ≈ 98.1, ratio ≈ 0.793)
  irs_bea_ratio <- 0.793
  K0_R_net_adj <- K0_R_net * irs_bea_ratio
  cat(sprintf("\nADJ_2: Scaling initial real net stock by %.3f\n", irs_bea_ratio))
  cat(sprintf("  K0_R_net (BEA):     %.2f\n", K0_R_net))
  cat(sprintf("  K0_R_net (adjusted): %.2f\n", K0_R_net_adj))
  K0_R_net <- K0_R_net_adj
}

## ADJ_3: IRS scrapping (skip if file unavailable)
if (CORP_ADJ$ADJ3_IRS_SCRAPPING) {
  irs_path <- here::here("data/raw/irs_book_value.csv")
  if (file.exists(irs_path)) {
    cat("\nADJ_3: Applying IRS book value correction...\n")
    irs <- read_csv(irs_path, show_col_types = FALSE)
    ## TODO: Implement IRS/BEA ratio correction for 1925-1947
    ## For now, skip
    cat("ADJ_3: IRS correction not yet implemented.\n")
  } else {
    cat("\nADJ_3 skipped: IRS book value file not available\n")
  }
}

## Run GPIM forward accumulation for net stock
## Use data from first_year_idx onward (where dcorp is available)
gpim_data <- bea |> slice(first_year_idx:n())

KNR_gpim <- gpim_accumulate_real(
  IG_R = gpim_data$IGRcorpbea,
  z    = gpim_data$dcorp,
  K0_R = K0_R_net
)

## Back to current-cost
KNC_gpim <- KNR_gpim * (gpim_data$pKN / 100)

## Attach to data frame
bea$KNRcorp <- NA_real_
bea$KNCcorp <- NA_real_
bea$KNRcorp[first_year_idx:nrow(bea)] <- KNR_gpim
bea$KNCcorp[first_year_idx:nrow(bea)] <- KNC_gpim

cat(sprintf("\nNet stock GPIM accumulation: %d periods from %d\n",
            length(KNR_gpim), gpim_data$year[1]))

## ----------------------------------------------------------
## Gross stock accumulation (GPIM §1)
## Uses retirement rate (1/L_corp) instead of depreciation rate
## K^R_gross_t = (IGRcorpbea_t) + (1 - ret_corp) * K^R_gross_{t-1}
## ----------------------------------------------------------

## Initial gross stock: K^gross_0 ≈ K^net_0 × (dep_rate / ret_rate)
dep_rate_mean <- median(gpim_data$dcorp, na.rm = TRUE)
K0_R_gross <- K0_R_net * (dep_rate_mean / ret_corp)

cat(sprintf("\nGross stock initial condition:\n"))
cat(sprintf("  K0_R_net:    %.2f\n", K0_R_net))
cat(sprintf("  dep/ret ratio: %.3f\n", dep_rate_mean / ret_corp))
cat(sprintf("  K0_R_gross:  %.2f\n", K0_R_gross))

## Forward accumulation with retirement rate
KGR_gpim <- gpim_accumulate_real(
  IG_R = gpim_data$IGRcorpbea,
  z    = rep(ret_corp, nrow(gpim_data)),
  K0_R = K0_R_gross
)

## Back to current-cost (using pKN as price index)
KGC_gpim <- KGR_gpim * (gpim_data$pKN / 100)

bea$KGRcorp <- NA_real_
bea$KGCcorp <- NA_real_
bea$KGRcorp[first_year_idx:nrow(bea)] <- KGR_gpim
bea$KGCcorp[first_year_idx:nrow(bea)] <- KGC_gpim

## ----------------------------------------------------------
## SFC validation (net stock)
## ----------------------------------------------------------

cat("\n=== STOCK-FLOW CONSISTENCY (Net Stock) ===\n")
sfc_net <- validate_sfc_identity(
  K     = KNR_gpim,
  K_lag = c(K0_R_net, KNR_gpim[-length(KNR_gpim)]),
  I     = gpim_data$IGRcorpbea,
  D     = gpim_data$DEPCcorp_fa / (gpim_data$pKN / 100),  # real depreciation
  label = "GPIM_net_corp"
)

max_sfc_pct <- max(abs(sfc_net$pct_residual), na.rm = TRUE)
cat(sprintf("Max SFC residual (net, pct): %.6f\n", max_sfc_pct))
if (max_sfc_pct > GDP_CONFIG$GPIM$sfc_tolerance) {
  cat("WARNING: SFC residual exceeds tolerance!\n")
} else {
  cat("PASS: SFC identity satisfied within tolerance.\n")
}

## ----------------------------------------------------------
## Verification table
## ----------------------------------------------------------

cat("\n=== VERIFICATION TABLE ===\n")
cat(sprintf("%-6s  %12s  %12s  %10s  %10s\n",
            "Year", "KNCcorp", "KGCcorp", "dcorp", "pKN"))
cat(paste(rep("-", 60), collapse = ""), "\n")

verify_years <- c(1947, 1960, 1980, 2000, 2011)
for (yr in verify_years) {
  row <- bea |> filter(year == yr)
  if (nrow(row) > 0) {
    cat(sprintf("%-6d  %12.2f  %12.2f  %10.4f  %10.2f\n",
                yr,
                row$KNCcorp,
                row$KGCcorp,
                row$dcorp,
                row$pKN))
  }
}

## Shaikh reference targets
cat("\nShaikh reference (Appendix 6.8, Table II.5):\n")
cat("  KNCcorp_1947:  ~77.77 (Shaikh) vs KNCcorpbea_1947 ≈ 190.1 (BEA 2011)\n")
cat("  KGCcorp_1947:  ~141.9 (Shaikh) vs KGCcorp canonical ≈ 170.6\n")

row_1947 <- bea |> filter(year == 1947)
if (nrow(row_1947) > 0) {
  cat(sprintf("\nActual computed:\n"))
  cat(sprintf("  KNCcorp_1947:    %.2f\n", row_1947$KNCcorp))
  cat(sprintf("  KGCcorp_1947:    %.2f\n", row_1947$KGCcorp))
  cat(sprintf("  KNCcorpbea_1947: %.2f\n", row_1947$KNCcorpbea))
}

## ----------------------------------------------------------
## Write output
## ----------------------------------------------------------

out_df <- bea |>
  select(year, KNCcorpbea, KNRcorpbea, KNRIndxcorpbea,
         KNHcorpbea, DEPCcorp_fa, IGCcorpbea,
         pKN, dcorp, IGRcorpbea,
         KNRcorp, KNCcorp, KGRcorp, KGCcorp)

out_path <- file.path(GDP_CONFIG$PROCESSED, "corp_kstock_series.csv")
safe_write_csv(out_df, out_path)

cat(sprintf("\nWritten: %s\n", out_path))
cat(sprintf("Columns: %s\n", paste(names(out_df), collapse = ", ")))
cat(sprintf("Years: %d-%d (%d observations)\n",
            min(out_df$year), max(out_df$year), nrow(out_df)))
