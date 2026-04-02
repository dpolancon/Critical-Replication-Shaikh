# ============================================================
# 99_figure_protocol.R — Unified figure protocol for Ch3 Results Pack
#
# Minimalist, Tufte-inspired data visualization protocol.
# Colorblind-safe Okabe-Ito palette, integer x-axes on
# fit-complexity planes, ggrepel for lag-structure labeling.
#
# Sourced by 80_pack_ch1_replication.R and stage scripts (21, 22, 23).
# Supersedes diagnostic plot functions in 98_ardl_helpers.R.
#
# Dependencies: ggplot2, ggrepel, dplyr
# Date: 2026-03-11
# ============================================================


# ---- 1. Minimalist theme ----

#' Tufte-inspired ggplot2 theme for Ch3 paper figures.
#' - No vertical gridlines (chartjunk)
#' - Faint horizontal gridlines only
#' - Muted axis text, compact margins
#' - Legend at bottom, no title
theme_ch3 <- function(base_size = 11) {
  ggplot2::theme_minimal(base_size = base_size) %+replace%
    ggplot2::theme(
      text               = ggplot2::element_text(family = ""),
      plot.title          = ggplot2::element_text(
        size = ggplot2::rel(1.05), face = "plain", hjust = 0,
        margin = ggplot2::margin(b = 4)
      ),
      plot.subtitle       = ggplot2::element_text(
        size = ggplot2::rel(0.8), color = "grey45",
        margin = ggplot2::margin(b = 8)
      ),
      plot.caption        = ggplot2::element_text(
        size = ggplot2::rel(0.7), color = "grey50", hjust = 1
      ),
      axis.title          = ggplot2::element_text(
        size = ggplot2::rel(0.9), color = "grey25"
      ),
      axis.text           = ggplot2::element_text(
        size = ggplot2::rel(0.8), color = "grey35"
      ),
      axis.ticks          = ggplot2::element_line(
        color = "grey70", linewidth = 0.3
      ),
      axis.ticks.length   = grid::unit(3, "pt"),
      panel.grid.major.x  = ggplot2::element_blank(),
      panel.grid.major.y  = ggplot2::element_line(
        color = "grey90", linewidth = 0.3
      ),
      panel.grid.minor    = ggplot2::element_blank(),
      legend.position     = "bottom",
      legend.title        = ggplot2::element_blank(),
      legend.text         = ggplot2::element_text(size = ggplot2::rel(0.75)),
      legend.key.size     = grid::unit(12, "pt"),
      legend.margin       = ggplot2::margin(t = 2),
      strip.text          = ggplot2::element_text(
        size = ggplot2::rel(0.85), face = "bold", hjust = 0
      ),
      plot.margin         = ggplot2::margin(8, 12, 6, 8)
    )
}


# ---- 2. Okabe-Ito colorblind-safe palette ----

PAL_OI <- c(
  orange     = "#E69F00",
  skyblue    = "#56B4E9",
  green      = "#009E73",
  yellow     = "#F0E442",
  blue       = "#0072B2",
  vermillion = "#D55E00",
  purple     = "#CC79A7",
  black      = "#000000"
)


# ---- 3. IC visual encoding ----

IC_COLORS <- c(
  AIC           = "#E69F00",
  BIC           = "#56B4E9",
  HQ            = "#009E73",
  ICOMP         = "#0072B2",
  RICOMP = "#D55E00"
)

IC_SHAPES <- c(
  AIC           = 15L,
  BIC           = 16L,
  HQ            = 17L,
  ICOMP         = 18L,
  RICOMP =  4L
)

IC_LABELS <- c(
  AIC           = "AIC",
  BIC           = "BIC",
  HQ            = "HQ",
  ICOMP         = "ICOMP",
  RICOMP = expression(RICOMP)
)

IC_NAMES <- c("AIC", "BIC", "HQ", "ICOMP", "RICOMP")


# ---- 4. Integer x-axis for k_total ----

#' Scale for complexity axis: integer breaks, no minor gridlines.
#' @param k_range numeric vector of k_total values (for adaptive step)
scale_x_k <- function(k_range = NULL) {
  if (is.null(k_range)) {
    return(ggplot2::scale_x_continuous(
      breaks = function(lim) {
        span <- diff(lim)
        by <- if (span <= 15) 1L else if (span <= 30) 2L else 5L
        seq(floor(lim[1]), ceiling(lim[2]), by = by)
      },
      minor_breaks = NULL
    ))
  }
  span <- diff(range(k_range, na.rm = TRUE))
  by <- if (span <= 15) 1L else if (span <= 30) 2L else 5L
  ggplot2::scale_x_continuous(
    breaks = seq(floor(min(k_range, na.rm = TRUE)),
                 ceiling(max(k_range, na.rm = TRUE)), by = by),
    minor_breaks = NULL
  )
}


# ---- 5. Save helper (dual PDF + PNG) ----

#' Save a ggplot figure as both PDF (archival/LaTeX) and PNG (Notion embed).
#' @param plot ggplot2 object
#' @param filename filename with or without extension (stem is extracted)
#' @param dir target directory
#' @param width,height inches
#' @param dpi resolution (PNG only; PDF is vector)
save_png_pdf_dual <- function(plot, filename, dir, width = 7, height = 5, dpi = 300) {
  dir.create(dir, recursive = TRUE, showWarnings = FALSE)
  stem <- tools::file_path_sans_ext(filename)

  # PDF — archival / LaTeX
  pdf_path <- file.path(dir, paste0(stem, ".pdf"))
  ggplot2::ggsave(pdf_path, plot, width = width, height = height, device = "pdf")

  # PNG — GitHub raw → Notion embed
  png_path <- file.path(dir, paste0(stem, ".png"))
  ggplot2::ggsave(png_path, plot, width = width, height = height, dpi = dpi,
                  device = "png", bg = "white")

  cat("  Figure:", stem, "(PDF + PNG)\n")
  invisible(pdf_path)
}


# ---- 6. Visual hierarchy constants ----

# Cloud (background noise)
CLOUD_ALPHA <- 0.15
CLOUD_COLOR <- "grey70"
CLOUD_SIZE  <- 1.2

# Frontier / Omega_20 specs (signal)
FRONT_ALPHA <- 0.7
FRONT_COLOR <- PAL_OI["orange"]
FRONT_SIZE  <- 2.0

# Kernel ribbon (near-frontier fade)
RIBBON_BW   <- 5.0          # bandwidth for exp(-delta/BW) decay
RIBBON_BASE_ALPHA <- 0.55   # alpha at delta = 0 (frontier)
RIBBON_COLOR <- PAL_OI["orange"]
RIBBON_SIZE  <- 1.6

# Envelope line
ENVL_COLOR  <- "grey30"
ENVL_LW     <- 0.5

# IC winner points
IC_SIZE     <- 3.5

# IC isoquant lines (AIC/BIC/HQ)
ISO_LW      <- 0.4
ISO_LT      <- "dashed"
ISO_ALPHA   <- 0.6

# m0 benchmark
M0_SHAPE    <- 8L   # asterisk
M0_SIZE     <- 4
M0_COLOR    <- PAL_OI["blue"]

# ggrepel defaults
REPEL_SIZE  <- 2.2
REPEL_SEG_COLOR <- "grey70"
REPEL_SEG_LW    <- 0.3
REPEL_SEED      <- 42L

# Rug defaults
RUG_ALPHA   <- 0.12
RUG_LENGTH  <- grid::unit(0.02, "npc")


# ============================================================
# 7. PLOT BUILDERS
# ============================================================


# ---- 7a. IC winners extraction helper ----

