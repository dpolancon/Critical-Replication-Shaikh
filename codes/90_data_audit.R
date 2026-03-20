#!/usr/bin/env Rscript
# =============================================================================
# 90_data_audit.R — Shaikh Appendix 6.8 Data Audit
# Cross-validates xlsx data tables against canonical CSV
# =============================================================================

suppressPackageStartupMessages({
  library(readxl)
  library(dplyr)
  library(tidyr)
  library(readr)
})

# --- Paths ---
xlsx_corrected <- "data/raw/other/_Appendix6.8DataTablesCorrected.xlsx"
csv_canonical  <- "data/raw/Shaikh_canonical_series_v1.csv"
out_dir        <- "output/CriticalReplication/data_audit"
dir.create(out_dir, recursive = TRUE, showWarnings = FALSE)

# --- Step 1: Identify data sheets ---
all_sheets <- excel_sheets(xlsx_corrected)
cat("All sheets:\n")
print(all_sheets)

# Data sheets: Appndx 6.8.* (skip figure sheets and contents)
data_sheets <- all_sheets[grepl("^Appndx", all_sheets)]
cat("\nData sheets to process:\n")
print(data_sheets)

# --- Step 2: Read each data sheet and extract variable-year matrix ---
read_data_sheet <- function(path, sheet_name) {
  cat(sprintf("\n--- Reading sheet: %s ---\n", sheet_name))

  # Try different skip values to find the right header row
  best <- NULL
  for (skip_val in 0:6) {
    tryCatch({
      d <- read_excel(path, sheet = sheet_name, skip = skip_val,
                       col_types = "text", .name_repair = "minimal")
      if (is.null(d) || nrow(d) == 0) next

      # Look for year columns (4-digit numbers)
      year_cols <- grep("^(19|20)\\d{2}", names(d))
      if (length(year_cols) >= 10) {  # at least 10 year columns
        cat(sprintf("  skip=%d: %d rows x %d cols, %d year cols\n",
                    skip_val, nrow(d), ncol(d), length(year_cols)))
        if (is.null(best) || length(year_cols) > best$n_years) {
          best <- list(data = d, skip = skip_val, n_years = length(year_cols))
        }
      }
    }, error = function(e) {
      cat(sprintf("  skip=%d: ERROR: %s\n", skip_val, e$message))
    })
  }

  if (is.null(best)) {
    cat("  WARNING: Could not parse sheet\n")
    return(NULL)
  }

  d <- best$data
  cat(sprintf("  Using skip=%d\n", best$skip))

  # Identify columns
  cnames <- names(d)
  year_cols <- grep("^(19|20)\\d{2}", cnames)
  years <- as.integer(sub("^((19|20)\\d{2}).*", "\\1", cnames[year_cols]))

  # The variable name is typically in column 3 (or whichever has text identifiers)
  # Try columns 1-3 to find the one with variable-like names
  var_col <- NULL
  for (ci in 1:min(5, ncol(d))) {
    vals <- d[[ci]]
    non_na <- vals[!is.na(vals)]
    # Variable names are short text strings
    if (length(non_na) > 0 && all(nchar(non_na) < 50) && any(grepl("[A-Za-z]", non_na))) {
      var_col <- ci
      break
    }
  }

  if (is.null(var_col)) {
    cat("  WARNING: Could not identify variable name column\n")
    return(NULL)
  }

  cat(sprintf("  Variable name column: %d\n", var_col))

  # Extract numeric data
  result <- data.frame(
    sheet = sheet_name,
    variable = d[[var_col]],
    stringsAsFactors = FALSE
  )

  for (i in seq_along(year_cols)) {
    yr <- years[i]
    vals <- suppressWarnings(as.numeric(d[[year_cols[i]]]))
    result[[as.character(yr)]] <- vals
  }

  # Remove rows where variable is NA or looks like a section header
  result <- result[!is.na(result$variable), ]
  result <- result[nchar(result$variable) > 0, ]
  # Remove section headers (all-caps multi-word descriptions)
  result <- result[!grepl("^(Final|Conventional|Basic|Alternative|Intermediate)",
                          result$variable, ignore.case = TRUE), ]

  cat(sprintf("  Extracted %d variables, years %d-%d\n",
              nrow(result), min(years), max(years)))
  cat(sprintf("  Variables: %s\n", paste(head(result$variable, 10), collapse=", ")))

  return(result)
}

