# Load libraries
library(sqldf)
library(DBI)
library(RSQLite)

# FLUX
db <- dbConnect(SQLite(), dbname=myDB)

if ( "FLUX" %in% dbListTables(db)){
  dbSendQuery(db, "DROP VIEW  FLUX")
}

dbGetQuery(db, "CREATE VIEW FLUX AS
           SELECT FLUXNET_master.record_id,
           SITESID_master.site,
           FLUXNET_master.site_id,
           FLUXNET_master.timestampStart,
           FLUXNET_master.timestampEnd,
           FLUXNET_master.date,
           FLUXNET_master.year,
           FLUXNET_master.day,
           FLUXNET_master.mo,
           FLUXNET_master.neeCutRef_umolCO2m2s1,
           FLUXNET_master.neeVutRef_umolCO2m2s1,
           FLUXNET_master.neeCutRef_qc,
           FLUXNET_master.neeVutRef_qc,
           FLUXNET_master.neeCutRefJointunc_umolCO2m2s1,
           FLUXNET_master.neeVutRefJointunc_umolCO2m2s1,
           FLUXNET_master.recoNtVutRef_umolCO2m2s1,
           FLUXNET_master.recoNtVutSe_umolCO2m2s1,
           FLUXNET_master.recoNtCutRef_umolCO2m2s1,
           FLUXNET_master.recoNtCutSe_umolCO2m2s1,
           FLUXNET_master.gppNtVutRef_umolCO2m2s1,
           FLUXNET_master.gppNtVutSe_umolCO2m2s1,
           FLUXNET_master.gppNtCutRef_umolCO2m2s1,
           FLUXNET_master.gppNtCutSe_umolCO2m2s1,
           FLUXNET_master.recoDtVutRef_umolCO2m2s1,
           FLUXNET_master.recoDtVutSe_umolCO2m2s1,
           FLUXNET_master.recoDtCutRef_umolCO2m2s1,
           FLUXNET_master.recoDtCutSe_umolCO2m2s1,
           FLUXNET_master.gppDtVutRef_umolCO2m2s1,
           FLUXNET_master.gppDtVutSe_umolCO2m2s1,
           FLUXNET_master.gppDtCutRef_umolCO2m2s1,
           FLUXNET_master.gppDtCutSe_umolCO2m2s1
           FROM FLUXNET_master INNER JOIN SITESID_master ON FLUXNET_master.site_id = SITESID_master.site_id"
)

## Close connnection to db
dbDisconnect(db)


db <- dbConnect(SQLite(), dbname=myDB)
ids <- dbGetQuery(db, "SELECT site_id FROM (SELECT DISTINCT site_id FROM FLUXNET_master)")

for (i in 1:length(ids[,1])){
  if ( paste("FLUX_", ids[i,], sep = "") %in% dbListTables(db)){
    dbSendQuery(db, paste("DROP VIEW  FLUX_", ids[i,], sep = ""))
  }
  dbGetQuery(db, paste("CREATE VIEW FLUX_", ids[i,], " AS ",
                       "SELECT FLUXNET_master.record_id, ",
                       "SITESID_master.site, ",
                       "FLUXNET_master.site_id, ",
                       "FLUXNET_master.timestampStart, ",
                       "FLUXNET_master.timestampEnd, ",
                       "FLUXNET_master.date, ",
                       "FLUXNET_master.year, ",
                       "FLUXNET_master.day, ",
                       "FLUXNET_master.mo, ",
                       "FLUXNET_master.neeCutRef_umolCO2m2s1, ",
                       "FLUXNET_master.neeVutRef_umolCO2m2s1, ",
                       "FLUXNET_master.neeCutRef_qc, ",
                       "FLUXNET_master.neeVutRef_qc, ",
                       "FLUXNET_master.neeCutRefJointunc_umolCO2m2s1, ",
                       "FLUXNET_master.neeVutRefJointunc_umolCO2m2s1, ",
                       "FLUXNET_master.recoNtVutRef_umolCO2m2s1, ",
                       "FLUXNET_master.recoNtVutSe_umolCO2m2s1, ",
                       "FLUXNET_master.recoNtCutRef_umolCO2m2s1, ",
                       "FLUXNET_master.recoNtCutSe_umolCO2m2s1, ",
                       "FLUXNET_master.gppNtVutRef_umolCO2m2s1, ",
                       "FLUXNET_master.gppNtVutSe_umolCO2m2s1, ",
                       "FLUXNET_master.gppNtCutRef_umolCO2m2s1, ", 
                       "FLUXNET_master.gppNtCutSe_umolCO2m2s1, ",
                       "FLUXNET_master.recoDtVutRef_umolCO2m2s1, ",
                       "FLUXNET_master.recoDtVutSe_umolCO2m2s1, ",
                       "FLUXNET_master.recoDtCutRef_umolCO2m2s1, ",
                       "FLUXNET_master.recoDtCutSe_umolCO2m2s1, ",
                       "FLUXNET_master.gppDtVutRef_umolCO2m2s1, ",
                       "FLUXNET_master.gppDtVutSe_umolCO2m2s1, ",
                       "FLUXNET_master.gppDtCutRef_umolCO2m2s1, ",
                       "FLUXNET_master.gppDtCutSe_umolCO2m2s1 ",
                       "FROM FLUXNET_master INNER JOIN SITESID_master ON FLUXNET_master.site_id = SITESID_master.site_id WHERE FLUXNET_master.site_id = '",
                       ids[i,], "'", sep = "")
  )
}

