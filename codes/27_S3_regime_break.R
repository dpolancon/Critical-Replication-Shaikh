# ============================================================
# 27_S3_regime_break.R
# S3 — Temporal Composition Audit: Reserve Army Regime-Break
#       Test at the Fordist / Post-Fordist Threshold (1974)
#
# Consumes: output/S2_vecm/s2_results.rds (trivariate focal)
#
# EMPIRICAL STRATEGY:
#   S2 identified beta = (1, -0.727, 20.022) on (lnY, lnK, ln e).
#   theta is NOT identified (SE=4.85, t=-0.15); beta_e IS (t=7.90***).
#   Renormalize to the reserve army equation:
#     ln(e) = rho * (lnY - theta * lnK)    where rho = -1/beta_e
#   S3 tests rho-stability at 1974, not theta-stability.
#   The break date is a THEORETICAL PRIOR (regulationist periodization).
#
# Blocks:
#   0: Data construction
#   1: Load S2 + trivariate baseline on S3 sample
#   2: Hansen & Johansen (1999) constancy of rho and alpha_e
#   3: JMN (2000) augmented VECM with e* = D74 * ln(e)
#      + CRT (2012) bootstrap
#   4: Regime map
#   5: Figures
#   6: Save and summary
#
# Outputs: output/S3_regime/
# ============================================================

rm(list = ls())

suppressPackageStartupMessages({
  library(here)
  library(dplyr)
  library(ggplot2)
  library(tsDyn)
  library(vars)
  library(urca)
  library(strucchange)
  library(readr)
})

source(here::here("codes", "10_config.R"))
source(here::here("codes", "99_utils.R"))
source(here::here("codes", "99_figure_protocol.R"))

stopifnot(exists("CONFIG"))


# ============================================================
# GLOBAL CONFIG
# ============================================================

BREAK_YEAR   <- 1974
B_BOOT       <- 999
SEED         <- 42
S3_WINDOW    <- c(1947, 2007)   # T = 61
LAG_CAP      <- 2

OUT_DIR <- here::here(CONFIG$OUT_CR$S3_regime %||% "output/S3_regime")
FIG_DIR <- file.path(OUT_DIR, "figures")
CSV_DIR <- file.path(OUT_DIR, "csv")
dir.create(FIG_DIR, recursive = TRUE, showWarnings = FALSE)
dir.create(CSV_DIR, recursive = TRUE, showWarnings = FALSE)


# ============================================================
# BLOCK 0: DATA CONSTRUCTION
# ============================================================

cat("\n===== BLOCK 0: DATA CONSTRUCTION =====\n")

df_raw <- read_csv(here::here(CONFIG[["data_shaikh"]]), show_col_types = FALSE)

Pk      <- as.numeric(df_raw[[CONFIG$p_index]])
p_scale <- Pk / 100

df <- data.frame(
  year  = as.integer(df_raw[[CONFIG$year_col]]),
  Y_nom = as.numeric(df_raw[[CONFIG$y_nom]]),
  K_nom = as.numeric(df_raw[[CONFIG$k_nom]]),
  e_raw = as.numeric(df_raw[[CONFIG$e_rate]])
)
df <- df[complete.cases(df) & df$year > 0, ]

# Deflation (mirrors S2 focal exactly)
df$lnY <- log(df$Y_nom / p_scale[match(df$year, as.integer(df_raw[[CONFIG$year_col]]))])
df$lnK <- log(df$K_nom / p_scale[match(df$year, as.integer(df_raw[[CONFIG$year_col]]))])
df$lne <- log(df$e_raw)

# Trim to S3 sample
df <- df[df$year >= S3_WINDOW[1] & df$year <= S3_WINDOW[2], ]
df <- df[order(df$year), ]
df <- df[is.finite(df$lne), ]
stopifnot(nrow(df) == 61)
T_obs <- nrow(df)

cat("Sample:", min(df$year), "-", max(df$year), "(T =", T_obs, ")\n")

# Regime-shift interaction on exploitation rate
df$D74     <- as.integer(df$year >= BREAK_YEAR)
df$e_star  <- df$D74 * df$lne