#' Extract IC-minimizing rows from an admissible data.frame.
#' @param df data.frame with IC columns
#' @return named list of single-row data.frames
extract_ic_winners <- function(df) {
  winners <- list()
  for (ic in IC_NAMES) {
    if (!ic %in% names(df)) next
    vals <- df[[ic]]
    if (all(is.na(vals))) {
      winners[[ic]] <- df[0, ]
    } else {
      winners[[ic]] <- df[which.min(vals), , drop = FALSE]
    }
  }
  winners
}

#' Build a tidy data.frame of IC winners for ggplot.
#' @param winners named list from extract_ic_winners
#' @return data.frame with ic, k_total, neg2logL, label columns
ic_winners_df <- function(winners) {
  rows <- lapply(names(winners), function(ic) {
    w <- winners[[ic]]
    if (nrow(w) == 0) return(NULL)
    data.frame(
      ic       = ic,
      k_total  = w$k_total[1],
      neg2logL = w$neg2logL[1],
      label    = ic,
      stringsAsFactors = FALSE
    )
  })
  do.call(rbind, Filter(Negate(is.null), rows))
}


# ---- 7b. Pareto envelope (reuse from 98_ardl_helpers.R logic) ----

#' Simple Pareto frontier in (k_total, logLik) space.
#' For each k, keep highest logLik; then running max.
extract_envelope_proto <- function(df) {
  df_env <- df[is.finite(df$k_total) & is.finite(df$logLik), ]
  df_env <- df_env[order(df_env$k_total, -df_env$logLik), ]
  df_env <- df_env[!duplicated(df_env$k_total), ]
  df_env <- df_env[order(df_env$k_total), ]
  if (nrow(df_env) == 0) return(df_env)
  keep <- df_env$logLik >= cummax(df_env$logLik)
  df_env[keep, , drop = FALSE]
}


# ---- 7c. S0 figures ----

#' S0.1: Utilization replication — u_hat vs u_shaikh
build_fig_S0_utilization <- function(s0_u) {
  rmse <- sqrt(mean((s0_u$u_hat - s0_u$u_shaikh)^2, na.rm = TRUE))
  ggplot2::ggplot(s0_u, ggplot2::aes(x = year)) +
    ggplot2::geom_line(ggplot2::aes(y = u_shaikh), color = "black",
                       linetype = "dashed", linewidth = 0.7) +
    ggplot2::geom_line(ggplot2::aes(y = u_hat), color = PAL_OI["blue"],
                       linewidth = 0.8) +
    ggplot2::geom_hline(yintercept = 1, color = "grey60", linewidth = 0.3) +
    ggplot2::geom_vline(xintercept = c(1956, 1974, 1980),
                        linetype = "dotted", color = "grey50", linewidth = 0.3) +
    ggplot2::annotate("text", x = 2005, y = min(s0_u$u_hat, na.rm = TRUE) + 0.02,
                      label = paste0("RMSE = ", format(round(rmse, 5), nsmall = 5)),
                      size = 2.8, color = "grey40", hjust = 1) +
    ggplot2::annotate("text", x = 1956, y = max(s0_u$u_hat, na.rm = TRUE),
                      label = "1956", size = 2, color = "grey50", hjust = -0.2, vjust = -0.5) +
    ggplot2::annotate("text", x = 1974, y = max(s0_u$u_hat, na.rm = TRUE),
                      label = "1974", size = 2, color = "grey50", hjust = -0.2, vjust = -0.5) +
    ggplot2::annotate("text", x = 1980, y = max(s0_u$u_hat, na.rm = TRUE),
                      label = "1980", size = 2, color = "grey50", hjust = -0.2, vjust = -0.5) +
    ggplot2::labs(x = NULL, y = "Capacity utilization  u") +
    theme_ch3()
}

#' S0.2: Capacity benchmark — lnY vs yp_hat (log capacity)
build_fig_S0_capacity_benchmark <- function(s0_u, lnY) {
  df <- data.frame(year = s0_u$year, lnY = lnY, yp_hat = s0_u$yp_hat)
  ggplot2::ggplot(df, ggplot2::aes(x = year)) +
    ggplot2::geom_ribbon(ggplot2::aes(ymin = pmin(lnY, yp_hat),
                                       ymax = pmax(lnY, yp_hat)),
                          fill = PAL_OI["skyblue"], alpha = 0.25) +
    ggplot2::geom_line(ggplot2::aes(y = lnY), color = "grey30", linewidth = 0.6) +
    ggplot2::geom_line(ggplot2::aes(y = yp_hat), color = PAL_OI["blue"],
                       linewidth = 0.7) +
    ggplot2::geom_vline(xintercept = c(1956, 1974, 1980),
                        linetype = "dotted", color = "grey50", linewidth = 0.3) +
    ggplot2::labs(x = NULL,
                  y = expression(ln ~ Y[t] ~~ "and" ~~ ln ~ Y[t]^p)) +
    theme_ch3()
}

#' S0.3: Five-case comparison — faceted small multiples
build_fig_S0_fivecase <- function(s0_u, s0_spec) {
  u_cols <- grep("^u_case", names(s0_u), value = TRUE)
  if (length(u_cols) == 0) return(NULL)

  long <- tidyr::pivot_longer(
    s0_u[, c("year", "u_shaikh", u_cols)],
    cols = dplyr::all_of(u_cols),
    names_to = "series", values_to = "u"
  )
  long$case_id <- as.integer(gsub("u_case", "", long$series))
  long <- merge(long,
                s0_spec[, c("case_id", "F_pass"), drop = FALSE],
                by = "case_id", all.x = TRUE)
  long$case_label <- paste("Case", long$case_id)

  ggplot2::ggplot(long, ggplot2::aes(x = year)) +
    ggplot2::geom_line(ggplot2::aes(y = u_shaikh), color = "grey70",
                       linewidth = 0.4, linetype = "dashed") +
    ggplot2::geom_line(ggplot2::aes(y = u, linetype = F_pass),
                       color = PAL_OI["blue"], linewidth = 0.6) +
    ggplot2::scale_linetype_manual(values = c("TRUE" = "solid", "FALSE" = "dashed"),
                                   guide = "none") +
    ggplot2::geom_hline(yintercept = 1, color = "grey80", linewidth = 0.2) +
    ggplot2::facet_wrap(~ case_label, nrow = 1) +
    ggplot2::labs(x = NULL, y = "u") +
    theme_ch3() +
    ggplot2::theme(axis.text.x = ggplot2::element_text(angle = 45, hjust = 1, size = 6))
}

