# This is an Example R script to fetch the variant
# information from Ensembl based on provided rsIDs.
# Szymon Szyszkowski 2025

source(".Rprofile")
library(cli)
library(readr)


#' Main function to read rsIDs from a file and fetch their variant information
#'
#' @param input_file Path to the input file containing rsIDs.
#' @param output_file Path to the output file where the
#'                    variant information will be saved.
#' @return A data frame containing the fetched variant information.
main <- function() {
  cli::cli_h1("Fetch Variants from rsIDs")
  args <- commandArgs(trailingOnly = TRUE)
  if (length(args) < 2) {
    cli::cli_alert_danger(
      "Usage: fetch_variants_from_rsids.R <input_rsids.tsv> <output.tsv> \n"
    )
    quit(status = 1)
  }

  input_file <- args[1]
  output_file <- args[2]

  # Check if input file exists
  if (!file.exists(input_file)) {
    cat(sprintf("Error: input file '%s' does not exist.\n", input_file))
    quit(status = 1)
  }

  readr::read_tsv(input_file, col_names = TRUE) |>
    dplyr::pull(1) |>
    ensembl_fetch_variant() |>
    readr::write_tsv(output_file)

  cli::cli_alert_success(
    sprintf("Variant information saved to '%s'", output_file)
  )

  invisible()
}

main()
