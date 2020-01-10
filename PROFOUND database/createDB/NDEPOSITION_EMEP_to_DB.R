#------------------------------------------------------------------------------#
#                          NDEP Data
#
#------------------------------------------------------------------------------#

load( "~/ownCloud/PROFOUND_Data/Processed/RData/NDepEMEP_Data.RData")
# Target variables
#variables_names <- c( "RCP","year", "CO2")
# Columns DB
columns <- c("record_id", "site_id",  "year", "noy_gm2","nhx_gm2")

# loadsites
load("~/ownCloud/PROFOUND_Data/Processed/RData/Sites.RData")
# get the  locations
site <- Sites$site2
site.id <-  Sites$site_id
names(site.id) <- site


#------------------------------------------------------------------------------#
#                    CREATE   SQL    TABLE
#------------------------------------------------------------------------------#
# Load libraries
library(sqldf)
library(DBI)
library(RSQLite)
# open connection to DB
db <- dbConnect(SQLite(), dbname= myDB)

if ( "NDEPOSITION_EMEP_master" %in% dbListTables(db)){
  dbSendQuery(db, "DROP TABLE NDEPOSITION_EMEP_master")}
# create table in DB (cant type minus)
dbSendQuery(conn = db,
            "CREATE TABLE NDEPOSITION_EMEP_master
            (record_id INTEGER NOT NULL,
            site_id INTEGER NOT NULL,
            year INTEGER NOT NULL,
            noy_gm2 REAL CHECK(noy_gm2>0),
            nhx_gm2 REAL CHECK(nhx_gm2>0),
            PRIMARY KEY (record_id),
            FOREIGN KEY (site_id) REFERENCES SITESID_master(site_id)
            )")

# Check the table
dbListTables(db) # The tables in the database
dbListFields(db, "NDEPOSITION_EMEP_master") # The fields in the table
## Close connnection to db
dbDisconnect(db)
# dbSendQuery(db, "DROP TABLE NDEPOSITION")
#------------------------------------------------------------------------------#
#               ENTER DATA IN THE TABLE
#------------------------------------------------------------------------------#
id <- 0
# Loop over files adds data to DB, could also add it to list and then do.call(rbind, listDf)
for (i in 1:length(NDepEMEP_Data)){
  df <- NDepEMEP_Data[[i]]
  if (unique(df$site) %in% site){
    df$record_id <- c((id+1):(id+length(df$site)))
    # open connection to DB
    db <- dbConnect(SQLite(), dbname= myDB)
    dbWriteTable(db, "NDEPOSITION_EMEP_master", df[,columns], append=TRUE, row.names = FALSE)
    dbDisconnect(db)
    # reset the id values
    id <- id+length(df$site)
  }
}
# create index
db <- dbConnect(SQLite(), dbname=myDB)
# create index for variables we are going to query: so far location, gcm, rcp
# --> change names to include the table
dbGetQuery(db,"CREATE INDEX index_NDEPOSITION_EMEP_master_site_id ON NDEPOSITION_EMEP_master (site_id)")
## Close connnection to db
dbDisconnect(db)