#' S0.4: Fit-complexity seed point
build_fig_S0_seed <- function(s0_spec, s1_adm) {
  # Extract m0 coordinates from Case 3
  c3 <- s0_spec[s0_spec$case_id == 3, ]
  if (nrow(c3) == 0) return(NULL)

  # We need k_total and neg2logL for m0
  # S0 spec_report has order_p=2, order_q=4, and we need to compute k_total

  # Use the S1 lattice to find the matching spec: p=2, q=4, case=3, s="s3"
  m0_row <- s1_adm[s1_adm$p == 2 & s1_adm$q == 4 &
                    s1_adm$case == 3 & s1_adm$s == "s3", ]
  if (nrow(m0_row) == 0) {
    # fallback: k=11 and neg2logL from S0 theta_hat
    m0_df <- data.frame(k_total = 11, neg2logL = -341.38)
  } else {
    m0_df <- data.frame(k_total = m0_row$k_total[1],
                        neg2logL = m0_row$neg2logL[1])
  }

  # AIC/BIC iso-contour slopes
  T_eff <- if (nrow(m0_row) > 0) m0_row$T_eff[1] else 63
  aic_intercept <- m0_df$neg2logL + 2 * m0_df$k_total
  bic_intercept <- m0_df$neg2logL + log(T_eff) * m0_df$k_total

  k_seq <- seq(m0_df$k_total - 5, m0_df$k_total + 10, length.out = 100)
  contours <- data.frame(
    k = rep(k_seq, 2),
    neg2logL = c(aic_intercept - 2 * k_seq, bic_intercept - log(T_eff) * k_seq),
    IC = rep(c("AIC", "BIC"), each = length(k_seq))
  )

  ggplot2::ggplot() +
    ggplot2::geom_line(data = contours,
                       ggplot2::aes(x = k, y = neg2logL, color = IC),
                       linetype = "dashed", linewidth = 0.4) +
    ggplot2::scale_color_manual(values = c(AIC = IC_COLORS["AIC"],
                                            BIC = IC_COLORS["BIC"])) +
    ggplot2::geom_point(data = m0_df,
                        ggplot2::aes(x = k_total, y = neg2logL),
                        shape = M0_SHAPE, size = M0_SIZE, color = M0_COLOR) +
    ggrepel::geom_text_repel(
      data = m0_df,
      ggplot2::aes(x = k_total, y = neg2logL, label = "(2,4) Case III"),
      size = REPEL_SIZE + 0.3, color = "grey25",
      nudge_x = 2, nudge_y = 5,
      segment.color = REPEL_SEG_COLOR, segment.size = REPEL_SEG_LW,
      seed = REPEL_SEED
    ) +
    scale_x_k(k_seq) +
    ggplot2::labs(
      x = expression(italic(k)(m)),
      y = expression(-2 ~ log ~ italic(L)(m))
    ) +
    theme_ch3()
}


# ---- 7c-bis. Kernel-weight and label helpers ----

#' Compute vertical distance from Pareto envelope and kernel-weighted alpha.
#' @param df admissible specs (must have k_total, neg2logL)
#' @param envelope output of extract_envelope_proto()
#' @param bw bandwidth for exponential decay (default RIBBON_BW)
#' @return df with delta_frontier and alpha_w columns added
add_frontier_kernel <- function(df, envelope, bw = RIBBON_BW) {
  env_lookup <- stats::setNames(envelope$neg2logL, as.character(envelope$k_total))
  # For each spec, find the envelope neg2logL at the nearest k_total
  df$env_neg2logL <- vapply(df$k_total, function(k) {
    dists <- abs(as.numeric(names(env_lookup)) - k)
    env_lookup[which.min(dists)]
  }, numeric(1))
  df$delta_frontier <- df$neg2logL - df$env_neg2logL
  df$delta_frontier <- pmax(df$delta_frontier, 0)
  df$alpha_w <- RIBBON_BASE_ALPHA * exp(-df$delta_frontier / bw)
  df
}

#' Build full ARDL spec label: (p,q,C,s)
ardl_spec_label <- function(df) {
  paste0("(", df$p, ",", df$q, ",", df$case, ",", df$s, ")")
}

#' Merge coincident IC winners into "AIC / BIC" labels.
#' @param wdf data.frame from ic_winners_df()
#' @return wdf with coincident points collapsed, labels joined
merge_coincident_winners <- function(wdf) {
  if (is.null(wdf) || nrow(wdf) == 0) return(wdf)
  wdf$key <- paste(wdf$k_total, wdf$neg2logL, sep = "_")
  merged <- do.call(rbind, lapply(split(wdf, wdf$key), function(grp) {
    data.frame(
      ic       = grp$ic[1],
      k_total  = grp$k_total[1],
      neg2logL = grp$neg2logL[1],
      label    = paste(grp$ic, collapse = " / "),
      stringsAsFactors = FALSE
    )
  }))
  merged$key <- NULL
  rownames(merged) <- NULL
  merged
}

#' Build IC isoquant lines for AIC, BIC, HQ through their winner points.
#' @param wdf merged winners data.frame
#' @param df admissible specs (for T_eff and k range)
#' @return data.frame with k, neg2logL, ic columns for geom_line
build_ic_isoquants <- function(wdf, df) {
  if (is.null(wdf) || nrow(wdf) == 0) return(NULL)
  T_eff <- if ("T_eff" %in% names(df)) median(df$T_eff, na.rm = TRUE) else 63
  k_range <- range(df$k_total, na.rm = TRUE)
  k_seq <- seq(k_range[1] - 1, k_range[2] + 1, length.out = 200)

  # Penalty slopes: IC = neg2logL + penalty*k  =>  neg2logL = IC_star - penalty*k
  slopes <- c(AIC = 2, BIC = log(T_eff), HQ = 2 * log(log(T_eff)))

  rows <- list()
  for (ic_name in names(slopes)) {
    # Find the winner row for this IC (may be merged label)
    w_row <- wdf[grepl(ic_name, wdf$label), ]
    if (nrow(w_row) == 0) next
    ic_star <- w_row$neg2logL[1] + slopes[ic_name] * w_row$k_total[1]
    rows[[ic_name]] <- data.frame(
      k = k_seq,
      neg2logL = as.numeric(ic_star) - slopes[ic_name] * k_seq,
      ic = ic_name,
      stringsAsFactors = FALSE
    )
  }
  if (length(rows) == 0) return(NULL)
  do.call(rbind, rows)
}


# ---- 7d. S1 figures (ARDL geometry) ----

#' S1.1: Global frontier — kernel-shaded near-frontier region,
#'        envelope line, frontier specs labeled (p,q,C,s), marginal rugs.
build_fig_S1_global_frontier <- function(s1_adm, m0_row = NULL) {
  envelope <- extract_envelope_proto(s1_adm)
  envelope$spec_label <- ardl_spec_label(envelope)

  # Kernel-weighted alpha for near-frontier shading
  df_k <- add_frontier_kernel(s1_adm, envelope)

  p <- ggplot2::ggplot(df_k, ggplot2::aes(x = k_total, y = neg2logL)) +
    # Near-frontier kernel ribbon (fading points)
    ggplot2::geom_point(ggplot2::aes(alpha = alpha_w),
                        color = RIBBON_COLOR, size = RIBBON_SIZE) +
    ggplot2::scale_alpha_identity() +
    # Faint cloud underneath (all specs)
    ggplot2::geom_point(data = s1_adm, ggplot2::aes(x = k_total, y = neg2logL),
                        alpha = CLOUD_ALPHA, color = CLOUD_COLOR,
                        size = CLOUD_SIZE) +
    # Pareto envelope line + points
    ggplot2::geom_line(data = envelope,
                       ggplot2::aes(x = k_total, y = neg2logL),
                       color = ENVL_COLOR, linewidth = ENVL_LW) +
    ggplot2::geom_point(data = envelope,
                        ggplot2::aes(x = k_total, y = neg2logL),
                        color = ENVL_COLOR, size = 1.8, alpha = 0.8) +
    # Marginal density rugs
    ggplot2::geom_rug(data = s1_adm, ggplot2::aes(x = k_total, y = neg2logL),
                      alpha = RUG_ALPHA, length = RUG_LENGTH,
                      color = "grey50", sides = "bl") +
    # Envelope spec labels
    ggrepel::geom_text_repel(
      data = envelope,
      ggplot2::aes(x = k_total, y = neg2logL, label = spec_label),
      size = REPEL_SIZE, color = "grey30",
      segment.color = REPEL_SEG_COLOR, segment.size = REPEL_SEG_LW,
      segment.linetype = "solid",
      max.overlaps = 25, box.padding = 0.4, point.padding = 0.2,
      force = 2, min.segment.length = 0.1, seed = REPEL_SEED
    )

  if (!is.null(m0_row) && nrow(m0_row) > 0) {
    p <- p +
      ggplot2::geom_point(
        data = m0_row,
        ggplot2::aes(x = k_total, y = neg2logL),
        shape = M0_SHAPE, size = M0_SIZE + 1, color = M0_COLOR
      ) +
      ggrepel::geom_text_repel(
        data = m0_row,
        ggplot2::aes(x = k_total, y = neg2logL),
        label = "m0 (Shaikh, inadmissible)",
        size = REPEL_SIZE + 0.5, color = M0_COLOR, fontface = "bold",
        nudge_x = 1.5, nudge_y = 8,
        segment.color = M0_COLOR, segment.size = 0.4,
        segment.linetype = "dashed",
        max.overlaps = Inf, seed = REPEL_SEED
      )
  }

  p + scale_x_k(s1_adm$k_total) +
    ggplot2::labs(
      x = expression(italic(k)(m)),
      y = expression(-2 ~ log ~ italic(L)(m))
    ) +
    theme_ch3()
}