# ============================================================
# BLOCK 1: LOAD S2 + TRIVARIATE BASELINE
# ============================================================

cat("\n===== BLOCK 1: S2 INHERITANCE + TRIVARIATE BASELINE =====\n")

# --- Load S2 ---
s2_path <- here::here("output/S2_vecm/s2_results.rds")
stopifnot(file.exists(s2_path))
s2 <- readRDS(s2_path)

RHO_S2 <- -1 / s2$beta_e

cat(sprintf("S2 loaded: %s (T=%d, %d-%d)\n",
            s2$spec_label, s2$T_obs,
            s2$sample_window[1], s2$sample_window[2]))
cat(sprintf("  beta = (1, %.4f, %.4f)\n", s2$beta[2], s2$beta[3]))
cat(sprintf("  theta = %.4f | beta_e = %.3f | rho = %.5f\n",
            s2$theta, s2$beta_e, RHO_S2))
cat(sprintf("  alpha = (%.5f, %.5f, %.5f)\n",
            s2$alpha[1], s2$alpha[2], s2$alpha[3]))
cat(sprintf("  VECM lag = %d (VAR p = %d)\n", s2$lag, s2$p_var))

# Inherit lag
S2_LAG <- s2$lag
if (S2_LAG > LAG_CAP) {
  cat(sprintf("WARNING: S2 lag=%d > LAG_CAP=%d, capping\n", S2_LAG, LAG_CAP))
  S2_LAG <- LAG_CAP
}

# --- Trivariate VECM on S3 sample ---
X_tri <- cbind(lnY = df$lnY, lnK = df$lnK, lne = df$lne)

vecm_tri <- VECM(X_tri, lag = S2_LAG, r = 1,
                  estim = "ML", include = "const")

beta_tri  <- as.matrix(coefB(vecm_tri))
alpha_tri <- as.matrix(coefA(vecm_tri))

THETA_S3  <- -beta_tri[2, 1]
BETA_E_S3 <- beta_tri[3, 1]
RHO_S3    <- -1 / BETA_E_S3
ALPHA_S3  <- alpha_tri
RESID_S3  <- residuals(vecm_tri)

cat(sprintf("\nTrivariate VECM on S3 sample (T=%d, lag=%d):\n", T_obs, S2_LAG))
cat(sprintf("  beta  = (1, %.4f, %.4f)\n", beta_tri[2,1], beta_tri[3,1]))
cat(sprintf("  theta = %.4f | beta_e = %.3f | rho = %.5f\n",
            THETA_S3, BETA_E_S3, RHO_S3))
cat(sprintf("  alpha_y = %.5f | alpha_k = %.5f | alpha_e = %.5f\n",
            ALPHA_S3[1,1], ALPHA_S3[2,1], ALPHA_S3[3,1]))

# S2 vs S3 comparison
cat("\n--- S2 vs S3 comparison ---\n")
cat(sprintf("  theta:  S2 = %.4f | S3 = %.4f | delta = %.4f\n",
            s2$theta, THETA_S3, THETA_S3 - s2$theta))
cat(sprintf("  beta_e: S2 = %.3f | S3 = %.3f | delta = %.3f\n",
            s2$beta_e, BETA_E_S3, BETA_E_S3 - s2$beta_e))
cat(sprintf("  rho:    S2 = %.5f | S3 = %.5f\n", RHO_S2, RHO_S3))

