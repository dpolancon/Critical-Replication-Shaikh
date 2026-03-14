############################################################
# 50_fetch_bea_corporate.R — Fetch BEA Corporate Sector Data
#
# Downloads BEA Fixed Assets tables by legal form (corporate)
# and NIPA tables for corporate output + GDP deflator.
#
# Tables fetched:
#   FixedAssets: FAAt601-604, FAAt607 (Private FA by Legal Form)
#   NIPA: T10114 (Corporate GVA), T70011 (Interest), T10104 (GDP deflator)
#
# Writes standardized long-format CSVs to:
#   data/interim/bea_parsed/corp_*.csv   (FixedAssets)
#   data/interim/bea_parsed/nipa_*.csv   (NIPA)
#
# Requires: bea.R (or beaR), dplyr, readr
# Sources:  40_gdp_kstock_config.R, 99_utils.R, 97_kstock_helpers.R
############################################################

rm(list = ls())

library(dplyr)
library(readr)

source(here::here("codes/40_gdp_kstock_config.R"))
source(here::here("codes/99_utils.R"))
source(here::here("codes/97_kstock_helpers.R"))

ensure_dirs(GDP_CONFIG)

## ----------------------------------------------------------
## Configuration: toggle for re-fetching existing files
## ----------------------------------------------------------
force_refetch <- FALSE

## ----------------------------------------------------------
## BEA API fetch function (generic, supports both datasets)
## ----------------------------------------------------------

#' Fetch a single BEA table via API
#'
#' @param table_name  BEA table name (e.g., "FAAt601", "T10114")
#' @param api_key     BEA API key
#' @param dataset     BEA dataset name ("FixedAssets" or "NIPA")
#' @param year        "ALL" or "X" for all years
#' @return Data frame from BEA, or NULL on failure
fetch_bea_table <- function(table_name, api_key,
                            dataset = "FixedAssets", year = "ALL") {

  if (!requireNamespace("bea.R", quietly = TRUE) &&
      !requireNamespace("beaR", quietly = TRUE)) {
    message("  Neither bea.R nor beaR available.")
    return(NULL)
  }

  tryCatch({
    message(sprintf("  Fetching %s from BEA API (dataset: %s)...",
                    table_name, dataset))

    specs <- list(
      UserID      = api_key,
      Method      = "GetData",
      datasetname = dataset,
      TableName   = table_name,
      Frequency   = "A",
      Year        = year
    )

    if (requireNamespace("bea.R", quietly = TRUE)) {
      resp <- bea.R::beaGet(specs, asWide = FALSE)
    } else {
      resp <- beaR::beaGet(specs, asWide = FALSE)
    }

    if (is.null(resp) || nrow(resp) == 0) {
      message(sprintf("  Empty response for %s", table_name))
      return(NULL)
    }

    message(sprintf("  Got %d rows for %s", nrow(resp), table_name))
    resp

  }, error = function(e) {
    message(sprintf("  API error for %s: %s", table_name, e$message))
    NULL
  })
}

## ----------------------------------------------------------
## Tables to fetch
## ----------------------------------------------------------

CORP_TABLES <- list(
  # BEA Fixed Assets: Private FA by Legal Form of Organization
  corp_net_cc = list(
    table_name = "FAAt601",
    dataset    = "FixedAssets",
    desc       = "Current-Cost Net Stock, Private FA by Legal Form"
  ),
  corp_net_chain = list(
    table_name = "FAAt602",
    dataset    = "FixedAssets",
    desc       = "Chain-Type QI Net Stock, Private FA by Legal Form"
  ),
  corp_net_hist = list(
    table_name = "FAAt603",
    dataset    = "FixedAssets",
    desc       = "Historical-Cost Net Stock, Private FA by Legal Form"
  ),
  corp_dep_cc = list(
    table_name = "FAAt604",
    dataset    = "FixedAssets",
    desc       = "Current-Cost Depreciation, Private FA by Legal Form"
  ),
  corp_inv_cc = list(
    table_name = "FAAt607",
    dataset    = "FixedAssets",
    desc       = "Investment in Private FA by Legal Form"
  ),

  # NIPA tables
  nipa_t1014 = list(
    table_name = "T10114",
    dataset    = "NIPA",
    desc       = "NIPA Table 1.14: Gross Value Added of Corporate Business"
  ),
  nipa_t7011 = list(
    table_name = "T70011",
    dataset    = "NIPA",
    desc       = "NIPA Table 7.11: Interest Paid and Received by Sector"
  ),
  nipa_t10104 = list(
    table_name = "T10104",
    dataset    = "NIPA",
    desc       = "NIPA Table 1.1.4: Price Indexes for GDP"
  )
)

## ----------------------------------------------------------
## Main fetch loop
## ----------------------------------------------------------

log_file <- file.path(GDP_CONFIG$INTERIM_LOGS, "fetch_bea_corporate_log.txt")
dir.create(dirname(log_file), showWarnings = FALSE, recursive = TRUE)
log_conn <- file(log_file, open = "wt")

cat(sprintf("BEA Corporate Sector Fetch — %s\n", now_stamp()),
    file = log_conn)
cat(sprintf("API Key: %s...%s\n",
            substr(GDP_CONFIG$BEA_API_KEY, 1, 8),
            substr(GDP_CONFIG$BEA_API_KEY,
                   nchar(GDP_CONFIG$BEA_API_KEY) - 3,
                   nchar(GDP_CONFIG$BEA_API_KEY))),
    file = log_conn)

