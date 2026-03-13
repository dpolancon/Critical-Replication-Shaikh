############################################################
# 51_fetch_bea_fixed_assets.R — Download BEA Fixed Assets
#
# Strategy: Fetch individual BEA series from FRED API.
# BEA Fixed Assets tables are mirrored on FRED with
# systematic series IDs. This avoids the BEA API entirely.
#
# Naming convention:
#   K1 = Current-cost net stock
#   K3 = Chain-type quantity index net stock
#   K4 = Historical-cost net stock
#   M1 = Current-cost depreciation
#   I3 = Investment in fixed assets
#   Sector: P=Private, N=Nonresidential, R=Residential,
#           G=Government, T=Total
#   Type: ES=total, EQ=Equipment, ST=Structures,
#         IP=Intell.Property, CD=Consumer Durables
#
# Output: data/interim/bea_parsed/*.csv (one per BEA table)
#
# Requires: httr, jsonlite, dplyr, readr
# Sources:  50_gdp_kstock_config.R, 97_kstock_helpers.R
############################################################

rm(list = ls())

library(dplyr)
library(readr)
library(httr)
library(jsonlite)

source("codes/50_gdp_kstock_config.R")
source("codes/99_utils.R")
source("codes/97_kstock_helpers.R")

ensure_dirs(GDP_CONFIG)

## ----------------------------------------------------------
## FRED series mapping for BEA Fixed Assets tables
##
## Each BEA table is reconstructed from individual FRED series
## that correspond to the line items in that table.
## ----------------------------------------------------------

