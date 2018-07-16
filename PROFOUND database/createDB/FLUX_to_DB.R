################################################################################
# This script writes the FLUX data to the DB
#
################################################################################
#------------------------------------------------------------------------------#
variables <- read.table("/home/trashtos/ownCloud/PROFOUND_Data/Processed/fluxnet2015/FLUX.csv",
                        sep = ",", header = T)

variables <- variables[ variables$Tier == 1,]$Variable


columns <- c("IDrecord", "site_id", "date", "year", "day", "mo", 
              as.character(variables))

#------------------------------------------------------------------------------#

# Load libraries
library(sqldf)
library(DBI)
library(RSQLite)


# open connection to DB
# open connection to DB
db <- dbConnect(SQLite(), dbname= myDB)
# create df in DB
dbSendQuery(conn = db,
            "CREATE TABLE FLUX
       (IDrecord INTEGER PRIMARY KEY,
        site_id INTEGER,
        date TEXT,
        year INTEGER,
        day INTEGER,
        mo INTEGER,
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
        gppDtCutSe_umolCO2m2s1 REAL
            )")

# Check the df
dbListTables(db)   # The dfs in the database
dbListFields(db, "FLUX") # The fields in the df

dbDisconnect(db)
#dbSendQuery(conn = db, "DROP TABLE FLUX")

load("/home/trashtos/ownCloud/PROFOUND_Data/Processed/RData/FLUXNET_Flux.RData")

#db <- dbConnect(SQLite(), dbname= myDB)
#hala <- dbListFields(db, "FLUX") 
id <- 0
for (i in 1:length(FLUXNET_Flux)){  
  df <- FLUXNET_Flux[[i]]
  df <- df[!is.na(df$date),]
  df$IDrecord <- c((id+1):(id+length(df$site)))
  df$date <- as.character(df$date)
  df[df == -9999] <- NA  
  for (i in 1:length(columns)){
    if (!columns[i] %in% names(df)){
      df[[columns[i]]] <- NA
    }
  }    
  db <- dbConnect(SQLite(), dbname= myDB)  
  dbWriteTable(db, "FLUX", df[,columns], append=TRUE, row.names = FALSE)  
  dbDisconnect(db)
  id <- id+length(df$site)
}
#dbDisconnect(db)

# Connect to df and creating indexes for fast querying
# open connection to DB
db <- dbConnect(SQLite(), dbname=myDB)

# create index for variables we are going to query: so far location, year
dbGetQuery(db,"CREATE INDEX index_FLUX_site_id ON FLUX (site_id)")
dbGetQuery(db,"CREATE INDEX index_FLUX_year ON FLUX (year)")

## Close connnection to db
dbDisconnect(db)

