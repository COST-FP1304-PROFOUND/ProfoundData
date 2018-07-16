  #------------------------------------------------------------------------------#
#                         MODIS DATA
#------------------------------------------------------------------------------#

#------------------------------------------------------------------------------#
#                         MODIS 8  DATA
#------------------------------------------------------------------------------#
load("~/ownCloud/PROFOUND_Data/Processed/RData/MODIS8_Data.RData")
# Target variables
#variables_names <- c( "RCP","year", "CO2")
# Columns DB
columns <- c("record_id",  "site_id", "date", "day", "mo", "year", "gpp_KgCm2",
             "psNet_KgCm2", "gpp_qc", "psNet_qc", "lstDay_degK", "lstNight_degK", 
             "lstDay_qc", "lstNight_qc", "reflB01_percent", "reflB02_percent",
             "reflB03_percent", "reflB04_percent", "reflB05_percent", "reflB06_percent",
             "reflB07_percent", "aR_rad", "aNir_rad", "aSwir1_rad", "aSwir2_rad",
             "ndwi", "ndvi", "evi", "refl_qc", "reflB01_qc", "reflB02_qc", "reflB03_qc",
             "reflB04_qc", "reflB05_qc", "reflB06_qc", "reflB07_qc", "atmCor" ,
             "adjCor", "fpar_percent", "lai", "fpar_qc", "lai_qc")

# Load libraries
require(sqldf)
require(DBI)
require(RSQLite)
# open connection to DB
db <- dbConnect(SQLite(), dbname= myDB)
# create table in DB (cant type minus)
if ( "MODIS8_master" %in% dbListTables(db))  dbSendQuery(db, "DROP TABLE MODIS8_master")

dbSendQuery(conn = db,
            "CREATE TABLE MODIS8_master
       (record_id INTEGER NOT NULL,
        site_id INTEGER NOT NULL,
        date TEXT NOT NULL, 
        day INTEGER NOT NULL,
        mo INTEGER NOT NULL,
        year INTEGER NOT NULL, 
        gpp_KgCm2 REAL,
        psNet_KgCm2 REAL,
        gpp_qc INTEGER, 
        psNet_qc INTEGER, 
        lstDay_degK REAL,
        lstNight_degK REAL, 
        lstDay_qc INTEGER,
        lstNight_qc INTEGER,
        reflB01_percent REAL,
        reflB02_percent REAL,
        reflB03_percent REAL,
        reflB04_percent REAL,
        reflB05_percent REAL,
        reflB06_percent REAL,
        reflB07_percent REAL,
        aR_rad REAL,
        aNir_rad REAL,
        aSwir1_rad REAL,
        aSwir2_rad REAL,
        ndwi REAL, 
        ndvi8 REAL, 
        evi8 REAL,
        refl_qc INTEGER,
        reflB01_qc INTEGER,
        reflB02_qc INTEGER,
        reflB03_qc INTEGER,
        reflB04_qc INTEGER,
        reflB05_qc INTEGER,
        reflB06_qc INTEGER,
        reflB07_qc INTEGER,
        atmCor TEXT,
        adjCor TEXT,
        fpar_percent REAL,
        lai REAL,
        fpar_qc INTEGER,
        lai_qc INTEGER,
        PRIMARY KEY (record_id),
        FOREIGN KEY (site_id) REFERENCES SITESID_master(site_id)
            )")

# Check the table
dbListTables(db) # The tables in the database
dbListFields(db, "MODIS8_master") # The fields in the table
## Close connnection to db
dbDisconnect(db)
# dbSendQuery(db, "DROP TABLE CO2")
#id <- 0
# Loop over files adds data to DB, could also add it to list and then do.call(rbind, listDf)
#for (i in 1:length(MODIS8_DATA)){
df <- MODIS8_Data
df$record_id <- c(1:length(df[,1]))
# open connection to DB
db <- dbConnect(SQLite(), dbname= myDB)
dbWriteTable(db, "MODIS8_master", df[,columns], append=TRUE, row.names = FALSE)
dbDisconnect(db)
# reset the id values
#id <- id+length(df$Site)
#}
# create index
db <- dbConnect(SQLite(), dbname=myDB)
# create index for variables we are going to query: so far location, gcm, rcp
# --> change names to include the table
dbGetQuery(db,"CREATE INDEX index_MODIS8_master_site_id ON MODIS8_master(site_id)")
dbDisconnect(db)

#------------------------------------------------------------------------------#
#                         MODIS 16  DATA
#------------------------------------------------------------------------------#
load("~/ownCloud/PROFOUND_Data/Processed/RData/MODIS16_Data.RData")
# Target variables
#variables_names <- c( "RCP","year", "CO2")
# Columns DB
columns <- c("record_id",  "site_id", "date", "day", "mo", "year","ndvi", "evi",
             "ndvi_qc", "evi_qc")

# Load libraries
require(sqldf)
require(DBI)
require(RSQLite)
# open connection to DB
db <- dbConnect(SQLite(), dbname= myDB)
# create table in DB (cant type minus)
if ( "MODIS16_master" %in% dbListTables(db)){
  dbSendQuery(db, "DROP TABLE MODIS16_master")}

dbSendQuery(conn = db,
            "CREATE TABLE MODIS16_master
            (record_id INTEGER NOT NULL,
            site_id INTEGER NOT NULL,
            date TEXT NOT NULL, 
            day INTEGER NOT NULL,
            mo INTEGER NOT NULL,
            year INTEGER NOT NULL, 
            ndvi16 REAL, 
            evi16 REAL,
            ndvi16_qc INTEGER,
            evi16_qc INTEGER,
            PRIMARY KEY (record_id),
            FOREIGN KEY (site_id) REFERENCES SITESID_master(site_id)
            )")

# Check the table
dbListTables(db) # The tables in the database
dbListFields(db, "MODIS16_master") # The fields in the table
## Close connnection to db
dbDisconnect(db)
# dbSendQuery(db, "DROP TABLE CO2")
#id <- 0
# Loop over files adds data to DB, could also add it to list and then do.call(rbind, listDf)
#for (i in 1:length(MODIS16_DATA)){
df <- MODIS16_Data
df$record_id <- c(1:length(df[,1]))
# open connection to DB
db <- dbConnect(SQLite(), dbname= myDB)
dbWriteTable(db, "MODIS16_master", df[,columns], append=TRUE, row.names = FALSE)
dbDisconnect(db)
# reset the id values
#id <- id+length(df$Site)
#}
# create index
db <- dbConnect(SQLite(), dbname=myDB)
# create index for variables we are going to query: so far location, gcm, rcp
# --> change names to include the table
dbGetQuery(db,"CREATE INDEX index_MODIS16_master_site_id ON MODIS16_master(site_id)")
dbDisconnect(db)

