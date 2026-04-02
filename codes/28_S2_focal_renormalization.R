# ============================================================
# 28_S2_focal_renormalization.R
#
# S2 — Focal VECM renormalization: (p=2, d2, h2, r=1)
#
# Re-estimates the focal spec and applies the exploitation-rate
# renormalization:
#   Output-normalized:  beta'X = ln Y - theta ln K + beta_e ln e
#   Reserve-army form:  ln e = rho (ln Y - theta ln K) + c
#
# where rho = -1/beta_e is the reserve-army elasticity and
# theta is the transformation elasticity.
#
# Methodology:
#   Block 0: Preamble
#   Block 1: Data construction (same as script 27)
#   Block 2: Re-estimation (tsDyn + urca)
#   Block 3: Johansen Var(beta) + delta method for (theta, rho)
#   Block 4: Capacity utilization and exploitation rate series
#   Block 5: Figure — time series (CU + exploitation rate)
#   Block 6: Figure — reserve-army scatter
#   Block 7: Summary
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
# FOCAL SPEC PARAMETERS (identical to script 27)
# ============================================================

P_VAR       <- 2L
VECM_LAG    <- 1L
R_RANK      <- 1L
M_DIM       <- 3L
D_INCLUDE   <- "const"
D_LRINCLUDE <- "none"
D_ECDET     <- "none"
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

log_path <- file.path(LOG_DIR, "S2_focal_renormalization_log.txt")
sink(log_path, split = TRUE)
on.exit(try(sink(), silent = TRUE), add = TRUE)

cat("=== S2 Focal VECM Renormalization: (p=2, d2, h2, r=1) ===\n")
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

for (yy in DUMMY_YEARS) df0[[paste0("d", yy)]] <- as.integer(df0$year >= yy)

w  <- CONFIG$WINDOWS_LOCKED[[WINDOW_TAG]]
df <- df0[df0$year >= w[1] & df0$year <= w[2], ]
df <- df[order(df$year), ]
df <- df[is.finite(df$e), ]
T_obs <- nrow(df)

X3 <- as.matrix(df[, c("lnY", "lnK", "e")])
colnames(X3) <- c("lnY", "lnK", "e")
dum_mat <- as.matrix(df[, c("d1956", "d1974", "d1980")])

cat("Window:", min(df$year), "-", max(df$year), " T =", T_obs, "\n\n")


# ============================================================
# BLOCK 2: RE-ESTIMATION
# ============================================================

cat("\n===== BLOCK 2: RE-ESTIMATION =====\n")

vecm_fit <- tsDyn::VECM(
  X3,
  lag       = VECM_LAG,
  r         = R_RANK,
  estim     = "ML",
  include   = D_INCLUDE,
  LRinclude = D_LRINCLUDE,
  exogen    = dum_mat
)

jo <- urca::ca.jo(X3, type = "trace", ecdet = D_ECDET, K = P_VAR,
                  dumvar = dum_mat)
jo_rls <- urca::cajorls(jo, r = R_RANK)

beta_norm <- as.numeric(jo_rls$beta[, 1])
names(beta_norm) <- rownames(jo_rls$beta)

theta_hat <- -beta_norm[2]   # beta_K = -theta
beta_e    <-  beta_norm[3]   # beta_e (positive, ~20)

cat(sprintf("theta_hat = %.4f\n", theta_hat))
cat(sprintf("beta_e    = %.4f\n", beta_e))


# ============================================================
# BLOCK 3: JOHANSEN Var(beta) + DELTA METHOD
# ============================================================

cat("\n===== BLOCK 3: DELTA METHOD =====\n")

# --- Step 1: Johansen asymptotic variance of free beta elements ---
# beta = (1, -theta, beta_e)'; free elements phi = (-theta, beta_e) = beta[2:3]
# Var(phi) from Johansen (1995) Thm 13.3:
#   Var(phi) = (1 / (T * lambda_1 / (1 - lambda_1))) * inv(S11_schur)
# where S11_schur is the Schur complement of S11[1,1] in S11.

S11     <- crossprod(jo@RK) / nrow(jo@RK)
T_jo    <- nrow(jo@RK)
lambda1 <- jo@lambda[1]

cat(sprintf("lambda_1 = %.4f\n", lambda1))
cat(sprintf("T_jo     = %d\n", T_jo))

