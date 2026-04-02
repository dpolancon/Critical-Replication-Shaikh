# ============================================================
# 27_S2_vecm_focal_p2d2h2.R
#
# S2 — Focal VECM specification deep-dive: (p=2, d2, h2, r=1)
#
# Trivariate system: X_t = (lnY_t, lnK_t, lnE_t)'
# Cointegration rank: r = 1
# VECM lag: 1 (= p - 1 = 2 - 1)
# Deterministic: d2 (unrestricted SR constant, no LR constant)
# Shocks: h2 (step dummies at 1956, 1974, 1980)
#
# Self-contained: re-estimates from raw data (no S2 lattice imports).
#
# Methodology:
#   Block 0: Preamble
#   Block 1: Data construction
#   Block 2: Dual estimation (tsDyn + urca)
#   Block 3: Beta extraction with SEs
#   Block 4: Alpha, Gamma, deterministic extraction with SEs
#   Block 5: Diagnostic tests
#   Block 6: CU path (raw cointegrating residual)
#   Block 7: Figure — CU path
#   Block 8: Figure — Companion eigenvalues
#   Block 9: Summary and verification
#
# Outputs: output/S2_vecm/focal/
# ============================================================

rm(list = ls())

suppressPackageStartupMessages({
  library(here)
  library(dplyr)
  library(ggplot2)
  library(tsDyn)
  library(urca)
  library(vars)
  library(readr)
})

# ------------------------------------------------------------
# Source config, utils, figure protocol
# ------------------------------------------------------------
source(here::here("codes", "10_config.R"))
source(here::here("codes", "99_utils.R"))
source(here::here("codes", "99_figure_protocol.R"))

stopifnot(exists("CONFIG"))


# ============================================================
# FOCAL SPEC PARAMETERS
# ============================================================

P_VAR       <- 2L          # VAR lag order
VECM_LAG    <- 1L          # max(0, P_VAR - 1)
R_RANK      <- 1L          # cointegration rank
M_DIM       <- 3L          # trivariate
D_INCLUDE   <- "const"     # d2: unrestricted SR constant
D_LRINCLUDE <- "none"      # d2: no restricted LR constant
D_ECDET     <- "none"      # urca equivalent of d2
DUMMY_YEARS <- c(1956L, 1974L, 1980L)
WINDOW_TAG  <- "shaikh_window"


# ============================================================
# OUTPUT DIRECTORIES
# ============================================================

FOCAL_DIR <- here::here(CONFIG$OUT_CR$S2_vecm %||% "output/S2_vecm", "focal")
CSV_DIR   <- file.path(FOCAL_DIR, "csv")
FIG_DIR   <- file.path(FOCAL_DIR, "figures")
LOG_DIR   <- file.path(FOCAL_DIR, "logs")

dir.create(CSV_DIR, recursive = TRUE, showWarnings = FALSE)
dir.create(FIG_DIR, recursive = TRUE, showWarnings = FALSE)
dir.create(LOG_DIR, recursive = TRUE, showWarnings = FALSE)

log_path <- file.path(LOG_DIR, "S2_focal_p2d2h2_log.txt")
sink(log_path, split = TRUE)
on.exit(try(sink(), silent = TRUE), add = TRUE)

cat("=== S2 Focal VECM: (p=2, d2, h2, r=1) ===\n")
cat("Timestamp:", format(Sys.time(), "%Y-%m-%d %H:%M:%S"), "\n\n")


# ============================================================
# BLOCK 1: DATA CONSTRUCTION
# ============================================================

cat("\n===== BLOCK 1: DATA CONSTRUCTION =====\n")

df_raw <- read_csv(here::here(CONFIG[["data_shaikh"]]), show_col_types = FALSE)

Py      <- as.numeric(df_raw[[CONFIG$p_index]])
p_scale <- Py / 100

