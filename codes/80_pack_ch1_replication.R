# ============================================================
# 80_pack_ch3_replication.R
#
# Results packaging for Chapter 1 Critical Replication.
# STRICT CONSUMER of declared public S0/S1/S2 outputs.
# CONTRACT ERROR on any missing input. No fallbacks. No heuristic
# discovery. No schema repair.
#
# Produces:
#   - 8 CSV tables (paper-facing summary tables)
#   - 20 figures as dual PDF + PNG (minimalist, Okabe-Ito, ggrepel-labeled)
#
# Reads:
#   S0: S0_spec_report.csv, S0_utilization_series.csv, S0_fivecase_summary.csv
#   S1: S1_lattice_full.csv, S1_admissible.csv, S1_frontier_F020.csv,
#       S1_frontier_u_band.csv, S1_frontier_theta.csv
#   S2: S2_m2_admissible.csv, S2_m2_omega20.csv, S2_m2_u_band.csv,
#       S2_m3_admissible.csv, S2_m3_omega20.csv, S2_m3_u_band.csv,
#       S2_rotation_check.csv
#
# Writes:
#   output/ResultsPack/tables/
#   output/ResultsPack/figures/
#
# Date: 2026-03-11
# ============================================================

rm(list = ls())

suppressPackageStartupMessages({
  library(here)
  library(dplyr)
  library(tidyr)
  library(ggplot2)
  library(ggrepel)
  library(readr)
})

source(here::here("codes", "10_config.R"))
source(here::here("codes", "99_utils.R"))
source(here::here("codes", "99_figure_protocol.R"))

stopifnot(exists("CONFIG"))

# ---- CONTRACT: assert_file utility ----
assert_file <- function(path) {
  if (!file.exists(path))
    stop("CONTRACT ERROR: expected file not found: ", path, call. = FALSE)
  invisible(path)
}

# ---- Paths ----
S0_DIR <- here::here(CONFIG$OUT_CR$S0_faithful, "csv")
S1_DIR <- here::here(CONFIG$OUT_CR$S1_geometry, "csv")
S2_DIR <- here::here(CONFIG$OUT_CR$S2_vecm, "csv")

PACK_ROOT <- here::here(CONFIG$OUT_CR$results_pack)
PACK_TABLES  <- file.path(PACK_ROOT, "tables")

# Stage-specific figure directories (de-duplicated — no ResultsPack/figures/)
S0_FIGURES <- here::here(CONFIG$OUT_CR$S0_faithful, "figures")
S1_FIGURES <- here::here(CONFIG$OUT_CR$S1_geometry, "figures")
S2_FIGURES <- here::here(CONFIG$OUT_CR$S2_vecm, "figures")
CROSS_FIGURES <- file.path(PACK_ROOT, "figures")  # cross-stage synthesis only

dir.create(PACK_TABLES,   recursive = TRUE, showWarnings = FALSE)
dir.create(S0_FIGURES,     recursive = TRUE, showWarnings = FALSE)
dir.create(S1_FIGURES,     recursive = TRUE, showWarnings = FALSE)
dir.create(S2_FIGURES,     recursive = TRUE, showWarnings = FALSE)
dir.create(CROSS_FIGURES,  recursive = TRUE, showWarnings = FALSE)

# ============================================================
# LOAD ALL INPUTS
# ============================================================

# ---- S0 inputs ----
s0_spec_report <- assert_file(file.path(S0_DIR, "S0_spec_report.csv"))
s0_utilization <- assert_file(file.path(S0_DIR, "S0_utilization_series.csv"))
s0_fivecase    <- assert_file(file.path(S0_DIR, "S0_fivecase_summary.csv"))

cat("S0 inputs verified.\n")
s0_spec  <- read.csv(s0_spec_report)
s0_u     <- read.csv(s0_utilization)
s0_cases <- read.csv(s0_fivecase)

