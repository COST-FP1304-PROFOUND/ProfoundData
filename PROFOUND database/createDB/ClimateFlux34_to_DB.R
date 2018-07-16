#------------------------------------------------------------------------------#
# Climated data
#     This script does the following:

#
#------------------------------------------------------------------------------#
load("~/ownCloud/PROFOUND_Data/Processed/RData/FLUX34_meteo.RData")
#------------------------------------------------------------------------------#
#                    CREATE   SQL    TABLE
#------------------------------------------------------------------------------#

columns <- c("IDrecord", "site_id", "date", "day", "mo", "year","tmax_degC",
             "tmean_degC", "tmin_degC", "p_mm", "relhum_percent", 
             "rad_Jcm2day", "wind_ms", "tmax_qf", "tmean_qf", "tmin_qf",
             "p_qf", "relhum_qf", "rad_qf")
# Load libraries
library(sqldf)
library(DBI)
library(RSQLite)
# open connection to DB
db <- dbConnect(SQLite(), dbname= myDB)

if ( "CLIMATEEUROFLUX_master" %in% dbListTables(db)){
  dbSendQuery(db, "DROP TABLE CLIMATEEUROFLUX_master")}


# create table in DB (cant type minus)
dbSendQuery(conn = db,
            "CREATE TABLE CLIMATEEUROFLUX_master
             (IDrecord INTEGER NOT NULL,
              site_id INTEGER NOT NULL,
              date TEXT  NOT NULL,
              day INTEGER CHECK(day > 0 AND day < 32),
              mo INTEGER CHECK(mo > 0 AND mo < 13),
              year INTEGER CHECK(year > 0 AND year < 9999),
              tmax_degC REAL CHECK(NULL OR tmax_degC > -90 AND tmax_degC < 80 ),
              tmean_degC REAL CHECK(NULL OR tmean_degC > -90 AND tmean_degC < 80 ),
              tmin_degC  REAL CHECK(NULL OR tmin_degC > -90 AND tmin_degC < 80 ),
              p_mm REAL  CHECK(NULL OR p_mm >=0 AND p_mm <= 2000),
              relhum_percent REAL CHECK(NULL OR relhum_percent > 0 AND relhum_percent <= 100),
              rad_Jcm2day REAL CHECK(NULL OR rad_Jcm2day >= 0 AND rad_Jcm2day < 4320),
              wind_ms REAL CHECK(NULL OR wind_ms >= 0 AND wind_ms <= 120),
              tmax_qc INTEGER  CHECK(NULL OR tmax_qc >= 0 AND tmax_qc <= 1),
              tmean_qc INTEGER CHECK(NULL OR tmean_qc >= 0 AND tmean_qc <= 1),
              tmin_qc INTEGER CHECK(NULL OR tmin_qc >= 0 AND tmin_qc <= 1),
              p_qc INTEGER CHECK(NULL OR p_qc >= 0 AND p_qc <= 1),
              relhum_qc INTEGER CHECK(NULL OR relhum_qc >= 0 AND relhum_qc <= 1),
              rad_qc INTEGER CHECK(NULL OR rad_qc >= 0 AND rad_qc <= 1),
              PRIMARY KEY (IDrecord),
              FOREIGN KEY (site_id) REFERENCES SITESID_master(site_id)
            )")






# Check the table
dbListTables(db) # The tables in the database
dbListFields(db, "CLIMATEEUROFLUX_master") # The fields in the table
## Close connnection to db
dbDisconnect(db)
#dbSendQuery(db, "DROP TABLE CLIMATE")



#------------------------------------------------------------------------------#
#               ENTER DATA IN THE TABLE
#------------------------------------------------------------------------------#
id <- 0
# Loop over files adds data to DB, could also add it to list and then do.call(rbind, listDf)
#for (i in 1:length(FLUX34_meteo)){
  
  df <- FLUX34_meteo$LeBray
  df$IDrecord <- c((id+1):(id+length(df$site)))
  db <- dbConnect(SQLite(), dbname= myDB)
  #hola <- df[ , columns]
  dbWriteTable(db, "CLIMATEEUROFLUX_master",
               df[ , columns],
               append=TRUE, row.names = FALSE)
  dbDisconnect(db)
  # reset the id values
  id <- id+length(df$site)
#}
#------------------------------------------------------------------------------#
# Close connections and delete data
#------------------------------------------------------------------------------#
# Connect to table and creating indexes for fast querying
# open connection to DB
db <- dbConnect(SQLite(), dbname=myDB)
# create index for variables we are going to query: so far location, gcm, rcp
# --> change names to include the table
dbGetQuery(db,"CREATE INDEX index_CLIMATEEUROFLUX_master_site_id ON CLIMATEEUROFLUX_master (site_id)")

## Close connnection to db
dbDisconnect(db)


db <- dbConnect(SQLite(), dbname=myDB)
ids <- dbGetQuery(db, "SELECT site_id FROM (SELECT DISTINCT site_id FROM CLIMATEEUROFLUX_master)")

for (i in 1:length(ids[,1])){
  dbGetQuery(db, paste("CREATE VIEW CLIMATE_", ids[i,], " AS ",
                       "SELECT CLIMATEEUROFLUX_master.IDrecord, ",
                       "SITESID_master.site, ",
                       "CLIMATEEUROFLUX_master.site_id, ",
                       "CLIMATEEUROFLUX_master.date, ",
                       "CLIMATEEUROFLUX_master.day, ",
                       "CLIMATEEUROFLUX_master.mo, ", 
                       "CLIMATEEUROFLUX_master.year, ",
                       "CLIMATEEUROFLUX_master.tmax_degC,",
                       "CLIMATEEUROFLUX_master.tmean_degC,",
                       "CLIMATEEUROFLUX_master.tmin_degC, ", 
                       "CLIMATEEUROFLUX_master.p_mm, ",
                       "CLIMATEEUROFLUX_master.relhum_percent, ",
                       "CLIMATEEUROFLUX_master.rad_Jcm2day, ",
                       "CLIMATEEUROFLUX_master.wind_ms, ",
                       "CLIMATEEUROFLUX_master.tmax_qc, ",
                       "CLIMATEEUROFLUX_master.tmean_qc, ",
                       "CLIMATEEUROFLUX_master.tmin_qc, ",
                       "CLIMATEEUROFLUX_master.p_qc, ",
                       "CLIMATEEUROFLUX_master.relhum_qc, ",
                       "CLIMATEEUROFLUX_master.rad_qc ",
                       "FROM CLIMATEEUROFLUX_master INNER JOIN SITESID_master ON CLIMATEEUROFLUX_master.site_id = SITESID_master.site_id WHERE CLIMATEEUROFLUX_master.site_id = '",
                       ids[i,], "'", sep = "")
  )
}

## Close connnection to db
dbDisconnect(db)
