#------------------------------------------------------------------------------#
#                         VERSION
#
#------------------------------------------------------------------------------#
load("~/ownCloud/PROFOUND_Data/Processed/RData/METADATA_SITEDESCRIPTION.RData")

columns <- c("record_id","variable", "site_id", "type", "units",  "description")
#------------------------------------------------------------------------------#
#                    CREATE   SQL    TABLE
#------------------------------------------------------------------------------#
# Load libraries
# open connection to DB
db <- dbConnect(SQLite(), dbname= myDB)
if ( "METADATA_SITEDESCRIPTION_master" %in% dbListTables(db)){
  dbSendQuery(db, "DROP TABLE METADATA_SITEDESCRIPTION_master")}
# create table in DB (cant type minus)
dbSendQuery(conn = db,
            "CREATE TABLE METADATA_SITEDESCRIPTION_master
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
dbListFields(db, "METADATA_SITEDESCRIPTION_master") # The fields in the table
## Close connnection to db
dbDisconnect(db)
#------------------------------------------------------------------------------#
#               ENTER DATA IN THE TABLE
#------------------------------------------------------------------------------#
#id <- 0
# Loop over files adds data to DB, could also add it to list and then do.call(rbind, listDf)
#for (i in 1:length(CO2_Data)){
df <- METADATA_SITEDESCRIPTION
df$record_id <- c(1:length(df[,1]))
# open connection to DB
db <- dbConnect(SQLite(), dbname= myDB)
dbWriteTable(db, "METADATA_SITEDESCRIPTION_master", df[,columns], append=TRUE, row.names = FALSE)
dbDisconnect(db)
# reset the id values
#id <- id+length(df$Site)
#}
db <- dbConnect(SQLite(), dbname=myDB)
# create index for variables we are going to query: so far location, gcm, rcp
# --> change names to include the table
dbGetQuery(db,"CREATE INDEX index_METADATA_SITEDESCRIPTION_master_variable ON METADATA_SITEDESCRIPTION_master (variable)")
dbGetQuery(db,"CREATE INDEX index_METADATA_SITEDESCRIPTION_master_site_id ON METADATA_SITEDESCRIPTION_master (site_id)")
## Close connnection to db
dbDisconnect(db)