# ---- S1 inputs ----
s1_lattice_path  <- assert_file(file.path(S1_DIR, "S1_lattice_full.csv"))
s1_admiss_path   <- assert_file(file.path(S1_DIR, "S1_admissible.csv"))
s1_frontier_path <- assert_file(file.path(S1_DIR, "S1_frontier_F020.csv"))

cat("S1 inputs verified.\n")
s1_lat <- read.csv(s1_lattice_path)
s1_adm <- read.csv(s1_admiss_path)
s1_f20 <- read.csv(s1_frontier_path)

# Optional S1 files
s1_u_band_path <- file.path(S1_DIR, "S1_frontier_u_band.csv")
s1_theta_path  <- file.path(S1_DIR, "S1_frontier_theta.csv")
s1_u_band <- if (file.exists(s1_u_band_path)) read.csv(s1_u_band_path) else NULL
s1_theta  <- if (file.exists(s1_theta_path))  read.csv(s1_theta_path)  else NULL

# ---- S2 inputs ----
s2_m2_admiss <- assert_file(file.path(S2_DIR, "S2_m2_admissible.csv"))
s2_m2_omega  <- assert_file(file.path(S2_DIR, "S2_m2_omega20.csv"))
s2_m3_admiss <- assert_file(file.path(S2_DIR, "S2_m3_admissible.csv"))
s2_m3_omega  <- assert_file(file.path(S2_DIR, "S2_m3_omega20.csv"))
s2_rotation  <- assert_file(file.path(S2_DIR, "S2_rotation_check.csv"))

cat("S2 inputs verified.\n")
s2_m2_a <- read.csv(s2_m2_admiss)
s2_m2_o <- read.csv(s2_m2_omega)
s2_m3_a <- read.csv(s2_m3_admiss)
s2_m3_o <- read.csv(s2_m3_omega)
s2_rot  <- read.csv(s2_rotation)

# S2 u_band files (optional)
s2_m2_uband_path <- file.path(S2_DIR, "S2_m2_u_band.csv")
s2_m3_uband_path <- file.path(S2_DIR, "S2_m3_u_band.csv")
s2_m2_uband <- if (file.exists(s2_m2_uband_path)) read.csv(s2_m2_uband_path) else NULL
s2_m3_uband <- if (file.exists(s2_m3_uband_path)) read.csv(s2_m3_uband_path) else NULL

# ---- m0 reference row (Shaikh's specification in S1 lattice) ----
m0_row <- s1_adm[s1_adm$p == 2 & s1_adm$q == 4 &
                  s1_adm$case == 3 & s1_adm$s == "s3", ]
if (nrow(m0_row) == 0) {
  cat("WARNING: m0 (2,4,3,s3) not found in S1 admissible set.\n")
}

# ---- lnY series for S0.2 capacity benchmark ----
# Read raw data to compute lnY (same logic as 20_S0)
df_raw <- readr::read_csv(here::here(CONFIG$data_shaikh), show_col_types = FALSE)
Py <- as.numeric(df_raw[[CONFIG$p_index]])
p_scale <- Py / 100
w <- CONFIG$WINDOWS_LOCKED[["shaikh_window"]]

lnY_raw <- data.frame(
  year  = as.integer(df_raw[[CONFIG$year_col]]),
  Y_nom = as.numeric(df_raw[[CONFIG$y_nom]])
)
lnY_raw <- lnY_raw[complete.cases(lnY_raw) & lnY_raw$year >= w[1] & lnY_raw$year <= w[2], ]
lnY_raw <- lnY_raw[order(lnY_raw$year), ]
lnY_raw$lnY <- log(lnY_raw$Y_nom / p_scale[match(lnY_raw$year,
                    as.integer(df_raw[[CONFIG$year_col]]))])
lnY_vec <- lnY_raw$lnY

# Verify lnY length matches s0_u
stopifnot(length(lnY_vec) == nrow(s0_u))


# ============================================================
# BUILD TABLES
# ============================================================

cat("\n--- Building tables ---\n")

