#------------------------------------------------------------------------------#
# Sites to DB
#
#------------------------------------------------------------------------------#
# loadsites
load("~/ownCloud/PROFOUND_Data/Processed/RData/Sites.RData")

#------------------------------------------------------------------------------#
#                    CREATE   SQL    TABLE
#------------------------------------------------------------------------------#
# Load libraries
library(sqldf)
library(DBI)
library(RSQLite)
# open connection to DB
#myDB <- "/home/trashtos/ownCloud/PROFOUND_Data/ProfoundData.sqlite"
db <- dbConnect(SQLite(), dbname= myDB)
# create table in DB (cant type minus)
if ( "SITESID_master" %in% dbListTables(db)){
  dbSendQuery(db, "DROP TABLE SITESID_master")}
dbSendQuery(conn = db,
            "CREATE TABLE SITESID_master
             (site_id INTEGER NOT NULL,
              site TEXT,
              site2 TEXT,
              PRIMARY KEY (site_id)
              )")

if ( "SITES_master" %in% dbListTables(db)){
  dbSendQuery(db, "DROP TABLE SITES_master")}
dbSendQuery(conn = db,
            "CREATE TABLE SITES_master
             (site_id INTEGER NOT NULL,
              lat REAL NOT NULL,
              lon REAL NOT NULL,
              epsg INTEGER ,
              country TEXT ,
              aspect_deg  REAL,
              elevation_masl REAL,
              slope_percent REAL,
              natVegetation_code1 TEXT,
              natVegetation_code2 TEXT, 
              natVegetation_description TEXT,
              PRIMARY KEY (site_id)
            )")

# Check the table
dbListTables(db) # The tables in the database
dbListFields(db, "SITESID_master") # The fields in the table
dbListFields(db, "SITES_master")
## Close connnection to db
dbDisconnect(db)
# dbSendQuery(db, "DROP TABLE ISI_MIP")

#------------------------------------------------------------------------------#
#               ENTER DATA IN THE TABLE
#------------------------------------------------------------------------------#
columns <- c("site_id", "name1", "name2")
names(Sites)
db <- dbConnect(SQLite(), dbname= myDB)
dbWriteTable(db, "SITESID_master",
             Sites[,columns],
             append=TRUE, row.names = FALSE)
dbDisconnect(db)


# create index
db <- dbConnect(SQLite(), dbname=myDB)
# create index for variables we are going to query: so far location, gcm, rcp
# --> change names to include the table
dbGetQuery(db,"CREATE INDEX index_SITESID_master_site_id ON SITESID_master (site_id)")
## Close connnection to db
dbDisconnect(db)




columns <- c("site_id", "lat", "lon", "epsg","country",
             "aspect_deg", "elevation_masl", "slope_percent", "natVegetation_code1",
             "natVegetation_code2", "natVegetation_description")
names(Sites)
db <- dbConnect(SQLite(), dbname= myDB)
dbWriteTable(db, "SITES_master",
             Sites[,columns],
             append=TRUE, row.names = FALSE)
dbDisconnect(db)


# create index
db <- dbConnect(SQLite(), dbname=myDB)
# create index for variables we are going to query: so far location, gcm, rcp
# --> change names to include the table
dbGetQuery(db,"CREATE INDEX index_SITES_master_site_id ON SITES_master (site_id)")
dbDisconnect(db)

#if ( "SITESID" %in% dbListTables(db)){
#dbSendQuery(db, "DROP VIEW SITESID")}

#dbGetQuery(db, "CREATE VIEW SITESID AS SELECT
#      SITESID_master.site_id,
#      SITESID_master.site,
#      SITESID_master.site2
#      FROM  SITESID_master"
#)