#' S1.2: IC tangencies — IC winners with isoquant lines (AIC/BIC/HQ),
#'        coincident winners merged, marginal rugs.
build_fig_S1_ic_tangencies <- function(s1_adm, m0_row = NULL) {
  envelope <- extract_envelope_proto(s1_adm)
  winners <- extract_ic_winners(s1_adm)
  wdf <- ic_winners_df(winners)
  wdf_merged <- merge_coincident_winners(wdf)

  # IC isoquant lines (AIC, BIC, HQ only — ICOMP/RICOMP are non-linear)
  iso_df <- build_ic_isoquants(wdf, s1_adm)

  p <- ggplot2::ggplot(s1_adm, ggplot2::aes(x = k_total, y = neg2logL)) +
    ggplot2::geom_point(alpha = CLOUD_ALPHA, color = CLOUD_COLOR,
                        size = CLOUD_SIZE) +
    ggplot2::geom_line(data = envelope,
                       ggplot2::aes(x = k_total, y = neg2logL),
                       color = ENVL_COLOR, linewidth = ENVL_LW) +
    ggplot2::geom_rug(alpha = RUG_ALPHA, length = RUG_LENGTH,
                      color = "grey50", sides = "bl")

  # Isoquant lines (clipped to y-range of data)
  if (!is.null(iso_df) && nrow(iso_df) > 0) {
    y_range <- range(s1_adm$neg2logL, na.rm = TRUE)
    iso_clipped <- iso_df[iso_df$neg2logL >= y_range[1] &
                          iso_df$neg2logL <= y_range[2], ]
    if (nrow(iso_clipped) > 0) {
      p <- p + ggplot2::geom_line(
        data = iso_clipped,
        ggplot2::aes(x = k, y = neg2logL, color = ic),
        linetype = ISO_LT, linewidth = ISO_LW, alpha = ISO_ALPHA
      )
    }
  }

  # IC winner points + merged labels
  if (!is.null(wdf) && nrow(wdf) > 0) {
    p <- p +
      ggplot2::geom_point(
        data = wdf, ggplot2::aes(x = k_total, y = neg2logL,
                                  color = ic, shape = ic),
        size = IC_SIZE
      ) +
      ggplot2::scale_color_manual(values = IC_COLORS, labels = IC_LABELS) +
      ggplot2::scale_shape_manual(values = IC_SHAPES, labels = IC_LABELS) +
      ggrepel::geom_text_repel(
        data = wdf_merged,
        ggplot2::aes(x = k_total, y = neg2logL, label = label),
        size = REPEL_SIZE + 0.3, fontface = "bold",
        segment.color = REPEL_SEG_COLOR, segment.size = REPEL_SEG_LW,
        max.overlaps = Inf, box.padding = 0.6, force = 3,
        min.segment.length = 0, seed = REPEL_SEED
      )
  }

  if (!is.null(m0_row) && nrow(m0_row) > 0) {
    p <- p +
      ggplot2::geom_point(
        data = m0_row,
        ggplot2::aes(x = k_total, y = neg2logL),
        shape = M0_SHAPE, size = M0_SIZE + 1, color = M0_COLOR
      ) +
      ggrepel::geom_text_repel(
        data = m0_row,
        ggplot2::aes(x = k_total, y = neg2logL),
        label = "m0 (Shaikh, inadmissible)",
        size = REPEL_SIZE + 0.5, color = M0_COLOR, fontface = "bold",
        nudge_x = 1.5, nudge_y = 8,
        segment.color = M0_COLOR, segment.size = 0.4,
        segment.linetype = "dashed",
        max.overlaps = Inf, seed = REPEL_SEED
      )
  }

  p + scale_x_k(s1_adm$k_total) +
    ggplot2::labs(
      x = expression(italic(k)(m)),
      y = expression(-2 ~ log ~ italic(L)(m))
    ) +
    theme_ch3() +
    ggplot2::theme(legend.position = "bottom")
}

#' S1.3: Informational domain — kernel-shaded near-frontier region,
#'        F^(0.20) specs labeled (p,q,C,s), marginal rugs.
build_fig_S1_informational_domain <- function(s1_adm, s1_f20, m0_row = NULL) {
  envelope <- extract_envelope_proto(s1_adm)
  s1_f20$spec_label <- ardl_spec_label(s1_f20)

  # Kernel-weighted shading for near-frontier region
  df_k <- add_frontier_kernel(s1_adm, envelope)

  p <- ggplot2::ggplot(df_k, ggplot2::aes(x = k_total, y = neg2logL)) +
    # Near-frontier kernel ribbon
    ggplot2::geom_point(ggplot2::aes(alpha = alpha_w),
                        color = RIBBON_COLOR, size = RIBBON_SIZE) +
    ggplot2::scale_alpha_identity() +
    # Faint cloud (all specs)
    ggplot2::geom_point(data = s1_adm, ggplot2::aes(x = k_total, y = neg2logL),
                        alpha = CLOUD_ALPHA, color = CLOUD_COLOR,
                        size = CLOUD_SIZE) +
    # Pareto envelope
    ggplot2::geom_line(data = envelope,
                       ggplot2::aes(x = k_total, y = neg2logL),
                       color = ENVL_COLOR, linewidth = ENVL_LW) +
    # F^(0.20) frontier specs (highlighted)
    ggplot2::geom_point(data = s1_f20,
                        ggplot2::aes(x = k_total, y = neg2logL),
                        color = FRONT_COLOR, size = FRONT_SIZE,
                        alpha = FRONT_ALPHA) +
    # Marginal rugs
    ggplot2::geom_rug(data = s1_adm, ggplot2::aes(x = k_total, y = neg2logL),
                      alpha = RUG_ALPHA, length = RUG_LENGTH,
                      color = "grey50", sides = "bl") +
    # F^(0.20) spec labels
    ggrepel::geom_text_repel(
      data = s1_f20,
      ggplot2::aes(x = k_total, y = neg2logL, label = spec_label),
      size = REPEL_SIZE, color = "grey30",
      segment.color = REPEL_SEG_COLOR, segment.size = REPEL_SEG_LW,
      max.overlaps = 25, box.padding = 0.4, point.padding = 0.2,
      force = 2, min.segment.length = 0.1, seed = REPEL_SEED
    ) +
    ggplot2::annotate("text", x = Inf, y = Inf,
                      label = paste0("n = ", nrow(s1_f20), " specs"),
                      hjust = 1.1, vjust = 1.5, size = 2.8, color = "grey40")

  if (!is.null(m0_row) && nrow(m0_row) > 0) {
    p <- p +
      ggplot2::geom_point(
        data = m0_row,
        ggplot2::aes(x = k_total, y = neg2logL),
        shape = M0_SHAPE, size = M0_SIZE + 1, color = M0_COLOR
      ) +
      ggrepel::geom_text_repel(
        data = m0_row,
        ggplot2::aes(x = k_total, y = neg2logL),
        label = "m0 (Shaikh, inadmissible)",
        size = REPEL_SIZE + 0.5, color = M0_COLOR, fontface = "bold",
        nudge_x = 1.5, nudge_y = 8,
        segment.color = M0_COLOR, segment.size = 0.4,
        segment.linetype = "dashed",
        max.overlaps = Inf, seed = REPEL_SEED
      )
  }

  p + scale_x_k(s1_adm$k_total) +
    ggplot2::labs(
      x = expression(italic(k)(m)),
      y = expression(-2 ~ log ~ italic(L)(m))
    ) +
    theme_ch3()
}


