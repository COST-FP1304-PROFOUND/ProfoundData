# Load libraries
require(sqldf)
require(DBI)
require(RSQLite)
#------------------------------------------------------------------------------#
#                         MODIS 8  DATA
#------------------------------------------------------------------------------#


db <- dbConnect(SQLite(), dbname=myDB)
if ( "MODIS8" %in% dbListTables(db))  dbSendQuery(db, "DROP VIEW MODIS8")
dbGetQuery(db, "CREATE VIEW MODIS8 AS
           SELECT MODIS8_master.record_id,
           SITESID_master.site,
           MODIS8_master.site_id,
           MODIS8_master.date  , 
           MODIS8_master.day  ,
           MODIS8_master.mo  ,
           MODIS8_master.year  , 
           MODIS8_master.gpp_KgCm2 ,
           MODIS8_master.psNet_KgCm2 ,
           MODIS8_master.gpp_qc , 
           MODIS8_master.psNet_qc , 
           MODIS8_master.lstDay_degK ,
           MODIS8_master.lstNight_degK , 
           MODIS8_master.lstDay_qc ,
           MODIS8_master.lstNight_qc ,
           MODIS8_master.reflB01_percent ,
           MODIS8_master.reflB02_percent ,
           MODIS8_master.reflB03_percent ,
           MODIS8_master.reflB04_percent ,
           MODIS8_master.reflB05_percent ,
           MODIS8_master.reflB06_percent ,
           MODIS8_master.reflB07_percent ,
           MODIS8_master.aR_rad ,
           MODIS8_master.aNir_rad ,
           MODIS8_master.aSwir1_rad ,
           MODIS8_master.aSwir2_rad ,
           MODIS8_master.ndwi , 
           MODIS8_master.ndvi8 , 
           MODIS8_master.evi8 ,
           MODIS8_master.refl_qc ,
           MODIS8_master.reflB01_qc ,
           MODIS8_master.reflB02_qc ,
           MODIS8_master.reflB03_qc ,
           MODIS8_master.reflB04_qc ,
           MODIS8_master.reflB05_qc ,
           MODIS8_master.reflB06_qc ,
           MODIS8_master.reflB07_qc ,
           MODIS8_master.atmCor ,
           MODIS8_master.adjCor ,
           MODIS8_master.fpar_percent ,
           MODIS8_master.lai ,
           MODIS8_master.fpar_qc ,
           MODIS8_master.lai_qc 
           FROM MODIS8_master INNER JOIN SITESID_master ON MODIS8_master.site_id = SITESID_master.site_id"
)

## Close connnection to db
dbDisconnect(db)


db <- dbConnect(SQLite(), dbname=myDB)
ids <- dbGetQuery(db, "SELECT site_id FROM (SELECT DISTINCT site_id FROM MODIS8_master)")

for (i in 1:length(ids[,1])){
  if ( paste("MODIS8_", ids[i,], sep = "" ) %in% dbListTables(db))  dbSendQuery(db, paste("DROP VIEW MODIS8_", ids[i,], sep = "" ))
  dbGetQuery(db, paste("CREATE VIEW MODIS8_", ids[i,], " AS ",
                       "SELECT MODIS8_master.record_id, ",
                       "SITESID_master.site, ",
                       "MODIS8_master.site_id, ",
                       "MODIS8_master.date, ",
                       "MODIS8_master.day , ",
                       "MODIS8_master.mo, ",
                       "MODIS8_master.year, ",
                       "MODIS8_master.gpp_KgCm2, ",
                       "MODIS8_master.psNet_KgCm2, ",
                       "MODIS8_master.gpp_qc, " ,
                       "MODIS8_master.psNet_qc, ", 
                       "MODIS8_master.lstDay_degK, ",
                       "MODIS8_master.lstNight_degK, " ,
                       "MODIS8_master.lstDay_qc, ",
                       "MODIS8_master.lstNight_qc, ",
                       "MODIS8_master.reflB01_percent, ",
                       "MODIS8_master.reflB02_percent, ",
                       "MODIS8_master.reflB03_percent,",
                       "MODIS8_master.reflB04_percent,",
                       "MODIS8_master.reflB05_percent,",
                       "MODIS8_master.reflB06_percent, ",
                       "MODIS8_master.reflB07_percent, ",
                       "MODIS8_master.aR_rad, ",
                       "MODIS8_master.aNir_rad, ",
                       "MODIS8_master.aSwir1_rad, ",
                       "MODIS8_master.aSwir2_rad, ",
                       "MODIS8_master.ndwi, " ,
                       "MODIS8_master.ndvi8, " ,
                       "MODIS8_master.evi8, ",
                       "MODIS8_master.refl_qc, ",
                       "MODIS8_master.reflB01_qc, ",
                       "MODIS8_master.reflB02_qc, ",
                       "MODIS8_master.reflB03_qc, ",
                       "MODIS8_master.reflB04_qc, ",
                       "MODIS8_master.reflB05_qc, ",
                       "MODIS8_master.reflB06_qc, ",
                       "MODIS8_master.reflB07_qc, ",
                       "MODIS8_master.atmCor, ",
                       "MODIS8_master.adjCor, ",
                       "MODIS8_master.fpar_percent, " ,
                       "MODIS8_master.lai, ",
                       "MODIS8_master.fpar_qc, ",
                       "MODIS8_master.lai_qc ",
                       "FROM MODIS8_master INNER JOIN SITESID_master ON MODIS8_master.site_id = SITESID_master.site_id WHERE MODIS8_master.site_id = '",
                       ids[i,], "'", sep = "")
  )
}