df0 <- data.frame(
  year  = as.integer(df_raw[[CONFIG$year_col]]),
  Y_nom = as.numeric(df_raw[[CONFIG$y_nom]]),
  K_nom = as.numeric(df_raw[[CONFIG$k_nom]]),
  e_raw = as.numeric(df_raw[[CONFIG$e_rate]])
)
df0 <- df0[complete.cases(df0) & df0$year > 0, ]
df0$lnY <- log(df0$Y_nom / p_scale[match(df0$year, as.integer(df_raw[[CONFIG$year_col]]))])
df0$lnK <- log(df0$K_nom / p_scale[match(df0$year, as.integer(df_raw[[CONFIG$year_col]]))])
df0$e   <- log(df0$e_raw)

# Step dummies
for (yy in DUMMY_YEARS) df0[[paste0("d", yy)]] <- as.integer(df0$year >= yy)

# Window
w  <- CONFIG$WINDOWS_LOCKED[[WINDOW_TAG]]
df <- df0[df0$year >= w[1] & df0$year <= w[2], ]
df <- df[order(df$year), ]
df <- df[is.finite(df$e), ]
T_obs <- nrow(df)

# State matrix
X3 <- as.matrix(df[, c("lnY", "lnK", "e")])
colnames(X3) <- c("lnY", "lnK", "e")

# Dummy matrix (h2: all three)
dum_mat <- as.matrix(df[, c("d1956", "d1974", "d1980")])

# FRB CU for optional overlay
u_frb <- tryCatch(
  as.numeric(df_raw[[CONFIG$u_frb]])[match(df$year, as.integer(df_raw[[CONFIG$year_col]]))],
  error = function(e) NULL
)

cat("Window:", min(df$year), "-", max(df$year), " T =", T_obs, "\n")
cat("State matrix:", paste(colnames(X3), collapse = ", "), "\n")
cat("Dummies:", paste(colnames(dum_mat), collapse = ", "), "\n\n")


# ============================================================
# BLOCK 2: DUAL ESTIMATION (tsDyn + urca)
# ============================================================

cat("\n===== BLOCK 2: DUAL ESTIMATION =====\n")

# --- tsDyn estimation ---
vecm_fit <- tsDyn::VECM(
  X3,
  lag       = VECM_LAG,
  r         = R_RANK,
  estim     = "ML",
  include   = D_INCLUDE,
  LRinclude = D_LRINCLUDE,
  exogen    = dum_mat
)

beta_tsdyn  <- as.matrix(tsDyn::coefB(vecm_fit))
alpha_tsdyn <- as.matrix(tsDyn::coefA(vecm_fit))

theta_hat <- -as.numeric(beta_tsdyn[2, 1])
alpha_y   <- as.numeric(alpha_tsdyn[1, 1])
alpha_k   <- as.numeric(alpha_tsdyn[2, 1])
alpha_e   <- as.numeric(alpha_tsdyn[3, 1])

cat(sprintf("tsDyn theta_hat = %.4f\n", theta_hat))
cat(sprintf("tsDyn alpha_y   = %.4f\n", alpha_y))
cat(sprintf("tsDyn alpha_k   = %.4f\n", alpha_k))
cat(sprintf("tsDyn alpha_e   = %.4f\n", alpha_e))

# --- urca estimation ---
jo <- urca::ca.jo(X3, type = "trace", ecdet = D_ECDET, K = P_VAR,
                  dumvar = dum_mat)

# Restricted OLS (cajorls) for SEs
jo_rls <- urca::cajorls(jo, r = R_RANK)
beta_urca <- jo_rls$beta   # normalized cointegrating vector

cat(sprintf("\nurca beta = (%s)\n",
            paste(sprintf("%.4f", beta_urca[, 1]), collapse = ", ")))

# Cross-check tsDyn vs urca
cat(sprintf("\nCross-check theta: tsDyn = %.4f, urca = %.4f\n",
            theta_hat, -as.numeric(beta_urca[2, 1])))


# ============================================================
# BLOCK 3: BETA EXTRACTION WITH SEs
# ============================================================

cat("\n===== BLOCK 3: BETA =====\n")

# Normalized beta from urca (first element = 1)
beta_norm <- as.numeric(beta_urca[, 1])
names(beta_norm) <- rownames(beta_urca)

