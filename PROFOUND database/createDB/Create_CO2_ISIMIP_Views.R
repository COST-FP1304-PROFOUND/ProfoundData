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
           CO2_ISIMIP_master.forcingConditions,
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
                       "CO2_ISIMIP_master.forcingConditions, ",
                       "CO2_ISIMIP_master.co2_ppm ",
                       "FROM CO2_ISIMIP_master INNER JOIN SITESID_master ON CO2_ISIMIP_master.site_id = SITESID_master.site_id ",
                       sep = "")
  )
}

## Close connnection to db
dbDisconnect(db)


db <- dbConnect(SQLite(), dbname=myDB)
forcingConditions <- dbGetQuery(db, "SELECT forcingConditions FROM (SELECT DISTINCT forcingConditions FROM CO2_ISIMIP_master)")
ids <- dbGetQuery(db, "SELECT site_id FROM (SELECT DISTINCT site_id FROM SITES_master)")

for (i in 1:length(forcingConditions[,1])){
  if ( paste("CO2_ISIMIP_", forcingConditions[i,],sep = "") %in% dbListTables(db))  dbSendQuery(db, paste("DROP VIEW CO2_ISIMIP_", forcingConditions[i,],sep = ""))
  dbGetQuery(db, paste("CREATE VIEW CO2_ISIMIP_", forcingConditions[i,], " AS ",
                       "SELECT CO2_ISIMIP_master.record_id, ",
                       "SITESID_master.site, ",
                       "CO2_ISIMIP_master.site_id, ",
                       "CO2_ISIMIP_master.year, ",
                       "CO2_ISIMIP_master.forcingConditions, ",
                       "CO2_ISIMIP_master.co2_ppm ",
                       "FROM CO2_ISIMIP_master INNER JOIN SITESID_master ON CO2_ISIMIP_master.site_id = SITESID_master.site_id WHERE CO2_ISIMIP_master.forcingConditions = '",
                       forcingConditions[i,], "'", sep = "")
  )
  for (j in 1:length(ids[,1])){
    if ( paste("CO2_ISIMIP_",forcingConditions[i,],"_", ids[j,],sep = "") %in% dbListTables(db))  dbSendQuery(db, paste("DROP VIEW CO2_ISIMIP_",forcingConditions[i,],"_", ids[j,],sep = ""))
    dbGetQuery(db, paste("CREATE VIEW CO2_ISIMIP_", forcingConditions[i,],"_", ids[j,], " AS ",
                         "SELECT CO2_ISIMIP_master.record_id, ",
                         "SITESID_master.site, ",
                         ids[j,], " AS site_id, ",
                         "CO2_ISIMIP_master.year, ",
                         "CO2_ISIMIP_master.forcingConditions, ",
                         "CO2_ISIMIP_master.co2_ppm ",
                         "FROM CO2_ISIMIP_master INNER JOIN SITESID_master ON CO2_ISIMIP_master.site_id = SITESID_master.site_id WHERE CO2_ISIMIP_master.forcingConditions = '",
                         forcingConditions[i,],"'", sep = "")
    )
  }
}

## Close connnection to db
dbDisconnect(db)


