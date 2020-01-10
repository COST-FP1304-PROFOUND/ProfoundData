#------------------------------------------------------------------------------#
#                         Policy
#
#------------------------------------------------------------------------------#
load("~/ownCloud/PROFOUND_Data/Processed/RData/METADATA_POLICY.RData")
load("~/ownCloud/PROFOUND_Data/Processed/RData/METADATA_POLICY_SITES.RData")
# Target variables
#variables_names <- c( "RCP","year", "CO2")
# Columns DB
columns <- c("record_id","site_id", "dataset", "dataPolicy" )

#------------------------------------------------------------------------------#
#                    CREATE   SQL    TABLE
#------------------------------------------------------------------------------#
# Load libraries
library(sqldf)
library(DBI)
library(RSQLite)
# open connection to DB
db <- dbConnect(SQLite(), dbname= myDB)
if ( "POLICY_master" %in% dbListTables(db)){
  dbSendQuery(db, "DROP TABLE POLICY_master")}

# create table in DB (cant type minus)
dbSendQuery(conn = db,
            "CREATE TABLE POLICY_master
       (record_id INTEGER NOT NULL,
        site_id INTEGER NOT NULL,
        dataset TEXT,
        dataPolicy TEXT,
        PRIMARY KEY (record_id),
        FOREIGN KEY (site_id) REFERENCES SITESID_master(site_id)
            )")

# Check the table
dbListTables(db) # The tables in the database
dbListFields(db, "POLICY_master") # The fields in the table
## Close connnection to db
dbDisconnect(db)
# dbSendQuery(db, "DROP TABLE TREE")
#------------------------------------------------------------------------------#
#               ENTER DATA IN THE TABLE
#------------------------------------------------------------------------------#
#id <- 0
# Loop over files adds data to DB, could also add it to list and then do.call(rbind, listDf)
#for (i in 1:length(CO2_Data)){
df <- METADATA_POLICY
df$record_id <- c(1:length(df[,1]))
  # open connection to DB
db <- dbConnect(SQLite(), dbname= myDB)
dbWriteTable(db, "POLICY_master", df[,columns], append=TRUE, row.names = FALSE)
dbDisconnect(db)
  # reset the id values
#id <- id+length(df$Site)
#}
db <- dbConnect(SQLite(), dbname=myDB)
# create index for variables we are going to query: so far location, gcm, rcp
# --> change names to include the table
dbGetQuery(db,"CREATE INDEX index_POLICY_master_site_id ON POLICY_master (site_id)")
dbGetQuery(db,"CREATE INDEX index_POLICY_master_species_id ON POLICY_master (dataset)")
## Close connnection to db
dbDisconnect(db)

#------------------------------------------------------------------------------#
#                    CREATE   SQL    TABLE
#------------------------------------------------------------------------------#
# open connection to DB
db <- dbConnect(SQLite(), dbname= myDB)
if ( "POLICY_SITES_master" %in% dbListTables(db)){
  dbSendQuery(db, "DROP TABLE POLICY_SITES_master")}

# create table in DB (cant type minus)
dbSendQuery(conn = db,
            "CREATE TABLE POLICY_SITES_master
            (record_id INTEGER NOT NULL,
            site_id INTEGER NOT NULL,
            dataset TEXT,
            dataPolicy TEXT,
            PRIMARY KEY (record_id),
            FOREIGN KEY (site_id) REFERENCES SITESID_master(site_id)
            )")

# Check the table
dbListTables(db) # The tables in the database
dbListFields(db, "POLICY_SITES_master") # The fields in the table
## Close connnection to db
dbDisconnect(db)
# dbSendQuery(db, "DROP TABLE TREE")
#------------------------------------------------------------------------------#
#               ENTER DATA IN THE TABLE
#------------------------------------------------------------------------------#
#id <- 0
# Loop over files adds data to DB, could also add it to list and then do.call(rbind, listDf)
#for (i in 1:length(CO2_Data)){
df <- METADATA_POLICY_SITES
df$record_id <- c(1:length(df[,1]))
# open connection to DB
db <- dbConnect(SQLite(), dbname= myDB)
dbWriteTable(db, "POLICY_SITES_master", df[,columns], append=TRUE, row.names = FALSE)
dbDisconnect(db)
# reset the id values
#id <- id+length(df$Site)
#}
db <- dbConnect(SQLite(), dbname=myDB)
# create index for variables we are going to query: so far location, gcm, rcp
# --> change names to include the table
dbGetQuery(db,"CREATE INDEX index_POLICY_SITES_master_site_id ON POLICY_SITES_master (site_id)")
dbGetQuery(db,"CREATE INDEX index_POLICY_SITES_master_species_id ON POLICY_SITES_master (dataset)")
## Close connnection to db
dbDisconnect(db)

