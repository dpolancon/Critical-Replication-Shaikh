# ============================================================
# 26_S0_redesign_ardl_search.R
#
# S0 Redesign — Theoretically-grounded ARDL search with
#               exact bounds F+t dual gate, Case 3 only
#
# Theoretical motivation:
#   Shaikh's capacity utilization identifies productive capacity
#   as the component of output cointegrated with capital stock
#   under the classical gravitation principle. Technological
#   change is capital-embodied — unrestricted deterministic trends
#   in the cointegrating equation (Cases 4, 5) imply autonomous
#   technological change, contradicting the framework. Only Case 3
#   (unrestricted intercept, no trend) is admissible.
#
# Grid: p in {1,2,3,4}, q in {0,1,2,3,4}, Case 3 only = 20 specs
# Gates: F-bounds p < 0.10 AND t-bounds p < 0.10 (exact=TRUE)
#
# Outputs under: output/CriticalReplication/S0_redesign/
# ============================================================

rm(list = ls())

suppressPackageStartupMessages({
  library(here)
  library(readxl)
  library(readr)
  library(dplyr)
  library(tidyr)
  library(purrr)
  library(stringr)
  library(ARDL)
  library(lmtest)
  library(tseries)
})

# ------------------------------------------------------------
# Load CONFIG + UTILS (repo-native)
# ------------------------------------------------------------
source(here::here("codes", "10_config.R"))
source(here::here("codes", "99_utils.R"))
source(here::here("codes", "98_ardl_helpers.R"))

stopifnot(exists("CONFIG"), is.list(CONFIG))

# ------------------------------------------------------------
# LOCKED TOGGLES (S0 Redesign)
# ------------------------------------------------------------
WINDOW_TAG    <- "shaikh_window"
P_RANGE       <- 1:4
Q_RANGE       <- 0:4
CASE          <- 3L
EXACT_TEST    <- TRUE
F_GATE_ALPHA  <- 0.10
T_GATE_ALPHA  <- 0.10
DUMMY_YEARS   <- c(1956L, 1974L, 1980L)
SHAIKH_ANCHOR <- c(2L, 4L)   # p=2, q=4

# ------------------------------------------------------------
# Output directories + log sink
# ------------------------------------------------------------
EXERCISE_DIR <- here::here("output/CriticalReplication/S0_redesign")
CSV_DIR      <- file.path(EXERCISE_DIR, "csv")
DOC_DIR      <- file.path(EXERCISE_DIR, "docs")
LOG_DIR      <- file.path(EXERCISE_DIR, "logs")

dir.create(CSV_DIR, recursive = TRUE, showWarnings = FALSE)
dir.create(DOC_DIR, recursive = TRUE, showWarnings = FALSE)
dir.create(LOG_DIR, recursive = TRUE, showWarnings = FALSE)

log_path <- file.path(LOG_DIR, "S0_redesign_log.txt")
sink(log_path, split = TRUE)
on.exit(try(sink(), silent = TRUE), add = TRUE)

cat("=== S0 Redesign — Case 3 Only, Exact Bounds F+t Dual Gate ===\n")
cat("Timestamp: ", now_stamp(), "\n", sep = "")
cat("Grid:      p in {", paste(P_RANGE, collapse = ","), "}, q in {",
    paste(Q_RANGE, collapse = ","), "} = ", length(P_RANGE) * length(Q_RANGE),
    " specs\n", sep = "")
cat("Case:      ", CASE, " (unrestricted intercept, no trend)\n", sep = "")
cat("Bounds:    exact=", EXACT_TEST, "\n", sep = "")
cat("Gates:     F_alpha=", F_GATE_ALPHA, " | T_alpha=", T_GATE_ALPHA, "\n", sep = "")
cat("Shock:     ", CONFIG$SHOCK_TYPE, "\n\n", sep = "")

# ------------------------------------------------------------
# Local helpers (copied from 20_S0_shaikh_faithful.R patterns)
# ------------------------------------------------------------
rebase_to_year_to_100 <- function(p_vec, year_vec, base_year, strict = TRUE) {
  idx <- which(year_vec == base_year)
  if (length(idx) != 1) {
    msg <- paste0("Base year ", base_year, " not uniquely present in price index series.")
    if (strict) stop(msg) else {
      warning(msg, " Falling back to first observation in provided series.")
      idx <- 1
    }
  }
  p0 <- p_vec[idx]
  if (!is.finite(p0) || p0 <= 0) stop("Invalid base-year price index value.")
  100 * (p_vec / p0)
}

extract_bt <- function(bt_obj) {
  out <- list(stat = NA_real_, pval = NA_real_)
  if (is.list(bt_obj)) {
    if (!is.null(bt_obj$statistic)) out$stat <- suppressWarnings(as.numeric(bt_obj$statistic))
    if (!is.null(bt_obj$p.value))   out$pval <- suppressWarnings(as.numeric(bt_obj$p.value))
  }
  out
}

sig_stars <- function(p) {
  if (!is.finite(p)) return("")
  if (p <= 0.01) return("***")
  if (p <= 0.05) return("**")
  if (p <= 0.10) return("*")
  ""
}

