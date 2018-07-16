# Load libraries
library(sqldf)
library(DBI)
library(RSQLite)

db <- dbConnect(SQLite(), dbname=myDB)
ids <- dbGetQuery(db, "SELECT site_id FROM (SELECT DISTINCT site_id FROM CLIMATEFLUXNET_master)")

tables <- dbListTables(db)

for (i in 1:length(ids[,1])){
  if (!paste("CLIMATE_LOCAL_", ids[i,], sep = "")  %in% tables){
    dbGetQuery(db, paste("CREATE VIEW CLIMATE_LOCAL_", ids[i,], " AS ",
                         "SELECT CLIMATEFLUXNET_master.record_id, ",
                         "SITESID_master.site, ",
                         "CLIMATEFLUXNET_master.site_id, ",
                         "CLIMATEFLUXNET_master.date, ",
                         "CLIMATEFLUXNET_master.day, ",
                         "CLIMATEFLUXNET_master.mo, ", 
                         "CLIMATEFLUXNET_master.year, ",
                         "CLIMATEFLUXNET_master.tmax_degC,",
                         "CLIMATEFLUXNET_master.tmean_degC,",
                         "CLIMATEFLUXNET_master.tmin_degC, ", 
                         "CLIMATEFLUXNET_master.p_mm, ",
                         "CLIMATEFLUXNET_master.relhum_percent, ",
                         "CLIMATEFLUXNET_master.airpress_hPa, ",
                         "CLIMATEFLUXNET_master.rad_Jcm2day, ",
                         "CLIMATEFLUXNET_master.wind_ms, ",
                         "CLIMATEFLUXNET_master.tmax_qc, ",
                         "CLIMATEFLUXNET_master.tmean_qc, ",
                         "CLIMATEFLUXNET_master.tmin_qc, ",
                         "CLIMATEFLUXNET_master.p_qc, ",
                         "CLIMATEFLUXNET_master.relhum_qc, ",
                         "CLIMATEFLUXNET_master.airpress_qc, ",
                         "CLIMATEFLUXNET_master.rad_qc, ",
                         "CLIMATEFLUXNET_master.wind_qc ",
                         "FROM CLIMATEFLUXNET_master INNER JOIN SITESID_master ON CLIMATEFLUXNET_master.site_id = SITESID_master.site_id WHERE CLIMATEFLUXNET_master.site_id = '",
                         ids[i,], "'", sep = "")
    )
  }
}

## Close connnection to db
dbDisconnect(db)
