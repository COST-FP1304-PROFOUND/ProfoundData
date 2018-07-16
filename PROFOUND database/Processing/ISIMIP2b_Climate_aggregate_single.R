#------------------------------------------------------------------------------#
# ISMIP2B NDEP
#       Organize the single files to aggregate data
#       1. Write a function to merge variables of the same dataset (site + product + scneario)
#           that ouputs the txt file
#       2. Loop over site, product and scenario and feed the function
#       3. 
#
#------------------------------------------------------------------------------#
setwd("/home/ramiro/ownCloud/PROFOUND_Data")
# Read all files
inDir <- "./ISIMIP_2B/CLIMATE/"
# outDir
outDir <- "./Processed/ISIMIP2B/CLIMATE"

filenames <- list.files(inDir, full.names=TRUE, recursive = TRUE)

# What we know a priori from the files and what we want to change
products.raw <- c("GFDL-ESM2M", "IPSL-CM5A-LR", "MIROC5", "HadGEM2-ES")
products.new <- c("GFDLESM2M", "IPSLCM5ALR", "MIROC5", "HadGEM2ES")
scenarios.raw <- c("historical", "piControl", "rcp26", "rcp60")
scenarios.new <- c("historical", "piControl", "rcp2p6","rcp6p0")

variables.raw <- c("hurs", "pr", "ps",  "rsds", "sfcWind", "tas", "tasmax", "tasmin")
variables.new <- c("relhum_percent", "p_mm", "airpress_hPa", "rad_Jcm2day", "wind_ms",
                   "tmean_degC", "tmax_degC", "tmin_degC")
sites.raw <- c("Bily_Kriz", "Brasschaat", "Collelongo", "Espirra", "Hesse", 
                   "Hyytiälä", "Kroof", "Le_Bray", "Peitz", "Puechabon", "Solling",
                   "Soro")

sites.new <- c("BilyKriz", "Brasschaat", "Collelongo", "Espirra", "Hesse", 
                   "Hyytiala", "Kroof", "LeBray", "Peitz", "Solling",
                   "Soro")
# Remove not needed sites
sites.raw <- c("Bily_Kriz", "Collelongo",
               "Hyytiälä", "Kroof", "Le_Bray", "Peitz", "Solling",
               "Soro")
sites.new <- c("BilyKriz",  "Collelongo",
               "Hyytiala", "Kroof", "LeBray", "Peitz", "Solling",
               "Soro")

# The function that binds and writes table function
write.ISIMIP2B.climate <- function(suffix, outName, product, scenario, site){
  climateFiles <- paste("./", variables.raw,"_",  suffix, sep="")
  climateFiles <- lapply(1:length(climateFiles),
                         function(x){
                           filename <- paste("./", variables.raw[x],"_",  suffix, sep="")
                           df <- read.table(filename, header = F, col.names = c("Time", variables.new[x]))
                         })
  climate <- Reduce(function(x, y) merge(x, y, all=TRUE), climateFiles)
  climate$product <- product
  climate$scenario <- scenario
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
 for (j in 1:length(products.raw)){
   # The target zipfile
   zipFile <-  paste(file.path(inDir, paste(sites.raw[i], "_", products.raw[j],  ".zip", sep="")))
   unzippedFiles <- unzip(zipFile)
   for (k in 1:length(scenarios.raw)){
     # The suffix for all unzipped file and the output name for the merged file
     suffix <- paste( products.raw[j],"_", scenarios.raw[k], "_", sites.raw[i], ".txt", sep="")
     outName <- paste( products.raw[j],"_", scenarios.raw[k], "_", sites.new[i], ".txt", sep="")
     # Call the own merge function and delete zipped files
     write.ISIMIP2B.climate(suffix, outName, products.new[j], scenarios.new[k], sites.new[i] )
   }
   sapply(unzippedFiles, file.remove)
 }
}

# New rcp November 2017
scenarios.raw <- c("rcp85", "rcp45")
scenarios.new <- c("rcp8p5","rcp4p5")
# Create the data!!
for (i in 1:length(sites.raw)){
  for (j in 1:length(products.raw)){
    for (k in 1:length(scenarios.raw)){
      # The target zipfile
      zipFile <-  paste(file.path(inDir, paste(sites.raw[i], "_", products.raw[j], "_", scenarios.raw[k],  ".zip", sep="")))
      unzippedFiles <- unzip(zipFile)
      # The suffix for all unzipped file and the output name for the merged file
      suffix <- paste( products.raw[j],"_", scenarios.raw[k], "_", sites.raw[i], ".txt", sep="")
      outName <- paste( products.raw[j],"_", scenarios.raw[k], "_", sites.new[i], ".txt", sep="")
      # Call the own merge function and delete zipped files
      write.ISIMIP2B.climate(suffix, outName, products.new[j], scenarios.new[k], sites.new[i] )
      }
      sapply(unzippedFiles, file.remove)
  }
}

