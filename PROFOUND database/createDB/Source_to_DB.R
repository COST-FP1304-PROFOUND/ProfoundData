#------------------------------------------------------------------------------#
#                         SOURCE
#
#------------------------------------------------------------------------------#
load("~/ownCloud/PROFOUND_Data/Processed/RData/METADATA_SOURCE.RData")
load("~/ownCloud/PROFOUND_Data/Processed/RData/METADATA_SOURCE_SITES.RData")
# Target variables
#variables_names <- c( "RCP","year", "CO2")
# Columns DB
columns <- c("record_id","site_id", "dataset", "source", "reference", "comments" )

#------------------------------------------------------------------------------#
#                    CREATE   SQL    TABLE
#------------------------------------------------------------------------------#
# Load libraries
library(sqldf)
library(DBI)
library(RSQLite)
# open connection to DB
db <- dbConnect(SQLite(), dbname= myDB)
if ( "SOURCE_master" %in% dbListTables(db)){
  dbSendQuery(db, "DROP TABLE SOURCE_master")}

# create table in DB (cant type minus)
dbSendQuery(conn = db,
            "CREATE TABLE SOURCE_master
       (record_id INTEGER NOT NULL,
        site_id INTEGER NOT NULL,
        dataset TEXT,
        source TEXT,
        reference TEXT,
        comments TEXT,
        PRIMARY KEY (record_id),
        FOREIGN KEY (site_id) REFERENCES SITESID_master(site_id)
            )")

# Check the table
dbListTables(db) # The tables in the database
dbListFields(db, "SOURCE_master") # The fields in the table
## Close connnection to db
dbDisconnect(db)
# dbSendQuery(db, "DROP TABLE TREE")
# open connection to DB
db <- dbConnect(SQLite(), dbname= myDB)
if ( "SOURCE_SITES_master" %in% dbListTables(db)){
  dbSendQuery(db, "DROP TABLE SOURCE_SITES_master")}

# create table in DB (cant type minus)
dbSendQuery(conn = db,
            "CREATE TABLE SOURCE_SITES_master
       (record_id INTEGER NOT NULL,
        site_id INTEGER NOT NULL,
        dataset TEXT,
        source TEXT,
        reference TEXT,
        comments TEXT,
        PRIMARY KEY (record_id),
        FOREIGN KEY (site_id) REFERENCES SITESID_master(site_id)
            )")

# Check the table
dbListTables(db) # The tables in the database
dbListFields(db, "SOURCE_SITES_master") # The fields in the table
## Close connnection to db
dbDisconnect(db)
# dbSendQuery(db, "DROP TABLE TREE")
#------------------------------------------------------------------------------#
#               ENTER DATA IN THE TABLE
#------------------------------------------------------------------------------#
#id <- 0
# Loop over files adds data to DB, could also add it to list and then do.call(rbind, listDf)
#for (i in 1:length(CO2_Data)){
df <- METADATA_SOURCE
df$record_id <- c(1:length(df[,1]))
  # open connection to DB
db <- dbConnect(SQLite(), dbname= myDB)
dbWriteTable(db, "SOURCE_master", df[,columns], append=TRUE, row.names = FALSE)
dbDisconnect(db)
  # reset the id values
#id <- id+length(df$Site)
db <- dbConnect(SQLite(), dbname=myDB)
# create index for variables we are going to query: so far location, gcm, rcp
# --> change names to include the table
dbGetQuery(db,"CREATE INDEX index_SOURCE_master_site_id ON SOURCE_master (site_id)")
dbGetQuery(db,"CREATE INDEX index_SOURCE_master_species_id ON SOURCE_master (dataset)")
## Close connnection to db
dbDisconnect(db)

#for (i in 1:length(CO2_Data)){
df <- METADATA_SOURCE_SITES
df$record_id <- c(1:length(df[,1]))
# open connection to DB
db <- dbConnect(SQLite(), dbname= myDB)
dbWriteTable(db, "SOURCE_SITES_master", df[,columns], append=TRUE, row.names = FALSE)
dbDisconnect(db)
# reset the id values
#id <- id+length(df$Site)
db <- dbConnect(SQLite(), dbname=myDB)
# create index for variables we are going to query: so far location, gcm, rcp
# --> change names to include the table
dbGetQuery(db,"CREATE INDEX index_SOURCE_SITES_master_site_id ON SOURCE_SITES_master (site_id)")
dbGetQuery(db,"CREATE INDEX index_SOURCE_SITES_master_species_id ON SOURCE_SITES_master (dataset)")
## Close connnection to db
dbDisconnect(db)
#}