# --- Companion stability ---
check_stability <- function(vecm_fit, label) {
  var_rep <- tryCatch(VARrep(vecm_fit), error = function(e) NULL)
  if (is.null(var_rep) || !is.matrix(var_rep)) {
    cat(sprintf("  %s: VARrep failed\n", label)); return(invisible(NULL))
  }
  lag_cols <- grep("\\.l[0-9]+$", colnames(var_rep))
  A_lag <- var_rep[, lag_cols, drop = FALSE]
  m <- nrow(var_rep); p_eff <- ncol(A_lag) / m
  if (p_eff == 1) {
    eig_mod <- Mod(eigen(A_lag)$values)
  } else {
    n_c <- m * p_eff
    C <- matrix(0, n_c, n_c)
    C[1:m, ] <- A_lag
    C[(m+1):n_c, 1:(m*(p_eff-1))] <- diag(m*(p_eff-1))
    eig_mod <- Mod(eigen(C)$values)
  }
  cat(sprintf("  %s: eigenmod = (%s) — %s\n", label,
              paste(sprintf("%.3f", sort(eig_mod, decreasing = TRUE)), collapse = ", "),
              if (max(eig_mod) <= 1 + 1e-6) "STABLE" else "UNSTABLE"))
}
check_stability(vecm_tri, "Trivariate")

# --- Bai-Perron on e-equation residuals ---
cat("\nBai-Perron on trivariate e-equation residuals:\n")
bp_dates <- NULL
bp_resid <- RESID_S3[, 3]  # e-equation
bp <- tryCatch(
  breakpoints(bp_resid ~ 1, h = floor(0.15 * length(bp_resid))),
  error = function(e) NULL)
if (!is.null(bp)) {
  bp_dates <- breakdates(bp)
  cat("  Break dates:", paste(bp_dates, collapse = ", "), "\n")
} else {
  cat("  No breaks detected\n")
}


# ============================================================
# BLOCK 2: H&J (1999) CONSTANCY — rho AND alpha_e
# ============================================================

cat("\n===== BLOCK 2: HANSEN & JOHANSEN (1999) — rho CONSTANCY =====\n")

t_min <- floor(0.20 * T_obs)
cat(sprintf("Recursive: t* = %d (%d) to %d (%d)\n",
            t_min, df$year[t_min], T_obs, df$year[T_obs]))

hj_df <- data.frame(
  t_star = integer(), year = integer(),
  beta_e_recursive = numeric(), rho_recursive = numeric(),
  alpha_e_recursive = numeric(),
  stringsAsFactors = FALSE
)

for (t_star in t_min:T_obs) {
  X_sub <- X_tri[1:t_star, , drop = FALSE]

  if (t_star < S2_LAG + 5) {
    hj_df <- rbind(hj_df, data.frame(
      t_star = t_star, year = df$year[t_star],
      beta_e_recursive = NA_real_, rho_recursive = NA_real_,
      alpha_e_recursive = NA_real_))
    next
  }

  fit_sub <- tryCatch(
    VECM(X_sub, lag = S2_LAG, r = 1, estim = "ML", include = "const"),
    error = function(e) NULL)

  if (!is.null(fit_sub)) {
    be_sub  <- coefB(fit_sub)[3, 1]
    ae_sub  <- coefA(fit_sub)[3, 1]
    rho_sub <- if (abs(be_sub) > 0.01) -1 / be_sub else NA_real_
  } else {
    be_sub  <- NA_real_
    ae_sub  <- NA_real_
    rho_sub <- NA_real_
  }

  hj_df <- rbind(hj_df, data.frame(
    t_star = t_star, year = df$year[t_star],
    beta_e_recursive = be_sub, rho_recursive = rho_sub,
    alpha_e_recursive = ae_sub))
}

# Fluctuation sequences
hj_df$fluct_rho     <- hj_df$rho_recursive - RHO_S3
hj_df$fluct_alpha_e <- hj_df$alpha_e_recursive - ALPHA_S3[3, 1]

# Nyblom Lc
hj_valid <- hj_df[!is.na(hj_df$rho_recursive) & !is.na(hj_df$alpha_e_recursive), ]
n_valid  <- nrow(hj_valid)

if (n_valid > 2) {
  Lc_rho     <- (1 / n_valid^2) * sum(cumsum(hj_valid$fluct_rho)^2)
  Lc_alpha_e <- (1 / n_valid^2) * sum(cumsum(hj_valid$fluct_alpha_e)^2)
} else {
  Lc_rho     <- NA_real_
  Lc_alpha_e <- NA_real_
}

