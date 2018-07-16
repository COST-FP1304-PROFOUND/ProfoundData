# Load libraries
require(sqldf)
require(DBI)
require(RSQLite)
#------------------------------------------------------------------------------#
#                         MODIS_MOD09A1
#------------------------------------------------------------------------------#
db <- dbConnect(SQLite(), dbname=myDB)
if ( "MODIS_MOD09A1" %in% dbListTables(db))  dbSendQuery(db, "DROP VIEW MODIS_MOD09A1")
dbGetQuery(db, "CREATE VIEW MODIS_MOD09A1 AS
           SELECT MODIS_MOD09A1_master.record_id,
           SITESID_master.site,
           MODIS_MOD09A1_master.site_id,
           MODIS_MOD09A1_master.date  , 
           MODIS_MOD09A1_master.day  ,
           MODIS_MOD09A1_master.mo  ,
           MODIS_MOD09A1_master.year  , 
           MODIS_MOD09A1_master.reflB01_percent ,
           MODIS_MOD09A1_master.reflB02_percent ,
           MODIS_MOD09A1_master.reflB03_percent ,
           MODIS_MOD09A1_master.reflB04_percent ,
           MODIS_MOD09A1_master.reflB05_percent ,
           MODIS_MOD09A1_master.reflB06_percent ,
           MODIS_MOD09A1_master.reflB07_percent ,
           MODIS_MOD09A1_master.aB01_rad ,
           MODIS_MOD09A1_master.aB02_rad ,
           MODIS_MOD09A1_master.aB05_rad ,
           MODIS_MOD09A1_master.aB06_rad ,
           MODIS_MOD09A1_master.ndwi , 
           MODIS_MOD09A1_master.ndvi8 , 
           MODIS_MOD09A1_master.evi8 ,
          MODIS_MOD09A1_master.sasi_rad,
          MODIS_MOD09A1_master.sani_rad,
           MODIS_MOD09A1_master.refl_qc
           FROM MODIS_MOD09A1_master INNER JOIN SITESID_master ON MODIS_MOD09A1_master.site_id = SITESID_master.site_id"
)

## Close connnection to db
dbDisconnect(db)


db <- dbConnect(SQLite(), dbname=myDB)
ids <- dbGetQuery(db, "SELECT site_id FROM (SELECT DISTINCT site_id FROM MODIS_MOD09A1_master)")

for (i in 1:length(ids[,1])){
  if ( paste("MODIS_MOD09A1_", ids[i,], sep = "" ) %in% dbListTables(db))  dbSendQuery(db, paste("DROP VIEW MODIS_MOD09A1_", ids[i,], sep = "" ))
  dbGetQuery(db, paste("CREATE VIEW MODIS_MOD09A1_", ids[i,], " AS ",
                       "SELECT MODIS_MOD09A1_master.record_id, ",
                       "SITESID_master.site, ",
                       "MODIS_MOD09A1_master.site_id, ",
                       "MODIS_MOD09A1_master.date, ",
                       "MODIS_MOD09A1_master.day , ",
                       "MODIS_MOD09A1_master.mo, ",
                       "MODIS_MOD09A1_master.year, ",
                       "MODIS_MOD09A1_master.reflB01_percent, ",
                       "MODIS_MOD09A1_master.reflB02_percent, ",
                       "MODIS_MOD09A1_master.reflB03_percent,",
                       "MODIS_MOD09A1_master.reflB04_percent,",
                       "MODIS_MOD09A1_master.reflB05_percent,",
                       "MODIS_MOD09A1_master.reflB06_percent, ",
                       "MODIS_MOD09A1_master.reflB07_percent, ",
                       "MODIS_MOD09A1_master.aB01_rad, ",
                       "MODIS_MOD09A1_master.aB02_rad, ",
                       "MODIS_MOD09A1_master.aB05_rad, ",
                       "MODIS_MOD09A1_master.aB06_rad, ",
                       "MODIS_MOD09A1_master.ndwi, " ,
                       "MODIS_MOD09A1_master.ndvi8, " ,
                       "MODIS_MOD09A1_master.evi8, ",
                       "MODIS_MOD09A1_master.sasi_rad, ",
                       "MODIS_MOD09A1_master.sani_rad, ",
                       "MODIS_MOD09A1_master.refl_qc ",
                       "FROM MODIS_MOD09A1_master INNER JOIN SITESID_master ON MODIS_MOD09A1_master.site_id = SITESID_master.site_id WHERE MODIS_MOD09A1_master.site_id = '",
                       ids[i,], "'", sep = "")
  )
}

