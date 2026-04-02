# ============================================================
# 25_S_more_request.R
# Additional visualizations from already-built stage objects.
# Reads CSVs from S1/S2/S3 output folders and drops new
# figures into the corresponding stage figure directories.
#
# Not part of the manifest runner — run interactively.
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
source(here::here("codes", "99_figure_protocol.R"))

stopifnot(exists("CONFIG"))


# ============================================================
# S1 — Theta decomposition: one figure per distribution
# ============================================================
#
# Produces 8 individual kernel density figures:
#   1. _admissible     — all admissible specs
#   2. _frontier       — F^(0.20) by -2logL
#   3. _kernel         — near-frontier kernel (top 20% alpha_w)
#   4. _AIC            — bottom 20% of admissible by AIC
#   5. _BIC            — bottom 20% of admissible by BIC
#   6. _HQ             — bottom 20% of admissible by HQ
#   7. _ICOMP          — bottom 20% of admissible by ICOMP
#   8. _RICOMP         — bottom 20% of admissible by RICOMP
#
# Each panel: kernel density + rug, IC winner lines, summary stats.
# ============================================================

S1_CSV_DIR <- here::here(CONFIG$OUT_CR$S1_geometry, "csv")
S1_FIG_DIR <- here::here(CONFIG$OUT_CR$S1_geometry, "figures")
dir.create(S1_FIG_DIR, recursive = TRUE, showWarnings = FALSE)

F020_Q <- 0.20  # quantile for all frontier/vicinity definitions

# --- Load S1 data ---
s1_adm <- read_csv(file.path(S1_CSV_DIR, "S1_admissible.csv"),
                   show_col_types = FALSE)
s1_f20 <- read_csv(file.path(S1_CSV_DIR, "S1_frontier_F020.csv"),
                   show_col_types = FALSE)

cat("S1 admissible:", nrow(s1_adm), "specs\n")
cat("S1 F^(0.20): ", nrow(s1_f20), "specs\n")

# --- Compute near-frontier kernel set ---
envelope   <- extract_envelope_proto(s1_adm)
df_k       <- add_frontier_kernel(s1_adm, envelope)
q80_alpha  <- quantile(df_k$alpha_w, 1 - F020_Q, na.rm = TRUE)
near_front <- df_k[df_k$alpha_w >= q80_alpha, ]
cat("Near-frontier kernel:", nrow(near_front), "specs\n")

# --- IC winners (used on every panel) ---
ic_winners <- extract_ic_winners(s1_adm)

ic_theta_df <- do.call(rbind, lapply(names(ic_winners), function(ic) {
  w <- ic_winners[[ic]]
  if (nrow(w) == 0 || !is.finite(w$theta_hat[1])) return(NULL)
  data.frame(
    ic    = ic,
    theta = w$theta_hat[1],
    spec  = paste0("(", w$p[1], ",", w$q[1], ",", w$case[1], ",", w$s[1], ")"),
    stringsAsFactors = FALSE
  )
}))

# Merge coincident IC winners for labeling
merge_ic_labels <- function(ic_df) {
  if (is.null(ic_df) || nrow(ic_df) == 0) return(ic_df)
  ic_df$key <- round(ic_df$theta, 5)
  ic_df %>%
    group_by(key) %>%
    summarise(
      theta = first(theta),
      label = paste(ic, collapse = " / "),
      spec  = first(spec),
      color_ic = first(ic),
      .groups = "drop"
    )
}

ic_merged <- merge_ic_labels(ic_theta_df)

# --- IC-specific bottom-20% sets ---
ic_vicinity <- list()
for (ic in c("AIC", "BIC", "HQ", "ICOMP", "RICOMP")) {
  vals <- s1_adm[[ic]]
  if (all(is.na(vals))) { ic_vicinity[[ic]] <- s1_adm[0, ]; next }
  q20_ic <- quantile(vals, F020_Q, na.rm = TRUE)
  ic_vicinity[[ic]] <- s1_adm[is.finite(vals) & vals <= q20_ic, ]
  cat(sprintf("  %6s vicinity (20%%): %d specs\n", ic, nrow(ic_vicinity[[ic]])))
}


# ============================================================
# Reusable single-panel builder
# ============================================================