# LR multipliers + scaled LR dummy multipliers via delta method
get_lr_table_with_scaled_dummies <- function(fit_ardl, lnY_name = "lnY", dummy_names = character()) {
  lr_mult <- ARDL::multipliers(fit_ardl, type = "lr")

  coefs <- coef(fit_ardl)
  phi_names <- grep(paste0("^L\\(", lnY_name, ","), names(coefs), value = TRUE)
  den <- 1 - sum(coefs[phi_names])

  dummy_table <- NULL
  if (length(dummy_names)) {
    gamma_sr  <- coefs[dummy_names]
    dummy_lr  <- gamma_sr / den

    vc <- vcov(fit_ardl)

    se_lr <- numeric(length(dummy_names))
    for (j in seq_along(dummy_names)) {
      dname   <- dummy_names[j]
      gamma_j <- coefs[dname]
      param_names <- c(dname, phi_names)
      idx <- match(param_names, names(coefs))
      grad      <- numeric(length(param_names))
      grad[1]   <- 1 / den
      grad[-1]  <- gamma_j / den^2
      V_sub     <- vc[idx, idx, drop = FALSE]
      se_lr[j]  <- sqrt(as.numeric(t(grad) %*% V_sub %*% grad))
    }

    t_lr <- as.numeric(dummy_lr) / se_lr
    p_lr <- 2 * pt(abs(t_lr), df = df.residual(fit_ardl), lower.tail = FALSE)

    dummy_table <- data.frame(
      Term         = dummy_names,
      Estimate     = as.numeric(dummy_lr),
      `Std. Error` = se_lr,
      `t value`    = t_lr,
      `Pr(>|t|)`   = p_lr,
      stringsAsFactors = FALSE
    )
    names(dummy_table) <- names(lr_mult)
  }

  lr_full_table <- if (!is.null(dummy_table)) rbind(lr_mult, dummy_table) else lr_mult
  list(lr_full_table = lr_full_table, den = den)
}

extract_lr_row <- function(lr_full, term) {
  if (is.null(lr_full) || !("Term" %in% names(lr_full))) return(list(est = NA_real_, se = NA_real_, p = NA_real_))
  rr <- lr_full[lr_full$Term == term, , drop = FALSE]
  if (nrow(rr) == 0) return(list(est = NA_real_, se = NA_real_, p = NA_real_))
  p_col <- intersect(c("Pr(>|t|)", "Pr...t..", "p.value", "p_value"), names(rr))[1]
  se_col <- intersect(c("Std. Error", "Std..Error"), names(rr))[1]
  list(
    est = suppressWarnings(as.numeric(rr$Estimate[1])),
    se  = if (!is.na(se_col)) suppressWarnings(as.numeric(rr[[se_col]][1])) else NA_real_,
    p   = if (!is.na(p_col)) suppressWarnings(as.numeric(rr[[p_col]][1])) else NA_real_
  )
}

extract_alpha_from_uecm <- function(fit_ardl, lnY_name = "lnY") {
  uecm_model <- ARDL::uecm(fit_ardl)
  uecm_coef <- tryCatch(summary(uecm_model)$coefficients, error = function(e) NULL)
  if (is.null(uecm_coef)) return(list(est = NA_real_, se = NA_real_, p = NA_real_))
  rr <- grep(paste0("^L\\(", lnY_name, ", 1\\)$"), rownames(uecm_coef), value = TRUE)
  if (length(rr) == 1) {
    return(list(
      est = as.numeric(uecm_coef[rr, "Estimate"]),
      se  = as.numeric(uecm_coef[rr, "Std. Error"]),
      p   = as.numeric(uecm_coef[rr, "Pr(>|t|)"])
    ))
  }
  list(est = NA_real_, se = NA_real_, p = NA_real_)
}

run_residual_diagnostics <- function(fit) {
  resids <- as.numeric(residuals(fit))
  n <- length(resids)
  diag_list <- list()

  # Breusch-Godfrey (lag 1)
  bg1 <- tryCatch(lmtest::bgtest(fit, order = 1), error = function(e) NULL)
  diag_list$bg1_stat <- if (!is.null(bg1)) bg1$statistic else NA_real_
  diag_list$bg1_p    <- if (!is.null(bg1)) bg1$p.value else NA_real_

  # Breusch-Godfrey (lag 4)
  bg4 <- tryCatch(lmtest::bgtest(fit, order = 4), error = function(e) NULL)
  diag_list$bg4_stat <- if (!is.null(bg4)) bg4$statistic else NA_real_
  diag_list$bg4_p    <- if (!is.null(bg4)) bg4$p.value else NA_real_

  # ARCH(1) — manual Engle LM test
  e2 <- resids^2
  if (n > 2) {
    arch_fit <- tryCatch(lm(e2[2:n] ~ e2[1:(n - 1)]), error = function(e) NULL)
    if (!is.null(arch_fit)) {
      arch_r2 <- summary(arch_fit)$r.squared
      arch_stat <- arch_r2 * (n - 1)
      diag_list$arch1_stat <- arch_stat
      diag_list$arch1_p    <- pchisq(arch_stat, df = 1, lower.tail = FALSE)
    } else {
      diag_list$arch1_stat <- NA_real_
      diag_list$arch1_p    <- NA_real_
    }
  } else {
    diag_list$arch1_stat <- NA_real_
    diag_list$arch1_p    <- NA_real_
  }

  # Ramsey RESET
  reset <- tryCatch(lmtest::resettest(fit, power = 2:3), error = function(e) NULL)
  diag_list$reset_stat <- if (!is.null(reset)) reset$statistic else NA_real_
  diag_list$reset_p    <- if (!is.null(reset)) reset$p.value else NA_real_

  # Jarque-Bera normality
  jb <- tryCatch(tseries::jarque.bera.test(resids), error = function(e) NULL)
  diag_list$jb_stat <- if (!is.null(jb)) jb$statistic else NA_real_
  diag_list$jb_p    <- if (!is.null(jb)) jb$p.value else NA_real_

  diag_list
}

