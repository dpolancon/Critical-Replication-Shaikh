# ============================================================
# 26_S2_vecm_bundle.R
#
# S2 — Unified VECM bundle: cross-dimensional IC competition
#
# Reads CSVs produced by 22_S2_vecm_bivariate.R and
# 23_S2_vecm_trivariate.R, pools admissible specs across
# system dimensions (m=2, m=3) and ranks (r=1, r=2),
# normalizes ICs for cross-dimensional comparison, and
# produces unified figures and summary tables.
#
# Central question: under what IC criterion (if any) does a
# higher-rank or higher-dimension specification win?
#
# Not part of the manifest runner -- run interactively after
# 22 + 23.
# ============================================================

rm(list = ls())

suppressPackageStartupMessages({
  library(here)
  library(dplyr)
  library(tidyr)
  library(ggplot2)
  library(readr)
})

source(here::here("codes", "10_config.R"))
source(here::here("codes", "99_utils.R"))
source(here::here("codes", "98_ardl_helpers.R"))
source(here::here("codes", "99_figure_protocol.R"))

stopifnot(exists("CONFIG"))

IC_NAMES <- c("AIC", "BIC", "HQ", "ICOMP", "RICOMP")
OMEGA_QUANTILE <- 0.20

# ============================================================
# 1) Read existing S2 CSVs
# ============================================================

S2_CSV <- here::here(CONFIG$OUT_CR$S2_vecm %||% "output/S2_vecm", "csv")
S2_FIG <- here::here(CONFIG$OUT_CR$S2_vecm %||% "output/S2_vecm", "figures")
S2_LOG <- here::here(CONFIG$OUT_CR$S2_vecm %||% "output/S2_vecm", "logs")

dir.create(S2_FIG, recursive = TRUE, showWarnings = FALSE)
dir.create(S2_LOG, recursive = TRUE, showWarnings = FALSE)

log_path <- file.path(S2_LOG, "S2_vecm_bundle_log.txt")
sink(log_path, split = TRUE)
on.exit(try(sink(), silent = TRUE), add = TRUE)

cat("=== S2 VECM Bundle: Cross-Dimensional IC Competition ===\n")
cat("Timestamp:", format(Sys.time(), "%Y-%m-%d %H:%M:%S"), "\n\n")

s2_m2_a <- read_csv(file.path(S2_CSV, "S2_m2_admissible.csv"),
                     show_col_types = FALSE)
s2_m3_a <- read_csv(file.path(S2_CSV, "S2_m3_admissible.csv"),
                     show_col_types = FALSE)
s2_m2_o <- read_csv(file.path(S2_CSV, "S2_m2_omega20.csv"),
                     show_col_types = FALSE)
s2_m3_o <- read_csv(file.path(S2_CSV, "S2_m3_omega20.csv"),
                     show_col_types = FALSE)
s2_m2_uband <- read_csv(file.path(S2_CSV, "S2_m2_u_band.csv"),
                          show_col_types = FALSE)
s2_m3_uband <- read_csv(file.path(S2_CSV, "S2_m3_u_band.csv"),
                          show_col_types = FALSE)

# Rotation check (may not exist if no r=2 specs were admissible)
rot_path <- file.path(S2_CSV, "S2_rotation_check.csv")
rotation_df <- if (file.exists(rot_path)) {
  read_csv(rot_path, show_col_types = FALSE)
} else {
  NULL
}

cat("Loaded:\n")
cat("  m=2 admissible:", nrow(s2_m2_a), "\n")
cat("  m=3 admissible:", nrow(s2_m3_a), "\n")
cat("  m=2 Omega_20:  ", nrow(s2_m2_o), "\n")
cat("  m=3 Omega_20:  ", nrow(s2_m3_o), "\n")

# ============================================================
# 2) Schema harmonization + pooling
# ============================================================

