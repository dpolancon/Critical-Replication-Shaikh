# ============================================================
# 26_S0_redesign_ardl_search.R
#
# S0 Redesign — IC-Guided ARDL Search with Exact Bounds
#
# Motivation: The faithful replication of Shaikh (2016) ARDL(2,4)
# Case 3 fails cointegration under current BEA vintage data
# (F=0.057, p=0.993; t=-0.002, p=0.971). This script implements
# an IC-guided search over theoretically admissible specifications
# (Case 3 only) using exact bounds testing, dual F+t admissibility
# gates, and 5-IC winner selection (AIC/BIC/HQ/ICOMP/RICOMP).
#
# Grid: p in {1,2,3,4}, q in {0,1,2,3,4}, Case 3 = 20 specs
#
# Outputs under: output/CriticalReplication/S0_redesign/
# ============================================================

rm(list = ls())

suppressPackageStartupMessages({
  library(here)
  library(readr)
  library(readxl)
  library(dplyr)
  library(tidyr)
  library(purrr)
  library(stringr)
  library(ARDL)
  library(ggplot2)
  library(lmtest)
  library(tseries)
})

# ------------------------------------------------------------
# Load CONFIG + UTILS
# ------------------------------------------------------------
source(here::here("codes", "10_config.R"))
source(here::here("codes", "99_utils.R"))
source(here::here("codes", "99_figure_protocol.R"))

stopifnot(exists("CONFIG"))
stopifnot(is.list(CONFIG))

# ------------------------------------------------------------
# Output directories
# ------------------------------------------------------------
EXERCISE_DIR <- here::here("output", "CriticalReplication", "S0_redesign")
CSV_DIR      <- file.path(EXERCISE_DIR, "csv")
FIG_DIR      <- file.path(EXERCISE_DIR, "figures")
DOC_DIR      <- file.path(EXERCISE_DIR, "docs")

dir.create(CSV_DIR, recursive = TRUE, showWarnings = FALSE)
dir.create(FIG_DIR, recursive = TRUE, showWarnings = FALSE)
dir.create(DOC_DIR, recursive = TRUE, showWarnings = FALSE)

# Sink to report file
report_path <- file.path(DOC_DIR, "S0_redesign_report.txt")
sink(report_path, split = TRUE)
on.exit(try(sink(), silent = TRUE), add = TRUE)

cat("=============================================================\n")
cat("S0 REDESIGN — IC-Guided ARDL Search with Exact Bounds\n")
cat("Timestamp:", now_stamp(), "\n")
cat("=============================================================\n\n")

# ============================================================
# STEP 0 — LOAD REFERENCE SERIES: uK AND uFRB
# ============================================================
cat("--- STEP 0: Load reference utilization series ---\n")

ref_csv <- here::here("data", "raw", "Shaikh_canonical_series_v1.csv")
ref_data <- readr::read_csv(ref_csv, show_col_types = FALSE)

# Extract uK and uFRB from canonical CSV (preferred source)
uK_source <- "Shaikh_canonical_series_v1.csv"
uFRB_source <- "Shaikh_canonical_series_v1.csv"

ref_uK <- ref_data %>%
  filter(!is.na(year)) %>%
  transmute(year = as.integer(year),
            uK = as.numeric(uK)) %>%
  filter(is.finite(year))

ref_uFRB <- ref_data %>%
  filter(!is.na(year)) %>%
  transmute(year = as.integer(year),
            uFRB = as.numeric(uFRB)) %>%
  filter(is.finite(year))

has_uK   <- any(is.finite(ref_uK$uK))
has_uFRB <- any(is.finite(ref_uFRB$uFRB))

if (has_uK) {
  uK_vec <- ref_uK %>% filter(is.finite(uK))
  cat("uK source:", uK_source, "\n")
  cat("uK 1947-1951:",
      paste(round(head(uK_vec$uK[uK_vec$year >= 1947], 5), 4), collapse = ", "), "\n")
} else {
  cat("WARNING: uK not available in CSV — attempting Excel fallback\n")
  uK_source <- "Excel fallback attempted"
}

if (has_uFRB) {
  uFRB_vec <- ref_uFRB %>% filter(is.finite(uFRB))
  cat("uFRB source:", uFRB_source, "\n")
  cat("uFRB first 5 non-NA:",
      paste(round(head(uFRB_vec$uFRB, 5), 4), collapse = ", "), "\n")
} else {
  cat("WARNING: uFRB not available in CSV — attempting Excel fallback\n")
  # Attempt Excel extraction
  app68 <- here::here("data", "raw", "other", "_Appendix6.8DataTablesCorrected.xlsx")
  if (file.exists(app68)) {
    ws_II7 <- tryCatch(
      read_excel(app68, sheet = "Appndx 6.8.II.7", col_names = FALSE),
      error = function(e) NULL
    )
    if (!is.null(ws_II7)) {
      # Extract year header (row 1, cols 7+)
      years_raw <- as.numeric(ws_II7[1, 7:ncol(ws_II7)])
      # uFRB is row 51
      if (nrow(ws_II7) >= 51) {
        uFRB_raw <- as.numeric(ws_II7[51, 7:ncol(ws_II7)])
        valid <- is.finite(years_raw) & is.finite(uFRB_raw)
        if (any(valid)) {
          ref_uFRB <- tibble(year = as.integer(years_raw[valid]),
                             uFRB = uFRB_raw[valid])
          has_uFRB <- TRUE
          uFRB_source <- "_Appendix6.8DataTablesCorrected.xlsx (row 51)"
          cat("uFRB extracted from Excel, first 5:",
              paste(round(head(ref_uFRB$uFRB, 5), 4), collapse = ", "), "\n")
        }
      }
    }
  }
  if (!has_uFRB) cat("uFRB: NOT AVAILABLE from any source\n")
}
cat("\n")