## Close connnection to db
dbDisconnect(db)
#------------------------------------------------------------------------------#
#                         MODIS_MOD15A2  
#------------------------------------------------------------------------------#
db <- dbConnect(SQLite(), dbname=myDB)
if ( "MODIS_MOD15A2" %in% dbListTables(db))  dbSendQuery(db, "DROP VIEW MODIS_MOD15A2")
dbGetQuery(db, "CREATE VIEW MODIS_MOD15A2 AS
           SELECT MODIS_MOD15A2_master.record_id,
           SITESID_master.site,
           MODIS_MOD15A2_master.site_id,
           MODIS_MOD15A2_master.date  , 
           MODIS_MOD15A2_master.day  ,
           MODIS_MOD15A2_master.mo  ,
           MODIS_MOD15A2_master.year  , 
           MODIS_MOD15A2_master.fpar_percent ,
           MODIS_MOD15A2_master.lai ,
           MODIS_MOD15A2_master.fpar_qc ,
           MODIS_MOD15A2_master.lai_qc 
           FROM MODIS_MOD15A2_master INNER JOIN SITESID_master ON MODIS_MOD15A2_master.site_id = SITESID_master.site_id"
)

## Close connnection to db
dbDisconnect(db)


db <- dbConnect(SQLite(), dbname=myDB)
ids <- dbGetQuery(db, "SELECT site_id FROM (SELECT DISTINCT site_id FROM MODIS_MOD15A2_master)")

for (i in 1:length(ids[,1])){
  if ( paste("MODIS_MOD15A2_", ids[i,], sep = "" ) %in% dbListTables(db))  dbSendQuery(db, paste("DROP VIEW MODIS_MOD15A2_", ids[i,], sep = "" ))
  dbGetQuery(db, paste("CREATE VIEW MODIS_MOD15A2_", ids[i,], " AS ",
                       "SELECT MODIS_MOD15A2_master.record_id, ",
                       "SITESID_master.site, ",
                       "MODIS_MOD15A2_master.site_id, ",
                       "MODIS_MOD15A2_master.date, ",
                       "MODIS_MOD15A2_master.day , ",
                       "MODIS_MOD15A2_master.mo, ",
                       "MODIS_MOD15A2_master.year, ",
                       "MODIS_MOD15A2_master.fpar_percent, " ,
                       "MODIS_MOD15A2_master.lai, ",
                       "MODIS_MOD15A2_master.fpar_qc, ",
                       "MODIS_MOD15A2_master.lai_qc ",
                       "FROM MODIS_MOD15A2_master INNER JOIN SITESID_master ON MODIS_MOD15A2_master.site_id = SITESID_master.site_id WHERE MODIS_MOD15A2_master.site_id = '",
                       ids[i,], "'", sep = "")
  )
}

## Close connnection to db
dbDisconnect(db)
#------------------------------------------------------------------------------#
#                         MODIS_MOD11A2
#------------------------------------------------------------------------------#
db <- dbConnect(SQLite(), dbname=myDB)
if ( "MODIS_MOD11A2" %in% dbListTables(db))  dbSendQuery(db, "DROP VIEW MODIS_MOD11A2")
dbGetQuery(db, "CREATE VIEW MODIS_MOD11A2 AS
           SELECT MODIS_MOD11A2_master.record_id,
           SITESID_master.site,
           MODIS_MOD11A2_master.site_id,
           MODIS_MOD11A2_master.date  , 
           MODIS_MOD11A2_master.day  ,
           MODIS_MOD11A2_master.mo  ,
           MODIS_MOD11A2_master.year  , 
           MODIS_MOD11A2_master.lstDay_degK ,
           MODIS_MOD11A2_master.lstNight_degK , 
           MODIS_MOD11A2_master.lstDay_qc ,
           MODIS_MOD11A2_master.lstNight_qc 
           FROM MODIS_MOD11A2_master INNER JOIN SITESID_master ON MODIS_MOD11A2_master.site_id = SITESID_master.site_id"
)

