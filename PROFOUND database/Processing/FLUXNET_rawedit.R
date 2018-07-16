#------------------------------------------------------------------------------#
#                             FLUXNET 2015 -> meteo
#
# This scripts subsets the FLUXNET 2015 data the meteo variables
#------------------------------------------------------------------------------#
#FLUXNET 2015 metoe
files_flux <- c("~/ownCloud/PROFOUND_Data/Processed/fluxnet2015/FI-Hyy/FLX_FI-Hyy_FLUXNET2015_FULLSET_HH_1996-2014_1-1.csv",
             "~/ownCloud/PROFOUND_Data/Processed/fluxnet2015/FR-Pue/FLX_FR-Pue_FLUXNET2015_FULLSET_HH_2000-2013_1-1.csv",
             "~/ownCloud/PROFOUND_Data/Processed/fluxnet2015/BE-Bra/FLX_BE-Bra_FLUXNET2015_FULLSET_HH_1996-2013_1-1.csv",
             "~/ownCloud/PROFOUND_Data/Processed/fluxnet2015/CZ-BK1/FLX_CZ-BK1_FLUXNET2015_FULLSET_HH_2000-2008_1-1.csv",
             "~/ownCloud/PROFOUND_Data/Processed/fluxnet2015/DK-Sor/FLX_DK-Sor_FLUXNET2015_FULLSET_HH_1996-2012_1-1.csv",
             "~/ownCloud/PROFOUND_Data/Processed/fluxnet2015/FLX_IT-Col_FLUXNET2015_FULLSET_1996-2014_1-3/FLX_IT-Col_FLUXNET2015_FULLSET_HH_1996-2014_1-3.csv",
             "~/ownCloud/PROFOUND_Data/Processed/fluxnet2015/FLX_FR-LBr_FLUXNET2015_FULLSET_1996-2008_1-3/FLX_FR-LBr_FLUXNET2015_FULLSET_HH_1996-2008_1-3.csv"
)

names(files_flux) <- c("Hyytiala", "Puechabon", "Brasschaat","BilyKriz", "Soro",
                        "Collelongo", "LeBray")

# GEt all fluxnet variables
  # FLUXES
variables <- read.table("~/ownCloud/PROFOUND_Data/Processed/fluxnet2015/FLUX.csv",
                        sep = ",", header = T)
variables <- variables[ variables$Tier == 1,]$Variable
  # ENERGY BALANCE
var <- read.csv("~/ownCloud/PROFOUND_Data/Processed/fluxnet2015/ENERGY_BALANCE.csv",
                      sep = ",", header = T)
var <- var[var$Tier == 1, ]$Variable
variables <- c(as.character(variables), as.character(var))
  # SOIL_TS
var <- read.csv("~/ownCloud/PROFOUND_Data/Processed/fluxnet2015/SOIL_TS.csv",
                      sep = ",", header = T)
var <- var$Variable
variables <- c(as.character(variables), as.character(var))
  # METEO
var <- read.csv("~/ownCloud/PROFOUND_Data/Processed/fluxnet2015/CLIMATE.csv",
                      sep = ",", header = T)
var <- var$Variable
variables <- c(as.character(variables), as.character(var))
 # ADD TIME STAMPS
variables <- c("TIMESTAMP_START", "TIMESTAMP_END", as.character(variables))
# Add the date


require(plyr)

FLUXNET_raw <- vector("list", length(files_flux))

names(FLUXNET_raw) <- names(files_flux)


for (i in 1:length(files_flux)){
  df_flux <- read.table(files_flux[i], header = T,  sep= ",")
  df_flux <- df_flux[, names(df_flux) %in% variables]
  #hola <- df_flux[, variables]
  #df_flux <- df_flux[, variables]
  #df_flux <- df_flux[, new_names ]
  df_flux[df_flux == -9999] <- NA
  #names(df_flux) <- gsub("_QC$", "_qf", names(df_flux))
  df_flux$date <- strptime(as.character(df_flux$TIMESTAMP_START), format="%Y%m%d%H%M")
  df_flux$year <- as.numeric(format(df_flux$date, format = "%Y"))
  df_flux$mo <-as.numeric(format(df_flux$date, format = "%m"))
  df_flux$day <- as.numeric(format(df_flux$date, format = "%d"))
  df_flux$date <- as.character(df_flux$date)
  df_flux$LE_CORR_QC <- df_flux$H_F_MDS_QC
  df_flux$H_CORR_QC <- df_flux$LE_F_MDS_QC
  #df_flux$TIMESTAMP_START <- NULL
  #df_flux[df_flux == -9999] <- NA
  FLUXNET_raw[[i]] <-  df_flux    
}



save(FLUXNET_raw, file = "~/ownCloud/PROFOUND_Data/Processed/RData/FLUXNET_raw.RData")

### Check data
load("~/ownCloud/PROFOUND_Data/Processed/RData/FLUXNET_raw.RData")
# loadsites
load("~/ownCloud/PROFOUND_Data/Processed/RData/Sites.RData")
# get the  locations
Site <- Sites$name2
Site.id <-  Sites$site_id
names(Site.id) <- Site



for (i in 1:length(FLUXNET_raw)){
  
  file.site <- names(FLUXNET_raw)[i]
  if (file.site  %in% names(Site.id))    FLUXNET_raw[[i]]$site_id <- Site.id[[file.site]]
  FLUXNET_raw[[i]]$site <- file.site

}

save(FLUXNET_raw, file = "~/ownCloud/PROFOUND_Data/Processed/RData/FLUXNET_raw.RData")
##
load("~/ownCloud/PROFOUND_Data/Processed/RData/FLUXNET_raw.RData")
str(FLUXNET_raw,1)

#sink("FLUXNET_raw.txt")
#str(FLUXNET_raw,1)

for (i in 1:length(FLUXNET_raw)){
  for (j in 1:length(variables)){
    if (!variables[j] %in% names(FLUXNET_raw[[i]])){
      FLUXNET_raw[[i]][[variables[j]]] <- NA
    }
  }    
  cat(summary(FLUXNET_raw[[i]]$date))
  cat("\n")
}

save(FLUXNET_raw, file = "~/ownCloud/PROFOUND_Data/Processed/RData/FLUXNET_raw.RData")

#sink()
