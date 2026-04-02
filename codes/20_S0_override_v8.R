library(ARDL)
library(dynlm)
library(dplyr)
library(here)
source("codes/10_config.R")
source("codes/99_utils.R")

# ── Logging ───────────────────────────────────────────────────────────
out_dir <- here::here("output", "S0_manualOverride")



# ── Data ──────────────────────────────────────────────────────────────
df <- readr::read_csv(here::here(CONFIG[["data_shaikh"]]), show_col_types = FALSE)

build_data <- function(df) {
  df |>
    filter(year >= 1947, year <= 2011) |>
    mutate(
      # Priority 1 — most likely Shaikh's actual spec
      y  = log(GVAcorp  / pKN),   # gross output / investment deflator
      k = log(KGCcorp  / pKN),   # total capital (gross + inventories) / same deflator
      d1956 = as.integer(year == 1956),
      d1974 = as.integer(year == 1974),
      d1980 = as.integer(year == 1980),
      trend = row_number()
    )
}
df  <- build_data(df)

# Priority 2 — net stock + capital deflator
# GVAcorp, KGCcorp,KTCcorp, pIGcorpbea, pKN

#Data frame to TS 
df_ts <- ts(df |> select(y,k, d1956, d1974, d1980),
            start = 1947, end = 2011, frequency = 1)

######## Specification without a trend ########

# ── Step 1: Short Run estimation ─────────────────────────────────────
ardl_shaikh <- dynlm(y ~ L(y, 1) + L(y, 2) +
                       k + L(k, 1) + L(k, 2) + L(k, 3) + L(k, 4) +
                       d1956 + d1974 + d1980,
                     data = df_ts, start = 1947, end = 2011)

# ── Step 2: Long-run multipliers ─────────────────────────────────────
cc  <- coef(ardl_shaikh)
V   <- vcov(ardl_shaikh)
n   <- length(cc)

phi   <- cc["k"] + cc["L(k, 1)"] + cc["L(k, 2)"] + cc["L(k, 3)"] + cc["L(k, 4)"]
d     <- 1 - cc["L(y, 1)"] - cc["L(y, 2)"]
theta <- phi / d
a     <- cc["(Intercept)"] / d
c1_lr <- cc["d1956"] / d
c2_lr <- cc["d1974"] / d
c3_lr <- cc["d1980"] / d

# ── Step 3: Delta method SE for each LR object ───────────────────────
# Generic gradient builder: LR = numerator / d
# d(LR)/d(beta_j) = (1/d) * d(num)/d(beta_j) + (num/d^2) * d(d)/d(beta_j)
# d(d)/d(psi_i) = 1 for AR lags (because d = 1 - sum(psi))

delta_se <- function(num_names, num_val, V, cc) {
  grad <- setNames(numeric(length(cc)), names(cc))
  # numerator partials
  for (nm in num_names) grad[nm] <- 1 / d
  # denominator partials (AR lags enter d = 1 - psi1 - psi2)
  for (nm in c("L(y, 1)", "L(y, 2)")) grad[nm] <- num_val / d^2
  sqrt(as.numeric(t(grad) %*% V %*% grad))
}

se_theta <- delta_se(c("k","L(k, 1)","L(k, 2)","L(k, 3)","L(k, 4)"), phi, V, cc)
se_a     <- delta_se("(Intercept)",   cc["(Intercept)"],  V, cc)
se_c1    <- delta_se("d1956",         cc["d1956"],         V, cc)
se_c2    <- delta_se("d1974",         cc["d1974"],         V, cc)
se_c3    <- delta_se("d1980",         cc["d1980"],         V, cc)

# ── Step 4: t-stats and significance stars ────────────────────────────
df_resid <- df.residual(ardl_shaikh)

stars <- function(tstat) {
  p <- 2 * pt(-abs(tstat), df = df_resid)
  case_when(
    p < 0.01 ~ "***",
    p < 0.05 ~ "**",
    p < 0.10 ~ "*",
    p < 0.15 ~ ".",
    TRUE     ~ ""
  )
}

lr_table <- tibble(
  Parameter  = c("theta", "a", "d1956 LR", "d1974 LR", "d1980 LR"),
  Estimate   = c(theta, a, c1_lr, c2_lr, c3_lr),
  SE         = c(se_theta, se_a, se_c1, se_c2, se_c3)
) |>
  mutate(
    t_stat = Estimate / SE,
    Stars  = stars(t_stat)
  )

# ── Step 5: Report ────────────────────────────────────────────────────
summary(ardl_shaikh)
cat("\n--- Long-run multipliers (delta method SEs) ---\n")
cat(sprintf("1 - sum(gamma) = %.6f\n", as.numeric(d)))
print(lr_table, digits = 4)
cat("\nNote: SEs via delta method. Near-singular denominator",
    sprintf("(d = %.4f) implies SEs are conservative lower bounds.\n", as.numeric(d)))



