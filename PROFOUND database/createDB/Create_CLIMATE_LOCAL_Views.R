# Load libraries
library(sqldf)
library(DBI)
library(RSQLite)

db <- dbConnect(SQLite(), dbname=myDB)
# create index for variables we are going to query: so far location, gcm, rcp
ids <- dbGetQuery(db, "SELECT site_id FROM (SELECT DISTINCT site_id FROM CLIMATE_LOCAL_master)")
for (i in 1:length(ids[,1])){
  if ( paste("CLIMATE_LOCAL_", ids[i,],sep = "") %in% dbListTables(db))  dbSendQuery(db,  paste("DROP VIEW CLIMATE_LOCAL_", ids[i,],sep = ""))
  dbGetQuery(db, paste("CREATE VIEW CLIMATE_LOCAL_", ids[i,], " AS ",
                       "SELECT CLIMATE_LOCAL_master.record_id, ",
                       "SITESID_master.site, ",
                       "CLIMATE_LOCAL_master.site_id, ",
                       "CLIMATE_LOCAL_master.date, ",
                       "CLIMATE_LOCAL_master.day, ",
                       "CLIMATE_LOCAL_master.mo, ", 
                       "CLIMATE_LOCAL_master.year, ",
                       "CLIMATE_LOCAL_master.tmax_degC,",
                       "CLIMATE_LOCAL_master.tmean_degC,",
                       "CLIMATE_LOCAL_master.tmin_degC, ", 
                       "CLIMATE_LOCAL_master.p_mm, ",
                       "CLIMATE_LOCAL_master.relhum_percent, ",
                       "CLIMATE_LOCAL_master.airpress_hPa, ",
                       "CLIMATE_LOCAL_master.rad_Jcm2day, ",
                       "CLIMATE_LOCAL_master.wind_ms ",
                       "FROM CLIMATE_LOCAL_master INNER JOIN SITESID_master ON CLIMATE_LOCAL_master.site_id = SITESID_master.site_id WHERE CLIMATE_LOCAL_master.site_id = '",
                       ids[i,], "'", sep = "")
  )
}

## Close connnection to db
dbDisconnect(db)


# Connect to table and creating indexes for fast querying
# open connection to DB
db <- dbConnect(SQLite(), dbname=myDB)

if ( "CLIMATE_LOCAL" %in% dbListTables(db))  dbSendQuery(db, "DROP VIEW CLIMATE_LOCAL")

dbGetQuery(db, "CREATE VIEW CLIMATE_LOCAL AS 
           SELECT foo.record_id,
           bar.site,
           foo.site_id,
           foo.date,
           foo.day,
           foo.mo,
           foo.year,
           foo.tmax_degC,
           foo.tmean_degC,
           foo.tmin_degC,
           foo.p_mm,
           foo.relhum_percent,
           foo.airpress_hPa,
           foo.rad_Jcm2day,
           foo.wind_ms,
           foo.tmax_qc,
           foo.tmean_qc,
           foo.tmin_qc ,
           foo.p_qc ,
           foo.relhum_qc,
           foo.airpress_qc,
           foo.rad_qc,
           foo.wind_qc
           FROM (SELECT record_id,
           site_id,
           date,
           day,
           mo,
           year,
           tmax_degC,
           tmean_degC,
           tmin_degC,
           p_mm,
           relhum_percent,
           airpress_hPa,
           rad_Jcm2day,
           wind_ms,
           NULL AS tmax_qc ,
           NULL AS tmean_qc,
           NULL AS tmin_qc ,
           NULL AS p_qc ,
           NULL AS relhum_qc,
           NULL AS airpress_qc,
           NULL AS rad_qc,
           NULL AS wind_qc
           FROM CLIMATE_LOCAL_master
           UNION 
           SELECT record_id,
           site_id,
           date,
           day,
           mo,
           year,
           tmax_degC,
           tmean_degC,
           tmin_degC,
           p_mm,
           relhum_percent,
           airpress_hPa,
           rad_Jcm2day,
           wind_ms,
           tmax_qc,
           tmean_qc,
           tmin_qc ,
           p_qc ,
           relhum_qc,
           airpress_qc,
           rad_qc,
           wind_qc 
           FROM CLIMATEFLUXNET_master)
           as foo  INNER JOIN SITESID_master as bar ON foo.site_id = bar.site_id")


## Close connnection to db
dbDisconnect(db)