# Table 1: S0 bounds report (slimmed)
tab_s0_bounds <- s0_spec[, c("case_id", "boundsF_stat", "boundsF_p",
                              "boundsT_stat", "boundsT_p",
                              "theta_hat", "alpha_hat", "F_pass")]
tab_s0_bounds$boundsF_stat <- round(tab_s0_bounds$boundsF_stat, 3)
tab_s0_bounds$boundsF_p    <- round(tab_s0_bounds$boundsF_p, 4)
tab_s0_bounds$boundsT_stat <- round(tab_s0_bounds$boundsT_stat, 3)
tab_s0_bounds$boundsT_p    <- round(tab_s0_bounds$boundsT_p, 4)
tab_s0_bounds$theta_hat    <- round(tab_s0_bounds$theta_hat, 4)
tab_s0_bounds$alpha_hat    <- round(tab_s0_bounds$alpha_hat, 4)
write.csv(tab_s0_bounds, file.path(PACK_TABLES, "TAB_S0_bounds_report.csv"),
          row.names = FALSE)

# Table 2: S0 five-case coefficients
write.csv(s0_cases, file.path(PACK_TABLES, "TAB_S0_fivecase.csv"),
          row.names = FALSE)

# Table 3: S1 frontier summary (enriched)
s1_ic_win <- extract_ic_winners(s1_adm)
s1_summary <- data.frame(
  total_specs     = nrow(s1_lat),
  admissible      = nrow(s1_adm),
  frontier_F020   = nrow(s1_f20),
  theta_min_F020  = round(min(s1_f20$theta_hat, na.rm = TRUE), 4),
  theta_max_F020  = round(max(s1_f20$theta_hat, na.rm = TRUE), 4),
  theta_mean_F020 = round(mean(s1_f20$theta_hat, na.rm = TRUE), 4),
  sK_min_F020     = round(min(s1_f20$s_K, na.rm = TRUE), 4),
  sK_max_F020     = round(max(s1_f20$s_K, na.rm = TRUE), 4),
  n_cases_in_F020 = length(unique(s1_f20$case)),
  n_dummies_in_F020 = length(unique(s1_f20$s)),
  stringsAsFactors = FALSE
)
write.csv(s1_summary, file.path(PACK_TABLES, "TAB_S1_frontier_summary.csv"),
          row.names = FALSE)

# Table 4: S2 admissibility summary (enriched)
s2_summary <- data.frame(
  system         = c("m=2", "m=3"),
  total_grid     = c(48L, 96L),
  admissible     = c(nrow(s2_m2_a), nrow(s2_m3_a)),
  omega20        = c(nrow(s2_m2_o), nrow(s2_m3_o)),
  theta_min      = c(if (nrow(s2_m2_o) > 0) round(min(s2_m2_o$theta_hat, na.rm = TRUE), 4) else NA_real_,
                     round(min(s2_m3_o$theta_hat, na.rm = TRUE), 4)),
  theta_max      = c(if (nrow(s2_m2_o) > 0) round(max(s2_m2_o$theta_hat, na.rm = TRUE), 4) else NA_real_,
                     round(max(s2_m3_o$theta_hat, na.rm = TRUE), 4)),
  stringsAsFactors = FALSE
)
write.csv(s2_summary, file.path(PACK_TABLES, "TAB_S2_admissibility_summary.csv"),
          row.names = FALSE)

# Table 5: S2 rotation diagnostics
write.csv(s2_rot, file.path(PACK_TABLES, "TAB_S2_rotation_check.csv"),
          row.names = FALSE)

# Table 6: S1 IC winners (NEW)
s1_ic_tab <- do.call(rbind, lapply(names(s1_ic_win), function(ic) {
  w <- s1_ic_win[[ic]]
  if (nrow(w) == 0) return(NULL)
  data.frame(IC = ic, p = w$p[1], q = w$q[1], case = w$case[1], s = w$s[1],
             IC_value = round(w[[ic]][1], 2),
             theta_hat = round(w$theta_hat[1], 4),
             neg2logL = round(w$neg2logL[1], 2),
             k_total = w$k_total[1],
             stringsAsFactors = FALSE)
}))
write.csv(s1_ic_tab, file.path(PACK_TABLES, "TAB_S1_ic_winners.csv"),
          row.names = FALSE)