# ============================================================
# STEP 1 — DATA PREP
# ============================================================
cat("--- STEP 1: Data preparation ---\n")

df_raw <- readr::read_csv(here::here(CONFIG$data_shaikh), show_col_types = FALSE)
stopifnot(all(c("year", "GVAcorp", "KGCcorp", "Py") %in% names(df_raw)))

df <- df_raw %>%
  filter(year >= 1947, year <= 2011) %>%
  arrange(year) %>%
  mutate(
    lnY   = log(GVAcorp / (Py / 100)),
    lnK   = log(KGCcorp / (Py / 100)),
    d1956 = as.integer(year >= 1956),
    d1974 = as.integer(year >= 1974),
    d1980 = as.integer(year >= 1980)
  )

T_obs <- nrow(df)
cat(sprintf("Data loaded: T=%d obs, years %d-%d\n", T_obs, min(df$year), max(df$year)))
cat(sprintf("lnY_1947: %.4f | lnK_1947: %.4f\n", df$lnY[1], df$lnK[1]))
cat("Y series: GVAcorp | K series: KGCcorp | Deflator: Py\n")
stopifnot(T_obs == 65)

# Cast to ts object
dummy_names <- c("d1956", "d1974", "d1980")
df_ts <- ts(df %>% select(lnY, lnK, all_of(dummy_names)),
            start = min(df$year), frequency = 1)

cat("\n")

# ============================================================
# STEP 2 — HELPER FUNCTIONS
# ============================================================

sig_stars <- function(p) {
  dplyr::case_when(
    p < 0.01 ~ "***",
    p < 0.05 ~ "**",
    p < 0.10 ~ "*",
    TRUE     ~ ""
  )
}

stars_from_p <- function(p) {
  if (!is.finite(p)) return("")
  if (p <= 0.01) return("***")
  if (p <= 0.05) return("**")
  if (p <= 0.10) return("*")
  ""
}

compute_icomp <- function(fit, n) {
  k <- length(coef(fit))
  ll <- as.numeric(logLik(fit))
  X <- model.matrix(fit)
  F_hat <- (t(X) %*% X) / n
  tr_F <- sum(diag(F_hat))
  det_F <- det(F_hat)
  if (det_F <= 0) return(NA_real_)
  C1 <- (k / 2) * log(tr_F / k) - (1 / 2) * log(det_F)
  -2 * ll + 2 * C1
}

compute_ricomp <- function(fit, n) {
  k <- length(coef(fit))
  ll <- as.numeric(logLik(fit))
  X <- model.matrix(fit)
  e <- residuals(fit)
  bread <- solve(t(X) %*% X)
  meat  <- t(X) %*% diag(as.numeric(e^2)) %*% X
  V     <- bread %*% meat %*% bread * n
  tr_V <- sum(diag(V))
  det_V <- det(V)
  if (det_V <= 0) return(NA_real_)
  C1 <- (k / 2) * log(tr_V / k) - (1 / 2) * log(det_V)
  -2 * ll + 2 * C1
}

extract_bt <- function(bt_obj) {
  out <- list(stat = NA_real_, pval = NA_real_)
  if (is.list(bt_obj)) {
    if (!is.null(bt_obj$statistic)) out$stat <- suppressWarnings(as.numeric(bt_obj$statistic))
    if (!is.null(bt_obj$p.value))   out$pval <- suppressWarnings(as.numeric(bt_obj$p.value))
  }
  out
}

# Extract I(0) and I(1) critical value bounds from bounds test object
extract_bounds <- function(bt_obj) {
  out <- list(I0 = NA_real_, I1 = NA_real_)
  if (is.list(bt_obj)) {
    # The ARDL package stores critical values in $tab.ci or as attributes
    if (!is.null(bt_obj$tab.ci)) {
      # tab.ci is a matrix with columns I(0) and I(1)
      out$I0 <- as.numeric(bt_obj$tab.ci[1, 1])
      out$I1 <- as.numeric(bt_obj$tab.ci[1, 2])
    } else if (!is.null(bt_obj$critical.value.bounds)) {
      out$I0 <- as.numeric(bt_obj$critical.value.bounds[1])
      out$I1 <- as.numeric(bt_obj$critical.value.bounds[2])
    }
  }
  out
}

# LR multipliers + scaled LR dummy multipliers via delta method
get_lr_table_with_scaled_dummies <- function(fit_ardl, lnY_name = "lnY",
                                              dummy_names = character()) {
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

  lr_full <- if (!is.null(dummy_table)) rbind(lr_mult, dummy_table) else lr_mult
  list(lr_full_table = lr_full, den = den)
}

# Extract ECM speed from UECM
extract_alpha_from_uecm <- function(fit_ardl, lnY_name = "lnY") {
  uecm_model <- ARDL::uecm(fit_ardl)
  uecm_coef <- tryCatch(summary(uecm_model)$coefficients, error = function(e) NULL)
  if (is.null(uecm_coef)) return(list(est = NA_real_, se = NA_real_, pval = NA_real_))
  rr <- grep(paste0("^L\\(", lnY_name, ", 1\\)$"), rownames(uecm_coef), value = TRUE)
  if (length(rr) == 1) {
    return(list(
      est  = as.numeric(uecm_coef[rr, "Estimate"]),
      se   = as.numeric(uecm_coef[rr, "Std. Error"]),
      pval = as.numeric(uecm_coef[rr, "Pr(>|t|)"])
    ))
  }
  list(est = NA_real_, se = NA_real_, pval = NA_real_)
}

