# Load libraries
library(sqldf)
library(DBI)
library(RSQLite)

# GET ONE SITE
dataset <- c("TREE", "STAND", "SOIL", "CLIMATE_LOCAL")

gsubMetadata <- function(x){
  query <- gsub(  'CREATE VIEW (\\w+) AS',""  ,  x)  
  for (i in 1:length(query)){
    query[i] <- gsub("SELECT", paste("SELECT '",names(query)[i], "' AS dataset, ", sep= "" ), query[i])
  }
  
  return(query)
}


#------------------------------------------------------------------------------#
#   METADATA FULL SITE
#------------------------------------------------------------------------------#
# GET ONE SITE
dataset <- c("SITES", "TREE", "STAND", "SOIL", "CLIMATE_LOCAL",# "CLIMATEFLUXNET",# "CLIMATEEUROFLUX",
             "FLUXNET", "FLUX", "ATMOSPHERICHEATCONDUCTION", "SOILTS", "NDEPOSITION_EMEP",
             "NDEPOSITION_ISIMIP2B", "CO2_ISIMIP",  "CLIMATE_ISIMIP2B", "CLIMATE_ISIMIP2A",
             "CLIMATE_ISIMIPFT",  "MODIS_MOD09A1", "MODIS_MOD11A2", "MODIS_MOD13Q1",
             "MODIS_MOD15A2",  "MODIS_MOD17A2")

gsubMetadata <- function(x){
  query <- gsub(  'CREATE VIEW (\\w+) AS',""  ,  x)  
  for (i in 1:length(query)){
    query[i] <- gsub("SELECT", paste("SELECT '",names(query)[i], "' AS dataset, ", sep= "" ), query[i])
  }
  
  return(query)
}

db <- dbConnect(SQLite(), dbname= myDB)
datasets.available <- dbListTables(db)

# Close the connection
dbDisconnect(db)

datasets.available <- datasets.available[!grepl("_master", datasets.available)]
datasets.available <- datasets.available[!grepl("METADATA", datasets.available)]
datasets.available <- datasets.available[!grepl("VERSION", datasets.available)]
datasets.available <- datasets.available[!grepl("_[0-9]", datasets.available)]
datasets.available <- datasets.available[!grepl("TREE", datasets.available)]
datasets.available <- datasets.available[!grepl("STAND", datasets.available)]
datasets.available <- datasets.available[!grepl("SITES", datasets.available)]
datasets.available <- datasets.available[!datasets.available %in% dataset]

datasets.CO2 <- datasets.available[grepl("CO2", datasets.available)]
datasets.ISIMIP <- datasets.available[!grepl("CO2", datasets.available)]



db <- dbConnect(SQLite(), dbname=myDB)
sites <- dbGetQuery(db, "SELECT site_id FROM (SELECT DISTINCT site_id FROM SITESID_master)")
sites <- sites[,1]
sites <- sites[sites!=99]
dbDisconnect(db)

allSites  <- rep(NA, length(sites))
names(allSites) <- sites

