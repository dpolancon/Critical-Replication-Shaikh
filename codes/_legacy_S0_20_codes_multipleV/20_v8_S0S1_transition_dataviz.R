# =============================================================================
# S0 — Capacity Utilization Fan Figure (v3)
# fig_S0_cu_fan_v3.R
#
# Visual design: two-panel facet
#   Left  — "Shaikh ARDL(2,4): Interpretation Comparison"
#            Series A (Shaikh interp), B (Case 1), C (Case 3), F (corrected)
#   Right — "IC-Preferred Specifications: Admissible Fan"
#            Series B (Shaikh Case 1 — reference), D (BIC winner), E (AIC winner)
#   Both panels: Shaikh uK (raw) + FRB (raw) as benchmarks
#
# Series F (new): Shaikh ARDL(2,4) coefficients, dummies applied as STEP
#   functions in yp — the correct permanent-shift construction.
#   Same theta/a as A, same c_h magnitudes, but 1(t >= h) instead of 1(t == h)
#
# Three-layer architecture (from ggplot2 guide):
#   Layer 1 — fan lines (low alpha, thin)
#   Layer 2 — benchmarks (full opacity, bold, drawn last)
# =============================================================================

library(ARDL)
library(dynlm)
library(dplyr)
library(tidyr)
library(ggplot2)
library(RColorBrewer)
library(readr)
library(here)

# ── Helper 1: LR multipliers including dummies ────────────────────────
get_lr_full <- function(mod) {
  cc        <- coef(mod)
  ar_names  <- names(cc)[grepl("^L\\(y", names(cc))]
  k_names   <- names(cc)[grepl("^k$|^L\\(k", names(cc))]
  gamma_sum <- sum(cc[ar_names], na.rm = TRUE)
  phi_sum   <- sum(cc[k_names],  na.rm = TRUE)
  denom     <- 1 - gamma_sum
  list(
    denom = denom,
    theta = phi_sum / denom,
    a     = if ("(Intercept)" %in% names(cc)) unname(cc["(Intercept)"] / denom) else 0,
    d1956 = if ("d1956" %in% names(cc)) unname(cc["d1956"] / denom) else 0,
    d1974 = if ("d1974" %in% names(cc)) unname(cc["d1974"] / denom) else 0,
    d1980 = if ("d1980" %in% names(cc)) unname(cc["d1980"] / denom) else 0
  )
}

# ── Helper 2: capacity benchmark ─────────────────────────────────────
# "shaikh"   — impulse dummies in LR equation (as Shaikh implements)
# "case1"    — no intercept, no dummies in LR
# "case3"    — intercept only, no dummies
# "perm"     — CORRECT: LR coefficients from impulse est., applied as steps
build_yp <- function(lr, df, interp) {
  switch(interp,
         shaikh = lr$a + lr$theta * df$k +
           lr$d1956 * df$d1956 +
           lr$d1974 * df$d1974 +
           lr$d1980 * df$d1980,
         case1  = lr$theta * df$k,
         case3  = lr$a + lr$theta * df$k,
         perm   = lr$a + lr$theta * df$k +
           lr$d1956 * as.integer(df$year >= 1956) +
           lr$d1974 * as.integer(df$year >= 1974) +
           lr$d1980 * as.integer(df$year >= 1980),
         stop("Unknown interp: ", interp)
  )
}

build_u <- function(y, yp) {
  ect <- y - yp
  exp(ect - mean(ect, na.rm = TRUE))
}

# ── Step 1: Estimate models ───────────────────────────────────────────
mod_shaikh_const <- ardl(y ~ k | d1956 + d1974 + d1980,
                         data = df_ts, order = c(2, 4), start = 1947, end = 2011)
mod_shaikh_nc    <- ardl(y ~ k - 1 | d1956 + d1974 + d1980,
                         data = df_ts, order = c(2, 4), start = 1947, end = 2011)
mod_bic_nc       <- ardl(y ~ k - 1 | d1956 + d1974 + d1980,
                         data = df_ts, order = c(2, 3), start = 1947, end = 2011)
mod_aic_nc       <- ardl(y ~ k - 1 | d1956 + d1974 + d1980,
                         data = df_ts, order = c(3, 3), start = 1947, end = 2011)