# Table 7: S2 IC winners (NEW)
s2_m2_ic_win <- extract_ic_winners(s2_m2_a)
s2_m3_ic_win <- extract_ic_winners(s2_m3_a)

s2_ic_tab <- do.call(rbind, c(
  lapply(names(s2_m2_ic_win), function(ic) {
    w <- s2_m2_ic_win[[ic]]
    if (nrow(w) == 0) return(NULL)
    data.frame(m = 2L, IC = ic, p = w$p[1], d = w$d[1], h = w$h[1],
               IC_value = round(w[[ic]][1], 2),
               theta_hat = round(w$theta_hat[1], 4),
               neg2logL = round(w$neg2logL[1], 2),
               k_total = w$k_total[1],
               stringsAsFactors = FALSE)
  }),
  lapply(names(s2_m3_ic_win), function(ic) {
    w <- s2_m3_ic_win[[ic]]
    if (nrow(w) == 0) return(NULL)
    data.frame(m = 3L, IC = ic, p = w$p[1], d = w$d[1], h = w$h[1],
               IC_value = round(w[[ic]][1], 2),
               theta_hat = round(w$theta_hat[1], 4),
               neg2logL = round(w$neg2logL[1], 2),
               k_total = w$k_total[1],
               stringsAsFactors = FALSE)
  })
))
write.csv(s2_ic_tab, file.path(PACK_TABLES, "TAB_S2_ic_winners.csv"),
          row.names = FALSE)

# Table 8: Cross-stage theta comparison (NEW)
theta_cross <- data.frame(
  stage     = c("S0 (ARDL m0)", "S1 (F020 mean)", "S1 (F020 range)",
                "S2 m=2 (Omega20 mean)", "S2 m=3 (Omega20 mean)"),
  theta     = c(round(s0_spec$theta_hat[s0_spec$case_id == 3], 4),
                round(mean(s1_f20$theta_hat, na.rm = TRUE), 4),
                paste0("[", round(min(s1_f20$theta_hat, na.rm = TRUE), 4),
                       ", ", round(max(s1_f20$theta_hat, na.rm = TRUE), 4), "]"),
                if (nrow(s2_m2_o) > 0) round(mean(s2_m2_o$theta_hat, na.rm = TRUE), 4) else NA_real_,
                round(mean(s2_m3_o$theta_hat, na.rm = TRUE), 4)),
  stringsAsFactors = FALSE
)
write.csv(theta_cross, file.path(PACK_TABLES, "TAB_CROSS_theta_comparison.csv"),
          row.names = FALSE)

#cat("Tables written to:", PACK_TABLES, "\n")


# ============================================================
# BUILD FIGURES (dual PDF + PNG via save_png_pdf_dual)
# ============================================================

cat("\n--- Building figures (PDF + PNG) ---\n")

# ---- S0 figures ----

# S0.1: Utilization replication
fig <- build_fig_S0_utilization(s0_u)
save_png_pdf_dual(fig, "fig_S0_utilization_replication", S0_FIGURES)

# S0.2: Capacity benchmark
fig <- build_fig_S0_capacity_benchmark(s0_u, lnY_vec)
save_png_pdf_dual(fig, "fig_S0_capacity_benchmark", S0_FIGURES)

# S0.3: Five-case comparison
fig <- build_fig_S0_fivecase(s0_u, s0_spec)
if (!is.null(fig)) save_png_pdf_dual(fig, "fig_S0_fivecase_comparison", S0_FIGURES,
                                 width = 11, height = 4)