# Compute utilization from LR vector
compute_u_from_lr <- function(df, lnY_name, lnK_name, lr_full, dummy_names) {
  a_lr_vec <- lr_full$Estimate[lr_full$Term == "(Intercept)"]
  a_lr <- if (length(a_lr_vec) > 0 && is.finite(a_lr_vec[1])) a_lr_vec[1] else 0

  theta_lr <- lr_full$Estimate[lr_full$Term == lnK_name]

  dummy_coef <- if (length(dummy_names))
    lr_full$Estimate[match(dummy_names, lr_full$Term)] else numeric(0)
  dummy_effect <- if (length(dummy_names))
    rowSums(df[dummy_names] * dummy_coef) else 0

  lnY  <- df[[lnY_name]]
  lnK  <- df[[lnK_name]]
  lnYp <- a_lr + theta_lr * lnK + dummy_effect
  u    <- exp(lnY - lnYp)
  list(u = u, lnYp = lnYp, intercept = a_lr, theta = theta_lr)
}

# ============================================================
# STEP 3 — PACKAGE CHECK
# ============================================================
cat("--- STEP 3: Package check ---\n")
pkg_ver <- packageVersion("ARDL")
cat("ARDL package version:", as.character(pkg_ver), "\n")
if (pkg_ver < "0.2.3") {
  cat("WARNING: installing ARDL >= 0.2.3 for exact=TRUE support\n")
  install.packages("ARDL")
  library(ARDL)
  pkg_ver <- packageVersion("ARDL")
  cat("Updated ARDL version:", as.character(pkg_ver), "\n")
}
cat("\n")

# ============================================================
# STEP 4 — GRID SEARCH
# ============================================================
cat("--- STEP 4: ARDL Grid Search (Case 3, exact=TRUE) ---\n")
cat("Grid: p in {1,2,3,4}, q in {0,1,2,3,4} = 20 specifications\n")
cat("Dummies (LR): d1956, d1974, d1980\n\n")

P_GRID <- 1:4
Q_GRID <- 0:4
CASE   <- 3L
dum_str <- paste(dummy_names, collapse = " + ")
fml <- as.formula(paste0("lnY ~ lnK | ", dum_str))

results_list <- list()
spec_idx <- 0

for (pp in P_GRID) {
  for (qq in Q_GRID) {
    spec_idx <- spec_idx + 1
    spec_label <- sprintf("ARDL(%d,%d)", pp, qq)

    row <- tryCatch({
      # 1. Estimate ARDL
      fit <- ARDL::ardl(formula = fml, data = df_ts, order = c(pp, qq))

      # 2. Information criteria
      ll_val  <- as.numeric(logLik(fit))
      k_total <- length(coef(fit))
      T_eff   <- length(residuals(fit))
      aic_val <- AIC(fit)
      bic_val <- BIC(fit)
      hq_val  <- -2 * ll_val + 2 * k_total * log(log(T_eff))
      icomp_val  <- compute_icomp(fit, T_eff)
      ricomp_val <- compute_ricomp(fit, T_eff)

      # 3. F-bounds at 3 alpha levels
      bt_f_10 <- tryCatch(
        ARDL::bounds_f_test(fit, case = CASE, alpha = 0.10, pvalue = TRUE, exact = TRUE),
        error = function(e) NULL)
      bt_f_05 <- tryCatch(
        ARDL::bounds_f_test(fit, case = CASE, alpha = 0.05, pvalue = TRUE, exact = TRUE),
        error = function(e) NULL)
      bt_f_01 <- tryCatch(
        ARDL::bounds_f_test(fit, case = CASE, alpha = 0.01, pvalue = TRUE, exact = TRUE),
        error = function(e) NULL)

      # 4. t-bounds at 3 alpha levels
      bt_t_10 <- tryCatch(
        ARDL::bounds_t_test(fit, case = CASE, alpha = 0.10, pvalue = TRUE, exact = TRUE),
        error = function(e) NULL)
      bt_t_05 <- tryCatch(
        ARDL::bounds_t_test(fit, case = CASE, alpha = 0.05, pvalue = TRUE, exact = TRUE),
        error = function(e) NULL)
      bt_t_01 <- tryCatch(
        ARDL::bounds_t_test(fit, case = CASE, alpha = 0.01, pvalue = TRUE, exact = TRUE),
        error = function(e) NULL)

      # 5. Extract stats and p-values (p-value is alpha-invariant)
      bF <- extract_bt(if (!is.null(bt_f_10)) bt_f_10 else bt_f_05)
      bT <- extract_bt(if (!is.null(bt_t_10)) bt_t_10 else bt_t_05)

      # Extract I(0)/I(1) bounds at each alpha
      bF_10_bounds <- extract_bounds(bt_f_10)
      bF_05_bounds <- extract_bounds(bt_f_05)
      bF_01_bounds <- extract_bounds(bt_f_01)
      bT_10_bounds <- extract_bounds(bt_t_10)
      bT_05_bounds <- extract_bounds(bt_t_05)
      bT_01_bounds <- extract_bounds(bt_t_01)

      # 6. LR coefficients
      lr_pack <- get_lr_table_with_scaled_dummies(fit, lnY_name = "lnY",
                                                    dummy_names = dummy_names)
      lr_full <- lr_pack$lr_full_table
      den <- lr_pack$den

      theta_row <- lr_full[lr_full$Term == "lnK", , drop = FALSE]
      theta_hat <- if (nrow(theta_row) > 0) theta_row$Estimate[1] else NA_real_
      theta_se  <- if (nrow(theta_row) > 0) theta_row[[2]][1] else NA_real_  # Std. Error
      theta_p   <- if (nrow(theta_row) > 0) theta_row[[5]][1] else NA_real_  # Pr(>|t|)

      # ECM speed
      alpha_pack <- extract_alpha_from_uecm(fit, lnY_name = "lnY")

      # Print progress
      cat(sprintf("[%s Case 3] F=%.2f (p=%.3f%s) | t=%.2f (p=%.3f%s) | AIC=%.1f | BIC=%.1f | HQ=%.1f | ICOMP=%.1f | RICOMP=%.1f\n",
                  spec_label,
                  bF$stat, bF$pval, stars_from_p(bF$pval),
                  bT$stat, bT$pval, stars_from_p(bT$pval),
                  aic_val, bic_val, hq_val,
                  ifelse(is.na(icomp_val), 0, icomp_val),
                  ifelse(is.na(ricomp_val), 0, ricomp_val)))

      tibble(
        spec       = spec_label,
        p          = pp,
        q          = qq,
        case_id    = CASE,
        k_total    = k_total,
        T_eff      = T_eff,
        logLik     = ll_val,
        AIC        = aic_val,
        BIC        = bic_val,
        HQ         = hq_val,
        ICOMP      = icomp_val,
        RICOMP     = ricomp_val,
        F_stat     = bF$stat,
        F_pval     = bF$pval,
        F_sig      = stars_from_p(bF$pval),
        F_I0_10    = bF_10_bounds$I0,
        F_I1_10    = bF_10_bounds$I1,
        F_I0_05    = bF_05_bounds$I0,
        F_I1_05    = bF_05_bounds$I1,
        F_I0_01    = bF_01_bounds$I0,
        F_I1_01    = bF_01_bounds$I1,
        t_stat     = bT$stat,
        t_pval     = bT$pval,
        t_sig      = stars_from_p(bT$pval),
        t_I0_10    = bT_10_bounds$I0,
        t_I1_10    = bT_10_bounds$I1,
        t_I0_05    = bT_05_bounds$I0,
        t_I1_05    = bT_05_bounds$I1,
        t_I0_01    = bT_01_bounds$I0,
        t_I1_01    = bT_01_bounds$I1,
        theta_hat  = theta_hat,
        theta_se   = theta_se,
        theta_p    = theta_p,
        alpha_ecm  = alpha_pack$est,
        alpha_se   = alpha_pack$se,
        alpha_p    = alpha_pack$pval,
        den        = den,
        failed     = FALSE,
        error_msg  = NA_character_
      )
    }, error = function(e) {
      cat(sprintf("[%s Case 3] FAILED: %s\n", spec_label, conditionMessage(e)))
      tibble(
        spec       = spec_label,
        p          = pp,
        q          = qq,
        case_id    = CASE,
        k_total    = NA_integer_,
        T_eff      = NA_integer_,
        logLik     = NA_real_,
        AIC        = NA_real_,
        BIC        = NA_real_,
        HQ         = NA_real_,
        ICOMP      = NA_real_,
        RICOMP     = NA_real_,
        F_stat     = NA_real_,
        F_pval     = NA_real_,
        F_sig      = "",
        F_I0_10    = NA_real_,
        F_I1_10    = NA_real_,
        F_I0_05    = NA_real_,
        F_I1_05    = NA_real_,
        F_I0_01    = NA_real_,
        F_I1_01    = NA_real_,
        t_stat     = NA_real_,
        t_pval     = NA_real_,
        t_sig      = "",
        t_I0_10    = NA_real_,
        t_I1_10    = NA_real_,
        t_I0_05    = NA_real_,
        t_I1_05    = NA_real_,
        t_I0_01    = NA_real_,
        t_I1_01    = NA_real_,
        theta_hat  = NA_real_,
        theta_se   = NA_real_,
        theta_p    = NA_real_,
        alpha_ecm  = NA_real_,
        alpha_se   = NA_real_,
        alpha_p    = NA_real_,
        den        = NA_real_,
        failed     = TRUE,
        error_msg  = conditionMessage(e)
      )
    })

    # Store fit object for later diagnostics
    fit_obj <- tryCatch(
      ARDL::ardl(formula = fml, data = df_ts, order = c(pp, qq)),
      error = function(e) NULL
    )
    results_list[[spec_idx]] <- list(row = row, fit = fit_obj, p = pp, q = qq)
  }
}

