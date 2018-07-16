  #------------------------------------------------------------------------------#
# Tree data
#     This script does the following:

#
#------------------------------------------------------------------------------#

load("~/ownCloud/PROFOUND_Data/Processed/RData/Tree_Data.RData")
# Columns DB
columns <- c("record_id", "site_id", "year", 
             "species_id", "dbh1_cm", "height1_m" )


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
if ( "TREE_master" %in% dbListTables(db)){
  dbSendQuery(db, "DROP TABLE TREE_master")}

# create table in DB (cant type minus)
dbSendQuery(conn = db,
            "CREATE TABLE TREE_master
             (record_id INTEGER NOT NULL,
              site_id INTEGER NOT NULL,
              year INTEGER NOT NULL,
              species_id TEXT NOT NULL,
              dbh1_cm REAL CHECK(dbh1_cm<2000),
              height1_m REAL CHECK(height1_m<200),
              PRIMARY KEY (record_id),
              FOREIGN KEY (site_id) REFERENCES SITESID_master(site_id),
              FOREIGN KEY (species_id) REFERENCES TREESPECIES_master(species_id)
            )")

# Check the table
dbListTables(db) # The tables in the database
dbListFields(db, "TREE_master") # The fields in the table
## Close connnection to db
dbDisconnect(db)
# dbSendQuery(db, "DROP TABLE TREE")
#------------------------------------------------------------------------------#
#               ENTER DATA IN THE TABLE
#------------------------------------------------------------------------------#
id <- 0
# Loop over files adds data to DB, could also add it to list and then do.call(rbind, listDf)
for (i in 1:length(Tree_Data)){
  df <- Tree_Data[[i]]
  df$record_id <- c((id+1):(id+length(df$site)))
  # open connection to DB
  db <- dbConnect(SQLite(), dbname= myDB)
  dbWriteTable(db, "TREE_master", df[,columns], append=TRUE, row.names = FALSE)
  dbDisconnect(db)
  # reset the id values
  id <- id+length(df$site)
}
# create index
db <- dbConnect(SQLite(), dbname=myDB)
# create index for variables we are going to query: so far location, gcm, rcp
# --> change names to include the table
dbGetQuery(db,"CREATE INDEX index_TREE_master_site_id ON TREE_master (site_id)")
dbGetQuery(db,"CREATE INDEX index_TREE_master_species_id ON TREE_master (species_id)")
## Close connnection to db
dbDisconnect(db)

