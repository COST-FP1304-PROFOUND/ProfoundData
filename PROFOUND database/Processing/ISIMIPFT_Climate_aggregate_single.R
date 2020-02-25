#------------------------------------------------------------------------------#
# ISMIP2B NDEP
#       Organize the single files to aggregate data
#       1. Write a function to merge variables of the same dataset (site + forcingDataset + scneario)
#           that ouputs the txt file
#       2. Loop over site, forcingDataset and forcingConditions and feed the function
#       3. 
#
#------------------------------------------------------------------------------#
setwd("/home/ramiro/ownCloud/PROFOUND_Data")
# Read all files
inDir <- "./ISI-MIP_Climate_input/"
# outDir
outDir <- "./Processed/ISIMIPFT/"

filenames <- list.files(inDir, full.names=TRUE, recursive = TRUE)

# What we know a priori from the files and what we want to change
forcingDatasets.raw <- c("GFDL-ESM2M", "HadGEM2-ES", "IPSL-CM5A-LR", "MIROC-ESM-CHEM", "NorESM1-M" )
forcingDatasets.new <- c("GFDLESM2M", "HadGEM2ES", "IPSLCM5ALR", "MIROCESMCHEM", "NorESM1M" )
forcingConditions.raw <- c("historical", "rcp2p6", "rcp4p5", "rcp6p0","rcp8p5" )
forcingConditions.new <-forcingConditions.raw 

variables.raw <- c("rhs", "pr", "ps",  "rsds", "wind", "tas", "tasmax", "tasmin")
variables.new <- c("relhum_percent", "p_mm", "airpress_hPa", "rad_Jcm2", "wind_ms",
                   "tmean_degC", "tmax_degC", "tmin_degC")
sites.raw <- c("Bily_Kriz", "Brasschaat", "Collelongo", "Espirra", "Hesse", 
                   "Hyytiälä", "Kroof", "Le_Bray", "Peitz", "Puechabon", "Solling",
                   "Soro")
sites.new <- c("BilyKriz", "Brasschaat", "Collelongo", "Espirra", "Hesse", 
                   "Hyytiala", "Kroof", "LeBray", "Peitz", "Puechabon", "Solling",
                   "Soro")

# The function that binds and writes table function
write.ISIMIPFT.climate <- function(suffix, outName, forcingDataset, forcingCondition, site){
  climateFiles <- paste("./", variables.raw,"_",  suffix, sep="")
  climateFiles <- lapply(1:length(climateFiles),
                         function(x){
                           filename <- paste("./", variables.raw[x],"_",  suffix, sep="")
                           df <- read.table(filename, header = F, col.names = c("Time", variables.new[x]))
                         })
  climate <- Reduce(function(x, y) merge(x, y, all=TRUE), climateFiles)
  climate$forcingDataset <- forcingDataset
  climate$forcingCondition <- forcingCondition
  climate$site <- site
  climate$date <- as.Date(climate$Time, format =  "%Y-%m-%d")
  climate$Time <- NULL
  climate <- climate[order(climate$date),]
  climate$year <- format(climate$date, "%Y")
  climate$mo <- format(climate$date, "%m")
  climate$day <- format(climate$date, "%d")

  write.table(climate, file.path(outDir,outName), row.names = F)
}


# Create the data!!
for (i in 1:length(sites.raw)){
 for (j in 1:length(forcingDatasets.raw)){
   # The target zipfile
   zipFile <-  paste(file.path(inDir, paste(sites.raw[i], "_", forcingDatasets.raw[j],  ".zip", sep="")))
   unzippedFiles <- unzip(zipFile)
   for (k in 1:length(forcingConditions.raw)){
     # The suffix for all unzipped file and the output name for the merged file
     suffix <- paste( forcingDatasets.raw[j],"_", forcingConditions.raw[k], "_", sites.raw[i], ".txt", sep="")
     outName <- paste( forcingDatasets.raw[j],"_", forcingConditions.raw[k], "_", sites.new[i], ".txt", sep="")
     # Call the own merge function and delete zipped files
     write.ISIMIPFT.climate(suffix, outName, forcingDatasets.new[j], forcingConditions.new[k], sites.new[i] )
   }
   sapply(unzippedFiles, file.remove)
 }
}

