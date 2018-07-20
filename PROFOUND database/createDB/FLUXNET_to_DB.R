################################################################################
# This script writes the FLUX data to the DB
#
################################################################################
#------------------------------------------------------------------------------#
# GEt all fluxnet variables
# FLUXES
variables <- read.table("~/ownCloud/PROFOUND_Data/Processed/fluxnet2015/FLUX.csv",
                        sep = ",", header = T)
variables <- variables[ variables$Tier == 1,]$Variable
# ENERGY BALANCE
var <- read.csv("~/ownCloud/PROFOUND_Data/Processed/fluxnet2015/ENERGY_BALANCE.csv",
                sep = ",", header = T)
var <- var[var$Tier == 1, ]$Variable
var
var <- c("LE_F_MDS", "LE_F_MDS_QC", "LE_CORR", "LE_CORR_QC", 
         "LE_CORR_JOINTUNC",  "H_F_MDS", "H_F_MDS_QC", "H_CORR", "H_CORR_QC","H_CORR_JOINTUNC" )
variables <- c(as.character(variables), as.character(var))
# SOIL_TS
var <- read.csv("~/ownCloud/PROFOUND_Data/Processed/fluxnet2015/SOIL_TS.csv",
                sep = ",", header = T)
var <- var$Variable
variables <- c(as.character(variables), as.character(var))
# METEO
var <- read.csv("~/ownCloud/PROFOUND_Data/Processed/fluxnet2015/CLIMATE.csv",
                sep = ",", header = T)
var <- var$Variable
variables <- c(as.character(variables), as.character(var))
# ADD TIME STAMPS
variables <- c("TIMESTAMP_START", "TIMESTAMP_END", as.character(variables))
# Add the date

columns <- c("record_id", "site_id", "date", "year", "day", "mo", 
              as.character(variables))

columns <- columns[!grepl("[0, 6, 7, 8,9]", columns)]

# loadsites
load("~/ownCloud/PROFOUND_Data/Processed/RData/Sites.RData")
# get the  locations
site <- Sites$site2
site.id <-  Sites$site_id
names(site.id) <- site
#------------------------------------------------------------------------------#

# Load libraries
library(sqldf)
library(DBI)
library(RSQLite)


# open connection to DB
# open connection to DB
db <- dbConnect(SQLite(), dbname= myDB)

if ( "FLUXNET_master" %in% dbListTables(db)){
  dbSendQuery(db, "DROP TABLE FLUXNET_master")}