#' Single-distribution panel: one density + rug + IC winners.
build_theta_panel <- function(theta_vec, fill_color, border_color,
                              subtitle_text, ic_highlight = NULL,
                              ic_merged_df = ic_merged) {
  df <- data.frame(theta = theta_vec[is.finite(theta_vec)])
  if (nrow(df) < 2) return(NULL)

  n   <- nrow(df)
  mu  <- mean(df$theta)
  s   <- sd(df$theta)
  rng <- range(df$theta)

  stat_label <- sprintf("n = %d | mean = %.3f | sd = %.3f | [%.3f, %.3f]",
                        n, mu, s, rng[1], rng[2])

  p <- ggplot(df, aes(x = theta)) +
    geom_density(fill = fill_color, alpha = 0.45,
                 color = border_color, linewidth = 0.5) +
    geom_rug(alpha = 0.20, length = grid::unit(0.03, "npc"),
             color = border_color, sides = "b")

  p <- add_ic_winner_lines(p, ic_merged_df, ic_highlight)

  p +
    annotate("text", x = Inf, y = Inf,
             label = stat_label,
             hjust = 1.02, vjust = -0.3,
             size = 2.3, color = "grey40") +
    labs(x = expression(hat(theta)), y = "Density",
         subtitle = subtitle_text) +
    theme_ch3()
}

#' Two-layer panel: full admissible as grey background + colored subset overlay.
build_theta_panel_layered <- function(theta_all, theta_subset,
                                      fill_color, border_color,
                                      subtitle_text, ic_highlight = NULL,
                                      ic_merged_df = ic_merged) {
  df_all <- data.frame(theta = theta_all[is.finite(theta_all)])
  df_sub <- data.frame(theta = theta_subset[is.finite(theta_subset)])
  if (nrow(df_all) < 2) return(NULL)

  n   <- nrow(df_sub)
  mu  <- if (n > 0) mean(df_sub$theta)  else NA
  s   <- if (n > 1) sd(df_sub$theta)    else NA
  rng <- if (n > 0) range(df_sub$theta) else c(NA, NA)

  stat_label <- sprintf("n = %d | mean = %.3f | sd = %.3f | [%.3f, %.3f]",
                        n, mu, s, rng[1], rng[2])

  p <- ggplot() +
    # Background: full admissible (grey, faint)
    geom_density(data = df_all, aes(x = theta),
                 fill = "grey80", alpha = 0.25,
                 color = "grey60", linewidth = 0.3) +
    # Foreground: best-20% subset (colored)
    geom_density(data = df_sub, aes(x = theta),
                 fill = fill_color, alpha = 0.50,
                 color = border_color, linewidth = 0.5) +
    # Rugs: faint for all, bold for subset
    geom_rug(data = df_all, aes(x = theta),
             alpha = 0.06, length = grid::unit(0.02, "npc"),
             color = "grey50", sides = "b") +
    geom_rug(data = df_sub, aes(x = theta),
             alpha = 0.30, length = grid::unit(0.035, "npc"),
             color = border_color, sides = "b")

  p <- add_ic_winner_lines(p, ic_merged_df, ic_highlight)

  p +
    annotate("text", x = Inf, y = Inf,
             label = stat_label,
             hjust = 1.02, vjust = -0.3,
             size = 2.3, color = "grey40") +
    labs(x = expression(hat(theta)), y = "Density",
         subtitle = subtitle_text) +
    theme_ch3()
}

#' Add IC winner vertical lines + labels to a ggplot.
add_ic_winner_lines <- function(p, ic_merged_df, ic_highlight = NULL) {
  if (is.null(ic_merged_df) || nrow(ic_merged_df) == 0) return(p)
  for (i in seq_len(nrow(ic_merged_df))) {
    row <- ic_merged_df[i, ]
    col <- IC_COLORS[row$color_ic]
    if (is.na(col)) col <- "grey30"

    is_focus <- !is.null(ic_highlight) && grepl(ic_highlight, row$label)
    lw <- if (is_focus) 0.8 else 0.35
    al <- if (is_focus) 0.95 else 0.45
    sz <- if (is_focus) 2.3 else 1.8

    p <- p +
      geom_vline(xintercept = row$theta, color = col,
                 linetype = "dashed", linewidth = lw, alpha = al) +
      annotate("text",
               x = row$theta, y = Inf,
               label = paste0(row$label, "\n", row$spec),
               hjust = -0.08, vjust = 1.2,
               size = sz, color = col, fontface = "bold",
               lineheight = 0.85)
  }
  p
}