# Add alpha_e to m=2 if missing
if (!"alpha_e" %in% names(s2_m2_a)) s2_m2_a$alpha_e <- NA_real_
if (!"alpha_e" %in% names(s2_m2_o)) s2_m2_o$alpha_e <- NA_real_

# Prefix spec_ids to avoid collisions
s2_m2_a$spec_id <- paste0("m2:", s2_m2_a$spec_id)
s2_m3_a$spec_id <- paste0("m3:", s2_m3_a$spec_id)
s2_m2_o$spec_id <- paste0("m2:", s2_m2_o$spec_id)
s2_m3_o$spec_id <- paste0("m3:", s2_m3_o$spec_id)

# Pool (handle empty dataframes — readr may infer wrong types for 0-row CSVs)
if (nrow(s2_m2_a) == 0 && nrow(s2_m3_a) > 0) {
  pooled <- s2_m3_a
} else if (nrow(s2_m3_a) == 0 && nrow(s2_m2_a) > 0) {
  pooled <- s2_m2_a
} else {
  pooled <- bind_rows(s2_m2_a, s2_m3_a)
}
pooled$mr_group <- factor(
  paste0("m", pooled$m, "_r", pooled$r),
  levels = c("m2_r1", "m3_r1", "m3_r2")
)

cat("\nPooled admissible:", nrow(pooled), "specs\n")
cat("  by (m,r) group:\n")
print(table(pooled$mr_group))

# ============================================================
# 3) Normalized ICs
# ============================================================
#
# NOTE: Raw IC values from m=2 and m=3 systems are NOT directly
# comparable due to different likelihood dimensionality.
# We normalize by:
#   IC_norm  = IC / (m * T_eff)   -- per-variable-per-observation
#   IC_perEq = IC / m             -- per-equation
# These are exploratory and should be interpreted with caution.
# ============================================================

for (ic in IC_NAMES) {
  pooled[[paste0(ic, "_norm")]]  <- pooled[[ic]] / (pooled$m * pooled$T_eff)
  pooled[[paste0(ic, "_perEq")]] <- pooled[[ic]] / pooled$m
}
pooled$neg2logL_norm <- pooled$neg2logL / (pooled$m * pooled$T_eff)

cat("\nNormalized ICs computed (IC_norm = IC/(m*T_eff), IC_perEq = IC/m)\n")

# ============================================================
# 4) IC winners: within-m and cross-m
# ============================================================

build_winner_row <- function(df, ic_col, ic_name, variant, mr_label = NA) {
  vals <- df[[ic_col]]
  if (all(is.na(vals))) return(NULL)
  idx <- which.min(vals)
  row <- df[idx, , drop = FALSE]
  data.frame(
    ic      = ic_name,
    variant = variant,
    winner_mr = as.character(row$mr_group),
    winner_spec = row$spec_id,
    ic_value = row[[ic_col]],
    theta_hat = row$theta_hat,
    p = row$p, d = row$d, h = row$h, m = row$m, r = row$r,
    stringsAsFactors = FALSE
  )
}

winner_rows <- list()
i <- 0L

for (ic in IC_NAMES) {
  # Within m=2
  m2_sub <- pooled[pooled$m == 2, ]
  if (nrow(m2_sub) > 0) {
    i <- i + 1L
    winner_rows[[i]] <- build_winner_row(m2_sub, ic, ic, "within_m2")
  }

  # Within m=3
  m3_sub <- pooled[pooled$m == 3, ]
  if (nrow(m3_sub) > 0) {
    i <- i + 1L
    winner_rows[[i]] <- build_winner_row(m3_sub, ic, ic, "within_m3")
  }

  # Cross-m normalized
  ic_norm <- paste0(ic, "_norm")
  i <- i + 1L
  winner_rows[[i]] <- build_winner_row(pooled, ic_norm, ic, "normalized")

  # Cross-m per-equation
  ic_perEq <- paste0(ic, "_perEq")
  i <- i + 1L
  winner_rows[[i]] <- build_winner_row(pooled, ic_perEq, ic, "per_equation")
}

