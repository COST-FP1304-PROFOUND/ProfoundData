
load("~/ownCloud/PROFOUND_Data/Processed/RData/METADATA_CLIMATE.RData")

#------------------------------------------------------------------------------#
#                   METADATA_CLIMATE_master
#------------------------------------------------------------------------------#
# Load libraries
library(sqldf)
library(DBI)
library(RSQLite)
# open connection to DB

columns <- c("IDrecord","variable", "site_id", "type", "units",  "description", "source")
db <- dbConnect(SQLite(), dbname= myDB)
if ( "METADATA_CLIMATE_master" %in% dbListTables(db)){
  dbSendQuery(db, "DROP TABLE METADATA_CLIMATE_master")}
# create table in DB (cant type minus)
dbSendQuery(conn = db,
            "CREATE TABLE METADATA_CLIMATE_master
       (IDrecord INTEGER NOT NULL,
        variable TEXT,
        site_id INTEGER,
        type TEXT NOT NULL,
        units TEXT NOT NULL,
        description TEXT NOT NULL,
        source TEXT,
        PRIMARY KEY (IDrecord),
        FOREIGN KEY (site_id) REFERENCES SITES_ID(site_id)
            )")

# Check the table
dbListFields(db, "METADATA_CLIMATE_master") # The fields in the table
## Close connnection to db
dbDisconnect(db)
# Loop over files adds data to DB, could also add it to list and then do.call(rbind, listDf)
#for (i in 1:length(CO2_Data)){
df <- METADATA_CLIMATE[METADATA_CLIMATE$site_id==99,]
df$IDrecord <- c(1:length(df[,1]))
# open connection to DB
db <- dbConnect(SQLite(), dbname= myDB)
dbWriteTable(db, "METADATA_CLIMATE_master", df[,columns], append=TRUE, row.names = FALSE)
dbDisconnect(db)
# reset the id values
#id <- id+length(df$Site)
#}
db <- dbConnect(SQLite(), dbname=myDB)
# create index for variables we are going to query: so far location, gcm, rcp
# --> change names to include the table
dbGetQuery(db,"CREATE INDEX index_METADATA_CLIMATE_master_variable ON METADATA_CLIMATE_master (variable)")
dbGetQuery(db,"CREATE INDEX index_METADATA_CLIMATE_master_site_id ON METADATA_CLIMATE_master (site_id)")
## Close connnection to db
dbDisconnect(db)


#------------------------------------------------------------------------------#
#                   METADATA_CLIMATE_SITES_master
#------------------------------------------------------------------------------#
columns <- c("IDrecord","variable", "site_id", "source", "comments")
db <- dbConnect(SQLite(), dbname= myDB)
if ( "METADATA_CLIMATE_SITES_master" %in% dbListTables(db)){
  dbSendQuery(db, "DROP TABLE METADATA_CLIMATE_SITES_master")}
# create table in DB (cant type minus)
dbSendQuery(conn = db,
            "CREATE TABLE METADATA_CLIMATE_SITES_master
            (IDrecord INTEGER NOT NULL,
            variable TEXT,
            site_id INTEGER,
            source TEXT,
            comments TEXT,
            PRIMARY KEY (IDrecord),
            FOREIGN KEY (site_id) REFERENCES SITES_ID(site_id)
            )")

# Check the table
dbListFields(db, "METADATA_CLIMATE_SITES_master") # The fields in the table
## Close connnection to db
dbDisconnect(db)
# Loop over files adds data to DB, could also add it to list and then do.call(rbind, listDf)
#for (i in 1:length(CO2_Data)){
df <- METADATA_CLIMATE[METADATA_CLIMATE$site_id!=99,]
df$IDrecord <- c(1:length(df[,1]))
# open connection to DB
db <- dbConnect(SQLite(), dbname= myDB)
dbWriteTable(db, "METADATA_CLIMATE_SITES_master", df[,columns], append=TRUE, row.names = FALSE)
dbDisconnect(db)
# reset the id values
#id <- id+length(df$Site)
#}
db <- dbConnect(SQLite(), dbname=myDB)
# create index for variables we are going to query: so far location, gcm, rcp
# --> change names to include the table
dbGetQuery(db,"CREATE INDEX index_METADATA_CLIMATE_SITES_master_variable ON METADATA_CLIMATE_SITES_master (variable)")
dbGetQuery(db,"CREATE INDEX index_METADATA_CLIMATE_SITES_master_site_id ON METADATA_CLIMATE_SITES_master (site_id)")
## Close connnection to db
dbDisconnect(db)


db <- dbConnect(SQLite(), dbname= myDB)

dbGetQuery(db, "CREATE VIEW METADATA_CLIMATE_SITES AS
              SELECT foo.variable,
               bar.site,
               foo.site_id,
               foo.type,
               foo.units,
               foo.description,
               foo.source,
               foo.comments
               FROM (SELECT METADATA_CLIMATE_SITES_master.variable,
                      METADATA_CLIMATE_SITES_master.site_id,
                      METADATA_CLIMATE_master.type,
                      METADATA_CLIMATE_master.units,
                      METADATA_CLIMATE_master.description,
                      METADATA_CLIMATE_SITES_master.source,
                      METADATA_CLIMATE_SITES_master.comments
                      FROM METADATA_CLIMATE_SITES_master
                      INNER JOIN METADATA_CLIMATE_master ON  METADATA_CLIMATE_SITES_master.variable = METADATA_CLIMATE_master.variable)
               AS foo INNER JOIN SITESID_master as bar ON foo.site_id = bar.site_id")

## Close connnection to db
dbDisconnect(db)


