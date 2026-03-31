# ============================================================
# fig_net_to_gross_ratio.R
# §4.2 Data and Measurement — Main text figure
# Net-to-gross ratio ψ_t = KNCcorpbea / KGCcorp
#
# Purpose: Show the secular decline of ψ_t that contaminates the
# ARDL denominator when net K is used as the capacity regressor.
# The figure IS the argument of §4.2 P2.
#
# Data: Shaikh Appendix 6.8 (Dataset 1)
# Output: output/figures/fig_net_to_gross_ratio.pdf + .png
# ============================================================

library(tidyverse)
library(here)

# --- Load data ------------------------------------------------
# Adjust path to match your pipeline config
source(here("codes", "10_config.R"))

# df should be the Shaikh Dataset 1 dataframe
# Expected columns: year, KGCcorp, KNCcorpbea
# If your config loads it differently, adjust accordingly

# --- Construct ψ_t -------------------------------------------
df <- df %>%
  mutate(
    psi = KNCcorpbea / KGCcorp
  )

# --- Dissertation figure palette -----------------------------
col_main    <- "#2C3E50"   # dark blue-grey for ψ_t
col_regime  <- "#E8E4DF"   # muted fill for regime shading
col_ref     <- "#999999"   # reference line

# --- Plot ----------------------------------------------------
p <- ggplot(df, aes(x = year, y = psi)) +
  
  # Regime shading: 1974 boundary (optional — remove if too busy)
  annotate("rect",
           xmin = 1974, xmax = 2011,
           ymin = -Inf, ymax = Inf,
           fill = col_regime, alpha = 0.5) +
  
  # Reference line at ψ = 1 (where net = gross)
  geom_hline(yintercept = 1, linetype = "dashed",
             color = col_ref, linewidth = 0.4) +
  
  # Main series
  geom_line(color = col_main, linewidth = 0.9) +
  
  # Endpoint label
  annotate("text",
           x = 2012, y = df$psi[df$year == 2011],
           label = sprintf("%.2f", df$psi[df$year == 2011]),
           hjust = 0, size = 3.2, color = col_main) +
  
  # Scales
  
  scale_x_continuous(
    breaks = seq(1950, 2010, by = 10),
    limits = c(1947, 2015)
  ) +
  scale_y_continuous(
    labels = scales::number_format(accuracy = 0.01),
    breaks = seq(0.3, 1.0, by = 0.1)
  ) +
  
  # Labels
  labs(
    x       = NULL,
    y       = expression(psi[t] == KNC^{BEA} / KGC^{GPIM}),
    caption = paste0(
      "Source: Shaikh (2016, Appendix 6.8). ",
      "KGCcorp: GPIM-adjusted gross corporate capital stock. ",
      "KNCcorpbea: BEA 2011 official net corporate capital stock.\n",
      "Shaded area: post-1974 (post-Fordist periodization)."
    )
  ) +
  
  # Theme — dissertation standard
  theme_minimal(base_size = 11) +
  theme(
    panel.grid.minor   = element_blank(),
    panel.grid.major.x = element_blank(),
    panel.grid.major.y = element_line(color = "grey90"),
    axis.text          = element_text(size = 10, color = "black"),
    axis.title.y       = element_text(size = 11),
    plot.caption        = element_text(hjust = 0, size = 8,
                                       color = "grey40"),
    plot.margin         = margin(10, 15, 10, 10)
  )

# --- Export ---------------------------------------------------
ggsave(here("output", "S0", "fig_net_to_gross_ratio.pdf"),
       p, width = 7, height = 4, dpi = 300)
ggsave(here("output", "S0", "fig_net_to_gross_ratio.png"),
       p, width = 7, height = 4, dpi = 300)

cat("Exported: fig_net_to_gross_ratio.pdf/.png\n")
cat(sprintf("ψ range: [%.3f, %.3f]\n",
            min(df$psi, na.rm = TRUE),
            max(df$psi, na.rm = TRUE)))
cat(sprintf("ψ_1947 = %.3f, ψ_2011 = %.3f\n",
            df$psi[df$year == 1947],
            df$psi[df$year == 2011]))