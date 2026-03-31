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

