#------------------------------------------------------------------------------#
#                         PLOTSIZE
#
#------------------------------------------------------------------------------#
load("~/ownCloud/PROFOUND_Data/Processed/RData/PlotSize_Data.RData")
# Target variables
#variables_names <- c( "RCP","year", "CO2")
# Columns DB
columns <- c("record_id","site_id", "year", "size_m2")

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
if ( "PLOTSIZE_master" %in% dbListTables(db)){
  dbSendQuery(db, "DROP TABLE PLOTSIZE_master")}

# create table in DB (cant type minus)
dbSendQuery(conn = db,
            "CREATE TABLE PLOTSIZE_master
            (record_id INTEGER NOT NULL,
            site_id INTEGER NOT NULL,
            year INTEGER NOT NULL,
            size_m2 REAL,
            PRIMARY KEY (record_id),
            FOREIGN KEY (site_id) REFERENCES SITESID_master(site_id)
            )")

# Check the table
dbListTables(db) # The tables in the database
dbListFields(db, "PLOTSIZE_master") # The fields in the table
## Close connnection to db
dbDisconnect(db)
# dbSendQuery(db, "DROP TABLE TREE")

#------------------------------------------------------------------------------#
#               ENTER DATA IN THE TABLE
#------------------------------------------------------------------------------#
#id <- 0
# Loop over files adds data to DB, could also add it to list and then do.call(rbind, listDf)
#for (i in 1:length(CO2_Data)){
df <- PlotSize_Data
df$record_id <- c(1:length(df[,1]))
# open connection to DB
db <- dbConnect(SQLite(), dbname= myDB)
dbWriteTable(db, "PLOTSIZE_master", df[,columns], append=TRUE, row.names = FALSE)
dbDisconnect(db)
# reset the id values
#id <- id+length(df$Site)
db <- dbConnect(SQLite(), dbname=myDB)
# --> change names to include the table
dbGetQuery(db,"CREATE INDEX index_PLOTSIZE_master_site_id ON PLOTSIZE_master (site_id)")
dbGetQuery(db,"CREATE INDEX index_PLOTSIZE_master_year ON PLOTSIZE_master (year)")
## Close connnection to db
dbDisconnect(db)
