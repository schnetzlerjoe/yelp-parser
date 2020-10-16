library('tidyverse')
library('httr')

client_id <- "client_id"
client_secret <- "client_secret"

res <- POST("https://api.yelp.com/oauth2/token",
            body = list(grant_type = "client_credentials",
                        client_id = client_id,
                        client_secret = client_secret))

token <- content(res)$access_token

yelp <- "https://api.yelp.com"
term <- business_data$name

url <- modify_url(yelp, path = c("v3", "businesses", "search", "phone"),
                  query = list(term = term))
res <- GET(url, add_headers('Authorization' = paste("bearer", client_secret)))

results <- content(res)

yelp_httr_parse <- function(x) {
  
  parse_list <- list(phone = x$phone)
  
  parse_list <- lapply(parse_list, FUN = function(x) ifelse(is.null(x), "", x))
  
  df <- data_frame(phone=parse_list$phone)
  df
}

results_list <- lapply(results$businesses, FUN = yelp_httr_parse)

phone_numbers <- do.call("rbind", results_list)

business_data <- cbind(business_data, phone_numbers)