####### 2. Estimating ARDL properly ###########

library(ARDL)
library(dplyr)

# ── Step 1: Auto ARDL search — top 5 AIC and BIC ─────────────────────
# Using C3 spec: y = GVAcorp/pKN, k = KGCcorp/pKN
# max orders: p=5 on y, q=5 on k — search over the full grid


auto_res <- auto_ardl(
  formula   =y ~ k | d1956 + d1974 + d1980,
  data     = df_ts,
  max_order = c(5, 5),
  selection = "AIC",
  selection_minmax = "min",
  start = 1947,
  end   = 2011
)

# Top 5 by AIC
top5_aic <- head(auto_res$top_orders, 5)

# Re-run for BIC
auto_res_bic <- auto_ardl(
  formula   =y ~ k | d1956 + d1974 + d1980,
  data      = df_ts,
  max_order = c(5, 5),
  selection = "BIC",
  selection_minmax = "min",
  start = 1947,
  end   = 2011
)

top5_bic <- head(auto_res_bic$top_orders, 5)

# ── Step 2: Report top 5 for each criterion ───────────────────────────
cat("\n=== TOP 5 by AIC ===\n")
print(top5_aic)

cat("\n=== TOP 5 by BIC ===\n")
print(top5_bic)

# ── Step 3: Extract the IC-preferred model and compare to Shaikh (2,4) ─
best_aic_order <- auto_res$best_order
best_bic_order <- auto_res_bic$best_order

cat(sprintf("\nAIC winner: ARDL(%s)\n",
            paste(best_aic_order, collapse = ",")))
cat(sprintf("BIC winner: ARDL(%s)\n",
            paste(best_bic_order, collapse = ",")))
cat("Shaikh:     ARDL(2,4)\n")

# ── Step 4: Retrieve the best model objects for bounds testing ─────────
best_ardl_aic <- auto_res$best_model
best_ardl_bic <- auto_res_bic$best_model

# Also re-estimate Shaikh's (2,4) via ARDL package for apples-to-apples
shaikh_ardl <- ardl(
  formula   = y ~ k | d1956 + d1974 + d1980,
  data      = df_ts,
  order     = c(2, 4),
  start = 1947,
  end   = 2011
)

cat("\n=== Short summaries ===\n")
cat("\n--- AIC best ---\n");  summary(best_ardl_aic)
cat("\n--- BIC best ---\n");  summary(best_ardl_bic)
cat("\n--- Shaikh (2,4) ---\n"); summary(shaikh_ardl)


############ Bounds Testing #############

library(ARDL)
library(dplyr)
library(purrr)

# ── Specs to test ─────────────────────────────────────────────────────
specs <- list(
  "BIC winner  ARDL(2,3)" = c(2, 3),
  "AIC winner  ARDL(3,3)" = c(3, 3),
  "Shaikh      ARDL(2,4)" = c(2, 4)
)

# ── Estimate two versions per spec ───────────────────────────────────
# Version A: with constant — compatible with Cases 2 and 3
# Version B: no constant (-1) — compatible with Case 1

models_const <- imap(specs, ~ ardl(
  formula = y ~ k | d1956 + d1974 + d1980,
  data    = df_ts,
  order   = .x,
  start   = 1947,
  end     = 2011
))

models_noconst <- imap(specs, ~ ardl(
  formula = y ~ k - 1 | d1956 + d1974 + d1980,
  data    = df_ts,
  order   = .x,
  start   = 1947,
  end     = 2011
))

# ── F-bounds: Case 1 on no-constant model ────────────────────────────
run_f_case1 <- function(mod, label) {
  res <- bounds_f_test(mod, case = 1, exact = TRUE, R = 40000)
  cat(sprintf(
    "  Case 1 | F = %6.3f | p = %.4f | I(0) 5%% = %.3f | I(1) 5%% = %.3f\n",
    res$statistic, res$p.value,
    res$tab["0.05", "I(0)"], res$tab["0.05", "I(1)"]
  ))
}

# ── F-bounds: Cases 2 and 3 on constant model ────────────────────────
run_f_cases23 <- function(mod, label) {
  for (case in c(2, 3)) {
    res <- bounds_f_test(mod, case = case, exact = TRUE, R = 40000)
    cat(sprintf(
      "  Case %d | F = %6.3f | p = %.4f | I(0) 5%% = %.3f | I(1) 5%% = %.3f\n",
      case, res$statistic, res$p.value,
      res$tab["0.05", "I(0)"], res$tab["0.05", "I(1)"]
    ))
  }
}