## Close connnection to db
dbDisconnect(db)

#------------------------------------------------------------------------------#
#                         MODIS 16  DATA
#------------------------------------------------------------------------------#

db <- dbConnect(SQLite(), dbname=myDB)
if ( "MODIS16" %in% dbListTables(db))  dbSendQuery(db, "DROP VIEW MODIS16")
dbGetQuery(db, "CREATE VIEW MODIS16 AS
           SELECT MODIS16_master.record_id,
           SITESID_master.site,
           MODIS16_master.site_id,
           MODIS16_master.date  , 
           MODIS16_master.day  ,
           MODIS16_master.mo  ,
           MODIS16_master.year  , 
           MODIS16_master.ndvi16 , 
           MODIS16_master.evi16 ,
           MODIS16_master.ndvi16_qc ,
           MODIS16_master.evi16_qc
           FROM MODIS16_master INNER JOIN SITESID_master ON MODIS16_master.site_id = SITESID_master.site_id"
)

## Close connnection to db
dbDisconnect(db)


db <- dbConnect(SQLite(), dbname=myDB)
ids <- dbGetQuery(db, "SELECT site_id FROM (SELECT DISTINCT site_id FROM MODIS16_master)")

for (i in 1:length(ids[,1])){
  if ( paste("MODIS16_", ids[i,], sep = "" ) %in% dbListTables(db))  dbSendQuery(db, paste("DROP VIEW MODIS16_", ids[i,], sep = "" ))
  dbGetQuery(db, paste("CREATE VIEW MODIS16_", ids[i,], " AS ",
                       "SELECT MODIS16_master.record_id, ",
                       "SITESID_master.site, ",
                       "MODIS16_master.site_id, ",
                       "MODIS16_master.date, ",
                       "MODIS16_master.day , ",
                       "MODIS16_master.mo, ",
                       "MODIS16_master.year, ",
                       "MODIS16_master.ndvi16, " ,
                       "MODIS16_master.evi16, ",
                       "MODIS16_master.ndvi16_qc, ",
                       "MODIS16_master.evi16_qc ",
                       "FROM MODIS16_master INNER JOIN SITESID_master ON MODIS16_master.site_id = SITESID_master.site_id WHERE MODIS16_master.site_id = '",
                       ids[i,], "'", sep = "")
  )
}

## Close connnection to db
dbDisconnect(db)


## CONSIDER HAVING MODIS LAATOGETHER

