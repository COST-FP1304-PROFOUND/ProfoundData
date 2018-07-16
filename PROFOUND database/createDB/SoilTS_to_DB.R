################################################################################
# This script writes the FLUX data to the DB
#
################################################################################
#------------------------------------------------------------------------------#

#------------------------------------------------------------------------------#

# Load libraries


require(sqldf)
require(DBI)
require(RSQLite)


#writeDB_SOILTS <- function(myDB, RData ){
variables <- read.csv("/home/trashtos/ownCloud/PROFOUND_Data/Processed/fluxnet2015/SOIL_TS.csv",
                       sep = ",", header = T)  
variables <- variables$Variable
variables <- variables[c(1:10, 21:30)]  
columns <- c("IDrecord", "site_id", "date", "year", "day", "mo", 
               as.character(variables))
  # Check data
#  id <- 0
#  for (i in 1:length(RData)){  
#    df <- RData[[i]]
#    df <- df[!is.na(df$date),]
#    df$IDrecord <- c((id+1):(id+length(df$site)))
#    df$date <- as.character(df$date)
#    df[df == -9999] <- NA  
#    for (i in 1:length(columns)){
#      if (!columns[i] %in% names(df)){
#        df[[columns[i]]] <- NA
#      }
#    }    
    
#    dbrecords <- try(df[,columns], TRUE)
#    if (class)

#    id <- id+length(df$site)
#  }
  
  
#}

# open connection to DB
# open connection to DB
db <- dbConnect(SQLite(), dbname= myDB)
# create df in DB
dbSendQuery(conn = db,
            "CREATE TABLE SOILTS
            (IDrecord INTEGER PRIMARY KEY,
            site_id INTEGER,
            date TEXT,
            year INTEGER,
            day INTEGER,
            mo INTEGER,
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
            swcFMDS5_qc INTEGER
            )")

# Check the df
dbListTables(db)   # The dfs in the database
dbListFields(db, "SOILTS") # The fields in the df

dbDisconnect(db)
#dbSendQuery(conn = db, "DROP TABLE SOIL_TS")

load("/home/trashtos/ownCloud/PROFOUND_Data/Processed/RData/FLUXNET_SoilTS.RData")

#db <- dbConnect(SQLite(), dbname= myDB)
#hala <- dbListFields(db, "FLUX") 
id <- 0
for (i in 1:length(FLUXNET_SoilTS)){  
  df <- FLUXNET_SoilTS[[i]]
  df$IDrecord <- c((id+1):(id+length(df$site)))
  df$date <- as.character(df$date)
  df[df == -9999] <- NA  
  for (i in 1:length(columns)){
    if (!columns[i] %in% names(df)){
      df[[columns[i]]] <- NA
    }
  }    
  
  db <- dbConnect(SQLite(), dbname= myDB)  
  dbWriteTable(db, "SOILTS", df[,columns], append=TRUE, row.names = FALSE)  
  dbDisconnect(db)
  id <- id+length(df$site)
}
#dbDisconnect(db)

# Connect to df and creating indexes for fast querying
# open connection to DB
db <- dbConnect(SQLite(), dbname=myDB)

# create index for variables we are going to query: so far location, year
dbGetQuery(db,"CREATE INDEX index_SOILTS_site ON SOILTS (site)")
dbGetQuery(db,"CREATE INDEX index_SOILTS_year ON SOILTS (year)")

## Close connnection to db
dbDisconnect(db)