# Read all data sheets
all_data <- list()
for (sh in data_sheets) {
  tryCatch({
    d <- read_data_sheet(xlsx_corrected, sh)
    if (!is.null(d)) all_data[[sh]] <- d
  }, error = function(e) {
    cat(sprintf("FAILED on sheet %s: %s\n", sh, e$message))
  })
}

cat("\n\n========================================\n")
cat("Successfully read", length(all_data), "data sheets\n")
cat("========================================\n")

# --- Step 3: Read canonical CSV ---
canonical <- read_csv(csv_canonical, show_col_types = FALSE)
cat("\nCanonical CSV: ", nrow(canonical), "rows x", ncol(canonical), "cols\n")
cat("Years:", min(canonical$year), "-", max(canonical$year), "\n")
cat("Columns:", paste(names(canonical), collapse=", "), "\n")

# --- Combine all xlsx data into one long table ---
xlsx_long <- bind_rows(all_data) %>%
  pivot_longer(cols = matches("^\\d{4}$"), names_to = "year", values_to = "value") %>%
  mutate(year = as.integer(year)) %>%
  filter(!is.na(value))

cat("\nXLSX long format:", nrow(xlsx_long), "observations\n")
cat("Unique variables:", length(unique(xlsx_long$variable)), "\n")
cat("Variable list:\n")
print(sort(unique(xlsx_long$variable)))

# --- AUDIT 3: Match canonical CSV columns to xlsx variables ---
cat("\n\n========================================\n")
cat("AUDIT 3: Canonical CSV vs XLSX tables\n")
cat("========================================\n")

# Pivot canonical CSV to long
csv_long <- canonical %>%
  pivot_longer(-year, names_to = "csv_col", values_to = "csv_value") %>%
  filter(!is.na(csv_value))

# For each CSV column, try to find a matching xlsx variable
audit3_results <- data.frame(
  csv_column = character(),
  xlsx_variable = character(),
  xlsx_sheet = character(),
  match_status = character(),
  n_compared = integer(),
  n_exact = integer(),
  n_close = integer(),
  max_abs_diff = numeric(),
  max_pct_diff = numeric(),
  stringsAsFactors = FALSE
)

csv_cols <- setdiff(names(canonical), "year")

for (col in csv_cols) {
  csv_vals <- canonical %>% select(year, value = !!sym(col)) %>% filter(!is.na(value))

  best_match <- NULL
  best_exact <- 0

  # Try each xlsx variable
  for (var in unique(xlsx_long$variable)) {
    xlsx_vals <- xlsx_long %>%
      filter(variable == var) %>%
      select(year, xlsx_value = value)

    # Join on year
    joined <- inner_join(csv_vals, xlsx_vals, by = "year")
    if (nrow(joined) < 5) next  # need at least 5 overlap years

    # Compare
    n_exact <- sum(abs(joined$value - joined$xlsx_value) < 0.001)

    if (n_exact > best_exact) {
      best_exact <- n_exact
      abs_diffs <- abs(joined$value - joined$xlsx_value)
      pct_diffs <- ifelse(joined$value != 0,
                          abs(joined$value - joined$xlsx_value) / abs(joined$value) * 100,
                          NA)
      n_close <- sum(abs_diffs < 0.01, na.rm = TRUE)

      best_match <- data.frame(
        csv_column = col,
        xlsx_variable = var,
        xlsx_sheet = xlsx_long$sheet[xlsx_long$variable == var][1],
        match_status = ifelse(n_exact == nrow(joined), "EXACT_MATCH",
                       ifelse(n_close == nrow(joined), "CLOSE_MATCH",
                       ifelse(n_exact > nrow(joined) * 0.9, "NEAR_MATCH", "DIVERGENT"))),
        n_compared = nrow(joined),
        n_exact = n_exact,
        n_close = n_close,
        max_abs_diff = max(abs_diffs, na.rm = TRUE),
        max_pct_diff = max(pct_diffs, na.rm = TRUE),
        stringsAsFactors = FALSE
      )
    }
  }

  if (is.null(best_match)) {
    best_match <- data.frame(
      csv_column = col,
      xlsx_variable = NA,
      xlsx_sheet = NA,
      match_status = "NOT_FOUND",
      n_compared = 0,
      n_exact = 0,
      n_close = 0,
      max_abs_diff = NA,
      max_pct_diff = NA,
      stringsAsFactors = FALSE
    )
  }

  audit3_results <- bind_rows(audit3_results, best_match)
}

