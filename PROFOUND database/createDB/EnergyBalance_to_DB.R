################################################################################
# This script writes the FLUX data to the DB
#
################################################################################
#------------------------------------------------------------------------------#
variables <- read.table("/home/trashtos/ownCloud/PROFOUND_Data/Processed/fluxnet2015/ENERGY_BALANCE.csv",
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
            "CREATE TABLE ENERGYBALANCE
            (IDrecord INTEGER PRIMARY KEY,
            site_id INTEGER,
            date TEXT,
            year INTEGER,
            day INTEGER,
            mo INTEGER,
            leFMDS_Wm2 REAL,
            leFMDS_qc INTEGER,
            leCORR_Wm2 REAL,
            leCORRJOINTUNC_Wm2 REAL,
            hFMDS_Wm2 REAL,
            hFMDS_qc INTEGER,
            hCORR_Wm2 REAL,
            hCORRJOINTUNC_Wm2 REAL
            )")

# Check the df
dbListTables(db)   # The dfs in the database
dbListFields(db, "ENERGYBALANCE") # The fields in the df

dbDisconnect(db)
#dbSendQuery(conn = db, "DROP TABLE ENERGYBALANCE")

load("/home/trashtos/ownCloud/PROFOUND_Data/Processed/RData/FLUXNET_EenergyBalance.RData")

#db <- dbConnect(SQLite(), dbname= myDB)
#hala <- dbListFields(db, "FLUX") 
id <- 0
for (i in 1:length(FLUXNET_EenergyBalance)){  
  df <- FLUXNET_EenergyBalance[[i]]
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
  dbWriteTable(db, "ENERGYBALANCE", df[,columns], append=TRUE, row.names = FALSE)  
  dbDisconnect(db)
  id <- id+length(df$site)
}
#dbDisconnect(db)

# Connect to df and creating indexes for fast querying
# open connection to DB
db <- dbConnect(SQLite(), dbname=myDB)

# create index for variables we are going to query: so far location, year
dbGetQuery(db,"CREATE INDEX index_ENERGYBALANCE_site ON ENERGYBALANCE (site)")
dbGetQuery(db,"CREATE INDEX index_ENERGYBALANCE_year ON ENERGYBALANCE (year)")

## Close connnection to db
dbDisconnect(db)