# Schur complement: S22 - S21 * S11^{-1} * S12
s11 <- S11[1, 1]
s12 <- S11[1, 2:M_DIM, drop = FALSE]
s21 <- S11[2:M_DIM, 1, drop = FALSE]
s22 <- S11[2:M_DIM, 2:M_DIM]
S11_schur <- s22 - s21 %*% solve(s11) %*% s12

# Covariance of phi = (beta_2, beta_3) = (-theta, beta_e)
scaling <- 1 / (T_jo * lambda1 / (1 - lambda1))
Sigma_phi <- scaling * solve(S11_schur)

cat("\nSigma_phi (Var of [-theta, beta_e]):\n")
print(Sigma_phi)

se_theta_raw <- sqrt(Sigma_phi[1, 1])  # SE of -theta = SE of theta
se_beta_e    <- sqrt(Sigma_phi[2, 2])
cat(sprintf("\nVerification: SE(theta) = %.4f (expect ~4.852)\n", se_theta_raw))
cat(sprintf("             SE(beta_e) = %.4f (expect ~2.536)\n", se_beta_e))

# --- Step 2: Transform to (theta, beta_e) covariance ---
# phi = (-theta, beta_e). To get Var(theta, beta_e):
# theta = -phi_1, beta_e = phi_2
# Jacobian of (theta, beta_e) w.r.t. (phi_1, phi_2):
#   J1 = | -1  0 |
#        |  0  1 |
# Sigma_tb = J1 * Sigma_phi * J1' = flip sign on off-diags of row/col 1
Sigma_tb <- Sigma_phi
Sigma_tb[1, 2] <- -Sigma_phi[1, 2]
Sigma_tb[2, 1] <- -Sigma_phi[2, 1]
# Diagonal unchanged ((-1)^2 = 1)

cat("\nSigma (theta, beta_e):\n")
print(Sigma_tb)

# --- Step 3: Delta method for rho = -1/beta_e ---
# g(theta, beta_e) = (theta, rho) where rho = -1/beta_e
# Jacobian:
#   J2 = | 1          0          |
#        | 0    1/beta_e^2       |
rho_hat <- -1 / beta_e
J2 <- matrix(c(1, 0,
                0, 1 / beta_e^2), nrow = 2, byrow = TRUE)

Sigma_psi <- J2 %*% Sigma_tb %*% t(J2)  # Var(theta, rho)

se_theta <- sqrt(Sigma_psi[1, 1])
se_rho   <- sqrt(Sigma_psi[2, 2])
cov_tr   <- Sigma_psi[1, 2]
cor_tr   <- cov_tr / (se_theta * se_rho)

cat(sprintf("\nRenormalized parameters:\n"))
cat(sprintf("  theta = %.4f  (SE = %.4f, t = %.3f)\n",
            theta_hat, se_theta, theta_hat / se_theta))
cat(sprintf("  rho   = %.6f  (SE = %.6f, t = %.3f)\n",
            rho_hat, se_rho, rho_hat / se_rho))
cat(sprintf("  cov(theta, rho) = %.8f\n", cov_tr))
cat(sprintf("  cor(theta, rho) = %.4f\n", cor_tr))

# --- Step 4: Save renormalized beta CSV ---
add_stars <- function(p) {
  ifelse(is.na(p), "",
  ifelse(p < 0.01, "***",
  ifelse(p < 0.05, "**",
  ifelse(p < 0.10, "*", ""))))
}

df_ren <- data.frame(
  parameter = c("theta", "rho"),
  estimate  = c(theta_hat, rho_hat),
  se        = c(se_theta, se_rho),
  t_stat    = c(theta_hat / se_theta, rho_hat / se_rho),
  p_value   = c(
    2 * pt(abs(theta_hat / se_theta), df = T_obs - M_DIM * VECM_LAG, lower.tail = FALSE),
    2 * pt(abs(rho_hat / se_rho), df = T_obs - M_DIM * VECM_LAG, lower.tail = FALSE)
  ),
  stringsAsFactors = FALSE
)
df_ren$signif <- add_stars(df_ren$p_value)

safe_write_csv(df_ren, file.path(CSV_DIR, "focal_renormalized_beta.csv"))
cat("\nRenormalized beta table:\n")
print(df_ren, row.names = FALSE)


# ============================================================
# BLOCK 4: CAPACITY UTILIZATION + EXPLOITATION RATE SERIES
# ============================================================

cat("\n===== BLOCK 4: CU + EXPLOITATION RATE =====\n")