# --- Beta SEs via Johansen (1995) Theorem 13.3 ---
# For r=1, beta = (1, beta_2, ..., beta_m)' normalized on first element.
# Asymptotic variance of (beta_2, ..., beta_m):
#   Var = (1 / (T * lambda_1 / (1 - lambda_1))) * S11_22.1^{-1}
# where S11 is the residual moment matrix from the concentration step
# (stored in jo@RK), lambda_1 is the largest eigenvalue, and S11_22.1
# is the Schur complement of S11[1,1] in S11.

beta_se <- tryCatch({
  S11 <- crossprod(jo@RK) / nrow(jo@RK)
  T_jo <- nrow(jo@RK)
  lambda1 <- jo@lambda[1]

  # Schur complement: S11_22 - S11_21 * S11_11^{-1} * S11_12
  s11 <- S11[1, 1]
  s12 <- S11[1, 2:M_DIM, drop = FALSE]
  s21 <- S11[2:M_DIM, 1, drop = FALSE]
  s22 <- S11[2:M_DIM, 2:M_DIM]
  S11_schur <- s22 - s21 %*% solve(s11) %*% s12

  beta_var <- (1 / (T_jo * lambda1 / (1 - lambda1))) * solve(S11_schur)
  sqrt(diag(beta_var))
}, error = function(e) {
  cat("  Beta SE computation failed:", conditionMessage(e), "\n")
  rep(NA_real_, M_DIM - 1)
})

# Build beta table
beta_se_full <- c(NA_real_, beta_se)  # first element (normalized to 1) has no SE
beta_t <- ifelse(is.na(beta_se_full) | beta_se_full == 0, NA_real_,
                 beta_norm / beta_se_full)
beta_p <- ifelse(is.na(beta_t), NA_real_,
                 2 * pt(abs(beta_t), df = T_obs - VECM_LAG * M_DIM, lower.tail = FALSE))

add_stars <- function(p) {
  ifelse(is.na(p), "",
  ifelse(p < 0.01, "***",
  ifelse(p < 0.05, "**",
  ifelse(p < 0.10, "*", ""))))
}

focal_beta <- data.frame(
  variable = c("lnY", "lnK", "e"),
  beta     = beta_norm,
  se       = beta_se_full,
  t_stat   = beta_t,
  p_value  = beta_p,
  signif   = add_stars(beta_p),
  stringsAsFactors = FALSE
)

safe_write_csv(focal_beta, file.path(CSV_DIR, "focal_beta.csv"))
cat("Beta:\n")
print(focal_beta, row.names = FALSE)


# ============================================================
# BLOCK 4: ALPHA, GAMMA, DETERMINISTIC WITH SEs
# ============================================================

cat("\n===== BLOCK 4: ALPHA / GAMMA / DETERMINISTIC =====\n")

# Use cajorls restricted OLS model — it's a standard mlm
rlm_obj  <- jo_rls$rlm
rlm_summ <- summary(rlm_obj)

# Equation names from urca's mlm
eq_names <- colnames(fitted(rlm_obj))  # e.g. "lnY.d", "lnK.d", "e.d"
eq_labels <- c("lnY", "lnK", "e")

# --- Helper: extract coefficient table from mlm summary ---
extract_coef_rows <- function(rlm_summ, eq_idx, coef_pattern) {
  ct <- coef(rlm_summ)[[eq_idx]]
  rows <- grep(coef_pattern, rownames(ct))
  if (length(rows) == 0) return(NULL)
  out <- as.data.frame(ct[rows, , drop = FALSE])
  colnames(out) <- c("estimate", "se", "t_stat", "p_value")
  out$variable <- rownames(ct)[rows]
  out$equation <- eq_labels[eq_idx]
  out$signif   <- add_stars(out$p_value)
  out
}

# --- Alpha (ECT coefficient in each equation) ---
alpha_rows <- lapply(seq_along(eq_labels), function(i) {
  extract_coef_rows(rlm_summ, i, "^ect1$")
})
focal_alpha <- bind_rows(alpha_rows)
focal_alpha$variable <- eq_labels  # rename to match convention

safe_write_csv(focal_alpha, file.path(CSV_DIR, "focal_alpha.csv"))
cat("Alpha:\n")
print(focal_alpha, row.names = FALSE)