# ── t-bounds: Case 1 (no-constant model) and Case 3 (constant model) ─
run_t_case1 <- function(mod, label) {
  res <- bounds_t_test(mod, case = 1, exact = TRUE, R = 40000)
  cat(sprintf(
    "  Case 1 | t = %6.3f | p = %.4f | I(0) 5%% = %.3f | I(1) 5%% = %.3f\n",
    res$statistic, res$p.value,
    res$tab["0.05", "I(0)"], res$tab["0.05", "I(1)"]
  ))
}

run_t_case3 <- function(mod, label) {
  res <- bounds_t_test(mod, case = 3, exact = TRUE, R = 40000)
  cat(sprintf(
    "  Case 3 | t = %6.3f | p = %.4f | I(0) 5%% = %.3f | I(1) 5%% = %.3f\n",
    res$statistic, res$p.value,
    res$tab["0.05", "I(0)"], res$tab["0.05", "I(1)"]
  ))
}

# ── Run all tests ─────────────────────────────────────────────────────
cat("========================================================\n")
cat("  PSS BOUNDS TESTS — IC WINNERS + SHAIKH REPLICATION\n")
cat("  Exact finite-sample, T = 65, R = 40000\n")
cat("  y = GVAcorp/pKN | k = KGCcorp/pKN\n")
cat("  Case 1: no-constant model (y ~ k - 1 | dummies)\n")
cat("  Cases 2-3: constant model (y ~ k | dummies)\n")
cat("========================================================\n")

for (nm in names(specs)) {
  cat(sprintf("\n\n=== %s ===\n", nm))
  cat("--- F-BOUNDS TEST ---\n")
  run_f_case1(models_noconst[[nm]], nm)
  run_f_cases23(models_const[[nm]], nm)
  cat("--- t-BOUNDS TEST ---\n")
  run_t_case1(models_noconst[[nm]], nm)
  run_t_case3(models_const[[nm]], nm)
}

# ── Admissibility summary ─────────────────────────────────────────────
cat("\n\n=== ADMISSIBILITY SUMMARY (F-test, p < 0.05) ===\n")
cat(sprintf("%-26s  Case1   Case2   Case3\n", "Spec"))
cat(strrep("-", 52), "\n")

for (nm in names(specs)) {
  r1 <- tryCatch({
    res <- bounds_f_test(models_noconst[[nm]], case = 1, exact = TRUE, R = 40000)
    ifelse(res$p.value < 0.05, " PASS ", " fail ")
  }, error = function(e) "  n/a ")
  
  r23 <- map_chr(c(2, 3), function(case) {
    res <- bounds_f_test(models_const[[nm]], case = case, exact = TRUE, R = 40000)
    ifelse(res$p.value < 0.05, " PASS ", " fail ")
  })
  
  cat(sprintf("%-26s  %s  %s  %s\n", nm, r1, r23[1], r23[2]))
}


# ── Replace print_f with this ─────────────────────────────────────────
print_f <- function(mod, case, label_case) {
  ex  <- bounds_f_test(mod, case = case, exact = TRUE,  R = 40000)
  asy <- bounds_f_test(mod, case = case, exact = FALSE)
  cat(sprintf(
    "  Case %s | F = %6.3f | p(exact) = %.4f | p(asymp) = %.4f\n",
    label_case, ex$statistic, ex$p.value, asy$p.value
  ))
  cat(sprintf(
    "    Exact  CVs — 10%%: [%5.3f, %5.3f]  5%%: [%5.3f, %5.3f]\n",
    ex$tab["0.1","I(0)"], ex$tab["0.1","I(1)"],
    ex$tab["0.05","I(0)"], ex$tab["0.05","I(1)"]
  ))
  cat(sprintf(
    "    Asymp. CVs — 10%%: [%5.3f, %5.3f]  5%%: [%5.3f, %5.3f]\n",
    asy$tab["0.1","I(0)"], asy$tab["0.1","I(1)"],
    asy$tab["0.05","I(0)"], asy$tab["0.05","I(1)"]
  ))
}

# ── Replace print_t with this ─────────────────────────────────────────
print_t <- function(mod, case, label_case) {
  ex  <- bounds_t_test(mod, case = case, exact = TRUE,  R = 40000)
  asy <- bounds_t_test(mod, case = case, exact = FALSE)
  cat(sprintf(
    "  Case %s | t = %6.3f | p(exact) = %.4f | p(asymp) = %.4f\n",
    label_case, ex$statistic, ex$p.value, asy$p.value
  ))
  cat(sprintf(
    "    Exact  CVs — 10%%: [%5.3f, %5.3f]  5%%: [%5.3f, %5.3f]\n",
    ex$tab["0.1","I(0)"], ex$tab["0.1","I(1)"],
    ex$tab["0.05","I(0)"], ex$tab["0.05","I(1)"]
  ))
  cat(sprintf(
    "    Asymp. CVs — 10%%: [%5.3f, %5.3f]  5%%: [%5.3f, %5.3f]\n",
    asy$tab["0.1","I(0)"], asy$tab["0.1","I(1)"],
    asy$tab["0.05","I(0)"], asy$tab["0.05","I(1)"]
  ))
}

