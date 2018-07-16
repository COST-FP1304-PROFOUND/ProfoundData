#------------------------------------------------------------------------------#
#                         VERSION
#
#------------------------------------------------------------------------------#
load("~/ownCloud/PROFOUND_Data/Processed/RData/Version_Data.RData")
# Target variables
#variables_names <- c( "RCP","year", "CO2")
# Columns DB
columns <- c("record_id",  "date", "version" , "description")

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
if ( "VERSION_master" %in% dbListTables(db)){
  dbSendQuery(db, "DROP TABLE VERSION_master")}

# create table in DB (cant type minus)
dbSendQuery(conn = db,
            "CREATE TABLE VERSION_master
       (record_id INTEGER PRIMARY KEY,
        date TEXT,
        version TEXT,
        description TEXT
            )")

# Check the table
dbListTables(db) # The tables in the database
dbListFields(db, "VERSION_master") # The fields in the table
## Close connnection to db
dbDisconnect(db)
# dbSendQuery(db, "DROP TABLE TREE")
#------------------------------------------------------------------------------#
#               ENTER DATA IN THE TABLE
#------------------------------------------------------------------------------#
#id <- 0
# Loop over files adds data to DB, could also add it to list and then do.call(rbind, listDf)
#for (i in 1:length(CO2_Data)){
df <- Version_Data
df$record_id <- c(1:length(df[,1]))
  # open connection to DB
db <- dbConnect(SQLite(), dbname= myDB)
dbWriteTable(db, "VERSION_master", df[,columns], append=TRUE, row.names = FALSE)
dbDisconnect(db)
  # reset the id values
#id <- id+length(df$Site)
#}
db <- dbConnect(SQLite(), dbname=myDB)
if ( "VERSION" %in% dbListTables(db)){
  dbSendQuery(db, "DROP VIEW VERSION")}

dbGetQuery(db, "CREATE VIEW VERSION AS SELECT * FROM VERSION_master")
dbDisconnect(db)