# Bind all rows
grid_full <- bind_rows(lapply(results_list, `[[`, "row"))

cat(sprintf("\nGrid search complete: %d specs estimated, %d failed\n\n",
            sum(!grid_full$failed), sum(grid_full$failed)))

# ============================================================
# STEP 5 — ADMISSIBILITY GATES
# ============================================================
cat("--- STEP 5: Admissibility gates ---\n")

grid_full <- grid_full %>%
  mutate(
    gate_F = !is.na(F_pval) & F_pval < 0.10,
    gate_t = !is.na(t_pval) & t_pval < 0.10,
    admissible = gate_F & gate_t & !failed
  )

n_admissible <- sum(grid_full$admissible)
cat(sprintf("Gate 1 (F < 0.10): %d pass\n", sum(grid_full$gate_F, na.rm = TRUE)))
cat(sprintf("Gate 2 (t < 0.10): %d pass\n", sum(grid_full$gate_t, na.rm = TRUE)))
cat(sprintf("Both gates (admissible): %d specs\n", n_admissible))

if (n_admissible == 0) {
  cat("\n*** ADMISSIBLE SET IS EMPTY ***\n")
  cat("No specification passes both F and t bounds gates at 10%.\n")
  cat("IC winner selection cannot proceed.\n\n")
}

admissible_set <- grid_full %>% filter(admissible)
cat("\n")

# ============================================================
# STEP 6 — IC WINNER SELECTION
# ============================================================
cat("--- STEP 6: IC winner selection ---\n")