# ── Replace the loop body with this ──────────────────────────────────
for (nm in names(specs)) {
  cat(sprintf("\n\n=== %s ===\n", nm))
  cat("--- F-BOUNDS TEST ---\n")
  tryCatch(print_f(models_noconst[[nm]], 1, "1 (no const)"),
           error = function(e) cat("  Case 1 | error:", e$message, "\n"))
  tryCatch(print_f(models_const[[nm]],   2, "2 (restr. int)"),
           error = function(e) cat("  Case 2 | error:", e$message, "\n"))
  tryCatch(print_f(models_const[[nm]],   3, "3 (unres. int)"),
           error = function(e) cat("  Case 3 | error:", e$message, "\n"))
  cat("--- t-BOUNDS TEST ---\n")
  tryCatch(print_t(models_noconst[[nm]], 1, "1 (no const)"),
           error = function(e) cat("  Case 1 | error:", e$message, "\n"))
  tryCatch(print_t(models_const[[nm]],   3, "3 (unres. int)"),
           error = function(e) cat("  Case 3 | error:", e$message, "\n"))
}

################ Extracting Bounds Tests ################################


# ── Extract full bounds results into a tidy data frame ────────────────
library(tibble)
library(tidyr)

extract_bounds <- function(specs, models_const, models_noconst) {
  
  rows <- list()
  
  for (nm in names(specs)) {
    
    configs <- list(
      list(fn = bounds_f_test, mod = models_noconst[[nm]],
           case = 1, test = "F", label = "1 (no const)"),
      list(fn = bounds_f_test, mod = models_const[[nm]],
           case = 2, test = "F", label = "2 (restr. int)"),
      list(fn = bounds_f_test, mod = models_const[[nm]],
           case = 3, test = "F", label = "3 (unres. int)"),
      list(fn = bounds_t_test, mod = models_noconst[[nm]],
           case = 1, test = "t", label = "1 (no const)"),
      list(fn = bounds_t_test, mod = models_const[[nm]],
           case = 3, test = "t", label = "3 (unres. int)")
    )
    
    for (cfg in configs) {
      
      # alpha = 0.10 unlocks I(0)/I(1) in $tab
      ex <- tryCatch(
        cfg$fn(cfg$mod, case = cfg$case,
               alpha = 0.10, exact = TRUE, R = 40000),
        error = function(e) NULL)
      asy <- tryCatch(
        cfg$fn(cfg$mod, case = cfg$case,
               alpha = 0.10, exact = FALSE),
        error = function(e) NULL)
      
      if (!is.null(ex)) {
        
        # $tab columns when alpha passed:
        # statistic | Lower-bound I(0) | Upper-bound I(1) | alpha | p.value
        stat    <- as.numeric(ex$tab[1, "statistic"])
        i0_ex   <- as.numeric(ex$tab[1, "Lower-bound I(0)"])
        i1_ex   <- as.numeric(ex$tab[1, "Upper-bound I(1)"])
        p_ex    <- as.numeric(ex$p.value)
        
        i0_asy  <- if (!is.null(asy)) as.numeric(asy$tab[1, "Lower-bound I(0)"]) else NA
        i1_asy  <- if (!is.null(asy)) as.numeric(asy$tab[1, "Upper-bound I(1)"]) else NA
        p_asy   <- if (!is.null(asy)) as.numeric(asy$p.value) else NA
        
        # three-way verdict based on position relative to I(0)/I(1) at 10%
        # F-test: higher F = stronger evidence (above I(1) = CI)
        # t-test: more negative t = stronger evidence (below I(1) = CI)
        if (cfg$test == "F") {
          v_ex  <- dplyr::case_when(
            stat > i1_ex  ~ "CI",
            stat > i0_ex  ~ "?",
            TRUE          ~ "no"
          )
          v_asy <- dplyr::case_when(
            !is.na(i1_asy) & stat > i1_asy ~ "CI",
            !is.na(i0_asy) & stat > i0_asy ~ "?",
            TRUE                            ~ "no"
          )
        } else {
          v_ex  <- dplyr::case_when(
            stat < i1_ex  ~ "CI",
            stat < i0_ex  ~ "?",
            TRUE          ~ "no"
          )
          v_asy <- dplyr::case_when(
            !is.na(i1_asy) & stat < i1_asy ~ "CI",
            !is.na(i0_asy) & stat < i0_asy ~ "?",
            TRUE                            ~ "no"
          )
        }
        
        rows[[length(rows)+1]] <- tibble::tibble(
          spec          = nm,
          test          = cfg$test,
          case          = cfg$label,
          statistic     = round(stat,  3),
          I0_exact      = round(i0_ex, 3),
          I1_exact      = round(i1_ex, 3),
          I0_asymp      = round(i0_asy, 3),
          I1_asymp      = round(i1_asy, 3),
          p_exact       = round(p_ex,  4),
          p_asymp       = round(p_asy, 4),
          verdict_exact = v_ex,
          verdict_asymp = v_asy
        )
      }
    }
  }
  
  dplyr::bind_rows(rows)
}

