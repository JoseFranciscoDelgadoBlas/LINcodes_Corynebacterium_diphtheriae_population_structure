# LINcodes_Corynebacterium_diphtheriae_population_structure
This repository contains the input files and R scripts used to analyze the population structure of Corynebacterium diphtheriae strains using a ten-level, cgMLST-based LIN code system, as described in the publication "Life identification number (LIN) codes for the genomic taxonomy of Corynebacterium diphtheriae strains" by Jose F. Delgado-Blas et al. The resources provided generate circle packing charts to visualize hierarchical population structures and alluvial plots to display concordance between LIN code levels, facilitating detailed exploration of genomic relationships within the LIN code framework.

# Circle packing plots (Figures 1 and 6)
R script to generate a circle packing plot based on LIN code prefixes (bacterial strains are defined by complete 10-level LIN codes). Each LIN code prefix is represented by a circle, which is coloured according to the level (from 1 to 10, as shown in the right legend) and nested within their corresponding higher/parental LIN code prefixes. Note that each LIN code prefix corresponds to a specific taxonomic level, and as one progresses from left to right along the code, the threshold for allelic mismatches decreases, ultimately reaching 0 mismatches in the complete 10-level LIN codes. The circle sizes display the number of genomes encompassed by each LIN code prefix. The first LIN code prefix corresponds to the species, and the labels for the LIN code prefixes from level 2 to level 5 for those comprising ≥30 genomes are also displayed in the plot.

R script: LINcode_circle_packing_plot_R_script.R

Input data (Figure 1 example): Figure_1_population_structure_LINcode_data.csv


