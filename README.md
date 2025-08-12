# LINcodes_Corynebacterium_diphtheriae_population_structure

This repository contains input files and R scripts for analyzing the population structure of *Corynebacterium diphtheriae* strains using a ten-level, cgMLST-based LIN code system, as described in the publication:  
**"Life identification number (LIN) codes for the genomic taxonomy of Corynebacterium diphtheriae strains" by Jose F. Delgado-Blas *et al.***

These resources support:
- **Circle packing charts** to visualize hierarchical population structures.
- **Alluvial plots** to display concordance between LIN code levels.

---

## 📊 Circle Packing Plots (Figures 1 and 6)

The provided R script generates a circle packing plot based on LIN code prefixes, where each bacterial strain is defined by a complete 10-level LIN code.

**Plot features:**
- Each circle represents a LIN code prefix (taxonomic level).
- Circles are nested within their corresponding higher/parental LIN code prefixes.
- Circle color encodes the LIN code level (from 1 to 10).
- Circle size displays the number of genomes for each LIN code prefix.
- The first LIN code prefix corresponds to the species.
- LIN code prefixes from levels 2 to 5 with ≥30 genomes are labeled.

---

## 📁 Repository Contents

- **R script:**  
  [`LINcode_circle_packing_plot_R_script.R`](LINcode_circle_packing_plot_R_script.R)  

- **Input data (example for Figure 1):**  
  [`Figure_1_population_structure_LINcode_data.csv`](Figure_1_population_structure_LINcode_data.csv)

---

## 🚀 How to Use

1. Place your input CSV in the `data/` directory (see provided example).
2. Run the R script:
    ```r
    source("LINcode_circle_packing_plot_R_script.R")
    ```
3. The script will output a circle packing plot visualizing the population structure based on the chMLST-based LIN codes.

---

## 📚 Reference

If you use this repository, please cite:  
Delgado-Blas, J. F., *et al.* "Life identification number (LIN) codes for the genomic taxonomy of Corynebacterium diphtheriae strains".

---


