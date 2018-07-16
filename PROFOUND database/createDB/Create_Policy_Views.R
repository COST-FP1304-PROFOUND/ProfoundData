#------------------------------------------------------------------------------#
#                         Policy
#
#------------------------------------------------------------------------------#
# Load libraries
library(sqldf)
library(DBI)
library(RSQLite)

db <- dbConnect(SQLite(), dbname=myDB)
if ( "POLICY" %in% dbListTables(db)){
  dbSendQuery(db, "DROP VIEW POLICY")
  }


dbGetQuery(db, "CREATE VIEW POLICY AS
            SELECT POLICY_master.dataset,
            POLICY_master.dataPolicy
            FROM POLICY_master WHERE POLICY_master.dataset != 'CLIMATEFLUXNET' ")
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
                  "CLIMATE_ISIMIP2B","CLIMATE_ISIMIP2BLC", "CLIMATE_ISIMIP2A",
                  "CLIMATE_ISIMIPFT",  "MODIS8", "MODIS16")
dataset.sites <- c( "TREE", "STAND", "SOIL", "CLIMATE_LOCAL")
dataset.fluxnet <-c("FLUX", "ENERGYBALANCE", "SOILTS", "METEOROLOGICAL")

dummy.sites <- paste("SELECT bar.site AS site, foo.site_id AS site_id, foo.dataset AS dataset, spam.source AS source, ",
                       "foo.dataPolicy AS dataPolicy FROM (SELECT site_id, dataset, dataPolicy ", 
                       "FROM POLICY_SITES_master WHERE dataset = '_dataset_' and site_id='_site_id_') AS foo ",
                       "INNER JOIN SITESID_master as bar ON foo.site_id = bar.site_id ",
                       "INNER JOIN (SELECT site_id, source FROM SOURCE_SITES_master WHERE dataset='_dataset_') as spam ",
                       "ON foo.site_id = spam.site_id ",sep = "")

dummy.all <- paste("SELECT bar.site AS site, foo.site_id AS site_id, foo.dataset AS dataset, spam.source AS source, ",
                     "foo.dataPolicy AS dataPolicy FROM (SELECT _site_id_ AS site_id, dataset, dataPolicy ", 
                     "FROM POLICY_master WHERE dataset = '_dataset_') AS foo ",
                     "INNER JOIN SITESID_master as bar ON foo.site_id = bar.site_id ",
                     "INNER JOIN (SELECT _site_id_ AS site_id, source FROM SOURCE_master WHERE dataset='_dataset_') as spam ",
                     "ON foo.site_id = spam.site_id ",sep = "")


queries.sites <- sapply(dataset.sites, function(x) gsub("_dataset_",x,  dummy.sites))
queries.all <- sapply(dataset.all, function(x) gsub("_dataset_",x,  dummy.all))
queries.fluxnet <-  sapply(dataset.fluxnet, function(x) gsub("_dataset_",x,  dummy.all))

for ( i in 1:length(sites)){
  db <- dbConnect(SQLite(), dbname=myDB)
  trueTeller <- sapply(names(queries.sites), function(x){
    ids <- dbGetQuery(db, paste("SELECT site_id FROM (SELECT DISTINCT site_id FROM ", x, "_master)", sep=""))
    x <- TRUE
    if (!sites[i] %in% ids[,1]){x <- FALSE} 
    return(x)
  })
  queries.sites.clean <- queries.sites[trueTeller]
  
  ids <- dbGetQuery(db, "SELECT site_id FROM (SELECT DISTINCT site_id FROM FLUXNET_master)")
  if (sites[i] %in% ids[,1]){
    queries <- c(queries.sites.clean, queries.fluxnet, queries.all) 
  }else{
    queries <- c(queries.sites.clean, queries.all) 
  }
  ids <- dbGetQuery(db, "SELECT site_id FROM (SELECT DISTINCT site_id FROM CLIMATEFLUXNET_master)")
  
  if (sites[i] %in% ids[,1]){
    tmp <-paste(" SELECT ",
                "bar.site AS site, ",
                "foo.site_id AS site_id, ",
                "foo.dataset AS dataset, ",
                "spam.source AS source, ",
                "foo.dataPolicy AS dataPolicy ",
                "FROM (SELECT ",
                sites[i]," AS site_id, ", 
                "'CLIMATE_LOCAL' AS dataset, ",
                "dataPolicy ",
                "FROM POLICY_master WHERE dataset = 'CLIMATEFLUXNET') AS foo ", 
                "INNER JOIN SITESID_master as bar ON foo.site_id = bar.site_id ",
                "INNER JOIN (SELECT  ",
                sites[i]," AS site_id, ", 
                "source ",
                "FROM SOURCE_master WHERE dataset='CLIMATEFLUXNET') as spam ON foo.site_id = spam.site_id ",              
                sep = "")
    queries["CLIMATE_LOCAL"] <-  tmp
  }
  ids <- dbGetQuery(db, "SELECT site_id FROM (SELECT DISTINCT site_id FROM METADATA_CLIMATEFLUXNET_SITES_master)")
  if (sites[i] %in% ids[,1]){
    tmp <- paste("SELECT bar.site AS site, foo.site_id AS site_id, foo.dataset AS dataset, spam.source AS source, ",
        "foo.dataPolicy AS dataPolicy FROM (SELECT site_id, dataset, dataPolicy ", 
        "FROM POLICY_SITES_master WHERE dataset = 'CLIMATE_LOCAL' and site_id='",sites[i],"') AS foo ",
        "INNER JOIN SITESID_master as bar ON foo.site_id = bar.site_id ",
        "INNER JOIN (SELECT site_id, source FROM SOURCE_SITES_master WHERE dataset='CLIMATE_LOCAL') as spam ",
        "ON foo.site_id = spam.site_id ",sep = "")
    queries["CLIMATE_LOCAL"] <-  tmp
  }
    # CLose the open db connection
  dbDisconnect(db)
  # Drop empty querie (cautious)
  queries <- queries[!is.na(queries)]
  queries <- sapply(queries, function(x) gsub("_site_id_",sites[i],  x))
  # Create a monster query
  query <- paste(queries, collapse = " UNION ")
  begin <- paste("CREATE VIEW POLICY_", sites[i], " AS ", sep ="")
  querySite <- paste(begin,  query, sep = "")
  
  db <- dbConnect(SQLite(), dbname=myDB)
  if(paste("POLICY_", sites[i], sep="") %in% dbListTables(db)) dbGetQuery(db, paste("DROP VIEW POLICY_", sites[i], sep = ""))
  dbGetQuery(db,querySite) 
  dbDisconnect(db)
}