# ---- 7e. S1 supplementary figures ----

#' S1-supp-a: theta distribution across F^(0.20)
build_fig_S1_theta_dist <- function(s1_theta, theta_m0 = 0.6609) {
  ggplot2::ggplot(s1_theta, ggplot2::aes(x = theta)) +
    ggplot2::geom_density(fill = PAL_OI["skyblue"], alpha = 0.4,
                          color = PAL_OI["blue"], linewidth = 0.5) +
    ggplot2::geom_vline(xintercept = theta_m0, linetype = "dashed",
                        color = PAL_OI["vermillion"], linewidth = 0.5) +
    ggplot2::annotate("text", x = theta_m0, y = Inf,
                      label = expression(hat(theta)[m0]),
                      hjust = -0.3, vjust = 1.5, size = 3,
                      color = PAL_OI["vermillion"]) +
    ggplot2::labs(x = expression(hat(theta)), y = "Density") +
    theme_ch3()
}

#' S1-supp-b: Utilization band across F^(0.20)
build_fig_S1_u_band <- function(s1_u_band) {
  ggplot2::ggplot(s1_u_band, ggplot2::aes(x = year)) +
    ggplot2::geom_ribbon(ggplot2::aes(ymin = u_lower, ymax = u_upper),
                          fill = PAL_OI["skyblue"], alpha = 0.25) +
    ggplot2::geom_line(ggplot2::aes(y = u_med), color = PAL_OI["blue"],
                       linewidth = 0.7) +
    ggplot2::geom_line(ggplot2::aes(y = u_shaikh), color = "black",
                       linetype = "dashed", linewidth = 0.5) +
    ggplot2::geom_hline(yintercept = 1, color = "grey60", linewidth = 0.2) +
    ggplot2::labs(x = NULL, y = "u") +
    theme_ch3()
}

#' S1-supp-c: s_K distribution across F^(0.20)
build_fig_S1_sK_dist <- function(s1_f20) {
  ggplot2::ggplot(s1_f20, ggplot2::aes(x = s_K)) +
    ggplot2::geom_histogram(bins = 10, fill = PAL_OI["skyblue"],
                            color = "white", alpha = 0.7) +
    ggplot2::labs(x = expression(italic(s)[K] == italic(q) / (italic(p) + italic(q))),
                  y = "Count") +
    theme_ch3()
}


# ---- 7e-bis. S1 theta landscape (new) ----

#' S1 theta landscape: theta mapped to color on the (k, -2logL) plane.
build_fig_S1_theta_landscape <- function(s1_adm, m0_row = NULL) {
  envelope <- extract_envelope_proto(s1_adm)

  # Filter specs with finite theta
  df <- s1_adm[is.finite(s1_adm$theta_hat), ]

  p <- ggplot2::ggplot(df, ggplot2::aes(x = k_total, y = neg2logL)) +
    ggplot2::geom_point(ggplot2::aes(color = theta_hat),
                        size = 1.8, alpha = 0.7) +
    ggplot2::scale_color_viridis_c(option = "C", name = expression(hat(theta))) +
    ggplot2::geom_line(data = envelope,
                       ggplot2::aes(x = k_total, y = neg2logL),
                       color = ENVL_COLOR, linewidth = ENVL_LW + 0.2) +
    ggplot2::geom_rug(alpha = RUG_ALPHA, length = RUG_LENGTH,
                      color = "grey50", sides = "bl")

  if (!is.null(m0_row) && nrow(m0_row) > 0) {
    p <- p + ggplot2::geom_point(
      data = m0_row, ggplot2::aes(x = k_total, y = neg2logL),
      shape = M0_SHAPE, size = M0_SIZE, color = "white"
    )
  }

  p + scale_x_k(s1_adm$k_total) +
    ggplot2::labs(
      x = expression(italic(k)(m)),
      y = expression(-2 ~ log ~ italic(L)(m))
    ) +
    theme_ch3() +
    ggplot2::theme(legend.position = "right")
}


# ---- 7f. S2 figures (VECM) ----

#' Build VECM spec label: "(p, d, h)" or "(p, d, h, r)" for m=3
vecm_label <- function(df, include_r = FALSE) {
  if (include_r) {
    paste0("(", df$p, ",", df$d, ",", df$h, ",r", df$r, ")")
  } else {
    paste0("(", df$p, ",", df$d, ",", df$h, ")")
  }
}

#' S2.1: Global frontier per system dimension — kernel-shaded, rugs, labels.
build_fig_S2_global_frontier <- function(s2_adm, s2_omega, m_dim,
                                          include_r = FALSE) {
  envelope <- extract_envelope_proto(s2_adm)
  s2_omega$spec_label <- vecm_label(s2_omega, include_r = include_r)

  df_k <- add_frontier_kernel(s2_adm, envelope)

  p <- ggplot2::ggplot(df_k, ggplot2::aes(x = k_total, y = neg2logL)) +
    ggplot2::geom_point(ggplot2::aes(alpha = alpha_w),
                        color = RIBBON_COLOR, size = RIBBON_SIZE) +
    ggplot2::scale_alpha_identity() +
    ggplot2::geom_point(data = s2_adm, ggplot2::aes(x = k_total, y = neg2logL),
                        alpha = CLOUD_ALPHA, color = CLOUD_COLOR,
                        size = CLOUD_SIZE) +
    ggplot2::geom_line(data = envelope,
                       ggplot2::aes(x = k_total, y = neg2logL),
                       color = ENVL_COLOR, linewidth = ENVL_LW) +
    ggplot2::geom_point(data = s2_omega,
                        ggplot2::aes(x = k_total, y = neg2logL),
                        color = FRONT_COLOR, size = FRONT_SIZE,
                        alpha = FRONT_ALPHA) +
    ggplot2::geom_rug(data = s2_adm, ggplot2::aes(x = k_total, y = neg2logL),
                      alpha = RUG_ALPHA, length = RUG_LENGTH,
                      color = "grey50", sides = "bl")

  if (nrow(s2_omega) <= 20) {
    p <- p + ggrepel::geom_text_repel(
      data = s2_omega,
      ggplot2::aes(x = k_total, y = neg2logL, label = spec_label),
      size = REPEL_SIZE, color = "grey30",
      segment.color = REPEL_SEG_COLOR, segment.size = REPEL_SEG_LW,
      max.overlaps = 25, box.padding = 0.4, force = 2,
      min.segment.length = 0.1, seed = REPEL_SEED
    )
  }

  p + scale_x_k(s2_adm$k_total) +
    ggplot2::labs(
      x = expression(italic(k)(m)),
      y = expression(-2 ~ log ~ italic(L)(m))
    ) +
    theme_ch3()
}