# S0.4: Fit-complexity seed point
fig <- build_fig_S0_seed(s0_spec, s1_adm)
if (!is.null(fig)) save_png_pdf_dual(fig, "fig_S0_fitcomplexity_seed", S0_FIGURES)


# ---- S1 figures ----

# S1.1: Global frontier
fig <- build_fig_S1_global_frontier(s1_adm, m0_row)
save_png_pdf_dual(fig, "fig_S1_global_frontier", S1_FIGURES)

# S1.2: IC tangencies
fig <- build_fig_S1_ic_tangencies(s1_adm, m0_row)
save_png_pdf_dual(fig, "fig_S1_ic_tangencies", S1_FIGURES)

# S1.3: Informational domain
fig <- build_fig_S1_informational_domain(s1_adm, s1_f20, m0_row)
save_png_pdf_dual(fig, "fig_S1_informational_domain", S1_FIGURES)

# S1.4: Theta landscape (new)
fig <- build_fig_S1_theta_landscape(s1_adm, m0_row)
save_png_pdf_dual(fig, "fig_S1_theta_landscape", S1_FIGURES)

# S1 supplementary
if (!is.null(s1_theta) && nrow(s1_theta) > 0) {
  fig <- build_fig_S1_theta_dist(s1_theta)
  save_png_pdf_dual(fig, "fig_S1_theta_distribution", S1_FIGURES)
}

if (!is.null(s1_u_band) && nrow(s1_u_band) > 0) {
  fig <- build_fig_S1_u_band(s1_u_band)
  save_png_pdf_dual(fig, "fig_S1_utilization_band", S1_FIGURES)
}

if (nrow(s1_f20) > 0 && "s_K" %in% names(s1_f20)) {
  fig <- build_fig_S1_sK_dist(s1_f20)
  save_png_pdf_dual(fig, "fig_S1_sK_distribution", S1_FIGURES)
}


# ---- S2 figures ----

# S2 m=2 figures (guarded — m=2 omega/admissible may be empty)
if (nrow(s2_m2_a) > 0 && nrow(s2_m2_o) > 0) {
  fig <- build_fig_S2_global_frontier(s2_m2_a, s2_m2_o, m_dim = 2)
  save_png_pdf_dual(fig, "fig_S2_global_frontier_m2", S2_FIGURES)

  fig <- build_fig_S2_informational_domain(s2_m2_a, s2_m2_o, m_dim = 2)
  save_png_pdf_dual(fig, "fig_S2_informational_domain_m2", S2_FIGURES)
} else {
  cat("  NOTE: S2 m=2 admissible/omega empty — skipping m=2 frontier/domain figures\n")
}

if (nrow(s2_m2_a) > 0) {
  fig <- build_fig_S2_ic_tangencies(s2_m2_a, m_dim = 2)
  save_png_pdf_dual(fig, "fig_S2_ic_tangencies_m2", S2_FIGURES)
} else {
  cat("  NOTE: S2 m=2 admissible empty — skipping m=2 IC tangencies\n")
}

# S2 m=3 figures
fig <- build_fig_S2_global_frontier(s2_m3_a, s2_m3_o, m_dim = 3,
                                     include_r = TRUE)
save_png_pdf_dual(fig, "fig_S2_global_frontier_m3", S2_FIGURES)

fig <- build_fig_S2_ic_tangencies(s2_m3_a, m_dim = 3)
save_png_pdf_dual(fig, "fig_S2_ic_tangencies_m3", S2_FIGURES)

fig <- build_fig_S2_informational_domain(s2_m3_a, s2_m3_o, m_dim = 3,
                                          include_r = TRUE)
save_png_pdf_dual(fig, "fig_S2_informational_domain_m3", S2_FIGURES)

# S2 supplementary: theta distribution (guard for empty m=2)
if (nrow(s2_m2_o) > 0 || nrow(s2_m3_o) > 0) {
  fig <- build_fig_S2_theta_dist(s2_m2_o, s2_m3_o)
  save_png_pdf_dual(fig, "fig_S2_theta_distribution", S2_FIGURES)
}