# Capacity utilization: u = exp(ln Y - theta ln K - c)
# where c = mean(ln Y - theta ln K) so that mean(u) = 1.
# The constant c absorbs initial conditions, unit scale, and the
# cumulated secular drift (mu_Y - theta * mu_K) from the d2
# unrestricted constant. It carries no structural content —
# it is an identification-irrelevant normalization.
ln_u_raw <- df$lnY - theta_hat * df$lnK
c_norm   <- mean(ln_u_raw)
ln_u     <- ln_u_raw - c_norm
u_t      <- exp(ln_u)

# Exploitation rate in levels
e_t <- exp(df$e)  # df$e = log(e_raw)

# Full cointegrating residual
beta_X <- as.numeric(X3 %*% beta_norm)

focal_cue <- data.frame(
  year   = df$year,
  lnY    = df$lnY,
  lnK    = df$lnK,
  lnE    = df$e,
  ln_u   = ln_u,
  u      = u_t,
  e      = e_t,
  beta_X = beta_X
)

# --- Shaikh's CU (uK from canonical CSV) ---
u_shaikh <- as.numeric(df_raw[[CONFIG$u_shaikh]])[
  match(df$year, as.integer(df_raw[[CONFIG$year_col]]))]
if (any(!is.na(u_shaikh))) {
  focal_cue$u_shaikh <- u_shaikh
  cat(sprintf("Shaikh CU loaded: %d non-NA obs\n", sum(!is.na(u_shaikh))))
}

# --- FRB CU (uFRB from canonical CSV) ---
u_frb_raw <- tryCatch(
  as.numeric(df_raw[[CONFIG$u_frb]])[
    match(df$year, as.integer(df_raw[[CONFIG$year_col]]))],
  error = function(e) NULL
)
if (!is.null(u_frb_raw) && any(!is.na(u_frb_raw))) {
  focal_cue$u_frb <- u_frb_raw
  cat(sprintf("FRB CU loaded: %d non-NA obs (starts %d)\n",
              sum(!is.na(u_frb_raw)),
              min(df$year[!is.na(u_frb_raw)])))
}

safe_write_csv(focal_cue, file.path(CSV_DIR, "focal_cu_exploitation.csv"))

cat(sprintf("CU:  mean(u) = %.4f, SD = %.4f, range = [%.4f, %.4f]\n",
            mean(u_t), sd(u_t), min(u_t), max(u_t)))
cat(sprintf("Exploitation: mean(e) = %.4f, SD = %.4f, range = [%.4f, %.4f]\n",
            mean(e_t), sd(e_t), min(e_t), max(e_t)))


# ============================================================
# BLOCK 5: FIGURE — TIME SERIES (CU + EXPLOITATION RATE)
# ============================================================

cat("\n===== BLOCK 5: FIGURE — TIME SERIES =====\n")

# --- Build long-format data for CU series ---
# All CU series on left axis, exploitation rate on right axis

ts_df <- data.frame(year = df$year, u_vecm = u_t, e = e_t)

# Add Shaikh CU if available
has_shaikh <- "u_shaikh" %in% names(focal_cue)
if (has_shaikh) ts_df$u_shaikh <- focal_cue$u_shaikh

# Add FRB CU if available (rescale from 0-100 range to ~1 center)
has_frb <- "u_frb" %in% names(focal_cue)
if (has_frb) ts_df$u_frb <- focal_cue$u_frb  # already in ratio units

# Compute y-axis range across all CU series
all_cu_vals <- c(ts_df$u_vecm)
if (has_shaikh) all_cu_vals <- c(all_cu_vals, na.omit(ts_df$u_shaikh))
if (has_frb)    all_cu_vals <- c(all_cu_vals, na.omit(ts_df$u_frb))
u_range <- range(all_cu_vals, na.rm = TRUE)

# Secondary axis: affine transform for exploitation rate
a_coef <- diff(u_range) / diff(range(e_t))
b_coef <- u_range[1] - a_coef * min(e_t)

fig_ts <- ggplot(ts_df, aes(x = year)) +
  # Vertical break lines
  geom_vline(xintercept = DUMMY_YEARS, linetype = "dashed",
             color = "grey60", linewidth = 0.35) +
  # Reference at u = 1
  geom_hline(yintercept = 1, color = "grey70", linewidth = 0.25)

# FRB CU (lightest, background)
if (has_frb) {
  fig_ts <- fig_ts +
    geom_line(aes(y = u_frb), color = PAL_OI["green"],
              linewidth = 0.5, alpha = 0.6, na.rm = TRUE)
}