## Close connnection to db
dbDisconnect(db)






# ATMOSPHERICHEATCONDUCTION
db <- dbConnect(SQLite(), dbname=myDB)
if ( "ATMOSPHERICHEATCONDUCTION" %in% dbListTables(db)){
  dbSendQuery(db, "DROP VIEW  ATMOSPHERICHEATCONDUCTION")
}
dbGetQuery(db, "CREATE VIEW ATMOSPHERICHEATCONDUCTION AS
           SELECT FLUXNET_master.record_id,
           SITESID_master.site,
           FLUXNET_master.site_id,
           FLUXNET_master.timestampStart,
           FLUXNET_master.timestampEnd,
           FLUXNET_master.date,
           FLUXNET_master.year,
           FLUXNET_master.day,
           FLUXNET_master.mo,
           FLUXNET_master.leFMDS_Wm2,
           FLUXNET_master.leFMDS_qc,
           FLUXNET_master.leCORR_Wm2,
           FLUXNET_master.leCORR_qc,
           FLUXNET_master.leCORRJOINTUNC_Wm2,
           FLUXNET_master.hFMDS_Wm2,
           FLUXNET_master.hFMDS_qc,
           FLUXNET_master.hCORR_Wm2,
           FLUXNET_master.hCORR_qc,
           FLUXNET_master.hCORRJOINTUNC_Wm2
           FROM FLUXNET_master INNER JOIN SITESID_master ON FLUXNET_master.site_id = SITESID_master.site_id"
)
## Close connnection to db
dbDisconnect(db)


db <- dbConnect(SQLite(), dbname=myDB)
ids <- dbGetQuery(db, "SELECT site_id FROM (SELECT DISTINCT site_id FROM FLUXNET_master)")

for (i in 1:length(ids[,1])){
  if ( paste("ATMOSPHERICHEATCONDUCTION_", ids[i,], sep = "") %in% dbListTables(db)){
    dbSendQuery(db, paste("DROP VIEW  ATMOSPHERICHEATCONDUCTION_", ids[i,], sep = ""))
  }
  
  dbGetQuery(db, paste("CREATE VIEW ATMOSPHERICHEATCONDUCTION_", ids[i,], " AS ",
                       "SELECT FLUXNET_master.record_id, ",
                       "SITESID_master.site, ",
                       "FLUXNET_master.timestampStart, ",
                       "FLUXNET_master.timestampEnd, ",
                       "FLUXNET_master.site_id, ",
                       "FLUXNET_master.date, ",
                       "FLUXNET_master.year, ",
                       "FLUXNET_master.day, ",
                       "FLUXNET_master.mo, ",
                       "FLUXNET_master.leFMDS_Wm2, ",
                       "FLUXNET_master.leFMDS_qc, ",
                       "FLUXNET_master.leCORR_Wm2, ",
                       "FLUXNET_master.leCORR_qc, ",
                       "FLUXNET_master.leCORRJOINTUNC_Wm2, ",
                       "FLUXNET_master.hFMDS_Wm2, ",
                       "FLUXNET_master.hFMDS_qc, ",
                       "FLUXNET_master.hCORR_Wm2, ",
                       "FLUXNET_master.hCORR_qc, ",
                       "FLUXNET_master.hCORRJOINTUNC_Wm2 ",
                       "FROM FLUXNET_master INNER JOIN SITESID_master ON FLUXNET_master.site_id = SITESID_master.site_id WHERE FLUXNET_master.site_id = '",
                       ids[i,], "'", sep = "")
  )
}
## Close connnection to db
dbDisconnect(db)


# SOILTS
db <- dbConnect(SQLite(), dbname=myDB)

