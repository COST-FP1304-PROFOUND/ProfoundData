# Load libraries
library(sqldf)
library(DBI)
library(RSQLite)

# GET ONE SITE
dataset <- c("SITES", "TREE", "STAND", "SOIL", "CLIMATE_LOCAL",# "CLIMATEFLUXNET",# "CLIMATEEUROFLUX",
           "FLUXNET", "FLUX", "ATMOSPHERICHEATCONDUCTION", "SOILTS", "NDEPOSITION_EMEP",
             "NDEPOSITION_ISIMIP2B", "CO2_ISIMIP",  "CLIMATE_ISIMIP2B", "CLIMATE_ISIMIP2A",
             "CLIMATE_ISIMIPFT",  "MODIS_MOD09A1", "MODIS_MOD11A2", "MODIS_MOD13Q1",
             "MODIS_MOD15A2",  "MODIS_MOD17A2")

gsubMetadata <- function(x){
  for (i in 1:length(x)){
    x[i] <- gsub("SELECT foo.variable", paste("SELECT '",names(x)[i], "' AS dataset, foo.variable", sep= "" ), x[i])
#    x[i] <- gsub("SELECT fooeggs.variable", paste("SELECT '",names(x)[i], "' AS dataset, fooeggs.variable", sep= "" ), x[i])
    x[i] <- gsub("SELECT norf.variable", paste("SELECT '",names(x)[i], "' AS dataset, norf.variable", sep= "" ), x[i])
#    x[i] <- gsub("SELECT norf.variable", paste("SELECT '",names(x)[i], "' AS dataset, norf.variable", sep= "" ), x[i])
#    x[i] <- gsub("SELECT foofoo.variable", paste("SELECT '",names(x)[i], "' AS dataset, foofoo.variable", sep= "" ), x[i])
#    x[i] <- gsub("SELECT fooham.variable", paste("SELECT '",names(x)[i], "' AS dataset, fooham.variable", sep= "" ), x[i])
   x[i] <- paste(x[i], ") ", sep="")
  }
  query <- gsub(  'CREATE VIEW (\\w+) AS'," SELECT * FROM ("  ,  x)
  query <- gsub(  "foo.description, spam.source FROM","foo.description, NULL AS comments, spam.source FROM"  ,  query)
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




queries  <- rep(NA, length(dataset))
names(queries) <- dataset
#SELECT foo.variable, foo.type, foo.units , foo.description, spam.source FROM
#(SELECT * FROM  METADATA_CLIMATE_ISIMIP2A_master UNION SELECT * FROM METADATA_SITESID_master  WHERE variable="site" ) AS foo 
#INNER JOIN (SELECT site_id, source FROM SOURCE_master WHERE dataset='CLIMATE_ISIMIP2A') AS spam ON foo.site_id = spam.site_id
  # SITES
  tmp <-paste("CREATE VIEW METADATA_SITES AS  SELECT foo.variable,  foo.type, foo.units , foo.description, spam.source FROM ",
              "(SELECT *  FROM METADATA_SITESID_master UNION SELECT * FROM METADATA_SITES_master ) AS foo ",
              "INNER JOIN (SELECT site_id, source FROM SOURCE_master WHERE dataset='SITES') AS spam ON foo.site_id = spam.site_id ",
              paste = "")
  queries["SITES"] <- tmp
  tmp <-paste("CREATE VIEW METADATA_SITEDESCRIPTION AS  SELECT foo.variable,  foo.type, foo.units , foo.description, spam.source FROM ",
              "(SELECT *  FROM METADATA_SITEDESCRIPTION_master UNION SELECT * FROM METADATA_SITESID_master  WHERE variable='site' ) AS foo ",
              "INNER JOIN (SELECT site_id, source FROM SOURCE_master WHERE dataset='SITES') AS spam ON foo.site_id = spam.site_id ",
              paste = "")
  queries["SITEDESCRIPTION"] <- tmp
  # TREE
  tmp <-paste("CREATE VIEW METADATA_TREE AS SELECT foo.variable, foo.type, foo.units , foo.description, spam.source FROM ",
              "(SELECT * FROM METADATA_TREESPECIES_master  WHERE variable ='species' UNION  SELECT * FROM METADATA_TREE_master ",
              "UNION SELECT * FROM  METADATA_PLOTSIZE_master where variable='size_m2' UNION SELECT * FROM METADATA_SITESID_master  WHERE variable='site' ) AS foo  ",
              "INNER JOIN (SELECT site_id, source FROM SOURCE_master WHERE dataset='TREE') AS spam ON foo.site_id = spam.site_id ",
              paste = "")
  queries["TREE"] <- tmp
  # STAND
  tmp <-paste("CREATE VIEW METADATA_STAND AS SELECT foo.variable, foo.type, foo.units , foo.description, spam.source FROM ",
              "(SELECT * FROM METADATA_TREESPECIES_master  WHERE variable ='species' UNION  SELECT * FROM METADATA_STAND_master UNION SELECT * FROM METADATA_SITESID_master  WHERE variable='site') AS foo ",
              "INNER JOIN (SELECT site_id, source FROM SOURCE_master WHERE dataset='STAND') AS spam ON foo.site_id = spam.site_id ",
              paste = "")
  queries["STAND"] <- tmp
    # SOIL
  tmp <-paste("CREATE VIEW METADATA_SOIL AS ",
              "SELECT foo.variable, foo.type, foo.units , foo.description, spam.source FROM ",
              "(SELECT *  FROM METADATA_SOIL_master UNION SELECT * FROM METADATA_SITESID_master  WHERE variable='site' ) AS foo ",
              "INNER JOIN (SELECT site_id, source FROM SOURCE_master WHERE dataset='SOIL') AS spam ON foo.site_id = spam.site_id ",
              paste = "")
  queries["SOIL"] <- tmp
  # CLIMATE
  tmp <-paste("CREATE VIEW METADATA_CLIMATE_LOCAL AS ",
              "SELECT foo.variable, foo.type, foo.units, foo.description, foo.comments, foo.source ",
              "FROM  (SELECT ham.variable, ham.type, ham.units, ham.description, NULL AS comments, spam.source FROM ",
              "(SELECT *  FROM METADATA_CLIMATE_LOCAL_master UNION SELECT * FROM METADATA_SITESID_master  WHERE variable='site' ) as ham ",
              "INNER JOIN (SELECT site_id, source FROM SOURCE_master WHERE dataset='CLIMATE_LOCAL') AS spam ON ham.site_id = spam.site_id ) as foo ",
              "UNION ",
              "SELECT norf.variable, norf.type, norf.units, norf.description, norf.comments, norf.source ",
              "FROM (SELECT bar.variable, bar.type, bar.units, bar.description, bar.comments,  eggs.source FROM ",
              "(SELECT *  FROM METADATA_CLIMATEFLUXNET_master UNION SELECT *, NULL AS comments  FROM METADATA_SITESID_master  WHERE variable='site' ) as bar ",
              "INNER JOIN (SELECT site_id, source FROM SOURCE_master WHERE dataset='CLIMATEFLUXNET') AS eggs ON bar.site_id = eggs.site_id ) as norf ",
              paste = "")
  queries["CLIMATE_LOCAL"] <- tmp
#  tmp <-paste("CREATE VIEW METADATA_CLIMATEFLUXNET AS ",
#              "SELECT foo.variable, foo.type, foo.units , foo.description, spam.source , comments FROM METADATA_CLIMATEFLUXNET_master ",
#              paste = "")
#  queries["CLIMATEFLUXNET"] <- tmp
#  tmp <-paste("CREATE VIEW METADATA_CLIMATEEUROFLUX AS ",
#              "SELECT foo.variable, foo.type, foo.units , foo.description, spam.source , comments FROM METADATA_CLIMATEEUROFLUX_master",
#              paste = "")
#  queries["CLIMATEEUROFLUX"] <- tmp
  # NDEPOSITION_EMEP
  tmp <-paste("CREATE VIEW METADATA_NDEPOSITION_EMEP AS ",
              "SELECT foo.variable, foo.type, foo.units , foo.description, spam.source FROM ", 
              "(SELECT *  FROM METADATA_NDEPOSITION_EMEP_master UNION SELECT * FROM METADATA_SITESID_master  WHERE variable='site' ) AS foo ",
              "INNER JOIN (SELECT site_id, source FROM SOURCE_master WHERE dataset='NDEPOSITION_EMEP') AS spam ON foo.site_id = spam.site_id ",
              paste = "")
    queries["NDEPOSITION_EMEP"] <- tmp
  # NDEPOSITION_ISIMIP2B
  tmp <-paste("CREATE VIEW METADATA_NDEPOSITION_ISIMIP2B AS ",
              "SELECT foo.variable, foo.type, foo.units , foo.description, spam.source FROM ",
              "(SELECT *  FROM METADATA_NDEPOSITION_ISIMIP2B_master UNION SELECT * FROM METADATA_SITESID_master  WHERE variable='site' ) AS foo ",
              "INNER JOIN (SELECT site_id, source FROM SOURCE_master WHERE dataset='NDEPOSITION_ISIMIP2B') AS spam ON foo.site_id = spam.site_id ",
              paste = "")
  queries["NDEPOSITION_ISIMIP2B"] <- tmp

  # CO2_ISIMIP
  tmp <-paste("CREATE VIEW METADATA_CO2_ISIMIP AS ",
                "SELECT foo.variable, foo.type, foo.units , foo.description, spam.source FROM ", 
              "(SELECT *  FROM METADATA_CO2_ISIMIP_master UNION SELECT * FROM METADATA_SITESID_master  WHERE variable='site' ) AS foo ",
               "INNER JOIN (SELECT site_id, source FROM SOURCE_master WHERE dataset='CO2_ISIMIP') AS spam ON foo.site_id = spam.site_id ",
                paste = "")
   queries["CO2_ISIMIP"] <- tmp
#   for (i in 1:length(datasets.CO2)){
#     tmp.co2 <- gsub("VIEW METADATA_CO2", paste("VIEW METADATA_", datasets.CO2[i], sep=""),
#                        tmp)
#     queries[datasets.CO2[i]] <- tmp.co2
#   }
  # CLIMATE_ISIMIP2A
   tmp <-paste("CREATE VIEW METADATA_CLIMATE_ISIMIP2A AS ",
               "SELECT foo.variable, foo.type, foo.units , foo.description, spam.source FROM ",
               "(SELECT *  FROM METADATA_CLIMATE_ISIMIP2A_master UNION SELECT * FROM METADATA_SITESID_master  WHERE variable='site' ) AS foo ",
                "INNER JOIN (SELECT site_id, source FROM SOURCE_master WHERE dataset='CLIMATE_ISIMIP2A') AS spam ON foo.site_id = spam.site_id ",
               paste = "")
   queries["CLIMATE_ISIMIP2A"] <- tmp
   # CLIMATE_ISIMIP2B
   tmp <-paste("CREATE VIEW METADATA_CLIMATE_ISIMIP2B AS ",
               "SELECT foo.variable, foo.type, foo.units , foo.description, spam.source FROM ", 
               "(SELECT *  FROM METADATA_CLIMATE_ISIMIP2B_master UNION SELECT * FROM METADATA_SITESID_master  WHERE variable='site' ) AS foo ",
               "INNER JOIN (SELECT site_id, source FROM SOURCE_master WHERE dataset='CLIMATE_ISIMIP2B') AS spam ON foo.site_id = spam.site_id ",
               paste = "")
   queries["CLIMATE_ISIMIP2B"] <- tmp
   # CLIMATE_ISIMIP2BLBC
   tmp <-paste("CREATE VIEW METADATA_CLIMATE_ISIMIP2BLBC AS ",
               "SELECT foo.variable, foo.type, foo.units , foo.description, spam.source FROM ",
               "(SELECT *  FROM METADATA_CLIMATE_ISIMIP2BLBC_master UNION SELECT * FROM METADATA_SITESID_master  WHERE variable='site' ) AS foo ",
                "INNER JOIN (SELECT site_id, source FROM SOURCE_master WHERE dataset='CLIMATE_ISIMIP2BLBC') AS spam ON foo.site_id = spam.site_id ",
               paste = "")
   queries["CLIMATE_ISIMIP2BLBC"] <- tmp
   # CLIMATE_ISIMIPFT
   tmp <-paste("CREATE VIEW METADATA_CLIMATE_ISIMIPFT AS ",
               "SELECT foo.variable, foo.type, foo.units, foo.description, spam.source FROM ",
               "(SELECT *  FROM METADATA_CLIMATE_ISIMIPFT_master UNION SELECT * FROM METADATA_SITESID_master  WHERE variable='site' ) AS foo ",
               "INNER JOIN (SELECT site_id, source FROM SOURCE_master WHERE dataset='CLIMATE_ISIMIPFT') AS spam ON foo.site_id = spam.site_id ",
               paste = "")
   queries["CLIMATE_ISIMIPFT"] <- tmp
#   for (i in 1:length(datasets.ISIMIP)){
#     tmp.isimip <- gsub("VIEW METADATA_ISIMIP", paste("VIEW METADATA_", datasets.ISIMIP[i], sep=""),
#                        tmp)
#     queries[datasets.ISIMIP[i]] <- tmp.isimip
#   }
   # FLUXNET
   tmp <-paste("CREATE VIEW METADATA_FLUXNET AS ",
               "SELECT foo.variable, foo.type, foo.units , foo.description, spam.source FROM ", 
               "(SELECT *  FROM METADATA_FLUXNET_master UNION SELECT record_id, variable, type, units , description, 'FLUXNET' AS dataset, site_id  FROM METADATA_SITESID_master  WHERE variable='site') AS foo ",
               "INNER JOIN (SELECT site_id, source FROM SOURCE_master WHERE dataset='FLUXNET') AS spam ON foo.site_id = spam.site_id ",
               paste = "")
#  queries["FLUXNET"] <- tmp
   # ATMOSPHERICHEATCONDUCTION
   tmp <-paste("CREATE VIEW METADATA_ATMOSPHERICHEATCONDUCTION AS ",
               "SELECT foo.variable, foo.type, foo.units , foo.description, spam.source FROM ",
               "(SELECT *  FROM METADATA_FLUXNET_master UNION SELECT record_id, variable, type, units , description, 'FLUXNET' AS dataset, site_id  FROM METADATA_SITESID_master  WHERE variable='site') AS foo ",
               "INNER JOIN (SELECT site_id, source FROM SOURCE_master WHERE dataset='ATMOSPHERICHEATCONDUCTION') AS spam ON foo.site_id = spam.site_id ",
               "WHERE foo.dataset='FLUXNET' OR foo.dataset='ATMOSPHERICHEATCONDUCTION'",
               paste = "")
   queries["ATMOSPHERICHEATCONDUCTION"] <- tmp
   # FLUX
   tmp <-paste("CREATE VIEW METADATA_FLUX AS ",
               "SELECT foo.variable, foo.type, foo.units , foo.description, spam.source FROM ", 
               "(SELECT *  FROM METADATA_FLUXNET_master  UNION SELECT record_id, variable, type, units , description, 'FLUXNET' AS dataset, site_id  FROM METADATA_SITESID_master  WHERE variable='site') AS foo ",
               "INNER JOIN (SELECT site_id, source FROM SOURCE_master WHERE dataset='FLUX') AS spam ON foo.site_id = spam.site_id ",
               "WHERE foo.dataset='FLUXNET' OR foo.dataset='FLUX'",
               paste = "")
  queries["FLUX"] <- tmp
  # SOILTS
  tmp <-paste("CREATE VIEW METADATA_SOILTS AS ",
              "SELECT foo.variable, foo.type, foo.units , foo.description, spam.source FROM ",
              "(SELECT *  FROM METADATA_FLUXNET_master  UNION SELECT record_id, variable, type, units , description, 'FLUXNET' AS dataset, site_id  FROM METADATA_SITESID_master  WHERE variable='site') AS foo ",
              "INNER JOIN (SELECT site_id, source FROM SOURCE_master WHERE dataset='SOILTS') AS spam ON foo.site_id = spam.site_id ",
              "WHERE foo.dataset='FLUXNET' OR foo.dataset='SOILTS'",
              paste = "")
  queries["SOILTS"] <- tmp
  # METEOROLOGICAL
  tmp <-paste("CREATE VIEW METADATA_METEOROLOGICAL AS ",
              "SELECT foo.variable, foo.type, foo.units , foo.description, spam.source FROM ",
              "(SELECT *  FROM METADATA_FLUXNET_master  UNION SELECT record_id, variable, type, units , description, 'FLUXNET' AS dataset, site_id  FROM METADATA_SITESID_master  WHERE variable='site') AS foo ",
              "INNER JOIN (SELECT site_id, source FROM SOURCE_master WHERE dataset='METEOROLOGICAL') AS spam ON foo.site_id = spam.site_id ",
              "WHERE foo.dataset='FLUXNET' OR foo.dataset='METEOROLOGICAL'",
              paste = "")
  queries["METEOROLOGICAL"] <- tmp
  # MODIS_MOD09A1
  tmp <-paste("CREATE VIEW METADATA_MODIS_MOD09A1 AS ",
              "SELECT foo.variable, foo.type, foo.units, foo.description, foo.comments, spam.source FROM ", 
              "(SELECT *  FROM METADATA_MODIS_MOD09A1_master UNION SELECT *, NULL AS comments FROM METADATA_SITESID_master  WHERE variable='site' ) AS foo ",
              "INNER JOIN (SELECT site_id, source FROM SOURCE_master WHERE dataset='MODIS_MOD09A1') As spam ON foo.site_id = spam.site_id ",
              sep = "")
  queries["MODIS_MOD09A1"] <- tmp
  # MODIS_MOD11A2
  tmp <-paste("CREATE VIEW METADATA_MODIS_MOD11A2 AS ",
              "SELECT foo.variable, foo.type, foo.units, foo.description, foo.comments, spam.source FROM ", 
              "(SELECT *  FROM METADATA_MODIS_MOD11A2_master UNION SELECT *, NULL AS comments FROM METADATA_SITESID_master  WHERE variable='site' ) AS foo ",
              "INNER JOIN (SELECT site_id, source FROM SOURCE_master WHERE dataset='MODIS_MOD11A2') As spam ON foo.site_id = spam.site_id ",
              sep = "")
  queries["MODIS_MOD11A2"] <- tmp
  # MODIS_MOD13Q1
  tmp <-paste("CREATE VIEW METADATA_MODIS_MOD13Q1 AS ",
              "SELECT foo.variable, foo.type, foo.units, foo.description, foo.comments, spam.source FROM ", 
              "(SELECT *  FROM METADATA_MODIS_MOD13Q1_master UNION SELECT *, NULL AS comments FROM METADATA_SITESID_master  WHERE variable='site' ) AS foo ",
              "INNER JOIN (SELECT site_id, source FROM SOURCE_master WHERE dataset='MODIS_MOD13Q1') As spam ON foo.site_id = spam.site_id ",
              sep = "")
  queries["MODIS_MOD13Q1"] <- tmp
  # MODIS_MOD15A2
  tmp <-paste("CREATE VIEW METADATA_MODIS_MOD15A2 AS ",
              "SELECT foo.variable, foo.type, foo.units, foo.description, foo.comments, spam.source FROM ",
              "(SELECT *  FROM METADATA_MODIS_MOD15A2_master UNION SELECT *, NULL AS comments FROM METADATA_SITESID_master  WHERE variable='site' ) AS foo ",
              "INNER JOIN (SELECT site_id, source FROM SOURCE_master WHERE dataset='MODIS_MOD15A2') As spam ON foo.site_id = spam.site_id ",
              sep = "")
  queries["MODIS_MOD15A2"] <- tmp
  # MODIS_MOD17A2
  tmp <-paste("CREATE VIEW METADATA_MODIS_MOD17A2 AS ",
              "SELECT foo.variable, foo.type, foo.units, foo.description, foo.comments, spam.source FROM ",
              "(SELECT *  FROM METADATA_MODIS_MOD17A2_master UNION SELECT *, NULL AS comments FROM METADATA_SITESID_master  WHERE variable='site' ) AS foo ",
              "INNER JOIN (SELECT site_id, source FROM SOURCE_master WHERE dataset='MODIS_MOD17A2') As spam ON foo.site_id = spam.site_id ",
              sep = "")
  queries["MODIS_MOD17A2"] <- tmp
  # MODIS 
  tmp <-paste("CREATE VIEW METADATA_MODIS AS ",
            "SELECT  foo.variable, foo.type, foo.units, foo.description,foo.comments, spam.source FROM",
            "(SELECT *  FROM METADATA_MODIS_MOD09A1_master UNION SELECT *, NULL AS comments FROM METADATA_SITESID_master  WHERE variable='site' ) AS foo ",
            "INNER JOIN (SELECT site_id, source FROM SOURCE_master WHERE dataset='MODIS_MOD09A1') As spam ON foo.site_id = spam.site_id ",
            "UNION ",
            "SELECT  norf.variable,  norf.type, norf.units, norf.description, norf.comments, ham.source FROM ",
            "(SELECT *  FROM METADATA_MODIS_MOD11A2_master UNION SELECT *, NULL AS comments FROM METADATA_SITESID_master  WHERE variable='site' ) AS norf ",
            "INNER JOIN (SELECT site_id, source FROM SOURCE_master WHERE dataset='MODIS_MOD11A2') AS ham ON norf.site_id = ham.site_id ",
            "UNION ",
            "SELECT  fooeggs.variable, fooeggs.type,  fooeggs.units, fooeggs.description, fooeggs.comments, foobar.source FROM ",
            "(SELECT *  FROM METADATA_MODIS_MOD13Q1_master UNION SELECT *, NULL AS comments FROM METADATA_SITESID_master  WHERE variable='site' ) AS fooeggs ",
            "INNER JOIN (SELECT site_id, source FROM SOURCE_master WHERE dataset='MODIS_MOD13Q1') As foobar ON fooeggs.site_id = foobar.site_id ",
            "UNION ",
            "SELECT  foofoo.variable, foofoo.type, foofoo.units, foofoo.description, foofoo.comments, foospam.source FROM ",
            "(SELECT *  FROM METADATA_MODIS_MOD15A2_master UNION SELECT *, NULL AS comments FROM METADATA_SITESID_master  WHERE variable='site' ) AS foofoo ",
            "INNER JOIN (SELECT site_id, source FROM SOURCE_master WHERE dataset='MODIS_MOD15A2') As foospam ON foofoo.site_id = foospam.site_id ",
            "UNION ",
            "SELECT  fooham.variable, fooham.type, fooham.units, fooham.description, fooham.comments, foonorf.source FROM ",
            "(SELECT *  FROM METADATA_MODIS_MOD17A2_master UNION SELECT *, NULL AS comments FROM METADATA_SITESID_master  WHERE variable='site' ) AS fooham ",
            "INNER JOIN (SELECT site_id, source FROM SOURCE_master WHERE dataset='MODIS_MOD17A2') As foonorf ON fooham.site_id = foonorf.site_id ",
            sep = "")
  queries["MODIS"] <- tmp
  # MODIS8
  tmp <-paste("CREATE VIEW METADATA_MODIS8 AS ",
              "SELECT  foo.variable, foo.type, foo.units, foo.description, spam.source FROM METADATA_MODIS_MOD09A1_master AS foo ", 
              "INNER JOIN (SELECT site_id, source FROM SOURCE_master WHERE dataset='MODIS_MOD09A1') As spam ON foo.site_id = spam.site_id ",
              "UNION ",
              "SELECT  norf.variable,  norf.type, norf.units, norf.description, ham.source FROM METADATA_MODIS_MOD11A2_master AS norf ", 
              "INNER JOIN (SELECT site_id, source FROM SOURCE_master WHERE dataset='MODIS_MOD11A2') AS ham ON norf.site_id = ham.site_id ",
              "UNION ",
              "SELECT  foofoo.variable, foofoo.type, foofoo.units, foofoo.description, foospam.source FROM METADATA_MODIS_MOD15A2_master AS foofoo ", 
              "INNER JOIN (SELECT site_id, source FROM SOURCE_master WHERE dataset='MODIS_MOD15A2') As foospam ON foofoo.site_id = foospam.site_id ",
              "UNION ",
              "SELECT  fooham.variable, fooham.type, fooham.units, fooham.description, foonorf.source FROM METADATA_MODIS_MOD17A2_master AS fooham ", 
              "INNER JOIN (SELECT site_id, source FROM SOURCE_master WHERE dataset='MODIS_MOD17A2') As foonorf ON fooham.site_id = foonorf.site_id ",
              sep = "")
#  queries["MODIS8"] <- tmp
  # MODIS16
 tmp <-paste("CREATE VIEW METADATA_MODIS16 AS ",
              "SELECT  foo.variable, foo.type, foo.units, foo.description, spam.source FROM METADATA_MODIS_MOD13Q1_master AS foo ", 
              "INNER JOIN (SELECT site_id, source FROM SOURCE_master WHERE dataset='MODIS_MOD13Q1') As spam ON foo.site_id = spam.site_id ",
              sep = "")
#  queries["MODIS16"] <- tmp


queries <- queries[!is.na(queries)]
db <- dbConnect(SQLite(), dbname=myDB)
sapply(1:length(queries), FUN = function(x){
  if(paste("METADATA_", names(queries)[x],sep="") %in% dbListTables(db)) dbGetQuery(db, paste("DROP VIEW METADATA_", names(queries)[x], sep = ""))
  dbGetQuery(db,queries[x])
})
dbDisconnect(db)

queries <- queries[!names(queries) %in% c("MODIS")]
query <- gsubMetadata(queries)

query <- paste(query, collapse = " UNION ")

query <- paste("CREATE VIEW METADATA_DATASETS AS ", query, sep = "")

db <- dbConnect(SQLite(), dbname=myDB)
if("METADATA_DATASETS" %in% dbListTables(db)) dbGetQuery(db, "DROP VIEW METADATA_DATASETS")
dbGetQuery(db,query)
dbDisconnect(db)




