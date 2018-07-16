#------------------------------------------------------------------------------#
#                         METADATA SOIL
#------------------------------------------------------------------------------#
load("~/ownCloud/PROFOUND_Data/Processed/RData/METADATA_SOIL.RData")
load("~/ownCloud/PROFOUND_Data/Processed/RData/METADATA_SOIL_SITES.RData")

#------------------------------------------------------------------------------#
#                   METADATA_SOIL_master
#------------------------------------------------------------------------------#
# Load libraries
library(sqldf)
library(DBI)
library(RSQLite)
# open connection to DB

columns <- c("record_id","variable", "site_id", "type", "units",  "description")

columns[!columns %in% names(METADATA_SOIL)]
names(METADATA_SOIL)[!names(METADATA_SOIL) %in% columns]

db <- dbConnect(SQLite(), dbname= myDB)
if ( "METADATA_SOIL_master" %in% dbListTables(db)){
  dbSendQuery(db, "DROP TABLE METADATA_SOIL_master")}
# create table in DB (cant type minus)
dbSendQuery(conn = db,
            "CREATE TABLE METADATA_SOIL_master
       (record_id INTEGER NOT NULL,
        variable TEXT,
        site_id INTEGER,
        type TEXT NOT NULL,
        units TEXT,
        description TEXT,
        PRIMARY KEY (record_id),
        FOREIGN KEY (site_id) REFERENCES SITES_ID(site_id)
            )")

# Check the table
dbListFields(db, "METADATA_SOIL_master") # The fields in the table
## Close connnection to db
dbDisconnect(db)
# Loop over files adds data to DB, could also add it to list and then do.call(rbind, listDf)
#for (i in 1:length(CO2_Data)){
df <- METADATA_SOIL[METADATA_SOIL$site_id==99,]
df$record_id <- c(1:length(df[,1]))
# open connection to DB
db <- dbConnect(SQLite(), dbname= myDB)
dbWriteTable(db, "METADATA_SOIL_master", df[,columns], append=TRUE, row.names = FALSE)
dbDisconnect(db)
# reset the id values
#id <- id+length(df$Site)
#}
db <- dbConnect(SQLite(), dbname=myDB)
# create index for variables we are going to query: so far location, gcm, rcp
# --> change names to include the table
dbGetQuery(db,"CREATE INDEX index_METADATA_SOIL_master_variable ON METADATA_SOIL_master (variable)")
dbGetQuery(db,"CREATE INDEX index_METADATA_SOIL_master_site_id ON METADATA_SOIL_master (site_id)")
## Close connnection to db
dbDisconnect(db)




#------------------------------------------------------------------------------#
#                   METADATA_SOIL_SITES_master
#------------------------------------------------------------------------------#
columns <- c("record_id","variable", "site_id",  "comments")
columns[!columns %in% names(METADATA_SOIL_SITES)]
names(METADATA_SOIL_SITES)[!names(METADATA_SOIL_SITES) %in% columns]

db <- dbConnect(SQLite(), dbname= myDB)
if ( "METADATA_SOIL_SITES_master" %in% dbListTables(db)){
  dbSendQuery(db, "DROP TABLE METADATA_SOIL_SITES_master")}
# create table in DB (cant type minus)
dbSendQuery(conn = db,
            "CREATE TABLE METADATA_SOIL_SITES_master
            (record_id INTEGER NOT NULL,
            variable TEXT,
            site_id INTEGER,
            comments TEXT,
            PRIMARY KEY (record_id),
            FOREIGN KEY (site_id) REFERENCES SITES_ID(site_id)
            )")

# Check the table
dbListFields(db, "METADATA_SOIL_SITES_master") # The fields in the table
## Close connnection to db
dbDisconnect(db)
#------------------------------------------------------------------------------#
#               ENTER DATA IN THE TABLE
#------------------------------------------------------------------------------#
#id <- 0
# Loop over files adds data to DB, could also add it to list and then do.call(rbind, listDf)
#for (i in 1:length(CO2_Data)){
df <- METADATA_SOIL_SITES[METADATA_SOIL_SITES$site_id!=99,]
df$record_id <- c(1:length(df[,1]))
# open connection to DB
db <- dbConnect(SQLite(), dbname= myDB)
dbWriteTable(db, "METADATA_SOIL_SITES_master", df[,columns], append=TRUE, row.names = FALSE)
dbDisconnect(db)
# reset the id values
#id <- id+length(df$Site)
#}
db <- dbConnect(SQLite(), dbname=myDB)
# create index for variables we are going to query: so far location, gcm, rcp
# --> change names to include the table
dbGetQuery(db,"CREATE INDEX index_METADATA_SOIL_SITES_master_variable ON METADATA_SOIL_SITES_master (variable)")
dbGetQuery(db,"CREATE INDEX index_METADATA_SOIL_SITES_master_site_id ON METADATA_SOIL_SITES_master (site_id)")
## Close connnection to db
dbDisconnect(db)










