# ============================================================
# 26_S1_theta_distribution.R
#
# S1 — theta_hat distribution and CU fan across Pareto envelope
#      Double-panel figure: histogram + capacity utilization fan
#
# Uses:
#   - CONFIG          from codes/10_config.R
#   - utilities       from codes/99_utils.R
#   - theme_ch3(), PAL_OI, save_png_pdf_dual() from 99_figure_protocol.R
#
# Outputs under: output/S1_geometry/figures/
# ============================================================

rm(list = ls())

suppressPackageStartupMessages({
  library(here)
  library(readr)
  library(dplyr)
  library(ggplot2)
  library(patchwork)
  library(scales)
})

# Load CONFIG + UTILS + FIGURE PROTOCOL
source(here::here("codes", "10_config.R"))
source(here::here("codes", "99_utils.R"))
source(here::here("codes", "99_figure_protocol.R"))

stopifnot(exists("CONFIG"))

# ============================================================
# DATA
# ============================================================

# Admissible set
s1_adm <- read_csv(here::here(CONFIG$OUT_CR$S1_geometry, "csv",
                               "S1_admissible.csv"),
                   show_col_types = FALSE)

# Raw Shaikh data (for building u_hat series)
df_raw <- read_csv(here::here(CONFIG[["data_shaikh"]]),
                   show_col_types = FALSE)

Pk       <- as.numeric(df_raw[[CONFIG$p_index]])
p_scale  <- Pk / 100
w        <- CONFIG$WINDOWS_LOCKED[["shaikh_window"]]

df <- data.frame(
  year  = as.integer(df_raw[[CONFIG$year_col]]),
  Y_nom = as.numeric(df_raw[[CONFIG$y_nom]]),
  K_nom = as.numeric(df_raw[[CONFIG$k_nom]])
)
df <- df[df$year >= w[1] & df$year <= w[2], ]
df <- df[order(df$year), ]
df$lnY <- log(df$Y_nom / p_scale[match(df$year,
                as.integer(df_raw[[CONFIG$year_col]]))])
df$lnK <- log(df$K_nom / p_scale[match(df$year,
                as.integer(df_raw[[CONFIG$year_col]]))])

# FRB and Shaikh raw uK benchmarks
uFRB      <- as.numeric(df_raw[["uFRB"]])[
               match(df$year, as.integer(df_raw[[CONFIG$year_col]]))]
uK_shaikh <- as.numeric(df_raw[["uK"]])[
               match(df$year, as.integer(df_raw[[CONFIG$year_col]]))]

# ============================================================
# STEP 1 — IDENTIFY ENVELOPE SPECS (delta = 0)
# ============================================================

# At each k_total, keep the spec with the highest logLik
envelope_specs <- s1_adm %>%
  group_by(k_total) %>%
  slice_max(logLik, n = 1, with_ties = FALSE) %>%
  ungroup()

cat("Envelope specs (E_S1):", nrow(envelope_specs), "\n")
cat("k distribution:\n")
print(table(envelope_specs$k_total))

# Tag all admissible specs — use pre-computed columns from script 21
s1_adm <- s1_adm %>%
  mutate(
    on_envelope = delta_frontier == 0,
    case_label  = paste0("Case ", case)
  )

# ============================================================
# STEP 2 — BUILD CU FAN FOR ENVELOPE SPECS
# ============================================================

fan_list <- list()
for (i in seq_len(nrow(envelope_specs))) {
  spec  <- envelope_specs[i, ]
  theta <- spec$theta_hat
  a     <- spec$a_hat
  k_val <- spec$k_total

  if (!is.finite(theta) || !is.finite(a)) next

  lnYp  <- a + theta * df$lnK
  ect   <- df$lnY - lnYp
  u_hat <- exp(ect - mean(ect, na.rm = TRUE))

  fan_list[[i]] <- data.frame(
    year        = df$year,
    u_hat       = u_hat,
    spec_id     = paste0("(", spec$p, ",", spec$q, ",c",
                          spec$case, ",", spec$s, ")"),
    k_total     = k_val,
    case        = spec$case,
    theta       = theta,
    on_envelope = TRUE
  )
}
fan_df <- bind_rows(fan_list)

# ============================================================
# STEP 3 — BUILD PANELS
# ============================================================