if (n_admissible > 0) {
  winner_AIC    <- admissible_set %>% slice_min(AIC, n = 1, with_ties = FALSE)
  winner_BIC    <- admissible_set %>% slice_min(BIC, n = 1, with_ties = FALSE)
  winner_HQ     <- admissible_set %>% slice_min(HQ, n = 1, with_ties = FALSE)

  # ICOMP/RICOMP: only if available
  icomp_avail <- admissible_set %>% filter(!is.na(ICOMP))
  ricomp_avail <- admissible_set %>% filter(!is.na(RICOMP))

  winner_ICOMP  <- if (nrow(icomp_avail) > 0)
    icomp_avail %>% slice_min(ICOMP, n = 1, with_ties = FALSE) else NULL
  winner_RICOMP <- if (nrow(ricomp_avail) > 0)
    ricomp_avail %>% slice_min(RICOMP, n = 1, with_ties = FALSE) else NULL

  # Collect winner specs
  winner_specs <- c(
    AIC    = winner_AIC$spec,
    BIC    = winner_BIC$spec,
    HQ     = winner_HQ$spec
  )
  if (!is.null(winner_ICOMP)) winner_specs <- c(winner_specs, ICOMP = winner_ICOMP$spec)
  if (!is.null(winner_RICOMP)) winner_specs <- c(winner_specs, RICOMP = winner_RICOMP$spec)

  cat("IC winners:\n")
  for (ic_name in names(winner_specs)) {
    cat(sprintf("  %s: %s\n", ic_name, winner_specs[ic_name]))
  }

  # Consensus detection
  unique_winners <- unique(winner_specs)
  if (length(unique_winners) == 1) {
    consensus_flag <- "FULL CONSENSUS"
    cat(sprintf("\n*** %s: all ICs select %s ***\n", consensus_flag, unique_winners))
  } else {
    # Check for partial consensus (2+ ICs agree)
    spec_counts <- table(winner_specs)
    consensus_specs <- names(spec_counts[spec_counts >= 2])
    if (length(consensus_specs) > 0) {
      consensus_flag <- "CONSENSUS"
      for (cs in consensus_specs) {
        agreeing <- names(winner_specs[winner_specs == cs])
        cat(sprintf("\n*** CONSENSUS: %s selected by %s ***\n",
                    cs, paste(agreeing, collapse = ", ")))
      }
    } else {
      consensus_flag <- "NO CONSENSUS"
      cat("\nNo consensus — all ICs select different specs\n")
    }
  }

  # Check if Shaikh benchmark appears
  shaikh_in_admissible <- "ARDL(2,4)" %in% admissible_set$spec
  if (shaikh_in_admissible) {
    cat("\nShaikh benchmark ARDL(2,4) Case 3 is IN the admissible set\n")
  } else {
    cat("\nShaikh benchmark ARDL(2,4) Case 3 is NOT in the admissible set\n")
  }

  # ICOMP vs RICOMP divergence check
  if (!is.null(winner_ICOMP) && !is.null(winner_RICOMP)) {
    if (winner_ICOMP$spec != winner_RICOMP$spec) {
      cat(sprintf("\nNote: ICOMP winner (%s) differs from RICOMP winner (%s)\n",
                  winner_ICOMP$spec, winner_RICOMP$spec))
      cat("The sandwich correction shifted the frontier selection.\n")
      cat("RICOMP is the preferred IC for dissertation reporting.\n")
    }
  }

  # Build IC-winner labels for the full table
  grid_full <- grid_full %>%
    mutate(ic_winner = "")

  for (ic_name in names(winner_specs)) {
    s <- winner_specs[ic_name]
    idx <- which(grid_full$spec == s)
    if (length(idx) > 0) {
      existing <- grid_full$ic_winner[idx[1]]
      grid_full$ic_winner[idx[1]] <- if (existing == "") ic_name
        else paste(existing, ic_name, sep = ",")
    }
  }

} else {
  consensus_flag <- "EMPTY SET"
  winner_specs <- character(0)
}

cat("\n")

# ============================================================
# STEP 7 — FULL RESULTS TABLE
# ============================================================
cat("--- STEP 7: Full results table (sorted by AIC) ---\n\n")

grid_sorted <- grid_full %>% arrange(AIC)
grid_sorted <- grid_sorted %>%
  mutate(
    rank = row_number(),
    admis_label = ifelse(admissible, "YES", "NO")
  )

# Print table header
cat(sprintf("%-4s %-12s %-8s %-8s %-8s %-8s %-8s %-6s %-6s %-4s %-7s %-6s %-4s %-5s %-12s\n",
            "Rank", "Spec", "AIC", "BIC", "HQ", "ICOMP", "RICOMP",
            "F-stat", "F-p", "F-*", "t-stat", "t-p", "t-*", "Adm", "IC-winner"))
cat(paste(rep("-", 115), collapse = ""), "\n")

for (i in seq_len(nrow(grid_sorted))) {
  r <- grid_sorted[i, ]
  cat(sprintf("%-4d %-12s %7.1f %7.1f %7.1f %7.1f %7.1f %6.2f %6.3f %-4s %7.2f %6.3f %-4s %-5s %s\n",
              r$rank, r$spec,
              ifelse(is.na(r$AIC), 0, r$AIC),
              ifelse(is.na(r$BIC), 0, r$BIC),
              ifelse(is.na(r$HQ), 0, r$HQ),
              ifelse(is.na(r$ICOMP), 0, r$ICOMP),
              ifelse(is.na(r$RICOMP), 0, r$RICOMP),
              ifelse(is.na(r$F_stat), 0, r$F_stat),
              ifelse(is.na(r$F_pval), 1, r$F_pval),
              r$F_sig,
              ifelse(is.na(r$t_stat), 0, r$t_stat),
              ifelse(is.na(r$t_pval), 1, r$t_pval),
              r$t_sig,
              r$admis_label,
              r$ic_winner))
}
cat("\n")

# Save full grid CSV
safe_write_csv(grid_sorted, file.path(CSV_DIR, "S0_redesign_full_grid.csv"))
cat("Saved: S0_redesign_full_grid.csv\n")

# Save admissible subset
if (n_admissible > 0) {
  safe_write_csv(admissible_set, file.path(CSV_DIR, "S0_redesign_admissible.csv"))
  cat("Saved: S0_redesign_admissible.csv\n")
}

# Save IC winners
if (length(winner_specs) > 0) {
  ic_winners_df <- grid_full %>% filter(spec %in% unique(winner_specs))
  safe_write_csv(ic_winners_df, file.path(CSV_DIR, "S0_redesign_ic_winners.csv"))
  cat("Saved: S0_redesign_ic_winners.csv\n")
}
cat("\n")

