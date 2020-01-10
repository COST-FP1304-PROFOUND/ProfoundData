#------------------------------------------------------------------------------#
#                         Site Description
#
#------------------------------------------------------------------------------#
load("~/ownCloud/PROFOUND_Data/Processed/RData/SiteDescription_Data.RData")
# Target variables
#variables_names <- c( "RCP","year", "CO2")
# Columns DB
columns <- c("IDrecord","site_id", "description", "reference" )

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
       (IDrecord INTEGER NOT NULL,
        site_id INTEGER NOT NULL,
        description TEXT,
        reference TEXT,
        PRIMARY KEY (IDrecord),
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
#id <- 0
# Loop over files adds data to DB, could also add it to list and then do.call(rbind, listDf)
#for (i in 1:length(CO2_Data)){
df <- SiteDescription_Data
df$IDrecord <- c(1:length(df[,1]))
  # open connection to DB
db <- dbConnect(SQLite(), dbname= myDB)
dbWriteTable(db, "SITEDESCRIPTION_master", df[,columns], append=TRUE, row.names = FALSE)
dbDisconnect(db)
  # reset the id values
#id <- id+length(df$Site)
#}

db <- dbConnect(SQLite(), dbname=myDB)
dbGetQuery(db, "CREATE VIEW SITEDESCRIPTION AS SELECT * FROM SITEDESCRIPTION_master")
dbDisconnect(db)