FRED_BEA_MAP <- list(
  # === Table 4.1: Current-Cost Net Stock, Private FA ===
  private_net_cc = list(
    table_name = "FAAt401",
    series = list(
      list(line = 1L,  desc = "Private fixed assets",
           fred_id = "K1PTOTL1ES000"),
      list(line = 2L,  desc = "Nonresidential",
           fred_id = "K1NTOTL1ES000"),
      list(line = 3L,  desc = "Structures",
           fred_id = "K1NTOTL1ST000"),
      list(line = 6L,  desc = "Equipment",
           fred_id = "K1NTOTL1EQ000"),
      list(line = 9L,  desc = "Intellectual property products",
           fred_id = "K1NTOTL1IP000"),
      list(line = 13L, desc = "Residential",
           fred_id = "K1RTOTL1ES000")
    )
  ),

  # === Table 4.2: Chain-Type QI Net Stock, Private FA ===
  private_net_chain = list(
    table_name = "FAAt402",
    series = list(
      list(line = 1L,  desc = "Private fixed assets",
           fred_id = "K3PTOTL1ES000"),
      list(line = 2L,  desc = "Nonresidential",
           fred_id = "K3NTOTL1ES000"),
      list(line = 3L,  desc = "Structures",
           fred_id = "K3NTOTL1ST000"),
      list(line = 6L,  desc = "Equipment",
           fred_id = "K3NTOTL1EQ000"),
      list(line = 9L,  desc = "Intellectual property products",
           fred_id = "K3NTOTL1IP000"),
      list(line = 13L, desc = "Residential",
           fred_id = "K3RTOTL1ES000")
    )
  ),

  # === Table 4.3: Historical-Cost Net Stock, Private FA ===
  private_net_hist = list(
    table_name = "FAAt403",
    series = list(
      list(line = 1L,  desc = "Private fixed assets",
           fred_id = "K4PTOTL1ES000"),
      list(line = 2L,  desc = "Nonresidential",
           fred_id = "K4NTOTL1ES000"),
      list(line = 3L,  desc = "Structures",
           fred_id = "K4NTOTL1ST000"),
      list(line = 6L,  desc = "Equipment",
           fred_id = "K4NTOTL1EQ000"),
      list(line = 9L,  desc = "Intellectual property products",
           fred_id = "K4NTOTL1IP000"),
      list(line = 13L, desc = "Residential",
           fred_id = "K4RTOTL1ES000")
    )
  ),

  # === Table 4.4: Current-Cost Depreciation, Private FA ===
  private_dep_cc = list(
    table_name = "FAAt404",
    series = list(
      list(line = 1L,  desc = "Private fixed assets",
           fred_id = "M1PTOTL1ES000"),
      list(line = 2L,  desc = "Nonresidential",
           fred_id = "M1NTOTL1ES000"),
      list(line = 3L,  desc = "Structures",
           fred_id = "M1NTOTL1ST000"),
      list(line = 6L,  desc = "Equipment",
           fred_id = "M1NTOTL1EQ000"),
      list(line = 9L,  desc = "Intellectual property products",
           fred_id = "M1NTOTL1IP000"),
      list(line = 13L, desc = "Residential",
           fred_id = "M1RTOTL1ES000")
    )
  ),

  # === Table 4.7: Investment in Private FA ===
  private_inv = list(
    table_name = "FAAt407",
    series = list(
      list(line = 1L,  desc = "Private fixed assets",
           fred_id = "I3PTOTL1ES000"),
      list(line = 2L,  desc = "Nonresidential",
           fred_id = "I3NTOTL1ES000"),
      list(line = 3L,  desc = "Structures",
           fred_id = "I3NTOTL1ST000"),
      list(line = 6L,  desc = "Equipment",
           fred_id = "I3NTOTL1EQ000"),
      list(line = 9L,  desc = "Intellectual property products",
           fred_id = "I3NTOTL1IP000"),
      list(line = 13L, desc = "Residential",
           fred_id = "I3RTOTL1ES000")
    )
  ),

  # === Table 6.1: Current-Cost Net Stock, Government FA ===
  govt_net_cc = list(
    table_name = "FAAt601",
    series = list(
      list(line = 1L,  desc = "Government fixed assets",
           fred_id = "K1GTOTL1ES000"),
      list(line = 2L,  desc = "National defense",
           fred_id = "K1GDEFN1ES000"),
      list(line = 3L,  desc = "National defense: Structures",
           fred_id = "K1GDEFN1ST000"),
      list(line = 4L,  desc = "National defense: Equipment",
           fred_id = "K1GDEFN1EQ000"),
      list(line = 5L,  desc = "National defense: IP products",
           fred_id = "K1GDEFN1IP000"),
      list(line = 6L,  desc = "Nondefense",
           fred_id = "K1GNDFN1ES000"),
      list(line = 7L,  desc = "Nondefense: Structures",
           fred_id = "K1GNDFN1ST000"),
      list(line = 8L,  desc = "Nondefense: Equipment",
           fred_id = "K1GNDFN1EQ000"),
      list(line = 9L,  desc = "Nondefense: IP products",
           fred_id = "K1GNDFN1IP000")
    )
  ),

  # === Table 6.2: Chain-Type QI Net Stock, Government FA ===
  govt_net_chain = list(
    table_name = "FAAt602",
    series = list(
      list(line = 1L,  desc = "Government fixed assets",
           fred_id = "K3GTOTL1ES000"),
      list(line = 2L,  desc = "National defense",
           fred_id = "K3GDEFN1ES000"),
      list(line = 6L,  desc = "Nondefense",
           fred_id = "K3GNDFN1ES000")
    )
  ),

  # === Table 6.3: Current-Cost Depreciation, Government FA ===
  govt_dep_cc = list(
    table_name = "FAAt603",
    series = list(
      list(line = 1L,  desc = "Government fixed assets",
           fred_id = "M1GTOTL1ES000"),
      list(line = 2L,  desc = "National defense",
           fred_id = "M1GDEFN1ES000"),
      list(line = 6L,  desc = "Nondefense",
           fred_id = "M1GNDFN1ES000")
    )
  ),

  # === Table 6.4: Investment in Government FA ===
  govt_inv = list(
    table_name = "FAAt604",
    series = list(
      list(line = 1L,  desc = "Government fixed assets",
           fred_id = "I3GTOTLGES000"),
      list(line = 2L,  desc = "National defense",
           fred_id = "I3GDEFNGES000"),
      list(line = 6L,  desc = "Nondefense",
           fred_id = "I3GNDFNGES000")
    )
  )
)

## ----------------------------------------------------------
## FRED fetch function (direct httr, with retry)
## ----------------------------------------------------------