# ============================================================
# STEP 8 — WINNER DIAGNOSTICS
# ============================================================
cat("--- STEP 8: Winner diagnostics ---\n\n")

if (n_admissible > 0) {
  unique_winner_specs <- unique(winner_specs)

  for (ws in unique_winner_specs) {
    # Which ICs selected this spec?
    ic_labels <- names(winner_specs[winner_specs == ws])
    ic_str <- paste(ic_labels, collapse = " / ")

    # Find the fit object
    match_idx <- which(sapply(results_list, function(x) {
      sprintf("ARDL(%d,%d)", x$p, x$q) == ws
    }))
    if (length(match_idx) == 0) next
    fit <- results_list[[match_idx[1]]]$fit
    if (is.null(fit)) next

    pp <- results_list[[match_idx[1]]]$p
    qq <- results_list[[match_idx[1]]]$q

    cat(sprintf("=== IC WINNER: %s Case 3 [%s] ===\n\n", ws, ic_str))

    # Bounds tests detail
    cat("Bounds tests (exact, T=", length(residuals(fit)), "):\n", sep = "")

    # F-bounds at 3 levels
    for (alpha_val in c(0.10, 0.05, 0.01)) {
      bt_f <- tryCatch(
        ARDL::bounds_f_test(fit, case = CASE, alpha = alpha_val,
                            pvalue = TRUE, exact = TRUE),
        error = function(e) NULL)
      if (!is.null(bt_f)) {
        bF <- extract_bt(bt_f)
        bds <- extract_bounds(bt_f)
        position <- if (is.na(bF$stat) || is.na(bds$I0)) "unknown"
          else if (bF$stat > bds$I1) "above"
          else if (bF$stat < bds$I0) "below"
          else "between"
        if (alpha_val == 0.10) {
          cat(sprintf("  F-bounds: Stat=%.2f | p=%.3f %s\n",
                      bF$stat, bF$pval, stars_from_p(bF$pval)))
        }
        cat(sprintf("    alpha=%d%%: I(0)=%.2f | I(1)=%.2f | [%s]\n",
                    as.integer(alpha_val * 100),
                    ifelse(is.na(bds$I0), 0, bds$I0),
                    ifelse(is.na(bds$I1), 0, bds$I1),
                    position))
      }
    }

    # t-bounds at 3 levels
    for (alpha_val in c(0.10, 0.05, 0.01)) {
      bt_t <- tryCatch(
        ARDL::bounds_t_test(fit, case = CASE, alpha = alpha_val,
                            pvalue = TRUE, exact = TRUE),
        error = function(e) NULL)
      if (!is.null(bt_t)) {
        bT <- extract_bt(bt_t)
        bds <- extract_bounds(bt_t)
        # t-test: more negative = stronger rejection
        position <- if (is.na(bT$stat) || is.na(bds$I0)) "unknown"
          else if (bT$stat < bds$I1) "above"     # below I(1) bound = reject
          else if (bT$stat > bds$I0) "below"      # above I(0) bound = no reject
          else "between"
        if (alpha_val == 0.10) {
          cat(sprintf("  t-bounds: Stat=%.2f | p=%.3f %s\n",
                      bT$stat, bT$pval, stars_from_p(bT$pval)))
        }
        cat(sprintf("    alpha=%d%%: I(0)=%.2f | I(1)=%.2f | [%s]\n",
                    as.integer(alpha_val * 100),
                    ifelse(is.na(bds$I0), 0, bds$I0),
                    ifelse(is.na(bds$I1), 0, bds$I1),
                    position))
      }
    }

    # Long-run cointegrating vector
    cat("\nLong-run cointegrating vector:\n")
    lr_pack <- get_lr_table_with_scaled_dummies(fit, lnY_name = "lnY",
                                                  dummy_names = dummy_names)
    lr_full <- lr_pack$lr_full_table

    for (i in seq_len(nrow(lr_full))) {
      term_name <- lr_full$Term[i]
      est <- lr_full$Estimate[i]
      se_val <- lr_full[[2]][i]
      p_val <- lr_full[[5]][i]
      cat(sprintf("  %-14s %7.4f | SE=%.4f | p=%.4f %s\n",
                  paste0(term_name, ":"), est, se_val, p_val, stars_from_p(p_val)))
    }

    # ECM speed
    alpha_pack <- extract_alpha_from_uecm(fit, lnY_name = "lnY")
    cat(sprintf("\nECM:\n  alpha (speed): %.4f | SE=%.4f | p=%.4f %s\n",
                alpha_pack$est, alpha_pack$se, alpha_pack$pval,
                stars_from_p(alpha_pack$pval)))

    # Residual diagnostics
    cat("\nResidual diagnostics:\n")
    e <- residuals(fit)

    bg1 <- tryCatch(bgtest(fit, order = 1), error = function(e) NULL)
    bg4 <- tryCatch(bgtest(fit, order = 4), error = function(e) NULL)
    arch1 <- tryCatch({
      e2 <- e^2
      n_e <- length(e2)
      arch_lm <- lm(e2[2:n_e] ~ e2[1:(n_e - 1)])
      arch_stat <- summary(arch_lm)$r.squared * (n_e - 1)
      list(p.value = pchisq(arch_stat, df = 1, lower.tail = FALSE))
    }, error = function(e) NULL)
    reset_test <- tryCatch(resettest(fit, power = 2:3, type = "regressor"),
                           error = function(e) NULL)
    jb <- tryCatch(jarque.bera.test(e), error = function(e) NULL)

    cat(sprintf("  Breusch-Godfrey (lag 1): p=%.4f %s\n",
                if (!is.null(bg1)) bg1$p.value else NA,
                if (!is.null(bg1)) stars_from_p(bg1$p.value) else ""))
    cat(sprintf("  Breusch-Godfrey (lag 4): p=%.4f %s\n",
                if (!is.null(bg4)) bg4$p.value else NA,
                if (!is.null(bg4)) stars_from_p(bg4$p.value) else ""))
    cat(sprintf("  ARCH (lag 1):             p=%.4f %s\n",
                if (!is.null(arch1)) arch1$p.value else NA,
                if (!is.null(arch1)) stars_from_p(arch1$p.value) else ""))
    cat(sprintf("  RESET:                    p=%.4f %s\n",
                if (!is.null(reset_test)) reset_test$p.value else NA,
                if (!is.null(reset_test)) stars_from_p(reset_test$p.value) else ""))
    cat(sprintf("  Jarque-Bera:              p=%.4f %s\n",
                if (!is.null(jb)) jb$p.value else NA,
                if (!is.null(jb)) stars_from_p(jb$p.value) else ""))

    # IC coordinates
    r_row <- grid_full %>% filter(spec == ws)
    cat(sprintf("\nIC coordinates: AIC=%.1f | BIC=%.1f | HQ=%.1f | ICOMP=%.1f | RICOMP=%.1f\n\n",
                r_row$AIC[1], r_row$BIC[1], r_row$HQ[1],
                ifelse(is.na(r_row$ICOMP[1]), 0, r_row$ICOMP[1]),
                ifelse(is.na(r_row$RICOMP[1]), 0, r_row$RICOMP[1])))
  }
}

