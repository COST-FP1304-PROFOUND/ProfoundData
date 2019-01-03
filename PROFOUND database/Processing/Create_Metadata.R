#------------------------------------------------------------------------------#
#                               CREATE METADATA
#------------------------------------------------------------------------------#
myDir <- "~/ownCloud/PROFOUND_Data/Processed/"
setwd(myDir)
# SITES
METADATA_SITES <- read.csv("./Metadata/METADATA_SITES.csv", header = T)
save(METADATA_SITES, file="./RData/METADATA_SITES.RData")
METADATA_SITESID <- read.csv("./Metadata/METADATA_SITESID.csv", header = T)
save(METADATA_SITESID, file="./RData/METADATA_SITESID.RData")
# SITES
METADATA_SITEDESCRIPTION <- read.csv("./Metadata/METADATA_SITESDESCRIPTION.csv", header = T)
save(METADATA_SITEDESCRIPTION, file="./RData/METADATA_SITEDESCRIPTION.RData")
# SOIL
METADATA_SOIL <- read.table("./Metadata/METADATA_SOIL.txt", header = T, sep= "\t",
                            stringsAsFactors = F, quote = "")
METADATA_SOIL$site_id <- 99
save(METADATA_SOIL, file="./RData/METADATA_SOIL.RData")
METADATA_SOIL_SITES <- read.table("./Metadata/METADATA_SOIL_SITES.txt", header = T, sep= "\t",
                                  stringsAsFactors = F, quote = "")
save(METADATA_SOIL_SITES, file="./RData/METADATA_SOIL_SITES.RData")
# TREE
METADATA_TREE <- read.csv("./Metadata/METADATA_TREE.txt", header = T,sep= "\t",
                          stringsAsFactors = F, quote = "")
METADATA_TREE$site_id <- 99
save(METADATA_TREE, file="./RData/METADATA_TREE.RData")
METADATA_TREE_SITES <- read.csv("./Metadata/METADATA_TREE_SITES.txt", header = T,sep= "\t",
                          stringsAsFactors = F, quote = "")
save(METADATA_TREE_SITES, file="./RData/METADATA_TREE_SITES.RData")
METADATA_TREESPECIES <- read.csv("./Metadata/METADATA_TREESPECIES.csv", header = T)
save(METADATA_TREESPECIES, file="./RData/METADATA_TREESPECIES.RData")
# PLOTSIZE
METADATA_PLOTSIZE <- read.csv("./Metadata/METADATA_PLOTSIZE.txt", header = T,sep= "\t",
                          stringsAsFactors = F, quote = "")
METADATA_PLOTSIZE$site_id <- 99
save(METADATA_PLOTSIZE, file="./RData/METADATA_PLOTSIZE.RData")
METADATA_PLOTSIZE_SITES <- read.csv("./Metadata/METADATA_PLOTSIZE_SITES.txt", header = T,sep= "\t",
                              stringsAsFactors = F, quote = "")
save(METADATA_PLOTSIZE_SITES, file="./RData/METADATA_PLOTSIZE_SITES.RData")
# STAND
METADATA_STAND <- read.csv("./Metadata/METADATA_STAND.txt", header = T,sep= "\t",
                              stringsAsFactors = F, quote = "")
METADATA_STAND$site_id <- 99
save(METADATA_STAND, file="./RData/METADATA_STAND.RData")
METADATA_STAND_SITES <- read.csv("./Metadata/METADATA_STAND_SITES.txt", header = T,sep= "\t",
                                    stringsAsFactors = F, quote = "")
save(METADATA_STAND_SITES, file="./RData/METADATA_STAND_SITES.RData")
# CLIMATE_LOCAL
METADATA_CLIMATEFLUXNET <- read.csv("./Metadata/METADATA_CLIMATEFLUXNET.csv", header = T)
save(METADATA_CLIMATEFLUXNET, file="./RData/METADATA_CLIMATEFLUXNET.RData")
METADATA_CLIMATEFLUXNET_SITES <- read.csv("./Metadata/METADATA_CLIMATEFLUXNET_SITES.csv", header = T)
save(METADATA_CLIMATEFLUXNET_SITES, file="./RData/METADATA_CLIMATEFLUXNET_SITES.RData")

METADATA_CLIMATE_LOCAL <- read.csv("./Metadata/METADATA_CLIMATE_LOCAL.txt", header = T,sep= "\t",
                           stringsAsFactors = F, quote = "")
METADATA_CLIMATE_LOCAL$site_id <- 99
save(METADATA_CLIMATE_LOCAL, file="./RData/METADATA_CLIMATE_LOCAL.RData")
METADATA_CLIMATE_LOCAL_SITES <- read.csv("./Metadata/METADATA_CLIMATE_LOCAL_SITES.txt", header = T,sep= "\t",
                                 stringsAsFactors = F, quote = "")