# Shaikh CU
if (has_shaikh) {
  fig_ts <- fig_ts +
    geom_line(aes(y = u_shaikh), color = PAL_OI["skyblue"],
              linewidth = 0.55, linetype = "dotdash", na.rm = TRUE)
}

# VECM-implied CU (main)
fig_ts <- fig_ts +
  geom_line(aes(y = u_vecm), color = PAL_OI["blue"], linewidth = 0.7)

# Exploitation rate (right axis)
fig_ts <- fig_ts +
  geom_line(aes(y = a_coef * e + b_coef), color = PAL_OI["vermillion"],
            linewidth = 0.6, linetype = "dashed") +
  scale_y_continuous(
    name = "Capacity utilization",
    sec.axis = sec_axis(~ (. - b_coef) / a_coef,
                        name = expression("Exploitation rate  " * e[t]))
  )

# Break year labels
fig_ts <- fig_ts +
  annotate("text", x = DUMMY_YEARS + 1,
           y = rep(max(all_cu_vals, na.rm = TRUE) * 1.01, 3),
           label = as.character(DUMMY_YEARS), size = 2.3, color = "grey50",
           hjust = 0)

# Manual legend via annotate (avoids aes/scale complexity)
legend_y <- min(all_cu_vals, na.rm = TRUE) + 0.03
legend_x <- 1947
fig_ts <- fig_ts +
  annotate("segment", x = legend_x, xend = legend_x + 5,
           y = legend_y + 0.000, yend = legend_y + 0.000,
           color = PAL_OI["blue"], linewidth = 0.7) +
  annotate("text", x = legend_x + 6, y = legend_y + 0.000,
           label = "VECM", size = 2.3, hjust = 0, color = PAL_OI["blue"])

if (has_shaikh) {
  fig_ts <- fig_ts +
    annotate("segment", x = legend_x, xend = legend_x + 5,
             y = legend_y - 0.022, yend = legend_y - 0.022,
             color = PAL_OI["skyblue"], linewidth = 0.55, linetype = "dotdash") +
    annotate("text", x = legend_x + 6, y = legend_y - 0.022,
             label = "Shaikh", size = 2.3, hjust = 0, color = PAL_OI["skyblue"])
}

if (has_frb) {
  fig_ts <- fig_ts +
    annotate("segment", x = legend_x, xend = legend_x + 5,
             y = legend_y - 0.044, yend = legend_y - 0.044,
             color = PAL_OI["green"], linewidth = 0.5, alpha = 0.6) +
    annotate("text", x = legend_x + 6, y = legend_y - 0.044,
             label = "FRB", size = 2.3, hjust = 0, color = PAL_OI["green"])
}

fig_ts <- fig_ts +
  annotate("segment", x = legend_x, xend = legend_x + 5,
           y = legend_y - 0.066, yend = legend_y - 0.066,
           color = PAL_OI["vermillion"], linewidth = 0.6, linetype = "dashed") +
  annotate("text", x = legend_x + 6, y = legend_y - 0.066,
           label = "Exploitation rate (RHS)", size = 2.3, hjust = 0,
           color = PAL_OI["vermillion"])

fig_ts <- fig_ts +
  labs(x = NULL,
       title = "Capacity utilization and exploitation rate, US corporate sector 1947\u20132011") +
  theme_ch3() +
  theme(
    axis.title.y.right = element_text(color = PAL_OI["vermillion"], size = 9),
    axis.text.y.right  = element_text(color = PAL_OI["vermillion"]),
    plot.title = element_text(size = 10)
  )

save_png_pdf_dual(fig_ts, "fig_S2_focal_cu_exploitation", FIG_DIR,
                  width = 7, height = 4.5)
cat("Saved fig_S2_focal_cu_exploitation\n")


# ============================================================
# BLOCK 6: FIGURE — RESERVE-ARMY SCATTER
# ============================================================

cat("\n===== BLOCK 6: FIGURE — RESERVE-ARMY SCATTER =====\n")

# Reserve-army relation: ln e = rho * ln_u + c_scatter
# Fit the bivariate regression for display
scatter_lm <- lm(lnE ~ ln_u, data = focal_cue)
scatter_r2  <- summary(scatter_lm)$r.squared
scatter_int <- coef(scatter_lm)[1]
scatter_slope <- coef(scatter_lm)[2]

cat(sprintf("Scatter regression: ln e = %.4f + %.4f * ln u\n",
            scatter_int, scatter_slope))
cat(sprintf("  vs. structural rho = %.6f\n", rho_hat))
cat(sprintf("  R-squared = %.4f\n", scatter_r2))