fetch_fred_series <- function(series_id, api_key, max_retries = 4L) {
  url <- "https://api.stlouisfed.org/fred/series/observations"

  params <- list(
    series_id  = series_id,
    api_key    = api_key,
    file_type  = "json",
    frequency  = "a",
    observation_start = "1925-01-01",
    observation_end   = "2024-12-31"
  )

  wait_secs <- 2
  for (attempt in seq_len(max_retries)) {
    tryCatch({
      resp <- httr::GET(url, query = params, httr::timeout(30))

      if (httr::status_code(resp) != 200) {
        if (attempt < max_retries) {
          Sys.sleep(wait_secs)
          wait_secs <- wait_secs * 2
          next
        }
        return(NULL)
      }

      content_text <- httr::content(resp, as = "text", encoding = "UTF-8")
      parsed <- jsonlite::fromJSON(content_text)

      if (is.null(parsed$observations) || nrow(parsed$observations) == 0) {
        return(NULL)
      }

      parsed$observations |>
        dplyr::transmute(
          date  = as.Date(date),
          year  = as.integer(format(as.Date(date), "%Y")),
          value = suppressWarnings(as.numeric(value))
        ) |>
        dplyr::filter(!is.na(value))

    }, error = function(e) {
      if (attempt < max_retries) {
        Sys.sleep(wait_secs)
        wait_secs <<- wait_secs * 2
      }
      NULL
    })
  }
  NULL
}


## ----------------------------------------------------------
## Main fetch loop: reconstruct each BEA table from FRED
## ----------------------------------------------------------

log_file <- file.path(GDP_CONFIG$INTERIM_LOGS, "fetch_bea_log.txt")
log_conn <- file(log_file, open = "wt")

cat(sprintf("BEA Fixed Assets Fetch via FRED — %s\n", now_stamp()), file = log_conn)

results <- list()

for (tbl_label in names(FRED_BEA_MAP)) {
  tbl_spec <- FRED_BEA_MAP[[tbl_label]]
  tbl_name <- tbl_spec$table_name
  message(sprintf("\n[%s] Building %s (%s) from %d FRED series...",
                  now_stamp(), tbl_label, tbl_name, length(tbl_spec$series)))

  rows <- list()
  n_ok <- 0L
  n_fail <- 0L

  for (spec in tbl_spec$series) {
    message(sprintf("  Line %d (%s): %s", spec$line, spec$desc, spec$fred_id))

    df <- fetch_fred_series(spec$fred_id, GDP_CONFIG$FRED_API_KEY)

    if (is.null(df) || nrow(df) == 0) {
      message(sprintf("    FAILED: %s", spec$fred_id))
      n_fail <- n_fail + 1L
      next
    }

    df <- df |>
      mutate(
        line_number = spec$line,
        line_desc   = spec$desc
      ) |>
      filter(year >= GDP_CONFIG$year_start,
             year <= GDP_CONFIG$year_end)

    rows[[spec$fred_id]] <- df
    n_ok <- n_ok + 1L
    message(sprintf("    OK: %d obs, %d-%d",
                    nrow(df), min(df$year), max(df$year)))

    Sys.sleep(0.3)  # Rate limit
  }

  if (length(rows) == 0) {
    msg <- sprintf("FAILED: %s (%s) — 0/%d series fetched",
                   tbl_label, tbl_name, length(tbl_spec$series))
    message(msg)
    cat(msg, "\n", file = log_conn)
    next
  }

  # Combine into table-level data
  combined <- bind_rows(rows) |>
    select(year, line_number, line_desc, value) |>
    mutate(table_label = tbl_label,
           table_name  = tbl_name,
           source      = "FRED")

  # Write parsed long-format
  parsed_path <- file.path(GDP_CONFIG$INTERIM_BEA_PARSED,
                            sprintf("%s.csv", tbl_label))
  safe_write_csv(combined, parsed_path)

  # Also save raw
  raw_path <- file.path(GDP_CONFIG$RAW_BEA,
                         sprintf("%s_raw.csv", tbl_label))
  safe_write_csv(combined, raw_path)

  msg <- sprintf("OK: %s (%s) — %d/%d series, %d rows, years %d-%d",
                 tbl_label, tbl_name, n_ok, length(tbl_spec$series),
                 nrow(combined),
                 min(combined$year), max(combined$year))
  message(msg)
  cat(msg, "\n", file = log_conn)

  results[[tbl_label]] <- combined
}

## ----------------------------------------------------------
## Summary
## ----------------------------------------------------------

cat(sprintf("\nFetch complete: %d/%d tables — %s\n",
            length(results), length(FRED_BEA_MAP), now_stamp()),
    file = log_conn)
close(log_conn)

message(sprintf("\n=== BEA fetch complete: %d/%d tables ===",
                length(results), length(FRED_BEA_MAP)))
message(sprintf("Parsed data: %s", GDP_CONFIG$INTERIM_BEA_PARSED))
message(sprintf("Log: %s", log_file))