# S2 supplementary: utilization bands
if (!is.null(s2_m2_uband) && !is.null(s2_m3_uband)) {
  fig <- build_fig_S2_u_band(s2_m2_uband, s2_m3_uband)
  save_png_pdf_dual(fig, "fig_S2_utilization_band", S2_FIGURES, width = 10, height = 5)
}

# S2 supplementary: alpha heatmap (guard for empty m=2)
if (nrow(s2_m2_o) > 0 || nrow(s2_m3_o) > 0) {
  fig <- build_fig_S2_alpha_heatmap(s2_m2_o, s2_m3_o)
} else {
  fig <- NULL
}
if (!is.null(fig)) save_png_pdf_dual(fig, "fig_S2_alpha_heatmap", S2_FIGURES)

# ---- S2 bundled cross-dimensional figures ----

s2_pool_path  <- file.path(S2_DIR, "S2_pooled_admissible.csv")
s2_pool_o_path <- file.path(S2_DIR, "S2_pooled_omega20.csv")
s2_winner_path <- file.path(S2_DIR, "S2_ic_winner_table.csv")

if (all(file.exists(s2_pool_path, s2_pool_o_path, s2_winner_path))) {
  s2_pooled   <- read.csv(s2_pool_path, stringsAsFactors = FALSE)
  s2_pooled_o <- read.csv(s2_pool_o_path, stringsAsFactors = FALSE)
  s2_winners  <- read.csv(s2_winner_path, stringsAsFactors = FALSE)

  s2_pooled$mr_group   <- factor(s2_pooled$mr_group,
                                  levels = c("m2_r1", "m3_r1", "m3_r2"))
  s2_pooled_o$mr_group <- factor(s2_pooled_o$mr_group,
                                  levels = c("m2_r1", "m3_r1", "m3_r2"))

  fig <- build_fig_S2_pooled_frontier(s2_pooled, s2_pooled_o)
  save_png_pdf_dual(fig, "fig_S2_pooled_frontier", S2_FIGURES)

  fig <- build_fig_S2_rank_dominance(s2_winners)
  save_png_pdf_dual(fig, "fig_S2_rank_dominance", S2_FIGURES)

  fig <- build_fig_S2_theta_by_mr(s2_pooled_o)
  if (!is.null(fig))
    save_png_pdf_dual(fig, "fig_S2_theta_by_mr", S2_FIGURES, width = 10, height = 4)
} else {
  cat("  NOTE: S2 pooled CSVs not found -- run 26_S2_vecm_bundle.R first\n")
}


# ---- Cross-stage synthesis ----
fig <- build_fig_cross_synthesis(s1_adm, s2_m2_a, s2_m3_a, m0_row)
save_png_pdf_dual(fig, "fig_CROSS_synthesis", CROSS_FIGURES)


cat("\nPack complete. Output:", PACK_ROOT, "\n")


# ============================================================
# INDEX
# ============================================================
# Collect figures from all stage directories
all_fig_dirs <- c(S0 = S0_FIGURES, S1 = S1_FIGURES, S2 = S2_FIGURES,
                  Cross = CROSS_FIGURES)
fig_index <- unlist(lapply(names(all_fig_dirs), function(stage) {
  figs <- sort(list.files(all_fig_dirs[stage], pattern = "\\.(pdf|png)$"))
  if (length(figs) == 0) return(character(0))
  paste0("- ", stage, ": ", figs)
}))

index_lines <- c(
  "# INDEX \u2014 Chapter 1 Results Pack",
  sprintf("Generated: %s", Sys.time()),
  "",
  "## Tables",
  paste0("- ", sort(list.files(PACK_TABLES))),
  "",
  "## Figures (by stage)",
  fig_index
)
writeLines(index_lines, file.path(PACK_ROOT, "INDEX_RESULTS_PACK.md"))
cat("Index written.\n")