# ============================================================
# Generate all 8 panels
# ============================================================

cat("\n--- Building theta decomposition panels ---\n")

# 1. All admissible
fig <- build_theta_panel(
  s1_adm$theta_hat,
  fill_color   = "grey75",
  border_color = "grey50",
  subtitle_text = "All F-bounds admissible specifications"
)
if (!is.null(fig))
  save_png_pdf_dual(fig, "fig_S1_theta_decomposition_admissible", S1_FIG_DIR)

# 2. F^(0.20) frontier (by -2logL)
fig <- build_theta_panel(
  s1_f20$theta_hat,
  fill_color   = PAL_OI["orange"],
  border_color = PAL_OI["vermillion"],
  subtitle_text = expression(F^"(0.20)" ~ "frontier (bottom 20% by " * -2 * log * L * ")")
)
if (!is.null(fig))
  save_png_pdf_dual(fig, "fig_S1_theta_decomposition_frontier", S1_FIG_DIR)

# 3. Near-frontier kernel
fig <- build_theta_panel(
  near_front$theta_hat,
  fill_color   = PAL_OI["skyblue"],
  border_color = PAL_OI["blue"],
  subtitle_text = "Near-frontier kernel (top 20% by distance-weighted alpha)"
)
if (!is.null(fig))
  save_png_pdf_dual(fig, "fig_S1_theta_decomposition_kernel", S1_FIG_DIR)

# 4-8. IC-specific bottom-20% vicinities
ic_panel_config <- list(
  AIC    = list(fill = PAL_OI["orange"],     border = "#C47F00"),
  BIC    = list(fill = PAL_OI["skyblue"],    border = PAL_OI["blue"]),
  HQ     = list(fill = PAL_OI["green"],      border = "#007A59"),
  ICOMP  = list(fill = "#8FB8D9",            border = PAL_OI["blue"]),
  RICOMP = list(fill = "#F2A67A",            border = PAL_OI["vermillion"])
)

for (ic in names(ic_panel_config)) {
  cfg <- ic_panel_config[[ic]]
  vic <- ic_vicinity[[ic]]
  if (nrow(vic) < 2) {
    cat("  ", ic, ": <2 specs, skipped\n")
    next
  }

  sub_text <- sprintf(
    "%s: best 20%% of admissible (n=%d) over full admissible (n=%d)",
    ic, nrow(vic), nrow(s1_adm)
  )

  fig <- build_theta_panel_layered(
    theta_all    = s1_adm$theta_hat,
    theta_subset = vic$theta_hat,
    fill_color   = cfg$fill,
    border_color = cfg$border,
    subtitle_text = sub_text,
    ic_highlight  = ic
  )
  if (!is.null(fig))
    save_png_pdf_dual(
      fig,
      paste0("fig_S1_theta_decomposition_", ic),
      S1_FIG_DIR
    )
}


# ============================================================
# Summary statistics table
# ============================================================

cat("\n=== THETA DECOMPOSITION SUMMARY ===\n")

print_stats <- function(label, theta_vec) {
  tv <- theta_vec[is.finite(theta_vec)]
  if (length(tv) == 0) { cat(sprintf("  %-25s  n=  0\n", label)); return() }
  cat(sprintf("  %-25s  n=%3d  mean=%.4f  sd=%.4f  [%.4f, %.4f]\n",
              label, length(tv), mean(tv), sd(tv), min(tv), max(tv)))
}

print_stats("All admissible",       s1_adm$theta_hat)
print_stats("F^(0.20) frontier",    s1_f20$theta_hat)
print_stats("Near-frontier kernel", near_front$theta_hat)
for (ic in names(ic_vicinity)) {
  print_stats(paste0(ic, " vicinity (20%)"), ic_vicinity[[ic]]$theta_hat)
}

if (!is.null(ic_theta_df)) {
  cat("\n  IC Winners:\n")
  for (i in seq_len(nrow(ic_theta_df))) {
    cat(sprintf("    %-8s  theta=%.4f  spec=%s\n",
                ic_theta_df$ic[i], ic_theta_df$theta[i], ic_theta_df$spec[i]))
  }
}
cat("===================================\n")

cat("\nFigures saved to:", S1_FIG_DIR, "\n")
cat("DONE.\n")
