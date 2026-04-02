# ============================================================
# _build_s2_rds.R
# Packages the S2 focal trivariate VECM into s2_results.rds
# for consumption by S3 (27_S3_regime_break.R).
#
# This script RE-ESTIMATES the S2 focal specification to ensure
# the .rds contains a complete, self-consistent parameter set.
# It does NOT just copy numbers from a CSV — the VECM object
# is needed for residuals, Gamma matrices, and companion roots.
#
# IDENTIFICATION CHAIN (traced from 27_S2_vecm_focal_p2d2h2.R):
#
#   System:       X_t = (lnY, lnK, ln e)'  (trivariate)
#   Rank:         r = 1  (one cointegrating relation)
#   VAR order:    p = 2  →  VECM lag = p - 1 = 1
#   Deterministic: d2 = unrestricted SR constant
#                  (include="const", LRinclude="none")
#   Exogenous:    h2 = step dummies at 1956, 1974, 1980
#   Sample:       1947-2011 (shaikh_window, T = 65)
#   Estimation:   Johansen ML via tsDyn::VECM()
#
# NORMALIZATION:
#   tsDyn normalizes beta on the first variable (lnY):
#     coefB() = (1, beta_k, beta_e)'
#   The cointegrating relation is:
#     lnY + beta_k * lnK + beta_e * ln(e) ~ I(0)
#   Since beta_k < 0 (= -0.727), this reads:
#     lnY - 0.727 * lnK + 20.022 * ln(e) ~ I(0)
#   The output-capital elasticity theta = -beta_k = 0.727.
#
# THETA IDENTIFICATION:
#   theta = 0.727 < 1 (overaccumulation).
#   BUT: SE(theta) = 4.85, t = -0.15. Theta is NOT precisely
#   identified in the trivariate system because beta_e = 20.022
#   (t = 7.90***) carries 99.1% of the cointegrating residual
#   variance. The data identify the exploitation rate loading
#   with high precision; theta is a secondary, imprecise feature.
#   This is the key S2 finding: the bilateral Y-K relation is
#   a projection of a trilateral Y-K-e manifold dominated by
#   distributional dynamics.
#
# WHAT S3 NEEDS FROM THIS:
#   1. theta = 0.727      → H0 restriction in JMN augmented VECM
#   2. lag = 1             → inherited VECM lag for S3 estimation
#   3. residuals (63 x 3) → Bai-Perron break detection
#   4. alpha, Gamma, beta  → structural interpretation in report
#   5. data (year, lnY, lnK, e) → S3 subsets to 1947-2007
#   6. companion eigenvalues → stability verification
#   7. dummy_years         → context for S3 deterministic setup
#
# DISCREPANCY NOTE:
#   S2 uses dummies (h2) as exogen. This .rds includes those
#   dummies in the estimation, so the residuals are conditional
#   on the regime shifts. S3's JMN test adds k* = D74*k as a
#   NEW variable in the cointegrating vector — this is distinct
#   from the 1974 dummy in S2, which enters as an exogenous
#   level shift in the short-run dynamics.
# ============================================================

suppressPackageStartupMessages({
  library(here); library(tsDyn); library(readr)
})
source(here("codes", "10_config.R"))
source(here("codes", "99_utils.R"))

cat("=== Building s2_results.rds from S2 focal trivariate ===\n\n")

# ============================================================
# 1. DATA CONSTRUCTION (mirrors 27_S2_vecm_focal_p2d2h2.R exactly)
# ============================================================

df_raw  <- read_csv(here(CONFIG$data_shaikh), show_col_types = FALSE)
Py      <- as.numeric(df_raw[[CONFIG$p_index]])
p_scale <- Py / 100