## Close connnection to db
dbDisconnect(db)


db <- dbConnect(SQLite(), dbname=myDB)
ids <- dbGetQuery(db, "SELECT site_id FROM (SELECT DISTINCT site_id FROM MODIS_MOD11A2_master)")

for (i in 1:length(ids[,1])){
  if ( paste("MODIS_MOD11A2_", ids[i,], sep = "" ) %in% dbListTables(db))  dbSendQuery(db, paste("DROP VIEW MODIS_MOD11A2_", ids[i,], sep = "" ))
  dbGetQuery(db, paste("CREATE VIEW MODIS_MOD11A2_", ids[i,], " AS ",
                       "SELECT MODIS_MOD11A2_master.record_id, ",
                       "SITESID_master.site, ",
                       "MODIS_MOD11A2_master.site_id, ",
                       "MODIS_MOD11A2_master.date, ",
                       "MODIS_MOD11A2_master.day , ",
                       "MODIS_MOD11A2_master.mo, ",
                       "MODIS_MOD11A2_master.year, ",
                       "MODIS_MOD11A2_master.lstDay_degK, ",
                       "MODIS_MOD11A2_master.lstNight_degK, " ,
                       "MODIS_MOD11A2_master.lstDay_qc, ",
                       "MODIS_MOD11A2_master.lstNight_qc ",
                       "FROM MODIS_MOD11A2_master INNER JOIN SITESID_master ON MODIS_MOD11A2_master.site_id = SITESID_master.site_id WHERE MODIS_MOD11A2_master.site_id = '",
                       ids[i,], "'", sep = "")
  )
}

## Close connnection to db
dbDisconnect(db)

#------------------------------------------------------------------------------#
#                         MODIS_MOD13Q1
#------------------------------------------------------------------------------#
db <- dbConnect(SQLite(), dbname=myDB)
if ( "MODIS_MOD17A2" %in% dbListTables(db))  dbSendQuery(db, "DROP VIEW MODIS_MOD17A2")
dbGetQuery(db, "CREATE VIEW MODIS_MOD17A2 AS
           SELECT MODIS_MOD17A2_master.record_id,
           SITESID_master.site,
           MODIS_MOD17A2_master.site_id,
           MODIS_MOD17A2_master.date  , 
           MODIS_MOD17A2_master.day  ,
           MODIS_MOD17A2_master.mo  ,
           MODIS_MOD17A2_master.year  , 
           MODIS_MOD17A2_master.gpp_gCm2d ,
           MODIS_MOD17A2_master.psNet_gCm2d ,
           MODIS_MOD17A2_master.gpp_qc , 
           MODIS_MOD17A2_master.psNet_qc 
           FROM MODIS_MOD17A2_master INNER JOIN SITESID_master ON MODIS_MOD17A2_master.site_id = SITESID_master.site_id"
)

## Close connnection to db
dbDisconnect(db)


db <- dbConnect(SQLite(), dbname=myDB)
ids <- dbGetQuery(db, "SELECT site_id FROM (SELECT DISTINCT site_id FROM MODIS_MOD17A2_master)")

for (i in 1:length(ids[,1])){
  if ( paste("MODIS_MOD17A2_", ids[i,], sep = "" ) %in% dbListTables(db))  dbSendQuery(db, paste("DROP VIEW MODIS_MOD17A2_", ids[i,], sep = "" ))
  dbGetQuery(db, paste("CREATE VIEW MODIS_MOD17A2_", ids[i,], " AS ",
                       "SELECT MODIS_MOD17A2_master.record_id, ",
                       "SITESID_master.site, ",
                       "MODIS_MOD17A2_master.site_id, ",
                       "MODIS_MOD17A2_master.date, ",
                       "MODIS_MOD17A2_master.day , ",
                       "MODIS_MOD17A2_master.mo, ",
                       "MODIS_MOD17A2_master.year, ",
                       "MODIS_MOD17A2_master.gpp_gCm2d, ",
                       "MODIS_MOD17A2_master.psNet_gCm2d, ",
                       "MODIS_MOD17A2_master.gpp_qc, " ,
                       "MODIS_MOD17A2_master.psNet_qc ", 
                       "FROM MODIS_MOD17A2_master INNER JOIN SITESID_master ON MODIS_MOD17A2_master.site_id = SITESID_master.site_id WHERE MODIS_MOD17A2_master.site_id = '",
                       ids[i,], "'", sep = "")
  )
}