# ============================================================
# STEP 9 — SHAIKH BENCHMARK ANCHOR
# ============================================================
cat("--- STEP 9: Shaikh benchmark anchor ---\n\n")

shaikh_row <- grid_full %>% filter(spec == "ARDL(2,4)")

cat("=== SHAIKH (2016) BENCHMARK: ARDL(2,4) Case 3 ===\n")
cat("[Replication failure documented — current-vintage BEA data]\n\n")

if (nrow(shaikh_row) > 0 && !shaikh_row$failed[1]) {
  cat(sprintf("F-bounds (exact): F=%.3f | p=%.3f | %s\n",
              shaikh_row$F_stat[1], shaikh_row$F_pval[1],
              if (shaikh_row$F_pval[1] < 0.10) "PASS" else "FAIL"))
  cat(sprintf("t-bounds (exact): t=%.3f | p=%.3f | %s\n",
              shaikh_row$t_stat[1], shaikh_row$t_pval[1],
              if (shaikh_row$t_pval[1] < 0.10) "PASS" else "FAIL"))
  cat(sprintf("AR sum (den): %.4f | alpha: %.6f | theta: %.1f%s\n",
              1 - shaikh_row$den[1], shaikh_row$alpha_ecm[1],
              shaikh_row$theta_hat[1],
              if (abs(shaikh_row$theta_hat[1]) > 10) " (numerically undefined)" else ""))

  cat(sprintf("\nAdmissible under redesign criteria: %s\n",
              if (shaikh_row$admissible[1]) "YES" else "NO"))
  cat(sprintf("Gate 1 (F): %s (p=%.3f %s 0.10)\n",
              if (shaikh_row$gate_F[1]) "PASS" else "FAIL",
              shaikh_row$F_pval[1],
              if (shaikh_row$F_pval[1] < 0.10) "<" else ">>"))
  cat(sprintf("Gate 2 (t): %s (p=%.3f %s 0.10)\n",
              if (shaikh_row$gate_t[1]) "PASS" else "FAIL",
              shaikh_row$t_pval[1],
              if (shaikh_row$t_pval[1] < 0.10) "<" else ">>"))

  cat("\nRoot cause: BEA 2023 comprehensive revision attenuated structural breaks\n")
  cat("  in corporate GVA by factor 6-9x, pushing AR sum to near-unity.\n")
  cat("  This is a data-vintage sensitivity finding, not a specification error.\n")

  # Report Shaikh benchmark coefficients for comparison
  shaikh_fit_idx <- which(sapply(results_list, function(x) x$p == 2 & x$q == 4))
  if (length(shaikh_fit_idx) > 0) {
    shaikh_fit <- results_list[[shaikh_fit_idx[1]]]$fit
    if (!is.null(shaikh_fit)) {
      cat("\nShaikh benchmark coefficients (for comparison with IC winners):\n")
      lr_pack_s <- get_lr_table_with_scaled_dummies(shaikh_fit, lnY_name = "lnY",
                                                      dummy_names = dummy_names)
      lr_full_s <- lr_pack_s$lr_full_table
      for (i in seq_len(nrow(lr_full_s))) {
        cat(sprintf("  %-14s %7.4f | SE=%.4f | p=%.4f %s\n",
                    paste0(lr_full_s$Term[i], ":"),
                    lr_full_s$Estimate[i], lr_full_s[[2]][i], lr_full_s[[5]][i],
                    stars_from_p(lr_full_s[[5]][i])))
      }
      cat(sprintf("  IC values: AIC=%.1f | BIC=%.1f | HQ=%.1f | ICOMP=%.1f | RICOMP=%.1f\n",
                  shaikh_row$AIC[1], shaikh_row$BIC[1], shaikh_row$HQ[1],
                  ifelse(is.na(shaikh_row$ICOMP[1]), 0, shaikh_row$ICOMP[1]),
                  ifelse(is.na(shaikh_row$RICOMP[1]), 0, shaikh_row$RICOMP[1])))
    }
  }
} else {
  cat("ARDL(2,4) estimation failed or not in grid\n")
}
cat("\n")

# ============================================================
# STEP 10 — UTILIZATION COMPARISON FIGURE
# ============================================================
cat("--- STEP 10: Utilization comparison figure ---\n\n")