winner_table <- bind_rows(winner_rows)

cat("\n=== IC WINNER TABLE ===\n")
for (v in c("within_m2", "within_m3", "normalized", "per_equation")) {
  sub <- winner_table[winner_table$variant == v, ]
  cat(sprintf("\n--- %s ---\n", v))
  for (j in seq_len(nrow(sub))) {
    rr <- sub[j, ]
    cat(sprintf("  %-8s -> %-7s  spec=%-25s  theta=%.4f  IC=%.2f\n",
                rr$ic, rr$winner_mr, rr$winner_spec, rr$theta_hat, rr$ic_value))
  }
}

# Key question: does any IC ever pick m3_r2?
any_r2_winner <- any(winner_table$winner_mr == "m3_r2", na.rm = TRUE)
cat("\n*** Does any IC criterion select m3_r2? ***\n")
cat("  Answer:", if (any_r2_winner) "YES" else "NO", "\n")

if (any_r2_winner) {
  r2_wins <- winner_table[winner_table$winner_mr == "m3_r2", ]
  cat("  Criteria selecting m3_r2:\n")
  for (j in seq_len(nrow(r2_wins))) {
    cat(sprintf("    %s (%s)\n", r2_wins$ic[j], r2_wins$variant[j]))
  }
}

# Cross-dimensional vacuity diagnostic
n_m2_adm <- sum(pooled$m == 2)
if (n_m2_adm == 0) {
  cat("\nNOTE: Cross-dimensional comparison (normalized/per_equation)\n")
  cat("is vacuous: m=2 has 0 admissible specs. Only within_m3\n")
  cat("results are substantive.\n")
}

# ============================================================
# 5) Omega^(0.20) — Pareto-envelope fattening
# ============================================================
#
# Definition (three objects in strict logical order):
#   E_S2(k)      = argmax_{m in pooled, k(m)=k} logL(m)
#   delta(m)     = [-2logL(m)] - [-2logL(E_S2(k(m)))] >= 0
#   Omega^(0.20) = { m : delta(m) <= Q_0.20(delta) }
#
# Uses raw neg2logL (not normalized) — within-k, m and T_eff
# are fixed so normalization is irrelevant.
# ============================================================

# Step 1: Pareto envelope at each k_total
env_pooled <- pooled %>%
  group_by(k_total) %>%
  slice_max(logLik, n = 1, with_ties = FALSE) %>%
  ungroup() %>%
  select(k_total, env_logLik = logLik) %>%
  mutate(env_neg2logL = -2 * env_logLik)

# Step 2: delta(m) for every pooled spec
pooled <- pooled %>%
  left_join(env_pooled, by = "k_total") %>%
  mutate(delta_frontier = pmax(neg2logL - env_neg2logL, 0),
         delta_frontier = ifelse(delta_frontier < 1e-6, 0, delta_frontier))

# Step 3: Omega^(0.20) = bottom 20% of delta distribution
q20_delta <- quantile(pooled$delta_frontier,
                       probs = OMEGA_QUANTILE, na.rm = TRUE)
pooled_omega <- pooled %>% filter(delta_frontier <= q20_delta)

# Diagnostics
cat("\nDelta quantile distribution (pooled):\n")
print(quantile(pooled$delta_frontier,
                probs = c(0.20, 0.25, 0.30, 0.40, 0.50),
                na.rm = TRUE))
cat("Q_0.20(delta):      ", round(q20_delta, 4), "\n")
cat("E_S2 (delta==0):    ", sum(pooled$delta_frontier == 0), "specs\n")
cat("Omega^(0.20):       ", nrow(pooled_omega), "specs\n")
cat("E_S2 subset Omega:  ",
    all(pooled$delta_frontier[pooled$delta_frontier == 0] <= q20_delta),
    "\n")

