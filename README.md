# LINcodes_Corynebacterium_diphtheriae_population_structure

This repository contains input files and R scripts for analyzing the population structure of *Corynebacterium diphtheriae* strains using a ten-level, cgMLST-based LIN code system, as described in the publication:  
**"Life identification number (LIN) codes for the genomic taxonomy of Corynebacterium diphtheriae strains" by Jose F. Delgado-Blas *et al.***

These resources support:
- 🟣 **Circle packing plots** for hierarchical population structure.
- 🌊 **Alluvial plots** for concordance and relationships between LIN code levels.

---

## 🟣 Circle Packing Plots (Figures 1 and 6)

The provided R script generates a circle packing plot based on LIN code prefixes, where each bacterial strain is defined by a complete 10-level LIN code.

**Plot features:**
- Each circle corresponds to a LIN code prefix (taxonomic level).
- Circles are nested within their higher/parental LIN code prefixes.
- Circle color encodes the LIN code level (from 1 to 10).
- Circle size displays the number of genomes for each LIN code prefix.
- LIN code prefixes (levels 2–5) with ≥30 genomes are labeled.
- The first LIN code prefix corresponds to the species.

---

## 🌊 Alluvial Plots (Figures 2, 4B, and 5B)

The provided R scripts generate alluvial plots representing hierarchical relationships between LIN code prefixes across sequential taxonomic levels.

**Plot features:**
- LIN code-based taxonomic levels are indicated in the X-axis.
- Each level partitions are represented by white bars and ordered by decreasing total counts (Y-axis).
- Inter-level links are colored according to last level partitions.
- Predominant nicknames/LIN code prefixes are displayed next to level partitions.
- The lineage level is indicated by two-level LIN code prefixes.
- Sublineage (SL) and clonal group (ClG) nicknames are based on the most represented ST per group.
- GC (genetic cluster) nicknames are assigned by decreasing total counts in the BIGSdb-Pasteur database.

---

## 📁 Repository Contents

- **R scripts:**  
  [`LINcode_circle_packing_plot_R_script.R`](LINcode_circle_packing_plot_R_script.R)  
  [`LINcode_nickname_concordance_alluvial_plot_R_script.R`](LINcode_nickname_concordance_alluvial_plot_R_script.R)  
  [`LINcode_prefix_decomposition_and_alluvial_plot_R_script.R`](LINcode_prefix_decomposition_and_alluvial_plot_R_script.R)  

- **Input datasets (examples):**  
  [`Figure_1_population_structure_LINcode_data.csv`](Figure_1_population_structure_LINcode_data.csv)  
  [`Figure_2_LINcode_taxonomic_level_data.csv`](Figure_2_LINcode_taxonomic_level_data.csv)  
  [`Figure_4B_SL8_LINcode_data.csv`](Figure_4B_SL8_LINcode_data.csv)

---

## 🚀 How to Use

1. Place your input CSV file(s) in the `data/` directory (see provided examples).
2. Run the appropriate R script, for example:  
    ```r
    source("LINcode_circle_packing_plot_R_script.R")
    # or for alluvial plots:
    source("LINcode_nickname_concordance_alluvial_plot_R_script.R")
    source("LINcode_prefix_decomposition_and_alluvial_plot_R_script.R")
    ```
3. The script will output a plot in the `output/` directory.

---

## 📚 Reference

If you use this repository, please cite:  
Delgado-Blas, J. F., *et al.* "Life identification number (LIN) codes for the genomic taxonomy of Corynebacterium diphtheriae strains".

---
