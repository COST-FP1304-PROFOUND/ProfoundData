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
inDir <- "./ISI-MIP_Climate_input/"
# outDir
outDir <- "./Processed/ISIMIP2A/"

filenames <- list.files(inDir, full.names=TRUE, recursive = TRUE)




# What we know a priori from the files and what we want to change
products.rawfiles <- c("gswp3", "watch", "watch+wfdei", "pgfv2.1")
products.raw <- c("GSWP3", "WATCH", "WATCH+WFDEI", "PGFv2.1")
products.new <- c("GSWP3", "WATCH", "WATCHWFDEI", "PRINCETON")



variables.raw <- c("rhs", "pr", "ps",  "rsds", "wind", "tas", "tasmax", "tasmin")
variables.new <- c("relhum_percent", "p_mm", "airpress_hPa", "rad_Jcm2day", "wind_ms",
                   "tmean_degC", "tmax_degC", "tmin_degC")
sites.raw <- c("Bily_Kriz", "Brasschaat", "Collelongo", "Espirra", "Hesse", 
                   "Hyytiälä", "Kroof", "Le_Bray", "Peitz", "Puechabon", "Solling",
                   "Soro")
sites.new <- c("BilyKriz", "Brasschaat", "Collelongo", "Espirra", "Hesse", 
                   "Hyytiala", "Kroof", "LeBray", "Peitz", "Puechabon", "Solling",
                   "Soro")

# The function that binds and writes table function
write.ISIMIP2A.climate <- function(suffix, outName, product, site){
  climateFiles <- paste("./", variables.raw,"_",  suffix, sep="")
  
  climateFiles <- lapply(1:length(climateFiles),
                         function(x){
                           filename <- paste("./", variables.raw[x],"_",  suffix, sep="")
                           df <- read.table(filename, header = F, col.names = c("Time", variables.new[x]))
                         })
  climate <- Reduce(function(x, y) merge(x, y, all=TRUE), climateFiles)
  climate$product <- product
  climate$site <- site
  climate$date <- as.Date(climate$Time, format =  "%Y-%m-%d")
  climate$Time <- NULL
  climate <- climate[order(climate$date),]
  climate$year <- format(climate$date, "%Y")
  climate$mo <- format(climate$date, "%m")
  climate$day <- format(climate$date, "%d")
  if (product == "WATCHWFDEI"){
    #Deletes from each file years with empty values, namely 2011 and 2012
    climate <- climate[climate$year < 2011, ]
    climate$product <- "WFDEI"
    
  }
  write.table(climate, file.path(outDir,outName), row.names = F)
}


  # Create the data!!
  for (i in 1:length(sites.raw)){
   for (j in 1:length(products.raw)){
     # The target zipfile
     zipFile <-  paste(file.path(inDir, paste(sites.raw[i], "_", products.raw[j],  ".zip", sep="")))
     unzippedFiles <- unzip(zipFile)
     # The suffix for all unzipped file and the output name for the merged file
     suffix <- paste( products.rawfiles[j], "_", sites.raw[i], ".txt", sep="")
     outName <- paste( products.raw[j], "_", sites.new[i], ".txt", sep="")
     # Call the own merge function and delete zipped files
     
     dummy <- try(write.ISIMIP2A.climate(suffix, outName, products.new[j], sites.new[i] ), silent = T)
     if(class(dummy) == "try-error"){
       suffix <- paste( products.raw[j], "_", sites.raw[i], ".txt", sep="")
       dummy <- try(write.ISIMIP2A.climate(suffix, outName, products.new[j], sites.new[i] ), silent = T)
       if(class(dummy) == "try-error") stop("You are missing something!!")
     }
     sapply(unzippedFiles, file.remove)
   }
  }