if (q20_delta == 0) {
  cat("Omega^(0.20) collapses to E_S2 -- 20th percentile of delta is zero.\n")
}

cat("  by (m,r) group:\n")
print(table(pooled_omega$mr_group))

# ============================================================
# 6) Diagnostics by (m,r) group
# ============================================================

cat("\n=== THETA DIAGNOSTICS (Omega^(0.20)) ===\n")
tv_omega <- pooled_omega$theta_hat[is.finite(pooled_omega$theta_hat)]
if (length(tv_omega) > 0) {
  cat(sprintf("  Omega^(0.20): n=%d  mean=%.4f  sd=%.4f  [%.4f, %.4f]\n",
              length(tv_omega), mean(tv_omega),
              if (length(tv_omega) > 1) sd(tv_omega) else NA_real_,
              min(tv_omega), max(tv_omega)))
} else {
  cat("  Omega^(0.20): n=0\n")
}

# E_S2 (envelope) theta separately
e_s2 <- pooled[pooled$delta_frontier == 0, ]
tv_env <- e_s2$theta_hat[is.finite(e_s2$theta_hat)]
if (length(tv_env) > 0) {
  cat(sprintf("  E_S2 (delta==0): n=%d  mean=%.4f  sd=%.4f  [%.4f, %.4f]\n",
              length(tv_env), mean(tv_env),
              if (length(tv_env) > 1) sd(tv_env) else NA_real_,
              min(tv_env), max(tv_env)))
}

cat("\n  by (m,r) group in Omega^(0.20):\n")
for (grp in levels(pooled$mr_group)) {
  sub <- pooled_omega[pooled_omega$mr_group == grp, ]
  tv <- sub$theta_hat[is.finite(sub$theta_hat)]
  if (length(tv) == 0) {
    cat(sprintf("    %-7s: n=0\n", grp))
  } else {
    cat(sprintf("    %-7s: n=%d  mean=%.4f  [%.4f, %.4f]\n",
                grp, length(tv), mean(tv), min(tv), max(tv)))
  }
}

cat("\n  k_total distribution in Omega^(0.20):\n")
print(table(pooled_omega$k_total))

cat("\n=== ALPHA DIAGNOSTICS (Omega_20) ===\n")
for (grp in levels(pooled$mr_group)) {
  sub <- pooled_omega[pooled_omega$mr_group == grp, ]
  if (nrow(sub) == 0) next
  cat(sprintf("  %s:\n", grp))
  cat(sprintf("    alpha_y: [%.4f, %.4f]\n",
              min(sub$alpha_y, na.rm = TRUE), max(sub$alpha_y, na.rm = TRUE)))
  cat(sprintf("    alpha_k: [%.4f, %.4f]\n",
              min(sub$alpha_k, na.rm = TRUE), max(sub$alpha_k, na.rm = TRUE)))
  if (any(!is.na(sub$alpha_e))) {
    cat(sprintf("    alpha_e: [%.4f, %.4f]\n",
                min(sub$alpha_e, na.rm = TRUE), max(sub$alpha_e, na.rm = TRUE)))
  }
}

# Rotation pass-through
if (!is.null(rotation_df) && nrow(rotation_df) > 0) {
  cat("\n=== P8 ROTATION DIAGNOSTIC (pass-through) ===\n")
  n_sign <- sum(rotation_df$sign_consistent, na.rm = TRUE)
  cat("  r=2 specs tested:", nrow(rotation_df), "\n")
  cat("  lambda < 0 (sign consistent):", n_sign, "/", nrow(rotation_df), "\n")
} else {
  cat("\nP8 rotation: skipped (no r=2 admissible specs)\n")
}

# ============================================================
# 7) Figures
# ============================================================

cat("\n--- Building figures ---\n")

# 7a. Pooled frontier (new)
fig <- build_fig_S2_pooled_frontier(pooled, pooled_omega)
save_png_pdf_dual(fig, "fig_S2_pooled_frontier", S2_FIG)

