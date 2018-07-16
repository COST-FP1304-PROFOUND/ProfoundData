#------------------------------------------------------------------------------#
# Tree data
#     This script does the following:

#
#------------------------------------------------------------------------------#

load("~/ownCloud/PROFOUND_Data/Processed/RData/TreeSpecies_Data.RData")
# Target variables
columns <- c("species_id", "species")


# Here a check
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
if ( "TREESPECIES_master" %in% dbListTables(db)){
  dbSendQuery(db, "DROP TABLE TREESPECIES_master")}


# create table in DB (cant type minus)
dbSendQuery(conn = db,
            "CREATE TABLE TREESPECIES_master
             (species_id TEXT NOT NULL,
              species TEXT NOT NULL,
              PRIMARY KEY (species_id)
            )")

# Check the table
dbListTables(db) # The tables in the database
dbListFields(db, "TREESPECIES_master") # The fields in the table
## Close connnection to db
dbDisconnect(db)
# dbSendQuery(db, "DROP TABLE TREE")
#------------------------------------------------------------------------------#
#               ENTER DATA IN THE TABLE
#------------------------------------------------------------------------------#

df <- TreeSpecies_Data
# open connection to DB
db <- dbConnect(SQLite(), dbname= myDB)
dbWriteTable(db, "TREESPECIES_master", df[,columns], append=TRUE, row.names = FALSE)
dbDisconnect(db)
# create index
db <- dbConnect(SQLite(), dbname=myDB)
# create index for variables we are going to query: so far location, gcm, rcp
# --> change names to include the table
dbGetQuery(db,"CREATE INDEX index_TREESPECIES_master_species_id ON TREESPECIES_master (species_id)")
## Close connnection to db
dbDisconnect(db)


