# MSTclust population structure metrics visualization + allelic pairwise mismatch calculation/visualization

# ==== 0. LIBRARIES AND SETTINGS ====
library(tidyverse)
library(ggplot2)
library(parallel)
library(scales) # for rescale()

set.seed(123)

# ==== 1. LOAD & PREPARE SILHOUETTE/STABILITY DATA ====
# Read summary metrics (assumed 1 row per allelic cutoff)
silhouette_data <- read_csv("data/MSTclust_Corynebacterium_diphtheriae_metrics_summary.csv"). #MSTclust metricss output (Additional_file Delgado-Blas et al.)

# Prepare both curves (as tidy data frame)
curve_df <- bind_rows(
  silhouette_data %>%
    transmute(
      mismatches = `allelic mismatches`,
      value = silhouette,
      low = `noise silhouette low`,
      up = `noise silhouette up`,
      type = "Consistency coefficient St"
    ),
  silhouette_data %>%
    transmute(
      mismatches = `allelic mismatches`,
      value = `noise aWallace2 av`,
      low = `noise aWallace2 low`,
      up = `noise aWallace2 up`,
      type = "Stability coefficient Wt"
    )
)

# ==== 2. CALCULATE PAIRWISE ALLELIC DIFFERENCES ====
# Read cgMLST profiles table (1st column: genome, others: loci)
profile_mat <- read_csv("data/Corynebacterium_diphtheriae_cgMLST_allelic_profiles.csv", col_types = cols()) #cgMLST allelic profiles from BIGSdb-Pasteur project DelgadoBlas_LINcodes_2025
loci_data <- profile_mat[-1] # drop genome ID column

# All unique pairs of genomes (as indices)
pairs <- combn(seq_len(nrow(loci_data)), 2, simplify = FALSE)

# Function for allelic differences between two profiles
allelic_diff <- function(pair) {
  sum(loci_data[pair[1], ] != loci_data[pair[2], ] &
        !is.na(loci_data[pair[1], ]) & !is.na(loci_data[pair[2], ]), na.rm = TRUE)
}

# Parallel calculation of all pairwise differences
cat("Calculating pairwise mismatches ...\n")
cl <- makeCluster(max(1, detectCores() - 1))
clusterExport(cl, c("loci_data"))
all_mismatches <- parSapply(cl, pairs, allelic_diff)
stopCluster(cl)

mismatches_tbl <- tibble(mismatches = all_mismatches)
cat(length(all_mismatches), "pairwise comparisons processed.\n")

# ==== 3. GENERATE SUPERIMPOSED PLOT ====

# Calculate density for right axis scaling
dens <- density(mismatches_tbl$mismatches, from = 0, to = 1305, n = 512)
# 2. Set right axis max as requested
density_max <- 0.02
# Rescale functions for overlaying density/histogram to [0, 1] left y scale
to_left_scale <- function(x) rescale(x, to = c(0, 1), from = c(0, density_max))
to_right_scale <- function(x) rescale(x, to = c(0, density_max), from = c(0, 1))

# Main plot: histogram and density first, then ribbon and lines for clarity
p <- ggplot() +
  # -- Histogram/density first (right y, rescaled)
  geom_histogram(data = mismatches_tbl,
                 aes(x = mismatches, y = to_left_scale(..density..)),
                 bins = 1305, fill = "#22577a", color = "#22577a", alpha = 0.6,
                 inherit.aes = FALSE) +
  geom_density(data = mismatches_tbl,
               aes(x = mismatches, y = to_left_scale(..density..)),
               fill = "#55dde0", alpha = 0.6, linetype = 0, inherit.aes = FALSE) +
  
  # -- (3) Put ribbon/curves on top (left y)
  geom_ribbon(data = curve_df,
              aes(x = mismatches, ymin = low, ymax = up, fill = type),
              alpha = 0.25) +
  geom_line(data = curve_df,
            aes(x = mismatches, y = value, color = type),
            size = 0.6) +  # (1) Thinner lines
  
  scale_color_manual(
    values = c("Consistency coefficient St" = "#38a3a5",
               "Stability coefficient Wt" = "#80ed99"),
    name = NULL
  ) +
  scale_fill_manual(
    values = c("Consistency coefficient St" = "#38a3a5",
               "Stability coefficient Wt" = "#80ed99"),
    name = NULL
  ) +
  scale_x_continuous(
    breaks = seq(0, 1305, by = 100), limits = c(0, 1305)
  ) +
  scale_y_continuous(
    name = "Silhouette / Stability coefficient",
    limits = c(0, 1),
    sec.axis = sec_axis(trans = to_right_scale,
                        name = "Density (pairwise allelic mismatches)",
                        breaks = seq(0, density_max, by = 0.005),
                        labels = scales::number_format(accuracy = 0.001))
  ) +
  xlab("Allelic mismatches") +
  theme_light() +
  theme(
    panel.background = element_rect(fill = 'transparent'),
    plot.background = element_rect(fill = 'transparent', color = NA),
    panel.grid.minor = element_blank(),
    legend.background = element_rect(fill = 'transparent'),
    legend.box.background = element_rect(fill = 'transparent'),
    axis.title.y.right = element_text(color = "#22577a"),
    axis.text.y.right = element_text(color = "#22577a")
  )

print(p)

# Optionally save the plot:
ggsave(
  filename = "MSTclust_metrics_pairwise_allelic_mismatches_plot.png",
  plot = p,
  path = "output",
  width = 10, height = 7, dpi = 300,
  bg = "transparent"
)

cat("Plot saved as output/MSTclust_metrics_pairwise_allelic_mismatches_plot.png\n")