# 7b. Rank dominance (new)
fig <- build_fig_S2_rank_dominance(winner_table)
save_png_pdf_dual(fig, "fig_S2_rank_dominance", S2_FIG)

# 7c. Theta by (m,r) group (new)
fig <- build_fig_S2_theta_by_mr(pooled_omega)
if (!is.null(fig)) {
  save_png_pdf_dual(fig, "fig_S2_theta_by_mr", S2_FIG, width = 10, height = 4)
}

# 7d. Theta distribution m=2 vs m=3 (existing — needs both non-empty)
if (nrow(s2_m2_o) > 0 && nrow(s2_m3_o) > 0) {
  fig <- build_fig_S2_theta_dist(s2_m2_o, s2_m3_o)
  save_png_pdf_dual(fig, "fig_S2_theta_distribution", S2_FIG)
} else {
  cat("  Skipped theta_dist: m=2 or m=3 Omega_20 empty\n")
}

# 7e. Utilization bands (existing — needs non-null, non-empty u_bands)
has_m2_uband <- !is.null(s2_m2_uband) && nrow(s2_m2_uband) > 0 &&
                any(!is.na(s2_m2_uband$u_med))
has_m3_uband <- !is.null(s2_m3_uband) && nrow(s2_m3_uband) > 0 &&
                any(!is.na(s2_m3_uband$u_med))
if (has_m2_uband && has_m3_uband) {
  fig <- build_fig_S2_u_band(s2_m2_uband, s2_m3_uband)
  save_png_pdf_dual(fig, "fig_S2_utilization_band", S2_FIG, width = 10, height = 5)
} else {
  cat("  Skipped u_band: m=2 or m=3 u_band empty or all-NA\n")
}

# 7f. Alpha heatmap (existing — needs both non-empty)
if (nrow(s2_m2_o) > 0 && nrow(s2_m3_o) > 0) {
  fig <- build_fig_S2_alpha_heatmap(s2_m2_o, s2_m3_o)
  save_png_pdf_dual(fig, "fig_S2_alpha_heatmap", S2_FIG)
} else {
  cat("  Skipped alpha_heatmap: m=2 or m=3 Omega_20 empty\n")
}

cat("Figures saved to:", S2_FIG, "\n")

# ============================================================
# 8) CSV exports
# ============================================================

safe_write_csv(pooled,        file.path(S2_CSV, "S2_pooled_admissible.csv"))
safe_write_csv(pooled_omega,  file.path(S2_CSV, "S2_pooled_omega20.csv"))
safe_write_csv(winner_table,  file.path(S2_CSV, "S2_ic_winner_table.csv"))

cat("CSVs written to:", S2_CSV, "\n")

# ============================================================
# 9) Summary
# ============================================================

cat("\n=== S2 BUNDLE VERIFICATION ===\n")
cat("Pooled admissible:   ", nrow(pooled), "\n")
cat("Pooled Omega_20:     ", nrow(pooled_omega), "\n")
cat("  m2_r1 in Omega_20: ", sum(pooled_omega$mr_group == "m2_r1"), "\n")
cat("  m3_r1 in Omega_20: ", sum(pooled_omega$mr_group == "m3_r1"), "\n")
cat("  m3_r2 in Omega_20: ", sum(pooled_omega$mr_group == "m3_r2"), "\n")
cat("Any r=2 IC winner:   ", any_r2_winner, "\n")
cat("\nNOTE: Cross-dimensional IC comparison uses per-variable-per-\n")
cat("observation normalization IC/(m*T_eff). Raw IC values from\n")
cat("m=2 and m=3 systems are NOT directly comparable. Normalized\n")
cat("comparisons are exploratory.\n")
cat("========================================\n")
cat("STAGE_STATUS_HINT: stage=S2_bundle status=complete\n")
cat("\nDONE.\n")