## Close connnection to db
dbDisconnect(db)


#------------------------------------------------------------------------------#
#                         MODIS_MOD13Q1
#------------------------------------------------------------------------------#

db <- dbConnect(SQLite(), dbname=myDB)
if ( "MODIS_MOD13Q1" %in% dbListTables(db))  dbSendQuery(db, "DROP VIEW MODIS_MOD13Q1")
dbGetQuery(db, "CREATE VIEW MODIS_MOD13Q1 AS
           SELECT MODIS_MOD13Q1_master.record_id,
           SITESID_master.site,
           MODIS_MOD13Q1_master.site_id,
           MODIS_MOD13Q1_master.date  , 
           MODIS_MOD13Q1_master.day  ,
           MODIS_MOD13Q1_master.mo  ,
           MODIS_MOD13Q1_master.year  , 
           MODIS_MOD13Q1_master.ndvi16 , 
           MODIS_MOD13Q1_master.evi16 ,
           MODIS_MOD13Q1_master.ndvi16_qc ,
           MODIS_MOD13Q1_master.evi16_qc
           FROM MODIS_MOD13Q1_master INNER JOIN SITESID_master ON MODIS_MOD13Q1_master.site_id = SITESID_master.site_id"
)

## Close connnection to db
dbDisconnect(db)


db <- dbConnect(SQLite(), dbname=myDB)
ids <- dbGetQuery(db, "SELECT site_id FROM (SELECT DISTINCT site_id FROM MODIS_MOD13Q1_master)")