# ── Run ───────────────────────────────────────────────────────────────
bounds_df <- extract_bounds(specs, models_const, models_noconst)

# ── Preview ───────────────────────────────────────────────────────────
cat("=== F-TESTS ===\n")
print(bounds_df |> dplyr::filter(test == "F") |>
        dplyr::select(spec, case, statistic,
                      I0_exact, I1_exact, I0_asymp, I1_asymp,
                      p_exact, p_asymp,
                      verdict_exact, verdict_asymp),
      n = 20)

cat("\n=== t-TESTS ===\n")
print(bounds_df |> dplyr::filter(test == "t") |>
        dplyr::select(spec, case, statistic,
                      I0_exact, I1_exact, I0_asymp, I1_asymp,
                      p_exact, p_asymp,
                      verdict_exact, verdict_asymp),
      n = 20)


# ============================================================
# CSV EXPORT — S0 faithful contract (Cases 1–3)
#
# Produces:
#   S0_spec_report.csv         (bounds + theta per case)
#   S0_fivecase_summary.csv    (LR coefficients, Case 3)
#   S0_utilization_series.csv  (u_hat + yp_hat + u_case*)
#
# Target: output/S0_faithful/csv/  (pack contract)
# ============================================================

cat("\n=== CSV EXPORT — S0 faithful contract ===\n")

source(here::here("codes", "99_figure_protocol.R"))

S0_CSV_DIR <- here::here(CONFIG$OUT_CR$S0_faithful, "csv")
S0_FIG_DIR <- here::here(CONFIG$OUT_CR$S0_faithful, "figures")
dir.create(S0_CSV_DIR, recursive = TRUE, showWarnings = FALSE)
dir.create(S0_FIG_DIR, recursive = TRUE, showWarnings = FALSE)

# ---- Helper: LR multipliers from ARDL fit ----
get_lr_full <- function(mod) {
  cc       <- coef(mod)
  ar_names <- names(cc)[grepl("^L\\(y", names(cc))]
  k_names  <- names(cc)[grepl("^k$|^L\\(k", names(cc))]
  denom    <- 1 - sum(cc[ar_names])
  list(
    denom = denom,
    theta = sum(cc[k_names]) / denom,
    a     = if ("(Intercept)" %in% names(cc)) unname(cc["(Intercept)"] / denom) else 0,
    d1956 = if ("d1956" %in% names(cc)) unname(cc["d1956"] / denom) else 0,
    d1974 = if ("d1974" %in% names(cc)) unname(cc["d1974"] / denom) else 0,
    d1980 = if ("d1980" %in% names(cc)) unname(cc["d1980"] / denom) else 0
  )
}

# ---- Helper: raw SR dummy coefficients (for Series F) ----
get_raw_dummies <- function(mod) {
  cc <- coef(mod)
  list(
    d1956 = if ("d1956" %in% names(cc)) unname(cc["d1956"]) else 0,
    d1974 = if ("d1974" %in% names(cc)) unname(cc["d1974"]) else 0,
    d1980 = if ("d1980" %in% names(cc)) unname(cc["d1980"]) else 0
  )
}

# ---- Helper: UECM alpha (speed of adjustment) ----
get_alpha <- function(mod) {
  tryCatch({
    uecm_cc <- summary(ARDL::uecm(mod))$coefficients
    rr <- grep("^L\\(y, 1\\)$", rownames(uecm_cc), value = TRUE)
    if (length(rr) == 1) as.numeric(uecm_cc[rr, "Estimate"]) else NA_real_
  }, error = function(e) NA_real_)
}

# ---- Helper: capacity benchmark from LR ----
build_yp_lr <- function(lr, df_in, include_intercept = TRUE) {
  yp <- lr$theta * df_in$k +
    lr$d1956 * df_in$d1956 + lr$d1974 * df_in$d1974 + lr$d1980 * df_in$d1980
  if (include_intercept) yp <- yp + lr$a
  yp
}

# ---- Models (reuse from override) ----
mod_c23 <- models_const[["Shaikh      ARDL(2,4)"]]
mod_c1  <- models_noconst[["Shaikh      ARDL(2,4)"]]

lr_c23 <- get_lr_full(mod_c23)
lr_c1  <- get_lr_full(mod_c1)

# ---- 1) S0_spec_report.csv ----
shaikh_b <- bounds_df[bounds_df$spec == "Shaikh      ARDL(2,4)", ]

