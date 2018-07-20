#------------------------------------------------------------------------------#
# Created DB
#     This script does the following:
#
#
#------------------------------------------------------------------------------#
setwd("~/Github/COST-FP1304-PROFOUND/ProfoundData/PROFOUND database/createDB/")
#myDB <- "~/ProfoundData.sqlite"
#myDB <- "/home/ramiro/ownCloud/PROFOUND_Data/TESTVERSION/ProfoundData.sqlite"
myDB <- "/home/ramiro/ownCloud/PROFOUND_Data/v0.1.13/ProfoundData.sqlite"
#myDB <- "~/ownCloud/PROFOUND_Data/PI_Questions/ProfoundData.sqlite"
# Load libraries
library(sqldf)
library(DBI)
library(RSQLite)



# still have to do this
source("Version_to_DB.R")


# SITES
source("Sites_to_DB.R")
source("Create_SITES_Views.R")
source("MetadataSITES_to_DB.R")
source("SITEDESCRIPTION_to_DB.R")
source("MetadataSITEDESCRIPTION_to_DB.R")
source("Create_SITEDESCRIPTION_Views.R")
# create ecological description
# SOIL
source("SoilWide_to_DB.R")
source("Create_SOIL_Views.R")
source("MetadataSOIL_to_DB.R")
# PLOTSIZE
source("PLOTSIZE_to_DB.R")
source("METADATA_PLOTSIZE_to_DB.R")
# TREE
source("TreeSpecies_to_DB.R")
source("Tree_to_DB.R")
source("Create_TREE_Views.R")
source("MetadataTREE_to_DB.R")
# STAND
source("Stand_to_DB.R")
source("Create_STAND_Views.R")
source("MetadataSTAND_to_DB.R")
# CLIMATE_LOCAL
source("ClimateFluxnet_to_DB.R")
source("Create_CLIMATEFLUXNET_Views.R")
source("MetadataCLIMATEFLUXNET_to_DB.R")
source("ClimateLocal_to_DB.R")
source("Create_CLIMATE_LOCAL_Views.R")
source("MetadataCLIMATE_LOCAL_to_DB.R")
# CO2
source("CO2_ISIMIP_to_DB.R")
source("Create_CO2_ISIMIP_Views.R")
source("MetadataCO2_ISIMIP_to_DB.R")
# NDEPOSITION_EMEP
source("NDEPOSITION_EMEP_to_DB.R")
source("Create_NDEPOSITION_EMEP_Views.R")
source("MetadataNDEPOSITION_EMEP_to_DB.R")
# NDEPOSITION_ISIMIP2B
source("NDEPOSITION_ISIMIP2B_to_DB.R")
source("Create_NDEPOSITION_ISIMIP2B_Views.R")
source("MetadataNDEPOSITION_ISIMIP2B_to_DB.R")
# MODIS 8 & 16
source("MODIS_MOD09A1_to_DB.R")
source("MODIS_MOD11A2_to_DB.R") 
source("MODIS_MOD13Q1_to_DB.R")
source("MODIS_MOD15A2_to_DB.R")
source("MODIS_MOD17A2_to_DB.R") 
source("Create_MODIS_MOD_Views.R")
source("MetadataMODIS_MOD_DB.R")
# FLUXNET
source("FLUXNET_to_DB.R")
source("Create_FLUXNET_Views.R")
source("MetadataFLUXNET_to_DB.R")
# CLIMATE_ISIMPI2A
source("ISIMIP2A_to_DB.R")
source("Create_ISIMIP2A_Views.R")
source("MetadataCLIMATE_ISIMIP2A_to_DB.R")
# CLIMATE_ISIMPI2B
source("ISIMIP2B_to_DB.R")
source("Create_ISIMIP2B_Views.R")
source("MetadataCLIMATE_ISIMIP2B_to_DB.R")
# CLIMATE_ISIMPI2BLBC
source("ISIMIP2BLBC_to_DB.R")
source("Create_ISIMIP2BLBC_Views.R")
source("MetadataCLIMATE_ISIMIP2BLBC_to_DB.R")
# CLIMATE_ISIMPIPFT
source("ISIMIPFT_to_DB.R")
source("Create_ISIMIPFT_Views.R")
source("MetadataCLIMATE_ISIMIPFT_to_DB.R")
# SOURCE
source("Source_to_DB.R")
source("Create_Source_Views.R")
# POLICY
source("Policy_to_DB.R")
source("Create_Policy_Views.R")
# The missing metadata
source("Metadata_singleSites_DB.R")
source("Metadata_Datasets_DB.R")

source("Create_OVERVIEWDB.R")