# H&J (1999) asymptotic CVs — trivariate rank-1
# For the scalar rho (derived from one element of beta in a 3-var system),
# the relevant CVs are from the bivariate beta table (testing one free
# element conditional on normalization). Use bivariate rank-1 CVs as
# conservative reference.
HJ_CV_RHO     <- c("1%" = 0.748, "5%" = 0.470, "10%" = 0.353)
HJ_CV_ALPHA_E <- c("1%" = 0.470, "5%" = 0.353, "10%" = 0.284)

cat(sprintf("H&J rho constancy:     Lc = %.4f  (5%% CV = %.3f) — %s\n",
            Lc_rho, HJ_CV_RHO["5%"],
            if (!is.na(Lc_rho) && Lc_rho > HJ_CV_RHO["5%"])
              "REJECT" else "FAIL TO REJECT"))
cat(sprintf("H&J alpha_e constancy: Lc = %.4f  (5%% CV = %.3f) — %s\n",
            Lc_alpha_e, HJ_CV_ALPHA_E["5%"],
            if (!is.na(Lc_alpha_e) && Lc_alpha_e > HJ_CV_ALPHA_E["5%"])
              "REJECT" else "FAIL TO REJECT"))

write_csv(hj_df, file.path(CSV_DIR, "s3_recursive_hj.csv"))


# ============================================================
# BLOCK 3: JMN (2000) AUGMENTED VECM — e*-AUGMENTATION
# ============================================================

cat("\n===== BLOCK 3: JMN (2000) — e*-AUGMENTED VECM =====\n")

# Augmented system: (lnY, lnK, lne, e*)  where e* = D74 * lne
X_aug <- cbind(lnY = df$lnY, lnK = df$lnK, lne = df$lne, e_star = df$e_star)

cat(sprintf("Augmented system: m=%d, lag=%d, r=1, T=%d\n",
            ncol(X_aug), S2_LAG, T_obs))

# H1: unrestricted — beta = (1, beta_k, beta_e, beta_e*)
vecm_h1 <- VECM(X_aug, lag = S2_LAG, r = 1,
                 estim = "ML", include = "const")
beta_h1  <- coefB(vecm_h1)
alpha_h1 <- coefA(vecm_h1)

# Reserve army parameter recovery
beta_e_Ford <- beta_h1[3, 1]
beta_e_PF   <- beta_h1[3, 1] + beta_h1[4, 1]
rho_Ford    <- if (abs(beta_e_Ford) > 0.01) -1 / beta_e_Ford else NA_real_
rho_PF      <- if (abs(beta_e_PF)   > 0.01) -1 / beta_e_PF   else NA_real_
theta_h1    <- -beta_h1[2, 1]

cat(sprintf("H1 beta = (1, %.4f, %.4f, %.4f)\n",
            beta_h1[2,1], beta_h1[3,1], beta_h1[4,1]))
cat(sprintf("  theta     = %.4f\n", theta_h1))
cat(sprintf("  beta_e Ford = %.3f -> rho_Ford = %.5f\n", beta_e_Ford, rho_Ford))
cat(sprintf("  beta_e PF   = %.3f -> rho_PF   = %.5f\n", beta_e_PF, rho_PF))
cat(sprintf("  delta_beta_e = %.4f (= beta_e*)\n", beta_h1[4,1]))

LL_h1 <- as.numeric(logLik(vecm_h1))

# H0: regime-stable — extend trivariate beta with 0 for e*
# This is a SINGLE restriction (beta_e* = 0): the base beta is data-determined
# from the trivariate VECM on the S3 sample, not imposed from S2.
# Pure 1-df test of "does rho shift at 1974?"
beta_h0 <- matrix(c(beta_tri[, 1], 0), nrow = 4, ncol = 1)
cat(sprintf("\nH0 restriction (1-df): beta = (1, %.4f, %.4f, 0)\n",
            beta_h0[2], beta_h0[3]))
cat("  Source: S3-sample trivariate + beta_e* = 0\n")

vecm_h0 <- tryCatch(
  VECM(X_aug, lag = S2_LAG, r = 1, estim = "ML",
       include = "const", beta = beta_h0),
  error = function(e) {
    warning("H0 VECM failed: ", e$message); NULL
  }
)

