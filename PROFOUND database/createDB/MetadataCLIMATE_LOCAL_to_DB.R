#------------------------------------------------------------------------------#
#                         VERSION
#
#------------------------------------------------------------------------------#
load("~/ownCloud/PROFOUND_Data/Processed/RData/METADATA_CLIMATE_LOCAL.RData")
load("~/ownCloud/PROFOUND_Data/Processed/RData/METADATA_CLIMATE_LOCAL_SITES.RData")




#------------------------------------------------------------------------------#
#                    CREATE   SQL    TABLE
#------------------------------------------------------------------------------#
db <- dbConnect(SQLite(), dbname= myDB)
if ( "METADATA_CLIMATE_LOCAL_master" %in% dbListTables(db))  dbSendQuery(db, "DROP TABLE METADATA_CLIMATE_LOCAL_master")
# create table in DB (cant type minus)
dbSendQuery(conn = db,
            "CREATE TABLE METADATA_CLIMATE_LOCAL_master
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
dbListTables(db) # The tables in the database
dbListFields(db, "METADATA_CLIMATE_LOCAL_master") # The fields in the table
## Close connnection to db
dbDisconnect(db)


columns <- c("record_id","variable", "site_id", "type", "units",  "description")
df <- METADATA_CLIMATE_LOCAL[METADATA_CLIMATE_LOCAL$site_id == 99, ]
df$record_id <- c(1:length(df[,1]))
# open connection to DB
db <- dbConnect(SQLite(), dbname= myDB)
dbWriteTable(db, "METADATA_CLIMATE_LOCAL_master", df[,columns], append=TRUE, row.names = FALSE)
dbDisconnect(db)
# reset the id values
#id <- id+length(df$Site)
#}
db <- dbConnect(SQLite(), dbname=myDB)
# create index for variables we are going to query: so far location, gcm, rcp
# --> change names to include the table
dbGetQuery(db,"CREATE INDEX index_METADATA_CLIMATE_LOCAL_master_variable ON METADATA_CLIMATE_LOCAL_master (variable)")
## Close connnection to db
dbDisconnect(db)

#------------------------------------------------------------------------------#
#                   METADATA_CLIMATE_LOCAL_SITES_master
#------------------------------------------------------------------------------#
columns <- c("record_id","variable", "site_id", "comments")

db <- dbConnect(SQLite(), dbname= myDB)
if ( "METADATA_CLIMATE_LOCAL_SITES_master" %in% dbListTables(db)){
  dbSendQuery(db, "DROP TABLE METADATA_CLIMATE_LOCAL_SITES_master")}
# create table in DB (cant type minus)
dbSendQuery(conn = db,
            "CREATE TABLE METADATA_CLIMATE_LOCAL_SITES_master
            (record_id INTEGER NOT NULL,
            variable TEXT,
            site_id INTEGER,
            comments TEXT,
            PRIMARY KEY (record_id),
            FOREIGN KEY (site_id) REFERENCES SITES_ID(site_id)
            )")

# Check the table
dbListFields(db, "METADATA_CLIMATE_LOCAL_SITES_master") # The fields in the table
## Close connnection to db
dbDisconnect(db)
#id <- 0
# Loop over files adds data to DB, could also add it to list and then do.call(rbind, listDf)
#for (i in 1:length(CO2_Data)){
df <- METADATA_CLIMATE_LOCAL_SITES[METADATA_CLIMATE_LOCAL_SITES$site_id!=99,]
df$record_id <- c(1:length(df[,1]))
# open connection to DB
db <- dbConnect(SQLite(), dbname= myDB)
dbWriteTable(db, "METADATA_CLIMATE_LOCAL_SITES_master", df[,columns], append=TRUE, row.names = FALSE)
dbDisconnect(db)
# reset the id values
#id <- id+length(df$Site)
#}
db <- dbConnect(SQLite(), dbname=myDB)
# create index for variables we are going to query: so far location, gcm, rcp
# --> change names to include the table
dbGetQuery(db,"CREATE INDEX index_METADATA_CLIMATE_LOCAL_SITES_master_variable ON METADATA_CLIMATE_LOCAL_SITES_master (variable)")
dbGetQuery(db,"CREATE INDEX index_METADATA_CLIMATE_LOCAL_SITES_master_site_id ON METADATA_CLIMATE_LOCAL_SITES_master (site_id)")
## Close connnection to db
dbDisconnect(db)















# dbGetQuery(db, "CREATE VIEW METADATA_CLIMATE_LOCAL_SITES AS
#              SELECT foo.variable,
#              bar.site,
#               foo.site_id,
#               foo.type,
#               foo.units,
#               foo.description,
#               foo.source,
#               foo.comments
#               FROM (SELECT METADATA_CLIMATE_LOCAL_SITES_master.variable,
#                      METADATA_CLIMATE_LOCAL_SITES_master.site_id,
#                      METADATA_TREE_master.type,
#                      METADATA_TREE_master.units,
#                      METADATA_TREE_master.description,
#                      METADATA_CLIMATE_LOCAL_SITES_master.source,
#                      METADATA_CLIMATE_LOCAL_SITES_master.comments
#                      FROM METADATA_CLIMATE_LOCAL_SITES_master
#                      INNER JOIN METADATA_TREE_master ON  METADATA_CLIMATE_LOCAL_SITES_master.variable = METADATA_TREE_master.variable)
#               AS foo INNER JOIN SITESID_master as bar ON foo.site_id = bar.site_id")
#
## Close connnection to db
#dbDisconnect(db)