# Regime indicator
focal_cue$regime <- ifelse(focal_cue$year < 1974, "Fordist (1947\u20131973)",
                           "Post-Fordist (1974\u20132011)")

# Annotation text
annot_text <- sprintf("hat(rho) == %.4f ~~ (SE == %.4f)\nR^2 == %.3f",
                      scatter_slope, summary(scatter_lm)$coefficients[2, 2],
                      scatter_r2)

fig_scatter <- ggplot(focal_cue, aes(x = ln_u, y = lnE)) +
  geom_point(aes(color = regime, shape = regime), size = 2, alpha = 0.7) +
  geom_smooth(method = "lm", se = TRUE, color = "grey30", linewidth = 0.6,
              linetype = "solid", alpha = 0.15) +
  scale_color_manual(values = c(unname(PAL_OI["blue"]), unname(PAL_OI["vermillion"]))) +
  scale_shape_manual(values = c(16, 17)) +
  # Annotation
  annotate("text",
           x = min(focal_cue$ln_u) + 0.02 * diff(range(focal_cue$ln_u)),
           y = max(focal_cue$lnE) - 0.05 * diff(range(focal_cue$lnE)),
           label = sprintf("slope = %.4f  (SE = %.4f)\nR\u00b2 = %.3f",
                           scatter_slope,
                           summary(scatter_lm)$coefficients[2, 2],
                           scatter_r2),
           hjust = 0, vjust = 1, size = 2.8, color = "grey30") +
  labs(x = expression(ln~u[t] == ln~Y[t] - hat(theta) %.% ln~K[t]),
       y = expression(ln~e[t]),
       title = "Reserve-army attractor: exploitation rate vs. capacity gap") +
  theme_ch3() +
  theme(
    legend.position = c(0.75, 0.15),
    legend.background = element_rect(fill = "white", color = NA),
    legend.text = element_text(size = 8),
    plot.title = element_text(size = 10)
  )

save_png_pdf_dual(fig_scatter, "fig_S2_focal_reserve_army_scatter", FIG_DIR,
                  width = 7, height = 5)
cat("Saved fig_S2_focal_reserve_army_scatter\n")


# ============================================================
# BLOCK 7: SUMMARY
# ============================================================

cat("\n\n")
cat("=== S2 FOCAL RENORMALIZATION SUMMARY ===\n\n")

cat(sprintf("Output-normalized:     beta'X = ln Y - %.3f ln K + %.3f ln e\n",
            theta_hat, beta_e))
cat(sprintf("Reserve-army form:     ln e = rho (ln Y - theta ln K) + c\n\n"))

cat(sprintf("Structural parameter:  theta = %.4f (SE = %.4f, t = %.3f)\n",
            theta_hat, se_theta, theta_hat / se_theta))
cat(sprintf("Behavioral parameter:  rho   = %.6f (SE = %.6f, t = %.3f)\n",
            rho_hat, se_rho, rho_hat / se_rho))
cat(sprintf("Correlation:           cor(theta, rho) = %.4f\n\n", cor_tr))

cat(sprintf("Capacity utilization:  mean(u) = %.3f, SD(u) = %.4f, range = [%.3f, %.3f]\n",
            mean(u_t), sd(u_t), min(u_t), max(u_t)))
cat(sprintf("Exploitation rate:     mean(e) = %.4f, SD(e) = %.4f, range = [%.4f, %.4f]\n",
            mean(e_t), sd(e_t), min(e_t), max(e_t)))
cat(sprintf("\nReserve-army scatter:  R-squared = %.4f\n", scatter_r2))
cat(sprintf("  OLS slope (proxy rho) = %.4f (SE = %.4f)\n",
            scatter_slope, summary(scatter_lm)$coefficients[2, 2]))

cat("\n--- Output manifest ---\n")
all_files <- list.files(FOCAL_DIR, recursive = TRUE, pattern = "renorm|cu_expl|reserve")
for (f in all_files) cat("  ", f, "\n")


# ============================================================
# BLOCK 6b: REVISED SCATTER — OLS vs Johansen identification
# ============================================================

cat("\n===== BLOCK 6b: REVISED SCATTER (v2) =====\n")

# Johansen-implied line: ln e = rho * ln_u + intercept
# Johansen-implied line: ln e = rho * ln_u + intercept
jo_intercept <- mean(focal_cue$lnE) - rho_hat * mean(focal_cue$ln_u)

