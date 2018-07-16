#------------------------------------------------------------------------------#
#                         MODIS_MOD09A1 DATA
#------------------------------------------------------------------------------#
rm(columns)
load("~/ownCloud/PROFOUND_Data/Processed/RData/MODIS_MOD09A1_Data.RData")
names(MODIS_MOD09A1_Data)
# Target variables
#variables_names <- c( "RCP","year", "CO2")
# Columns DB
columns <- c("record_id",  "site_id", "date", "day", "mo", "year", 
             "reflB01_percent", "reflB02_percent","reflB03_percent",
             "reflB04_percent", "reflB05_percent", "reflB06_percent",
             "reflB07_percent", "aB01_rad", "aB02_rad", "aB05_rad", "aB06_rad",
             "ndwi", "ndvi", "evi", "sani_rad", "sasi_rad", "refl_qc" )
colnamesDummy <- names(MODIS_MOD09A1_Data)
columns[!columns %in% colnamesDummy] 
colnamesDummy[!colnamesDummy %in% columns] 

# Load libraries
require(sqldf)
require(DBI)
require(RSQLite)
# open connection to DB
db <- dbConnect(SQLite(), dbname= myDB)
# create table in DB (cant type minus)
if ( "MODIS_MOD09A1_master" %in% dbListTables(db))  dbSendQuery(db, "DROP TABLE MODIS_MOD09A1_master")

dbSendQuery(conn = db,
            "CREATE TABLE MODIS_MOD09A1_master
       (record_id INTEGER NOT NULL,
        site_id INTEGER NOT NULL,
        date TEXT NOT NULL, 
        day INTEGER NOT NULL,
        mo INTEGER NOT NULL,
        year INTEGER NOT NULL, 
        reflB01_percent REAL,
        reflB02_percent REAL,
        reflB03_percent REAL,
        reflB04_percent REAL,
        reflB05_percent REAL,
        reflB06_percent REAL,
        reflB07_percent REAL,
        aB01_rad REAL,
        aB02_rad REAL,
        aB05_rad REAL,
        aB06_rad REAL,
        ndwi REAL, 
        ndvi8 REAL, 
        evi8 REAL,
        sasi_rad REAL,
        sani_rad REAL,
        refl_qc INTEGER,
        PRIMARY KEY (record_id),
        FOREIGN KEY (site_id) REFERENCES SITESID_master(site_id)
            )")

# Check the table
dbListTables(db) # The tables in the database
dbListFields(db, "MODIS_MOD09A1_master") # The fields in the table
## Close connnection to db
dbDisconnect(db)
# dbSendQuery(db, "DROP TABLE CO2")
#id <- 0
# Loop over files adds data to DB, could also add it to list and then do.call(rbind, listDf)
#for (i in 1:length(MODIS_MOD09A1_DATA)){
df <- MODIS_MOD09A1_Data
df$record_id <- c(1:length(df[,1]))
df <-df[,columns]
# open connection to DB
db <- dbConnect(SQLite(), dbname= myDB)
dbWriteTable(db, "MODIS_MOD09A1_master", df, append=TRUE, row.names = FALSE)
dbDisconnect(db)
# reset the id values
#id <- id+length(df$Site)
#}
# create index
db <- dbConnect(SQLite(), dbname=myDB)
# create index for variables we are going to query: so far location, gcm, rcp
# --> change names to include the table
dbGetQuery(db,"CREATE INDEX index_MODIS_MOD09A1_master_site_id ON MODIS_MOD09A1_master(site_id)")
dbDisconnect(db)