LR_obs  <- NA_real_
p_boot  <- NA_real_
LR_boot <- NULL
n_fail  <- 0
n_outlier_50 <- NA
p_boot_trim  <- NA

if (!is.null(vecm_h0)) {
  LL_h0  <- as.numeric(logLik(vecm_h0))
  LR_obs <- -2 * (LL_h0 - LL_h1)
  cat(sprintf("LR_obs = %.3f  [chi2 p-value INVALID per JMN 2000]\n", LR_obs))

  # --- CRT (2012) bootstrap in ECM form ---
  reconstruct_vecm_ecm <- function(vecm_fit, eps_boot, X_orig) {
    C      <- coef(vecm_fit)
    m      <- nrow(C)
    alpha  <- as.matrix(coefA(vecm_fit))
    beta   <- as.matrix(coefB(vecm_fit))
    mu     <- C[, "Intercept"]
    p_vecm <- vecm_fit$lag

    orig_names <- colnames(X_orig)
    Gamma_list <- list()
    for (j in seq_len(p_vecm)) {
      lag_cols <- paste0(orig_names, " -", j)
      if (all(lag_cols %in% colnames(C)))
        Gamma_list[[j]] <- C[, lag_cols, drop = FALSE]
    }

    n_sim  <- nrow(eps_boot)
    n_init <- p_vecm + 1
    X_sim  <- matrix(NA_real_, nrow = n_sim + n_init, ncol = m)
    X_sim[seq_len(n_init), ] <- as.matrix(X_orig[seq_len(n_init), ])

    for (t in (n_init + 1):(n_sim + n_init)) {
      ect <- as.vector(alpha %*% crossprod(beta, X_sim[t - 1, ]))
      sr  <- numeric(m)
      for (j in seq_along(Gamma_list)) {
        if (t - j >= 2) {
          Dx_lag <- X_sim[t - j, ] - X_sim[t - j - 1, ]
          sr <- sr + as.vector(Gamma_list[[j]] %*% Dx_lag)
        }
      }
      Dx <- ect + sr + mu + eps_boot[t - n_init, ]
      X_sim[t, ] <- X_sim[t - 1, ] + Dx
    }

    out <- X_sim[(n_init + 1):(n_sim + n_init), , drop = FALSE]
    if (any(!is.finite(out)) || max(abs(out)) > 1e6) return(NULL)
    out
  }

  cat("Running CRT(2012) bootstrap LR (B =", B_BOOT, ")...")
  set.seed(SEED)
  resid_h0 <- residuals(vecm_h0)
  resid_h0 <- sweep(resid_h0, 2, colMeans(resid_h0))
  LR_boot  <- numeric(B_BOOT)
  n_fail   <- 0

  for (b in seq_len(B_BOOT)) {
    eps_b <- resid_h0[sample(nrow(resid_h0), nrow(resid_h0),
                             replace = TRUE), ]
    X_b   <- reconstruct_vecm_ecm(vecm_h0, eps_b, X_aug)

    if (is.null(X_b)) {
      n_fail <- n_fail + 1; LR_boot[b] <- NA; next
    }

    h1_b <- tryCatch(
      VECM(X_b, lag = S2_LAG, r = 1, estim = "ML", include = "const"),
      error = function(e) NULL)
    h0_b <- tryCatch(
      VECM(X_b, lag = S2_LAG, r = 1, estim = "ML", include = "const",
           beta = beta_h0),
      error = function(e) NULL)

    if (!is.null(h1_b) && !is.null(h0_b)) {
      ll0 <- as.numeric(logLik(h0_b))
      ll1 <- as.numeric(logLik(h1_b))
      if (is.finite(ll0) && is.finite(ll1)) {
        LR_boot[b] <- -2 * (ll0 - ll1)
      } else {
        n_fail <- n_fail + 1; LR_boot[b] <- NA
      }
    } else {
      n_fail <- n_fail + 1; LR_boot[b] <- NA
    }

    if (b %% 100 == 0) cat(".")
  }
  cat(" done.\n")

  if (n_fail > 0) cat("  Bootstrap failures:", n_fail, "/", B_BOOT, "\n")

  LR_boot_valid <- LR_boot[!is.na(LR_boot)]
  p_boot <- if (length(LR_boot_valid) > 0) {
    mean(LR_boot_valid >= LR_obs)
  } else { NA_real_ }

  cat(sprintf("p_boot = %.4f (%d valid replications)\n",
              p_boot, length(LR_boot_valid)))

  if (length(LR_boot_valid) > 0) {
    cat("Bootstrap LR quantiles:\n")
    print(quantile(LR_boot_valid, c(0.05, 0.25, 0.50, 0.75, 0.90, 0.95, 0.99)))
  }

  n_outlier_50 <- sum(LR_boot_valid > 50)
  p_boot_trim  <- if (sum(LR_boot_valid <= 50) > 0) {
    mean(LR_boot_valid[LR_boot_valid <= 50] >= LR_obs)
  } else { NA_real_ }
  cat(sprintf("Outliers: %d draws > 50 | p_boot_trim = %.4f\n",
              n_outlier_50, p_boot_trim))

  write_csv(data.frame(b = seq_len(B_BOOT), LR = LR_boot),
            file.path(CSV_DIR, "s3_JMN_bootstrap.csv"))

} else {
  cat("H0 VECM failed — bootstrap skipped.\n")
}


