#' Fetch Variant Information from Ensembl by rsID
#'
#' This function retrieves variant information from the Ensembl REST API using a list of rsIDs.
#' @param rsIds A character vector of rsIDs to fetch variant information for.
#' @param endpoint The URL of the Ensembl REST API endpoint. Default is set to the human variation endpoint.
#' @return A data frame containing variant information including start, end, allele strings, ancestral alleles, location, assembly name, sequence region name, and strand.
#' @examples
#' \dontrun{
#' rsIds <- c("rs789012", "rs74733149")
#' variants <- ensembl_fetch_variant_from_rsid(rsIds)
#' variants
#' A tibble: 2 × 10
#'   seq_region_name strand assembly_name      end ancestral_allele location             coord_system allele_string    start rsid
#'   <chr>            <int> <chr>            <int> <chr>            <chr>                <chr>        <chr>            <int> <chr>
#' 1 12                   1 GRCh38        28719649 G                12:28719649-28719649 chromosome   G/A           28719649 rs789012
#' 2 1                    1 GRCh38        65609903 A                1:65609903-65609903  chromosome   A/G           65609903 rs74733149
#' }
#' @export
ensembl_fetch_variant <- function(
  rsids,
  endpoint = "http://rest.ensembl.org/variation/homo_sapiens"
) {
  cli::cli_alert_info(sprintf("Fetching rsIds from %s", endpoint))
  httr::POST(
    endpoint,
    httr::content_type("application/json"),
    httr::accept("application/json"),
    body = jsonlite::toJSON(list(ids = rsids))
  ) |>
    httr::stop_for_status() |>
    httr::content() |>
    jsonlite::toJSON() |>
    jsonlite::fromJSON() |>
    ensembl_parse_response()
}


#' Parse API Response into a Data Frame
#'
#' Extracts the `mapping` element from each object in a response list and
#' converts the result into a data frame with an added column for the `rsIds`.
#'
#' @param resp A named list where each element is expected to contain a `$mapping` component.
#'
#' @return A `data.frame` with one row per item in `resp`, including the extracted
#' `mapping` fields and an `rsIds` column containing the names of the original list.
#'
#' @examples
#' \dontrun{
#' resp <- list(
#'   rs123 = list(mapping = list(seq_region_name = 1, allele_string = 'G/C/T')),
#' )
#' parse_response(resp)
#' }
ensembl_parse_response <- function(resp) {
  cli::cli_alert_info("Parsing response from Ensembl API")
  if (length(resp) == 0) {
    cli::cli_alert_danger("No variants found for the provided rsIDs.")
    return(data.frame())
  }
  purrr::map(resp, function(obj) as.data.frame(obj$mapping)) |>
    dplyr::bind_rows() |>
    tidyr::unnest(cols = dplyr::everything()) |>
    dplyr::mutate(
      rsid = names(resp)
    )
}
