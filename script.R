library('tidyverse')
library('httr')
library('xlsx')
library('data.table')
library('openxlsx')

yelp <- "https://api.yelp.com"
term <- "Coffee"
location <- "Tampa,FL"
categories <- NULL
radius <- 50




######## Do not Input Anything Below ########


 parser <- function(term1, location1) {

term <- term1
location <- location1

client_id <- "client_id"
client_secret <- "client_secret"

token <- content(res)$access_token

limit <- 50 
url <- paste0("https://api.yelp.com/v3/businesses/search", "?","term=", term, "&","location=",location)
res <- GET(url, add_headers('Authorization' = paste("bearer", client_secret)))

results <- content(res)

df <- as.data.frame(do.call("rbind", results$businesses))

write.xlsx(df, file = "coffee.xlsx", sheetName = location, append = TRUE)
 }