get_bstat <- function(ttype, clabel) {
  r <- shaikh_b[shaikh_b$test == ttype & shaikh_b$case == clabel, ]
  if (nrow(r) == 0) return(c(stat = NA_real_, p = NA_real_))
  c(stat = r$statistic[1], p = r$p_exact[1])
}

s0_spec_report <- data.frame(
  case_id      = 1:3,
  boundsF_stat = c(get_bstat("F", "1 (no const)")["stat"],
                   get_bstat("F", "2 (restr. int)")["stat"],
                   get_bstat("F", "3 (unres. int)")["stat"]),
  boundsF_p    = c(get_bstat("F", "1 (no const)")["p"],
                   get_bstat("F", "2 (restr. int)")["p"],
                   get_bstat("F", "3 (unres. int)")["p"]),
  boundsT_stat = c(get_bstat("t", "1 (no const)")["stat"],
                   NA_real_,
                   get_bstat("t", "3 (unres. int)")["stat"]),
  boundsT_p    = c(get_bstat("t", "1 (no const)")["p"],
                   NA_real_,
                   get_bstat("t", "3 (unres. int)")["p"]),
  theta_hat    = c(lr_c1$theta, lr_c23$theta, lr_c23$theta),
  alpha_hat    = c(get_alpha(mod_c1), get_alpha(mod_c23), get_alpha(mod_c23)),
  row.names    = NULL,
  stringsAsFactors = FALSE
)
s0_spec_report$F_pass <- !is.na(s0_spec_report$boundsF_p) &
  s0_spec_report$boundsF_p <= 0.10

write.csv(s0_spec_report, file.path(S0_CSV_DIR, "S0_spec_report.csv"),
          row.names = FALSE)

# ---- 2) S0_utilization_series.csv ----
yp_c3 <- build_yp_lr(lr_c23, df, include_intercept = TRUE)
u_c3  <- exp(df$y - yp_c3)

yp_c1 <- build_yp_lr(lr_c1, df, include_intercept = FALSE)
u_c1  <- exp(df$y - yp_c1)

s0_u_series <- data.frame(
  year     = df$year,
  u_shaikh = df$uK,
  u_hat    = u_c3,
  yp_hat   = yp_c3,
  u_case1  = u_c1,
  u_case2  = u_c3,
  u_case3  = u_c3
)
write.csv(s0_u_series, file.path(S0_CSV_DIR, "S0_utilization_series.csv"),
          row.names = FALSE)

# ---- 3) S0_fivecase_summary.csv ----
s0_fivecase <- data.frame(
  Term     = c("(Intercept)", "k", "d1956", "d1974", "d1980"),
  Estimate = c(lr_c23$a, lr_c23$theta, lr_c23$d1956, lr_c23$d1974, lr_c23$d1980),
  case_id  = 3L,
  order_p  = 2L,
  order_q  = 4L,
  stringsAsFactors = FALSE
)
write.csv(s0_fivecase, file.path(S0_CSV_DIR, "S0_fivecase_summary.csv"),
          row.names = FALSE)

cat("S0 CSVs written to:", S0_CSV_DIR, "\n")


# ============================================================
# FIGURE: Net-to-gross ratio ψ_t (GPIM, §4.2)
# ============================================================

library(ggplot2)
library(tidyr)
library(RColorBrewer)

cat("\n=== GPIM figure ===\n")

psi_df <- data.frame(
  year = df$year,
  psi  = df$KNCcorpbea / df$KGCcorp
)

fig_gpim <- ggplot(psi_df, aes(x = year, y = psi)) +
  annotate("rect", xmin = 1974, xmax = max(psi_df$year),
           ymin = -Inf, ymax = Inf, fill = "#E8E4DF", alpha = 0.5) +
  geom_hline(yintercept = 1, linetype = "dashed", color = "#999999",
             linewidth = 0.4) +
  geom_line(color = "#2C3E50", linewidth = 0.9) +
  annotate("text", x = max(psi_df$year) + 1, y = tail(psi_df$psi, 1),
           label = sprintf("%.2f", tail(psi_df$psi, 1)),
           hjust = 0, size = 3.2, color = "#2C3E50") +
  scale_x_continuous(breaks = seq(1950, 2010, by = 10),
                     limits = c(1947, 2015)) +
  scale_y_continuous(labels = scales::number_format(accuracy = 0.01),
                     breaks = seq(0.3, 1.0, by = 0.1)) +
  labs(x = NULL,
       y = expression(psi[t] == KNC^{BEA} / KGC^{GPIM}),
       caption = paste0("Source: Shaikh (2016, Appendix 6.8). ",
                        "Shaded: post-1974 (post-Fordist periodization).")) +
  theme_minimal(base_size = 11) +
  theme(panel.grid.minor   = element_blank(),
        panel.grid.major.x = element_blank(),
        panel.grid.major.y = element_line(color = "grey90"),
        plot.caption        = element_text(hjust = 0, size = 8, color = "grey40"))

