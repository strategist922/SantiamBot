## Santiam TwitterBot 
##
## 
##
## Version 1.0
##
##
library(twitteR)
library(dplyr)


## create URLs
reqURL <- "https://api.twitter.com/oauth/request_token"
accessURL <- "https://api.twitter.com/oauth/access_token"
authURL <- "https://api.twitter.com/oauth/authorize"

## Keys
## you get these from apps.twitter.com

directory <- "/Users/winstonsaunders/Documents/SantiamBot/"
sub_directory <- "secrets/"

keys <- read.csv(paste0(directory, sub_directory, "secret.key.csv"), encoding = "UTF-8", stringsAsFactors = FALSE)


consumerKey <- keys$consumerKey
consumerSecret <- keys$consumerSecret
accessToken <- keys$accessToken
accessSecret <- keys$accessSecret

## set up authentication
setup_twitter_oauth(consumerKey, consumerSecret, accessToken, accessSecret)
