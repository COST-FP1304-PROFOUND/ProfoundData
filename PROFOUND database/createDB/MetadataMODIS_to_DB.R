
load("~/ownCloud/PROFOUND_Data/Processed/RData/METADATA_MODIS.RData")

#------------------------------------------------------------------------------#
#                   METADATA_MODIS
#------------------------------------------------------------------------------#
# Load libraries
require(sqldf)
require(DBI)
require(RSQLite)


#------------------------------------------------------------------------------#
#                   METADATA_MODIS8
#------------------------------------------------------------------------------#
columns <- c("record_id","variable", "site_id", "type", "units",  "description")
db <- dbConnect(SQLite(), dbname= myDB)
if ( "METADATA_MODIS8_master" %in% dbListTables(db))  dbSendQuery(db, "DROP TABLE METADATA_MODIS8_master")
# create table in DB (cant type minus)
dbSendQuery(conn = db,
            "CREATE TABLE METADATA_MODIS8_master
       (record_id INTEGER NOT NULL,
        variable TEXT,
        site_id INTEGER,
        type TEXT NOT NULL,
        units TEXT NOT NULL,
        description TEXT NOT NULL,
        PRIMARY KEY (record_id),
        FOREIGN KEY (site_id) REFERENCES SITES_ID(site_id)
            )")

# Check the table
dbListFields(db, "METADATA_MODIS8_master") # The fields in the table
## Close connnection to db
dbDisconnect(db)
# Loop over files adds data to DB, could also add it to list and then do.call(rbind, listDf)
#for (i in 1:length(CO2_Data)){
df <- METADATA_MODIS[METADATA_MODIS$site_id==99 & METADATA_MODIS$datasets=="MODIS8",]
df$record_id <- c(1:length(df[,1]))
# open connection to DB
db <- dbConnect(SQLite(), dbname= myDB)
dbWriteTable(db, "METADATA_MODIS8_master", df[,columns], append=TRUE, row.names = FALSE)
dbDisconnect(db)
# reset the id values
#id <- id+length(df$Site)
#}
db <- dbConnect(SQLite(), dbname=myDB)
# create index for variables we are going to query: so far location, gcm, rcp
# --> change names to include the table
dbGetQuery(db,"CREATE INDEX index_METADATA_MODIS8_master_variable ON METADATA_MODIS8_master (variable)")
dbGetQuery(db,"CREATE INDEX index_METADATA_MODIS8_master_site_id ON METADATA_MODIS8_master (site_id)")
## Close connnection to db
dbDisconnect(db)


#------------------------------------------------------------------------------#
#                   METADATA_MODIS16
#------------------------------------------------------------------------------#
columns <- c("record_id","variable", "site_id", "type", "units",  "description")
db <- dbConnect(SQLite(), dbname= myDB)
if ( "METADATA_MODIS16_master" %in% dbListTables(db)){
  dbSendQuery(db, "DROP TABLE METADATA_MODIS16_master")}
# create table in DB (cant type minus)
dbSendQuery(conn = db,
            "CREATE TABLE METADATA_MODIS16_master
            (record_id INTEGER NOT NULL,
            variable TEXT,
            site_id INTEGER,
            type TEXT NOT NULL,
            units TEXT NOT NULL,
            description TEXT NOT NULL,
            PRIMARY KEY (record_id),
            FOREIGN KEY (site_id) REFERENCES SITES_ID(site_id)
            )")

# Check the table
dbListFields(db, "METADATA_MODIS16_master") # The fields in the table
## Close connnection to db
dbDisconnect(db)
# Loop over files adds data to DB, could also add it to list and then do.call(rbind, listDf)
#for (i in 1:length(CO2_Data)){
df <- METADATA_MODIS[METADATA_MODIS$site_id==99 & METADATA_MODIS$datasets=="MODIS16",]
df$record_id <- c(1:length(df[,1]))
# open connection to DB
db <- dbConnect(SQLite(), dbname= myDB)
dbWriteTable(db, "METADATA_MODIS16_master", df[,columns], append=TRUE, row.names = FALSE)
dbDisconnect(db)
# reset the id values
#id <- id+length(df$Site)
#}
db <- dbConnect(SQLite(), dbname=myDB)
# create index for variables we are going to query: so far location, gcm, rcp
# --> change names to include the table
dbGetQuery(db,"CREATE INDEX index_METADATA_MODIS16_master_variable ON METADATA_MODIS16_master (variable)")
dbGetQuery(db,"CREATE INDEX index_METADATA_MODIS16_master_site_id ON METADATA_MODIS16_master (site_id)")
## Close connnection to db
dbDisconnect(db)

#------------------------------------------------------------------------------#
#                   METADATA_MODIS16
#------------------------------------------------------------------------------#
