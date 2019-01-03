# Load libraries
library(sqldf)
library(DBI)
library(RSQLite)

db <- dbConnect(SQLite(), dbname=myDB)
if ( "CO2_ISIMIP" %in% dbListTables(db))  dbSendQuery(db, "DROP VIEW CO2_ISIMIP")
dbGetQuery(db, "CREATE VIEW CO2_ISIMIP AS
           SELECT CO2_ISIMIP_master.record_id,
           SITESID_master.site,
           CO2_ISIMIP_master.site_id,
           CO2_ISIMIP_master.year,
           CO2_ISIMIP_master.forcingCondition,
           CO2_ISIMIP_master.co2_ppm
           FROM CO2_ISIMIP_master INNER JOIN SITESID_master ON CO2_ISIMIP_master.site_id = SITESID_master.site_id"
)
dbDisconnect(db)


db <- dbConnect(SQLite(), dbname=myDB)
ids <- dbGetQuery(db, "SELECT site_id FROM (SELECT DISTINCT site_id FROM SITES_master)")


for (j in 1:length(ids[,1])){
  if ( paste("CO2_ISIMIP_", ids[j,],sep = "") %in% dbListTables(db))  dbSendQuery(db, paste("DROP VIEW CO2_ISIMIP_", ids[j,],sep = ""))
  dbGetQuery(db, paste("CREATE VIEW CO2_ISIMIP_", ids[j,], " AS ",
                       "SELECT CO2_ISIMIP_master.record_id, ",
                       "SITESID_master.site, ",
                       ids[j,], " AS site_id, ",
                       "CO2_ISIMIP_master.year, ",
                       "CO2_ISIMIP_master.forcingCondition, ",
                       "CO2_ISIMIP_master.co2_ppm ",
                       "FROM CO2_ISIMIP_master INNER JOIN SITESID_master ON CO2_ISIMIP_master.site_id = SITESID_master.site_id ",
                       sep = "")
  )
}

## Close connnection to db
dbDisconnect(db)


db <- dbConnect(SQLite(), dbname=myDB)
forcingCondition <- dbGetQuery(db, "SELECT forcingCondition FROM (SELECT DISTINCT forcingCondition FROM CO2_ISIMIP_master)")
ids <- dbGetQuery(db, "SELECT site_id FROM (SELECT DISTINCT site_id FROM SITES_master)")

for (i in 1:length(forcingCondition[,1])){
  if ( paste("CO2_ISIMIP_", forcingCondition[i,],sep = "") %in% dbListTables(db))  dbSendQuery(db, paste("DROP VIEW CO2_ISIMIP_", forcingCondition[i,],sep = ""))
  dbGetQuery(db, paste("CREATE VIEW CO2_ISIMIP_", forcingCondition[i,], " AS ",
                       "SELECT CO2_ISIMIP_master.record_id, ",
                       "SITESID_master.site, ",
                       "CO2_ISIMIP_master.site_id, ",
                       "CO2_ISIMIP_master.year, ",
                       "CO2_ISIMIP_master.forcingCondition, ",
                       "CO2_ISIMIP_master.co2_ppm ",
                       "FROM CO2_ISIMIP_master INNER JOIN SITESID_master ON CO2_ISIMIP_master.site_id = SITESID_master.site_id WHERE CO2_ISIMIP_master.forcingCondition = '",
                       forcingCondition[i,], "'", sep = "")
  )
  for (j in 1:length(ids[,1])){
    if ( paste("CO2_ISIMIP_",forcingCondition[i,],"_", ids[j,],sep = "") %in% dbListTables(db))  dbSendQuery(db, paste("DROP VIEW CO2_ISIMIP_",forcingCondition[i,],"_", ids[j,],sep = ""))
    dbGetQuery(db, paste("CREATE VIEW CO2_ISIMIP_", forcingCondition[i,],"_", ids[j,], " AS ",
                         "SELECT CO2_ISIMIP_master.record_id, ",
                         "SITESID_master.site, ",
                         ids[j,], " AS site_id, ",
                         "CO2_ISIMIP_master.year, ",
                         "CO2_ISIMIP_master.forcingCondition, ",
                         "CO2_ISIMIP_master.co2_ppm ",
                         "FROM CO2_ISIMIP_master INNER JOIN SITESID_master ON CO2_ISIMIP_master.site_id = SITESID_master.site_id WHERE CO2_ISIMIP_master.forcingCondition = '",
                         forcingCondition[i,],"'", sep = "")
    )
  }
}

## Close connnection to db
dbDisconnect(db)