# ============================================================
# STEP 0 — VERIFY SHAIKH'S OUTPUT SERIES FROM APPENDIX 6.8
# ============================================================
cat("============================================================\n")
cat("STEP 0 — Appendix 6.8 Series Verification\n")
cat("============================================================\n\n")

app68_path <- here::here("data/raw/_Appendix6.8DataTablesCorrected.xlsx")
tryCatch({
  if (!file.exists(app68_path)) {
    cat("WARNING: Appendix 6.8 file not found at:", app68_path, "\n")
    cat("Skipping Step 0 verification.\n\n")
  } else {
    sheets <- readxl::excel_sheets(app68_path)
    cat("Sheets available (", length(sheets), "):\n", sep = "")
    for (i in seq_along(sheets)) cat("  [", i, "] ", sheets[i], "\n", sep = "")
    cat("\n")

    # Attempt to find Table I.1 (income / GVA)
    i1_idx <- grep("I\\.1|I1|income|GVA", sheets, ignore.case = TRUE)
    if (length(i1_idx) > 0) {
      sheet_I1 <- readxl::read_excel(app68_path, sheet = sheets[i1_idx[1]])
      cat("Table I.1 (sheet '", sheets[i1_idx[1]], "') — first 15 rows:\n", sep = "")
      print(head(sheet_I1, 15))
      cat("\n")
      cat("Q1: Is Table I.1 line 1 all domestic corporate or nonfinancial corporate?\n")
      cat("    => Inspect column headers above to determine.\n\n")
    } else {
      cat("No sheet matching 'I.1' or 'income' found.\n\n")
    }

    # Attempt to find Table II.5 (capital stock)
    ii5_idx <- grep("II\\.5|II5|capital|stock", sheets, ignore.case = TRUE)
    if (length(ii5_idx) > 0) {
      sheet_II5 <- readxl::read_excel(app68_path, sheet = sheets[ii5_idx[1]])
      cat("Table II.5 (sheet '", sheets[ii5_idx[1]], "') — first 20 rows:\n", sep = "")
      print(head(sheet_II5, 20))
      cat("\n")
    } else {
      cat("No sheet matching 'II.5' or 'capital' found.\n\n")
    }
  }
}, error = function(e) {
  cat("WARNING: Step 0 Appendix 6.8 audit failed:", conditionMessage(e), "\n\n")
})

# ============================================================
# STEP 1 — DATA PREP
# ============================================================
cat("============================================================\n")
cat("STEP 1 — Data Preparation\n")
cat("============================================================\n\n")

primary_path <- here::here(CONFIG$data_shaikh)
if (file.exists(primary_path)) {
  df_raw <- readr::read_csv(primary_path, show_col_types = FALSE)
  col_y <- CONFIG$y_nom      # "GVAcorp"
  col_k <- CONFIG$k_nom      # "KGCcorp"
  col_p <- CONFIG$p_index    # "Py"
  base_year <- 2017L
  data_source <- "processed"
  cat("Data source: ", primary_path, " (processed)\n", sep = "")
} else {
  fallback_path <- here::here("data/raw/Shaikh_canonical_series_v1.csv")
  stopifnot(file.exists(fallback_path))
  df_raw <- readr::read_csv(fallback_path, show_col_types = FALSE)
  col_y <- "VAcorp"
  col_k <- "KGCcorp"
  col_p <- "pIGcorpbea"
  base_year <- 2005L
  data_source <- "raw_fallback"
  cat("FALLBACK: Using raw Shaikh CSV\n")
  cat("  Columns: Y=", col_y, " | K=", col_k, " | P=", col_p, "\n", sep = "")
  cat("  Base year: ", base_year, "\n", sep = "")
}

# Check for GVA_nfc column
if ("GVA_nfc" %in% names(df_raw)) {
  cat("GVA_nfc column found in dataset.\n")
} else {
  cat("No GVA_nfc column — using ", col_y, " as Y series.\n", sep = "")
}

# Build price ledger
p_ledger <- df_raw |>
  transmute(
    year  = as.integer(.data[["year"]]),
    p_raw = as.numeric(.data[[col_p]])
  ) |>
  filter(is.finite(year), is.finite(p_raw), p_raw > 0) |>
  arrange(year)

stopifnot(any(p_ledger$year == base_year))

p_ledger <- p_ledger |>
  mutate(p_rebased = rebase_to_year_to_100(p_raw, year, base_year, strict = TRUE)) |>
  select(year, p_rebased)

# Build main data frame
df0 <- df_raw |>
  transmute(
    year  = as.integer(.data[["year"]]),
    Y_nom = as.numeric(.data[[col_y]]),
    K_nom = as.numeric(.data[[col_k]]),
    u_shaikh = if ("uK" %in% names(df_raw)) as.numeric(.data[["uK"]]) else NA_real_
  ) |>
  filter(is.finite(year), is.finite(Y_nom), is.finite(K_nom)) |>
  arrange(year) |>
  left_join(p_ledger, by = "year")

stopifnot(all(is.finite(df0$p_rebased)))

# Window lock
w <- CONFIG$WINDOWS_LOCKED[[WINDOW_TAG]]
stopifnot(!is.null(w), length(w) == 2)
WINDOW_START <- as.integer(w[1])
WINDOW_END   <- as.integer(w[2])

df0 <- df0 |>
  filter(year >= WINDOW_START, year <= WINDOW_END) |>
  arrange(year)