# create df in DB
dbSendQuery(conn = db,
            "CREATE TABLE FLUXNET_master
       (record_id INTEGER NOT NULL,
        site_id INTEGER,
        date TEXT,
        year INTEGER,
        day INTEGER,
        mo INTEGER,
        timestampStart INTEGER,
        timestampEnd INTEGER,
        neeCutRef_umolCO2m2s1 REAL,
        neeVutRef_umolCO2m2s1 REAL,
        neeCutRef_qc INTEGER,
        neeVutRef_qc INTEGER,
        neeCutRefJointunc_umolCO2m2s1 REAL,
        neeVutRefJointunc_umolCO2m2s1 REAL,
        recoNtVutRef_umolCO2m2s1 REAL,
        recoNtVutSe_umolCO2m2s1 REAL,
        recoNtCutRef_umolCO2m2s1 REAL,
        recoNtCutSe_umolCO2m2s1 REAL,
        gppNtVutRef_umolCO2m2s1 REAL,
        gppNtVutSe_umolCO2m2s1 REAL,
        gppNtCutRef_umolCO2m2s1 REAL,
        gppNtCutSe_umolCO2m2s1 REAL,
        recoDtVutRef_umolCO2m2s1 REAL,
        recoDtVutSe_umolCO2m2s1 REAL,
        recoDtCutRef_umolCO2m2s1 REAL,
        recoDtCutSe_umolCO2m2s1 REAL,
        gppDtVutRef_umolCO2m2s1 REAL,
        gppDtVutSe_umolCO2m2s1 REAL,
        gppDtCutRef_umolCO2m2s1 REAL,
        gppDtCutSe_umolCO2m2s1 REAL,
        leFMDS_Wm2 REAL,
        leFMDS_qc INTEGER,
        leCORR_Wm2 REAL,
        leCORR_qc INTEGER,
        leCORRJOINTUNC_Wm2 REAL,
        hFMDS_Wm2 REAL,
        hFMDS_qc INTEGER,
        hCORR_Wm2 REAL,
        hCORR_qc INTEGER,
        hCORRJOINTUNC_Wm2 REAL,
        tsFMDS1_degC REAL,
        tsFMDS1_qc INTEGER, 
        tsFMDS2_degC REAL,
        tsFMDS2_qc INTEGER, 
        tsFMDS3_degC REAL,
        tsFMDS3_qc INTEGER, 
        tsFMDS4_degC REAL,
        tsFMDS4_qc INTEGER, 
        tsFMDS5_degC REAL,
        tsFMDS5_qc INTEGER,
        swcFMDS1_degC REAL,
        swcFMDS1_qc INTEGER, 
        swcFMDS2_degC REAL,
        swcFMDS2_qc INTEGER, 
        swcFMDS3_degC REAL,
        swcFMDS3_qc INTEGER, 
        swcFMDS4_degC REAL,
        swcFMDS4_qc INTEGER, 
        swcFMDS5_degC REAL,
        swcFMDS5_qc INTEGER,
        taFMDS_degC REAL,
        taFMDS_qc INTEGER,
        taF_degC REAL,
        taF_qc INTEGER,
        swInFMDS_Wm2 REAL,
        swInFMDS_qc INTEGER,
        swInF_Wm2 REAL,
        swInF_qc INTEGER,
        lwInFMDS_Wm2 REAL,
        lwInFMDS_qc INTEGER,
        lwInF_Wm2 REAL,
        lwInF_qc INTEGER,          
        vpdFMDS_hPa REAL,
        vpdFMDS_qc INTEGER,
        vpdF_hPa REAL,
        vpdF_qc INTEGER,
        pa_kPA REAL,
        ws_ms1 REAL,
        paF_kPa REAL,
        paF_qc INTEGER,
        p_mm REAL,
        pF_mm REAL,
        pF_qc INTEGER,
        wsF_ms1 REAL,
        wsF_qc INTEGER,
        PRIMARY KEY (record_id),
        FOREIGN KEY (site_id) REFERENCES SITESID_master(site_id)
            )")

# Check the df
dbListTables(db)   # The dfs in the database
dbListFields(db, "FLUXNET_master") # The fields in the df

dbDisconnect(db)



load("~/ownCloud/PROFOUND_Data/Processed/RData/FLUXNET_raw.RData")

#db <- dbConnect(SQLite(), dbname= myDB)
#hala <- dbListFields(db, "FLUX") 
id <- 0
for (i in 1:length(FLUXNET_raw)){  
  df <- FLUXNET_raw[[i]]
  if (unique(df$site) %in% site){
    df <- df[!is.na(df$date),]
    df$record_id <- c((id+1):(id+length(df$site)))
    df$date <- as.character(df$date)
    df[df == -9999] <- NA  
    for (j in 1:length(columns)){
      if (!columns[j] %in% names(df)){
        df[[columns[j]]] <- NA
      }
    }    
    db <- dbConnect(SQLite(), dbname= myDB)  
    dbWriteTable(db, "FLUXNET_master", df[,columns], append=TRUE, row.names = FALSE)  
    dbDisconnect(db)
    id <- id+length(df$site)
  }
}
#dbDisconnect(db)

# Connect to df and creating indexes for fast querying
# open connection to DB
db <- dbConnect(SQLite(), dbname=myDB)

# create index for variables we are going to query: so far location, year
dbGetQuery(db,"CREATE INDEX index_FLUXNET_master_site_id ON FLUXNET_master (site_id)")
dbGetQuery(db,"CREATE INDEX index_FLUXNET_master_year ON FLUXNET_master (year)")

## Close connnection to db
dbDisconnect(db)

