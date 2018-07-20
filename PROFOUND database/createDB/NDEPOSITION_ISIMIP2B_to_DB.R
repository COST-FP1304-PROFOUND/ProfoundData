#------------------------------------------------------------------------------#
#                          NDEP Data
#
#------------------------------------------------------------------------------#
# Target variables
# Columns DB
columns <- c("record_id", "site_id", "forcingConditions",  "year", "noy_gm2","nhx_gm2")

# Read all zip files
inDir <- "~/ownCloud/PROFOUND_Data/Processed/ISIMIP2B/NDEP/new"
filenames <- list.files(inDir, full.names=TRUE, recursive = TRUE)

print.progressNDEP <- function(df){
  cat("\n");cat(rep("-", 30));cat("\n")
  cat(as.character(unique(df$site)));cat("\n")
  cat(as.character(unique(df$forcingConditions))); cat("\n");cat("\n")
}
# Here a check
# loadsites
load("~/ownCloud/PROFOUND_Data/Processed/RData/Sites.RData")
# get the  locations
site <- Sites$site2
site.id <-  Sites$site_id
names(site.id) <- site
#TODO if something missing stop it
#------------------------------------------------------------------------------#
#                    CREATE   SQL    TABLE
#------------------------------------------------------------------------------#
# Load libraries
library(sqldf)
library(DBI)
library(RSQLite)
# open connection to DB
db <- dbConnect(SQLite(), dbname= myDB)

if ( "NDEPOSITION_ISIMIP2B_master" %in% dbListTables(db)){
  dbSendQuery(db, "DROP TABLE NDEPOSITION_ISIMIP2B_master")}
# create table in DB (cant type minus)
dbSendQuery(conn = db,
            "CREATE TABLE NDEPOSITION_ISIMIP2B_master
            (record_id INTEGER NOT NULL,
            site_id INTEGER NOT NULL,
            forcingConditions TEXT CHECK(forcingConditions <> ''),
            year INTEGER CHECK(NULL OR year >= 0 AND year < 9999),
            noy_gm2 REAL CHECK(noy_gm2>0),
            nhx_gm2 REAL CHECK(nhx_gm2>0),
            PRIMARY KEY (record_id),
            FOREIGN KEY (site_id) REFERENCES SITESID_master(site_id)
            )")

# Check the table
dbListTables(db) # The tables in the database
dbListFields(db, "NDEPOSITION_ISIMIP2B_master") # The fields in the table
## Close connnection to db
dbDisconnect(db)
# dbSendQuery(db, "DROP TABLE NDEPOSITION")
#------------------------------------------------------------------------------#
#               ENTER DATA IN THE TABLE
#------------------------------------------------------------------------------#

id <- 0
# Loop over files adds data to DB, could also add it to list and then do.call(rbind, listDf)
for (i in 1:length(filenames)){
  
  df <- read.table(filenames[i], header = TRUE, sep = "")
  file.site <-  as.character(unique(df$site))
  
  if (file.site == "Solling_304"){
    df1 <- df
    df1$site_id <- site.id[["Solling_304"]]
    df2 <- df
    df2$site <- "Solling_305"
    df2$site_id <- site.id[["Solling_305"]]
    df <- rbind(df1, df2)
    
    df$record_id <- c((id+1):(id+length(df$site)))
    
    
    # open connection to DB
    db <- dbConnect(SQLite(), dbname= myDB)
    dbWriteTable(db, "NDEPOSITION_ISIMIP2B_master",
                 df[,columns],
                 append=TRUE, row.names = FALSE)
    dbDisconnect(db)
    
    print.progressNDEP(df)
    # reset the id values
    id <- id+length(df$site)
    # delete data.all to keep RAM low
    rm(df)
  }else if (file.site %in% site){
    df$site_id <- site.id[[file.site]]
    df$record_id <- c((id+1):(id+length(df$site)))
    # open connection to DB
    db <- dbConnect(SQLite(), dbname= myDB)
    dbWriteTable(db, "NDEPOSITION_ISIMIP2B_master",
                 df[,columns],
                 append=TRUE, row.names = FALSE)
    dbDisconnect(db)
    
    print.progressNDEP(df)
    # reset the id values
    id <- id+length(df$site)
    rm(df)
  }
}


# create index
db <- dbConnect(SQLite(), dbname=myDB)
# create index for variables we are going to query: so far location, gcm, rcp
# --> change names to include the table
dbGetQuery(db,"CREATE INDEX index_NDEPOSITION_ISIMIP2B_master_forcingConditions ON NDEPOSITION_ISIMIP2B_master (forcingConditions)")
dbGetQuery(db,"CREATE INDEX index_NDEPOSITION_ISIMIP2B_master_site_id ON NDEPOSITION_ISIMIP2B_master (site_id)")
## Close connnection to db
dbDisconnect(db)