T_obs <- nrow(df0)
cat("Window:    ", WINDOW_TAG, " (", min(df0$year), "-", max(df0$year), ")\n", sep = "")
cat("T=", T_obs, " obs\n", sep = "")
stopifnot(T_obs == 65)

# Cross-check Appendix 6.8 GVA value
gva_1947 <- df0$Y_nom[df0$year == 1947]
cat("GVAcorp 1947 (from dataset): ", round(gva_1947, 2), "\n", sep = "")
cat("  (Check against Appendix 6.8 Table I.1 to confirm series identity)\n\n")

# Dummies + real logs
df0 <- make_dummies(df0, DUMMY_YEARS, CONFIG$SHOCK_TYPE)
dummy_names <- paste0("d", DUMMY_YEARS)

df <- df0 |>
  mutate(
    p_scale = p_rebased / 100,
    Y_real  = Y_nom / p_scale,
    K_real  = K_nom / p_scale,
    lnY     = log(Y_real),
    lnK     = log(K_real)
  )

cat("Data loaded: T=", T_obs, " obs, years ", min(df$year), "-", max(df$year),
    " | lnY_1947: ", round(df$lnY[df$year == 1947], 4),
    " | lnK_1947: ", round(df$lnK[df$year == 1947], 4),
    " | Y series: ", col_y, " (", data_source, ")\n\n", sep = "")

# Cast to ts
df_ts <- ts(df |> select(all_of(c("lnY", "lnK", dummy_names))),
            start = min(df$year), frequency = 1)

# ============================================================
# STEP 3 — ARDL PACKAGE VERSION CHECK
# ============================================================
cat("============================================================\n")
cat("STEP 3 — ARDL Package Version Check\n")
cat("============================================================\n\n")

ardl_ver <- packageVersion("ARDL")
cat("ARDL package version: ", as.character(ardl_ver), "\n", sep = "")
if (ardl_ver < "0.2.3") {
  stop("ARDL >= 0.2.3 required for exact=TRUE bounds tests. Found: ", ardl_ver)
}
cat("Version check PASSED.\n\n")

# ============================================================
# STEP 4 — GRID SEARCH (20 specifications)
# ============================================================
cat("============================================================\n")
cat("STEP 4 — Grid Search\n")
cat("============================================================\n\n")

grid <- expand.grid(p = P_RANGE, q = Q_RANGE, KEEP.OUT.ATTRS = FALSE)
N_SPECS <- nrow(grid)
cat("Grid: ", N_SPECS, " specifications (p x q = ",
    length(P_RANGE), " x ", length(Q_RANGE), ")\n\n", sep = "")

# Formula for Case 3
dum_str <- paste(dummy_names, collapse = " + ")
fml <- as.formula(paste0("lnY ~ lnK | ", dum_str))

# Storage
fit_store  <- vector("list", N_SPECS)
grid_rows  <- vector("list", N_SPECS)

for (i in seq_len(N_SPECS)) {
  pp <- grid$p[i]
  qq <- grid$q[i]
  spec_tag <- sprintf("ARDL(%d,%d)", pp, qq)

  row <- list(
    p = pp, q = qq, case = CASE,
    AIC = NA_real_, BIC = NA_real_, HQ = NA_real_,
    logLik = NA_real_, k_total = NA_integer_, T_eff = NA_integer_,
    F_stat = NA_real_, F_pval = NA_real_,
    F_I0_10 = NA_real_, F_I1_10 = NA_real_,
    F_I0_05 = NA_real_, F_I1_05 = NA_real_,
    F_I0_01 = NA_real_, F_I1_01 = NA_real_,
    t_stat = NA_real_, t_pval = NA_real_,
    t_I0_10 = NA_real_, t_I1_10 = NA_real_,
    t_I0_05 = NA_real_, t_I1_05 = NA_real_,
    t_I0_01 = NA_real_, t_I1_01 = NA_real_,
    failed = FALSE, error_msg = ""
  )

  tryCatch({
    fit <- ARDL::ardl(formula = fml, data = df_ts, order = c(pp, qq))
    fit_store[[i]] <- fit

    # IC extraction
    row$logLik  <- as.numeric(logLik(fit))
    row$k_total <- length(coef(fit))
    row$T_eff   <- length(residuals(fit))
    row$AIC     <- AIC(fit)
    row$BIC     <- BIC(fit)
    row$HQ      <- -2 * row$logLik + 2 * log(log(row$T_eff)) * row$k_total

    # F-bounds at three alpha levels
    alphas <- c(0.10, 0.05, 0.01)
    for (aa in alphas) {
      bt_f <- tryCatch(
        ARDL::bounds_f_test(fit, case = CASE, alpha = aa, pvalue = TRUE, exact = EXACT_TEST),
        error = function(e) list(statistic = NA_real_, p.value = NA_real_)
      )
      bf <- extract_bt(bt_f)
      if (aa == 0.10) { row$F_stat <- bf$stat; row$F_pval <- bf$pval }

      # Extract I(0)/I(1) bounds from the test object
      I0 <- NA_real_; I1 <- NA_real_
      if (is.list(bt_f)) {
        # Try common field names in ARDL bounds test objects
        if (!is.null(bt_f$tab)) {
          tab <- bt_f$tab
          if (is.matrix(tab) || is.data.frame(tab)) {
            I0 <- tryCatch(as.numeric(tab[1, 1]), error = function(e) NA_real_)
            I1 <- tryCatch(as.numeric(tab[1, 2]), error = function(e) NA_real_)
          }
        }
        if (is.na(I0) && !is.null(bt_f$parameters)) {
          params <- bt_f$parameters
          if (length(params) >= 2) { I0 <- params[1]; I1 <- params[2] }
        }
      }

      suffix <- gsub("\\.", "", sprintf("%02.0f", aa * 100))
      row[[paste0("F_I0_", suffix)]] <- I0
      row[[paste0("F_I1_", suffix)]] <- I1
    }

    # t-bounds at three alpha levels
    for (aa in alphas) {
      bt_t <- tryCatch(
        ARDL::bounds_t_test(fit, case = CASE, alpha = aa, pvalue = TRUE, exact = EXACT_TEST),
        error = function(e) list(statistic = NA_real_, p.value = NA_real_)
      )
      bt <- extract_bt(bt_t)
      if (aa == 0.10) { row$t_stat <- bt$stat; row$t_pval <- bt$pval }

      I0 <- NA_real_; I1 <- NA_real_
      if (is.list(bt_t)) {
        if (!is.null(bt_t$tab)) {
          tab <- bt_t$tab
          if (is.matrix(tab) || is.data.frame(tab)) {
            I0 <- tryCatch(as.numeric(tab[1, 1]), error = function(e) NA_real_)
            I1 <- tryCatch(as.numeric(tab[1, 2]), error = function(e) NA_real_)
          }
        }
        if (is.na(I0) && !is.null(bt_t$parameters)) {
          params <- bt_t$parameters
          if (length(params) >= 2) { I0 <- params[1]; I1 <- params[2] }
        }
      }

      suffix <- gsub("\\.", "", sprintf("%02.0f", aa * 100))
      row[[paste0("t_I0_", suffix)]] <- I0
      row[[paste0("t_I1_", suffix)]] <- I1
    }

  }, error = function(e) {
    row$failed    <<- TRUE
    row$error_msg <<- conditionMessage(e)
  })

  grid_rows[[i]] <- as.data.frame(row, stringsAsFactors = FALSE)

  # Progress line
  cat(sprintf("[%s Case %d] F=%.2f (p=%.3f%s) | t=%.2f (p=%.3f%s) | AIC=%.1f | BIC=%.1f | HQ=%.1f%s\n",
              spec_tag, CASE,
              ifelse(is.finite(row$F_stat), row$F_stat, NA),
              ifelse(is.finite(row$F_pval), row$F_pval, NA),
              sig_stars(row$F_pval),
              ifelse(is.finite(row$t_stat), row$t_stat, NA),
              ifelse(is.finite(row$t_pval), row$t_pval, NA),
              sig_stars(row$t_pval),
              ifelse(is.finite(row$AIC), row$AIC, NA),
              ifelse(is.finite(row$BIC), row$BIC, NA),
              ifelse(is.finite(row$HQ), row$HQ, NA),
              ifelse(row$failed, " [FAIL]", "")))
}