cat("\n--- Audit 3 Results ---\n")
print(audit3_results, n = 50)

# Save Audit 3 CSV
write_csv(audit3_results, file.path(out_dir, "audit3_canonical_vs_shaikh.csv"))

# --- Generate summary reports ---

# Audit 3 summary markdown
a3_md <- c(
  "# Audit 3: Canonical CSV vs Shaikh Appendix 6.8 Tables",
  "",
  sprintf("Date: %s", Sys.Date()),
  "",
  "## File inventory",
  "",
  "Only one xlsx file available in repo:",
  sprintf("- `%s` (690 KB, 30 sheets)", basename(xlsx_corrected)),
  "- `Shaikh_RepData.xlsx` has sheets [wide, long] — different format, not the REA appendix tables",
  "- The original uncorrected REA release and a separate 'MyReArrangement' file are **not present in the repo**",
  "",
  "**Consequence:** Audits 1 and 2 (rearrangement fidelity and correction ledger) cannot be performed",
  "with only one xlsx file. Audit 3 (canonical CSV vs xlsx) is the only feasible audit.",
  "",
  "## Data sheets parsed",
  "",
  sprintf("Successfully parsed %d of %d data sheets.", length(all_data), length(data_sheets)),
  ""
)

for (sh in names(all_data)) {
  d <- all_data[[sh]]
  a3_md <- c(a3_md, sprintf("- **%s**: %d variables", sh, nrow(d)))
}

a3_md <- c(a3_md, "",
  sprintf("Total unique xlsx variables: %d", length(unique(xlsx_long$variable))),
  "",
  "## Match results",
  "",
  "| CSV Column | XLSX Variable | Sheet | Status | N Compared | N Exact | Max Abs Diff | Max % Diff |",
  "|------------|---------------|-------|--------|------------|---------|-------------|-----------|"
)

for (i in 1:nrow(audit3_results)) {
  r <- audit3_results[i, ]
  a3_md <- c(a3_md, sprintf("| %s | %s | %s | %s | %d | %d | %s | %s |",
    r$csv_column,
    ifelse(is.na(r$xlsx_variable), "—", r$xlsx_variable),
    ifelse(is.na(r$xlsx_sheet), "—", r$xlsx_sheet),
    r$match_status,
    r$n_compared,
    r$n_exact,
    ifelse(is.na(r$max_abs_diff), "—", sprintf("%.4f", r$max_abs_diff)),
    ifelse(is.na(r$max_pct_diff), "—", sprintf("%.2f%%", r$max_pct_diff))
  ))
}

# Summary counts
a3_md <- c(a3_md, "",
  "## Summary",
  "",
  sprintf("- **EXACT_MATCH**: %d columns", sum(audit3_results$match_status == "EXACT_MATCH")),
  sprintf("- **CLOSE_MATCH**: %d columns", sum(audit3_results$match_status == "CLOSE_MATCH")),
  sprintf("- **NEAR_MATCH**: %d columns", sum(audit3_results$match_status == "NEAR_MATCH")),
  sprintf("- **DIVERGENT**: %d columns", sum(audit3_results$match_status == "DIVERGENT")),
  sprintf("- **NOT_FOUND**: %d columns", sum(audit3_results$match_status == "NOT_FOUND")),
  ""
)