#------------------------------------------------------------------------------#
#                         MODIS VIEWS
#------------------------------------------------------------------------------#
db <- dbConnect(SQLite(), dbname=myDB)
if ( "MODIS" %in% dbListTables(db))  dbSendQuery(db, "DROP VIEW MODIS")
dbGetQuery(db, "CREATE VIEW MODIS AS
           SELECT  bar.site,
           foo.site_id,
           foo.date  , 
           foo.day  ,
           foo.mo  ,
           foo.year  , 
           foo.gpp_KgCm2 ,
           foo.psNet_KgCm2 ,
           foo.gpp_qc , 
           foo.psNet_qc , 
           foo.lstDay_degK ,
           foo.lstNight_degK , 
           foo.lstDay_qc ,
           foo.lstNight_qc ,
           foo.reflB01_percent ,
           foo.reflB02_percent ,
           foo.reflB03_percent ,
           foo.reflB04_percent ,
           foo.reflB05_percent ,
           foo.reflB06_percent ,
           foo.reflB07_percent ,
           foo.aR_rad ,
           foo.aNir_rad ,
           foo.aSwir1_rad ,
           foo.aSwir2_rad ,
           foo.ndwi , 
           foo.ndvi8, 
           foo.evi8,
           foo.refl_qc ,
           foo.reflB01_qc ,
           foo.reflB02_qc ,
           foo.reflB03_qc ,
           foo.reflB04_qc ,
           foo.reflB05_qc ,
           foo.reflB06_qc ,
           foo.reflB07_qc ,
           foo.atmCor ,
           foo.adjCor ,
           foo.fpar_percent ,
           foo.lai ,
           foo.fpar_qc ,
           foo.lai_qc,
           foo.ndvi16, 
           foo.evi16,
           foo.ndvi16_qc,
           foo.evi16_qc
           FROM ( SELECT MODIS8_master.record_id,
           MODIS8_master.site_id,
           MODIS8_master.date  , 
           MODIS8_master.day  ,
           MODIS8_master.mo  ,
           MODIS8_master.year  , 
           MODIS8_master.gpp_KgCm2 ,
           MODIS8_master.psNet_KgCm2 ,
           MODIS8_master.gpp_qc , 
           MODIS8_master.psNet_qc , 
           MODIS8_master.lstDay_degK ,
           MODIS8_master.lstNight_degK , 
           MODIS8_master.lstDay_qc ,
           MODIS8_master.lstNight_qc ,
           MODIS8_master.reflB01_percent ,
           MODIS8_master.reflB02_percent ,
           MODIS8_master.reflB03_percent ,
           MODIS8_master.reflB04_percent ,
           MODIS8_master.reflB05_percent ,
           MODIS8_master.reflB06_percent ,
           MODIS8_master.reflB07_percent ,
           MODIS8_master.aR_rad ,
           MODIS8_master.aNir_rad ,
           MODIS8_master.aSwir1_rad ,
           MODIS8_master.aSwir2_rad ,
           MODIS8_master.ndwi , 
           MODIS8_master.ndvi8, 
           MODIS8_master.evi8,
           MODIS8_master.refl_qc ,
           MODIS8_master.reflB01_qc ,
           MODIS8_master.reflB02_qc ,
           MODIS8_master.reflB03_qc ,
           MODIS8_master.reflB04_qc ,
           MODIS8_master.reflB05_qc ,
           MODIS8_master.reflB06_qc ,
           MODIS8_master.reflB07_qc ,
           MODIS8_master.atmCor ,
           MODIS8_master.adjCor ,
           MODIS8_master.fpar_percent ,
           MODIS8_master.lai ,
           MODIS8_master.fpar_qc ,
           MODIS8_master.lai_qc,
           MODIS16_master.ndvi16, 
           MODIS16_master.evi16,
           MODIS16_master.ndvi16_qc,
           MODIS16_master.evi16_qc
           FROM MODIS8_master INNER JOIN MODIS16_master ON (MODIS8_master.site_id = MODIS16_master.site_id AND  MODIS8_master.date = MODIS16_master.date))
           AS foo INNER JOIN SITESID_master as bar ON foo.site_id = bar.site_id "
)

## Close connnection to db
dbDisconnect(db)


db <- dbConnect(SQLite(), dbname=myDB)
ids <- dbGetQuery(db, "SELECT site_id FROM (SELECT DISTINCT site_id FROM MODIS16_master)")

