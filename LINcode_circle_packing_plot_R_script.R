#LIN code Hierarchical Circle Packing Plot

# 1. Load Required Libraries ---------------------------------------------------
packages <- c("ggraph", "igraph", "tidyverse", "viridis", "ggrepel")

installed <- rownames(installed.packages())
for(p in packages) {
  if(!(p %in% installed)) install.packages(p)
}
invisible(lapply(packages, library, character.only = TRUE))

# 2. Set Seed for Reproducibility ---------------------------------------------
set.seed(1234)

# 3. File Input: Provide Relative Path -----------------------------------------
# Place your input CSV file in a folder called "data" in your project directory
data_file <- "data/Figure_1_population_structure_LINcode_data.csv"
if(!file.exists(data_file)){
  stop("Input file not found. Please add your CSV to the 'data' folder.")
}

# 4. Read LIN Code Data -------------------------------------------------------
data <- read.csv(data_file, header = FALSE, stringsAsFactors = FALSE)
colnames(data) <- c("code")

# 5. Parse Hierarchical LIN Codes ---------------------------------------------
parse_code <- function(code) {
  levels <- strsplit(code, "_")[[1]]
  levels <- as.numeric(levels)
  return(levels)
}

data <- data %>%
  mutate(levels = map(code, parse_code)) %>%
  unnest_wider(levels, names_sep = "_")

# 6. Aggregate Counts at Each Level -------------------------------------------
aggregate_counts <- function(data) {
  n_levels <- ncol(data) - 1
  counts <- data.frame()
  for (i in 1:n_levels) {
    level_cols <- paste0("levels_", 1:i)
    count_data <- data %>%
      group_by(across(all_of(level_cols))) %>%
      summarise(count = n(), .groups = 'drop') %>%
      mutate(level = i) %>%
      unite("name", all_of(level_cols), sep = "_", remove = FALSE)
    counts <- bind_rows(counts, count_data)
  }
  return(counts)
}
counts <- aggregate_counts(data)

# 7. Prepare for Hierarchical Visualization -----------------------------------
edges <- counts %>%
  mutate(parent = str_remove(name, "_[^_]+$")) %>%
  mutate(parent = if_else(parent == "", NA_character_, parent)) %>%
  select(parent, name)

vertices <- counts %>%
  select(name, count, level) %>%
  rename(size = count)

# 8. Construct Graph Object ---------------------------------------------------
mygraph <- graph_from_data_frame(edges, vertices = vertices)

# 9. Create Layout for ggraph -------------------------------------------------
layout <- create_layout(mygraph, layout = 'circlepack', weight = size)

# 10. Plot Circle Packing Visualization ---------------------------------------
plot <- ggraph(layout) +
  geom_node_circle(aes(fill = as.factor(level))) +
  geom_text_repel(aes(x = x, y = y, label = ifelse(level %in% 2:5 & size >= 30, name, "")),
                  color = "white",
                  size = 4,
                  max.overlaps = Inf) +
  theme_void() +
  scale_fill_viridis(discrete = TRUE, option = "F") +
  labs(fill = "LINcode level")

# 11. Display Plot and Optionally Save ----------------------------------------
print(plot)
# Optionally save the plot:
# ggsave("output/LINcode_circle_packing_plot.png", plot, width = 11, height = 9, dpi = 600)