#' S2.2: IC tangencies per system dimension — isoquants, merged labels, rugs.
build_fig_S2_ic_tangencies <- function(s2_adm, m_dim) {
  envelope <- extract_envelope_proto(s2_adm)
  winners <- extract_ic_winners(s2_adm)
  wdf <- ic_winners_df(winners)
  wdf_merged <- merge_coincident_winners(wdf)
  iso_df <- build_ic_isoquants(wdf, s2_adm)

  p <- ggplot2::ggplot(s2_adm, ggplot2::aes(x = k_total, y = neg2logL)) +
    ggplot2::geom_point(alpha = CLOUD_ALPHA, color = CLOUD_COLOR,
                        size = CLOUD_SIZE) +
    ggplot2::geom_line(data = envelope,
                       ggplot2::aes(x = k_total, y = neg2logL),
                       color = ENVL_COLOR, linewidth = ENVL_LW) +
    ggplot2::geom_rug(alpha = RUG_ALPHA, length = RUG_LENGTH,
                      color = "grey50", sides = "bl")

  if (!is.null(iso_df) && nrow(iso_df) > 0) {
    y_range <- range(s2_adm$neg2logL, na.rm = TRUE)
    iso_clipped <- iso_df[iso_df$neg2logL >= y_range[1] &
                          iso_df$neg2logL <= y_range[2], ]
    if (nrow(iso_clipped) > 0) {
      p <- p + ggplot2::geom_line(
        data = iso_clipped,
        ggplot2::aes(x = k, y = neg2logL, color = ic),
        linetype = ISO_LT, linewidth = ISO_LW, alpha = ISO_ALPHA
      )
    }
  }

  if (!is.null(wdf) && nrow(wdf) > 0) {
    p <- p +
      ggplot2::geom_point(
        data = wdf, ggplot2::aes(x = k_total, y = neg2logL,
                                  color = ic, shape = ic),
        size = IC_SIZE
      ) +
      ggplot2::scale_color_manual(values = IC_COLORS, labels = IC_LABELS) +
      ggplot2::scale_shape_manual(values = IC_SHAPES, labels = IC_LABELS) +
      ggrepel::geom_text_repel(
        data = wdf_merged,
        ggplot2::aes(x = k_total, y = neg2logL, label = label),
        size = REPEL_SIZE + 0.3, fontface = "bold",
        segment.color = REPEL_SEG_COLOR, segment.size = REPEL_SEG_LW,
        max.overlaps = Inf, box.padding = 0.6, force = 3,
        min.segment.length = 0, seed = REPEL_SEED
      )
  }

  p + scale_x_k(s2_adm$k_total) +
    ggplot2::labs(
      x = expression(italic(k)(m)),
      y = expression(-2 ~ log ~ italic(L)(m))
    ) +
    theme_ch3() +
    ggplot2::theme(legend.position = "bottom")
}

#' S2.3: Informational domain per system dimension — kernel-shaded, rugs.
build_fig_S2_informational_domain <- function(s2_adm, s2_omega, m_dim,
                                               include_r = FALSE) {
  envelope <- extract_envelope_proto(s2_adm)
  s2_omega$spec_label <- vecm_label(s2_omega, include_r = include_r)

  df_k <- add_frontier_kernel(s2_adm, envelope)

  p <- ggplot2::ggplot(df_k, ggplot2::aes(x = k_total, y = neg2logL)) +
    ggplot2::geom_point(ggplot2::aes(alpha = alpha_w),
                        color = RIBBON_COLOR, size = RIBBON_SIZE) +
    ggplot2::scale_alpha_identity() +
    ggplot2::geom_point(data = s2_adm, ggplot2::aes(x = k_total, y = neg2logL),
                        alpha = CLOUD_ALPHA, color = CLOUD_COLOR,
                        size = CLOUD_SIZE) +
    ggplot2::geom_line(data = envelope,
                       ggplot2::aes(x = k_total, y = neg2logL),
                       color = ENVL_COLOR, linewidth = ENVL_LW) +
    ggplot2::geom_point(data = s2_omega,
                        ggplot2::aes(x = k_total, y = neg2logL),
                        color = FRONT_COLOR, size = FRONT_SIZE,
                        alpha = FRONT_ALPHA) +
    ggplot2::geom_rug(data = s2_adm, ggplot2::aes(x = k_total, y = neg2logL),
                      alpha = RUG_ALPHA, length = RUG_LENGTH,
                      color = "grey50", sides = "bl") +
    ggplot2::annotate("text", x = Inf, y = Inf,
                      label = paste0("n = ", nrow(s2_omega), " specs"),
                      hjust = 1.1, vjust = 1.5, size = 2.8, color = "grey40")

  if (nrow(s2_omega) <= 20) {
    p <- p + ggrepel::geom_text_repel(
      data = s2_omega,
      ggplot2::aes(x = k_total, y = neg2logL, label = spec_label),
      size = REPEL_SIZE, color = "grey30",
      segment.color = REPEL_SEG_COLOR, segment.size = REPEL_SEG_LW,
      max.overlaps = 25, box.padding = 0.4, force = 2,
      min.segment.length = 0.1, seed = REPEL_SEED
    )
  }

  p + scale_x_k(s2_adm$k_total) +
    ggplot2::labs(
      x = expression(italic(k)(m)),
      y = expression(-2 ~ log ~ italic(L)(m))
    ) +
    theme_ch3()
}


# ---- 7g. S2 supplementary figures ----

#' S2-supp-a: theta (beta_k) distribution across Omega_20, by m
#' Handles sparse data: density for groups with >=2 obs, points for singletons.
build_fig_S2_theta_dist <- function(s2_m2_o, s2_m3_o, theta_m0 = 0.6609) {
  parts <- list()
  if (nrow(s2_m2_o) > 0) parts[[1]] <- data.frame(theta = s2_m2_o$theta_hat, m = "m = 2", stringsAsFactors = FALSE)
  if (nrow(s2_m3_o) > 0) parts[[2]] <- data.frame(theta = s2_m3_o$theta_hat, m = "m = 3", stringsAsFactors = FALSE)
  df <- do.call(rbind, parts)
  df <- df[is.finite(df$theta), ]

  # Split into groups with enough data for density vs singletons
  grp_n <- table(df$m)
  df_dense  <- df[df$m %in% names(grp_n[grp_n >= 2]), , drop = FALSE]
  df_sparse <- df[df$m %in% names(grp_n[grp_n <  2]), , drop = FALSE]

  p <- ggplot2::ggplot()

  if (nrow(df_dense) > 0) {
    p <- p + ggplot2::geom_density(
      data = df_dense, ggplot2::aes(x = theta, fill = m),
      alpha = 0.35, color = NA
    )
  }

  if (nrow(df_sparse) > 0) {
    p <- p + ggplot2::geom_point(
      data = df_sparse, ggplot2::aes(x = theta, y = 0, color = m),
      size = 3, shape = 18
    ) +
    ggplot2::scale_color_manual(values = c("m = 2" = PAL_OI["skyblue"],
                                            "m = 3" = PAL_OI["green"]))
  }

  p + ggplot2::scale_fill_manual(values = c("m = 2" = PAL_OI["skyblue"],
                                              "m = 3" = PAL_OI["green"])) +
    ggplot2::geom_vline(xintercept = theta_m0, linetype = "dashed",
                        color = PAL_OI["vermillion"], linewidth = 0.5) +
    ggplot2::annotate("text", x = theta_m0, y = Inf,
                      label = expression(hat(theta)[m0]),
                      hjust = -0.3, vjust = 1.5, size = 3,
                      color = PAL_OI["vermillion"]) +
    ggplot2::labs(x = expression(hat(theta)), y = "Density") +
    theme_ch3()
}

