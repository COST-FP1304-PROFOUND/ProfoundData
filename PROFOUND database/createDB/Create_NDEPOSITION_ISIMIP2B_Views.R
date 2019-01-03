# Load libraries
library(sqldf)
library(DBI)
library(RSQLite)


db <- dbConnect(SQLite(), dbname=myDB)
# create index for variables we are going to query: so far location, gcm, rcp
# --> change names to include the table
if ( "NDEPOSITION_ISIMIP2B" %in% dbListTables(db))  dbSendQuery(db, "DROP VIEW NDEPOSITION_ISIMIP2B")

dbGetQuery(db, "CREATE VIEW NDEPOSITION_ISIMIP2B AS
           SELECT NDEPOSITION_ISIMIP2B_master.record_id,
           SITESID_master.site,
           NDEPOSITION_ISIMIP2B_master.site_id,
           NDEPOSITION_ISIMIP2B_master.forcingCondition,
           NDEPOSITION_ISIMIP2B_master.year,
           NDEPOSITION_ISIMIP2B_master.noy_gm2,
           NDEPOSITION_ISIMIP2B_master.nhx_gm2
           FROM NDEPOSITION_ISIMIP2B_master INNER JOIN SITESID_master ON NDEPOSITION_ISIMIP2B_master.site_id = SITESID_master.site_id"
)

## Close connnection to db
dbDisconnect(db)


db <- dbConnect(SQLite(), dbname=myDB)
ids <- dbGetQuery(db, "SELECT site_id FROM (SELECT DISTINCT site_id FROM NDEPOSITION_ISIMIP2B_master)")

for (i in 1:length(ids[,1])){
  if ( paste("NDEPOSITION_ISIMIP2B_", ids[i,], sep = "") %in% dbListTables(db))  dbSendQuery(db, paste("DROP VIEW NDEPOSITION_ISIMIP2B_", ids[i,], sep = ""))
  dbGetQuery(db, paste("CREATE VIEW NDEPOSITION_ISIMIP2B_", ids[i,], " AS ",
                       "SELECT NDEPOSITION_ISIMIP2B_master.record_id, ",
                       "SITESID_master.site, ",
                       "NDEPOSITION_ISIMIP2B_master.site_id, ",
                       "NDEPOSITION_ISIMIP2B_master.forcingCondition, ",
                       "NDEPOSITION_ISIMIP2B_master.year, ",
                       "NDEPOSITION_ISIMIP2B_master.noy_gm2, ",
                       "NDEPOSITION_ISIMIP2B_master.nhx_gm2 ",
                       "FROM NDEPOSITION_ISIMIP2B_master INNER JOIN SITESID_master ON NDEPOSITION_ISIMIP2B_master.site_id = SITESID_master.site_id WHERE NDEPOSITION_ISIMIP2B_master.site_id = '",
                       ids[i,], "'", sep = "")
  )
}

## Close connnection to db
dbDisconnect(db)


db <- dbConnect(SQLite(), dbname=myDB)
forcingCondition <- dbGetQuery(db, "SELECT forcingCondition FROM (SELECT DISTINCT forcingCondition FROM NDEPOSITION_ISIMIP2B_master)"  )[,1]

for (i in 1:length(forcingCondition)){
  if ( paste("NDEPOSITION_ISIMIP2B_", forcingCondition[i], sep = "") %in% dbListTables(db))  dbSendQuery(db, paste("DROP VIEW NDEPOSITION_ISIMIP2B_", forcingCondition[i], sep = ""))
  dbGetQuery(db,  paste("CREATE VIEW NDEPOSITION_ISIMIP2B_", forcingCondition[i], " AS ",
                        "SELECT NDEPOSITION_ISIMIP2B_master.record_id, ",
                        "SITESID_master.site, ",
                        "NDEPOSITION_ISIMIP2B_master.site_id, ",
                        "NDEPOSITION_ISIMIP2B_master.forcingCondition, ",
                        "NDEPOSITION_ISIMIP2B_master.year, ",
                        "NDEPOSITION_ISIMIP2B_master.noy_gm2, ",
                        "NDEPOSITION_ISIMIP2B_master.nhx_gm2 ",
                        "FROM NDEPOSITION_ISIMIP2B_master INNER JOIN SITESID_master ON NDEPOSITION_ISIMIP2B_master.site_id = SITESID_master.site_id   WHERE NDEPOSITION_ISIMIP2B_master.forcingCondition = '",
                        forcingCondition[i], "'", sep = "")  )
}
dbDisconnect(db)



db <- dbConnect(SQLite(), dbname=myDB)

for (i in 1:length(forcingCondition)){
  ids <- dbGetQuery(db, paste("SELECT site_id FROM (SELECT DISTINCT site_id FROM NDEPOSITION_ISIMIP2B_master WHERE forcingCondition = '", 
                              forcingCondition[i], "')", sep = "")  )
  forcingCondition <- dbGetQuery(db, "SELECT forcingCondition FROM (SELECT DISTINCT forcingCondition FROM NDEPOSITION_ISIMIP2B_master)"  )[,1]
  
  for (j in 1:length(ids[, 1])){
    if ( paste("NDEPOSITION_ISIMIP2B_", forcingCondition[i],"_",  ids[j,],  sep = "") %in% dbListTables(db))  dbSendQuery(db, paste("DROP VIEW NDEPOSITION_ISIMIP2B_", forcingCondition[i],"_",  ids[j,],  sep = ""))
    
    dbGetQuery(db,  paste("CREATE VIEW NDEPOSITION_ISIMIP2B_", forcingCondition[i],"_",  ids[j,],  " AS ",
                          "SELECT NDEPOSITION_ISIMIP2B_master.record_id, ",
                          "SITESID_master.site, ",
                          "NDEPOSITION_ISIMIP2B_master.site_id, ",
                          "NDEPOSITION_ISIMIP2B_master.forcingCondition, ",
                          "NDEPOSITION_ISIMIP2B_master.year, ",
                          "NDEPOSITION_ISIMIP2B_master.noy_gm2, ",
                          "NDEPOSITION_ISIMIP2B_master.nhx_gm2 ",
                          "FROM NDEPOSITION_ISIMIP2B_master INNER JOIN SITESID_master ON NDEPOSITION_ISIMIP2B_master.site_id = SITESID_master.site_id   WHERE NDEPOSITION_ISIMIP2B_master.forcingCondition = '",
                          forcingCondition[i], "' AND NDEPOSITION_ISIMIP2B_master.site_id = '", ids[j,], "'", sep = "") )
  }
}
dbDisconnect(db)