if (n_admissible > 0) {
  unique_winner_specs <- unique(winner_specs)

  for (ws in unique_winner_specs) {
    ic_labels <- names(winner_specs[winner_specs == ws])
    ic_str <- paste(ic_labels, collapse = "/")

    # Get fit object
    match_idx <- which(sapply(results_list, function(x)
      sprintf("ARDL(%d,%d)", x$p, x$q) == ws))
    if (length(match_idx) == 0) next
    fit <- results_list[[match_idx[1]]]$fit
    if (is.null(fit)) next

    # Recover utilization
    lr_pack <- get_lr_table_with_scaled_dummies(fit, lnY_name = "lnY",
                                                  dummy_names = dummy_names)
    u_series <- compute_u_from_lr(df, "lnY", "lnK", lr_pack$lr_full_table,
                                   dummy_names)

    # Build plot data
    plot_df <- tibble(
      year = df$year,
      u_winner = u_series$u
    )

    # Add Shaikh uK
    if (has_uK) {
      plot_df <- plot_df %>%
        left_join(ref_uK, by = "year")
    }

    # Add FRB
    if (has_uFRB) {
      plot_df <- plot_df %>%
        left_join(ref_uFRB, by = "year")
    }

    # Pivot for ggplot
    plot_long <- plot_df %>%
      pivot_longer(cols = -year, names_to = "series", values_to = "value") %>%
      filter(!is.na(value))

    # Labels and linetypes
    series_labels <- c(
      u_winner = paste0("IC Winner (", ws, ")"),
      uK       = "Shaikh uK",
      uFRB     = "FRB Utilization"
    )

    series_ltys <- c(
      u_winner = "solid",
      uK       = "dashed",
      uFRB     = "dotted"
    )

    series_colors <- c(
      u_winner = "#000000",
      uK       = "#E69F00",
      uFRB     = "#56B4E9"
    )

    fig <- ggplot(plot_long, aes(x = year, y = value,
                                  color = series, linetype = series)) +
      geom_line(linewidth = 0.8) +
      scale_color_manual(values = series_colors, labels = series_labels,
                         breaks = names(series_labels)) +
      scale_linetype_manual(values = series_ltys, labels = series_labels,
                            breaks = names(series_labels)) +
      labs(
        title = paste0("Capacity Utilization: ", ws, " Case 3 [", ic_str, "]"),
        subtitle = "IC winner vs Shaikh (2016) uK and FRB utilization",
        x = "Year",
        y = "Utilization rate",
        color = NULL,
        linetype = NULL
      ) +
      theme_ch3() +
      theme(legend.position = "bottom")

    save_ch3_fig(fig, "fig_S0_redesign_u_comparison", FIG_DIR)
    cat(sprintf("Saved utilization figure for %s [%s]\n", ws, ic_str))

    # Only one figure if all winners are the same spec
    break
  }

  # If multiple distinct winners, produce panel figure
  if (length(unique_winner_specs) > 1) {
    panel_dfs <- list()
    for (ws in unique_winner_specs) {
      match_idx <- which(sapply(results_list, function(x)
        sprintf("ARDL(%d,%d)", x$p, x$q) == ws))
      if (length(match_idx) == 0) next
      fit <- results_list[[match_idx[1]]]$fit
      if (is.null(fit)) next

      lr_pack <- get_lr_table_with_scaled_dummies(fit, lnY_name = "lnY",
                                                    dummy_names = dummy_names)
      u_series <- compute_u_from_lr(df, "lnY", "lnK", lr_pack$lr_full_table,
                                     dummy_names)

      panel_df <- tibble(year = df$year, u_winner = u_series$u, spec = ws)
      if (has_uK) panel_df <- panel_df %>% left_join(ref_uK, by = "year")
      if (has_uFRB) panel_df <- panel_df %>% left_join(ref_uFRB, by = "year")
      panel_dfs <- c(panel_dfs, list(panel_df))
    }

    panel_all <- bind_rows(panel_dfs) %>%
      pivot_longer(cols = c(u_winner, any_of(c("uK", "uFRB"))),
                   names_to = "series", values_to = "value") %>%
      filter(!is.na(value))

    fig_panel <- ggplot(panel_all, aes(x = year, y = value,
                                        color = series, linetype = series)) +
      geom_line(linewidth = 0.7) +
      facet_wrap(~ spec) +
      scale_color_manual(values = series_colors, labels = series_labels,
                         breaks = names(series_labels)) +
      scale_linetype_manual(values = series_ltys, labels = series_labels,
                            breaks = names(series_labels)) +
      labs(
        title = "Capacity Utilization: IC Winners (Panel)",
        subtitle = "Each panel shows a distinct IC winner vs Shaikh uK and FRB",
        x = "Year", y = "Utilization rate",
        color = NULL, linetype = NULL
      ) +
      theme_ch3() +
      theme(legend.position = "bottom")

    save_ch3_fig(fig_panel, "fig_S0_redesign_u_comparison_panel", FIG_DIR,
                 width = 10, height = 5)
    cat("Saved panel utilization figure\n")
  }
} else {
  cat("No admissible specs — skipping utilization figure\n")
}

cat("\n")

# ============================================================
# STEP 11 — SUMMARY
# ============================================================
cat("--- STEP 11: Save summary ---\n\n")
cat("=============================================================\n")
cat("S0 REDESIGN COMPLETE\n")
cat("=============================================================\n")
cat(sprintf("Total specs: %d | Admissible: %d | Failed: %d\n",
            nrow(grid_full), n_admissible, sum(grid_full$failed)))
if (n_admissible > 0) {
  cat(sprintf("Consensus: %s\n", consensus_flag))
  cat(sprintf("IC winners: %s\n", paste(unique(winner_specs), collapse = ", ")))
}
cat("\nOutputs saved:\n")
cat(sprintf("  CSV:     %s\n", CSV_DIR))
cat(sprintf("  Figures: %s\n", FIG_DIR))
cat(sprintf("  Report:  %s\n", report_path))
cat("=============================================================\n")

# Close sink
try(sink(), silent = TRUE)

cat("\nS0 redesign script completed successfully.\n")
