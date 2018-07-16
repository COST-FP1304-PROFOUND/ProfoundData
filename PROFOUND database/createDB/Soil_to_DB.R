#------------------------------------------------------------------------------#
# Soil data
#     This script does the following:

#
#------------------------------------------------------------------------------#
load("/home/trashtos/ownCloud/PROFOUND_Data/Processed/RData/Soil_Data.RData")
# Target variables
columns <- c("IDrecord", "site_id", "table_id", "layer_id",
             "variable", "value", "description")


#------------------------------------------------------------------------------#
#                    CREATE   SQL    TABLE
#------------------------------------------------------------------------------#
# Load libraries
library(sqldf)
library(DBI)
library(RSQLite)
# open connection to DB
db <- dbConnect(SQLite(), dbname= myDB)
# create table in DB (cant type minus)
if ( "SOIL_master" %in% dbListTables(db)){
  dbSendQuery(db, "DROP TABLE SOIL_master")}



dbSendQuery(conn = db,
            "CREATE TABLE SOIL_master
       (IDrecord INTEGER PRIMARY KEY,
        site_id INTEGER,
        table_id INTEGER,
        layer_id INTEGER,
        variable TEXT,
        value  REAL,
        description TEXT
            )")

# Check the table
dbListTables(db) # The tables in the database
dbListFields(db, "SOIL_master") # The fields in the table
## Close connnection to db
dbDisconnect(db)
# dbSendQuery(db, "DROP TABLE SOIL")

#------------------------------------------------------------------------------#
#               ENTER DATA IN THE TABLE
#------------------------------------------------------------------------------#
id <- 0
# Loop over files adds data to DB, could also add it to list and then do.call(rbind, listDf)
for (i in 1:length(Soil_Data)){
  df <- Soil_Data[[i]]
  df$IDrecord <- c((id+1):(id+length(df$site)))
  # open connection to DB
  db <- dbConnect(SQLite(), dbname= myDB)
  dbWriteTable(db, "SOIL_master",
                 df[,columns],
                 append=TRUE, row.names = FALSE)
  dbDisconnect(db)
  # reset the id values
  id <- id+length(df$site)
}
# create index
db <- dbConnect(SQLite(), dbname=myDB)
# create index for variables we are going to query: so far location, gcm, rcp
# --> change names to include the table
dbGetQuery(db,"CREATE INDEX index_SOIL_master_site_id ON SOIL_master (site_id)")
## Close connnection to db
dbDisconnect(db)