#' S2-supp-b: Utilization band — two-panel m=2 vs m=3
build_fig_S2_u_band <- function(s2_m2_uband, s2_m3_uband) {
  s2_m2_uband$m <- "m = 2"
  s2_m3_uband$m <- "m = 3"
  df <- rbind(s2_m2_uband, s2_m3_uband)

  ggplot2::ggplot(df, ggplot2::aes(x = year)) +
    ggplot2::geom_ribbon(ggplot2::aes(ymin = u_lower, ymax = u_upper),
                          fill = PAL_OI["skyblue"], alpha = 0.25) +
    ggplot2::geom_line(ggplot2::aes(y = u_med), color = PAL_OI["blue"],
                       linewidth = 0.6) +
    ggplot2::geom_line(ggplot2::aes(y = u_shaikh), color = "black",
                       linetype = "dashed", linewidth = 0.4) +
    ggplot2::geom_hline(yintercept = 1, color = "grey60", linewidth = 0.2) +
    ggplot2::facet_wrap(~ m, nrow = 1) +
    ggplot2::labs(x = NULL, y = "u") +
    theme_ch3()
}

#' S2-supp-c: Alpha heatmap
build_fig_S2_alpha_heatmap <- function(s2_m2_o, s2_m3_o) {
  if (nrow(s2_m2_o) > 0) {
    rows_m2 <- data.frame(
      spec = paste0("m2:", s2_m2_o$spec_id),
      alpha_y = s2_m2_o$alpha_y,
      alpha_k = s2_m2_o$alpha_k,
      stringsAsFactors = FALSE
    )
  } else {
    rows_m2 <- data.frame(spec = character(), alpha_y = numeric(), alpha_k = numeric(),
                           stringsAsFactors = FALSE)
  }
  alpha_cols <- c("alpha_y", "alpha_k")
  if ("alpha_e" %in% names(s2_m3_o)) {
    rows_m3 <- data.frame(
      spec = paste0("m3:", s2_m3_o$spec_id),
      alpha_y = s2_m3_o$alpha_y,
      alpha_k = s2_m3_o$alpha_k,
      alpha_e = s2_m3_o$alpha_e,
      stringsAsFactors = FALSE
    )
    alpha_cols <- c("alpha_y", "alpha_k", "alpha_e")
  } else {
    rows_m3 <- data.frame(
      spec = paste0("m3:", s2_m3_o$spec_id),
      alpha_y = s2_m3_o$alpha_y,
      alpha_k = s2_m3_o$alpha_k,
      stringsAsFactors = FALSE
    )
  }

  # Pad missing columns (only for non-empty frames)
  for (col in alpha_cols) {
    if (nrow(rows_m2) > 0 && !col %in% names(rows_m2)) rows_m2[[col]] <- NA_real_
    if (nrow(rows_m3) > 0 && !col %in% names(rows_m3)) rows_m3[[col]] <- NA_real_
  }
  # Ensure both have all alpha_cols for rbind
  for (col in alpha_cols) {
    if (!col %in% names(rows_m2)) rows_m2[[col]] <- numeric(0)
    if (!col %in% names(rows_m3)) rows_m3[[col]] <- numeric(0)
  }

  df <- rbind(rows_m2[, c("spec", alpha_cols)],
              rows_m3[, c("spec", alpha_cols)])

  long <- tidyr::pivot_longer(df, cols = dplyr::all_of(alpha_cols),
                               names_to = "variable", values_to = "value")
  long$variable <- gsub("alpha_", "\u03B1_", long$variable)

  ggplot2::ggplot(long, ggplot2::aes(x = variable, y = spec, fill = value)) +
    ggplot2::geom_tile(color = "white", linewidth = 0.3) +
    ggplot2::scale_fill_gradient2(low = PAL_OI["blue"], mid = "white",
                                  high = PAL_OI["vermillion"], midpoint = 0,
                                  name = expression(alpha)) +
    ggplot2::labs(x = NULL, y = NULL) +
    theme_ch3() +
    ggplot2::theme(
      axis.text.y = ggplot2::element_text(size = 6),
      legend.position = "right"
    )
}


# ---- 7g-bis. S2 bundled cross-dimensional figures ----

# Color palette for (m, r) groups
MR_COLORS <- c(
  "m2_r1" = unname(PAL_OI["skyblue"]),
  "m3_r1" = unname(PAL_OI["green"]),
  "m3_r2" = unname(PAL_OI["purple"])
)
MR_SHAPES <- c("m2_r1" = 16L, "m3_r1" = 17L, "m3_r2" = 18L)
MR_LABELS <- c("m2_r1" = "m=2, r=1", "m3_r1" = "m=3, r=1", "m3_r2" = "m=3, r=2")

#' S2-bundle-a: Pooled fit-complexity frontier across system dimensions.
#' Uses normalized neg2logL = neg2logL / (m * T_eff) for cross-m comparison.
build_fig_S2_pooled_frontier <- function(pooled_adm, pooled_omega) {
  # Envelope on normalized values — extract_envelope_proto needs logLik column
  env_df <- data.frame(
    k_total  = pooled_adm$k_total,
    logLik   = -pooled_adm$neg2logL_norm / 2,
    neg2logL = pooled_adm$neg2logL_norm
  )
  envelope <- extract_envelope_proto(env_df)

  pooled_omega$spec_label <- vecm_label(pooled_omega, include_r = TRUE)

  p <- ggplot2::ggplot(pooled_adm,
                        ggplot2::aes(x = k_total, y = neg2logL_norm)) +
    ggplot2::geom_point(ggplot2::aes(color = mr_group),
                        alpha = 0.35, size = CLOUD_SIZE + 0.3) +
    ggplot2::geom_line(data = envelope,
                       ggplot2::aes(x = k_total, y = neg2logL),
                       color = ENVL_COLOR, linewidth = ENVL_LW) +
    ggplot2::geom_point(data = pooled_omega,
                        ggplot2::aes(x = k_total, y = neg2logL_norm),
                        color = FRONT_COLOR, size = FRONT_SIZE,
                        alpha = FRONT_ALPHA) +
    ggplot2::geom_rug(alpha = RUG_ALPHA, length = RUG_LENGTH,
                      color = "grey50", sides = "bl") +
    ggplot2::scale_color_manual(values = MR_COLORS, labels = MR_LABELS,
                                name = NULL) +
    ggplot2::annotate("text", x = Inf, y = Inf,
                      label = paste0("n = ", nrow(pooled_omega), " specs"),
                      hjust = 1.1, vjust = 1.5, size = 2.8, color = "grey40")

  if (nrow(pooled_omega) <= 20) {
    p <- p + ggrepel::geom_text_repel(
      data = pooled_omega,
      ggplot2::aes(x = k_total, y = neg2logL_norm, label = spec_label),
      size = REPEL_SIZE, color = "grey30",
      segment.color = REPEL_SEG_COLOR, segment.size = REPEL_SEG_LW,
      max.overlaps = 25, box.padding = 0.4, force = 2,
      min.segment.length = 0.1, seed = REPEL_SEED
    )
  }

  p + scale_x_k(pooled_adm$k_total) +
    ggplot2::labs(
      x = expression(italic(k)(m)),
      y = expression(frac(-2 ~ log ~ italic(L), m %.% T[eff]))
    ) +
    theme_ch3() +
    ggplot2::theme(legend.position = "bottom")
}

