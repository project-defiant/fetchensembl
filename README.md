# Fetch ensembl variant information from the Ensembl REST API based on rsIDs

This repository contains the R script `fetch_variants_from_rsids.R`, which fetches variant information from the Ensembl REST API using a list of rsIDs.

## Usage

```{bash}
Rscript fetch_variants_from_rsids.R test_data/rsids.tsv test_data/output.tsv
```

## Example Input

Check the `test_data/rsids.tsv` file for example input:

| rsid        |
|-------------|
| rs74733149  |
| rs789012    |


## Example Output

Check the `test_data/output.tsv` file for example output:


| assembly_name | coord_system | end      | ancestral_allele | allele_string | location             | strand | start    | seq_region_name | rsid        |
|---------------|--------------|----------|------------------|---------------|----------------------|--------|----------|-----------------|-------------|
| GRCh38        | chromosome   | 65609903 | A                | A/G           | 1:65609903-65609903  | 1      | 65609903 | 1               | rs74733149  |
| GRCh38        | chromosome   | 28719649 | G                | G/A           | 12:28719649-28719649 | 1      | 28719649 | 12              | rs789012    |

## Requirements

- R (version 4.3 or higher)