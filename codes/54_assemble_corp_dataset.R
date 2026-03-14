############################################################
# 54_assemble_corp_dataset.R — Assemble Corporate Sector Dataset
#
# Merges all corporate series + GDP deflator (Py) into
# the final deliverable:
#   data/processed/corporate_sector_dataset.csv
#
# This file is the input for 20_S0_shaikh_faithful.R when
# CONFIG$data_shaikh points to it.
#
# Requires: dplyr, readr
# Sources:  40_gdp_kstock_config.R, 99_utils.R
############################################################

rm(list = ls())

library(dplyr)
library(readr)

source(here::here("codes/40_gdp_kstock_config.R"))
source(here::here("codes/99_utils.R"))
source(here::here("codes/97_kstock_helpers.R"))

## ----------------------------------------------------------
## Load component datasets
## ----------------------------------------------------------

cat("=== ASSEMBLING CORPORATE SECTOR DATASET ===\n\n")

## Corporate output series
output_path <- file.path(GDP_CONFIG$PROCESSED, "corp_output_series.csv")
stopifnot(file.exists(output_path))
corp_out <- read_csv(output_path, show_col_types = FALSE)
cat(sprintf("Output series: %d obs (%d-%d)\n",
            nrow(corp_out), min(corp_out$year), max(corp_out$year)))

## Corporate capital stock series
kstock_path <- file.path(GDP_CONFIG$PROCESSED, "corp_kstock_series.csv")
stopifnot(file.exists(kstock_path))
corp_k <- read_csv(kstock_path, show_col_types = FALSE)
cat(sprintf("K stock series: %d obs (%d-%d)\n",
            nrow(corp_k), min(corp_k$year), max(corp_k$year)))

## Exploitation rate and profit metrics
exploit_path <- file.path(GDP_CONFIG$PROCESSED, "corp_exploitation_series.csv")
stopifnot(file.exists(exploit_path))
corp_e <- read_csv(exploit_path, show_col_types = FALSE)
cat(sprintf("Exploitation series: %d obs (%d-%d)\n",
            nrow(corp_e), min(corp_e$year), max(corp_e$year)))

## ----------------------------------------------------------
## GDP deflator (Py) from NIPA T1.1.4
## ----------------------------------------------------------

## Load NIPA T1.1.4 (GDP price index)
py_raw_path <- file.path(GDP_CONFIG$INTERIM_BEA_PARSED, "nipa_t10104.csv")

if (file.exists(py_raw_path)) {
  py_raw <- read_csv(py_raw_path, show_col_types = FALSE)

  ## GDP implicit price deflator is typically line 1
  ## Search for "Gross domestic product" in line descriptions
  py_lines <- py_raw |>
    distinct(line_number, line_desc) |>
    arrange(line_number)

  gdp_line <- py_lines |>
    filter(grepl("gross domestic product", line_desc, ignore.case = TRUE)) |>
    slice(1)

  if (nrow(gdp_line) > 0) {
    py_ln <- gdp_line$line_number
    cat(sprintf("\nGDP deflator: line %d (%s)\n",
                py_ln, gdp_line$line_desc))
  } else {
    py_ln <- 1L
    cat(sprintf("\nGDP deflator: using line 1 (default)\n"))
  }

  py_series <- py_raw |>
    filter(line_number == py_ln) |>
    select(year, Py = value) |>
    arrange(year)

  cat(sprintf("Py series: %d obs (%d-%d)\n",
              nrow(py_series), min(py_series$year), max(py_series$year)))

  ## Verify base year
  py_2017 <- py_series |> filter(year == 2017) |> pull(Py)
  if (length(py_2017) > 0) {
    cat(sprintf("Py(2017) = %.3f (should be ~100 for 2017=100 base)\n", py_2017))
    ## If not already 2017=100, rebase
    if (abs(py_2017 - 100) > 5) {
      cat("Rebasing Py to 2017=100...\n")
      py_series <- py_series |>
        mutate(Py = rebase_index(Py, year, 2017L, scale = 100))
    }
  }
} else {
  ## Fallback: try to load from gdp_us_1925_2024.csv if it exists
  gdp_path <- file.path(GDP_CONFIG$PROCESSED, "gdp_us_1925_2024.csv")
  if (file.exists(gdp_path)) {
    gdp_df <- read_csv(gdp_path, show_col_types = FALSE)
    ## Identify deflator column
    if ("gdp_deflator" %in% names(gdp_df)) {
      py_series <- gdp_df |>
        select(year, Py = gdp_deflator) |>
        arrange(year)
      cat(sprintf("\nPy from gdp_us_1925_2024.csv: %d obs\n", nrow(py_series)))
    } else {
      stop("Cannot find GDP deflator column in ", gdp_path)
    }
  } else {
    stop("No GDP deflator source available.\n",
         "  Expected: ", py_raw_path, " or ", gdp_path)
  }
}

## ----------------------------------------------------------
## Merge all series
## ----------------------------------------------------------

