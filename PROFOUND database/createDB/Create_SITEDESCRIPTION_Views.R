# Load libraries
library(sqldf)
library(DBI)
library(RSQLite)


# create index
db <- dbConnect(SQLite(), dbname=myDB)
if ( "SITEDESCRIPTION" %in% dbListTables(db)){
  dbSendQuery(db, "DROP VIEW SITEDESCRIPTION")}
# --> change names to include the table
dbGetQuery(db, "CREATE VIEW SITEDESCRIPTION AS
           SELECT SITEDESCRIPTION_master.record_id,
           SITESID_master.site,
          SITEDESCRIPTION_master.site_id,
          SITEDESCRIPTION_master.description, 
          SITEDESCRIPTION_master.reference
           FROM SITEDESCRIPTION_master INNER JOIN SITESID_master ON SITEDESCRIPTION_master.site_id = SITESID_master.site_id "
       #    INNER JOIN PLOTSIZE_master ON TREE_master.site_id = PLOTSIZE_master.site_id AND  TREE_master.year = PLOTSIZE_master.year"
)

## Close connnection to db
dbDisconnect(db)


db <- dbConnect(SQLite(), dbname=myDB)
ids <- dbGetQuery(db, "SELECT site_id FROM (SELECT DISTINCT site_id FROM SITEDESCRIPTION_master)")

for (i in 1:length(ids[,1])){
  if ( paste("SITEDESCRIPTION_",ids[i,], sep ="") %in% dbListTables(db)){
    dbSendQuery(db, paste("DROP VIEW SITEDESCRIPTION_", ids[i,], sep =""))}
  dbGetQuery(db, paste("CREATE VIEW SITEDESCRIPTION_",ids[i,],  " AS ",
                       "SELECT SITEDESCRIPTION_master.record_id, ",
                       "SITESID_master.site, ",
                       "SITEDESCRIPTION_master.site_id, ",
                       "SITEDESCRIPTION_master.description,  ",
                       "SITEDESCRIPTION_master.reference ",
                       "FROM SITEDESCRIPTION_master INNER JOIN SITESID_master ON SITEDESCRIPTION_master.site_id = SITESID_master.site_id ", 
                      # "INNER JOIN PLOTSIZE_master ONSITEDESCRIPTION_master.site_id = PLOTSIZE_master.site_id AND SITEDESCRIPTION_master.year = PLOTSIZE_master.year ",
                       "WHERE SITEDESCRIPTION_master.site_id = '", ids[i,], "'",
                       sep = "")
  )
  
}
## Close connnection to db
dbDisconnect(db)
