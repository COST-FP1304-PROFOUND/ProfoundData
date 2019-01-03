# open connection to DB
db <- dbConnect(SQLite(), dbname=myDB)
if ( "CLIMATE_ISIMIP2BLBC" %in% dbListTables(db))   dbSendQuery(db, "DROP VIEW CLIMATE_ISIMIP2BLBC")
dbGetQuery(db, "CREATE VIEW CLIMATE_ISIMIP2BLBC AS
           SELECT CLIMATE_ISIMIP2BLBC_master.record_id,
           SITESID_master.site,
           CLIMATE_ISIMIP2BLBC_master.site_id,
           CLIMATE_ISIMIP2BLBC_master.date ,
           CLIMATE_ISIMIP2BLBC_master.forcingDataset,
           CLIMATE_ISIMIP2BLBC_master.forcingCondition,
           CLIMATE_ISIMIP2BLBC_master.day,
           CLIMATE_ISIMIP2BLBC_master.mo,
           CLIMATE_ISIMIP2BLBC_master.year,
           CLIMATE_ISIMIP2BLBC_master.tmax_degC,
           CLIMATE_ISIMIP2BLBC_master.tmean_degC,
           CLIMATE_ISIMIP2BLBC_master.tmin_degC,
           CLIMATE_ISIMIP2BLBC_master.p_mm,
           CLIMATE_ISIMIP2BLBC_master.relhum_percent,
           CLIMATE_ISIMIP2BLBC_master.airpress_hPa,
           CLIMATE_ISIMIP2BLBC_master.rad_Jcm2day,
           CLIMATE_ISIMIP2BLBC_master.wind_ms
           FROM CLIMATE_ISIMIP2BLBC_master INNER JOIN SITESID_master ON CLIMATE_ISIMIP2BLBC_master.site_id = SITESID_master.site_id"
)
dbDisconnect(db)


db <- dbConnect(SQLite(), dbname=myDB)

ids <- dbGetQuery(db, "SELECT site_id FROM (SELECT DISTINCT site_id FROM CLIMATE_ISIMIP2BLBC_master)"  )
for (j in 1:length(ids[, 1])){
  if ( paste("CLIMATE_ISIMIP2BLBC_", ids[j,], sep="") %in% dbListTables(db))  dbSendQuery(db, paste("DROP VIEW CLIMATE_ISIMIP2BLBC_", ids[j,], sep="") )
  dbGetQuery(db,  paste("CREATE VIEW CLIMATE_ISIMIP2BLBC_",  ids[j,],  " AS ",
                        "SELECT CLIMATE_ISIMIP2BLBC_master.record_id, ",
                        "SITESID_master.site, ",
                        "CLIMATE_ISIMIP2BLBC_master.site_id, ",
                        "CLIMATE_ISIMIP2BLBC_master.date, ",
                        "CLIMATE_ISIMIP2BLBC_master.forcingDataset, ",
                        "CLIMATE_ISIMIP2BLBC_master.forcingCondition, ",
                        "CLIMATE_ISIMIP2BLBC_master.day, ",
                        "CLIMATE_ISIMIP2BLBC_master.mo, ",
                        "CLIMATE_ISIMIP2BLBC_master.year, ",
                        "CLIMATE_ISIMIP2BLBC_master.tmax_degC, ",
                        "CLIMATE_ISIMIP2BLBC_master.tmean_degC, ",
                        "CLIMATE_ISIMIP2BLBC_master.tmin_degC, ",
                        "CLIMATE_ISIMIP2BLBC_master.p_mm, ",
                        "CLIMATE_ISIMIP2BLBC_master.relhum_percent, ",
                        "CLIMATE_ISIMIP2BLBC_master.airpress_hPa, ",
                        "CLIMATE_ISIMIP2BLBC_master.rad_Jcm2day, ",
                        "CLIMATE_ISIMIP2BLBC_master.wind_ms ",
                        "FROM CLIMATE_ISIMIP2BLBC_master INNER JOIN SITESID_master ON CLIMATE_ISIMIP2BLBC_master.site_id = SITESID_master.site_id  WHERE CLIMATE_ISIMIP2BLBC_master.site_id = '",
                        ids[j,], "'", sep = "") )
  
}
dbDisconnect(db)