lattice <- bind_rows(grid_rows)
cat("\nGrid search complete: ", N_SPECS, " specs estimated.\n\n", sep = "")

# ============================================================
# STEP 5 — ADMISSIBILITY GATES
# ============================================================
cat("============================================================\n")
cat("STEP 5 — Admissibility Gates\n")
cat("============================================================\n\n")

lattice$F_pass <- !lattice$failed & !is.na(lattice$F_pval) & lattice$F_pval < F_GATE_ALPHA
lattice$t_pass <- !lattice$failed & !is.na(lattice$t_pval) & lattice$t_pval < T_GATE_ALPHA
lattice$admissible <- lattice$F_pass & lattice$t_pass

n_total    <- nrow(lattice)
n_failed   <- sum(lattice$failed)
n_F_only   <- sum(lattice$F_pass & !lattice$t_pass)
n_t_only   <- sum(!lattice$F_pass & lattice$t_pass)
n_both     <- sum(lattice$admissible)
n_neither  <- n_total - n_failed - n_F_only - n_t_only - n_both

cat("Total specs:      ", n_total, "\n")
cat("Failed:           ", n_failed, "\n")
cat("F-pass only:      ", n_F_only, "\n")
cat("t-pass only:      ", n_t_only, "\n")
cat("Both pass (admissible): ", n_both, "\n")
cat("Neither pass:     ", n_neither, "\n\n")

A_set <- lattice |> filter(admissible)

if (n_both == 0) {
  cat("*** WARNING: Admissible set is EMPTY. No specs pass both gates at 10%. ***\n")
  cat("*** IC winner selection cannot proceed. Shaikh anchor will still be reported. ***\n\n")
}

# ============================================================
# STEP 6 — IC WINNER SELECTION
# ============================================================
cat("============================================================\n")
cat("STEP 6 — IC Winner Selection\n")
cat("============================================================\n\n")

ic_winners <- data.frame()
consensus <- FALSE

