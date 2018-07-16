# Load libraries
library(sqldf)
library(DBI)
library(RSQLite)

db <- dbConnect(SQLite(), dbname=myDB)
# create index for variables we are going to query: so far location, gcm, rcp
# --> change names to include the table
if ( "NDEPOSITION_EMEP" %in% dbListTables(db))  dbSendQuery(db, "DROP VIEW NDEPOSITION_EMEP")

dbGetQuery(db, "CREATE VIEW NDEPOSITION_EMEP AS
           SELECT NDEPOSITION_EMEP_master.record_id,
           SITESID_master.site,
           NDEPOSITION_EMEP_master.site_id,
           NDEPOSITION_EMEP_master.year,
           NDEPOSITION_EMEP_master.noy_gm2,
           NDEPOSITION_EMEP_master.nhx_gm2
           FROM NDEPOSITION_EMEP_master INNER JOIN SITESID_master ON NDEPOSITION_EMEP_master.site_id = SITESID_master.site_id"
)

## Close connnection to db
dbDisconnect(db)


db <- dbConnect(SQLite(), dbname=myDB)
ids <- dbGetQuery(db, "SELECT site_id FROM (SELECT DISTINCT site_id FROM NDEPOSITION_EMEP_master)")

for (i in 1:length(ids[,1])){
  if (paste("NDEPOSITION_EMEP_", ids[i,], sep = "") %in% dbListTables(db))  dbSendQuery(db,  paste("DROP VIEW NDEPOSITION_EMEP_", ids[i,], sep = ""))
  dbGetQuery(db, paste("CREATE VIEW NDEPOSITION_EMEP_", ids[i,], " AS ",
                       "SELECT NDEPOSITION_EMEP_master.record_id, ",
                       "SITESID_master.site, ",
                       "NDEPOSITION_EMEP_master.site_id, ",
                       "NDEPOSITION_EMEP_master.year, ",
                       "NDEPOSITION_EMEP_master.noy_gm2, ",
                       "NDEPOSITION_EMEP_master.nhx_gm2 ",
                       "FROM NDEPOSITION_EMEP_master INNER JOIN SITESID_master ON NDEPOSITION_EMEP_master.site_id = SITESID_master.site_id WHERE NDEPOSITION_EMEP_master.site_id = '",
                       ids[i,], "'", sep = "")
  )
}

## Close connnection to db
dbDisconnect(db)

