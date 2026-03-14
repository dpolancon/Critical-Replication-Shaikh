############################################################
# 51_build_corp_output.R — Build Corporate Output Series
#
# Constructs GVAcorp, VAcorp, NOScorp, ECcorp, DEPCcorp
# from NIPA Table 1.14 (Corporate GVA) and Table 7.11
# (Interest paid/received), applying Shaikh's imputed
# interest adjustment.
#
# Source authority: Shaikh (2016) Appendix 6.8, Tables I.1-I.3
#
# Output: data/processed/corp_output_series.csv
#
# Requires: dplyr, readr, tidyr
# Sources:  40_gdp_kstock_config.R, 99_utils.R
############################################################

rm(list = ls())

library(dplyr)
library(readr)
library(tidyr)

source(here::here("codes/40_gdp_kstock_config.R"))
source(here::here("codes/99_utils.R"))

## ----------------------------------------------------------
## Load NIPA T1.14: Corporate GVA
## ----------------------------------------------------------

t1014_path <- file.path(GDP_CONFIG$INTERIM_BEA_PARSED, "nipa_t1014.csv")
stopifnot(file.exists(t1014_path))
t1014 <- read_csv(t1014_path, show_col_types = FALSE)

cat("=== NIPA T1.14: Corporate GVA ===\n")
cat(sprintf("Rows: %d | Years: %d-%d\n",
            nrow(t1014), min(t1014$year), max(t1014$year)))

## Extract required lines
extract_line <- function(df, ln, label) {
  series <- df |>
    filter(line_number == ln) |>
    select(year, value) |>
    arrange(year) |>
    rename(!!label := value)

  if (nrow(series) == 0) {
    warning(sprintf("Line %d (%s) not found in T1.14", ln, label))
  } else {
    desc <- df |> filter(line_number == ln) |> pull(line_desc) |> unique()
    cat(sprintf("  Line %d -> %s: '%s' (%d obs)\n",
                ln, label, desc[1], nrow(series)))
  }
  series
}

GVAcorpnipa  <- extract_line(t1014,  1, "GVAcorpnipa")
DEPCcorp     <- extract_line(t1014,  2, "DEPCcorp")
VAcorpnipa   <- extract_line(t1014,  3, "VAcorpnipa")
ECcorp       <- extract_line(t1014,  4, "ECcorp")
Tcorp        <- extract_line(t1014,  7, "Tcorp")
NOScorpnipa  <- extract_line(t1014,  8, "NOScorpnipa")
Pcorpnipa    <- extract_line(t1014, 11, "Pcorpnipa")

## Merge T1.14 series
corp_output <- GVAcorpnipa |>
  left_join(DEPCcorp,    by = "year") |>
  left_join(VAcorpnipa,  by = "year") |>
  left_join(ECcorp,      by = "year") |>
  left_join(Tcorp,       by = "year") |>
  left_join(NOScorpnipa, by = "year") |>
  left_join(Pcorpnipa,   by = "year") |>
  arrange(year)

## ----------------------------------------------------------
## Load NIPA T7.11: Interest Paid and Received
## ----------------------------------------------------------

t7011_path <- file.path(GDP_CONFIG$INTERIM_BEA_PARSED, "nipa_t7011.csv")
stopifnot(file.exists(t7011_path))
t7011 <- read_csv(t7011_path, show_col_types = FALSE)

cat("\n=== NIPA T7.11: Interest Paid/Received ===\n")
cat(sprintf("Rows: %d | Years: %d-%d\n",
            nrow(t7011), min(t7011$year), max(t7011$year)))

## Line 4: Financial corporate (bank) monetary interest paid
## Line 74: Nonfinancial corporate imputed interest received
## Line 53: Nonfinancial corporate imputed interest paid
bank_int <- t7011 |>
  filter(line_number == 4) |>
  select(year, BankMonIntPaid = value) |>
  arrange(year)

line74 <- t7011 |>
  filter(line_number == 74) |>
  select(year, line74_val = value) |>
  arrange(year)

line53 <- t7011 |>
  filter(line_number == 53) |>
  select(year, line53_val = value) |>
  arrange(year)

## Log what we found
for (ln in c(4, 53, 74)) {
  desc <- t7011 |> filter(line_number == ln) |> pull(line_desc) |> unique()
  n <- t7011 |> filter(line_number == ln) |> nrow()
  cat(sprintf("  Line %d: '%s' (%d obs)\n", ln,
              if (length(desc) > 0) desc[1] else "NOT FOUND", n))
}

## Compute CorpNFNetImpIntPaid = line 74 - line 53
int_adj <- bank_int |>
  left_join(line74, by = "year") |>
  left_join(line53, by = "year") |>
  mutate(
    CorpNFNetImpIntPaid = line74_val - line53_val,
    CorpImpIntAdj = -BankMonIntPaid - CorpNFNetImpIntPaid
  ) |>
  select(year, BankMonIntPaid, CorpNFNetImpIntPaid, CorpImpIntAdj)

## ----------------------------------------------------------
## Merge and apply imputed interest adjustment
## ----------------------------------------------------------

corp_output <- corp_output |>
  left_join(int_adj, by = "year") |>
  mutate(
    GVAcorp = GVAcorpnipa + CorpImpIntAdj,
    VAcorp  = VAcorpnipa,
    NOScorp = NOScorpnipa + CorpImpIntAdj
  )

## ----------------------------------------------------------
## Validation: compare 1947 values against Shaikh targets
## ----------------------------------------------------------

cat("\n=== 1947 VALIDATION (vs Shaikh targets) ===\n")

targets_1947 <- list(
  GVAcorpnipa  = 126.0,
  DEPCcorp     = 8.9,
  VAcorpnipa   = 117.1,
  ECcorp       = 82.1,
  Tcorp        = 11.5,
  NOScorpnipa  = 23.4,
  Pcorpnipa    = 22.5,
  BankMonIntPaid = -0.6,
  CorpImpIntAdj  = 1.5,
  GVAcorp      = 127.5,
  NOScorp      = 24.9
)

row_1947 <- corp_output |> filter(year == 1947)

if (nrow(row_1947) == 0) {
  cat("WARNING: 1947 not in data range!\n")
} else {
  for (var_name in names(targets_1947)) {
    target <- targets_1947[[var_name]]
    if (var_name %in% names(row_1947)) {
      actual <- row_1947[[var_name]]
      diff <- abs(actual - target)
      flag <- if (diff > 2.0) " *** WARNING: >2.0 ***" else ""
      cat(sprintf("  %-20s Actual: %8.1f | Target: %8.1f | Diff: %5.1f%s\n",
                  var_name, actual, target, diff, flag))
    }
  }
}

## ----------------------------------------------------------
## Write output
## ----------------------------------------------------------

out_path <- file.path(GDP_CONFIG$PROCESSED, "corp_output_series.csv")
safe_write_csv(corp_output, out_path)

cat(sprintf("\nWritten: %s\n", out_path))
cat(sprintf("Columns: %s\n", paste(names(corp_output), collapse = ", ")))
cat(sprintf("Years: %d-%d (%d observations)\n",
            min(corp_output$year), max(corp_output$year), nrow(corp_output)))
