#------------------------------------------------------------------------------#
#                         SOURCE
#
#------------------------------------------------------------------------------#
# Load libraries
library(sqldf)
library(DBI)
library(RSQLite)

#------------------------------------------------------------------------------#
#               ENTER DATA IN THE TABLE


db <- dbConnect(SQLite(), dbname=myDB)
if ( "SOURCE" %in% dbListTables(db)){
  dbSendQuery(db, "DROP VIEW SOURCE")
}

dbGetQuery(db, "CREATE VIEW SOURCE AS SELECT
            SOURCE_master.dataset,
            SOURCE_master.source,
            SOURCE_master.reference,
            SOURCE_master.comments
            FROM SOURCE_master INNER JOIN SITESID_master ON SOURCE_master.site_id = SITESID_master.site_id WHERE SOURCE_master.dataset != 'CLIMATEFLUXNET' ")
dbDisconnect(db)


dataset <- c("SITES", "TREE", "STAND", "SOIL", "CLIMATE_LOCAL",
             "FLUX", "ENERGYBALANCE", "SOILTS", "NDEPOSITION_EMEP",
             "NDEPOSITION_ISIMIP2B", "CO2_ISIMIP",  "CLIMATE_ISIMIP2B", "CLIMATE_ISIMIP2A",
             "CLIMATE_ISIMIPFT",  "MODIS8", "MODIS16")

db <- dbConnect(SQLite(), dbname=myDB)
sites <- dbGetQuery(db, "SELECT site_id FROM (SELECT DISTINCT site_id FROM SITESID_master)")
sites <- sites[,1]
sites <- sites[sites!=99]
dbDisconnect(db)
allSites  <- rep(NA, length(sites))
names(allSites) <- sites

dataset.all <-  c("SITES", "NDEPOSITION_EMEP", "NDEPOSITION_ISIMIP2B", "CO2_ISIMIP",
                  "CLIMATE_ISIMIP2B","CLIMATE_ISIMIP2BLBC", "CLIMATE_ISIMIP2A",
                  "CLIMATE_ISIMIPFT",  "MODIS8", "MODIS16")
dataset.sites <- c( "TREE", "STAND", "SOIL", "CLIMATE_LOCAL")
dataset.fluxnet <-c("FLUX", "ENERGYBALANCE", "SOILTS", "METEOROLOGICAL")

dummy.sites <- paste("SELECT bar.site AS site, spam.site_id AS site_id, spam.dataset AS dataset, ",
                     "spam.source AS source, spam.reference AS reference, spam.comments AS comments ",
                     "FROM (SELECT site_id, dataset, source, reference, comments FROM SOURCE_SITES_master WHERE dataset='_dataset_' AND site_id = '_site_id_') AS spam ",
                     "INNER JOIN SITESID_master as bar ON spam.site_id = bar.site_id ",sep = "")

dummy.all <- paste("SELECT bar.site AS site, spam.site_id AS site_id, spam.dataset AS dataset, ",
                   "spam.source AS source, spam.reference AS reference, spam.comments AS comments ",
                   "FROM (SELECT _site_id_ AS site_id, dataset, source, reference, comments FROM SOURCE_master WHERE dataset='_dataset_') AS spam ",
                   "INNER JOIN SITESID_master as bar ON spam.site_id = bar.site_id ", sep = "")


queries.sites <- sapply(dataset.sites, function(x) gsub("_dataset_",x,  dummy.sites))
queries.all <- sapply(dataset.all, function(x) gsub("_dataset_",x,  dummy.all))
queries.fluxnet <-  sapply(dataset.fluxnet, function(x) gsub("_dataset_",x,  dummy.all))

for ( i in 1:length(sites)){
  
  db <- dbConnect(SQLite(), dbname=myDB)
  ids <- dbGetQuery(db, "SELECT site_id FROM (SELECT DISTINCT site_id FROM FLUXNET_master)")
  if (sites[i] %in% ids[,1]){
    queries <- c(queries.sites, queries.fluxnet, queries.all) 
  }else{
    queries <- c(queries.sites, queries.all) 
  }
  ids <- dbGetQuery(db, "SELECT site_id FROM (SELECT DISTINCT site_id FROM CLIMATEFLUXNET_master)")
  if (sites[i] %in% ids[,1]){
    tmp <-paste(" SELECT ",
                "bar.site AS site, ",
                "spam.site_id AS site_id, ",
                "spam.dataset AS dataset, ",
                "spam.source AS source, ",
                "spam.reference AS reference, ",
                "spam.comments AS comments ",
                "FROM (SELECT ",
                sites[i]," AS site_id, ", 
                "'CLIMATE_LOCAL' AS dataset, ",
                "source, ",
                "reference, ",
                "comments ",
                "FROM  SOURCE_master WHERE dataset = 'CLIMATEFLUXNET') AS spam ", 
                "INNER JOIN SITESID_master as bar ON spam.site_id = bar.site_id ",
                sep = "")
    queries["CLIMATE_LOCAL"] <-  tmp
  }
  ids <- dbGetQuery(db, "SELECT site_id FROM (SELECT DISTINCT site_id FROM METADATA_CLIMATEFLUXNET_SITES_master)")
  if (sites[i] %in% ids[,1]){
    tmp <- paste("SELECT bar.site AS site, spam.site_id AS site_id, spam.dataset AS dataset, ",
                 "spam.source AS source, spam.reference AS reference, spam.comments AS comments ",
                 "FROM (SELECT site_id, dataset, source, reference, comments FROM SOURCE_SITES_master WHERE dataset='CLIMATE_LOCAL'",
                  "AND site_id = '",sites[i],"') AS spam ",
                 "INNER JOIN SITESID_master as bar ON spam.site_id = bar.site_id ",sep = "")
    queries["CLIMATE_LOCAL"] <-  tmp
  }
 
  queries <- sapply(queries, function(x) gsub("_site_id_",sites[i],  x))
  # CLose the open db connection
  dbDisconnect(db)
  # Drop empty querie (cautious)
  queries <- queries[!is.na(queries)]
  # Create a monster query
  query <- paste(queries, collapse = " UNION ")
  begin <- paste("CREATE VIEW SOURCE_", sites[i], " AS ", sep ="")
  querySite <- paste(begin,  query, sep = "")
  
  db <- dbConnect(SQLite(), dbname=myDB)
  if(paste("SOURCE_", sites[i], sep="") %in% dbListTables(db)) dbGetQuery(db, paste("DROP VIEW SOURCE_", sites[i], sep = ""))
  dbGetQuery(db,querySite) 
  dbDisconnect(db)
}