for (i in 1:length(ids[,1])){
  if ( paste("MODIS_", ids[i,], sep = "" ) %in% dbListTables(db))  dbSendQuery(db, paste("DROP VIEW MODIS_", ids[i,], sep = "" ))
  dbGetQuery(db, paste("CREATE VIEW MODIS_", ids[i,], " AS ",
                       "SELECT  bar.site, ",
                       "foo.site_id, ",
                       "foo.date, " ,
                       "foo.day, ",
                       "foo.mo, ",
                       "foo.year, " ,
                       "foo.gpp_KgCm2, ",
                       "foo.psNet_KgCm2, ",
                       "foo.gpp_qc, ", 
                       "foo.psNet_qc, " ,
                       "foo.lstDay_degK, ",
                       "foo.lstNight_degK, " ,
                       "foo.lstDay_qc, ",
                       "foo.lstNight_qc, ",
                       "foo.reflB01_percent, ",
                       "foo.reflB02_percent, ",
                       "foo.reflB03_percent, ", 
                       "foo.reflB04_percent, ",
                       "foo.reflB05_percent, ", 
                       "foo.reflB06_percent, ",
                       "foo.reflB07_percent, ",
                       "foo.aR_rad, ",
                       "foo.aNir_rad, ",
                       "foo.aSwir1_rad, ",
                       "foo.aSwir2_rad, ",
                       "foo.ndwi, ", 
                       "foo.ndvi8, ",
                       "foo.evi8, ",
                       "foo.refl_qc, ",
                       "foo.reflB01_qc, ",
                       "foo.reflB02_qc , ",
                       "foo.reflB03_qc , ",
                       "foo.reflB04_qc , ",
                       "foo.reflB05_qc , ",
                       "foo.reflB06_qc , ",
                       "foo.reflB07_qc , ",
                       "foo.atmCor ,",
                       "foo.adjCor , ",
                       "foo.fpar_percent , ",
                       "foo.lai , ",
                       "foo.fpar_qc , ",
                       "foo.lai_qc, ",
                       "foo.ndwi, ",
                       "foo.ndvi16, ",
                       "foo.evi16, ",
                       "foo.ndvi16_qc, ",
                       "foo.evi16_qc  ",
                       "FROM ( SELECT MODIS8_master.record_id, ",
                       "MODIS8_master.site_id, ",
                       "MODIS8_master.date, ",
                       "MODIS8_master.day, ",
                       "MODIS8_master.mo, ",
                       "MODIS8_master.year, " ,
                       "MODIS8_master.gpp_KgCm2, ",
                       "MODIS8_master.psNet_KgCm2, ",
                       "MODIS8_master.gpp_qc, ", 
                       "MODIS8_master.psNet_qc, " ,
                       "MODIS8_master.lstDay_degK, ",
                       "MODIS8_master.lstNight_degK, " ,
                       "MODIS8_master.lstDay_qc, ",
                       "MODIS8_master.lstNight_qc, ",
                       "MODIS8_master.reflB01_percent, ",
                       "MODIS8_master.reflB02_percent, ",
                       "MODIS8_master.reflB03_percent, ",
                       "MODIS8_master.reflB04_percent, ",
                       "MODIS8_master.reflB05_percent, ",
                       "MODIS8_master.reflB06_percent, ",
                       "MODIS8_master.reflB07_percent, ",
                       "MODIS8_master.aR_rad, ",
                       "MODIS8_master.aNir_rad, ",
                       "MODIS8_master.aSwir1_rad ,",
                       "MODIS8_master.aSwir2_rad, ",
                       "MODIS8_master.ndwi, ",
                       "MODIS8_master.ndvi8, ",
                       "MODIS8_master.evi8, ",
                       "MODIS8_master.refl_qc , ",
                       "MODIS8_master.reflB01_qc , ",
                       "MODIS8_master.reflB02_qc ,",
                       "MODIS8_master.reflB03_qc , ",
                       "MODIS8_master.reflB04_qc , ",
                       "MODIS8_master.reflB05_qc , ",
                       "MODIS8_master.reflB06_qc , ",
                       "MODIS8_master.reflB07_qc , ",
                       "MODIS8_master.atmCor , ",
                       "MODIS8_master.adjCor , ",
                       "MODIS8_master.fpar_percent, ",
                       "MODIS8_master.lai , ",
                       "MODIS8_master.fpar_qc, ",
                       "MODIS8_master.lai_qc, ",
                       "MODIS16_master.ndvi16, ",
                       "MODIS16_master.evi16, ",
                       "MODIS16_master.ndvi16_qc, ",
                       "MODIS16_master.evi16_qc ",
                       "FROM MODIS8_master INNER JOIN MODIS16_master ON (MODIS8_master.site_id = MODIS16_master.site_id AND  MODIS8_master.date = MODIS16_master.date) ",
                       " WHERE MODIS8_master.site_id = '", ids[i,], "')",
                       " AS foo INNER JOIN SITESID_master AS bar ON foo.site_id = bar.site_id ",
                       sep = ""))
}

## Close connnection to db
dbDisconnect(db)