if ( "SOILTS" %in% dbListTables(db)){
  dbSendQuery(db, "DROP VIEW  SOILTS")
}

dbGetQuery(db, "CREATE VIEW SOILTS AS
           SELECT FLUXNET_master.record_id,
           SITESID_master.site,
           FLUXNET_master.site_id,
           FLUXNET_master.timestampStart,
           FLUXNET_master.timestampEnd,
           FLUXNET_master.date,
           FLUXNET_master.year,
           FLUXNET_master.day,
           FLUXNET_master.mo,
           FLUXNET_master.tsFMDS1_degC,
           FLUXNET_master.tsFMDS1_qc,
           FLUXNET_master.tsFMDS2_degC,
           FLUXNET_master.tsFMDS2_qc,
           FLUXNET_master.tsFMDS3_degC,
           FLUXNET_master.tsFMDS3_qc,
           FLUXNET_master.tsFMDS4_degC,
           FLUXNET_master.tsFMDS4_qc,
           FLUXNET_master.tsFMDS5_degC,
           FLUXNET_master.tsFMDS5_qc,
           FLUXNET_master.swcFMDS1_degC,
           FLUXNET_master.swcFMDS1_qc,
           FLUXNET_master.swcFMDS2_degC,
           FLUXNET_master.swcFMDS2_qc,
           FLUXNET_master.swcFMDS3_degC,
           FLUXNET_master.swcFMDS3_qc,
           FLUXNET_master.swcFMDS4_degC,
           FLUXNET_master.swcFMDS4_qc,
           FLUXNET_master.swcFMDS5_degC,
           FLUXNET_master.swcFMDS5_qc
           FROM FLUXNET_master INNER JOIN SITESID_master ON FLUXNET_master.site_id = SITESID_master.site_id"
)
## Close connnection to db
dbDisconnect(db)


db <- dbConnect(SQLite(), dbname=myDB)
ids <- dbGetQuery(db, "SELECT site_id FROM (SELECT DISTINCT site_id FROM FLUXNET_master)")

for (i in 1:length(ids[,1])){
  if ( paste("SOILTS_", ids[i,], sep = "") %in% dbListTables(db)){
    dbSendQuery(db, paste("DROP VIEW  SOILTS_", ids[i,], sep = ""))
  }
  dbGetQuery(db, paste("CREATE VIEW SOILTS_", ids[i,], " AS ",
                       "SELECT FLUXNET_master.record_id, ",
                       "SITESID_master.site, ",
                       "FLUXNET_master.site_id, ",
                       "FLUXNET_master.timestampStart, ",
                       "FLUXNET_master.timestampEnd, ",
                       "FLUXNET_master.date, ",
                       "FLUXNET_master.year, ",
                       "FLUXNET_master.day, ",
                       "FLUXNET_master.mo, ",
                       "FLUXNET_master.tsFMDS1_degC, ",
                       "FLUXNET_master.tsFMDS1_qc, ",
                       "FLUXNET_master.tsFMDS2_degC, ",
                       "FLUXNET_master.tsFMDS2_qc, ",
                       "FLUXNET_master.tsFMDS3_degC, ",
                       "FLUXNET_master.tsFMDS3_qc, ",
                       "FLUXNET_master.tsFMDS4_degC, ",
                       "FLUXNET_master.tsFMDS4_qc, ",
                       "FLUXNET_master.tsFMDS5_degC, ",
                       "FLUXNET_master.tsFMDS5_qc, ",
                       "FLUXNET_master.swcFMDS1_degC, ",
                       "FLUXNET_master.swcFMDS1_qc, ",
                       "FLUXNET_master.swcFMDS2_degC, ",
                       "FLUXNET_master.swcFMDS2_qc, ",
                       "FLUXNET_master.swcFMDS3_degC, ",
                       "FLUXNET_master.swcFMDS3_qc, ",
                       "FLUXNET_master.swcFMDS4_degC, ",
                       "FLUXNET_master.swcFMDS4_qc, ",
                       "FLUXNET_master.swcFMDS5_degC, ",
                       "FLUXNET_master.swcFMDS5_qc ",
                       "FROM FLUXNET_master INNER JOIN SITESID_master ON FLUXNET_master.site_id = SITESID_master.site_id WHERE FLUXNET_master.site_id = '",
                       ids[i,], "'", sep = "")
  )
}
## Close connnection to db
dbDisconnect(db)


# METEOTS
db <- dbConnect(SQLite(), dbname=myDB)

