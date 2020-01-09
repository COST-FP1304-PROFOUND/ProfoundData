#------------------------------------------------------------------------------#
#                         CO2_ISIMIP Data
#
#------------------------------------------------------------------------------#
load("~/ownCloud/PROFOUND_Data/Processed/RData/CO2_ISIMIP_Data.RData")
# Target variables
#variables_names <- c( "forcingCondition","year", "CO2_ISIMIP")
# Columns DB
columns <- c("record_id",  "site_id" , "year","forcingCondition",  "co2_ppm")

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
if ( "CO2_ISIMIP_master" %in% dbListTables(db))  dbSendQuery(db, "DROP TABLE CO2_ISIMIP_master")

dbSendQuery(conn = db,
            "CREATE TABLE CO2_ISIMIP_master
       (record_id INTEGER NOT NULL,
        site_id INTEGER NOT NULL,
        year INTEGER NOT NULL,
        forcingCondition TEXT NOT NULL,
        co2_ppm REAL CHECK(co2_ppm>0),
        PRIMARY KEY (record_id),
        FOREIGN KEY (site_id) REFERENCES SITESID_master(site_id)
            )")

# Check the table
dbListTables(db) # The tables in the database
dbListFields(db, "CO2_ISIMIP_master") # The fields in the table
## Close connnection to db
dbDisconnect(db)
# dbSendQuery(db, "DROP TABLE CO2_ISIMIP")
#------------------------------------------------------------------------------#
#               ENTER DATA IN THE TABLE
#------------------------------------------------------------------------------#
#id <- 0
# Loop over files adds data to DB, could also add it to list and then do.call(rbind, listDf)
#for (i in 1:length(CO2_ISIMIP_Data)){
df <- CO2_ISIMIP_Data
df$record_id <- c(1:length(df[,1]))
# open connection to DB
db <- dbConnect(SQLite(), dbname= myDB)
dbWriteTable(db, "CO2_ISIMIP_master", df[,columns], append=TRUE, row.names = FALSE)
dbDisconnect(db)
# reset the id values
#id <- id+length(df$Site)
#}
# create index
db <- dbConnect(SQLite(), dbname=myDB)
# create index for variables we are going to query: so far location, gcm, forcingCondition
# --> change names to include the table
dbGetQuery(db,"CREATE INDEX index_CO2_ISIMIP_master_forcingCondition ON CO2_ISIMIP_master (forcingCondition)")
dbGetQuery(db,"CREATE INDEX index_CO2_ISIMIP_master_site_id ON CO2_ISIMIP_master(site_id)")
dbDisconnect(db)