# --- Gamma_1 (lagged differences) ---
gamma_rows <- lapply(seq_along(eq_labels), function(i) {
  extract_coef_rows(rlm_summ, i, "\\.dl[0-9]+$")
})
focal_gamma <- bind_rows(gamma_rows)

safe_write_csv(focal_gamma, file.path(CSV_DIR, "focal_gamma1.csv"))
cat("\nGamma_1:\n")
print(focal_gamma, row.names = FALSE)

# --- Deterministic: constant + step dummies ---
det_rows <- lapply(seq_along(eq_labels), function(i) {
  # Constant
  const_row <- extract_coef_rows(rlm_summ, i, "^constant$|^\\(Intercept\\)$")
  # Step dummies
  dum_row <- extract_coef_rows(rlm_summ, i, "^d1956$|^d1974$|^d1980$|^sd")
  bind_rows(const_row, dum_row)
})
focal_det <- bind_rows(det_rows)

safe_write_csv(focal_det, file.path(CSV_DIR, "focal_deterministic.csv"))
cat("\nDeterministic:\n")
print(focal_det, row.names = FALSE)


# ============================================================
# BLOCK 5: DIAGNOSTIC TESTS
# ============================================================

cat("\n===== BLOCK 5: DIAGNOSTICS =====\n")

# --- Companion matrix eigenvalues ---
var_coefs <- tsDyn::VARrep(vecm_fit)
lag_cols  <- grep("\\.l[0-9]+$", colnames(var_coefs))
A_lag     <- var_coefs[, lag_cols, drop = FALSE]
p_var_eff <- as.integer(ncol(A_lag) / M_DIM)

if (p_var_eff == 1L) {
  C_comp  <- A_lag
  eig_all <- eigen(A_lag)
} else {
  n_comp  <- M_DIM * p_var_eff
  C_comp  <- matrix(0, n_comp, n_comp)
  C_comp[1:M_DIM, ] <- A_lag
  C_comp[(M_DIM + 1):n_comp, 1:(M_DIM * (p_var_eff - 1))] <- diag(M_DIM * (p_var_eff - 1))
  eig_all <- eigen(C_comp)
}
eig_mod <- Mod(eig_all$values)

cat(sprintf("Companion eigenvalue moduli: %s\n",
            paste(sprintf("%.4f", sort(eig_mod, decreasing = TRUE)), collapse = ", ")))
cat(sprintf("Max modulus: %.4f (expect m-r=%d near 1.0)\n", max(eig_mod), M_DIM - R_RANK))

# --- Johansen trace statistics ---
cat("\nJohansen trace test:\n")
for (i in seq_along(jo@teststat)) {
  cat(sprintf("  r <= %d: stat = %.2f, 10pct = %.2f, 5pct = %.2f, 1pct = %.2f\n",
              M_DIM - i, jo@teststat[i],
              jo@cval[i, "10pct"], jo@cval[i, "5pct"], jo@cval[i, "1pct"]))
}

# --- Residual diagnostics via vars::vec2var ---
diag_results <- list()

var_rep <- tryCatch({
  vars::vec2var(jo, r = R_RANK)
}, error = function(e) {
  cat("  vec2var conversion failed:", conditionMessage(e), "\n")
  NULL
})