if ( "METEOROLOGICAL" %in% dbListTables(db)){
  dbSendQuery(db, "DROP VIEW  METEOROLOGICAL")
}
dbGetQuery(db, "CREATE VIEW METEOROLOGICAL AS
           SELECT FLUXNET_master.record_id,
           SITESID_master.site,
           FLUXNET_master.site_id,
           FLUXNET_master.timestampStart,
           FLUXNET_master.timestampEnd,
           FLUXNET_master.date,
           FLUXNET_master.year,
           FLUXNET_master.day,
           FLUXNET_master.mo,
           FLUXNET_master.taFMDS_degC,
           FLUXNET_master.taFMDS_qc,
           FLUXNET_master.taF_degC,
           FLUXNET_master.taF_qc,
           FLUXNET_master.swInFMDS_Wm2,
           FLUXNET_master.swInFMDS_qc,
           FLUXNET_master.swInF_Wm2,
           FLUXNET_master.swInF_qc,
           FLUXNET_master.lwInFMDS_Wm2,
           FLUXNET_master.lwInFMDS_qc,
           FLUXNET_master.lwInF_Wm2,
           FLUXNET_master.lwInF_qc,
           FLUXNET_master.vpdFMDS_hPa, 
           FLUXNET_master.vpdFMDS_qc,
           FLUXNET_master.vpdF_hPa,
           FLUXNET_master.vpdF_qc,
           FLUXNET_master.pa_kPA, 
           FLUXNET_master.ws_ms1, 
           FLUXNET_master.paF_kPa, 
           FLUXNET_master.paF_qc, 
           FLUXNET_master.p_mm, 
           FLUXNET_master.pF_mm, 
           FLUXNET_master.pF_qc, 
           FLUXNET_master.wsF_ms1,
           FLUXNET_master.wsF_qc
           FROM FLUXNET_master INNER JOIN SITESID_master ON FLUXNET_master.site_id = SITESID_master.site_id"
)
## Close connnection to db
dbDisconnect(db)

db <- dbConnect(SQLite(), dbname=myDB)
ids <- dbGetQuery(db, "SELECT site_id FROM (SELECT DISTINCT site_id FROM FLUXNET_master)")

for (i in 1:length(ids[,1])){
  
  if ( paste("METEOROLOGICAL_", ids[i,], sep = "") %in% dbListTables(db)){
    dbSendQuery(db, paste("DROP VIEW  METEOROLOGICAL_", ids[i,], sep = ""))
  }
  
  dbGetQuery(db, paste("CREATE VIEW METEOROLOGICAL_", ids[i,], " AS ",
                       "SELECT FLUXNET_master.record_id, ",
                       "SITESID_master.site, ",
                       "FLUXNET_master.site_id, ",
                       "FLUXNET_master.timestampStart, ",
                       "FLUXNET_master.timestampEnd, ",
                       "FLUXNET_master.date, ",
                       "FLUXNET_master.year, ",
                       "FLUXNET_master.day, ",
                       "FLUXNET_master.mo, ",
                       "FLUXNET_master.taFMDS_degC, ",
                       "FLUXNET_master.taFMDS_qc, ",
                       "FLUXNET_master.taF_degC, ",
                       "FLUXNET_master.taF_qc, ",
                       "FLUXNET_master.swInFMDS_Wm2, ",
                       "FLUXNET_master.swInFMDS_qc, ",
                       "FLUXNET_master.swInF_Wm2, ",
                       "FLUXNET_master.swInF_qc, ",
                       "FLUXNET_master.lwInFMDS_Wm2, ",
                       "FLUXNET_master.lwInFMDS_qc, ",
                       "FLUXNET_master.lwInF_Wm2, ",
                       "FLUXNET_master.lwInF_qc, ",
                       "FLUXNET_master.vpdFMDS_hPa, " ,
                       "FLUXNET_master.vpdFMDS_qc, ",
                       "FLUXNET_master.vpdF_hPa, ",
                       "FLUXNET_master.vpdF_qc, ",
                       "FLUXNET_master.pa_kPA, ",
                       "FLUXNET_master.ws_ms1, ",
                       "FLUXNET_master.paF_kPa, ",
                       "FLUXNET_master.paF_qc, ",
                       "FLUXNET_master.p_mm, ",
                       "FLUXNET_master.pF_mm, ",
                       "FLUXNET_master.pF_qc, ",
                       "FLUXNET_master.wsF_ms1, ",
                       "FLUXNET_master.wsF_qc ",
                       "FROM FLUXNET_master INNER JOIN SITESID_master ON FLUXNET_master.site_id = SITESID_master.site_id WHERE FLUXNET_master.site_id = '",
                       ids[i,], "'", sep = "")
  )
}
## Close connnection to db
dbDisconnect(db)