# ============================================================
# BLOCK 4: REGIME MAP
# ============================================================

cat("\n===== BLOCK 4: REGIME MAP =====\n")

regime_table <- data.frame(
  Method      = c("S2 trivariate focal",
                  "Trivariate (S3 sample)",
                  "H&J rho constancy",
                  "H&J alpha_e constancy",
                  "JMN augmented (e*, 1974)"),
  rho         = c(RHO_S2, RHO_S3, NA, NA, NA),
  rho_Ford    = c(NA, NA, NA, NA, rho_Ford),
  rho_PF      = c(NA, NA, NA, NA, rho_PF),
  stat        = c(NA, NA, Lc_rho, Lc_alpha_e, LR_obs),
  p_value     = c(NA, NA, NA, NA, p_boot),
  note        = c("S2 input",
                  sprintf("lag=%d, T=%d", S2_LAG, T_obs),
                  sprintf("5%% CV = %.3f", HJ_CV_RHO["5%"]),
                  sprintf("5%% CV = %.3f", HJ_CV_ALPHA_E["5%"]),
                  "break=1974"),
  stringsAsFactors = FALSE
)

write_csv(regime_table, file.path(CSV_DIR, "s3_regime_theta_table.csv"))
print(regime_table, digits = 4)

# Scenario logic
scenario_label <- if (!is.na(p_boot) && p_boot > 0.10) {
  "regime-stable -- reserve army sensitivity invariant to Fordist/Post-Fordist transition"
} else if (!is.na(p_boot) && p_boot <= 0.10) {
  if (!is.na(rho_Ford) && !is.na(rho_PF) && abs(rho_Ford) > abs(rho_PF)) {
    "reserve army weakens post-Fordism (|rho| declines)"
  } else if (!is.na(rho_Ford) && !is.na(rho_PF) && abs(rho_Ford) < abs(rho_PF)) {
    "reserve army strengthens post-Fordism (|rho| increases)"
  } else {
    "rho shifts at 1974 -- inspect direction"
  }
} else {
  "unclassified -- inspect manually"
}
cat("Scenario:", scenario_label, "\n")


# ============================================================
# BLOCK 5: FIGURES
# ============================================================

cat("\n===== BLOCK 5: FIGURES =====\n")

# --- Figure 1: H&J recursive rho and alpha_e ---

hj_plot <- hj_df[!is.na(hj_df$rho_recursive), ]