db <- dbConnect(SQLite(), dbname=myDB)
forcingDataset <- dbGetQuery(db, "SELECT forcingDataset FROM (SELECT DISTINCT forcingDataset FROM CLIMATE_ISIMIP2BLBC_master)"  )[,1]

for (i in 1:length(forcingDataset)){
  if ( paste("CLIMATE_ISIMIP2BLBC_", forcingDataset[i], sep="") %in% dbListTables(db))  dbSendQuery(db, paste("DROP VIEW CLIMATE_ISIMIP2BLBC_",forcingDataset[i], sep="") )
  dbGetQuery(db,  paste("CREATE VIEW CLIMATE_ISIMIP2BLBC_", forcingDataset[i], " AS ",
                        "SELECT CLIMATE_ISIMIP2BLBC_master.record_id, ",
                        "SITESID_master.site, ",
                        "CLIMATE_ISIMIP2BLBC_master.site_id, ",
                        "CLIMATE_ISIMIP2BLBC_master.date, ",
                        "CLIMATE_ISIMIP2BLBC_master.forcingDataset, ",
                        "CLIMATE_ISIMIP2BLBC_master.forcingCondition, ",
                        "CLIMATE_ISIMIP2BLBC_master.day, ",
                        "CLIMATE_ISIMIP2BLBC_master.mo, ",
                        "CLIMATE_ISIMIP2BLBC_master.year, ",
                        "CLIMATE_ISIMIP2BLBC_master.tmax_degC, ",
                        "CLIMATE_ISIMIP2BLBC_master.tmean_degC, ",
                        "CLIMATE_ISIMIP2BLBC_master.tmin_degC, ",
                        "CLIMATE_ISIMIP2BLBC_master.p_mm, ",
                        "CLIMATE_ISIMIP2BLBC_master.relhum_percent, ",
                        "CLIMATE_ISIMIP2BLBC_master.airpress_hPa, ",
                        "CLIMATE_ISIMIP2BLBC_master.rad_Jcm2day, ",
                        "CLIMATE_ISIMIP2BLBC_master.wind_ms ",
                        "FROM CLIMATE_ISIMIP2BLBC_master INNER JOIN SITESID_master ON CLIMATE_ISIMIP2BLBC_master.site_id = SITESID_master.site_id   WHERE CLIMATE_ISIMIP2BLBC_master.forcingDataset = '",
                        forcingDataset[i], "'", sep = "")  )
}
dbDisconnect(db)



db <- dbConnect(SQLite(), dbname=myDB)

