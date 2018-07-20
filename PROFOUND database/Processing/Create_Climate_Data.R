#------------------------------------------------------------------------------#
#                               CLIMATE DATA
#------------------------------------------------------------------------------#
# Climate data is available for:
#       Kroof
#       Peitz
#       Solling
# It mus be derived from FLUXNET for:
#       Braaschat
#       BilyKriz
#       Hyytiala
#       Soro
#       Puechabon
# It must be derived from FLUX level 3 and 4 for:
#       LeBray


#------------------------------------------------------------------------------#

myDir <- "~/ownCloud/PROFOUND_Data/Processed/"
setwd(myDir)

# Load  the processed other data
otherData <- "./RData/ProfoundOtherData.new.RData"
Kroof <- "./Kroof/climdata_for_database_kroof.txt"
load(otherData)
load("./RData/FLUXNET_Climate.RData")
load("./RData/FLUX34_meteo.RData")
# Structre
str(ProfoundOtherData.new,1)

# Create Climate data
Climate_Data <- list()

#------------------------------------------------------------------------------#
# Add already formatted data
#------------------------------------------------------------------------------#
# Kroof
df <- read.table(Kroof, sep = "\t", header = TRUE)
head(df)
summary(df)


names(df)<-c("day", "mo", "year", "tmax_degC", "tmean_degC", "tmin_degC",  "p_mm",
             "relhum_percent","airpress_hPa", "rad_Jcm2day",  "wind_ms")
df$date <- as.Date(strptime(paste(df$year, df$mo, df$day,sep=""), format="%Y%m%d%"))
Climate_Data$Kroof <-df
# Peitz
str(ProfoundOtherData.new$Peitz$ClimateData,1)
summary(ProfoundOtherData.new$Peitz$ClimateData)
# drop CID
Climate_Data$Peitz <-ProfoundOtherData.new$Peitz$ClimateData[,2:ncol(ProfoundOtherData.new$Peitz$ClimateData)]
names(Climate_Data$Peitz)
names(Climate_Data$Peitz) <- c("day", "mo", "year", "tmax_degC", "tmean_degC", "tmin_degC",
                               "p_mm", "relhum_percent","airpress_hPa", "rad_Jcm2day",
                               "wind_ms")
Climate_Data$Peitz$date <- as.Date(strptime(paste(Climate_Data$Peitz$year,
                                                  Climate_Data$Peitz$mo,
                                                  Climate_Data$Peitz$day,sep=""), format="%Y%m%d%"))
# Solling 304
str(ProfoundOtherData.new$Solling304$ClimateData,1)
Climate_Data$Solling_304 <- ProfoundOtherData.new$Solling304$ClimateData
Climate_Data$Solling_304[,] <- lapply(Climate_Data$Solling_304[,], as.character)
Climate_Data$Solling_304[,] <- lapply(Climate_Data$Solling_304[,], as.numeric)

names(Climate_Data$Solling_304)
names(Climate_Data$Solling_304) <- c("tmin_degC", "tmax_degC", "tmean_degC",
                                      "p_mm", "relhum_percent", "rad_Jcm2day",
                                     "wind_ms", "day", "mo", "year")

Climate_Data$Solling_304$rad_Jcm2day <- Climate_Data$Solling_304$rad_Jcm2day * (60*60*24)/10000
Climate_Data$Solling_304$date <- as.Date(strptime(paste(Climate_Data$Solling_304$year, 
                                                        Climate_Data$Solling_304$mo,
                                                        Climate_Data$Solling_304$day,sep=""), format="%Y%m%d%"))

# Solling 305
Climate_Data$Solling_305 <- Climate_Data$Solling_304







#------------------------------------------------------------------------------#
#   Add sites and check variables
#------------------------------------------------------------------------------#
# Target variables

# Get sites
load("./RData/Sites.RData")
# get the  locations
Site <- Sites$site2
Site.id <-  Sites$site_id
names(Site.id) <- Site
# variables to round

variables.round <- c("tmax_degC","tmean_degC", "tmin_degC", "p_mm", "relhum_percent", "airpress_hPa",
             "rad_Jcm2day", "wind_ms")

# Homogenize variables and add Site names and ID
for (i in  1:length(Climate_Data)){
  for (k in 1:length(variables.round)){
    if (variables.round[k] %in% names(Climate_Data[[i]]) == FALSE) {
      Climate_Data[[i]][[variables.round[k]]] <- NA
    }
  }
  for (k in 1:length(variables.round)){
    if (sum(Climate_Data[[i]][[variables.round[k]]], na.rm = TRUE)!=0){
      Climate_Data[[i]][[variables.round[k]]] <-   round( Climate_Data[[i]][[variables.round[k]]], 3)
    }
    

  }

  
  Climate_Data[[i]]$site <- names(Climate_Data)[i]
  Climate_Data[[i]]$site_id <- Site.id[[names(Climate_Data)[i]]]
  Climate_Data[[i]]$date <- as.character(strptime(paste(as.character(Climate_Data[[i]]$year), as.character(Climate_Data[[i]]$mo),
                                                        as.character(Climate_Data[[i]]$day), sep = " "),format="%Y %m %d")) # nerver put posixt objects into dataframes
  cat("\n")
  cat(names(Climate_Data[[i]]))
  cat("\n")
  cat(rep("*", 30))
  cat("\n")
}
#------------------------------------------------------------------------------#
save(Climate_Data, file="./RData/Climate_Data.RData")

### Check data
load("./RData/Climate_Data.RData")

for (i in 1:length(Climate_Data)){
  Climate_Data[[i]]$relhum_percent  <- ifelse(Climate_Data[[i]]$relhum_percent > 100, 100,
                                              ifelse(Climate_Data[[i]]$relhum_percent < 0, 0, Climate_Data[[i]]$relhum_percent))
}
save(Climate_Data, file="./RData/Climate_Data.RData")

str(Climate_Data,1)

#sink("./RData/Climate_Data.txt")
#str(Climate_Data)
#sink()

