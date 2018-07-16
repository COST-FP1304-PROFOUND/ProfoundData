#------------------------------------------------------------------------------#
# ISMIP2A
#
#------------------------------------------------------------------------------#
setwd("/home/ramiro/ownCloud/PROFOUND_Data")
# Read all files
inDir <- "./ISI-MIP_Climate_input/"
# outDir
outDir <- "./Processed/ISIMIP2A/"

filenames <- list.files(inDir, full.names=TRUE, recursive = TRUE)




# What we know a priori from the files and what we want to change
forcingDatasets.rawfiles <- c("GSWP3", "watch", "watch+wfdei", "pgfv2.1")
forcingDatasets.raw <- c("GSWP3", "WATCH", "WATCH+WFDEI", "PGFv2.1")
forcingDatasets.new <- c("GSWP3", "WATCH", "WATCHWFDEI", "PRINCETON")



variables.raw <- c("rhs", "pr", "ps",  "rsds", "wind", "tas", "tasmax", "tasmin")
variables.new <- c("relhum_percent", "p_mm", "airpress_hPa", "rad_Jcm2day", "wind_ms",
                   "tmean_degC", "tmax_degC", "tmin_degC")
sites.raw <- c("Bily_Kriz", #"Brasschaat", 
               "Collelongo", #"Espirra", "Hesse", 
                "Hyytiälä", "Kroof", "Le_Bray", "Peitz", #"Puechabon", 
               "Solling", "Soro")
sites.new <- c("BilyKriz", #"Brasschaat", 
               "Collelongo", #"Espirra", "Hesse", 
                "Hyytiala", "Kroof", "LeBray", "Peitz", #"Puechabon", 
               "Solling","Soro")

# The function that binds and writes table function
write.ISIMIP2A.climate <- function(suffix, outName, forcingDataset, site){
  climateFiles <- paste("./", variables.raw,"_",  suffix, sep="")
  
  climateFiles <- lapply(1:length(climateFiles),
                         function(x){
                           filename <- paste("./", variables.raw[x],"_",  suffix, sep="")
                           df <- read.table(filename, header = F, col.names = c("Time", variables.new[x]))
                         })
  climate <- Reduce(function(x, y) merge(x, y, all=TRUE), climateFiles)
  climate$forcingDataset <- forcingDataset
  climate$site <- site
  climate$date <- as.Date(climate$Time, format =  "%Y-%m-%d")
  climate$Time <- NULL
  climate <- climate[order(climate$date),]
  climate$year <- format(climate$date, "%Y")
  climate$mo <- format(climate$date, "%m")
  climate$day <- format(climate$date, "%d")
  if (forcingDataset == "WATCHWFDEI"){
    #Deletes from each file years with empty values, namely 2011 and 2012
    climate <- climate[climate$year < 2011, ]
    climate$forcingDataset <- "WFDEI"
    
  }
  write.table(climate, file.path(outDir,outName), row.names = F)
}


# Create the data!!
for (i in 1:length(sites.raw)){
   for (j in 1:length(forcingDatasets.raw)){
     # The target zipfile
     zipFile <-  paste(file.path(inDir, paste(sites.raw[i], "_", forcingDatasets.raw[j],  ".zip", sep="")))
     unzippedFiles <- unzip(zipFile)
     # The suffix for all unzipped file and the output name for the merged file
     suffix <- paste( forcingDatasets.rawfiles[j], "_", sites.raw[i], ".txt", sep="")
     outName <- paste( forcingDatasets.raw[j], "_", sites.new[i], ".txt", sep="")
     # Call the own merge function and delete zipped files
     
     dummy <- try(write.ISIMIP2A.climate(suffix, outName, forcingDatasets.new[j], sites.new[i] ), silent = T)
     if(class(dummy) == "try-error"){
       suffix <- paste( forcingDatasets.raw[j], "_", sites.raw[i], ".txt", sep="")
       dummy <- try(write.ISIMIP2A.climate(suffix, outName, forcingDatasets.new[j], sites.new[i] ), silent = T)
       if(class(dummy) == "try-error") stop("You are missing something!!")
     }
     sapply(unzippedFiles, file.remove)
   }
  }