# Key variables
key_vars <- c("VAcorp", "KGCcorp", "GVAcorp", "Py", "uK", "Rcorp", "Profshcorp")
a3_md <- c(a3_md, "## Key variable resolution", "")
for (v in key_vars) {
  r <- audit3_results[audit3_results$csv_column == v, ]
  if (nrow(r) > 0) {
    a3_md <- c(a3_md, sprintf("- **%s**: %s — matched to xlsx `%s` in sheet `%s`",
      v, r$match_status[1],
      ifelse(is.na(r$xlsx_variable[1]), "NOT FOUND", r$xlsx_variable[1]),
      ifelse(is.na(r$xlsx_sheet[1]), "N/A", r$xlsx_sheet[1])))
  }
}

# Audit 1/2 placeholders
a1_md <- c(
  "# Audit 1: Rearrangement Fidelity — CANNOT PERFORM",
  "",
  sprintf("Date: %s", Sys.Date()),
  "",
  "## Status: BLOCKED",
  "",
  "This audit requires comparing Diego's rearrangement xlsx against the corrected REA release.",
  "Only one xlsx file is present in the repo: `_Appendix6.8DataTablesCorrected.xlsx`.",
  "The original REA release and the separate rearrangement file are not available.",
  "",
  "To unblock this audit, add the following files to `data/raw/other/` (or `data/raw/shaikh_data/`):",
  "1. `_Appendix6_8DataTables_REA_release.xlsx` — original from realecon.org",
  "2. `_Appendix6_8DataTablesCorrected_REA_release.xlsx` — corrected version from REA",
  "3. `_Appendix6_8DataTablesCorrected_MyReArrangement.xlsx` — Diego's reconstruction"
)

a2_summary_md <- c(
  "# Audit 2: Correction Ledger — CANNOT PERFORM",
  "",
  sprintf("Date: %s", Sys.Date()),
  "",
  "## Status: BLOCKED",
  "",
  "This audit requires both the original and corrected REA xlsx files to produce a correction ledger.",
  "Only the corrected file is present. The original uncorrected release is not in the repo.",
  "",
  "To unblock: add `_Appendix6_8DataTables_REA_release.xlsx` to `data/raw/other/`."
)

# Write outputs
writeLines(a3_md, file.path(out_dir, "audit3_canonical_vs_shaikh.md"))
writeLines(a1_md, file.path(out_dir, "audit1_rearrangement_fidelity.md"))
writeLines(a2_summary_md, file.path(out_dir, "audit2_correction_summary.md"))

# Empty CSVs for blocked audits
write_csv(data.frame(status = "BLOCKED - missing files"),
          file.path(out_dir, "audit1_rearrangement_fidelity.csv"))
write_csv(data.frame(status = "BLOCKED - missing files"),
          file.path(out_dir, "audit2_correction_ledger.csv"))

cat("\n\n========================================\n")
cat("Outputs saved to", out_dir, "\n")
cat("========================================\n")

# --- Detailed divergence report for non-exact matches ---
cat("\n\n========================================\n")
cat("DETAILED DIVERGENCE REPORT\n")
cat("========================================\n")

divergent_cols <- audit3_results %>%
  filter(match_status %in% c("DIVERGENT", "NEAR_MATCH", "CLOSE_MATCH") & !is.na(xlsx_variable))

for (i in 1:nrow(divergent_cols)) {
  r <- divergent_cols[i, ]
  cat(sprintf("\n--- %s vs %s (sheet: %s) ---\n", r$csv_column, r$xlsx_variable, r$xlsx_sheet))

  csv_vals <- canonical %>% select(year, csv = !!sym(r$csv_column)) %>% filter(!is.na(csv))
  xlsx_vals <- xlsx_long %>%
    filter(variable == r$xlsx_variable) %>%
    select(year, xlsx = value)

  joined <- inner_join(csv_vals, xlsx_vals, by = "year") %>%
    mutate(diff = csv - xlsx,
           pct_diff = ifelse(csv != 0, diff / csv * 100, NA))

  mismatches <- joined %>% filter(abs(diff) > 0.001)
  if (nrow(mismatches) > 0) {
    cat(sprintf("  %d mismatches out of %d compared:\n", nrow(mismatches), nrow(joined)))
    print(as.data.frame(mismatches), row.names = FALSE)
  }
}

cat("\n\nDone.\n")