for (i in 1:length(forcingDataset)){
  ids <- dbGetQuery(db, paste("SELECT site_id FROM (SELECT DISTINCT site_id FROM CLIMATE_ISIMIP2BLBC_master WHERE forcingDataset = '", 
                              forcingDataset[i], "')", sep = "")  )
  forcingDataset <- dbGetQuery(db, "SELECT forcingDataset FROM (SELECT DISTINCT forcingDataset FROM CLIMATE_ISIMIP2BLBC_master)"  )[,1]
  
  for (j in 1:length(ids[, 1])){
    if ( paste("CLIMATE_ISIMIP2BLBC_", forcingDataset[i],"_",  ids[j,], sep="") %in% dbListTables(db))  dbSendQuery(db, paste("DROP VIEW CLIMATE_ISIMIP2BLBC_",forcingDataset[i],"_",  ids[j,], sep="") )
    
    dbGetQuery(db,  paste("CREATE VIEW CLIMATE_ISIMIP2BLBC_", forcingDataset[i],"_",  ids[j,],  " AS ",
                          "SELECT CLIMATE_ISIMIP2BLBC_master.record_id, ",
                          "SITESID_master.site, ",
                          "CLIMATE_ISIMIP2BLBC_master.site_id, ",
                          "CLIMATE_ISIMIP2BLBC_master.date, ",
                          "CLIMATE_ISIMIP2BLBC_master.forcingDataset, ",
                          "CLIMATE_ISIMIP2BLBC_master.forcingCondition, ",
                          "CLIMATE_ISIMIP2BLBC_master.day, ",
                          "CLIMATE_ISIMIP2BLBC_master.mo, ",
                          "CLIMATE_ISIMIP2BLBC_master.year, ",
                          "CLIMATE_ISIMIP2BLBC_master.tmax_degC, ",
                          "CLIMATE_ISIMIP2BLBC_master.tmean_degC, ",
                          "CLIMATE_ISIMIP2BLBC_master.tmin_degC, ",
                          "CLIMATE_ISIMIP2BLBC_master.p_mm, ",
                          "CLIMATE_ISIMIP2BLBC_master.relhum_percent, ",
                          "CLIMATE_ISIMIP2BLBC_master.airpress_hPa, ",
                          "CLIMATE_ISIMIP2BLBC_master.rad_Jcm2day, ",
                          "CLIMATE_ISIMIP2BLBC_master.wind_ms ",
                          "FROM CLIMATE_ISIMIP2BLBC_master INNER JOIN SITESID_master ON CLIMATE_ISIMIP2BLBC_master.site_id = SITESID_master.site_id  WHERE CLIMATE_ISIMIP2BLBC_master.forcingDataset = '",
                          forcingDataset[i], "' AND CLIMATE_ISIMIP2BLBC_master.site_id = '", ids[j,], "'", sep = "") )
  }
}
dbDisconnect(db)

# DO forcingDataset WISHT forcingCondition
db <- dbConnect(SQLite(), dbname=myDB)

forcingDataset <- dbGetQuery(db, "SELECT forcingDataset FROM (SELECT DISTINCT forcingDataset FROM CLIMATE_ISIMIP2BLBC_master)"  )[,1]