save_png_pdf_dual(fig_gpim, "fig_S0_net_to_gross_ratio", S0_FIG_DIR)
cat(sprintf("psi range: [%.3f, %.3f]\n",
            min(psi_df$psi), max(psi_df$psi)))


# ============================================================
# FIGURE: Capacity Utilization Fan — S0 (two-panel)
# ============================================================

cat("\n=== CU Fan figure ===\n")

library(RColorBrewer)

# Models (reuse already-estimated objects)
mod_bic_nc <- models_noconst[["BIC winner  ARDL(2,3)"]]
mod_aic_nc <- models_noconst[["AIC winner  ARDL(3,3)"]]

lr_sc <- get_lr_full(mod_c23)
lr_sn <- get_lr_full(mod_c1)
lr_bn <- get_lr_full(mod_bic_nc)
lr_an <- get_lr_full(mod_aic_nc)
raw_sc <- get_raw_dummies(mod_c23)

cat(sprintf("LR theta — Shaikh const: %.4f | nc: %.4f | BIC: %.4f | AIC: %.4f\n",
            lr_sc$theta, lr_sn$theta, lr_bn$theta, lr_an$theta))

# Capacity benchmark builder (fan interpretations)
build_yp_fan <- function(lr, df_in, interp, raw = NULL) {
  switch(interp,
         shaikh = lr$a + lr$theta * df_in$k +
           lr$d1956 * df_in$d1956 + lr$d1974 * df_in$d1974 + lr$d1980 * df_in$d1980,
         case1  = lr$theta * df_in$k,
         case3  = lr$a + lr$theta * df_in$k,
         perm   = {
           lr$a + lr$theta * df_in$k +
             raw$d1956 * as.integer(df_in$year >= 1956) +
             raw$d1974 * as.integer(df_in$year >= 1974) +
             raw$d1980 * as.integer(df_in$year >= 1980)
         })
}

build_u_fan <- function(y, yp) {
  ect <- y - yp
  exp(ect - mean(ect, na.rm = TRUE))
}

# CU series
df_fan <- df |> dplyr::select(year, y, k, d1956, d1974, d1980, uK, uFRB)

u_A <- build_u_fan(df_fan$y, build_yp_fan(lr_sc, df_fan, "shaikh"))
u_B <- build_u_fan(df_fan$y, build_yp_fan(lr_sn, df_fan, "case1"))
u_C <- build_u_fan(df_fan$y, build_yp_fan(lr_sc, df_fan, "case3"))
u_D <- build_u_fan(df_fan$y, build_yp_fan(lr_bn, df_fan, "case1"))
u_E <- build_u_fan(df_fan$y, build_yp_fan(lr_an, df_fan, "case1"))
u_F <- build_u_fan(df_fan$y, build_yp_fan(lr_sc, df_fan, "perm", raw = raw_sc))

# Long-form data for faceting
wide_L <- tibble(year = df_fan$year, B_Case1 = u_B, C_Case3 = u_C, F_corrected = u_F)
wide_R <- tibble(year = df_fan$year, B_Case1 = u_B, D_BIC_Case1 = u_D, E_AIC_Case1 = u_E)

fan_L <- wide_L |>
  pivot_longer(-year, names_to = "series", values_to = "cu") |>
  mutate(panel = "Shaikh ARDL(2,4)\u2009\u2014\u2009Alternative LR closures (B, C, F)")
fan_R <- wide_R |>
  pivot_longer(-year, names_to = "series", values_to = "cu") |>
  mutate(panel = "IC-preferred specifications\u2009\u2014\u2009Admissible fan (Case\u00a01)")
fan_all <- bind_rows(fan_L, fan_R) |>
  mutate(panel = factor(panel, levels = unique(panel)))

bm_wide <- tibble(year = df_fan$year, Shaikh_uK = df_fan$uK, FRB = df_fan$uFRB)
benchmarks <- bind_rows(
  bm_wide |> pivot_longer(-year, names_to = "series", values_to = "cu") |>
    mutate(panel = levels(fan_all$panel)[1]),
  bm_wide |> pivot_longer(-year, names_to = "series", values_to = "cu") |>
    mutate(panel = levels(fan_all$panel)[2])
) |> mutate(panel = factor(panel, levels = levels(fan_all$panel)))

# Visual encoding
reds  <- brewer.pal(6, "Reds")[3:6]
blues <- brewer.pal(6, "Blues")[3:6]

fan_colors <- c(
  B_Case1 = scales::alpha(reds[2], 0.75), C_Case3 = scales::alpha(reds[3], 0.55),
  F_corrected = scales::alpha(reds[1], 0.90),
  D_BIC_Case1 = scales::alpha(blues[3], 0.80), E_AIC_Case1 = scales::alpha(blues[2], 0.70))
