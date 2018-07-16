#------------------------------------------------------------------------------#
#                   METADATA_MODIS
#------------------------------------------------------------------------------#
load("~/ownCloud/PROFOUND_Data/Processed/RData/METADATA_MODIS_MOD09A1.RData")
load("~/ownCloud/PROFOUND_Data/Processed/RData/METADATA_MODIS_MOD11A2.RData")
load("~/ownCloud/PROFOUND_Data/Processed/RData/METADATA_MODIS_MOD13Q1.RData")
load("~/ownCloud/PROFOUND_Data/Processed/RData/METADATA_MODIS_MOD15A2.RData")
load("~/ownCloud/PROFOUND_Data/Processed/RData/METADATA_MODIS_MOD17A2.RData")
# Load libraries
require(sqldf)
require(DBI)
require(RSQLite)
#------------------------------------------------------------------------------#
#                   METADATA_MODIS_MOD09A1
#------------------------------------------------------------------------------#
columns <- c("record_id","variable", "site_id", "type", "units",  "description", "comments")
db <- dbConnect(SQLite(), dbname= myDB)
if ( "METADATA_MODIS_MOD09A1_master" %in% dbListTables(db))  dbSendQuery(db, "DROP TABLE METADATA_MODIS_MOD09A1_master")
# create table in DB (cant type minus)
dbSendQuery(conn = db,
            "CREATE TABLE METADATA_MODIS_MOD09A1_master
       (record_id INTEGER NOT NULL,
        variable TEXT,
        site_id INTEGER,
        type TEXT NOT NULL,
        units TEXT NOT NULL,
        description TEXT NOT NULL,
        comments TEXT,
        PRIMARY KEY (record_id),
        FOREIGN KEY (site_id) REFERENCES SITES_ID(site_id)
            )")

# Check the table
dbListFields(db, "METADATA_MODIS_MOD09A1_master") # The fields in the table
## Close connnection to db
dbDisconnect(db)
# Loop over files adds data to DB, could also add it to list and then do.call(rbind, listDf)
#for (i in 1:length(CO2_Data)){
df <- METADATA_MODIS_MOD09A1[METADATA_MODIS_MOD09A1$site_id==99,]
df$record_id <- c(1:length(df[,1]))
# open connection to DB
db <- dbConnect(SQLite(), dbname= myDB)
dbWriteTable(db, "METADATA_MODIS_MOD09A1_master", df[,columns], append=TRUE, row.names = FALSE)
dbDisconnect(db)
# reset the id values
#id <- id+length(df$Site)
#}
db <- dbConnect(SQLite(), dbname=myDB)
# create index for variables we are going to query: so far location, gcm, rcp
# --> change names to include the table
dbGetQuery(db,"CREATE INDEX index_METADATA_MODIS_MOD09A1_master_variable ON METADATA_MODIS_MOD09A1_master (variable)")
dbGetQuery(db,"CREATE INDEX index_METADATA_MODIS_MOD09A1_master_site_id ON METADATA_MODIS_MOD09A1_master (site_id)")
## Close connnection to db
dbDisconnect(db)
#------------------------------------------------------------------------------#
#                   METADATA_MODIS_MOD11A2
#------------------------------------------------------------------------------#
columns <- c("record_id","variable", "site_id", "type", "units",  "description", "comments")
db <- dbConnect(SQLite(), dbname= myDB)
if ( "METADATA_MODIS_MOD11A2_master" %in% dbListTables(db))  dbSendQuery(db, "DROP TABLE METADATA_MODIS_MOD11A2_master")
# create table in DB (cant type minus)
dbSendQuery(conn = db,
            "CREATE TABLE METADATA_MODIS_MOD11A2_master
            (record_id INTEGER NOT NULL,
            variable TEXT,
            site_id INTEGER,
            type TEXT NOT NULL,
            units TEXT NOT NULL,
            description TEXT NOT NULL,
            comments TEXT,
            PRIMARY KEY (record_id),
            FOREIGN KEY (site_id) REFERENCES SITES_ID(site_id)
            )")

# Check the table
dbListFields(db, "METADATA_MODIS_MOD11A2_master") # The fields in the table
## Close connnection to db
dbDisconnect(db)
# Loop over files adds data to DB, could also add it to list and then do.call(rbind, listDf)
#for (i in 1:length(CO2_Data)){
df <- METADATA_MODIS_MOD11A2[METADATA_MODIS_MOD11A2$site_id==99,]
df$record_id <- c(1:length(df[,1]))
# open connection to DB
db <- dbConnect(SQLite(), dbname= myDB)
dbWriteTable(db, "METADATA_MODIS_MOD11A2_master", df[,columns], append=TRUE, row.names = FALSE)
dbDisconnect(db)
# reset the id values
#id <- id+length(df$Site)
#}
db <- dbConnect(SQLite(), dbname=myDB)
# create index for variables we are going to query: so far location, gcm, rcp
# --> change names to include the table
dbGetQuery(db,"CREATE INDEX index_METADATA_MODIS_MOD11A2_master_variable ON METADATA_MODIS_MOD11A2_master (variable)")
dbGetQuery(db,"CREATE INDEX index_METADATA_MODIS_MOD11A2_master_site_id ON METADATA_MODIS_MOD11A2_master (site_id)")
## Close connnection to db
dbDisconnect(db)

#------------------------------------------------------------------------------#
#                   METADATA_MODIS_MOD13Q1
#------------------------------------------------------------------------------#
columns <- c("record_id","variable", "site_id", "type", "units",  "description", "comments")
db <- dbConnect(SQLite(), dbname= myDB)
if ( "METADATA_MODIS_MOD13Q1_master" %in% dbListTables(db))  dbSendQuery(db, "DROP TABLE METADATA_MODIS_MOD13Q1_master")
# create table in DB (cant type minus)
dbSendQuery(conn = db,
            "CREATE TABLE METADATA_MODIS_MOD13Q1_master
            (record_id INTEGER NOT NULL,
            variable TEXT,
            site_id INTEGER,
            type TEXT NOT NULL,
            units TEXT NOT NULL,
            description TEXT NOT NULL,
            comments TEXT,
            PRIMARY KEY (record_id),
            FOREIGN KEY (site_id) REFERENCES SITES_ID(site_id)
            )")

# Check the table
dbListFields(db, "METADATA_MODIS_MOD13Q1_master") # The fields in the table
## Close connnection to db
dbDisconnect(db)
# Loop over files adds data to DB, could also add it to list and then do.call(rbind, listDf)
#for (i in 1:length(CO2_Data)){
df <- METADATA_MODIS_MOD13Q1[METADATA_MODIS_MOD13Q1$site_id==99,]
df$record_id <- c(1:length(df[,1]))
# open connection to DB
db <- dbConnect(SQLite(), dbname= myDB)
dbWriteTable(db, "METADATA_MODIS_MOD13Q1_master", df[,columns], append=TRUE, row.names = FALSE)
dbDisconnect(db)
# reset the id values
#id <- id+length(df$Site)
#}
db <- dbConnect(SQLite(), dbname=myDB)
# create index for variables we are going to query: so far location, gcm, rcp
# --> change names to include the table
dbGetQuery(db,"CREATE INDEX index_METADATA_MODIS_MOD13Q1_master_variable ON METADATA_MODIS_MOD13Q1_master (variable)")
dbGetQuery(db,"CREATE INDEX index_METADATA_MODIS_MOD13Q1_master_site_id ON METADATA_MODIS_MOD13Q1_master (site_id)")
## Close connnection to db
dbDisconnect(db)
#------------------------------------------------------------------------------#
#                   METADATA_MODIS_MOD15A2
#------------------------------------------------------------------------------#
columns <- c("record_id","variable", "site_id", "type", "units",  "description", "comments")
db <- dbConnect(SQLite(), dbname= myDB)
if ( "METADATA_MODIS_MOD15A2_master" %in% dbListTables(db))  dbSendQuery(db, "DROP TABLE METADATA_MODIS_MOD15A2_master")
# create table in DB (cant type minus)
dbSendQuery(conn = db,
            "CREATE TABLE METADATA_MODIS_MOD15A2_master
            (record_id INTEGER NOT NULL,
            variable TEXT,
            site_id INTEGER,
            type TEXT NOT NULL,
            units TEXT NOT NULL,
            description TEXT NOT NULL,
            comments TEXT,
            PRIMARY KEY (record_id),
            FOREIGN KEY (site_id) REFERENCES SITES_ID(site_id)
            )")

# Check the table
dbListFields(db, "METADATA_MODIS_MOD15A2_master") # The fields in the table
## Close connnection to db
dbDisconnect(db)
# Loop over files adds data to DB, could also add it to list and then do.call(rbind, listDf)
#for (i in 1:length(CO2_Data)){
df <- METADATA_MODIS_MOD15A2[METADATA_MODIS_MOD15A2$site_id==99,]
df$record_id <- c(1:length(df[,1]))
# open connection to DB
db <- dbConnect(SQLite(), dbname= myDB)
dbWriteTable(db, "METADATA_MODIS_MOD15A2_master", df[,columns], append=TRUE, row.names = FALSE)
dbDisconnect(db)
# reset the id values
#id <- id+length(df$Site)
#}
db <- dbConnect(SQLite(), dbname=myDB)
# create index for variables we are going to query: so far location, gcm, rcp
# --> change names to include the table
dbGetQuery(db,"CREATE INDEX index_METADATA_MODIS_MOD15A2_master_variable ON METADATA_MODIS_MOD15A2_master (variable)")
dbGetQuery(db,"CREATE INDEX index_METADATA_MODIS_MOD15A2_master_site_id ON METADATA_MODIS_MOD15A2_master (site_id)")
## Close connnection to db
dbDisconnect(db)

#------------------------------------------------------------------------------#
#                   METADATA_MODIS_MOD17A2
#------------------------------------------------------------------------------#
columns <- c("record_id","variable", "site_id", "type", "units",  "description", "comments")
db <- dbConnect(SQLite(), dbname= myDB)
if ( "METADATA_MODIS_MOD17A2_master" %in% dbListTables(db))  dbSendQuery(db, "DROP TABLE METADATA_MODIS_MOD17A2_master")
# create table in DB (cant type minus)
dbSendQuery(conn = db,
            "CREATE TABLE METADATA_MODIS_MOD17A2_master
            (record_id INTEGER NOT NULL,
            variable TEXT,
            site_id INTEGER,
            type TEXT NOT NULL,
            units TEXT NOT NULL,
            description TEXT NOT NULL,
            comments TEXT,
            PRIMARY KEY (record_id),
            FOREIGN KEY (site_id) REFERENCES SITES_ID(site_id)
            )")

# Check the table
dbListFields(db, "METADATA_MODIS_MOD17A2_master") # The fields in the table
## Close connnection to db
dbDisconnect(db)
# Loop over files adds data to DB, could also add it to list and then do.call(rbind, listDf)
#for (i in 1:length(CO2_Data)){
df <- METADATA_MODIS_MOD17A2[METADATA_MODIS_MOD17A2$site_id==99,]
df$record_id <- c(1:length(df[,1]))
# open connection to DB
db <- dbConnect(SQLite(), dbname= myDB)
dbWriteTable(db, "METADATA_MODIS_MOD17A2_master", df[,columns], append=TRUE, row.names = FALSE)
dbDisconnect(db)
# reset the id values
#id <- id+length(df$Site)
#}
db <- dbConnect(SQLite(), dbname=myDB)
# create index for variables we are going to query: so far location, gcm, rcp
# --> change names to include the table
dbGetQuery(db,"CREATE INDEX index_METADATA_MODIS_MOD17A2_master_variable ON METADATA_MODIS_MOD17A2_master (variable)")
dbGetQuery(db,"CREATE INDEX index_METADATA_MODIS_MOD17A2_master_site_id ON METADATA_MODIS_MOD17A2_master (site_id)")
## Close connnection to db
dbDisconnect(db)




