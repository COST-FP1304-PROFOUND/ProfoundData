#------------------------------------------------------------------------------#
# ISI-MIP data
#     This script does the following:
#       1. Finds all ISI-MIP files for the desired locations
#       2. Opens a connection to a SQL DB
#       3. Reads and processes data by location, storing the data in the DB
#       4. Closes DB connection and deletes unzipped files
#
#------------------------------------------------------------------------------#
# loadsites
load("~/ownCloud/PROFOUND_Data/Processed/RData/Sites.RData")
# get the  locations
site <- Sites$name2
site.id <-  Sites$site_id
names(site.id) <- site


# Read all zip files
inDir <- "~/ownCloud/PROFOUND_Data/Processed/ISIMIP2A"
filenames <- list.files(inDir, full.names=TRUE, recursive = TRUE)

print.progressForcing <- function(df){
  cat("\n");cat(rep("-", 30));cat("\n")
  cat(as.character(unique(df$site)));cat("\n")
  cat(as.character(unique(df$product)));cat("\n");cat("\n")
}
  

#------------------------------------------------------------------------------#
#                    CREATE   SQL    TABLE
#------------------------------------------------------------------------------#
# Load libraries
library(sqldf)
library(DBI)
library(RSQLite)
# open connection to DB
db <- dbConnect(SQLite(), dbname= myDB)

if ( "CLIMATE_ISIMIP2A_master" %in% dbListTables(db))  dbSendQuery(db, "DROP TABLE CLIMATE_ISIMIP2A_master")

# create table in DB (cant type minus)
dbSendQuery(conn = db,
            "CREATE TABLE CLIMATE_ISIMIP2A_master
       (record_id INTEGER NOT NULL,
        site_id INTEGER NOT NULL,
        date TEXT CHECK(date <> ''),
        forcingDataset TEXT CHECK(forcingDataset <> ''),
        day INTEGER CHECK(NULL OR  day >= 0 AND day <= 31),
        mo INTEGER CHECK(NULL OR mo >= 0 AND mo <= 12),
        year INTEGER CHECK(NULL OR year >= 0 AND year < 9999),
        tmax_degC REAL CHECK(NULL OR tmax_degC > -90 AND tmax_degC < 80 ),
        tmean_degC REAL CHECK(NULL OR tmean_degC > -90 AND tmean_degC < 80 ),
        tmin_degC  REAL CHECK(NULL OR tmin_degC > -90 AND tmin_degC < 80 ),
        p_mm REAL  CHECK(NULL OR p_mm >=0 AND p_mm <= 2000),
        relhum_percent REAL CHECK(NULL OR relhum_percent > 0 AND relhum_percent <= 100),
        airpress_hPa REAL CHECK(NULL OR airpress_hPa > 500 AND airpress_hPa < 1200),
        rad_Jcm2day REAL CHECK(NULL OR rad_Jcm2day >= 0 AND rad_Jcm2day < 4320),
        wind_ms REAL CHECK(NULL OR wind_ms >= 0 AND wind_ms <= 120),
        PRIMARY KEY (record_id),
        FOREIGN KEY (site_id) REFERENCES SITESID_master(site_id)
            )")



# Check the table
dbListTables(db) # The tables in the database
dbListFields(db, "CLIMATE_ISIMIP2A_master") # The fields in the table
## Close connnection to db
dbDisconnect(db)
# dbSendQuery(db, "DROP TABLE ISIMIP2A")

#------------------------------------------------------------------------------#
#               ENTER DATA IN THE TABLE
#------------------------------------------------------------------------------#
columns <- c("record_id", "site_id", "date", "product","day", "mo",
             "year","tmax_degC","tmean_degC", "tmin_degC", "p_mm", "relhum_percent",
             "airpress_hPa", "rad_Jcm2day", "wind_ms")


id <- 0
# Loop over files adds data to DB, could also add it to list and then do.call(rbind, listDf)
for (i in 1:length(filenames)){

  df <- read.table(filenames[i], header = TRUE, sep = "")
  file.site <-  as.character(unique(df$site))
  
  if (file.site == "Solling"){
    df1 <- df
    df1$site <- "Solling_304"
    df1$site_id <- site.id[["Solling_304"]]
    df2 <- df
    df2$site <- "Solling_305"
    df2$site_id <- site.id[["Solling_305"]]
    df <- rbind(df1, df2)
    
    df$record_id <- c((id+1):(id+length(df$site)))
    # open connection to DB
    db <- dbConnect(SQLite(), dbname= myDB)
    dbWriteTable(db, "CLIMATE_ISIMIP2A_master",
                 df[,columns],
                 append=TRUE, row.names = FALSE)
    dbDisconnect(db)
    
    print.progressForcing(df)
    # reset the id values
    id <- id+length(df$site)
    # delete data.all to keep RAM low
    rm(df)
    
  }else if (file.site %in% site){
    df$site_id <- site.id[[file.site]]
    df$record_id <- c((id+1):(id+length(df$site)))
    # open connection to DB
    db <- dbConnect(SQLite(), dbname= myDB)
    dbWriteTable(db, "CLIMATE_ISIMIP2A_master",
                 df[,columns],
                 append=TRUE, row.names = FALSE)
    dbDisconnect(db)
    print.progressForcing(df)
    # reset the id values
    id <- id+length(df$site)
    rm(df)
  }
}


#------------------------------------------------------------------------------#
# Close connections and delete data
#------------------------------------------------------------------------------#
# Connect to table and creating indexes for fast querying
