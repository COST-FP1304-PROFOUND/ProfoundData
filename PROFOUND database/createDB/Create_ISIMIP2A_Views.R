
# Load libraries
library(sqldf)
library(DBI)
library(RSQLite)

# open connection to DB
db <- dbConnect(SQLite(), dbname=myDB)
# create index for variables we are going to query: so far location, forcingDataset
# --> change names to include the table
dbGetQuery(db,"CREATE INDEX index_CLIMATE_ISIMIP2A_master_site_id ON CLIMATE_ISIMIP2A_master (site_id)")
dbGetQuery(db,"CREATE INDEX index_CLIMATE_ISIMIP2A_master_forcingDataset ON CLIMATE_ISIMIP2A_master (forcingDataset)")
## Close connnection to db
if ( "CLIMATE_ISIMIP2A" %in% dbListTables(db))  dbSendQuery(db, "DROP VIEW CLIMATE_ISIMIP2A")

dbGetQuery(db, "CREATE VIEW CLIMATE_ISIMIP2A AS
           SELECT CLIMATE_ISIMIP2A_master.record_id,
           SITESID_master.site,
           CLIMATE_ISIMIP2A_master.site_id,
           CLIMATE_ISIMIP2A_master.date ,
           CLIMATE_ISIMIP2A_master.forcingDataset,
           CLIMATE_ISIMIP2A_master.day,
           CLIMATE_ISIMIP2A_master.mo,
           CLIMATE_ISIMIP2A_master.year,
           CLIMATE_ISIMIP2A_master.tmax_degC,
           CLIMATE_ISIMIP2A_master.tmean_degC,
           CLIMATE_ISIMIP2A_master.tmin_degC,
           CLIMATE_ISIMIP2A_master.p_mm,
           CLIMATE_ISIMIP2A_master.relhum_percent,
           CLIMATE_ISIMIP2A_master.airpress_hPa,
           CLIMATE_ISIMIP2A_master.rad_Jcm2,
           CLIMATE_ISIMIP2A_master.wind_ms
           FROM CLIMATE_ISIMIP2A_master INNER JOIN SITESID_master ON CLIMATE_ISIMIP2A_master.site_id = SITESID_master.site_id"
)
dbDisconnect(db)


db <- dbConnect(SQLite(), dbname=myDB)

ids <- dbGetQuery(db, "SELECT site_id FROM (SELECT DISTINCT site_id FROM CLIMATE_ISIMIP2A_master)"  )
for (j in 1:length(ids[, 1])){
  if ( paste("CLIMATE_ISIMIP2A_", ids[j,], sep="") %in% dbListTables(db))  dbSendQuery(db, paste("DROP VIEW CLIMATE_ISIMIP2A_", ids[j,], sep="") )
  dbGetQuery(db,  paste("CREATE VIEW CLIMATE_ISIMIP2A_",  ids[j,],  " AS ",
                        "SELECT CLIMATE_ISIMIP2A_master.record_id, ",
                        "SITESID_master.site, ",
                        "CLIMATE_ISIMIP2A_master.site_id, ",
                        "CLIMATE_ISIMIP2A_master.date, ",
                        "CLIMATE_ISIMIP2A_master.forcingDataset, ",
                        "CLIMATE_ISIMIP2A_master.day, ",
                        "CLIMATE_ISIMIP2A_master.mo, ",
                        "CLIMATE_ISIMIP2A_master.year, ",
                        "CLIMATE_ISIMIP2A_master.tmax_degC, ",
                        "CLIMATE_ISIMIP2A_master.tmean_degC, ",
                        "CLIMATE_ISIMIP2A_master.tmin_degC, ",
                        "CLIMATE_ISIMIP2A_master.p_mm, ",
                        "CLIMATE_ISIMIP2A_master.relhum_percent, ",
                        "CLIMATE_ISIMIP2A_master.airpress_hPa, ",
                        "CLIMATE_ISIMIP2A_master.rad_Jcm2, ",
                        "CLIMATE_ISIMIP2A_master.wind_ms ",
                        "FROM CLIMATE_ISIMIP2A_master INNER JOIN SITESID_master ON CLIMATE_ISIMIP2A_master.site_id = SITESID_master.site_id  WHERE CLIMATE_ISIMIP2A_master.site_id = '",
                        ids[j,], "'", sep = "") )
  
}
dbDisconnect(db)





db <- dbConnect(SQLite(), dbname=myDB)
forcingDataset <- dbGetQuery(db, "SELECT forcingDataset FROM (SELECT DISTINCT forcingDataset FROM CLIMATE_ISIMIP2A_master)"  )[,1]

