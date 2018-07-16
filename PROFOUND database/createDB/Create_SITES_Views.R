# Load libraries
library(sqldf)
library(DBI)
library(RSQLite)


db <- dbConnect(SQLite(), dbname=myDB)
if ( "SITES" %in% dbListTables(db)){
  dbSendQuery(db, "DROP VIEW SITES")}

dbGetQuery(db, "CREATE VIEW SITES AS
           SELECT SITES_master.site_id,
           SITESID_master.site,
           SITES_master.lat,
           SITES_master.lon,
           SITES_master.epsg,
           SITES_master.country,
           SITES_master.aspect_deg,
           SITES_master.elevation_masl,
           SITES_master.slope_percent,
           SITES_master.natVegetation_code1,
           SITES_master.natVegetation_code2, 
           SITES_master.natVegetation_description
           FROM SITES_master INNER JOIN SITESID_master ON SITES_master.site_id = SITESID_master.site_id"
)

## Close connnection to db
dbDisconnect(db)


db <- dbConnect(SQLite(), dbname=myDB)
ids <- dbGetQuery(db, "SELECT site_id FROM (SELECT DISTINCT site_id FROM SITES_master)")
ids <- ids[,1]

for (i in 1:length(ids)){
  
  if ( paste("SITES_", ids[i],sep="") %in% dbListTables(db)){
    dbSendQuery(db, paste("DROP VIEW SITES_", ids[i],sep=""))}
  
  if (ids[i] != 99){
    dbGetQuery(db, paste("CREATE VIEW SITES_", ids[i], " AS ",
                         "SELECT SITES_master.site_id, ",
                         "SITESID_master.site, ",
                         "SITES_master.lat, ",
                         "SITES_master.lon, ",
                         "SITES_master.epsg, ",
                         "SITES_master.country, ", 
                         "SITES_master.aspect_deg, ",
                         "SITES_master.elevation_masl, ",
                         "SITES_master.slope_percent, ",
                         "SITES_master.natVegetation_code1, ",
                         "SITES_master.natVegetation_code2, ",
                         "SITES_master.natVegetation_description ",
                         "FROM SITES_master INNER JOIN SITESID_master ON SITES_master.site_id = SITESID_master.site_id WHERE SITES_master.site_id = '",
                         ids[i], "'", sep = "")
    )
  }
  
}
## Close connnection to db
dbDisconnect(db)