if (!is.null(var_rep)) {
  # Portmanteau
  pt_test <- tryCatch({
    vars::serial.test(var_rep, lags.pt = 12, type = "PT.asymptotic")
  }, error = function(e) NULL)

  if (!is.null(pt_test)) {
    diag_results[["Portmanteau(12)"]] <- list(
      statistic = pt_test$serial$statistic,
      p_value   = pt_test$serial$p.value
    )
    cat(sprintf("Portmanteau(12): stat = %.2f, p = %.4f\n",
                pt_test$serial$statistic, pt_test$serial$p.value))
  }

  # Breusch-Godfrey
  bg_test <- tryCatch({
    vars::serial.test(var_rep, lags.bg = 4, type = "BG")
  }, error = function(e) NULL)

  if (!is.null(bg_test)) {
    diag_results[["BG-LM(4)"]] <- list(
      statistic = bg_test$serial$statistic,
      p_value   = bg_test$serial$p.value
    )
    cat(sprintf("BG-LM(4): stat = %.2f, p = %.4f\n",
                bg_test$serial$statistic, bg_test$serial$p.value))
  }

  # Jarque-Bera
  jb_test <- tryCatch({
    vars::normality.test(var_rep, multivariate.only = FALSE)
  }, error = function(e) NULL)

  if (!is.null(jb_test)) {
    jb_sys <- jb_test$jb.mul$JB
    diag_results[["JB-system"]] <- list(
      statistic = jb_sys$statistic,
      p_value   = jb_sys$p.value
    )
    cat(sprintf("JB-system: stat = %.2f, p = %.4f\n",
                jb_sys$statistic, jb_sys$p.value))
  }

  # ARCH-LM
  arch_test <- tryCatch({
    vars::arch.test(var_rep, lags.multi = 4)
  }, error = function(e) NULL)

  if (!is.null(arch_test)) {
    diag_results[["ARCH-LM(4)"]] <- list(
      statistic = arch_test$arch.mul$statistic,
      p_value   = arch_test$arch.mul$p.value
    )
    cat(sprintf("ARCH-LM(4): stat = %.2f, p = %.4f\n",
                arch_test$arch.mul$statistic, arch_test$arch.mul$p.value))
  }
}

# --- Build diagnostics CSV ---
diag_rows <- list()

# Residual tests
for (nm in names(diag_results)) {
  diag_rows[[length(diag_rows) + 1]] <- data.frame(
    test      = nm,
    statistic = as.numeric(diag_results[[nm]]$statistic),
    p_value   = as.numeric(diag_results[[nm]]$p_value),
    cval_5pct = NA_real_,
    verdict   = ifelse(as.numeric(diag_results[[nm]]$p_value) > 0.05, "PASS", "FAIL"),
    stringsAsFactors = FALSE
  )
}

# Companion eigenvalues
diag_rows[[length(diag_rows) + 1]] <- data.frame(
  test = "companion_max_eigenmod", statistic = max(eig_mod),
  p_value = NA_real_, cval_5pct = 1.0,
  verdict = ifelse(max(eig_mod) <= 1.001, "STABLE", "UNSTABLE"),
  stringsAsFactors = FALSE
)

# Johansen trace
for (i in seq_along(jo@teststat)) {
  r_null <- M_DIM - i
  diag_rows[[length(diag_rows) + 1]] <- data.frame(
    test = paste0("trace_r", r_null),
    statistic = jo@teststat[i],
    p_value = NA_real_,
    cval_5pct = jo@cval[i, "5pct"],
    verdict = ifelse(jo@teststat[i] > jo@cval[i, "5pct"], "REJECT", "FAIL_TO_REJECT"),
    stringsAsFactors = FALSE
  )
}

focal_diag <- bind_rows(diag_rows)
safe_write_csv(focal_diag, file.path(CSV_DIR, "focal_diagnostics.csv"))
cat("\nDiagnostics summary:\n")
print(focal_diag, row.names = FALSE)


# ============================================================
# BLOCK 6: CU PATH (RAW COINTEGRATING RESIDUAL)
# ============================================================

cat("\n===== BLOCK 6: CU PATH =====\n")

# Raw cointegrating residual: beta'X_t = lnY - theta*lnK - beta_e*lnE
# NO normalization at u = 1
beta_X <- as.numeric(X3 %*% beta_norm)

focal_cu <- data.frame(
  year   = df$year,
  lnY    = df$lnY,
  lnK    = df$lnK,
  lnE    = df$e,
  beta_X = beta_X
)

# Optionally load S1 ARDL residual for comparison
s1_path <- here::here("output", "S1_geometry", "csv", "S1_frontier_u_band.csv")
if (file.exists(s1_path)) {
  s1_band <- read_csv(s1_path, show_col_types = FALSE)
  # S1 u_med is exp(residual - mean(residual)); invert to get raw residual
  # But S1 stores utilization rates, not raw residuals. Log and de-mean
  # to approximate the cointegrating residual scale.
  focal_cu$s1_u_med <- s1_band$u_med[match(focal_cu$year, s1_band$year)]
  cat("S1 ARDL residual loaded for overlay\n")
} else {
  cat("S1 ARDL residual not found — skipping overlay\n")
}