# ── Step 2: LR multipliers ────────────────────────────────────────────
lr_sc <- get_lr_full(mod_shaikh_const)
lr_sn <- get_lr_full(mod_shaikh_nc)
lr_bn <- get_lr_full(mod_bic_nc)
lr_an <- get_lr_full(mod_aic_nc)

cat("=== LR multipliers ===\n")
cat(sprintf("A/C/F (Shaikh const) — theta: %.4f  a: %.4f  d74 LR: %.4f\n",
            lr_sc$theta, lr_sc$a, lr_sc$d1974))
cat(sprintf("B     (Shaikh nc)    — theta: %.4f  denom: %.4f\n",
            lr_sn$theta, lr_sn$denom))
cat(sprintf("D     (BIC nc)       — theta: %.4f  denom: %.4f\n",
            lr_bn$theta, lr_bn$denom))
cat(sprintf("E     (AIC nc)       — theta: %.4f  denom: %.4f\n",
            lr_an$theta, lr_an$denom))

# ── Step 3: Build CU series ───────────────────────────────────────────
df_plot <- df |>
  filter(year >= 1947, year <= 2011) |>
  select(year, y, k, d1956, d1974, d1980, uK, uFRB)

u_A <- build_u(df_plot$y, build_yp(lr_sc, df_plot, "shaikh"))  # artifact
u_B <- build_u(df_plot$y, build_yp(lr_sn, df_plot, "case1"))   # Case 1
u_C <- build_u(df_plot$y, build_yp(lr_sc, df_plot, "case3"))   # Case 3
u_D <- build_u(df_plot$y, build_yp(lr_bn, df_plot, "case1"))   # BIC Case 1
u_E <- build_u(df_plot$y, build_yp(lr_an, df_plot, "case1"))   # AIC Case 1
u_F <- build_u(df_plot$y, build_yp(lr_sc, df_plot, "perm"))    # corrected

# ── Step 4: Assemble long-form data ──────────────────────────────────
# Fix: build wide tibbles first, then pivot_longer — avoids rep() size
# mismatches where year (65 rows) != series labels (65*n rows)
#
# Two facets:
#   L — Shaikh(2,4) interpretation comparison: A, B, C, F
#   R — Admissible fan: B (reference), D, E

# Series A (impulse dummies in LR) removed — spikes are normalization
# artefacts, not economics. Kept in CSV export for documentation only.
wide_L <- tibble(
  year        = df_plot$year,
  B_Case1     = u_B,
  C_Case3     = u_C,
  F_corrected = u_F
)

wide_R <- tibble(
  year        = df_plot$year,
  B_Case1     = u_B,
  D_BIC_Case1 = u_D,
  E_AIC_Case1 = u_E
)

fan_L <- wide_L |>
  pivot_longer(-year, names_to = "series", values_to = "cu") |>
  mutate(panel = "Shaikh ARDL(2,4)\u2009\u2014\u2009Alternative LR closures (B, C, F)")

fan_R <- wide_R |>
  pivot_longer(-year, names_to = "series", values_to = "cu") |>
  mutate(panel = "IC-preferred specifications\u2009\u2014\u2009Admissible fan (Case\u00a01)")

fan_all <- bind_rows(fan_L, fan_R) |>
  mutate(panel = factor(panel, levels = c(
    "Shaikh ARDL(2,4)\u2009\u2014\u2009Alternative LR closures (B, C, F)",
    "IC-preferred specifications\u2009\u2014\u2009Admissible fan (Case\u00a01)"
  )))

# Benchmarks — wide → long, repeated in both panels
bm_wide <- tibble(
  year      = df_plot$year,
  Shaikh_uK = df_plot$uK,
  FRB       = df_plot$uFRB
)

benchmarks <- bind_rows(
  bm_wide |>
    pivot_longer(-year, names_to = "series", values_to = "cu") |>
    mutate(panel = levels(fan_all$panel)[1]),
  bm_wide |>
    pivot_longer(-year, names_to = "series", values_to = "cu") |>
    mutate(panel = levels(fan_all$panel)[2])
) |>
  mutate(panel = factor(panel, levels = levels(fan_all$panel)))

# ── Step 5: CSV export (wide format) ─────────────────────────────────
out_dir <- here::here("output", "CriticalReplication", "S0")
dir.create(out_dir, recursive = TRUE, showWarnings = FALSE)