panel_a <- ggplot(hj_plot, aes(x = year)) +
  geom_line(aes(y = rho_recursive), color = PAL_OI["blue"],
            linewidth = 0.7) +
  geom_hline(yintercept = RHO_S3, linetype = "dashed",
             color = PAL_OI["vermillion"], linewidth = 0.5) +
  geom_hline(yintercept = RHO_S2, linetype = "dotted",
             color = PAL_OI["green"], linewidth = 0.5) +
  geom_vline(xintercept = BREAK_YEAR, linetype = "dashed",
             color = "grey50", linewidth = 0.4) +
  annotate("text", x = BREAK_YEAR + 1,
           y = max(hj_plot$rho_recursive, na.rm = TRUE),
           label = "1974", size = 2.5, color = "grey50", hjust = 0) +
  annotate("text", x = max(hj_plot$year) - 3, y = RHO_S3 + 0.002,
           label = expression(hat(rho)[S3]),
           size = 2.5, color = PAL_OI["vermillion"], hjust = 1) +
  annotate("text", x = max(hj_plot$year) - 3, y = RHO_S2 - 0.002,
           label = expression(hat(rho)[S2]),
           size = 2.5, color = PAL_OI["green"], hjust = 1) +
  labs(x = NULL,
       y = expression(hat(rho) * " (recursive VECM)"),
       title = expression("A. Reserve army sensitivity " * rho *
                           " constancy")) +
  theme_ch3()

hj_plot_a <- hj_df[!is.na(hj_df$alpha_e_recursive), ]

panel_b <- ggplot(hj_plot_a, aes(x = year)) +
  geom_line(aes(y = alpha_e_recursive), color = PAL_OI["blue"],
            linewidth = 0.7) +
  geom_hline(yintercept = ALPHA_S3[3, 1], linetype = "dashed",
             color = PAL_OI["vermillion"], linewidth = 0.5) +
  geom_vline(xintercept = BREAK_YEAR, linetype = "dashed",
             color = "grey50", linewidth = 0.4) +
  labs(x = NULL,
       y = expression(hat(alpha)[e] * " (recursive VECM)"),
       title = expression("B. Exploitation rate adjustment " *
                           alpha[e] * " constancy")) +
  theme_ch3()

fig_hj <- gridExtra::grid.arrange(panel_a, panel_b, nrow = 2)
save_png_pdf_dual(fig_hj, "s3_hj_constancy", FIG_DIR,
                  width = 7, height = 8)


# --- Figure 2: Bootstrap LR ---

if (!is.null(LR_boot) && any(!is.na(LR_boot))) {
  lr_df <- data.frame(LR = LR_boot[!is.na(LR_boot)])

  fig_lr <- ggplot(lr_df, aes(x = LR)) +
    geom_histogram(bins = 40, fill = PAL_OI["skyblue"],
                   color = "white", alpha = 0.7) +
    geom_vline(xintercept = LR_obs, color = PAL_OI["vermillion"],
               linewidth = 0.7) +
    annotate("text", x = LR_obs, y = Inf,
             label = sprintf("LR_obs = %.2f\np_boot = %.3f",
                             LR_obs, p_boot),
             hjust = -0.1, vjust = 1.5, size = 3,
             color = PAL_OI["vermillion"]) +
    labs(x = "LR statistic (bootstrap null)",
         y = "Count") +
    theme_ch3()

  save_png_pdf_dual(fig_lr, "s3_bootstrap_LR_dist", FIG_DIR)
}


# --- Figure 3: Reserve army fit ---
# ln(e) vs rho*(lnY - theta*lnK) under S3 baseline

capacity_gap <- df$lnY - THETA_S3 * df$lnK
ra_fit       <- RHO_S3 * capacity_gap

ra_df <- data.frame(
  year   = df$year,
  lne    = df$lne,
  ra_fit = ra_fit
)

fig_ra <- ggplot(ra_df, aes(x = year)) +
  geom_line(aes(y = lne), color = "grey40", linewidth = 0.5) +
  geom_line(aes(y = ra_fit), color = PAL_OI["blue"], linewidth = 0.7) +
  geom_vline(xintercept = BREAK_YEAR, linetype = "dashed",
             color = "grey50", linewidth = 0.4) +
  labs(x = NULL,
       y = "ln(e)",
       title = expression("Reserve army equation: ln(e) vs " *
                           hat(rho) %.% (lnY - hat(theta) %.% lnK))) +
  theme_ch3()

