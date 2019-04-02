# Microbiome_variation
This repository contains the RMarkdown script and associated data files to reproduce the analyses described in [Bender *et al*., *Quantification of variation and the impact of biomass in targeted 16S rRNA gene microbiome studies*](https://doi.org/10.1186/s40168-018-0543-z).

## Running analysis
A decent number of packages are required - see the top of the R script for details. Installation is up to the user.

## Data files
In addition to the raw FASTQ files available via SRA (BioProject: [PRJNA415628](https://www.ncbi.nlm.nih.gov/bioproject/PRJNA415628)), we also include more helpful intermediate files in the [/data](/data) folder. These can be downloaded and used directly with the R script. Some details about the contents of each file:
* BLAST_results.parsed.txt - taxonomic classification by BLAST, useful for obtaining species-level labels for each ASV
* mapping.txt - mapping file with metadata variables
* merged_seqtab.nochim.rds - RDS object containing the amplicon sequence variant (ASV) table produced by DADA2
* metadata_types.txt - file containing some information about the metadata variables (outcomes) of interest
* qPCR.txt - qPCR data used in the biomass analysis
* taxa_coloring.txt - some pretty colors for genus-level barplots

## Issues
Questions/comments can be submitted via the [issue tracker](https://github.com/AldrovandiLab/Microbiome_variation/issues) or by email to fanli (at) mednet (dot) ucla (dot) edu.
