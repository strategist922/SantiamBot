## Santiam TwitterBot 
##
## 
##
## Version 1.0
##
##
library(twitteR)
library(dplyr)


## SET UP SOME GLOBAL VARIABLES


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
    
    if (!exists(sinceID.mention)) sinceID.mention <- NULL
    
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
    user_data<-userTimeline(user, n=2000, maxID=NULL, sinceID=NULL, includeRts=FALSE)
    ##inspect it
    head(user_data)
    ## convert to a data frame
    hwy_df<-do.call(rbind,lapply(user_data,as.data.frame))
    
    
## CLEAN AND TRANSFORM DATA    
    
    
    ## dedupe
    hwy_df<-hwy_df[!duplicated(hwy_df$created),]
    ##keep only columns of interest
    hwy_df<-hwy_df[,c("created", "text")]
    
    ## GOOD TO HERE>>.
    
    ## convert created column to date format
    hwy_df$created<-as.Date(hwy_df$created)
    
    ## dedupe
    hwy_df<-hwy_df[!duplicated(hwy_df$created),]
    ##keep only columns of interest
    hwy_df<-hwy_df[,c("created", "text")]
    
    
    #hwy_df$created<-as.character(hwy_df$created)
    hwy_df$text<-as.character(hwy_df$text)
    
    ##make the date column a date
    #hwy_df$date<-as.Date(hwy_df$created)
    ## create pacific time column
    hwy_df$PDT<-as.POSIXct(hwy_df$created, tz="UTC")
    ## convert to Pacific time
    attributes(hwy_df$PDT)$tzone<-"US/Pacific"
    
    ##make an "hour" column (for time of day)
    library(lubridate)
    t.lub <- ymd_hms(hwy_df$PDT)
    hwy_df$hour <- hour(t.lub) + minute(t.lub)/60
    
    ## make a seconds column
    hwy_df$chronsecs<-as.numeric(as.POSIXlt(hwy_df$PDT))
    
    
    ## create "dayperiod"
    hwy_df$dayperiod<-NA
    hwy_df$dayperiod[hwy_df$hour>=3 & hwy_df$hour<9]<-"morning"
    hwy_df$dayperiod[hwy_df$hour>=9 & hwy_df$hour<15]<-"midday"
    hwy_df$dayperiod[hwy_df$hour>=15 & hwy_df$hour<21]<-"evening"
    hwy_df$dayperiod[hwy_df$hour>=19]<-"night"
    hwy_df$dayperiod[hwy_df$hour<3]<-"night"
    
    ## make a factor
    hwy_df$dayperiod<-as.factor(hwy_df$dayperiod)
    #head(hwy_df)
    
    
    
    ### capture start and edn times of period 
    tEnd <- as.Date(hwy_df$created)[length(hwy_df$created)]
    tStart <- as.Date(hwy_df$created[1])
    
    
    ## look for specific incidents and create tidy data frames
    
        location <- "Santiam Pass Summit"
        ##Get tweets with S1
        hwy_df.santiam <-hwy_df[grep(location, hwy_df$text),]
    
        incident <- "crash"
        ## get tweets with S2
        hwy_df.santiam.crash <-hwy_df[grep(incident, hwy_df.santiam$text),]
    
        incident <- "snow"
        ## get tweets with S2
        hwy_df.santiam.snow <-hwy_df[grep(incident, hwy_df.santiam$text),]

## GENERATE MODEL    
    
    
        
        
    