df0 <- data.frame(
  year  = as.integer(df_raw[[CONFIG$year_col]]),
  Y_nom = as.numeric(df_raw[[CONFIG$y_nom]]),
  K_nom = as.numeric(df_raw[[CONFIG$k_nom]]),
  e_raw = as.numeric(df_raw[[CONFIG$e_rate]])
)
df0 <- df0[complete.cases(df0) & df0$year > 0, ]
# Deflation: identical indexing to S2 focal script
df0$lnY <- log(df0$Y_nom / p_scale[match(df0$year, as.integer(df_raw[[CONFIG$year_col]]))])
df0$lnK <- log(df0$K_nom / p_scale[match(df0$year, as.integer(df_raw[[CONFIG$year_col]]))])
df0$e   <- log(df0$e_raw)

# Step dummies (h2)
DUMMY_YEARS <- c(1956L, 1974L, 1980L)
for (yy in DUMMY_YEARS) df0[[paste0("d", yy)]] <- as.integer(df0$year >= yy)

# Sample window
w  <- CONFIG$WINDOWS_LOCKED[["shaikh_window"]]
df <- df0[df0$year >= w[1] & df0$year <= w[2], ]
df <- df[order(df$year), ]
df <- df[is.finite(df$e), ]
T_obs <- nrow(df)

cat(sprintf("Sample: %d-%d (T = %d)\n", min(df$year), max(df$year), T_obs))

# State matrix and dummy matrix
X3      <- as.matrix(df[, c("lnY", "lnK", "e")])
dum_mat <- as.matrix(df[, c("d1956", "d1974", "d1980")])


# ============================================================
# 2. ESTIMATE FOCAL VECM
# ============================================================

# VAR order p=2, VECM lag = p-1 = 1
# d2: include="const" (unrestricted SR), LRinclude="none" (no LR constant)
# h2: exogen = step dummies at 1956, 1974, 1980
P_VAR    <- 2L
VECM_LAG <- 1L

vecm_fit <- VECM(X3, lag = VECM_LAG, r = 1, estim = "ML",
                  include = "const", LRinclude = "none",
                  exogen = dum_mat)


# ============================================================
# 3. EXTRACT AND VERIFY PARAMETERS
# ============================================================

beta_hat  <- as.matrix(coefB(vecm_fit))
alpha_hat <- as.matrix(coefA(vecm_fit))

# Sign convention: coefB() returns (1, beta_k, beta_e)
# theta = -beta_k, so theta = -coefB()[2,1]
theta_hat <- -beta_hat[2, 1]
beta_e    <- beta_hat[3, 1]

cat("\n--- Cointegrating vector (beta) ---\n")
cat(sprintf("  beta = (%.4f, %.4f, %.4f)\n",
            beta_hat[1,1], beta_hat[2,1], beta_hat[3,1]))
cat(sprintf("  => lnY - %.4f*lnK + %.4f*ln(e) ~ I(0)\n", theta_hat, beta_e))
cat(sprintf("  theta = %.4f (overaccumulation: theta < 1)\n", theta_hat))

cat("\n--- Adjustment coefficients (alpha) ---\n")
cat(sprintf("  alpha_y = %.5f (output adjusts weakly)\n", alpha_hat[1,1]))
cat(sprintf("  alpha_k = %.5f (capital weakly exogenous)\n", alpha_hat[2,1]))
cat(sprintf("  alpha_e = %.5f (exploitation rate: primary adjustment)\n", alpha_hat[3,1]))

# Verify against S2 focal CSV targets
cat("\n--- Verification against S2 focal targets ---\n")
cat(sprintf("  theta:   %.4f vs 0.7267 -> %s\n", theta_hat,
            if (abs(theta_hat - 0.7267) < 0.001) "MATCH" else "MISMATCH"))
cat(sprintf("  beta_e:  %.3f vs 20.022 -> %s\n", beta_e,
            if (abs(beta_e - 20.022) < 0.01) "MATCH" else "MISMATCH"))
cat(sprintf("  alpha_y: %.5f vs -0.00466 -> %s\n", alpha_hat[1,1],
            if (abs(alpha_hat[1,1] - (-0.00466)) < 0.0001) "MATCH" else "MISMATCH"))