for (i in 1:length(forcingDataset)){
  ids <- dbGetQuery(db, paste("SELECT site_id FROM (SELECT DISTINCT site_id FROM CLIMATE_ISIMIP2BLBC_master WHERE forcingDataset = '", 
                              forcingDataset[i], "')", sep = "")  )
  forcingCondition <- dbGetQuery(db, paste("SELECT forcingCondition FROM (SELECT DISTINCT forcingCondition FROM CLIMATE_ISIMIP2BLBC_master WHERE forcingDataset = '", 
                                            forcingDataset[i], "')", sep = "")  )[,1]
  for (k in 1:length(forcingCondition)){
    if ( paste("CLIMATE_ISIMIP2BLBC_", forcingDataset[i],"_",  forcingCondition[k], sep="") %in% dbListTables(db))  dbSendQuery(db, paste("DROP VIEW CLIMATE_ISIMIP2BLBC_",forcingDataset[i],"_",  forcingCondition[k], sep="") )
    
    dbGetQuery(db,  paste("CREATE VIEW CLIMATE_ISIMIP2BLBC_", forcingDataset[i],"_",  forcingCondition[k],  " AS ",
                          "SELECT CLIMATE_ISIMIP2BLBC_master.record_id, ",
                          "SITESID_master.site, ",
                          "CLIMATE_ISIMIP2BLBC_master.site_id, ",
                          "CLIMATE_ISIMIP2BLBC_master.date, ",
                          "CLIMATE_ISIMIP2BLBC_master.forcingDataset, ",
                          "CLIMATE_ISIMIP2BLBC_master.forcingCondition, ",
                          "CLIMATE_ISIMIP2BLBC_master.day, ",
                          "CLIMATE_ISIMIP2BLBC_master.mo, ",
                          "CLIMATE_ISIMIP2BLBC_master.year, ",
                          "CLIMATE_ISIMIP2BLBC_master.tmax_degC, ",
                          "CLIMATE_ISIMIP2BLBC_master.tmean_degC, ",
                          "CLIMATE_ISIMIP2BLBC_master.tmin_degC, ",
                          "CLIMATE_ISIMIP2BLBC_master.p_mm, ",
                          "CLIMATE_ISIMIP2BLBC_master.relhum_percent, ",
                          "CLIMATE_ISIMIP2BLBC_master.airpress_hPa, ",
                          "CLIMATE_ISIMIP2BLBC_master.rad_Jcm2day, ",
                          "CLIMATE_ISIMIP2BLBC_master.wind_ms ",
                          "FROM CLIMATE_ISIMIP2BLBC_master INNER JOIN SITESID_master ON CLIMATE_ISIMIP2BLBC_master.site_id = SITESID_master.site_id  WHERE CLIMATE_ISIMIP2BLBC_master.forcingDataset = '",
                          forcingDataset[i], "' AND CLIMATE_ISIMIP2BLBC_master.forcingCondition = '", forcingCondition[k], "'", sep = "") )
    for (j in 1:length(ids[, 1])){
      if ( paste("CLIMATE_ISIMIP2BLBC_", forcingDataset[i],"_",  forcingCondition[k],"_",  ids[j,], sep="") %in% dbListTables(db))  dbSendQuery(db, paste("DROP VIEW CLIMATE_ISIMIP2BLBC_",forcingDataset[i],"_", forcingCondition[k],"_",  ids[j,] , sep="") )
      dbGetQuery(db,  paste("CREATE VIEW CLIMATE_ISIMIP2BLBC_", forcingDataset[i],"_",  forcingCondition[k], "_",  ids[j,],  " AS ",
                            "SELECT CLIMATE_ISIMIP2BLBC_master.record_id, ",
                            "SITESID_master.site, ",
                            "CLIMATE_ISIMIP2BLBC_master.site_id, ",
                            "CLIMATE_ISIMIP2BLBC_master.date, ",
                            "CLIMATE_ISIMIP2BLBC_master.forcingDataset, ",
                            "CLIMATE_ISIMIP2BLBC_master.forcingCondition, ",
                            "CLIMATE_ISIMIP2BLBC_master.day, ",
                            "CLIMATE_ISIMIP2BLBC_master.mo, ",
                            "CLIMATE_ISIMIP2BLBC_master.year, ",
                            "CLIMATE_ISIMIP2BLBC_master.tmax_degC, ",
                            "CLIMATE_ISIMIP2BLBC_master.tmean_degC, ",
                            "CLIMATE_ISIMIP2BLBC_master.tmin_degC, ",
                            "CLIMATE_ISIMIP2BLBC_master.p_mm, ",
                            "CLIMATE_ISIMIP2BLBC_master.relhum_percent, ",
                            "CLIMATE_ISIMIP2BLBC_master.airpress_hPa, ",
                            "CLIMATE_ISIMIP2BLBC_master.rad_Jcm2day, ",
                            "CLIMATE_ISIMIP2BLBC_master.wind_ms ",
                            "FROM CLIMATE_ISIMIP2BLBC_master INNER JOIN SITESID_master ON CLIMATE_ISIMIP2BLBC_master.site_id = SITESID_master.site_id  WHERE CLIMATE_ISIMIP2BLBC_master.forcingDataset = '",
                            forcingDataset[i], "' AND CLIMATE_ISIMIP2BLBC_master.forcingCondition = '", forcingCondition[k], "' AND CLIMATE_ISIMIP2BLBC_master.site_id = '", ids[j,], "'", sep = "") )
      
    }
  }
}

dbDisconnect(db)