save_png_pdf_dual(fig_ra, "s3_reserve_army_fit", FIG_DIR)


# ============================================================
# BLOCK 6: SAVE AND SUMMARY
# ============================================================

cat("\n===== BLOCK 6: SAVE AND SUMMARY =====\n")

s3_results <- list(
  # S2 inheritance
  s2_spec_label = s2$spec_label,
  s2_theta = s2$theta, s2_beta_e = s2$beta_e,
  s2_rho = RHO_S2, s2_alpha = s2$alpha,
  s2_lag = s2$lag, s2_p_var = s2$p_var,
  # Block 1: trivariate baseline
  THETA_S3 = THETA_S3, BETA_E_S3 = BETA_E_S3, RHO_S3 = RHO_S3,
  ALPHA_S3 = ALPHA_S3, beta_tri = beta_tri,
  S2_LAG = S2_LAG, bp_dates = bp_dates,
  # Block 2: H&J
  hj_recursive_df = hj_df,
  Lc_rho = Lc_rho, Lc_alpha_e = Lc_alpha_e,
  HJ_CV_RHO = HJ_CV_RHO, HJ_CV_ALPHA_E = HJ_CV_ALPHA_E,
  # Block 3: JMN
  beta_h1 = beta_h1, alpha_h1 = alpha_h1,
  rho_Ford = rho_Ford, rho_PF = rho_PF,
  beta_e_Ford = beta_e_Ford, beta_e_PF = beta_e_PF,
  theta_h1 = theta_h1,
  LR_obs = LR_obs, p_boot = p_boot,
  LR_boot = LR_boot, n_fail = n_fail,
  n_outlier_50 = n_outlier_50, p_boot_trim = p_boot_trim,
  # Block 4
  regime_table = regime_table, scenario = scenario_label,
  # Config
  BREAK_YEAR = BREAK_YEAR, B_BOOT = B_BOOT, SEED = SEED,
  S3_WINDOW = S3_WINDOW
)

saveRDS(s3_results, file.path(OUT_DIR, "s3_results.rds"))
cat("Results saved to:", OUT_DIR, "\n")

cat("\n===== S3 RESULTS SUMMARY =====\n")
cat(sprintf("S2 input: %s | theta = %.4f | beta_e = %.3f | rho = %.5f\n",
            s2$spec_label, s2$theta, s2$beta_e, RHO_S2))
cat(sprintf("S3 trivariate: theta = %.4f | beta_e = %.3f | rho = %.5f\n",
            THETA_S3, BETA_E_S3, RHO_S3))
cat(sprintf("H&J rho:     Lc = %.4f (5%% CV = %.3f) -> %s\n",
            Lc_rho, HJ_CV_RHO["5%"],
            if (!is.na(Lc_rho) && Lc_rho > HJ_CV_RHO["5%"])
              "REJECT" else "FAIL TO REJECT"))
cat(sprintf("H&J alpha_e: Lc = %.4f (5%% CV = %.3f) -> %s\n",
            Lc_alpha_e, HJ_CV_ALPHA_E["5%"],
            if (!is.na(Lc_alpha_e) && Lc_alpha_e > HJ_CV_ALPHA_E["5%"])
              "REJECT" else "FAIL TO REJECT"))
cat("JMN augmented VECM (e*, break=1974):\n")
cat(sprintf("  rho_Ford = %.5f | rho_PF = %.5f\n", rho_Ford, rho_PF))
cat(sprintf("  LR_obs = %.3f | p_boot = %.4f (B=%d, fail=%d)\n",
            LR_obs, p_boot, B_BOOT, n_fail))
if (!is.na(n_outlier_50))
  cat(sprintf("  Outliers: %d > 50 | p_boot_trim = %.4f\n",
              n_outlier_50, p_boot_trim))
cat("Bai-Perron:", if (!is.null(bp_dates)) paste(bp_dates, collapse=", ") else "none", "\n")
cat("Scenario:", scenario_label, "\n")
cat("==============================\n")