# ---- LEFT PANEL: theta histogram ----
p_hist <- ggplot() +
  # All admissible — grey background
  geom_histogram(
    data = s1_adm,
    aes(x = theta_hat),
    binwidth = 0.05,
    fill = "grey75", color = "white", alpha = 0.5
  ) +
  # Envelope specs — orange foreground
  geom_histogram(
    data = s1_adm %>% filter(on_envelope),
    aes(x = theta_hat),
    binwidth = 0.05,
    fill = PAL_OI["orange"], color = "white", alpha = 0.8
  ) +
  # Reference lines
  geom_vline(xintercept = 0.720, color = PAL_OI["blue"],
             linetype = "dashed", linewidth = 0.5) +
  geom_vline(xintercept = 1.000, color = "grey50",
             linetype = "solid", linewidth = 0.3) +
  # Annotate Shaikh m0
  annotate("text", x = 0.720, y = Inf,
           label = "m0\n(Shaikh)", hjust = -0.1, vjust = 1.5,
           size = 2.5, color = PAL_OI["blue"]) +
  # Annotate Case 4 outlier
  annotate("text", x = 2.204, y = Inf,
           label = "Case 4\n(trend)\n\u03b8=2.20",
           hjust = 1.1, vjust = 1.5,
           size = 2.2, color = "grey40") +
  annotate("segment", x = 2.204, xend = 2.204,
           y = 0, yend = Inf,
           color = "grey60", linewidth = 0.3, linetype = "dotted") +
  labs(
    x        = expression(hat(theta)),
    y        = "Count",
    subtitle = paste0(
      "Grey: all admissible (n=", nrow(s1_adm), ") | ",
      "Orange: Pareto envelope \u03b5_S1 (n=", nrow(envelope_specs), ")"
    )
  ) +
  theme_ch3()


# ---- RIGHT PANEL: CU fan ----
# Drop Case 4 (trend) — theta=2.20 blows up the scale
fan_df <- fan_df %>% filter(case != 4)
n_fan  <- length(unique(fan_df$spec_id))

# Distinct color per spec using full Okabe-Ito palette (no alpha fade)
spec_ids   <- sort(unique(fan_df$spec_id))
fan_colors <- setNames(
  rep_len(unname(PAL_OI[c("orange", "vermillion", "skyblue", "green",
                           "blue", "purple", "yellow")]),
          length(spec_ids)),
  spec_ids
)

p_fan <- ggplot() +
  # Envelope CU fan (one line per spec, distinct color)
  geom_line(
    data = fan_df,
    aes(x = year, y = u_hat, group = spec_id, color = spec_id),
    linewidth = 0.5
  ) +
  scale_color_manual(values = fan_colors, name = "Spec") +
  # Benchmarks in black
  geom_line(
    data = data.frame(year = df$year, u = uK_shaikh),
    aes(x = year, y = u),
    color = "black", linewidth = 1.0, linetype = "solid"
  ) +
  geom_line(
    data = data.frame(year = df$year, u = uFRB),
    aes(x = year, y = u),
    color = "black", linewidth = 1.0, linetype = "dashed"
  ) +
  # Reference lines
  geom_hline(yintercept = 1, color = "grey60",
             linewidth = 0.3, linetype = "solid") +
  geom_vline(xintercept = c(1956, 1974, 1980),
             color = "grey70", linewidth = 0.3, linetype = "dotted") +
  annotate("text", x = 2008, y = max(uK_shaikh, na.rm = TRUE) + 0.02,
           label = "Shaikh u_K", size = 2.2, color = "black",
           hjust = 1, fontface = "bold") +
  annotate("text", x = 2008, y = min(uFRB, na.rm = TRUE) - 0.02,
           label = "FRB (dashed)", size = 2.2, color = "black",
           hjust = 1, fontface = "bold") +
  labs(
    x        = NULL,
    y        = "Capacity utilization (index, demeaned)",
    subtitle = paste0(
      "CU fan across E_S1 (excl. Case 4 trend): ",
      n_fan, " specifications"
    )
  ) +
  theme_ch3() +
  theme(legend.position = "bottom",
        legend.text = element_text(size = 6))

# ============================================================
# STEP 4 — COMBINE WITH PATCHWORK AND SAVE
# ============================================================

fig_combined <- p_hist + p_fan +
  plot_annotation(
    title = expression(
      hat(theta) ~ "distribution and CU fan across " ~
      italic(E)[S1] ~ "(Pareto envelope)"
    )
  ) &
  theme_ch3()

OUT_DIR <- here::here(CONFIG$OUT_CR$S1_geometry, "figures")
save_png_pdf_dual(fig_combined, "fig_S1_theta_and_cu_fan",
                  OUT_DIR, width = 14, height = 5.5)

cat("Figure saved to:", OUT_DIR, "\n")