if (nrow(A_set) > 0) {
  aic_win <- A_set[which.min(A_set$AIC), ]
  bic_win <- A_set[which.min(A_set$BIC), ]
  hq_win  <- A_set[which.min(A_set$HQ), ]

  cat("AIC winner: ARDL(", aic_win$p, ",", aic_win$q, ") Case ", CASE,
      " | AIC=", round(aic_win$AIC, 1), "\n", sep = "")
  cat("BIC winner: ARDL(", bic_win$p, ",", bic_win$q, ") Case ", CASE,
      " | BIC=", round(bic_win$BIC, 1), "\n", sep = "")
  cat("HQ winner:  ARDL(", hq_win$p, ",", hq_win$q, ") Case ", CASE,
      " | HQ=",  round(hq_win$HQ, 1),  "\n", sep = "")

  # Build IC_winner label column
  lattice$IC_winner <- ""
  aic_key <- paste(aic_win$p, aic_win$q)
  bic_key <- paste(bic_win$p, bic_win$q)
  hq_key  <- paste(hq_win$p, hq_win$q)

  for (r in seq_len(nrow(lattice))) {
    key <- paste(lattice$p[r], lattice$q[r])
    tags <- c()
    if (key == aic_key) tags <- c(tags, "AIC")
    if (key == bic_key) tags <- c(tags, "BIC")
    if (key == hq_key)  tags <- c(tags, "HQ")
    lattice$IC_winner[r] <- paste(tags, collapse = "+")
  }

  # Check CONSENSUS
  if (aic_key == bic_key && bic_key == hq_key) {
    consensus <- TRUE
    cat("\n*** CONSENSUS: All three ICs select ARDL(", aic_win$p, ",", aic_win$q, ") ***\n", sep = "")
    lattice$IC_winner[lattice$IC_winner == "AIC+BIC+HQ"] <- "CONSENSUS"
  }

  # Deduplicated IC winners for diagnostics
  winner_keys <- unique(c(aic_key, bic_key, hq_key))
  for (wk in winner_keys) {
    ic_winners <- bind_rows(ic_winners, lattice[paste(lattice$p, lattice$q) == wk, ][1, ])
  }

  # Flag Shaikh benchmark in admissible set
  shaikh_in_admissible <- any(A_set$p == SHAIKH_ANCHOR[1] & A_set$q == SHAIKH_ANCHOR[2])
  cat("\nShaikh ARDL(2,4) in admissible set: ", ifelse(shaikh_in_admissible, "YES", "NO"), "\n\n", sep = "")
} else {
  lattice$IC_winner <- ""
  cat("No admissible specs — IC winner selection skipped.\n\n")
}

# ============================================================
# STEP 7 — FULL RESULTS TABLE
# ============================================================
cat("============================================================\n")
cat("STEP 7 — Full Results Table (sorted by AIC)\n")
cat("============================================================\n\n")

lattice$F_sig <- sapply(lattice$F_pval, sig_stars)
lattice$t_sig <- sapply(lattice$t_pval, sig_stars)

lattice_sorted <- lattice |> arrange(AIC)
lattice_sorted$Rank <- seq_len(nrow(lattice_sorted))

# Print table
print_cols <- c("Rank", "p", "q", "AIC", "BIC", "HQ",
                "F_stat", "F_pval", "F_sig",
                "t_stat", "t_pval", "t_sig",
                "admissible", "IC_winner")
print_df <- lattice_sorted[, print_cols]
print_df$AIC    <- round(print_df$AIC, 1)
print_df$BIC    <- round(print_df$BIC, 1)
print_df$HQ     <- round(print_df$HQ, 1)
print_df$F_stat <- round(print_df$F_stat, 2)
print_df$F_pval <- round(print_df$F_pval, 3)
print_df$t_stat <- round(print_df$t_stat, 2)
print_df$t_pval <- round(print_df$t_pval, 3)

for (r in seq_len(nrow(print_df))) {
  cat(sprintf("Rank %2d | ARDL(%d,%d) | AIC=%7.1f | BIC=%7.1f | HQ=%7.1f | F=%5.2f (p=%.3f%3s) | t=%6.2f (p=%.3f%3s) | %s | %s\n",
              print_df$Rank[r], print_df$p[r], print_df$q[r],
              print_df$AIC[r], print_df$BIC[r], print_df$HQ[r],
              print_df$F_stat[r], print_df$F_pval[r], print_df$F_sig[r],
              print_df$t_stat[r], print_df$t_pval[r], print_df$t_sig[r],
              ifelse(print_df$admissible[r], "ADMISSIBLE", "FAIL"),
              print_df$IC_winner[r]))
}
cat("\n")

# ============================================================
# STEP 8 — WINNER DIAGNOSTICS + SHAIKH ANCHOR
# ============================================================
cat("============================================================\n")
cat("STEP 8 — Winner Diagnostics + Shaikh Benchmark Anchor\n")
cat("============================================================\n\n")

# Collect specs to diagnose: IC winners + Shaikh anchor
diag_specs <- list()

if (nrow(ic_winners) > 0) {
  for (r in seq_len(nrow(ic_winners))) {
    key <- paste0(ic_winners$p[r], ",", ic_winners$q[r])
    diag_specs[[key]] <- list(p = ic_winners$p[r], q = ic_winners$q[r],
                              label = ic_winners$IC_winner[r])
  }
}

# Always add Shaikh anchor
shaikh_key <- paste0(SHAIKH_ANCHOR[1], ",", SHAIKH_ANCHOR[2])
if (is.null(diag_specs[[shaikh_key]])) {
  diag_specs[[shaikh_key]] <- list(p = SHAIKH_ANCHOR[1], q = SHAIKH_ANCHOR[2],
                                   label = "SHAIKH_ANCHOR")
} else {
  diag_specs[[shaikh_key]]$label <- paste(diag_specs[[shaikh_key]]$label, "+ SHAIKH_ANCHOR")
}

diag_results <- list()

