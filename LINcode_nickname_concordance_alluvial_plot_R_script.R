# Alluvial Plot of LIN Code Taxonomic Concordance

# 1. Load / Install required packages -------------------------
required_packages <- c("ggalluvial", "ggplot2", "dplyr", "readr", "viridis")
for(p in required_packages) {
  if(!requireNamespace(p, quietly = TRUE)) install.packages(p)
}
invisible(lapply(packages, library, character.only = TRUE))

# 2. Ensure reproducibility -----------------------------------
set.seed(123)

# 3. Input data file (using relative path) --------------------
data_file <- "data/Figure_2_LINcode_taxonomic_level_data.csv"

if(!file.exists(data_file)){
  stop(paste("File", data_file, "not found. Please place it in the 'data/' folder."))
}

levels <- read_csv(data_file)

# 4. Prepare data ---------------------------------------------

# Count frequency of each unique path through the hierarchy
levels_freq <- levels %>%
  group_by(Species, Lineage, Sublineage, ST, Clonal_group, Genetic_cluster) %>%
  summarise(Freq = n(), .groups = 'drop')

# Helper: Get categories with sufficient size for labels 
cat_threshold <- 30

get_major_categories <- function(df, var) {
  df %>%
    group_by({{var}}) %>%
    summarise(TotalFreq = sum(Freq), .groups = 'drop') %>%
    filter(TotalFreq >= cat_threshold) %>%
    pull({{var}})
}

filtered_Species <- get_major_categories(levels_freq, Species)
filtered_Lineage <- get_major_categories(levels_freq, Lineage)
filtered_Sublineage <- get_major_categories(levels_freq, Sublineage)
filtered_ST <- get_major_categories(levels_freq, ST)
filtered_Clonal_group <- get_major_categories(levels_freq, Clonal_group)
filtered_Genetic_cluster <- get_major_categories(levels_freq, Genetic_cluster)

# Set up label columns
levels_freq <- levels_freq %>%
  mutate(
    Label1 = ifelse(Species %in% filtered_Species, as.character(Species), ""),
    Label2 = ifelse(Lineage %in% filtered_Lineage, as.character(Lineage), ""),
    Label3 = ifelse(Sublineage %in% filtered_Sublineage, as.character(Sublineage), ""),
    Label4 = ifelse(ST %in% filtered_ST, as.character(ST), ""),
    Label5 = ifelse(Clonal_group %in% filtered_Clonal_group, as.character(Clonal_group), ""),
    Label6 = ifelse(Genetic_cluster %in% filtered_Genetic_cluster, as.character(Genetic_cluster), "")
  )

# Ensure levels are ordered by frequency for visual consistency
make_ordered <- function(df, var) {
  levels_order <- df %>% 
    group_by({{var}}) %>% 
    summarise(TotalFreq = sum(Freq), .groups = 'drop') %>%
    arrange(desc(TotalFreq)) %>%
    pull({{var}})
  factor(df[[deparse(substitute(var))]], levels = levels_order)
}

levels_freq <- levels_freq %>%
  mutate(
    Species = make_ordered(levels_freq, Species),
    Lineage = make_ordered(levels_freq, Lineage),
    Sublineage = make_ordered(levels_freq, Sublineage),
    ST = make_ordered(levels_freq, ST),
    Clonal_group = make_ordered(levels_freq, Clonal_group),
    Genetic_cluster = make_ordered(levels_freq, Genetic_cluster)
  )

# Set custom color palettes per hierarchy
levels_cat1 <- sort(unique(levels_freq$Species))
levels_cat2 <- sort(unique(levels_freq$Lineage))
levels_cat3 <- sort(unique(levels_freq$Sublineage))
levels_cat4 <- sort(unique(levels_freq$ST))
levels_cat5 <- sort(unique(levels_freq$Clonal_group))
levels_cat6 <- sort(unique(levels_freq$Genetic_cluster))

palette_cat1 <- viridis::viridis(length(levels_cat1), option = "A")
palette_cat2 <- viridis::viridis(length(levels_cat2), option = "B")
palette_cat3 <- viridis::viridis(length(levels_cat3), option = "C")
palette_cat4 <- viridis::viridis(length(levels_cat4), option = "D")
palette_cat5 <- viridis::viridis(length(levels_cat5), option = "E")
palette_cat6 <- viridis::viridis(length(levels_cat6), option = "F")

