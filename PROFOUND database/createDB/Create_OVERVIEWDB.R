#------------------------------------------------------------------------------#
# Created Views
#     This script does the following:
#
#
#------------------------------------------------------------------------------#
# Load libraries
require(sqldf)
require(DBI)
require(RSQLite)
# open connection to DB
db <- dbConnect(SQLite(), dbname= myDB)
if ( "OVERVIEW" %in% dbListTables(db)){
  dbSendQuery(db, "DROP VIEW OVERVIEW")}

datasets.available <- dbListTables(db)

# Close the connection
dbDisconnect(db)

# GET ONE SITE
dataset <- c("SITES", "TREE", "STAND", "SOIL", "CLIMATE_LOCAL",
             "CLIMATE_ISIMIP2B",  "CLIMATE_ISIMIP2BLBC", "CLIMATE_ISIMIP2A", "CLIMATE_ISIMIPFT",
             "METEOROLOGICAL",
             #"CLIMATEFLUXNET",# "CLIMATEEUROFLUX",
             #"FLUXNET",
             "FLUX", "ATMOSPHERICHEATCONDUCTION", "SOILTS", "NDEPOSITION_EMEP",
             "NDEPOSITION_ISIMIP2B", "CO2_ISIMIP", "MODIS_MOD09A1", "MODIS_MOD15A2",
             "MODIS_MOD11A2", "MODIS_MOD13Q1", "MODIS_MOD17A2") #, "MODIS")
datasets.columns <- sapply(dataset,
                       function(x) paste("CASE WHEN site_id IN (SELECT site_id FROM (SELECT DISTINCT site_id FROM ", x, "_master)) THEN 1 ELSE 0 END AS ", x, " ", sep=""))

datasets.columns["CLIMATE_LOCAL"] <- "CASE WHEN site_id IN (SELECT site_id FROM (SELECT DISTINCT site_id FROM CLIMATE_LOCAL_master)) THEN 1 WHEN site_id IN (SELECT site_id FROM (SELECT DISTINCT site_id FROM FLUXNET_master)) THEN 1 ELSE 0 END AS CLIMATE_LOCAL"
datasets.columns["MODIS"] <- gsub( "AS MODIS_MOD09A1","AS MODIS", datasets.columns["MODIS_MOD09A1"])
datasets.columns["FLUX"] <- gsub("FLUX_master", "FLUXNET_master", datasets.columns["FLUX"])
datasets.columns["METEOROLOGICAL"] <- gsub("METEOROLOGICAL_master", "FLUXNET_master", datasets.columns["METEOROLOGICAL"])
datasets.columns["SOILTS"] <- gsub("SOILTS_master", "FLUXNET_master", datasets.columns["SOILTS"])
datasets.columns["ATMOSPHERICHEATCONDUCTION"] <- gsub("ATMOSPHERICHEATCONDUCTION_master", "FLUXNET_master", datasets.columns["ATMOSPHERICHEATCONDUCTION"])
datasets.columns["CO2_ISIMIP"] <- "1 AS CO2_ISIMIP"


#SINGLE OVERVIEW
beginning <- c("CREATE VIEW OVERVIEW AS  SELECT site_id, site ")
end <- c("FROM SITESID_master WHERE SITESID_master.site_id <> 99")
query <- c(beginning, datasets.columns)
query <- paste(query, collapse = ",")
query <- paste(query, end , collapse = " ")
db <- dbConnect(SQLite(), dbname= myDB)
if ("OVERVIEW" %in% dbListTables(db)) dbGetQuery(db, "DROP VIEW OVERVIEW")
dbGetQuery(db, query)
# Close the connection
dbDisconnect(db)

#------------------------------------------------------------------------------#
dataset <- c("SITES", "TREE", "STAND", "SOIL", "CLIMATE_LOCAL",
             "METEOROLOGICAL",
             #"CLIMATEFLUXNET",# "CLIMATEEUROFLUX",
             #"FLUXNET",
             "FLUX", "ATMOSPHERICHEATCONDUCTION", "SOILTS", "NDEPOSITION_EMEP",
             "MODIS_MOD09A1", "MODIS_MOD15A2",
             "MODIS_MOD11A2", "MODIS_MOD13Q1", "MODIS_MOD17A2") #, "MODIS")
db <- dbConnect(SQLite(), dbname= myDB)
datasets.available <- dbListTables(db)
# Close the connection
dbDisconnect(db)
# Overview
datasets.available <- datasets.available[!grepl("_master", datasets.available)]
datasets.available <- datasets.available[!grepl("METADATA", datasets.available)]
datasets.available <- datasets.available[!grepl("VERSION", datasets.available)]
datasets.available <- datasets.available[!grepl("_[0-9]", datasets.available)]
datasets.available <- datasets.available[!grepl("TREE", datasets.available)]
datasets.available <- datasets.available[!grepl("STAND", datasets.available)]
datasets.available <- datasets.available[!grepl("SITES", datasets.available)]
datasets.available <- datasets.available[!datasets.available %in% dataset]
datasets.CO2 <- datasets.available[grepl("CO2_ISIMIP", datasets.available)]
datasets.ISIMIPFT <- datasets.available[grepl("CLIMATE_ISIMIPFT", datasets.available)]
datasets.ISIMIP2A <- datasets.available[grepl("CLIMATE_ISIMIP2A", datasets.available)]
datasets.ISIMIP2BLBC <- datasets.available[grepl("CLIMATE_ISIMIP2BLBC", datasets.available)]
datasets.ISIMIP2B <- datasets.available[grepl("CLIMATE_ISIMIP2B_", datasets.available)]
datasets.ISIMIP2B <- c("CLIMATE_ISIMIP2B", datasets.ISIMIP2B)
datasets.NDEP2B <- datasets.available[grepl("NDEPOSITION_ISIMIP2B", datasets.available)]