for (key in names(diag_specs)) {
  spec <- diag_specs[[key]]
  pp <- spec$p; qq <- spec$q
  spec_tag <- sprintf("ARDL(%d,%d)", pp, qq)
  label <- spec$label

  cat("=== IC WINNER: ", spec_tag, " Case ", CASE, " [", label, "] ===\n\n", sep = "")

  # Find stored fit or re-estimate
  grid_idx <- which(grid$p == pp & grid$q == qq)
  fit <- fit_store[[grid_idx]]
  if (is.null(fit)) {
    cat("  Re-estimating (fit not stored)...\n")
    fit <- tryCatch(
      ARDL::ardl(formula = fml, data = df_ts, order = c(pp, qq)),
      error = function(e) NULL
    )
    if (is.null(fit)) {
      cat("  FAILED to estimate. Skipping diagnostics.\n\n")
      next
    }
  }

  # --- Bounds tests (exact, all alpha levels) ---
  cat("  Bounds tests (exact, T=", length(residuals(fit)), "):\n", sep = "")

  alphas <- c(0.10, 0.05, 0.01)
  alpha_labels <- c("10%", " 5%", " 1%")

  # F-bounds
  f_detail <- list()
  for (j in seq_along(alphas)) {
    bt_f <- tryCatch(
      ARDL::bounds_f_test(fit, case = CASE, alpha = alphas[j], pvalue = TRUE, exact = EXACT_TEST),
      error = function(e) list(statistic = NA_real_, p.value = NA_real_)
    )
    f_detail[[j]] <- bt_f
  }
  bf <- extract_bt(f_detail[[1]])
  cat(sprintf("    F-bounds: Stat=%.2f | p=%.3f %s\n", bf$stat, bf$pval, sig_stars(bf$pval)))

  for (j in seq_along(alphas)) {
    bt <- f_detail[[j]]
    I0 <- NA_real_; I1 <- NA_real_
    if (is.list(bt) && !is.null(bt$tab)) {
      tab <- bt$tab
      if (is.matrix(tab) || is.data.frame(tab)) {
        I0 <- tryCatch(as.numeric(tab[1, 1]), error = function(e) NA_real_)
        I1 <- tryCatch(as.numeric(tab[1, 2]), error = function(e) NA_real_)
      }
    }
    if (is.na(I0) && is.list(bt) && !is.null(bt$parameters)) {
      params <- bt$parameters
      if (length(params) >= 2) { I0 <- params[1]; I1 <- params[2] }
    }
    pos <- if (is.finite(bf$stat) && is.finite(I0) && is.finite(I1)) {
      if (bf$stat > I1) "above" else if (bf$stat < I0) "below" else "between"
    } else "NA"
    cat(sprintf("      alpha=%s: I(0)=%.2f | I(1)=%.2f | [%s]\n",
                alpha_labels[j],
                ifelse(is.finite(I0), I0, NA), ifelse(is.finite(I1), I1, NA), pos))
  }

  # t-bounds
  t_detail <- list()
  for (j in seq_along(alphas)) {
    bt_t <- tryCatch(
      ARDL::bounds_t_test(fit, case = CASE, alpha = alphas[j], pvalue = TRUE, exact = EXACT_TEST),
      error = function(e) list(statistic = NA_real_, p.value = NA_real_)
    )
    t_detail[[j]] <- bt_t
  }
  bt_val <- extract_bt(t_detail[[1]])
  cat(sprintf("    t-bounds: Stat=%.2f | p=%.3f %s\n", bt_val$stat, bt_val$pval, sig_stars(bt_val$pval)))

  for (j in seq_along(alphas)) {
    bt <- t_detail[[j]]
    I0 <- NA_real_; I1 <- NA_real_
    if (is.list(bt) && !is.null(bt$tab)) {
      tab <- bt$tab
      if (is.matrix(tab) || is.data.frame(tab)) {
        I0 <- tryCatch(as.numeric(tab[1, 1]), error = function(e) NA_real_)
        I1 <- tryCatch(as.numeric(tab[1, 2]), error = function(e) NA_real_)
      }
    }
    if (is.na(I0) && is.list(bt) && !is.null(bt$parameters)) {
      params <- bt$parameters
      if (length(params) >= 2) { I0 <- params[1]; I1 <- params[2] }
    }
    # t-stat is negative, compare abs
    pos <- if (is.finite(bt_val$stat) && is.finite(I0) && is.finite(I1)) {
      if (bt_val$stat < I1) "above" else if (bt_val$stat > I0) "below" else "between"
    } else "NA"
    cat(sprintf("      alpha=%s: I(0)=%.2f | I(1)=%.2f | [%s]\n",
                alpha_labels[j],
                ifelse(is.finite(I0), I0, NA), ifelse(is.finite(I1), I1, NA), pos))
  }

  # --- Long-run coefficients ---
  cat("\n  Long-run:\n")
  lr_pack <- tryCatch(
    get_lr_table_with_scaled_dummies(fit, lnY_name = "lnY", dummy_names = dummy_names),
    error = function(e) NULL
  )
  if (!is.null(lr_pack)) {
    lr_full <- lr_pack$lr_full_table
    theta <- extract_lr_row(lr_full, "lnK")
    intcpt <- extract_lr_row(lr_full, "(Intercept)")
    cat(sprintf("    theta (lnK): %.4f | SE=%.4f | p=%.4f %s\n",
                theta$est, theta$se, theta$p, sig_stars(theta$p)))
    cat(sprintf("    intercept:   %.4f | SE=%.4f | p=%.4f %s\n",
                intcpt$est, intcpt$se, intcpt$p, sig_stars(intcpt$p)))
  } else {
    cat("    LR multiplier extraction failed.\n")
    lr_full <- NULL
  }

  # --- ECM speed of adjustment ---
  cat("\n  ECM:\n")
  alpha_ecm <- extract_alpha_from_uecm(fit, lnY_name = "lnY")
  cat(sprintf("    alpha (L(lnY,1)): %.4f | SE=%.4f | p=%.4f %s\n",
              alpha_ecm$est, alpha_ecm$se, alpha_ecm$p, sig_stars(alpha_ecm$p)))

  # --- SR structural dummies ---
  cat("\n  SR structural dummies:\n")
  coefs_fit <- coef(fit)
  for (dn in dummy_names) {
    val <- if (dn %in% names(coefs_fit)) coefs_fit[dn] else NA_real_
    # Get p-value from summary
    sm <- tryCatch(summary(fit)$coefficients, error = function(e) NULL)
    pv <- NA_real_
    if (!is.null(sm) && dn %in% rownames(sm)) {
      pv <- sm[dn, "Pr(>|t|)"]
    }
    cat(sprintf("    c_%s: %.4f | p=%.4f %s\n", dn, val, pv, sig_stars(pv)))
  }

  # --- Residual diagnostics ---
  cat("\n  Residual diagnostics:\n")
  diag <- run_residual_diagnostics(fit)
  cat(sprintf("    Breusch-Godfrey (lag 1): p=%.4f %s\n", diag$bg1_p, sig_stars(diag$bg1_p)))
  cat(sprintf("    Breusch-Godfrey (lag 4): p=%.4f %s\n", diag$bg4_p, sig_stars(diag$bg4_p)))
  cat(sprintf("    ARCH (lag 1):            p=%.4f %s\n", diag$arch1_p, sig_stars(diag$arch1_p)))
  cat(sprintf("    RESET:                   p=%.4f %s\n", diag$reset_p, sig_stars(diag$reset_p)))
  cat(sprintf("    Jarque-Bera normality:   p=%.4f %s\n", diag$jb_p, sig_stars(diag$jb_p)))

  # --- IC coordinates ---
  grid_row <- lattice[lattice$p == pp & lattice$q == qq, ]
  cat(sprintf("\n  IC coordinates: AIC=%.1f | BIC=%.1f | HQ=%.1f\n",
              grid_row$AIC, grid_row$BIC, grid_row$HQ))

  # --- Admissibility check for anchor ---
  if (grepl("SHAIKH_ANCHOR", label)) {
    cat("\n  --- SHAIKH BENCHMARK ANCHOR ---\n")
    is_adm <- grid_row$admissible
    cat("  Admissible under redesign criteria: ", ifelse(is_adm, "YES", "NO"), "\n", sep = "")
    if (!is_adm) {
      if (!grid_row$F_pass) {
        cat("    Gate 1 (F-bounds) FAILS: p=", round(grid_row$F_pval, 4), "\n", sep = "")
      }
      if (!grid_row$t_pass) {
        cat("    Gate 2 (t-bounds) FAILS: p=", round(grid_row$t_pval, 4), "\n", sep = "")
      }
    }
  }

  cat("\n")

  # Store diagnostics for CSV
  diag_results[[key]] <- list(
    spec = spec_tag, label = label,
    F_stat = bf$stat, F_pval = bf$pval,
    t_stat = bt_val$stat, t_pval = bt_val$pval,
    theta = if (!is.null(lr_pack)) theta$est else NA,
    theta_se = if (!is.null(lr_pack)) theta$se else NA,
    theta_p = if (!is.null(lr_pack)) theta$p else NA,
    intercept = if (!is.null(lr_pack)) intcpt$est else NA,
    alpha_ecm = alpha_ecm$est,
    bg1_p = diag$bg1_p, bg4_p = diag$bg4_p,
    arch1_p = diag$arch1_p, reset_p = diag$reset_p, jb_p = diag$jb_p,
    AIC = grid_row$AIC, BIC = grid_row$BIC, HQ = grid_row$HQ,
    admissible = grid_row$admissible
  )
}

