#------------------------------------------------------------------------------#
# Tree data
#     This script does the following:

#
#------------------------------------------------------------------------------#
load("~/ownCloud/PROFOUND_Data/Processed/RData/SiteDescription_Data.RData")
# Target variables
# Columns DB
columns <- c("record_id", "site_id", "description", "reference")


#------------------------------------------------------------------------------#
#                    CREATE   SQL    TABLE
#------------------------------------------------------------------------------#
# Load libraries
library(sqldf)
library(DBI)
library(RSQLite)
# open connection to DB
db <- dbConnect(SQLite(), dbname= myDB)
if ( "SITEDESCRIPTION_master" %in% dbListTables(db)){
  dbSendQuery(db, "DROP TABLE SITEDESCRIPTION_master")}


# create table in DB (cant type minus)
dbSendQuery(conn = db,
            "CREATE TABLE SITEDESCRIPTION_master
            (record_id INTEGER NOT NULL,
            site_id INTEGER NOT NULL,
            description TEXT, 
            reference TEXT,
            FOREIGN KEY (site_id) REFERENCES SITESID_master(site_id)
            )")

# Check the table
dbListTables(db) # The tables in the database
dbListFields(db, "SITEDESCRIPTION_master") # The fields in the table
## Close connnection to db
dbDisconnect(db)
# dbSendQuery(db, "DROP TABLE TREE")
#------------------------------------------------------------------------------#
#               ENTER DATA IN THE TABLE
#------------------------------------------------------------------------------#
id <- 0
# Loop over files adds data to DB, could also add it to list and then do.call(rbind, listDf)
df <- SiteDescription_Data
df$record_id <- 1:length(SiteDescription_Data[,1])
# open connection to DB
db <- dbConnect(SQLite(), dbname= myDB)
dbWriteTable(db, "SITEDESCRIPTION_master", df[,columns], append=TRUE, row.names = FALSE)
dbDisconnect(db)
# reset the id values

# create index
db <- dbConnect(SQLite(), dbname=myDB)
# create index for variables we are going to query: so far location, gcm, rcp
# --> change names to include the table
dbGetQuery(db,"CREATE INDEX index_SITEDESCRIPTION_master_site_id ON SITEDESCRIPTION_master (site_id)")
## Close connnection to db
dbDisconnect(db)