save(METADATA_CLIMATE_LOCAL_SITES, file="./RData/METADATA_CLIMATE_LOCAL_SITES.RData")
# FLUXNET
METADATA_FLUXNET <- read.csv("./Metadata/METADATA_FLUXNET.csv", header = T)
save(METADATA_FLUXNET, file="./RData/METADATA_FLUXNET.RData")
# CLIMATE_ISIMIP2A
METADATA_CLIMATE_ISIMIP2A <- read.csv("./Metadata/METADATA_CLIMATE_ISIMIP2A.csv", header = T)
save(METADATA_CLIMATE_ISIMIP2A, file="./RData/METADATA_CLIMATE_ISIMIP2A.RData")
# CLIMATE_ISIMIP2B
METADATA_CLIMATE_ISIMIP2B <- read.csv("./Metadata/METADATA_CLIMATE_ISIMIP2B.csv", header = T)
save(METADATA_CLIMATE_ISIMIP2B, file="./RData/METADATA_CLIMATE_ISIMIP2B.RData")
# CLIMATE_ISIMIP2BLBC
METADATA_CLIMATE_ISIMIP2BLBC <- read.csv("./Metadata/METADATA_CLIMATE_ISIMIP2BLBC.csv", header = T)
save(METADATA_CLIMATE_ISIMIP2BLBC, file="./RData/METADATA_CLIMATE_ISIMIP2BLBC.RData")
# CLIMATE_ISIMIPFT  
METADATA_CLIMATE_ISIMIPFT <- read.csv("./Metadata/METADATA_CLIMATE_ISIMIPFT.csv", header = T)
save(METADATA_CLIMATE_ISIMIPFT, file="./RData/METADATA_CLIMATE_ISIMIPFT.RData")
# NDEPOSITION_EMEP    
METADATA_NDEPOSITION_EMEP <- read.csv("./Metadata/METADATA_NDEPOSITION_EMEP.csv", header = T)
save(METADATA_NDEPOSITION_EMEP, file="./RData/METADATA_NDEPOSITION_EMEP.RData")
# NDEPOSITION_ISIMIP2B
METADATA_NDEPOSITION_ISIMIP2B <- read.csv("./Metadata/METADATA_NDEPOSITION_ISIMIP2B.csv", header = T)
save(METADATA_NDEPOSITION_ISIMIP2B, file="./RData/METADATA_NDEPOSITION_ISIMIP2B.RData")
# CO2_ISIMIP
METADATA_CO2_ISIMIP <- read.csv("./Metadata/METADATA_CO2_ISIMIP.csv", header = T)
save(METADATA_CO2_ISIMIP, file="./RData/METADATA_CO2_ISIMIP.RData")
# MODIS
METADATA_MODIS <- read.table("./Metadata/METADATA_MODIS.txt", header = T, sep= "\t",
                             stringsAsFactors = F, quote = "", fill = T)
save(METADATA_MODIS, file="./RData/METADATA_MODIS.RData")
METADATA_MODIS_MOD09A1 <- read.table("./Metadata/METADATA_MODIS_MOD09A1.txt", header = T, sep= "\t",
                             stringsAsFactors = F, quote = "", fill = T)
save(METADATA_MODIS_MOD09A1, file="./RData/METADATA_MODIS_MOD09A1.RData")
METADATA_MODIS_MOD11A2 <- read.table("./Metadata/METADATA_MODIS_MOD11A2.txt", header = T, sep= "\t",
                                     stringsAsFactors = F, quote = "", fill = T)
save(METADATA_MODIS_MOD11A2, file="./RData/METADATA_MODIS_MOD11A2.RData")
METADATA_MODIS_MOD13Q1 <- read.table("./Metadata/METADATA_MODIS_MOD13Q1.txt", header = T, sep= "\t",
                                     stringsAsFactors = F, quote = "", fill = T)
save(METADATA_MODIS_MOD13Q1, file="./RData/METADATA_MODIS_MOD13Q1.RData")
METADATA_MODIS_MOD15A2 <- read.table("./Metadata/METADATA_MODIS_MOD15A2.txt", header = T, sep= "\t",
                                     stringsAsFactors = F, quote = "", fill = T)
save(METADATA_MODIS_MOD15A2, file="./RData/METADATA_MODIS_MOD15A2.RData")
METADATA_MODIS_MOD17A2 <- read.table("./Metadata/METADATA_MODIS_MOD17A2.txt", header = T, sep= "\t",
                                     stringsAsFactors = F, quote = "", fill = T)
save(METADATA_MODIS_MOD17A2, file="./RData/METADATA_MODIS_MOD17A2.RData")