for ( i in 1:length(sites)){
  queries <- rep(NA, length(dataset))
  names(queries) <- dataset
  
  db <- dbConnect(SQLite(), dbname=myDB)
  # SITES
  tmp <-paste("CREATE VIEW METADATA_SITES_", sites[i], " AS ",
              "SELECT  foo.variable AS variable, ",
              "bar.site AS site, ",
              "foo.site_id AS site_id, ",
              "foo.type AS type, ",
              "foo.units AS units, ",
              "foo.description AS description, ",
              "foo.comments AS comments, ",
              "spam.source AS source ",
              "FROM (SELECT variable, ",
              sites[i]," AS site_id, ", 
              "type, ",
              "units, ",
              "description, ",
              "NULL AS comments ",
              "FROM METADATA_SITES_master ",
              "UNION  SELECT ", 
              "variable ,",
              sites[i]," AS site_id, ",
              "type, ",
              "units, " ,
              "description, ",
              "NULL AS comments ",
              "FROM  METADATA_SITESID_master WHERE variable = 'site') AS foo ", 
              "INNER JOIN SITESID_master as bar ON foo.site_id = bar.site_id ",
              "INNER JOIN (SELECT ", sites[i]," AS site_id, source FROM SOURCE_master WHERE dataset='SITES') as spam ON foo.site_id = spam.site_id ",
              sep = "")
  
  
  queries["SITES"] <- tmp
  # SITES
  tmp <-paste("CREATE VIEW METADATA_SITEDESCRIPTION_", sites[i], " AS ",
              "SELECT  foo.variable AS variable, ",
              "bar.site AS site, ",
              "foo.site_id AS site_id, ",
              "foo.type AS type, ",
              "foo.units AS units, ",
              "foo.description AS description, ",
              "foo.comments AS comments, ",
              "spam.source AS source ",
              "FROM (SELECT variable, ",
              sites[i]," AS site_id, ", 
              "type, ",
              "units, ",
              "description, ",
              "NULL AS comments ",
              "FROM METADATA_SITEDESCRIPTION_master ",
              "UNION  SELECT ", 
              "variable ,",
              sites[i]," AS site_id, ",
              "type, ",
              "units, " ,
              "description, ",
              "NULL AS comments ",
              "FROM  METADATA_SITESID_master WHERE variable = 'site') AS foo ", 
              "INNER JOIN SITESID_master as bar ON foo.site_id = bar.site_id ",
              "INNER JOIN (SELECT ", sites[i]," AS site_id, source FROM SOURCE_master WHERE dataset='SITES') as spam ON foo.site_id = spam.site_id ",
              sep = "")
  queries["SITEDESCRIPTION"] <- tmp
  
  # TREE
  tmp <-paste("CREATE VIEW METADATA_TREE_", sites[i], " AS ",
              "SELECT foo.variable AS variable, ",
              "bar.site AS site, ",
              "foo.site_id AS site_id, ",
              "foo.type AS type, ",
              "foo.units AS units, ",
              "foo.description AS description, ",
              "foo.comments AS comments, ",
              "spam.source AS source ",
              "FROM (SELECT METADATA_TREE_SITES_master.variable, ",
              "METADATA_TREE_SITES_master.site_id, ",
              "METADATA_TREE_master.type, ",
              "METADATA_TREE_master.units, ",
              "METADATA_TREE_master.description, ",
              "METADATA_TREE_SITES_master.comments ",
              "FROM METADATA_TREE_SITES_master ",
              "INNER JOIN METADATA_TREE_master ON  METADATA_TREE_SITES_master.variable = METADATA_TREE_master.variable WHERE METADATA_TREE_SITES_master.site_id ='",
              sites[i],               
              "' UNION SELECT ",
              "variable ,",
              sites[i]," AS site_id, ",
              "type, ",
              "units, ", 
              "description, ",
              "NULL AS comments ",
              "FROM  METADATA_TREE_master WHERE variable = 'record_id' OR variable = 'site_id' ",
              "UNION SELECT ",
              "variable ,",
              sites[i]," AS site_id, ",
              "type, ",
              "units, ", 
              "description, ",
              "NULL AS comments ",
              "FROM  METADATA_TREESPECIES_master WHERE variable = 'species' ",
              "UNION SELECT ham.variable, ",
              "ham.site_id, ",
              "ham.type, ",
              "ham.units, ",
              "ham.description, ",
              "eggs.comments FROM ",
              "(SELECT variable , ",
              sites[i], " AS site_id, type, units, description FROM  METADATA_PLOTSIZE_master where variable='size_m2') AS ham ",
              " INNER JOIN (SELECT site_id, comments FROM METADATA_PLOTSIZE_SITES_master WHERE site_id ='",
              sites[i], "')AS eggs ON ham.site_id = eggs.site_id ",
              "UNION  SELECT ", 
              "variable ,",
              sites[i]," AS site_id, ",
              "type, ",
              "units, " ,
              "description, ",
              "NULL AS comments ",
              "FROM  METADATA_SITESID_master WHERE variable = 'site') AS foo ", 
              "INNER JOIN SITESID_master as bar ON foo.site_id = bar.site_id ",
              "INNER JOIN (SELECT site_id, source FROM SOURCE_SITES_master WHERE dataset='TREE') as spam ON foo.site_id = spam.site_id ",
              sep = "")
  
  ids <- dbGetQuery(db, "SELECT site_id FROM (SELECT DISTINCT site_id FROM METADATA_TREE_SITES_master)")
  if (sites[i] %in% ids[,1]){
    queries["TREE"] <- tmp
  }
  
  
  # STAND
  tmp <-paste("CREATE VIEW METADATA_STAND_", sites[i], " AS ",
              "SELECT foo.variable AS variable, ",
              "bar.site AS site, ",
              "foo.site_id AS site_id, ",
              "foo.type AS type, ",
              "foo.units AS units, ",
              "foo.description AS description, ",
              "foo.comments AS comments, ",
              "spam.source AS source ",
              "FROM (SELECT METADATA_STAND_SITES_master.variable, ",
              "METADATA_STAND_SITES_master.site_id, ",
              "METADATA_STAND_master.type, ",
              "METADATA_STAND_master.units, ",
              "METADATA_STAND_master.description, ",
              "METADATA_STAND_SITES_master.comments ",
              "FROM METADATA_STAND_SITES_master ",
              "INNER JOIN METADATA_STAND_master ON  METADATA_STAND_SITES_master.variable = METADATA_STAND_master.variable WHERE METADATA_STAND_SITES_master.site_id ='",
              sites[i],               
              "' UNION SELECT ",
              "variable ,",
              sites[i]," AS site_id, ",
              "type, ",
              "units, ", 
              "description, ",
              "NULL AS comments ",
              "FROM  METADATA_STAND_master WHERE variable = 'record_id' OR variable = 'site_id' ",
              "UNION SELECT ",
              "variable ,",
              sites[i]," AS site_id, ",
              "type, ",
              "units, ", 
              "description, ",
              "NULL AS comments ",
              "FROM  METADATA_TREESPECIES_master WHERE variable = 'species' ",
              "UNION  SELECT ", 
              "variable ,",
              sites[i]," AS site_id, ",
              "type, ",
              "units, " ,
              "description, ",
              "NULL AS comments ",
              "FROM  METADATA_SITESID_master WHERE variable = 'site') AS foo ", 
              "INNER JOIN SITESID_master as bar ON foo.site_id = bar.site_id ",
              "INNER JOIN (SELECT site_id, source FROM SOURCE_SITES_master WHERE dataset='STAND') as spam ON foo.site_id = spam.site_id ",
              sep = "")
  
  ids <- dbGetQuery(db, "SELECT site_id FROM (SELECT DISTINCT site_id FROM METADATA_STAND_SITES_master)")
  if (sites[i] %in% ids[,1]){
    queries["STAND"] <- tmp
  }
  
  
  # SOIL
  tmp <-paste("CREATE VIEW METADATA_SOIL_", sites[i], " AS ",
              "SELECT foo.variable AS variable, ",
              "bar.site AS site, ",
              "foo.site_id AS site_id, ",
              "foo.type AS type, ",
              "foo.units AS units, ",
              "foo.description AS description, ",
              "foo.comments AS comments, ",
              "spam.source AS source ",              
              "FROM (SELECT METADATA_SOIL_SITES_master.variable, ",
              "METADATA_SOIL_SITES_master.site_id, ",
              "METADATA_SOIL_master.type, ",
              "METADATA_SOIL_master.units, ",
              "METADATA_SOIL_master.description, ",
              "METADATA_SOIL_SITES_master.comments ",
              "FROM METADATA_SOIL_SITES_master ",
              "INNER JOIN METADATA_SOIL_master ON  METADATA_SOIL_SITES_master.variable = METADATA_SOIL_master.variable WHERE METADATA_SOIL_SITES_master.site_id ='",
              sites[i],
              "' UNION SELECT ",
              "variable ,",
              sites[i]," AS site_id, ",
              "type, ",
              "units, ", 
              "description, ",
              "NULL AS comments ",
              "FROM  METADATA_SOIL_master WHERE variable = 'record_id' OR variable = 'site_id' ",
              "UNION  SELECT ", 
              "variable ,",
              sites[i]," AS site_id, ",
              "type, ",
              "units, " ,
              "description, ",
              "NULL AS comments ",
              "FROM  METADATA_SITESID_master WHERE variable = 'site') AS foo ", 
              "INNER JOIN SITESID_master as bar ON foo.site_id = bar.site_id ",
              "INNER JOIN (SELECT site_id, source FROM SOURCE_SITES_master WHERE dataset='SOIL') as spam ON foo.site_id = spam.site_id ",
              sep = "")
  
  ids <- dbGetQuery(db, "SELECT site_id FROM (SELECT DISTINCT site_id FROM METADATA_SOIL_SITES_master)")
  if (sites[i] %in% ids[,1]){
    queries["SOIL"] <- tmp
  }
  
  
  # CLIMATE
  tmp <-paste("CREATE VIEW METADATA_CLIMATE_LOCAL_", sites[i], " AS ",
              "SELECT foo.variable AS variable, ",
              "bar.site AS site, ",
              "foo.site_id AS site_id, ",
              "foo.type AS type, ",
              "foo.units AS units, ",
              "foo.description AS description, ",
              "foo.comments AS comments, ",
              "spam.source AS source ",
              "FROM (SELECT METADATA_CLIMATE_LOCAL_SITES_master.variable, ",
              "METADATA_CLIMATE_LOCAL_SITES_master.site_id, ",
              "METADATA_CLIMATE_LOCAL_master.type, ",
              "METADATA_CLIMATE_LOCAL_master.units, ",
              "METADATA_CLIMATE_LOCAL_master.description, ",
              "METADATA_CLIMATE_LOCAL_SITES_master.comments ",
              "FROM METADATA_CLIMATE_LOCAL_SITES_master ",
              "INNER JOIN METADATA_CLIMATE_LOCAL_master ON  METADATA_CLIMATE_LOCAL_SITES_master.variable = METADATA_CLIMATE_LOCAL_master.variable WHERE METADATA_CLIMATE_LOCAL_SITES_master.site_id ='",
              sites[i],
              "' UNION SELECT ",
              "variable ,",
              sites[i]," AS site_id, ",
              "type, ",
              "units, ", 
              "description, ",
              "NULL AS comments ",
              "FROM  METADATA_CLIMATE_LOCAL_master WHERE variable = 'record_id' OR variable = 'site_id' ",
              "UNION  SELECT ", 
              "variable ,",
              sites[i]," AS site_id, ",
              "type, ",
              "units, " ,
              "description, ",
              "NULL AS comments ",
              "FROM  METADATA_SITESID_master WHERE variable = 'site') AS foo ", 
              "INNER JOIN SITESID_master as bar ON foo.site_id = bar.site_id ",
              "INNER JOIN (SELECT site_id, source FROM SOURCE_SITES_master WHERE dataset='CLIMATE_LOCAL') as spam ON foo.site_id = spam.site_id ",
              sep = "")
  ids <- dbGetQuery(db, "SELECT site_id FROM (SELECT DISTINCT site_id FROM METADATA_CLIMATE_LOCAL_SITES_master)")
  if (sites[i] %in% ids[,1]){
    queries["CLIMATE_LOCAL"] <- tmp
  }
  # CLIMATEFLUXNET
  tmp <-paste("CREATE VIEW METADATA_CLIMATE_LOCAL_", sites[i], " AS ",
              "SELECT  foo.variable AS variable, ",
              "bar.site AS site, ",
              "foo.site_id AS site_id, ",
              "foo.type AS type, ",
              "foo.units AS units, ",
              "foo.description AS description, ",
              "foo.comments AS comments, ",
              "spam.source AS source ",
              "FROM (SELECT variable, ",
              sites[i]," AS site_id, ", 
              "type, ",
              "units, ",
              "description, ",
              "comments ",
              "FROM METADATA_CLIMATEFLUXNET_master ",
              "UNION  SELECT ", 
              "variable ,",
              sites[i]," AS site_id, ",
              "type, ",
              "units, " ,
              "description, ",
              "NULL AS comments ",
              "FROM  METADATA_SITESID_master WHERE variable = 'site') AS foo ", 
              "INNER JOIN SITESID_master as bar ON foo.site_id = bar.site_id ",
              "INNER JOIN (SELECT ", sites[i]," AS site_id, source FROM SOURCE_master WHERE dataset='CLIMATEFLUXNET') as spam ON foo.site_id = spam.site_id ",
              sep = "")
  ids <- dbGetQuery(db, "SELECT site_id FROM (SELECT DISTINCT site_id FROM CLIMATEFLUXNET_master)")
  if (sites[i] %in% ids[,1]){
    queries["CLIMATE_LOCAL"] <- tmp
  }
  # CLIMATEFLUXNET_SITES
  tmp <-paste("CREATE VIEW METADATA_CLIMATE_LOCAL_", sites[i], " AS ",
              "SELECT foo.variable AS variable, ",
              "bar.site AS site, ",
              "foo.site_id AS site_id, ",
              "foo.type AS type, ",
              "foo.units AS units, ",
              "foo.description AS description, ",
              "foo.comments AS comments, ",
              "spam.source AS source ",
              "FROM (SELECT METADATA_CLIMATEFLUXNET_SITES_master.variable, ",
              "METADATA_CLIMATEFLUXNET_SITES_master.site_id, ",
              "METADATA_CLIMATEFLUXNET_master.type, ",
              "METADATA_CLIMATEFLUXNET_master.units, ",
              "METADATA_CLIMATEFLUXNET_master.description, ",
              "METADATA_CLIMATEFLUXNET_SITES_master.comments ",
              "FROM METADATA_CLIMATEFLUXNET_SITES_master ",
              "INNER JOIN METADATA_CLIMATEFLUXNET_master ON  METADATA_CLIMATEFLUXNET_SITES_master.variable = METADATA_CLIMATEFLUXNET_master.variable WHERE METADATA_CLIMATEFLUXNET_SITES_master.site_id ='",
              sites[i],
              "' UNION SELECT ",
              "variable ,",
              sites[i]," AS site_id, ",
              "type, ",
              "units, ", 
              "description, ",
              "comments ",
              "FROM  METADATA_CLIMATEFLUXNET_master WHERE variable = 'record_id' OR variable = 'site_id' ",
              "UNION  SELECT ", 
              "variable ,",
              sites[i]," AS site_id, ",
              "type, ",
              "units, " ,
              "description, ",
              "NULL AS comments ",
              "FROM  METADATA_SITESID_master WHERE variable = 'site') AS foo ", 
              "INNER JOIN SITESID_master as bar ON foo.site_id = bar.site_id ",
              "INNER JOIN (SELECT site_id, source FROM SOURCE_SITES_master WHERE dataset='CLIMATE_LOCAL') as spam ON foo.site_id = spam.site_id ",
              sep = "")
  ids <- dbGetQuery(db, "SELECT site_id FROM (SELECT DISTINCT site_id FROM METADATA_CLIMATEFLUXNET_SITES_master)")
  if (sites[i] %in% ids[,1]){
    queries["CLIMATE_LOCAL"] <- tmp
  }
  
  # NDEPOSITION_EMEP
  tmp <-paste("CREATE VIEW METADATA_NDEPOSITION_EMEP_", sites[i], " AS ",
              "SELECT  foo.variable AS variable, ",
              "bar.site AS site, ",
              "foo.site_id AS site_id, ",
              "foo.type AS type, ",
              "foo.units AS units, ",
              "foo.description AS description, ",
              "foo.comments AS comments ,",
              "spam.source AS source ",
              "FROM (SELECT variable, ",
              sites[i]," AS site_id, ",  
              "type, ",
              "units, ",
              "description, ",
              "NULL AS comments ",
              "FROM METADATA_NDEPOSITION_EMEP_master ",
              "UNION  SELECT ", 
              "variable ,",
              sites[i]," AS site_id, ",
              "type, ",
              "units, " ,
              "description, ",
              "NULL AS comments ",
              "FROM  METADATA_SITESID_master WHERE variable = 'site') AS foo ", 
              "INNER JOIN SITESID_master as bar ON foo.site_id = bar.site_id ",
              "INNER JOIN (SELECT ", sites[i]," AS site_id, source FROM SOURCE_master WHERE dataset='NDEPOSITION_EMEP') as spam ON foo.site_id = spam.site_id ",
              sep = "")
  ids <- dbGetQuery(db, "SELECT site_id FROM (SELECT DISTINCT site_id FROM  NDEPOSITION_EMEP_master)")
  if (sites[i] %in% ids[,1]){
    queries["NDEPOSITION_EMEP"] <- tmp
  }
  
  # NDEPOSITION_ISIMIP2B
  tmp <-paste("CREATE VIEW METADATA_NDEPOSITION_ISIMIP2B_", sites[i], " AS ",
              "SELECT  foo.variable AS variable, ",
              "bar.site AS site, ",
              "foo.site_id AS site_id, ",
              "foo.type AS type, ",
              "foo.units AS units, ",
              "foo.description AS description, ",
              "foo.comments AS comments, ",
              "spam.source AS source ",
              "FROM (SELECT variable, ",
              sites[i]," AS site_id, ",  
              "type, ",
              "units, ",
              "description, ",
              "NULL AS comments ",
              "FROM METADATA_NDEPOSITION_ISIMIP2B_master ",
              "UNION  SELECT ", 
              "variable ,",
              sites[i]," AS site_id, ",
              "type, ",
              "units, " ,
              "description, ",
              "NULL AS comments ",
              "FROM  METADATA_SITESID_master WHERE variable = 'site') AS foo ", 
              "INNER JOIN SITESID_master as bar ON foo.site_id = bar.site_id ",
              "INNER JOIN (SELECT ", sites[i]," AS site_id, source FROM SOURCE_master WHERE dataset='NDEPOSITION_ISIMIP2B') as spam ON foo.site_id = spam.site_id ",
              sep = "")
  ids <- dbGetQuery(db, "SELECT site_id FROM (SELECT DISTINCT site_id FROM  NDEPOSITION_ISIMIP2B_master)")
  if (sites[i] %in% ids[,1]){
    queries["NDEPOSITION_ISIMIP2B"] <- tmp
  }
  
  # CO2_ISIMIP
  tmp <-paste("CREATE VIEW METADATA_CO2_ISIMIP_", sites[i], " AS ",
              "SELECT  foo.variable AS variable, ",
              "bar.site AS site, ",
              sites[i]," AS site_id, ", 
              "foo.type AS type, ",
              "foo.units AS units, ",
              "foo.description AS description, ",
              "foo.comments AS comments, ",
              "spam.source AS source ",
              "FROM (SELECT variable, ",
              "site_id, ", 
              "type, ",
              "units, ",
              "description, ",
              "NULL AS comments ",
              "FROM METADATA_CO2_ISIMIP_master ",
              "UNION  SELECT ", 
              "variable ,",
              "site_id, ",
              "type, ",
              "units, " ,
              "description, ",
              "NULL AS comments ",
              "FROM  METADATA_SITESID_master WHERE variable = 'site') AS foo ", 
              "INNER JOIN SITESID_master as bar ON foo.site_id = bar.site_id ",
              "INNER JOIN (SELECT site_id, source FROM SOURCE_master WHERE dataset='CO2_ISIMIP') as spam ON foo.site_id = spam.site_id ",
              sep = "")
  queries["CO2_ISIMIP"] <- tmp
  
  
  # ISIMIP2A
  tmp <-paste("CREATE VIEW METADATA_CLIMATE_ISIMIP2A_", sites[i], " AS ",
              "SELECT  foo.variable AS variable, ",
              "bar.site AS site, ",
              "foo.site_id AS site_id, ",
              "foo.type AS type, ",
              "foo.units AS units, ",
              "foo.description AS description, ",
              "foo.comments AS comments, ",
              "spam.source AS source ",
              "FROM (SELECT variable, ",
              sites[i]," AS site_id, ", 
              "type, ",
              "units, ",
              "description, ",
              "NULL AS comments ",
              "FROM METADATA_CLIMATE_ISIMIP2A_master ",
              "UNION  SELECT ", 
              "variable ,",
              sites[i]," AS site_id, ",
              "type, ",
              "units, " ,
              "description, ",
              "NULL AS comments ",
              "FROM  METADATA_SITESID_master WHERE variable = 'site') AS foo ", 
              "INNER JOIN SITESID_master as bar ON foo.site_id = bar.site_id ",
              "INNER JOIN (SELECT ", sites[i]," AS site_id, source FROM SOURCE_master WHERE dataset='CLIMATE_ISIMIP2A') as spam ON foo.site_id = spam.site_id ",
              sep = "")
  ids <- dbGetQuery(db, "SELECT site_id FROM (SELECT DISTINCT site_id FROM CLIMATE_ISIMIP2A_master)")
  if (sites[i] %in% ids[,1]){
    queries["CLIMATE_ISIMIP2A"] <- tmp
    # DO ALL STUUF
#    for (j in 1:length(datasets.ISIMIP)){
#      datasets.ISIMIP[j]
#      tmp.isimip <- gsub("VIEW METADATA_CLIMATE_ISIMIP_", paste("VIEW METADATA_", datasets.ISIMIP[j],"_",  sep=""),
    #                         tmp)
    #      queries[datasets.ISIMIP[j]] <- tmp.isimip
      
    #    }
  }
  # ISIMIP2B
  tmp <-paste("CREATE VIEW METADATA_CLIMATE_ISIMIP2B_", sites[i], " AS ",
              "SELECT  foo.variable AS variable, ",
              "bar.site AS site, ",
              "foo.site_id AS site_id, ",
              "foo.type AS type, ",
              "foo.units AS units, ",
              "foo.description AS description, ",
              "foo.comments AS comments, ",
              "spam.source AS source ",
              "FROM (SELECT variable, ",
              sites[i]," AS site_id, ", 
              "type, ",
              "units, ",
              "description, ",
              "NULL AS comments ",
              "FROM METADATA_CLIMATE_ISIMIP2B_master ",
              "UNION  SELECT ", 
              "variable ,",
              sites[i]," AS site_id, ",
              "type, ",
              "units, " ,
              "description, ",
              "NULL AS comments ",
              "FROM  METADATA_SITESID_master WHERE variable = 'site') AS foo ", 
              "INNER JOIN SITESID_master as bar ON foo.site_id = bar.site_id ",
              "INNER JOIN (SELECT ", sites[i]," AS site_id, source FROM SOURCE_master WHERE dataset='CLIMATE_ISIMIP2B') as spam ON foo.site_id = spam.site_id ",
              sep = "")
  ids <- dbGetQuery(db, "SELECT site_id FROM (SELECT DISTINCT site_id FROM CLIMATE_ISIMIP2B_master)")
  if (sites[i] %in% ids[,1]){
    queries["CLIMATE_ISIMIP2B"] <- tmp
  }
  # ISIMIP2BLC
  tmp <-paste("CREATE VIEW METADATA_CLIMATE_ISIMIP2BLBC_", sites[i], " AS ",
              "SELECT  foo.variable AS variable, ",
              "bar.site AS site, ",
              "foo.site_id AS site_id, ",
              "foo.type AS type, ",
              "foo.units AS units, ",
              "foo.description AS description, ",
              "foo.comments AS comments, ",
              "spam.source AS source ",
              "FROM (SELECT variable, ",
              sites[i]," AS site_id, ", 
              "type, ",
              "units, ",
              "description, ",
              "NULL AS comments ",
              "FROM METADATA_CLIMATE_ISIMIP2BLBC_master ",
              "UNION  SELECT ", 
              "variable ,",
              sites[i]," AS site_id, ",
              "type, ",
              "units, " ,
              "description, ",
              "NULL AS comments ",
              "FROM  METADATA_SITESID_master WHERE variable = 'site') AS foo ", 
              "INNER JOIN SITESID_master as bar ON foo.site_id = bar.site_id ",
              "INNER JOIN (SELECT ", sites[i]," AS site_id, source FROM SOURCE_master WHERE dataset='CLIMATE_ISIMIP2BLBC') as spam ON foo.site_id = spam.site_id ",
              sep = "")
  ids <- dbGetQuery(db, "SELECT site_id FROM (SELECT DISTINCT site_id FROM CLIMATE_ISIMIP2BLBC_master)")
  if (sites[i] %in% ids[,1]){
    queries["CLIMATE_ISIMIP2BLBC"] <- tmp
  }  
  # ISIMIPFT
  tmp <-paste("CREATE VIEW METADATA_CLIMATE_ISIMIPFT_", sites[i], " AS ",
              "SELECT  foo.variable AS variable, ",
              "bar.site AS site, ",
              "foo.site_id AS site_id, ",
              "foo.type AS type, ",
              "foo.units AS units, ",
              "foo.description AS description, ",
              "foo.comments AS comments, ",
              "spam.source AS source ",
              "FROM (SELECT variable, ",
              sites[i]," AS site_id, ", 
              "type, ",
              "units, ",
              "description, ",
              "NULL AS comments ",
              "FROM METADATA_CLIMATE_ISIMIPFT_master ",
              "UNION  SELECT ", 
              "variable ,",
              sites[i]," AS site_id, ",
              "type, ",
              "units, " ,
              "description, ",
              "NULL AS comments ",
              "FROM  METADATA_SITESID_master WHERE variable = 'site') AS foo ", 
              "INNER JOIN SITESID_master as bar ON foo.site_id = bar.site_id ",
              "INNER JOIN (SELECT ", sites[i]," AS site_id, source FROM SOURCE_master WHERE dataset='CLIMATE_ISIMIPFT') as spam ON foo.site_id = spam.site_id ",
              sep = "")
  ids <- dbGetQuery(db, "SELECT site_id FROM (SELECT DISTINCT site_id FROM CLIMATE_ISIMIPFT_master)")
  if (sites[i] %in% ids[,1]){
    queries["CLIMATE_ISIMIPFT"] <- tmp
  }
  
  
  
  # FLUXNET
  tmp <-paste("CREATE VIEW METADATA_FLUXNET_", sites[i], " AS ",
              "SELECT  foo.variable AS variable, ",
              "bar.site AS site, ",
              "foo.site_id AS site_id, ",
              "foo.type AS type, ",
              "foo.units AS units, ",
              "foo.description AS description, ",
              "foo.comments AS comments, ",
              "spam.source AS source ",
              "FROM (SELECT variable, ",
              sites[i]," AS site_id, ", 
              "type, ",
              "units, ",
              "description, ",
              "NULL AS comments ",
              "FROM METADATA_FLUXNET_master ",
              "UNION  SELECT ", 
              "variable ,",
              sites[i]," AS site_id, ",
              "type, ",
              "units, " ,
              "description, ",
              "NULL AS comments ",
              "FROM  METADATA_SITESID_master WHERE variable = 'site') AS foo ", 
              "INNER JOIN SITESID_master as bar ON foo.site_id = bar.site_id ",
              "INNER JOIN (SELECT ", sites[i]," AS site_id, source FROM SOURCE_master WHERE dataset='FLUXNET') as spam ON foo.site_id = spam.site_id ",
              sep = "") 
#  ids <- dbGetQuery(db, "SELECT site_id FROM (SELECT DISTINCT site_id FROM FLUXNET_master)")
#    if (sites[i] %in% ids[,1]){
#      queries["FLUXNET"] <- tmp
#  }
  
  
  # ATMOSPHERICHEATCONDUCTION
  tmp <-paste("CREATE VIEW METADATA_ATMOSPHERICHEATCONDUCTION_", sites[i], " AS ",
              "SELECT  foo.variable AS variable, ",
              "bar.site AS site, ",
              "foo.site_id AS site_id, ",
              "foo.type AS type, ",
              "foo.units AS units, ",
              "foo.description AS description, ",
              "foo.comments AS comments, ",
              "spam.source AS source ",
              "FROM (SELECT variable, ",
              sites[i]," AS site_id, ", 
              "type, ",
              "units, ",
              "description, ",
              "NULL AS comments ",
              "FROM METADATA_FLUXNET_master WHERE dataset='FLUXNET' OR dataset='ATMOSPHERICHEATCONDUCTION' ",
              "UNION  SELECT ", 
              "variable ,",
              sites[i]," AS site_id, ",
              "type, ",
              "units, " ,
              "description, ",
              "NULL AS comments ",
              "FROM  METADATA_SITESID_master WHERE variable = 'site') AS foo ", 
              "INNER JOIN SITESID_master as bar ON foo.site_id = bar.site_id ",
              "INNER JOIN (SELECT ", sites[i]," AS site_id, source FROM SOURCE_master WHERE dataset='FLUXNET') as spam ON foo.site_id = spam.site_id ",
              sep = "")
  ids <- dbGetQuery(db, "SELECT site_id FROM (SELECT DISTINCT site_id FROM FLUXNET_master)")
  if (sites[i] %in% ids[,1]){
    queries["ATMOSPHERICHEATCONDUCTION"] <- tmp
  }
  
  # FLUX
  tmp <-paste("CREATE VIEW METADATA_FLUX_", sites[i], " AS ",
              "SELECT  foo.variable AS variable, ",
              "bar.site AS site, ",
              "foo.site_id AS site_id, ",
              "foo.type AS type, ",
              "foo.units AS units, ",
              "foo.description AS description, ",
              "foo.comments AS comments, ",
              "spam.source AS source ",
              "FROM (SELECT variable, ",
              sites[i]," AS site_id, ", 
              "type, ",
              "units, ",
              "description, ",
              "NULL AS comments ",
              "FROM METADATA_FLUXNET_master WHERE dataset='FLUXNET' OR dataset='FLUX' ",
              "UNION  SELECT ", 
              "variable ,",
              sites[i]," AS site_id, ",
              "type, ",
              "units, " ,
              "description, ",
              "NULL AS comments ",
              "FROM  METADATA_SITESID_master WHERE variable = 'site') AS foo ", 
              "INNER JOIN SITESID_master as bar ON foo.site_id = bar.site_id ",
              "INNER JOIN (SELECT ", sites[i]," AS site_id, source FROM SOURCE_master WHERE dataset='FLUX') as spam ON foo.site_id = spam.site_id ",
              sep = "")
  ids <- dbGetQuery(db, "SELECT site_id FROM (SELECT DISTINCT site_id FROM FLUXNET_master)")
  if (sites[i] %in% ids[,1]){
    queries["FLUX"] <- tmp
  }
  
  # SOILTS
  tmp <-paste("CREATE VIEW METADATA_SOILTS_", sites[i], " AS ",
              "SELECT  foo.variable AS variable, ",
              "bar.site AS site, ",
              "foo.site_id AS site_id, ",
              "foo.type AS type, ",
              "foo.units AS units, ",
              "foo.description AS description, ",
              "foo.comments AS comments, ",
              "spam.source AS source ",
              "FROM (SELECT variable, ",
              sites[i]," AS site_id, ", 
              "type, ",
              "units, ",
              "description, ",
              "NULL AS comments ",
              "FROM METADATA_FLUXNET_master WHERE dataset='FLUXNET' OR dataset='SOILTS' ",
              "UNION  SELECT ", 
              "variable ,",
              sites[i]," AS site_id, ",
              "type, ",
              "units, " ,
              "description, ",
              "NULL AS comments ",
              "FROM  METADATA_SITESID_master WHERE variable = 'site') AS foo ", 
              "INNER JOIN SITESID_master as bar ON foo.site_id = bar.site_id ",
              "INNER JOIN (SELECT ", sites[i]," AS site_id, source FROM SOURCE_master WHERE dataset='SOILTS') as spam ON foo.site_id = spam.site_id ",
              sep = "")
  
  ids <- dbGetQuery(db, "SELECT site_id FROM (SELECT DISTINCT site_id FROM FLUXNET_master)")
  if (sites[i] %in% ids[,1]){
    queries["SOILTS"] <- tmp
  }
  
  # METEREOLOGICAL
  tmp <-paste("CREATE VIEW METADATA_METEOROLOGICAL_", sites[i], " AS ",
              "SELECT  foo.variable AS variable, ",
              "bar.site AS site, ",
              "foo.site_id AS site_id, ",
              "foo.type AS type, ",
              "foo.units AS units, ",
              "foo.description AS description, ",
              "foo.comments AS comments, ",
              "spam.source AS source ",
              "FROM (SELECT variable, ",
              sites[i]," AS site_id, ", 
              "type, ",
              "units, ",
              "description, ",
              "NULL AS comments ",
              "FROM METADATA_FLUXNET_master WHERE dataset='FLUXNET' OR dataset='METEOROLOGICAL' ",
              "UNION  SELECT ", 
              "variable ,",
              sites[i]," AS site_id, ",
              "type, ",
              "units, " ,
              "description, ",
              "NULL AS comments ",
              "FROM  METADATA_SITESID_master WHERE variable = 'site') AS foo ", 
              "INNER JOIN SITESID_master as bar ON foo.site_id = bar.site_id ",
              "INNER JOIN (SELECT ", sites[i]," AS site_id, source FROM SOURCE_master WHERE dataset='METEOROLOGICAL') as spam ON foo.site_id = spam.site_id ",
              sep = "")
  ids <- dbGetQuery(db, "SELECT site_id FROM (SELECT DISTINCT site_id FROM FLUXNET_master)")
  if (sites[i] %in% ids[,1]){
    queries["METEOROLOGICAL"] <- tmp
  }
  
  # MODIS_MOD09A1
  tmp <-paste("CREATE VIEW METADATA_MODIS_MOD09A1_", sites[i], " AS ",
              "SELECT  foo.variable AS variable, ",
              "bar.site AS site, ",
              "foo.site_id AS site_id, ",
              "foo.type AS type, ",
              "foo.units AS units, ",
              "foo.description AS description, ",
              "foo.comments AS comments, ",
              "spam.source AS source ",
              "FROM (SELECT variable, ",
              sites[i]," AS site_id, ", 
              "type, ",
              "units, ",
              "description, ",
              "comments ",
              "FROM METADATA_MODIS_MOD09A1_master ",
              "UNION  SELECT ", 
              "variable ,",
              sites[i]," AS site_id, ",
              "type, ",
              "units, " ,
              "description, ",
              "NULL AS comments ",
              "FROM  METADATA_SITESID_master WHERE variable = 'site') AS foo ", 
              "INNER JOIN SITESID_master as bar ON foo.site_id = bar.site_id ",
              "INNER JOIN (SELECT ", sites[i]," AS site_id, source FROM SOURCE_master WHERE dataset='MODIS_MOD09A1') as spam ON foo.site_id = spam.site_id ",
              sep = "")
  ids <- dbGetQuery(db, "SELECT site_id FROM (SELECT DISTINCT site_id FROM MODIS_MOD09A1_master)")
  if (sites[i] %in% ids[,1]){
    queries["MODIS_MOD09A1"] <- tmp
  }
  # MODIS_MOD11A2
  tmp <-paste("CREATE VIEW METADATA_MODIS_MOD11A2_", sites[i], " AS ",
              "SELECT  foo.variable AS variable, ",
              "bar.site AS site, ",
              "foo.site_id AS site_id, ",
              "foo.type AS type, ",
              "foo.units AS units, ",
              "foo.description AS description, ",
              "foo.comments AS comments, ",
              "spam.source AS source ",
              "FROM (SELECT variable, ",
              sites[i]," AS site_id, ", 
              "type, ",
              "units, ",
              "description, ",
              "comments ",
              "FROM METADATA_MODIS_MOD11A2_master ",
              "UNION  SELECT ", 
              "variable ,",
              sites[i]," AS site_id, ",
              "type, ",
              "units, " ,
              "description, ",
              "NULL AS comments ",
              "FROM  METADATA_SITESID_master WHERE variable = 'site') AS foo ", 
              "INNER JOIN SITESID_master as bar ON foo.site_id = bar.site_id ",
              "INNER JOIN (SELECT ", sites[i]," AS site_id, source FROM SOURCE_master WHERE dataset='MODIS_MOD11A2') as spam ON foo.site_id = spam.site_id ",
              sep = "")
  ids <- dbGetQuery(db, "SELECT site_id FROM (SELECT DISTINCT site_id FROM MODIS_MOD11A2_master)")
  if (sites[i] %in% ids[,1]){
    queries["MODIS_MOD11A2"] <- tmp
  }
  # MODIS_MOD13Q1
  tmp <-paste("CREATE VIEW METADATA_MODIS_MOD13Q1_", sites[i], " AS ",
              "SELECT  foo.variable AS variable, ",
              "bar.site AS site, ",
              "foo.site_id AS site_id, ",
              "foo.type AS type, ",
              "foo.units AS units, ",
              "foo.description AS description, ",
              "foo.comments AS comments, ",
              "spam.source AS source ",
              "FROM (SELECT variable, ",
              sites[i]," AS site_id, ", 
              "type, ",
              "units, ",
              "description, ",
              "comments ",
              "FROM METADATA_MODIS_MOD13Q1_master ",
              "UNION  SELECT ", 
              "variable ,",
              sites[i]," AS site_id, ",
              "type, ",
              "units, " ,
              "description, ",
              "NULL AS comments ",
              "FROM  METADATA_SITESID_master WHERE variable = 'site') AS foo ", 
              "INNER JOIN SITESID_master as bar ON foo.site_id = bar.site_id ",
              "INNER JOIN (SELECT ", sites[i]," AS site_id, source FROM SOURCE_master WHERE dataset='MODIS_MOD13Q1') as spam ON foo.site_id = spam.site_id ",
              sep = "")
  ids <- dbGetQuery(db, "SELECT site_id FROM (SELECT DISTINCT site_id FROM MODIS_MOD13Q1_master)")
  if (sites[i] %in% ids[,1]){
    queries["MODIS_MOD13Q1"] <- tmp
  }
  # MODIS_MOD15A2
  tmp <-paste("CREATE VIEW METADATA_MODIS_MOD15A2_", sites[i], " AS ",
              "SELECT  foo.variable AS variable, ",
              "bar.site AS site, ",
              "foo.site_id AS site_id, ",
              "foo.type AS type, ",
              "foo.units AS units, ",
              "foo.description AS description, ",
              "foo.comments AS comments, ",
              "spam.source AS source ",
              "FROM (SELECT variable, ",
              sites[i]," AS site_id, ", 
              "type, ",
              "units, ",
              "description, ",
              "comments ",
              "FROM METADATA_MODIS_MOD15A2_master ",
              "UNION  SELECT ", 
              "variable ,",
              sites[i]," AS site_id, ",
              "type, ",
              "units, " ,
              "description, ",
              "NULL AS comments ",
              "FROM  METADATA_SITESID_master WHERE variable = 'site') AS foo ", 
              "INNER JOIN SITESID_master as bar ON foo.site_id = bar.site_id ",
              "INNER JOIN (SELECT ", sites[i]," AS site_id, source FROM SOURCE_master WHERE dataset='MODIS_MOD15A2') as spam ON foo.site_id = spam.site_id ",
              sep = "")
  ids <- dbGetQuery(db, "SELECT site_id FROM (SELECT DISTINCT site_id FROM MODIS_MOD15A2_master)")
  if (sites[i] %in% ids[,1]){
    queries["MODIS_MOD15A2"] <- tmp
  }
  # MODIS_MOD17A2
  tmp <-paste("CREATE VIEW METADATA_MODIS_MOD17A2_", sites[i], " AS ",
              "SELECT  foo.variable AS variable, ",
              "bar.site AS site, ",
              "foo.site_id AS site_id, ",
              "foo.type AS type, ",
              "foo.units AS units, ",
              "foo.description AS description, ",
              "foo.comments AS comments, ",
              "spam.source AS source ",
              "FROM (SELECT variable, ",
              sites[i]," AS site_id, ", 
              "type, ",
              "units, ",
              "description, ",
              "comments ",
              "FROM METADATA_MODIS_MOD17A2_master ",
              "UNION  SELECT ", 
              "variable ,",
              sites[i]," AS site_id, ",
              "type, ",
              "units, " ,
              "description, ",
              "NULL AS comments ",
              "FROM  METADATA_SITESID_master WHERE variable = 'site') AS foo ", 
              "INNER JOIN SITESID_master as bar ON foo.site_id = bar.site_id ",
              "INNER JOIN (SELECT ", sites[i]," AS site_id, source FROM SOURCE_master WHERE dataset='MODIS_MOD17A2') as spam ON foo.site_id = spam.site_id ",
              sep = "")
  ids <- dbGetQuery(db, "SELECT site_id FROM (SELECT DISTINCT site_id FROM MODIS_MOD17A2_master)")
  if (sites[i] %in% ids[,1]){
    queries["MODIS_MOD17A2"] <- tmp
  }
  # MODIS8
  tmp <-paste("CREATE VIEW METADATA_MODIS8_", sites[i], " AS ",
              "SELECT monty.variable AS variable, ",
              "python.site AS site, ",
              "monty.site_id AS site_id, ",
              "monty.type AS type, ",
              "monty.units AS units, ",
              "monty.description AS description, ",
              "monty.comments AS comments, ",
              "monty.source AS source FROM ( ",
              "SELECT foo.variable, ",
              "foo.site_id, ",
              "foo.type, ",
              "foo.units, ",
              "foo.description, ",
              "foo.comments, ",
              "bar.source ",
              " FROM ",
              "(SELECT variable, ",
              sites[i], " AS site_id, ",
              "type, ",
              "units, ",
              "description, ",
              "NULL AS comments FROM METADATA_MODIS_MOD17A2_master) AS foo ",
              "INNER JOIN ",
              "(SELECT ", sites[i], " AS site_id, source FROM SOURCE_master WHERE dataset='MODIS_MOD17A2')  AS bar ",
              "ON foo.site_id = bar.site_id ",
              "UNION ",
              "SELECT spam.variable, ",
              "spam.site_id, ",
              "spam.type, ",
              "spam.units, ",
              "spam.description, ",
              "spam.comments, ",
              "ham.source ",
              " FROM ",
              "(SELECT variable, ",
              sites[i], " AS site_id, ",
              "type, ",
              "units, ",
              "description, ",
              "NULL AS comments FROM METADATA_MODIS_MOD09A1_master) AS spam ",
              "INNER JOIN ",
              "(SELECT ", sites[i], " AS site_id, source FROM SOURCE_master WHERE dataset='MODIS_MOD09A1')  AS ham ", 
              "ON spam.site_id = ham.site_id ",
              "UNION ",
              "SELECT eggs.variable, ",
              "eggs.site_id, ",
              "eggs.type, ",
              "eggs.units, ",
              "eggs.description, ",
              "eggs.comments, ",
              "foobar.source ",
              "FROM ",
              "(SELECT variable, ",
              sites[i], " AS site_id, ",
              "type, ",
              "units, ",
              "description, ",
              "NULL AS comments FROM METADATA_MODIS_MOD11A2_master) AS eggs ",
              "INNER JOIN ",
              "(SELECT ", sites[i], " AS site_id,  source FROM SOURCE_master WHERE dataset='MODIS_MOD11A2')  AS foobar  ",
              "ON eggs.site_id = foobar.site_id ",
              "UNION ",
              "SELECT fooham.variable, ",
              "fooham.site_id, ",
              "fooham.type, ",
              "fooham.units, ",
              "fooham.description, ",
              "fooham.comments, ",
              "fooeggs.source ",
              "FROM ",
              "(SELECT variable, ",
              sites[i], " AS site_id, ",
              "type, ",
              "units, ",
              "description, ",
              "NULL AS comments FROM METADATA_MODIS_MOD15A2_master) AS fooham ",
              "INNER JOIN ",
              "(SELECT ", sites[i], " AS site_id, source FROM SOURCE_master WHERE dataset='MODIS_MOD15A2')  AS fooeggs ",
              "ON fooham.site_id = fooeggs.site_id ",
              ") AS monty ",
              "INNER JOIN (SELECT site, site_id FROM SITESID_master) as python ON  monty.site_id = python.site_id ",
              sep = "")
  ids <- dbGetQuery(db, "SELECT site_id FROM (SELECT DISTINCT site_id FROM MODIS_MOD17A2_master)")
#  if (sites[i] %in% ids[,1]){    queries["MODIS8"] <- tmp  }
  # MODIS16
  tmp <-paste("CREATE VIEW METADATA_MODIS16_", sites[i], " AS ",
              "SELECT  foo.variable AS variable, ",
              "bar.site AS site, ",
              "foo.site_id AS site_id, ",
              "foo.type AS type, ",
              "foo.units AS units, ",
              "foo.description AS description, ",
              "foo.comments AS comments, ",
              "spam.source AS source ",
              "FROM (SELECT variable, ",
              sites[i]," AS site_id, ", 
              "type, ",
              "units, ",
              "description, ",
              "NULL AS comments ",
              "FROM METADATA_MODIS_MOD13Q1_master ",
              "UNION  SELECT ", 
              "variable ,",
              sites[i]," AS site_id, ",
              "type, ",
              "units, " ,
              "description, ",
              "NULL AS comments ",
              "FROM  METADATA_SITESID_master WHERE variable = 'site') AS foo ", 
              "INNER JOIN SITESID_master as bar ON foo.site_id = bar.site_id ",
              "INNER JOIN (SELECT ", sites[i]," AS site_id, source FROM SOURCE_master WHERE dataset='MODIS_MOD13Q1') as spam ON foo.site_id = spam.site_id ",
              sep = "")
  ids <- dbGetQuery(db, "SELECT site_id FROM (SELECT DISTINCT site_id FROM MODIS_MOD13Q1_master)")
 # if (sites[i] %in% ids[,1]){   queries["MODIS16"] <- tmp  }
  
  # MODIS
  tmp <-paste("CREATE VIEW METADATA_MODIS_", sites[i], " AS ",
              "SELECT monty.variable AS variable, ",
              "python.site AS site, ",
              "monty.site_id AS site_id, ",
              "monty.type AS type, ",
              "monty.units AS units, ",
              "monty.description AS description, ",
              "monty.comments AS comments, ",
              "monty.source AS source FROM ( ",
              "SELECT foo.variable, ",
              "foo.site_id, ",
              "foo.type, ",
              "foo.units, ",
              "foo.description, ",
              "foo.comments, ",
              "bar.source ",
              " FROM ",
              "(SELECT variable, ",
              sites[i], " AS site_id, ",
              "type, ",
              "units, ",
              "description, ",
              "comments FROM METADATA_MODIS_MOD17A2_master) AS foo ",
              "INNER JOIN ",
              "(SELECT ", sites[i], " AS site_id, source FROM SOURCE_master WHERE dataset='MODIS_MOD17A2')  AS bar ",
              "ON foo.site_id = bar.site_id ",
              "UNION ",
              "SELECT spam.variable, ",
              "spam.site_id, ",
              "spam.type, ",
              "spam.units, ",
              "spam.description, ",
              "spam.comments, ",
              "ham.source ",
              " FROM ",
              "(SELECT variable, ",
              sites[i], " AS site_id, ",
              "type, ",
              "units, ",
              "description, ",
              "comments FROM METADATA_MODIS_MOD09A1_master) AS spam ",
              "INNER JOIN ",
              "(SELECT ", sites[i], " AS site_id, source FROM SOURCE_master WHERE dataset='MODIS_MOD09A1')  AS ham ", 
              "ON spam.site_id = ham.site_id ",
              "UNION ",
              "SELECT eggs.variable, ",
              "eggs.site_id, ",
              "eggs.type, ",
              "eggs.units, ",
              "eggs.description, ",
              "eggs.comments, ",
              "foobar.source ",
              "FROM ",
              "(SELECT variable, ",
              sites[i], " AS site_id, ",
              "type, ",
              "units, ",
              "description, ",
              "comments FROM METADATA_MODIS_MOD11A2_master) AS eggs ",
              "INNER JOIN ",
              "(SELECT ", sites[i], " AS site_id,  source FROM SOURCE_master WHERE dataset='MODIS_MOD11A2')  AS foobar  ",
              "ON eggs.site_id = foobar.site_id ",
              "UNION ",
              "SELECT foofoo.variable, ",
              "foofoo.site_id, ",
              "foofoo.type, ",
              "foofoo.units, ",
              "foofoo.description, ",
              "foofoo.comments, ",
              "foospam.source ",
              "FROM ",
              "(SELECT variable, ",
              sites[i], " AS site_id, ",
              "type, ",
              "units, ",
              "description, ",
              "comments FROM METADATA_MODIS_MOD13Q1_master) AS foofoo ",
              "INNER JOIN ",
              "(SELECT ", sites[i], " AS site_id, source FROM SOURCE_master WHERE dataset='MODIS_MOD13Q1')  AS foospam  ",
              "ON foofoo.site_id = foospam.site_id ",
              "UNION ",
              "SELECT fooham.variable, ",
              "fooham.site_id, ",
              "fooham.type, ",
              "fooham.units, ",
              "fooham.description, ",
              "fooham.comments, ",
              "fooeggs.source ",
              "FROM ",
              "(SELECT variable, ",
              sites[i], " AS site_id, ",
              "type, ",
              "units, ",
              "description, ",
              "comments FROM METADATA_MODIS_MOD15A2_master) AS fooham ",
              "INNER JOIN ",
              "(SELECT ", sites[i], " AS site_id, source FROM SOURCE_master WHERE dataset='MODIS_MOD15A2')  AS fooeggs ",
              "ON fooham.site_id = fooeggs.site_id ",
              ") AS monty ",
              "INNER JOIN (SELECT site, site_id FROM SITESID_master) as python ON  monty.site_id = python.site_id ",
              sep = "")
  ids <- dbGetQuery(db, "SELECT site_id FROM (SELECT DISTINCT site_id FROM MODIS_MOD17A2_master)")
  if (sites[i] %in% ids[,1]){
    queries["MODIS"] <- tmp
  }
  
  
  
  
  dbDisconnect(db)
  queries <- queries[!is.na(queries)]
  
  db <- dbConnect(SQLite(), dbname=myDB)
  sapply(1:length(queries), FUN = function(x){
    if(paste("METADATA_", names(queries)[x],"_", sites[i], sep="") %in% dbListTables(db)) dbGetQuery(db, paste("DROP VIEW METADATA_", names(queries)[x],"_", sites[i], sep = ""))
    dbGetQuery(db,queries[x])
  } )
  
  queries <- queries[!names(queries) %in% c("MODIS")]

  dbDisconnect(db)
  
  query <- gsubMetadata(queries)
  query <- paste(query, collapse = " UNION ")
  
  allSites[i] <- query
  begin <- paste("CREATE VIEW METADATA_", sites[i], " AS", sep ="")
  
  querySite <- paste(begin,  query, sep = "")
  
  db <- dbConnect(SQLite(), dbname=myDB)
  if(paste("METADATA_",sites[i],sep="") %in% dbListTables(db)) dbGetQuery(db, paste("DROP VIEW METADATA_",sites[i],sep=""))
  dbGetQuery(db,querySite) 
  dbDisconnect(db)
}


#query <- paste(allSites, collapse = " UNION ")
#query <- paste("CREATE VIEW METADATA AS ", query, sep = "")

#db <- dbConnect(SQLite(), dbname=myDB)
#dbGetQuery(db,query) 
#dbDisconnect(db)