# ============================================================
# STEP 9 — SAVE OUTPUTS
# ============================================================
cat("============================================================\n")
cat("STEP 9 — Save Outputs\n")
cat("============================================================\n\n")

# Full grid
safe_write_csv(lattice_sorted, file.path(CSV_DIR, "S0_redesign_full_grid.csv"))
cat("Saved: S0_redesign_full_grid.csv (", nrow(lattice_sorted), " rows)\n", sep = "")

# Admissible subset
if (nrow(A_set) > 0) {
  safe_write_csv(A_set |> arrange(AIC), file.path(CSV_DIR, "S0_redesign_admissible.csv"))
  cat("Saved: S0_redesign_admissible.csv (", nrow(A_set), " rows)\n", sep = "")
} else {
  cat("Skipped: S0_redesign_admissible.csv (empty admissible set)\n")
}

# IC winners + anchor
if (length(diag_results) > 0) {
  winners_df <- bind_rows(lapply(diag_results, as.data.frame, stringsAsFactors = FALSE))
  safe_write_csv(winners_df, file.path(CSV_DIR, "S0_redesign_ic_winners.csv"))
  cat("Saved: S0_redesign_ic_winners.csv (", nrow(winners_df), " rows)\n", sep = "")
}

# Report text (the sink log itself serves as the report)
# Copy log to docs
report_path <- file.path(DOC_DIR, "S0_redesign_report.txt")

cat("\n=== S0 Redesign Complete ===\n")
cat("Timestamp: ", now_stamp(), "\n", sep = "")
cat("STAGE_STATUS_HINT: stage=S0_redesign status=complete\n")

# Close sink, then copy log to docs
try(sink(), silent = TRUE)

# Copy log to docs directory as the report
if (file.exists(log_path)) {
  file.copy(log_path, report_path, overwrite = TRUE)
}

cat("S0 Redesign pipeline complete. Outputs in:", EXERCISE_DIR, "\n")