## Start with output series (widest set of output variables)
df <- corp_out |>
  select(year, GVAcorp, VAcorp, DEPCcorp, NOScorp, ECcorp,
         GVAcorpnipa, VAcorpnipa, NOScorpnipa, Pcorpnipa,
         CorpImpIntAdj)

## Add capital stock
df <- df |>
  left_join(
    corp_k |> select(year, KGCcorp, KNCcorp, KNCcorpbea, pKN,
                     dcorp, IGCcorpbea),
    by = "year"
  )

## Add exploitation/profit metrics
df <- df |>
  left_join(
    corp_e |> select(year, exploit_rate, profit_share, rcorp,
                     R_obs, R_net, Pcorp),
    by = "year"
  )

## Add GDP deflator (Py)
df <- df |>
  left_join(py_series, by = "year")

## Add uK placeholder (NA — filled by 20_S0_shaikh_faithful.R after ARDL)
df <- df |>
  mutate(uK = NA_real_)

## Filter to years with complete core data
df <- df |>
  filter(!is.na(GVAcorp), !is.na(Py)) |>
  arrange(year)

cat(sprintf("\nAssembled dataset: %d obs (%d-%d), %d columns\n",
            nrow(df), min(df$year), max(df$year), ncol(df)))

## ----------------------------------------------------------
## Identity check: GVAcorp ≈ VAcorp + DEPCcorp
## ----------------------------------------------------------

cat("\n=== IDENTITY CHECK: GVAcorp = VAcorp + DEPCcorp ===\n")
df <- df |>
  mutate(gva_gap = GVAcorp - (VAcorp + DEPCcorp))

bad_identity <- df |> filter(abs(gva_gap) > 0.5)
if (nrow(bad_identity) > 0) {
  cat(sprintf("WARNING: %d years fail identity check (|gap| > 0.5):\n",
              nrow(bad_identity)))
  for (i in seq_len(min(5, nrow(bad_identity)))) {
    cat(sprintf("  Year %d: GVAcorp=%.1f, VAcorp+DEPCcorp=%.1f, gap=%.2f\n",
                bad_identity$year[i],
                bad_identity$GVAcorp[i],
                bad_identity$VAcorp[i] + bad_identity$DEPCcorp[i],
                bad_identity$gva_gap[i]))
  }
} else {
  cat("PASS: |GVAcorp - (VAcorp + DEPCcorp)| < 0.5 for all years.\n")
}

df <- df |> select(-gva_gap)

## ----------------------------------------------------------
## FINAL VERIFICATION BLOCK
## ----------------------------------------------------------

cat("\n=== CORPORATE SECTOR VERIFICATION ===\n")

row_1947 <- df |> filter(year == 1947)
if (nrow(row_1947) > 0) {
  cat(sprintf("GVAcorp_1947: %.1f | Target: 127.5\n", row_1947$GVAcorp))
  cat(sprintf("VAcorp_1947:  %.1f | Target: 118.6\n", row_1947$VAcorp))
  cat(sprintf("KGCcorp_1947: %.1f | Shaikh II.5: 141.9 | Current BEA: ~171\n",
              row_1947$KGCcorp))
  cat(sprintf("KNCcorp_1947: %.1f | Shaikh II.5: 77.77 | BEA 2011: 190.1\n",
              row_1947$KNCcorp))
  cat(sprintf("NOScorp_1947: %.1f | Target: 24.9\n", row_1947$NOScorp))
  cat(sprintf("ECcorp_1947:  %.1f | Target: 82.1\n", row_1947$ECcorp))
  cat(sprintf("Py_1947:      %.2f | Should be ~11.43 (2017=100 base)\n",
              row_1947$Py))
  cat(sprintf("exploit_1947: %.4f | Target: ~0.303\n",
              row_1947$exploit_rate))
}

cat(sprintf("Year range:   %d-%d\n", min(df$year), max(df$year)))
cat(sprintf("Columns:      %d\n", ncol(df)))
cat(sprintf("Column names: %s\n", paste(names(df), collapse = ", ")))

## Verify required columns for ARDL
REQUIRED_COLS <- c("year", "GVAcorp", "VAcorp", "DEPCcorp", "NOScorp",
                   "ECcorp", "Pcorp", "KGCcorp", "KNCcorp", "Py",
                   "pKN", "exploit_rate", "profit_share", "rcorp", "uK")

missing <- setdiff(REQUIRED_COLS, names(df))
if (length(missing) > 0) {
  cat(sprintf("\nWARNING: Missing required columns: %s\n",
              paste(missing, collapse = ", ")))
} else {
  cat("\nPASS: All required columns present.\n")
}

## ----------------------------------------------------------
## Write final dataset
## ----------------------------------------------------------

out_path <- file.path(GDP_CONFIG$PROCESSED, "corporate_sector_dataset.csv")
safe_write_csv(df, out_path)

cat(sprintf("\nWritten: %s\n", out_path))
cat("=== ASSEMBLY COMPLETE ===\n")
