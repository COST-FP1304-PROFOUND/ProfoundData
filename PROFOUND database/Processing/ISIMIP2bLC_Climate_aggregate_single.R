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
inDir <- "./ISIMIP_2B_LC/"
# outDir
outDir <- "./Processed/ISIMIP2BLC/"

filenames <- list.files(inDir, full.names=TRUE, recursive = TRUE)

# What we know a priori from the files and what we want to change
forcingDatasets.raw <- c("GFDL-ESM2M", "IPSL-CM5A-LR", "MIROC5", "HadGEM2-ES")
forcingDatasets.new <- c("GFDLESM2M", "IPSLCM5ALR", "MIROC5", "HadGEM2ES")
forcingConditionss.raw <- c("historical", "piControl", "rcp26", "rcp45","rcp60", "rcp85")
forcingConditionss.new <- c("historical", "piControl", "rcp2p6","rcp4p5", "rcp6p0", "rcp8p5")


variables.raw <- c("hurs", "pr", "ps",  "rsds", "sfcWind", "tas", "tasmax", "tasmin")
variables.new <- c("relhum_percent", "p_mm", "airpress_hPa", "rad_Jcm2day", "wind_ms",
                   "tmean_degC", "tmax_degC", "tmin_degC")
names(variables.new) <- variables.raw
sites.raw <-c("BilyKriz", "Brasschaat", "Collelongo", 
              "Hyytiala", "Kroof", "LeBray", "Peitz", "Puechabon", "Solling304",
              "Solling305","Soro")
sites.new <- c("BilyKriz", "Brasschaat", "Collelongo", 
                "Hyytiala", "Kroof", "LeBray", "Peitz", "Puechabon", "Solling_304",
               "Solling_305","Soro")

# The function that binds and writes table function
write.ISIMIP2B.climate <- function(suffix, outName, forcingDataset, forcingConditions, site){
  climateFiles <- paste(variables.raw,"_day_",  suffix, sep="")
  climateFiles <- sapply(climateFiles, function(x){
    dummy <- filenames[grepl(x, filenames)]
    if (length(dummy)> 0){
      names(dummy) <- variables.new[unlist(strsplit(x, "_"))[1]]
    }else{
      dummy <- NA
      names(dummy) <- NA
    }
    return(dummy)
  }, USE.NAMES = F )
  climateFiles <- climateFiles[!is.na(climateFiles)]
  climateFiles <- lapply(1:length(climateFiles),
                         function(x){
                           df <- read.table(climateFiles[x], header = F, col.names = c("Time", names(climateFiles)[x]))
                         })
  climate <- Reduce(function(x, y) merge(x, y, all=TRUE), climateFiles)
  climate$forcingDataset <- forcingDataset
  climate$forcingConditions <- forcingConditions
  climate$site <- site
  climate$date <- as.Date(climate$Time, format =  "%Y-%m-%d")
  climate$Time <- NULL
  climate <- climate[order(climate$date),]
  climate$year <- format(climate$date, "%Y")
  climate$mo <- format(climate$date, "%m")
  climate$day <- format(climate$date, "%d")
  climate$p_mm <- climate$p_mm * 86400 #kg m-2 s-1
  if("airpress_hPa" %in% colnames(climate)){
    climate$airpress_hPa <- climate$airpress_hPa / 100  #Pa
  }else{
    climate$airpress_hPa <- NA
  }
  climate$rad_Jcm2day <-   climate$rad_Jcm2day * (86400 / 10000)  #W m-2
  climate$tmean_degC <- climate$tmean_degC - 273.15 
  climate$tmax_degC <- climate$tmax_degC - 273.15 
  climate$tmin_degC <- climate$tmin_degC - 273.15 
  write.table(climate, file.path(outDir,outName), row.names = F, sep = "\t")
}



# Create the data!!
for (j in 1:length(forcingDatasets.raw)){
  for (i in 1:length(sites.raw)){
   # The target zipfile
#    for (i in 6:length(sites.raw)){
  for (k in 1:length(forcingConditionss.raw)){
     # The suffix for all unzipped file and the output name for the merged file
     suffix <- paste( forcingDatasets.raw[j],"_", forcingConditionss.raw[k], "_r1i1p1_Forests", sites.raw[i], sep="")
     outName <- paste( forcingDatasets.raw[j],"_", forcingConditionss.raw[k], "_", sites.new[i], ".txt", sep="")
     # Call the own merge function and delete zipped files
     write.ISIMIP2B.climate(suffix, outName, forcingDatasets.new[j], forcingConditionss.new[k], sites.new[i] )
   }
 }
}