for (i in 1:length(forcingDataset)){
  if ( paste("CLIMATE_ISIMIP2A_", forcingDataset[i], sep="") %in% dbListTables(db))  dbSendQuery(db, paste("DROP VIEW CLIMATE_ISIMIP2A_", forcingDataset[i], sep="") )
  dbGetQuery(db,  paste("CREATE VIEW CLIMATE_ISIMIP2A_", forcingDataset[i], " AS ",
                        "SELECT CLIMATE_ISIMIP2A_master.record_id, ",
                        "SITESID_master.site, ",
                        "CLIMATE_ISIMIP2A_master.site_id, ",
                        "CLIMATE_ISIMIP2A_master.date, ",
                        "CLIMATE_ISIMIP2A_master.forcingDataset, ",
                        "CLIMATE_ISIMIP2A_master.day, ",
                        "CLIMATE_ISIMIP2A_master.mo, ",
                        "CLIMATE_ISIMIP2A_master.year, ",
                        "CLIMATE_ISIMIP2A_master.tmax_degC, ",
                        "CLIMATE_ISIMIP2A_master.tmean_degC, ",
                        "CLIMATE_ISIMIP2A_master.tmin_degC, ",
                        "CLIMATE_ISIMIP2A_master.p_mm, ",
                        "CLIMATE_ISIMIP2A_master.relhum_percent, ",
                        "CLIMATE_ISIMIP2A_master.airpress_hPa, ",
                        "CLIMATE_ISIMIP2A_master.rad_Jcm2, ",
                        "CLIMATE_ISIMIP2A_master.wind_ms ",
                        "FROM CLIMATE_ISIMIP2A_master INNER JOIN SITESID_master ON CLIMATE_ISIMIP2A_master.site_id = SITESID_master.site_id   WHERE CLIMATE_ISIMIP2A_master.forcingDataset = '",
                        forcingDataset[i], "'", sep = "")  )
}
dbDisconnect(db)



db <- dbConnect(SQLite(), dbname=myDB)

for (i in 1:length(forcingDataset)){
  ids <- dbGetQuery(db, paste("SELECT site_id FROM (SELECT DISTINCT site_id FROM CLIMATE_ISIMIP2A_master WHERE forcingDataset = '", 
                              forcingDataset[i], "')", sep = "")  )
  forcingDataset <- dbGetQuery(db, "SELECT forcingDataset FROM (SELECT DISTINCT forcingDataset FROM CLIMATE_ISIMIP2A_master)"  )[,1]
  
  for (j in 1:length(ids[, 1])){
    if ( paste("CLIMATE_ISIMIP2A_", forcingDataset[i],"_",  ids[j,], sep="") %in% dbListTables(db))  dbSendQuery(db, paste("DROP VIEW CLIMATE_ISIMIP2A_", forcingDataset[i],"_",  ids[j,], sep="") )
    dbGetQuery(db,  paste("CREATE VIEW CLIMATE_ISIMIP2A_", forcingDataset[i],"_",  ids[j,],  " AS ",
                          "SELECT CLIMATE_ISIMIP2A_master.record_id, ",
                          "SITESID_master.site, ",
                          "CLIMATE_ISIMIP2A_master.site_id, ",
                          "CLIMATE_ISIMIP2A_master.date, ",
                          "CLIMATE_ISIMIP2A_master.forcingDataset, ",
                          "CLIMATE_ISIMIP2A_master.day, ",
                          "CLIMATE_ISIMIP2A_master.mo, ",
                          "CLIMATE_ISIMIP2A_master.year, ",
                          "CLIMATE_ISIMIP2A_master.tmax_degC, ",
                          "CLIMATE_ISIMIP2A_master.tmean_degC, ",
                          "CLIMATE_ISIMIP2A_master.tmin_degC, ",
                          "CLIMATE_ISIMIP2A_master.p_mm, ",
                          "CLIMATE_ISIMIP2A_master.relhum_percent, ",
                          "CLIMATE_ISIMIP2A_master.airpress_hPa, ",
                          "CLIMATE_ISIMIP2A_master.rad_Jcm2, ",
                          "CLIMATE_ISIMIP2A_master.wind_ms ",
                          "FROM CLIMATE_ISIMIP2A_master INNER JOIN SITESID_master ON CLIMATE_ISIMIP2A_master.site_id = SITESID_master.site_id  WHERE CLIMATE_ISIMIP2A_master.forcingDataset = '",
                          forcingDataset[i], "' AND CLIMATE_ISIMIP2A_master.site_id = '", ids[j,], "'", sep = "") )
  }
}
dbDisconnect(db)