colors_cat1 <- setNames(palette_cat1, levels_cat1)
colors_cat2 <- setNames(palette_cat2, levels_cat2)
colors_cat3 <- setNames(palette_cat3, levels_cat3)
colors_cat4 <- setNames(palette_cat4, levels_cat4)
colors_cat5 <- setNames(palette_cat5, levels_cat5)
colors_cat6 <- setNames(palette_cat6, levels_cat6)

levels_freq <- levels_freq %>%
  mutate(
    Fill1 = colors_cat1[as.character(Species)],
    Fill2 = colors_cat2[as.character(Lineage)],
    Fill3 = colors_cat3[as.character(Sublineage)],
    Fill4 = colors_cat4[as.character(ST)],
    Fill5 = colors_cat5[as.character(Clonal_group)],
    Fill6 = colors_cat6[as.character(Genetic_cluster)]
  )

# 5. Create the alluvial plot ----------------------------------

alluvial_plot <- ggplot(
  data = levels_freq,
  aes(
    axis1 = Species,
    axis2 = Lineage,
    axis3 = Sublineage,
    axis4 = ST,
    axis5 = Clonal_group,
    axis6 = Genetic_cluster,
    y = Freq
  )) +
  geom_alluvium(aes(fill = Fill1), width = 1/12, curve_type = "sigmoid") +
  geom_stratum(width = 1/20, color = "black") +
  geom_alluvium(aes(fill = Fill2), width = 1/12, curve_type = "sigmoid") +
  geom_stratum(width = 1/20, color = "black") +
  geom_alluvium(aes(fill = Fill3), width = 1/12, curve_type = "sigmoid") +
  geom_stratum(width = 1/20, color = "black") +
  geom_alluvium(aes(fill = Fill4), width = 1/12, curve_type = "sigmoid") +
  geom_stratum(width = 1/20, color = "black") +
  geom_alluvium(aes(fill = Fill5), width = 1/12, curve_type = "sigmoid") +
  geom_stratum(width = 1/20, color = "black") +
  geom_alluvium(aes(fill = Fill6), width = 1/12, curve_type = "sigmoid") +
  geom_stratum(width = 1/20, color = "black") +
  geom_text(aes(x = 1, stratum = Species, label = Label1), stat = "stratum", size = 4, vjust = 0.5, hjust = 1.3, fontface = "italic") +
  geom_text(aes(x = 2, stratum = Lineage, label = Label2), stat = "stratum", size = 3, vjust = 0.5, hjust = 1.3, color = "white") +
  geom_text(aes(x = 3, stratum = Sublineage, label = Label3), stat = "stratum", size = 2.5, vjust = 0.5, hjust = 1.3, color = "white") +
  geom_text(aes(x = 4, stratum = ST, label = Label4), stat = "stratum", size = 2.5, vjust = 0.5, hjust = 1.3, color = "white") +
  geom_text(aes(x = 5, stratum = Clonal_group, label = Label5), stat = "stratum", size = 2.5, vjust = 0.5, hjust = 1.3, color = "white") +
  geom_text(aes(x = 6, stratum = Genetic_cluster, label = Label6), stat = "stratum", size = 2.5, vjust = 0.5, hjust = 1.3, color = "white") +
  scale_x_discrete(
    limits = c("Species", "Lineage", "Sublineage", "ST", "Clonal group", "Genetic cluster"),
    expand = c(0.15, 0.05)) +
  scale_fill_identity() +
  ggtitle("Taxonomic level correlations") +
  theme_minimal() +
  theme(
    legend.position = "none",
    axis.text = element_text(size = 10),
    axis.title = element_blank(),
    panel.background = element_rect(fill = "white", color = "white"),
    plot.background = element_rect(fill = "white", color = NA)
  )

# 6. Display on screen and save to file -----------------------
print(Figure_2_alluvial_plot)
# Save output (optional):
# ggsave("output/Figure_2_LINcode_alluvial_plot.png", alluvial_plot, width = 12, height = 8, dpi = 600)