wide_export <- tibble(
  year              = df_plot$year,
  A_Shaikh_impl     = u_A,
  B_Shaikh_Case1    = u_B,
  C_Shaikh_Case3    = u_C,
  D_BIC_Case1       = u_D,
  E_AIC_Case1       = u_E,
  F_corrected_perm  = u_F,
  Shaikh_uK_raw     = df_plot$uK,
  FRB_raw           = df_plot$uFRB
)
write_csv(wide_export,
          file.path(out_dir, "cu_fan_S0_series_v3.csv"))
cat("\nCSV exported:", file.path(out_dir, "cu_fan_S0_series_v3.csv"), "\n")

# Quick summary
cat("\n=== SERIES SUMMARY ===\n")
wide_export |>
  select(-year) |>
  pivot_longer(everything(), names_to = "series", values_to = "v") |>
  group_by(series) |>
  summarise(mean = round(mean(v, na.rm=T),4), sd = round(sd(v, na.rm=T),4),
            min  = round(min(v,  na.rm=T),4), max = round(max(v, na.rm=T),4),
            .groups = "drop") |> print()

# ── Step 6: Visual encoding ───────────────────────────────────────────
# Fan color families
reds <- brewer.pal(6, "Reds")[3:6]    # Shaikh spec variants
blues <- brewer.pal(6, "Blues")[3:6]  # IC winners

fan_colors <- c(
  B_Case1     = scales::alpha(reds[2], 0.75),
  C_Case3     = scales::alpha(reds[3], 0.55),
  F_corrected = scales::alpha(reds[1], 0.90),  # lightest red, most opaque
  D_BIC_Case1 = scales::alpha(blues[3], 0.80),
  E_AIC_Case1 = scales::alpha(blues[2], 0.70)
)

fan_linetypes <- c(
  B_Case1     = "dashed",
  C_Case3     = "dotted",
  F_corrected = "solid",   # correct permanent-shift construction
  D_BIC_Case1 = "solid",
  E_AIC_Case1 = "dashed"
)

fan_lwidths <- c(
  B_Case1     = 0.65,
  C_Case3     = 0.55,
  F_corrected = 0.85,
  D_BIC_Case1 = 0.85,
  E_AIC_Case1 = 0.65
)

bm_colors <- c(
  Shaikh_uK = "#8B0000",  # dark red — Shaikh published series
  FRB       = "#222222"   # near-black — FRB
)

