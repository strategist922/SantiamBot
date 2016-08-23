## Santiam TwitterBot 
##
## 
##
## Version 1.0
##
##
library(twitteR)
library(dplyr)


## SET UP TWITTER
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

## READ HIWAY DATA
    
    trackHiway <- "TripCheckUS20B"
    broadcast <- "SantiamBot"
    
## CHECK FOR REQUESTS
    
    sinceID.mention <- NULL
    
    mentionList <- mentions(n=5, maxID=NULL, sinceID=sinceID.mention, includeRts=FALSE)
    
    ## catalog most recent
    sinceID.x<- mentionList[[ length(mentionList)]]$id
    
    ## get some recent mentions
    mentions(n=5, maxID=NULL, sinceID=sinceID.x)
    
    if (length(mentionList) >= 1){
        
        request.safety <- FALSE
        request.crash <- FALSE
        
        ## test for key phrases
        for (i in 1:length(mentionlist)){
            
            ## get tweet text
            testText <- mentionList[[1]]$text
            
            ## test
            if (grepl("crash", tolower(testText))) request.crash <- TRUE
            if (grepl("accident", tolower(testText))) request.crash <- TRUE
            
            if (grepl("safety", tolower(testText))) request.safety <- TRUE
            if (grepl("risk", tolower(testText))) request.safety <- TRUE
            
        }
    }
    
## GET DATA 
    
    ##name of access
    name <- "TripcheckUS20B"
    ##define user
    user <- getUser(paste0("@", name))
    ## get the data
    user_data<-userTimeline(user, n=1000, maxID=NULL, sinceID=NULL, includeRts=FALSE)
    ##inspect it
    head(user_data)
    ## convert to a data frame
    clean_data<-do.call(rbind,lapply(user_data,as.data.frame))
    ##write the data as a csv
    write.csv(clean_data, paste0(name,"_Jan16",".csv"))
    
    
    