results <- list()

for (tbl_label in names(CORP_TABLES)) {
  spec <- CORP_TABLES[[tbl_label]]
  out_path <- file.path(GDP_CONFIG$INTERIM_BEA_PARSED,
                        sprintf("%s.csv", tbl_label))

  message(sprintf("\n[%s] Processing %s (%s)...",
                  now_stamp(), tbl_label, spec$table_name))
  message(sprintf("  Description: %s", spec$desc))

  ## Skip if already exists and force_refetch is FALSE
  if (!force_refetch && file.exists(out_path)) {
    message(sprintf("  SKIP: %s already exists (force_refetch = FALSE)", out_path))
    cat(sprintf("SKIP: %s — already exists\n", tbl_label), file = log_conn)

    ## Still load for corporate line detection
    results[[tbl_label]] <- readr::read_csv(out_path, show_col_types = FALSE)
    next
  }

  ## Fetch via API
  year_param <- if (spec$dataset == "NIPA") "X" else "ALL"
  raw_resp <- fetch_bea_table(spec$table_name, GDP_CONFIG$BEA_API_KEY,
                              dataset = spec$dataset, year = year_param)

  if (is.null(raw_resp) || nrow(raw_resp) == 0) {
    msg <- sprintf("FAILED: %s (%s) — no data from API",
                   tbl_label, spec$table_name)
    message(msg)
    cat(msg, "\n", file = log_conn)
    next
  }

  ## Parse API response to standardized long format
  parsed <- parse_bea_api_response(raw_resp)

  ## Add metadata columns
  parsed <- parsed |>
    mutate(table_label = tbl_label,
           table_name  = spec$table_name,
           source      = "API")

  ## Write to interim/bea_parsed
  safe_write_csv(parsed, out_path)

  ## Log summary
  msg <- sprintf("OK: %s (%s) via API — %d rows, years %d-%d",
                 tbl_label, spec$table_name,
                 nrow(parsed),
                 min(parsed$year, na.rm = TRUE),
                 max(parsed$year, na.rm = TRUE))
  message(msg)
  cat(msg, "\n", file = log_conn)

  ## Print first 5 unique line descriptions
  line_sample <- parsed |>
    distinct(line_number, line_desc) |>
    arrange(line_number) |>
    head(5)
  message("  First 5 lines:")
  for (i in seq_len(nrow(line_sample))) {
    message(sprintf("    Line %d: %s",
                    line_sample$line_number[i],
                    line_sample$line_desc[i]))
  }

  ## Log data quality
  log_data_quality(parsed, tbl_label)

  results[[tbl_label]] <- parsed
}

## ----------------------------------------------------------
## Identify corporate line in FixedAssets tables
## ----------------------------------------------------------

cat("\n=== CORPORATE LINE IDENTIFICATION ===\n")
message("\n=== CORPORATE LINE IDENTIFICATION ===")

fa_tables <- c("corp_net_cc", "corp_net_chain", "corp_net_hist",
               "corp_dep_cc", "corp_inv_cc")

for (tbl_label in fa_tables) {
  if (!tbl_label %in% names(results)) {
    message(sprintf("  %s: NOT AVAILABLE — cannot identify corporate line",
                    tbl_label))
    next
  }

  df <- results[[tbl_label]]
  lines <- df |> distinct(line_number, line_desc) |> arrange(line_number)

  ## Search for "corporate" in line descriptions

  corp_lines <- lines |>
    filter(grepl("corporate", line_desc, ignore.case = TRUE))

  if (nrow(corp_lines) == 0) {
    ## Check if this is government data (wrong table)
    govt_check <- lines |>
      filter(grepl("defense|government", line_desc, ignore.case = TRUE))
    if (nrow(govt_check) > 0) {
      msg <- sprintf(
        "WARNING: %s appears to contain GOVERNMENT data, not corporate!\n  Found: %s\n  The BEA API table names may need adjustment.",
        tbl_label, paste(govt_check$line_desc[1:min(3, nrow(govt_check))],
                         collapse = "; "))
      message(msg)
      cat(msg, "\n", file = log_conn)
    } else {
      msg <- sprintf("WARNING: %s — no 'corporate' line found. All lines:\n",
                     tbl_label)
      message(msg)
      for (j in seq_len(nrow(lines))) {
        message(sprintf("    Line %d: %s",
                        lines$line_number[j], lines$line_desc[j]))
      }
    }
  } else {
    for (k in seq_len(nrow(corp_lines))) {
      msg <- sprintf("  %s — Corporate line: %d (%s)",
                     tbl_label,
                     corp_lines$line_number[k],
                     corp_lines$line_desc[k])
      message(msg)
      cat(msg, "\n", file = log_conn)
    }
  }
}

## ----------------------------------------------------------
## Summary
## ----------------------------------------------------------

cat(sprintf("\nFetch complete: %d/%d tables retrieved — %s\n",
            length(results), length(CORP_TABLES), now_stamp()),
    file = log_conn)
close(log_conn)

message(sprintf("\n=== BEA Corporate fetch complete: %d/%d tables ===",
                length(results), length(CORP_TABLES)))
message(sprintf("Parsed data: %s", GDP_CONFIG$INTERIM_BEA_PARSED))
message(sprintf("Log: %s", log_file))