# ── Step 7: Build figure ──────────────────────────────────────────────
p <- ggplot() +
  
  # ── Layer 1: break-year shading ──────────────────────────────────
  annotate("rect", xmin=1955.5, xmax=1956.5,
           ymin=-Inf, ymax=Inf, alpha=0.05, fill="#444444") +
  annotate("rect", xmin=1973,   xmax=1975,
           ymin=-Inf, ymax=Inf, alpha=0.05, fill="#444444") +
  annotate("rect", xmin=1979,   xmax=1982,
           ymin=-Inf, ymax=Inf, alpha=0.05, fill="#444444") +
  
  # ── Layer 2: reference line u = 1 ────────────────────────────────
  geom_hline(yintercept = 1, color = "grey60",
             linetype = "solid", linewidth = 0.35) +
  
  # ── Layer 3: fan lines (drawn first = behind benchmarks) ─────────
  geom_line(
    data = fan_all |> filter(!is.na(cu)),
    aes(x = year, y = cu, group = series,
        color = series, linetype = series, linewidth = series)
  ) +
  
  # ── Layer 4: benchmarks (drawn last = on top) ─────────────────────
  geom_line(
    data = benchmarks |> filter(!is.na(cu)),
    aes(x = year, y = cu, group = series, color = series),
    linewidth = 1.1
  ) +
  
  # ── Scales ────────────────────────────────────────────────────────
  scale_color_manual(
    values = c(fan_colors, bm_colors),
    labels = c(
      B_Case1     = "B: Shaikh(2,4), Case\u00a01 \u2014 no const., no dummies in LR",
      C_Case3     = "C: Shaikh(2,4), Case\u00a03 \u2014 intercept only in LR",
      F_corrected = "F: Shaikh(2,4), corrected \u2014 LR coefs, step dummies in y\u1D56",
      D_BIC_Case1 = "D: BIC winner ARDL(2,3), Case\u00a01",
      E_AIC_Case1 = "E: AIC winner ARDL(3,3), Case\u00a01",
      Shaikh_uK   = "Shaikh u\u1D4F (raw, Appendix\u00a06.6.1)",
      FRB         = "FRB CU (raw, not rescaled)"
    ),
    name = NULL
  ) +
  scale_linetype_manual(
    values = c(fan_linetypes, Shaikh_uK = "solid", FRB = "solid"),
    labels = c(
      B_Case1     = "B: Shaikh(2,4), Case\u00a01 \u2014 no const., no dummies in LR",
      C_Case3     = "C: Shaikh(2,4), Case\u00a03 \u2014 intercept only in LR",
      F_corrected = "F: Shaikh(2,4), corrected \u2014 LR coefs, step dummies in y\u1D56",
      D_BIC_Case1 = "D: BIC winner ARDL(2,3), Case\u00a01",
      E_AIC_Case1 = "E: AIC winner ARDL(3,3), Case\u00a01",
      Shaikh_uK   = "Shaikh u\u1D4F (raw, Appendix\u00a06.6.1)",
      FRB         = "FRB CU (raw, not rescaled)"
    ),
    name = NULL
  ) +
  scale_linewidth_manual(values = c(fan_lwidths, Shaikh_uK = 1.1, FRB = 1.1),
                         guide = "none") +
  
  # ── Facet ─────────────────────────────────────────────────────────
  facet_wrap(~ panel, ncol = 2) +
  
  # ── Axes and labels ───────────────────────────────────────────────
  scale_x_continuous(breaks = seq(1950, 2010, 10)) +
  scale_y_continuous(labels = function(x) sprintf("%.2f", x)) +
  labs(
    title    = "Capacity Utilization Fan \u2014 Stage S0",
    subtitle = paste0("US Corporate Sector, 1947\u20132011 | ",
                      "ARDL long-run residual, demeaned to mean\u00a0=\u00a01"),
    x        = NULL,
    y        = "Capacity utilization (index)",
    caption  = paste0(
      "Red family: Shaikh ARDL(2,4) under alternative long-run equation closures. ",
      "Blue family: IC-preferred specifications (BIC/AIC winners).\n",
      "Solid = no dummies in LR eq. (F, D); Dashed = no dummies, no const. (B, E); ",
      "Dotted = intercept only (C).\n",
      "Shaikh u\u1D4F and FRB at raw values \u2014 scale gap reflects undocumented ",
      "rescaling convention in Shaikh\u00a0(2016). Grey bands: dummy activation years.\n",
      "Series\u00a0A (Shaikh\u2019s impulse-dummy implementation) omitted \u2014 ",
      "produces artefact spikes of 1.71 (1956), 2.09 (1974), 1.35 (1980); ",
      "see CSV export for full series."
    )
  ) +
  
  # ── Theme ────────────────────────────────────────────────────────
  theme_minimal(base_size = 11) +
  theme(
    legend.position   = "bottom",
    legend.direction  = "vertical",
    legend.text       = element_text(size = 8),
    legend.key.width  = unit(2.0, "cm"),
    panel.grid.minor  = element_blank(),
    panel.grid.major  = element_line(color = "grey92", linewidth = 0.3),
    strip.text        = element_text(face = "bold", size = 10),
    plot.caption      = element_text(hjust = 0, size = 7.5, color = "grey40"),
    plot.title        = element_text(face = "bold", size = 13),
    plot.subtitle     = element_text(size = 9, color = "grey30")
  ) +
  guides(
    color    = guide_legend(ncol = 1,
                            override.aes = list(
                              linewidth = 1.2,
                              linetype  = c("dashed","dotted","solid",
                                            "solid","dashed",
                                            "solid","solid")
                            )),
    linetype = "none"   # merged into color legend via override.aes
  )

print(p)

# ── Save ─────────────────────────────────────────────────────────────
ggsave(file.path(out_dir, "fig_S0_cu_fan_v3.pdf"),
       p, width = 14, height = 7, dpi = 300)
ggsave(file.path(out_dir, "fig_S0_cu_fan_v3.png"),
       p, width = 14, height = 7, dpi = 300)
cat("\nFigure saved to:", file.path(out_dir, "fig_S0_cu_fan_v3.pdf"), "\n")