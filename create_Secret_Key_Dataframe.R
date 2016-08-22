

## writes a secret key file to a secrets sub-directory for security on github

    ## INSTRUCTIONS (TO PRESERVE SECRECY ON GITHUB)
    ## 0. make sure .gitignore includes a line item for /secrets
    ## 1. edit the expressions below to include your key values.
    ## 2. ensure the /secrets subdirectory is present locally

    ## 3. *DO NOT* save the program after editing. 

    ## 4. run the program (validate file is created) 


    ## CREATE KEYS_DF
    ## edit the expressions below with your key values
    ## 

    keys_df <- data.frame(
                    "consumerKey"    = "<FILL-IN>",         
                    "consumerSecret" = "<FILL-IN>",
                    "accessToken"    = "<FILL-IN>",   
                    "accessSecret"   = "<FILL-IN>")

    ## DEFINE DIRECTORY (EDIT PER USER)

    directory <- "/Users/winstonsaunders/Documents/SantiamBot/"
    sub_directory <- "secrets/"
    file_name <- "secret.key.csv"

    write.csv(keys_df, paste0(directory, sub_directory, file_name))

    cat("file written")
    list.files(paste0(directory, sub_directory))

    ## end (not run)
