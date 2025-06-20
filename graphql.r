source('.Rprofile')
library(ghql)
library(jsonlite)
con <- ghql::GraphqlClient$new('https://api.genetics.opentargets.org/graphql')
qry <- ghql::Query$new()
qry$query(
    "search_query",
    "query searchRsId($rsId: String!) {
        search(queryString: $rsId) {
            variants {
                id
            }
        }
    }"
)
variables <- list(rsId = 'rs789012')

res <- con$exec(qry$queries$search_query, variables) |> jsonlite::fromJSON(res)
# $data
# $data$search
# $data$search$variants
#                id
# 1 12_28719649_G_A

qry2 <- ghql::Query$new()
qry2$query(
    "v2g",
    "query v2g($variantId: String!) {
        genesForVariant(variantId: $variantId) {
            gene {
                symbol
                id
            }
            variant
            overallScore
            distances {
                sourceId
                aggregatedScore
                tissues {
                    distance
                }
            }
        }
    }"
)

variables2 <- list(variantId = search_query$data$search$variants$id[1])
res2 <- con$exec(qry2$queries$v2g, variables2) |> jsonlite::fromJSON()
# $data
# $data$genesForVariant
#   gene.symbol         gene.id         variant overallScore
# 1        FAR2 ENSG00000064763 12_28719649_G_A  0.006639839
#                    distances
# 1 canonical_tss, 0.1, 429367

qry3 <- ghql::Query$new()
qry3$query(
    "variantSearch",
    "
    query s {
  search(queryString:"rs7412" entityNames: ["variant"]) {
    hits {
      name
      ngrams
      score      
    }
  }
}
    "

)

con <- ghql::GraphqlClient$new('https://api.platform.opentargets.org/api/v4/graphql/')
