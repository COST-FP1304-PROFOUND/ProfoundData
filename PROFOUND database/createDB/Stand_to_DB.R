#------------------------------------------------------------------------------#
# Tree data
#     This script does the following:

#
#------------------------------------------------------------------------------#
load("~/ownCloud/PROFOUND_Data/Processed/RData/Stand_Data.RData")
# Target variables
# Columns DB
columns <- c("record_id", "site_id", "year", "species_id", "age", "dbhArith_cm",
             "dbhBA_cm", "dbhDQ_cm", "heightArith_m", "heightBA_m", "ba_m2ha",
             "density_treeha",  "aboveGroundBiomass_kgha",
             "foliageBiomass_kgha", "branchesBiomass_kgha", "stemBiomass_kgha", "rootBiomass_kgha",
             "stumpCoarseRootBiomass_kgha",  "lai")

colnamesDummy <- unique(unlist(sapply(Stand_Data, function(x)names(x))))
columns[!columns %in% colnamesDummy] 
colnamesDummy[!colnamesDummy %in% columns] 

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
if ( "STAND_master" %in% dbListTables(db)){
  dbSendQuery(db, "DROP TABLE STAND_master")}


# create table in DB (cant type minus)
dbSendQuery(conn = db,
            "CREATE TABLE STAND_master
             (record_id INTEGER NOT NULL,
              site_id INTEGER NOT NULL,
              year INTEGER NOT NULL,
              species_id TEXT NOT NULL,
              age INTEGER CHECK(age<1000),
              dbhArith_cm REAL CHECK(dbhArith_cm<2000),
              dbhBA_cm REAL CHECK(dbhBA_cm<2000),
              dbhDQ_cm REAL CHECK(dbhDQ_cm<2000),
              heightArith_m REAL CHECK(heightArith_m<200),
              heightBA_m REAL CHECK(heightBA_m<200),
              ba_m2ha REAL,
              density_treeha REAL,
              aboveGroundBiomass_kgha REAL,
              foliageBiomass_kgha REAL,
              branchesBiomass_kgha REAL,
              stemBiomass_kgha  REAL ,
              rootBiomass_kgha REAL,
              stumpCoarseRootBiomass_kgha REAL,
              lai REAL,
              PRIMARY KEY (record_id),
              FOREIGN KEY (site_id) REFERENCES SITESID_master(site_id),
              FOREIGN KEY (species_id) REFERENCES TREESPECIES_master(species_id)
            )")

# Check the table
dbListTables(db) # The tables in the database
dbListFields(db, "STAND_master") # The fields in the table
## Close connnection to db
dbDisconnect(db)
# dbSendQuery(db, "DROP TABLE TREE")
#------------------------------------------------------------------------------#
#               ENTER DATA IN THE TABLE
#------------------------------------------------------------------------------#
id <- 0
# Loop over files adds data to DB, could also add it to list and then do.call(rbind, listDf)
for (i in 1:length(Stand_Data)){
  df <- Stand_Data[[i]]
  df$record_id <- c((id+1):(id+length(df$site)))
  # open connection to DB
  db <- dbConnect(SQLite(), dbname= myDB)
  df <- df[,columns]
  dbWriteTable(db, "STAND_master", df[,columns], append=TRUE, row.names = FALSE)
  dbDisconnect(db)
  # reset the id values
  id <- id+length(df$site)
}
# create index
db <- dbConnect(SQLite(), dbname=myDB)
# create index for variables we are going to query: so far location, gcm, rcp
# --> change names to include the table
dbGetQuery(db,"CREATE INDEX index_STAND_master_site_id ON STAND_master (site_id)")
dbGetQuery(db,"CREATE INDEX index_STAND_master_species_id ON STAND_master (species_id)")
## Close connnection to db
dbDisconnect(db)