#' S2-bundle-b: Rank dominance dot chart — which (m,r) wins under each IC.
build_fig_S2_rank_dominance <- function(winner_table) {
  # Expects columns: ic, variant, winner_mr, ic_value, theta_hat
  winner_table$ic <- factor(winner_table$ic, levels = rev(IC_NAMES))
  winner_table$variant <- factor(winner_table$variant,
                                  levels = c("within_m2", "within_m3",
                                             "normalized", "per_equation"))

  ggplot2::ggplot(winner_table,
                  ggplot2::aes(x = variant, y = ic,
                               color = winner_mr, shape = winner_mr)) +
    ggplot2::geom_point(size = 4) +
    ggplot2::scale_color_manual(values = MR_COLORS, labels = MR_LABELS,
                                name = "Winner") +
    ggplot2::scale_shape_manual(values = MR_SHAPES, labels = MR_LABELS,
                                name = "Winner") +
    ggplot2::scale_x_discrete(labels = c(
      "within_m2"   = "Within m=2",
      "within_m3"   = "Within m=3",
      "normalized"  = "Normalized",
      "per_equation" = "Per-equation"
    )) +
    ggplot2::labs(x = NULL, y = NULL) +
    theme_ch3() +
    ggplot2::theme(legend.position = "bottom",
                   panel.grid.major.x = ggplot2::element_line(
                     color = "grey90", linewidth = 0.3))
}

#' S2-bundle-c: Theta distribution faceted by (m, r) group.
build_fig_S2_theta_by_mr <- function(pooled_omega, theta_m0 = 0.6609) {
  df <- pooled_omega[is.finite(pooled_omega$theta_hat), ]
  if (nrow(df) == 0) return(NULL)

  df$mr_label <- MR_LABELS[as.character(df$mr_group)]
  df$mr_label <- factor(df$mr_label,
                         levels = c("m=2, r=1", "m=3, r=1", "m=3, r=2"))

  # Per-group counts for stat annotations
  grp_stats <- df %>%
    dplyr::group_by(mr_label) %>%
    dplyr::summarise(
      n   = dplyr::n(),
      mu  = mean(theta_hat),
      rng = paste0("[", round(min(theta_hat), 3), ", ",
                   round(max(theta_hat), 3), "]"),
      .groups = "drop"
    )
  grp_stats$stat_label <- sprintf("n=%d  mean=%.3f  %s",
                                   grp_stats$n, grp_stats$mu, grp_stats$rng)

  # Split dense (>=2) vs sparse (<2) groups
  grp_n <- table(df$mr_label)
  df_dense  <- df[df$mr_label %in% names(grp_n[grp_n >= 2]), , drop = FALSE]
  df_sparse <- df[df$mr_label %in% names(grp_n[grp_n <  2]), , drop = FALSE]

  p <- ggplot2::ggplot()

  if (nrow(df_dense) > 0) {
    p <- p + ggplot2::geom_density(
      data = df_dense,
      ggplot2::aes(x = theta_hat, fill = mr_label),
      alpha = 0.40, color = NA
    ) +
    ggplot2::geom_rug(
      data = df_dense,
      ggplot2::aes(x = theta_hat),
      alpha = 0.25, length = grid::unit(0.03, "npc"),
      sides = "b", color = "grey40"
    )
  }

  if (nrow(df_sparse) > 0) {
    p <- p + ggplot2::geom_point(
      data = df_sparse,
      ggplot2::aes(x = theta_hat, y = 0, color = mr_label),
      size = 3, shape = 18
    ) +
    ggplot2::scale_color_manual(
      values = c("m=2, r=1" = unname(PAL_OI["skyblue"]),
                 "m=3, r=1" = unname(PAL_OI["green"]),
                 "m=3, r=2" = unname(PAL_OI["purple"])),
      guide = "none"
    )
  }

  p <- p +
    ggplot2::geom_vline(xintercept = theta_m0, linetype = "dashed",
                        color = unname(PAL_OI["vermillion"]), linewidth = 0.5) +
    ggplot2::scale_fill_manual(
      values = c("m=2, r=1" = unname(PAL_OI["skyblue"]),
                 "m=3, r=1" = unname(PAL_OI["green"]),
                 "m=3, r=2" = unname(PAL_OI["purple"])),
      guide = "none"
    ) +
    ggplot2::facet_wrap(~ mr_label, nrow = 1, scales = "free_y",
                        drop = FALSE) +
    ggplot2::geom_text(
      data = grp_stats,
      ggplot2::aes(x = Inf, y = Inf, label = stat_label),
      hjust = 1.05, vjust = 1.5, size = 2.2, color = "grey40",
      inherit.aes = FALSE
    ) +
    ggplot2::labs(x = expression(hat(theta)), y = "Density") +
    theme_ch3()

  p
}


# ---- 7h. Cross-stage synthesis ----

#' Combined fit-complexity plane: S0 seed + S1 ARDL cloud + S2 VECM cloud
build_fig_cross_synthesis <- function(s1_adm, s2_m2_a, s2_m3_a, m0_row) {
  s1_plot <- data.frame(k_total = s1_adm$k_total,
                        neg2logL = s1_adm$neg2logL,
                        stage = "S1: ARDL", stringsAsFactors = FALSE)
  s2_parts <- list()
  if (nrow(s2_m2_a) > 0) s2_parts[[1]] <- data.frame(k_total = s2_m2_a$k_total, neg2logL = s2_m2_a$neg2logL, stage = "S2: VECM m=2", stringsAsFactors = FALSE)
  if (nrow(s2_m3_a) > 0) s2_parts[[2]] <- data.frame(k_total = s2_m3_a$k_total, neg2logL = s2_m3_a$neg2logL, stage = "S2: VECM m=3", stringsAsFactors = FALSE)
  s2_plot <- do.call(rbind, s2_parts)
  all_data <- rbind(s1_plot, s2_plot)

  p <- ggplot2::ggplot(all_data, ggplot2::aes(x = k_total, y = neg2logL,
                                                color = stage)) +
    ggplot2::geom_point(alpha = 0.3, size = 1.5) +
    ggplot2::scale_color_manual(
      values = c("S1: ARDL"     = PAL_OI["skyblue"],
                 "S2: VECM m=2" = PAL_OI["green"],
                 "S2: VECM m=3" = PAL_OI["purple"])
    )

  if (!is.null(m0_row) && nrow(m0_row) > 0) {
    m0_df <- data.frame(k_total = m0_row$k_total[1],
                        neg2logL = m0_row$neg2logL[1])
    p <- p +
      ggplot2::geom_point(data = m0_df,
                          ggplot2::aes(x = k_total, y = neg2logL),
                          shape = M0_SHAPE, size = M0_SIZE,
                          color = M0_COLOR, inherit.aes = FALSE) +
      ggrepel::geom_text_repel(
        data = m0_df,
        ggplot2::aes(x = k_total, y = neg2logL),
        label = expression(m[0]),
        size = 3, color = M0_COLOR,
        nudge_x = 1, nudge_y = 3,
        segment.color = REPEL_SEG_COLOR, segment.size = REPEL_SEG_LW,
        seed = REPEL_SEED, inherit.aes = FALSE
      )
  }

  p + scale_x_k(all_data$k_total) +
    ggplot2::labs(
      x = expression(italic(k)(m)),
      y = expression(-2 ~ log ~ italic(L)(m))
    ) +
    theme_ch3()
}


# ============================================================
# END 99_figure_protocol.R
# ============================================================