datasets.CO2 <- sapply(datasets.CO2,
                           function(x) paste("1  AS ", x, sep=""))

datasets.ISIMIPFT <- sapply(datasets.ISIMIPFT,
                            function(x) paste("CASE WHEN site_id IN (SELECT site_id FROM (SELECT DISTINCT site_id FROM CLIMATE_ISIMIPFT_master)) THEN 1 ELSE 0 END AS ", x, sep=""))

datasets.ISIMIP2A <- sapply(datasets.ISIMIP2A,
                            function(x) paste("CASE WHEN site_id IN (SELECT site_id FROM (SELECT DISTINCT site_id FROM CLIMATE_ISIMIP2A_master)) THEN 1 ELSE 0 END AS ", x, sep=""))

datasets.ISIMIP2B <- sapply(datasets.ISIMIP2B,
                            function(x) paste("CASE WHEN site_id IN (SELECT site_id FROM (SELECT DISTINCT site_id FROM CLIMATE_ISIMIP2B_master)) THEN 1 ELSE 0 END AS ", x, sep=""))
datasets.ISIMIP2BLBC <- sapply(datasets.ISIMIP2BLBC,
                            function(x) paste("CASE WHEN site_id IN (SELECT site_id FROM (SELECT DISTINCT site_id FROM CLIMATE_ISIMIP2BLBC_master)) THEN 1 ELSE 0 END AS ", x, sep=""))
datasets.NDEP2B <- sapply(datasets.NDEP2B,
                            function(x) paste("CASE WHEN site_id IN (SELECT site_id FROM (SELECT DISTINCT site_id FROM NDEPOSITION_ISIMIP2B_master)) THEN 1 ELSE 0 END AS ", x, sep=""))
datasets.columns <- sapply(dataset,
                           function(x) paste("CASE WHEN site_id IN (SELECT site_id FROM (SELECT DISTINCT site_id FROM ", x, "_master)) THEN 1 ELSE 0 END AS ", x, " ", sep=""))

datasets.columns["CLIMATE_LOCAL"] <- "CASE WHEN site_id IN (SELECT site_id FROM (SELECT DISTINCT site_id FROM CLIMATE_LOCAL_master)) THEN 1 WHEN site_id IN (SELECT site_id FROM (SELECT DISTINCT site_id FROM FLUXNET_master)) THEN 1 ELSE 0 END AS CLIMATE_LOCAL"
#datasets.columns["MODIS"] <- gsub("MODIS_master", "MODIS8_master", datasets.columns["MODIS"])
datasets.columns["FLUX"] <- gsub("FLUX_master", "FLUXNET_master", datasets.columns["FLUX"])
datasets.columns["METEOROLOGICAL"] <- gsub("METEOROLOGICAL_master", "FLUXNET_master", datasets.columns["METEOROLOGICAL"])
datasets.columns["SOILTS"] <- gsub("SOILTS_master", "FLUXNET_master", datasets.columns["SOILTS"])
datasets.columns["ATMOSPHERICHEATCONDUCTION"] <- gsub("ATMOSPHERICHEATCONDUCTION_master", "FLUXNET_master", datasets.columns["ATMOSPHERICHEATCONDUCTION"])

datasets.columns["MODIS"] <- gsub( "AS MODIS_MOD09A1","AS MODIS", datasets.columns["MODIS_MOD09A1"])
datasets.columns["FLUXNET"] <- gsub("FLUX ", "FLUXNET", datasets.columns["FLUX"])

beginning <- c("CREATE VIEW OVERVIEW_EXTENDED AS  SELECT site_id, site ")
end <- c("FROM SITESID_master WHERE SITESID_master.site_id <> 99")
query <- c(beginning, datasets.columns, datasets.CO2, datasets.ISIMIPFT,
           datasets.ISIMIP2A, datasets.ISIMIP2B,datasets.ISIMIP2BLBC, datasets.NDEP2B)
query <- paste(query, collapse = ", ")
query <- paste(query, end , collapse = " ")




db <- dbConnect(SQLite(), dbname= myDB)
if ("OVERVIEW_EXTENDED" %in% dbListTables(db)) dbGetQuery(db, "DROP VIEW OVERVIEW_EXTENDED")
dbGetQuery(db, query)
# Close the connection
dbDisconnect(db)

