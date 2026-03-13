############################################################
# run_50_pipeline.R — Master Runner for 50-series Pipeline
#
# Runs the complete GDP & Capital Stock pipeline in order:
#   50 → config (sourced by each script)
#   51 → BEA fetch (via FRED API)
#   52 → FRED GDP/GNP/deflator fetch
#   53 → GDP construction
#   54 → Private capital stocks (GPIM core)
#   55 → Government capital stocks
#   56 → Shaikh adjustments
#   57 → SFC validation + deflator tests T1-T3
#   58 → Final assembly
#
# Prerequisites:
#   - R packages: dplyr, tidyr, readr, ggplot2, httr,
#     jsonlite, sandwich, lmtest, urca
#   - Environment variables BEA_API_KEY, FRED_API_KEY in .Renviron
#     (or hardcoded in 50_gdp_kstock_config.R)
#   - Internet access for API calls (scripts 51-52)
#
# Usage:
#   cd /path/to/Capacity-Utilization-US_Chile
#   Rscript codes/run_50_pipeline.R
#
# Or step by step:
#   Rscript codes/51_fetch_bea_fixed_assets.R
#   Rscript codes/52_fetch_fred_gdp.R
#   Rscript codes/53_build_gdp_series.R
#   Rscript codes/54_build_kstock_private.R
#   Rscript codes/55_build_kstock_government.R
#   Rscript codes/56_shaikh_adjustments.R
#   Rscript codes/57_stock_flow_consistency.R
#   Rscript codes/58_assemble_dataset.R
############################################################

cat("==============================================\n")
cat("  50-series Pipeline: GDP & Capital Stock\n")
cat("  with Shaikh GPIM Adjustments\n")
cat(sprintf("  Started: %s\n", Sys.time()))
cat("==============================================\n\n")

scripts <- c(
  "codes/51_fetch_bea_fixed_assets.R",
  "codes/52_fetch_fred_gdp.R",
  "codes/53_build_gdp_series.R",
  "codes/54_build_kstock_private.R",
  "codes/55_build_kstock_government.R",
  "codes/56_shaikh_adjustments.R",
  "codes/57_stock_flow_consistency.R",
  "codes/58_assemble_dataset.R"
)

t0 <- Sys.time()
results <- list()

for (script in scripts) {
  cat(sprintf("\n>>> Running %s ...\n", basename(script)))
  t_start <- Sys.time()

  status <- tryCatch({
    source(script, local = new.env())
    "OK"
  }, error = function(e) {
    cat(sprintf("  ERROR in %s: %s\n", basename(script), e$message))
    paste0("FAILED: ", e$message)
  })

  elapsed <- difftime(Sys.time(), t_start, units = "secs")
  results[[basename(script)]] <- list(status = status, elapsed = elapsed)

  cat(sprintf("<<< %s — %s (%.1f sec)\n",
              basename(script), status, as.numeric(elapsed)))

  if (grepl("^FAILED", status)) {
    # Check if this is a fetch script — pipeline can continue
    # if downstream scripts handle missing data gracefully
    if (grepl("^5[12]_", basename(script))) {
      cat("  (Fetch failure — downstream scripts will check for data)\n")
    } else {
      cat("  (Build failure — stopping pipeline)\n")
      break
    }
  }
}

cat("\n==============================================\n")
cat("  Pipeline Summary\n")
cat("==============================================\n")
total_elapsed <- difftime(Sys.time(), t0, units = "secs")

for (name in names(results)) {
  r <- results[[name]]
  cat(sprintf("  %-40s %s (%.1f sec)\n",
              name, r$status, as.numeric(r$elapsed)))
}

cat(sprintf("\n  Total elapsed: %.1f seconds\n", as.numeric(total_elapsed)))
cat(sprintf("  Completed: %s\n", Sys.time()))
cat("==============================================\n")

# Check for master dataset
master_path <- "data/processed/master_dataset.csv"
if (file.exists(master_path)) {
  info <- file.info(master_path)
  cat(sprintf("\n  Master dataset: %s (%.1f KB)\n", master_path, info$size / 1024))
} else {
  cat(sprintf("\n  Master dataset NOT found at %s\n", master_path))
  cat("  Run fetch scripts (51-52) with API access first.\n")
}