# FRB CU for optional overlay
if (!is.null(u_frb) && any(!is.na(u_frb))) {
  focal_cu$u_frb <- u_frb
  cat("FRB CU loaded for overlay\n")
}

safe_write_csv(focal_cu, file.path(CSV_DIR, "focal_cu_path.csv"))
cat(sprintf("CU path: mean(beta_X) = %.4f, sd = %.4f\n", mean(beta_X), sd(beta_X)))
cat(sprintf("         range: [%.4f, %.4f]\n", min(beta_X), max(beta_X)))


# ============================================================
# BLOCK 7: FIGURE — CU PATH
# ============================================================

cat("\n===== BLOCK 7: FIGURE — CU PATH =====\n")

fig_cu <- ggplot(focal_cu, aes(x = year, y = beta_X)) +
  geom_hline(yintercept = 0, color = "grey60", linewidth = 0.3) +
  geom_vline(xintercept = DUMMY_YEARS, linetype = "dashed",
             color = "grey50", linewidth = 0.4) +
  geom_line(color = PAL_OI["blue"], linewidth = 0.7) +
  annotate("text", x = DUMMY_YEARS, y = rep(max(beta_X) * 0.95, 3),
           label = as.character(DUMMY_YEARS), size = 2.5, color = "grey50",
           hjust = -0.1) +
  labs(x = NULL,
       y = expression(hat(beta)*"'"*X[t]),
       title = expression("Cointegrating residual: focal spec (2, "*d[2]*", "*h[2]*", r=1)")) +
  theme_ch3()

save_png_pdf_dual(fig_cu, "fig_S2_focal_cu_path", FIG_DIR, width = 7, height = 4)
cat("Saved fig_S2_focal_cu_path\n")


# ============================================================
# BLOCK 8: FIGURE — COMPANION EIGENVALUES
# ============================================================

cat("\n===== BLOCK 8: FIGURE — COMPANION EIGENVALUES =====\n")

eig_df <- data.frame(
  re = Re(eig_all$values),
  im = Im(eig_all$values)
)

theta_seq <- seq(0, 2 * pi, length.out = 200)
circle_df <- data.frame(x = cos(theta_seq), y = sin(theta_seq))

fig_comp <- ggplot() +
  geom_path(data = circle_df, aes(x = x, y = y),
            color = "grey70", linewidth = 0.3) +
  geom_hline(yintercept = 0, color = "grey85", linewidth = 0.2) +
  geom_vline(xintercept = 0, color = "grey85", linewidth = 0.2) +
  geom_point(data = eig_df, aes(x = re, y = im),
             color = PAL_OI["blue"], size = 3, alpha = 0.8) +
  coord_fixed(xlim = c(-1.15, 1.15), ylim = c(-1.15, 1.15)) +
  labs(x = "Real", y = "Imaginary",
       title = expression("Companion eigenvalues: (2, "*d[2]*", "*h[2]*", r=1)")) +
  theme_ch3()

save_png_pdf_dual(fig_comp, "fig_S2_focal_companion", FIG_DIR, width = 5, height = 5)
cat("Saved fig_S2_focal_companion\n")


# ============================================================
# BLOCK 9: SUMMARY AND VERIFICATION
# ============================================================

cat("\n===== BLOCK 9: VERIFICATION =====\n")
cat(sprintf("theta_hat = %.4f  (target: 0.727)\n", theta_hat))
cat(sprintf("alpha_y   = %.4f  (target: -0.005)\n", alpha_y))
cat(sprintf("alpha_k   = %.4f  (target:  0.000)\n", alpha_k))
cat(sprintf("alpha_e   = %.4f  (target: -0.019)\n", alpha_e))
cat(sprintf("T_eff     = %d\n", nrow(residuals(vecm_fit))))
cat(sprintf("k_total   = %d\n", length(unlist(coef(vecm_fit)))))
cat(sprintf("-2 log L  = %.1f\n", -2 * as.numeric(logLik(vecm_fit))))

cat("\n--- Output manifest ---\n")
all_files <- list.files(FOCAL_DIR, recursive = TRUE)
for (f in all_files) cat("  ", f, "\n")

cat("\n=== DONE ===\n")
