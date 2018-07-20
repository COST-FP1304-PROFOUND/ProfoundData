#------------------------------------------------------------------------------#
# Climated data
#     This script does the following:

#
#------------------------------------------------------------------------------#
load("~/ownCloud/PROFOUND_Data/Processed/RData/FLUXNET_Climate.RData")
# loadsites
load("~/ownCloud/PROFOUND_Data/Processed/RData/Sites.RData")
# get the  locations
site <- Sites$site2
site.id <-  Sites$site_id
names(site.id) <- site
#------------------------------------------------------------------------------#
#                    CREATE   SQL    TABLE
#------------------------------------------------------------------------------#
columns <- c("record_id", "site_id", "date", "day", "mo", "year","tmax_degC",
             "tmean_degC", "tmin_degC", "p_mm", "relhum_percent", "airpress_hPa",
             "rad_Jcm2day", "wind_ms", "tmax_qc", "tmean_qc", "tmin_qc",
             "p_qc", "relhum_qc", "airpress_qc", "rad_qc",
             "wind_qc")
# Load libraries
library(sqldf)
library(DBI)
library(RSQLite)
# open connection to DB
db <- dbConnect(SQLite(), dbname= myDB)

if ( "CLIMATEFLUXNET_master" %in% dbListTables(db)){
  dbSendQuery(db, "DROP TABLE CLIMATEFLUXNET_master")}


# create table in DB (cant type minus)
dbSendQuery(conn = db,
            "CREATE TABLE CLIMATEFLUXNET_master
             (record_id INTEGER NOT NULL,
              site_id INTEGER NOT NULL,
              date TEXT  NOT NULL,
              day INTEGER CHECK(day>0 AND day < 32),
              mo INTEGER CHECK(mo>0 AND mo < 13),
              year INTEGER CHECK(year>0 AND year< 9999),
              tmax_degC REAL CHECK(NULL OR tmax_degC > -90 AND tmax_degC < 80 ),
              tmean_degC REAL CHECK(NULL OR tmean_degC > -90 AND tmean_degC < 80 ),
              tmin_degC  REAL CHECK(NULL OR tmin_degC > -90 AND tmin_degC < 80 ),
              p_mm REAL  CHECK(NULL OR p_mm >=0 AND p_mm <= 2000),
              relhum_percent REAL CHECK(NULL OR relhum_percent > 0 AND relhum_percent <= 100),
              airpress_hPa REAL CHECK(NULL OR airpress_hPa > 500 AND airpress_hPa < 1200),
              rad_Jcm2day REAL CHECK(NULL OR rad_Jcm2day >= 0 AND rad_Jcm2day < 4320),
              wind_ms REAL CHECK(NULL OR wind_ms >= 0 AND wind_ms <= 120),
              tmax_qc REAL  CHECK(NULL OR tmax_qc >= 0 AND tmax_qc <= 1),
              tmean_qc REAL CHECK(NULL OR tmean_qc >= 0 AND tmean_qc <= 1),
              tmin_qc REAL CHECK(NULL OR tmin_qc >= 0 AND tmin_qc <= 1),
              p_qc REAL CHECK(NULL OR p_qc >= 0 AND p_qc <= 1),
              relhum_qc REAL CHECK(NULL OR relhum_qc >= 0 AND relhum_qc <= 1),
              airpress_qc REAL CHECK(NULL OR airpress_qc >= 0 AND airpress_qc <= 1),
              rad_qc REAL CHECK(NULL OR rad_qc >= 0 AND rad_qc <= 1),
              wind_qc REAL CHECK(NULL OR wind_qc >= 0 AND wind_qc <= 1),
              PRIMARY KEY (record_id),
              FOREIGN KEY (site_id) REFERENCES SITESID_master(site_id)
            )")






# Check the table
dbListTables(db) # The tables in the database
dbListFields(db, "CLIMATEFLUXNET_master") # The fields in the table
## Close connnection to db
dbDisconnect(db)
#dbSendQuery(db, "DROP TABLE CLIMATE")



#------------------------------------------------------------------------------#
#               ENTER DATA IN THE TABLE
#------------------------------------------------------------------------------#
id <- 0
# Loop over files adds data to DB, could also add it to list and then do.call(rbind, listDf)
for (i in 1:length(FLUXNET_Climate)){
  df <- FLUXNET_Climate[[i]]
  if (unique(df$site) %in% site){
    df$record_id <- c((id+1):(id+length(df$site)))
    db <- dbConnect(SQLite(), dbname= myDB)
    #hola <- df[ , columns]
    dbWriteTable(db, "CLIMATEFLUXNET_master",
                 df[ , columns],
                 append=TRUE, row.names = FALSE)
    dbDisconnect(db)
    # reset the id values
    id <- id+length(df$site)
  }
}
#------------------------------------------------------------------------------#
# Close connections and delete data
#------------------------------------------------------------------------------#
# Connect to table and creating indexes for fast querying
# open connection to DB
db <- dbConnect(SQLite(), dbname=myDB)
# create index for variables we are going to query: so far location, gcm, rcp
# --> change names to include the table
dbGetQuery(db,"CREATE INDEX index_CLIMATEFLUXNET_master_site_id ON CLIMATEFLUXNET_master (site_id)")

## Close connnection to db
dbDisconnect(db)