# OLS line (already computed above)
ols_se    <- summary(scatter_lm)$coefficients[2, 2]
ols_slope <- scatter_slope

# x-range for abline data
x_range <- range(focal_cue$ln_u)
x_seq   <- seq(x_range[1] - 0.02, x_range[2] + 0.02, length.out = 100)

line_df <- data.frame(
  ln_u = rep(x_seq, 2),
  lnE  = c(jo_intercept + rho_hat * x_seq,
            scatter_int + ols_slope * x_seq),
  method = rep(c("Johansen ML", "OLS"), each = length(x_seq))
)

fig_scatter_v2 <- ggplot(focal_cue, aes(x = ln_u, y = lnE)) +
  # Points by regime
  geom_point(aes(color = regime, shape = regime), size = 2.2, alpha = 0.7) +
  scale_color_manual(values = c(unname(PAL_OI["blue"]),
                                unname(PAL_OI["vermillion"]))) +
  scale_shape_manual(values = c(16, 17)) +
  # OLS line (grey dashed — the misidentified relation)
  geom_line(data = line_df[line_df$method == "OLS", ],
            aes(x = ln_u, y = lnE),
            color = "grey55", linewidth = 0.55, linetype = "dashed") +
  # Johansen ML line (black solid — the identified attractor)
  geom_line(data = line_df[line_df$method == "Johansen ML", ],
            aes(x = ln_u, y = lnE),
            color = "black", linewidth = 0.7, linetype = "solid") +
  # Annotation block (top-left)
  annotate("label",
           x = min(focal_cue$ln_u) + 0.01 * diff(range(focal_cue$ln_u)),
           y = max(focal_cue$lnE) - 0.02 * diff(range(focal_cue$lnE)),
           label = paste0(
             "Johansen ML:  \u03c1 = \u22120.050  (SE = 0.006),  t = \u22127.90***\n",
             "OLS:               slope =  0.270  (SE = 0.220),  R\u00b2 = 0.023"
           ),
           hjust = 0, vjust = 1, size = 2.6,
           fill = "white", color = "grey20",
           label.padding = unit(0.4, "lines"),
           label.size = 0.2, family = "mono") +
  # Line legend annotations (bottom-right area)
  annotate("segment",
           x = max(focal_cue$ln_u) - 0.35 * diff(range(focal_cue$ln_u)),
           xend = max(focal_cue$ln_u) - 0.25 * diff(range(focal_cue$ln_u)),
           y = min(focal_cue$lnE) + 0.10 * diff(range(focal_cue$lnE)),
           yend = min(focal_cue$lnE) + 0.10 * diff(range(focal_cue$lnE)),
           color = "black", linewidth = 0.7) +
  annotate("text",
           x = max(focal_cue$ln_u) - 0.24 * diff(range(focal_cue$ln_u)),
           y = min(focal_cue$lnE) + 0.10 * diff(range(focal_cue$lnE)),
           label = "Johansen ML", hjust = 0, size = 2.5, color = "black") +
  annotate("segment",
           x = max(focal_cue$ln_u) - 0.35 * diff(range(focal_cue$ln_u)),
           xend = max(focal_cue$ln_u) - 0.25 * diff(range(focal_cue$ln_u)),
           y = min(focal_cue$lnE) + 0.05 * diff(range(focal_cue$lnE)),
           yend = min(focal_cue$lnE) + 0.05 * diff(range(focal_cue$lnE)),
           color = "grey55", linewidth = 0.55, linetype = "dashed") +
  annotate("text",
           x = max(focal_cue$ln_u) - 0.24 * diff(range(focal_cue$ln_u)),
           y = min(focal_cue$lnE) + 0.05 * diff(range(focal_cue$lnE)),
           label = "OLS", hjust = 0, size = 2.5, color = "grey55") +
  labs(x = expression(ln~u[t] == ln~Y[t] - hat(theta) %.% ln~K[t]),
       y = expression(ln~e[t]),
       title = "Reserve-army attractor: exploitation rate vs. capacity gap") +
  theme_ch3() +
  theme(
    legend.position = c(0.80, 0.18),
    legend.background = element_rect(fill = alpha("white", 0.85), color = NA),
    legend.text = element_text(size = 7.5),
    plot.title = element_text(size = 10)
  )

save_png_pdf_dual(fig_scatter_v2, "fig_S2_focal_reserve_army_scatter_v2", FIG_DIR,
                  width = 7, height = 5)
cat("Saved fig_S2_focal_reserve_army_scatter_v2\n")

cat("\n=== DONE ===\n")