fan_lt <- c(B_Case1 = "dashed", C_Case3 = "dotted", F_corrected = "solid",
            D_BIC_Case1 = "solid", E_AIC_Case1 = "dashed")
fan_lw <- c(B_Case1 = 0.65, C_Case3 = 0.55, F_corrected = 0.85,
            D_BIC_Case1 = 0.85, E_AIC_Case1 = 0.65)
bm_colors <- c(Shaikh_uK = "#8B0000", FRB = "#222222")

fig_fan <- ggplot() +
  annotate("rect", xmin = 1955.5, xmax = 1956.5, ymin = -Inf, ymax = Inf,
           alpha = 0.05, fill = "#444444") +
  annotate("rect", xmin = 1973, xmax = 1975, ymin = -Inf, ymax = Inf,
           alpha = 0.05, fill = "#444444") +
  annotate("rect", xmin = 1979, xmax = 1982, ymin = -Inf, ymax = Inf,
           alpha = 0.05, fill = "#444444") +
  geom_hline(yintercept = 1, color = "grey60", linetype = "solid", linewidth = 0.35) +
  geom_line(data = fan_all |> filter(!is.na(cu)),
            aes(x = year, y = cu, group = series,
                color = series, linetype = series, linewidth = series)) +
  geom_line(data = benchmarks |> filter(!is.na(cu)),
            aes(x = year, y = cu, group = series, color = series),
            linewidth = 1.1) +
  scale_color_manual(
    values = c(fan_colors, bm_colors),
    labels = c(
      B_Case1     = "B: Shaikh(2,4), Case 1 \u2014 no const., no dummies in LR",
      C_Case3     = "C: Shaikh(2,4), Case 3 \u2014 intercept only in LR",
      F_corrected = "F: Shaikh(2,4), corrected \u2014 SR coefs as step dummies in y\u1D56",
      D_BIC_Case1 = "D: BIC winner ARDL(2,3), Case 1",
      E_AIC_Case1 = "E: AIC winner ARDL(3,3), Case 1",
      Shaikh_uK   = "Shaikh u\u1D4F (raw, Appendix 6.6.1)",
      FRB         = "FRB CU (raw, not rescaled)"),
    name = NULL) +
  scale_linetype_manual(
    values = c(fan_lt, Shaikh_uK = "solid", FRB = "solid"), guide = "none") +
  scale_linewidth_manual(
    values = c(fan_lw, Shaikh_uK = 1.1, FRB = 1.1), guide = "none") +
  facet_wrap(~ panel, ncol = 2) +
  scale_x_continuous(breaks = seq(1950, 2010, 10)) +
  scale_y_continuous(labels = function(x) sprintf("%.2f", x)) +
  labs(title    = "Capacity Utilization Fan \u2014 Stage S0",
       subtitle = "US Corporate Sector, 1947\u20132011 | ARDL long-run residual, demeaned to mean = 1",
       x = NULL, y = "Capacity utilization (index)",
       caption = paste0(
         "Red family: Shaikh ARDL(2,4) under alternative LR closures. ",
         "Blue family: IC-preferred specifications.\n",
         "Grey bands: dummy activation years.")) +
  theme_minimal(base_size = 11) +
  theme(legend.position  = "bottom", legend.direction = "vertical",
        legend.text      = element_text(size = 8),
        legend.key.width = unit(2.0, "cm"),
        panel.grid.minor = element_blank(),
        panel.grid.major = element_line(color = "grey92", linewidth = 0.3),
        strip.text       = element_text(face = "bold", size = 10),
        plot.caption     = element_text(hjust = 0, size = 7.5, color = "grey40"),
        plot.title       = element_text(face = "bold", size = 13),
        plot.subtitle    = element_text(size = 9, color = "grey30")) +
  guides(color = guide_legend(ncol = 1,
           override.aes = list(linewidth = 1.2,
             linetype = c("dashed","dotted","solid","solid","dashed","solid","solid"))))

save_png_pdf_dual(fig_fan, "fig_S0_cu_fan", S0_FIG_DIR, width = 14, height = 7)

# Fan CSV export
fan_export <- tibble(
  year = df_fan$year, A_Shaikh_impl = u_A, B_Shaikh_Case1 = u_B,
  C_Shaikh_Case3 = u_C, D_BIC_Case1 = u_D, E_AIC_Case1 = u_E,
  F_corrected_perm = u_F, Shaikh_uK_raw = df_fan$uK, FRB_raw = df_fan$uFRB)
write.csv(fan_export, file.path(S0_CSV_DIR, "S0_cu_fan_series.csv"), row.names = FALSE)

cat("\nS0 complete. Output:", S0_CSV_DIR, "|", S0_FIG_DIR, "\n")

