## 10-level LIN code Prefix-based Alluvial Plot

# 1. Load Required Libraries ---------------------------------------------------
packages <- c("ggalluvial", "ggplot2", "dplyr", "readr", "viridis")
installed <- rownames(installed.packages())
for(p in packages) if(!(p %in% installed)) install.packages(p)
invisible(lapply(packages, library, character.only = TRUE))

# 2. Set Seed for Reproducibility ---------------------------------------------
set.seed(1234)

# 3. Set File Paths -----------------------------------------------------------
data_file   <- "data/Figure_4B_SL8_LINcode_data.csv"
output_plot <- "output/LINcode_10level_alluvial_plot.png"
if(!file.exists(data_file)) stop("Input file not found. Please add your CSV to the 'data' folder.")
if(!dir.exists("output")) dir.create("output", showWarnings=FALSE)

# 4. Read Input LIN Code Data -------------------------------------------------
raw <- read_csv(data_file, col_names = FALSE, show_col_types = FALSE)
colnames(raw) <- "LINcode"

# 5. Decompose Each LINcode into Cumulative Prefixes --------------------------
get_prefixes <- function(lincode_str) {
  parts <- strsplit(trimws(lincode_str), "_")[[1]]
  if(length(parts) != 10) stop("LINcode does not have 10 fields: ", lincode_str)
  sapply(seq_along(parts), function(i) paste(parts[1:i], collapse="_"))
}
prefixes <- t(sapply(raw$LINcode, get_prefixes))
colnames(prefixes) <- paste0("Level_", 1:10)
df <- as.data.frame(prefixes, stringsAsFactors = FALSE)

# 6. Count frequencies for each unique path ------------------------------------
agg <- df %>% count(across(everything()), name="Freq")

# 7. Order each level's partitions by frequency (largest first) ----------------
for(i in 1:10) {
  lv <- paste0("Level_", i)
  lv_order <- agg %>% group_by(.data[[lv]]) %>% summarise(n=sum(Freq), .groups="drop") %>%
    arrange(desc(n)) %>% pull(1)
  agg[[lv]] <- factor(agg[[lv]], levels=lv_order)
}

# 8. Assign palette fill colors per level --------------------------------------
pal_opts <- LETTERS[1:10]
for(i in 1:10) {
  lv <- paste0("Level_", i)
  lv_levs <- levels(agg[[lv]])
  pal <- viridis::viridis(length(lv_levs), option=pal_opts[i])
  names(pal) <- lv_levs
  agg[[paste0("Fill", i)]] <- pal[as.character(agg[[lv]])]
}

# 9. Label only categories >= threshold ----------------------------------------
label_threshold <- 10
for(i in 1:10) {
  lv <- paste0("Level_", i)
  table_lv <- table(agg[[lv]])
  label_lv <- ifelse(agg[[lv]] %in% names(table_lv[table_lv >= label_threshold]), as.character(agg[[lv]]), "")
  agg[[paste0("Label", i)]] <- label_lv
}

# 10. Plot Alluvial Visualization ----------------------------------------------
plot <- ggplot(agg, aes(
  axis1=Level_1, axis2=Level_2, axis3=Level_3, axis4=Level_4, axis5=Level_5,
  axis6=Level_6, axis7=Level_7, axis8=Level_8, axis9=Level_9, axis10=Level_10, y=Freq)) +
  
  geom_alluvium(aes(fill=Fill1), width=1/12, curve_type="sigmoid", alpha=0.9) + geom_stratum(width=1/20, color="black") +
  geom_alluvium(aes(fill=Fill2), width=1/12, curve_type="sigmoid", alpha=0.8) + geom_stratum(width=1/20, color="black") +
  geom_alluvium(aes(fill=Fill3), width=1/12, curve_type="sigmoid", alpha=0.75) + geom_stratum(width=1/20, color="black") +
  geom_alluvium(aes(fill=Fill4), width=1/12, curve_type="sigmoid", alpha=0.7) + geom_stratum(width=1/20, color="black") +
  geom_alluvium(aes(fill=Fill5), width=1/12, curve_type="sigmoid", alpha=0.65) + geom_stratum(width=1/20, color="black") +
  geom_alluvium(aes(fill=Fill6), width=1/12, curve_type="sigmoid", alpha=0.6) + geom_stratum(width=1/20, color="black") +
  geom_alluvium(aes(fill=Fill7), width=1/12, curve_type="sigmoid", alpha=0.55) + geom_stratum(width=1/20, color="black") +
  geom_alluvium(aes(fill=Fill8), width=1/12, curve_type="sigmoid", alpha=0.5) + geom_stratum(width=1/20, color="black") +
  geom_alluvium(aes(fill=Fill9), width=1/12, curve_type="sigmoid", alpha=0.5) + geom_stratum(width=1/20, color="black") +
  geom_alluvium(aes(fill=Fill10), width=1/12, curve_type="sigmoid", alpha=0.5) + geom_stratum(width=1/20, color="black") +
  
  geom_text(aes(x=1, stratum=Level_1, label=Label1), stat="stratum", size=4,   vjust=0.5, hjust=2, color="black") +
  geom_text(aes(x=2, stratum=Level_2, label=Label2), stat="stratum", size=3,   vjust=0.5, hjust=1.3, color="white") +
  geom_text(aes(x=3, stratum=Level_3, label=Label3), stat="stratum", size=3,   vjust=0.5, hjust=1.2, color="white") +
  geom_text(aes(x=4, stratum=Level_4, label=Label4), stat="stratum", size=3, vjust=0.5, hjust=1.2, color="white") +
  geom_text(aes(x=5, stratum=Level_5, label=Label5), stat="stratum", size=3, vjust=0.5, hjust=1.1, color="white") +
  geom_text(aes(x=6, stratum=Level_6, label=Label6), stat="stratum", size=2.5, vjust=0.5, hjust=1.1, color="white") +
  geom_text(aes(x=7, stratum=Level_7, label=Label7), stat="stratum", size=2.5, vjust=0.5, hjust=1.1, color="white") +
  geom_text(aes(x=8, stratum=Level_8, label=Label8), stat="stratum", size=2.5, vjust=0.5, hjust=1.1, color="white") +
  geom_text(aes(x=9, stratum=Level_9, label=Label9), stat="stratum", size=2.5, vjust=0.5, hjust=1.1, color="white") +
  geom_text(aes(x=10,stratum=Level_10,label=Label10),stat="stratum", size=2.5, vjust=0.5, hjust=1.1,color="white") + +
  
  scale_x_discrete(limits=paste0("Level_", 1:10), expand=c(0.12,0.04)) +
  scale_fill_identity() +
  ggtitle("Alluvial plot of 10-level LIN code prefixes") +
  theme_minimal() +
  theme(
    legend.position="none",
    axis.text=element_text(size=12),
    axis.title=element_blank(),
    panel.background=element_rect(fill="white", color="white"),
    plot.background=element_rect(fill="white", color=NA)
  )

# 11. Display Plot and (Optionally Save) ---------------------------------------
print(plot)
#ggsave(output_plot, plot=plot, width=16, height=8, dpi=500)