# Companion eigenvalues (stability check)
var_coefs <- VARrep(vecm_fit)
lag_cols  <- grep("\\.l[0-9]+$", colnames(var_coefs))
A_lag     <- var_coefs[, lag_cols, drop = FALSE]
m <- 3L; p_var_eff <- ncol(A_lag) / m
if (p_var_eff == 1) {
  eig_mod <- Mod(eigen(A_lag)$values)
} else {
  n_comp <- m * p_var_eff
  C_comp <- matrix(0, n_comp, n_comp)
  C_comp[1:m, ] <- A_lag
  C_comp[(m+1):n_comp, 1:(m*(p_var_eff-1))] <- diag(m*(p_var_eff-1))
  eig_mod <- Mod(eigen(C_comp)$values)
}
cat(sprintf("\nCompanion eigenvalue moduli: %s\n",
            paste(sprintf("%.4f", sort(eig_mod, decreasing = TRUE)), collapse = ", ")))
cat(sprintf("Unit roots: %d (expect m-r = %d)\n",
            sum(eig_mod > 0.999), m - 1))

# Residuals
resid_mat <- residuals(vecm_fit)
cat(sprintf("\nResiduals: %d x %d (T_eff x m)\n",
            nrow(resid_mat), ncol(resid_mat)))


# ============================================================
# 4. PACKAGE INTO s2_results LIST
# ============================================================

s2 <- list(
  # --- Specification ---
  lag         = VECM_LAG,       # VECM lag (= VAR order - 1)
  p_var       = P_VAR,          # VAR order (for reference)
  rank        = 1L,             # cointegrating rank
  include     = "const",        # d2: unrestricted SR constant
  LRinclude   = "none",         # d2: no restricted LR constant
  m           = 3L,             # system dimension
  var_names   = c("lnY", "lnK", "e"),
  dummy_years = DUMMY_YEARS,    # h2: exogenous step dummies

  # --- Cointegrating vector ---
  # beta = (1, -theta, beta_e) normalized on lnY
  beta        = as.numeric(beta_hat[, 1]),   # raw coefB() output
  theta       = theta_hat,                   # = -beta[2]
  beta_e      = beta_e,                      # = beta[3]

  # --- Adjustment coefficients ---
  alpha       = as.numeric(alpha_hat[, 1]),  # (alpha_y, alpha_k, alpha_e)

  # --- Residuals ---
  resid       = resid_mat,      # T_eff x 3 matrix

  # --- Full data (S3 subsets to 1947-2007) ---
  data        = df[, c("year", "lnY", "lnK", "e")],

  # --- Companion eigenvalues ---
  companion_eigenmod = sort(eig_mod, decreasing = TRUE),

  # --- Metadata ---
  sample_window = as.integer(w),
  T_obs         = T_obs,
  spec_label    = "p2_d2_h2_r1",
  source_script = "codes/27_S2_vecm_focal_p2d2h2.R"
)

out_path <- here("output/S2_vecm/s2_results.rds")
saveRDS(s2, out_path)

cat("\n=== SAVED:", out_path, "===\n")
cat(sprintf("  spec:    %s | lag=%d (p=%d) | r=%d | m=%d\n",
            s2$spec_label, s2$lag, s2$p_var, s2$rank, s2$m))
cat(sprintf("  beta:    (1, %.4f, %.4f)\n", s2$beta[2], s2$beta[3]))
cat(sprintf("  theta:   %.4f | beta_e: %.3f\n", s2$theta, s2$beta_e))
cat(sprintf("  alpha:   (%.5f, %.5f, %.5f)\n",
            s2$alpha[1], s2$alpha[2], s2$alpha[3]))
cat(sprintf("  resid:   %dx%d | data: %dx%d\n",
            nrow(s2$resid), ncol(s2$resid),
            nrow(s2$data), ncol(s2$data)))
cat(sprintf("  sample:  %d-%d (T=%d)\n",
            s2$sample_window[1], s2$sample_window[2], s2$T_obs))
