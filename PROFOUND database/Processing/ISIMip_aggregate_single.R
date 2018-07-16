#------------------------------------------------------------------------------#
# ISI-MIP data:
#       Organize the single files to aggregate data
#
#------------------------------------------------------------------------------#
# Read all files
inDir <- "/home/trashtos/ownCloud/PROFOUND_Data/Processed/ISI-MIP"
filenames <- list.files(inDir, full.names=TRUE, recursive = TRUE)

# outDir
outDir <- "/home/trashtos/ownCloud/PROFOUND_Data/Christopher"

# Criteria
GCM <- c("GFDL-ESM2M", "HadGEM2-ES", "IPSL-CM5A-LR", "MIROC-ESM-CHEM","NorESM1-M")
ForcingDatasets <- c( "GSWP3", "pgfv2.1", "watch+wfdei", "watch")
rename <-c("pgfv2.1", "pgv2")
# For GCM we have the rcsp and historical
historical <- c("historical")
rcp <-c("rcp2p6", "rcp4p5", "rcp6p0", "rcp8p5")
# We want to rcp together with historical

location.grep <- function(x){
  tmp <- unlist(strsplit(unlist(strsplit(x, "/"))[8], "_"))[1]
  return(tmp)
}
locations <- lapply(filenames, location.grep)
locations <- unique(unlist(locations))

# Easiest way is to pack files first, becasue files are systematically  named
dummy.GCM <- vector("list", length(GCM))
names(dummy.GCM) <- GCM

dummy.rcp <- vector("list", length(rcp))
names(dummy.rcp) <- rcp

dummy.locations <- list(location = NULL, ForcingDatasets = NULL, GCM = dummy.GCM)

locations.files <- vector("list", length(locations))
for (i in 1:length(locations)){
  dummy.locations$ForcingDatasets <- file.path(inDir, paste(locations[i], ForcingDatasets, "none.txt", sep = "_" ))

  for (j in 1:length(GCM)){
    dummy.GCM[[j]] <- c( file.path(inDir, paste(locations[i], GCM[j], paste(rcp, ".txt", sep =""), sep = "_" )),
                     file.path(inDir, paste(locations[i], GCM[j],  "historical.txt", sep = "_" )))
  }
  dummy.locations$GCM <- dummy.GCM
  dummy.locations$location <- locations[i]
  locations.files[[i]] <- dummy.locations
}

#------------------------------------------------------------------------------#
#                    CREATE THE NEW FILES
#------------------------------------------------------------------------------#

write.table.ISIMPIP <- function(location, outDir){
  lapply(location$ForcingDatasets, function(x) {
    df <- read.table(x, header = TRUE, sep = "")
    observed <- unlist(strsplit(unlist(strsplit(x, "/"))[8], "_"))[2]
    if (observed =="pgfv2.1"){
      observed <- "pgfv2"
    }
    write.table(df,
                file = file.path(outDir, paste(location$location, "_", observed,".txt", sep = "")),
                dec = ".", row.names = FALSE)
    #df$observed <-unlist(strsplit(unlist(strsplit(x, "/"))[8], "_"))[2]
    #return(df)
  })
  #data <- do.call(rbind, data)
  #write.table(data,
  #            file = file.path(outDir, paste(location$location, "_observed.txt", sep = "")),
  #            dec = ".", row.names = FALSE)
  #rm(data)
  # GCM
  for(i in 1:length(location$GCM)){
    historical <- location$GCM[[i]][grepl("historical", location$GCM[[i]])]
    historical.data <- read.table(historical, header = TRUE, sep = "")
    historical.data$rcp <- "historical"
    # the others
    rcp.files <- location$GCM[[i]][!grepl("historical", location$GCM[[i]])]
    for (j in 1:length(rcp.files)){
      tmp <- gsub(".txt", "", unlist(strsplit(unlist(strsplit(rcp.files[j], "/"))[8], "_"))[3])
      rcp.data <- read.table(rcp.files[j], header = TRUE, sep = "")
      rcp.data$rcp <- tmp
      rcp.data <- rbind(historical.data, rcp.data)
      write.table(rcp.data, file = file.path(outDir,
                                             paste(location$location, "_", names(location$GCM)[i],"_", tmp, ".txt", sep = "")),
                  dec = ".", row.names = FALSE)
    }
  }
}

for (i  in 1:length(locations.files)){
  write.table.ISIMPIP(locations.files[[i]],  outDir)
}