for (i in 1:length(ids[,1])){
  if ( paste("MODIS_MOD13Q1_", ids[i,], sep = "" ) %in% dbListTables(db))  dbSendQuery(db, paste("DROP VIEW MODIS_MOD13Q1_", ids[i,], sep = "" ))
  dbGetQuery(db, paste("CREATE VIEW MODIS_MOD13Q1_", ids[i,], " AS ",
                       "SELECT MODIS_MOD13Q1_master.record_id, ",
                       "SITESID_master.site, ",
                       "MODIS_MOD13Q1_master.site_id, ",
                       "MODIS_MOD13Q1_master.date, ",
                       "MODIS_MOD13Q1_master.day , ",
                       "MODIS_MOD13Q1_master.mo, ",
                       "MODIS_MOD13Q1_master.year, ",
                       "MODIS_MOD13Q1_master.ndvi16, " ,
                       "MODIS_MOD13Q1_master.evi16, ",
                       "MODIS_MOD13Q1_master.ndvi16_qc, ",
                       "MODIS_MOD13Q1_master.evi16_qc ",
                       "FROM MODIS_MOD13Q1_master INNER JOIN SITESID_master ON MODIS_MOD13Q1_master.site_id = SITESID_master.site_id WHERE MODIS_MOD13Q1_master.site_id = '",
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
           foo.gpp_gCm2d ,
           foo.psNet_gCm2d ,
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
           foo.aB01_rad ,
           foo.aB02_rad ,
           foo.aB05_rad ,
           foo.aB06_rad ,
           foo.ndwi , 
           foo.ndvi8, 
           foo.evi8,
          foo.sasi_rad,
          foo.sani_rad,
           foo.refl_qc ,
           foo.fpar_percent ,
           foo.lai ,
           foo.fpar_qc ,
           foo.lai_qc
           FROM ( SELECT MODIS_MOD17A2_master.record_id,
           MODIS_MOD17A2_master.site_id,
           MODIS_MOD17A2_master.date  , 
           MODIS_MOD17A2_master.day  ,
           MODIS_MOD17A2_master.mo  ,
           MODIS_MOD17A2_master.year  , 
           MODIS_MOD17A2_master.gpp_gCm2d ,
           MODIS_MOD17A2_master.psNet_gCm2d ,
           MODIS_MOD17A2_master.gpp_qc , 
           MODIS_MOD17A2_master.psNet_qc , 
           MODIS_MOD11A2_master.lstDay_degK ,
           MODIS_MOD11A2_master.lstNight_degK , 
           MODIS_MOD11A2_master.lstDay_qc ,
           MODIS_MOD11A2_master.lstNight_qc ,
           MODIS_MOD09A1_master.reflB01_percent ,
           MODIS_MOD09A1_master.reflB02_percent ,
           MODIS_MOD09A1_master.reflB03_percent ,
           MODIS_MOD09A1_master.reflB04_percent ,
           MODIS_MOD09A1_master.reflB05_percent ,
           MODIS_MOD09A1_master.reflB06_percent ,
           MODIS_MOD09A1_master.reflB07_percent ,
           MODIS_MOD09A1_master.aB01_rad ,
           MODIS_MOD09A1_master.aB02_rad ,
           MODIS_MOD09A1_master.aB05_rad ,
           MODIS_MOD09A1_master.aB06_rad ,
           MODIS_MOD09A1_master.ndwi , 
           MODIS_MOD09A1_master.ndvi8, 
           MODIS_MOD09A1_master.evi8,
           MODIS_MOD09A1_master.sasi_rad,
          MODIS_MOD09A1_master.sani_rad,
           MODIS_MOD09A1_master.refl_qc ,
           MODIS_MOD15A2_master.fpar_percent ,
           MODIS_MOD15A2_master.lai ,
           MODIS_MOD15A2_master.fpar_qc ,
           MODIS_MOD15A2_master.lai_qc, 
           MODIS_MOD13Q1_master.ndvi16, 
           MODIS_MOD13Q1_master.evi16, 
           MODIS_MOD13Q1_master.ndvi16_qc, 
           MODIS_MOD13Q1_master.evi16_qc 
           FROM MODIS_MOD17A2_master INNER JOIN MODIS_MOD09A1_master ON MODIS_MOD17A2_master.site_id = MODIS_MOD09A1_master.site_id AND  MODIS_MOD17A2_master.date = MODIS_MOD09A1_master.date
           INNER JOIN MODIS_MOD11A2_master ON MODIS_MOD17A2_master.site_id = MODIS_MOD11A2_master.site_id AND  MODIS_MOD17A2_master.date = MODIS_MOD11A2_master.date
           INNER JOIN MODIS_MOD15A2_master ON MODIS_MOD17A2_master.site_id = MODIS_MOD15A2_master.site_id AND  MODIS_MOD17A2_master.date = MODIS_MOD15A2_master.date
           INNER JOIN MODIS_MOD13Q1_master ON MODIS_MOD17A2_master.site_id = MODIS_MOD13Q1_master.site_id AND  MODIS_MOD17A2_master.date = MODIS_MOD13Q1_master.date)
           AS foo INNER JOIN SITESID_master as bar ON foo.site_id = bar.site_id "
)

## Close connnection to db
dbDisconnect(db)

db <- dbConnect(SQLite(), dbname=myDB)
ids <- dbGetQuery(db, "SELECT site_id FROM (SELECT DISTINCT site_id FROM MODIS_MOD17A2_master)")

for (i in 1:length(ids[,1])){
  if ( paste("MODIS_", ids[i,], sep = "" ) %in% dbListTables(db))  dbSendQuery(db, paste("DROP VIEW MODIS_", ids[i,], sep = "" ))
  dbGetQuery(db, paste("CREATE VIEW MODIS_", ids[i,], " AS ",
                       "SELECT  bar.site, ",
                       "foo.site_id, ",
                       "foo.date  , ", 
                       "foo.day  , ",
                       "foo.mo  , ",
                       "foo.year  , ", 
                       "foo.gpp_gCm2d , ",
                       "foo.psNet_gCm2d , ",
                       "foo.gpp_qc , ", 
                       "foo.psNet_qc , ", 
                       "foo.lstDay_degK , ",
                       "foo.lstNight_degK , ", 
                       "foo.lstDay_qc , ",
                       "foo.lstNight_qc , ",
                       "foo.reflB01_percent , ",
                       "foo.reflB02_percent , ",
                       "foo.reflB03_percent , ",
                       "foo.reflB04_percent , ",
                       "foo.reflB05_percent , ",
                       "foo.reflB06_percent , ",
                       "foo.reflB07_percent , ",
                       "foo.aB01_rad , ",
                       "foo.aB02_rad , ",
                       "foo.aB05_rad , ",
                       "foo.aB06_rad , ",
                       "foo.ndwi , ", 
                       "foo.ndvi8, ", 
                       "foo.evi8, ",
                       "foo.sasi_rad, ",
                       "foo.sani_rad, ",
                       "foo.refl_qc , ",
                       "foo.fpar_percent , ",
                       "foo.lai , ",
                       "foo.fpar_qc , ",
                       "foo.lai_qc ",
                       "FROM ( SELECT MODIS_MOD17A2_master.record_id, ",
                      "MODIS_MOD17A2_master.site_id, ",
                      "MODIS_MOD17A2_master.date  , ", 
                      "MODIS_MOD17A2_master.day  , ",
                      "MODIS_MOD17A2_master.mo  , ",
                      "MODIS_MOD17A2_master.year  , ", 
                      "MODIS_MOD17A2_master.gpp_gCm2d , ",
                      "MODIS_MOD17A2_master.psNet_gCm2d , ",
                      "MODIS_MOD17A2_master.gpp_qc , ", 
                      "MODIS_MOD17A2_master.psNet_qc , ", 
                      "MODIS_MOD11A2_master.lstDay_degK , ",
                      "MODIS_MOD11A2_master.lstNight_degK , ", 
                      "MODIS_MOD11A2_master.lstDay_qc , ",
                      "MODIS_MOD11A2_master.lstNight_qc , ",
                      "MODIS_MOD09A1_master.reflB01_percent , ",
                      "MODIS_MOD09A1_master.reflB02_percent , ",
                      "MODIS_MOD09A1_master.reflB03_percent , ",
                      "MODIS_MOD09A1_master.reflB04_percent , ",
                      "MODIS_MOD09A1_master.reflB05_percent , ",
                      "MODIS_MOD09A1_master.reflB06_percent , ",
                      "MODIS_MOD09A1_master.reflB07_percent , ",
                      "MODIS_MOD09A1_master.aB01_rad , ",
                      "MODIS_MOD09A1_master.aB02_rad , ",
                      "MODIS_MOD09A1_master.aB05_rad , ",
                      "MODIS_MOD09A1_master.aB06_rad , ",
                      "MODIS_MOD09A1_master.ndwi , ", 
                      "MODIS_MOD09A1_master.ndvi8, ", 
                      "MODIS_MOD09A1_master.evi8, ",
                      "MODIS_MOD09A1_master.sasi_rad, ",
                      "MODIS_MOD09A1_master.sani_rad, ",
                      "MODIS_MOD09A1_master.refl_qc , ",
                      "MODIS_MOD15A2_master.fpar_percent , ",
                      "MODIS_MOD15A2_master.lai , ",
                      "MODIS_MOD15A2_master.fpar_qc , ",
                      "MODIS_MOD15A2_master.lai_qc, ", 
                      "MODIS_MOD13Q1_master.ndvi16, ", 
                      "MODIS_MOD13Q1_master.evi16, ", 
                      "MODIS_MOD13Q1_master.ndvi16_qc, ", 
                      "MODIS_MOD13Q1_master.evi16_qc ",
                      "FROM MODIS_MOD17A2_master LEFT JOIN MODIS_MOD09A1_master ON MODIS_MOD17A2_master.site_id = MODIS_MOD09A1_master.site_id AND  MODIS_MOD17A2_master.date = MODIS_MOD09A1_master.date ",
                      "LEFT JOIN MODIS_MOD11A2_master ON MODIS_MOD17A2_master.site_id = MODIS_MOD11A2_master.site_id AND  MODIS_MOD17A2_master.date = MODIS_MOD11A2_master.date ",
                      "LEFT JOIN MODIS_MOD15A2_master ON MODIS_MOD17A2_master.site_id = MODIS_MOD15A2_master.site_id AND  MODIS_MOD17A2_master.date = MODIS_MOD15A2_master.date ",
                      "LEFT JOIN MODIS_MOD13Q1_master ON MODIS_MOD17A2_master.site_id = MODIS_MOD13Q1_master.site_id AND  MODIS_MOD17A2_master.date = MODIS_MOD13Q1_master.date ",
                      " WHERE MODIS_MOD17A2_master.site_id = '", ids[i,], "')",
                      " AS foo INNER JOIN SITESID_master AS bar ON foo.site_id = bar.site_id ",
             sep = ""))
}

## Close connnection to db
dbDisconnect(db)

