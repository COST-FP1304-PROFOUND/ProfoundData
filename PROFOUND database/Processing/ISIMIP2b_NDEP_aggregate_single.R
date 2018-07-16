#------------------------------------------------------------------------------#
# ISMIP2B NDEP
#       Organize the single files to aggregate data
#
#------------------------------------------------------------------------------#
setwd("/home/ramiro/ownCloud/PROFOUND_Data")
# Read all files
inDir <- "./ISIMIP_2B/NDEP/"
# outDir
outDir <- "./Processed/ISIMIP2B/NDEP/old/"

filenames <- list.files(inDir, full.names=TRUE, recursive = TRUE, pattern = "zip")

# Check first files. Some should have constant values  

for (j in 1:length(filenames)){
  cat("\n");cat("\n");cat(filenames[[j]]);cat("\n"); cat("-------------------------");  cat("\n")
  testFiles <- unzip(filenames[[j]])
  for (i in 1:length(testFiles)){
    dummy <- read.table(testFiles[i], header = F, col.names =  c("Time", "Value"))
    if(max(dummy$Value) == min(dummy$Value)) cat(testFiles[i]);cat("\n")
  }
  
  sapply(testFiles, file.remove)
  
}


par(mfrow = c(4,4))
testFiles <- unzip(filenames[[1]])
for (i in 1:length(testFiles)){
  dummy <- read.table(testFiles[i], header = F, col.names =  c("Time", "Value"))
 # plot(dummy, main = testFiles[i])
}

par(mfrow = c(1,1))

# Files to use
filesOfInterest <- c("ndep_hd_nhx_histsoc_1861-2005.txt", "ndep_hd_noy_histsoc_1861-2005.txt",
                     "ndep_hd_nhx_rcp26soc_2006-2100.txt", "ndep_hd_noy_rcp26soc_2006-2100.txt",
                     "ndep_hd_nhx_rcp60soc_2006-2100.txt", "ndep_hd_noy_rcp60soc_2006-2100.txt")

filesOfInterest <- paste("./", filesOfInterest, sep = "")


writeNDEPfiles <- function(zipFile){
  # get site
  site <- gsub(".zip", "", unlist(strsplit(zipFile, "/") )[length(unlist(strsplit(zipFile, "/") ))])
  site <- gsub("_", "", site)
  site <- gsub("ä", "a", site)
  message(site)
  
  # unlist file
  unzippedFiles <- unzip(zipFile)
  unzippedFiles <- unzippedFiles[unzippedFiles %in% filesOfInterest]
  
  if (length(unzippedFiles) != length(filesOfInterest))stop("Wrong stuff")
  
  nhx <-read.table(filesOfInterest[1], header = F,col.names = c("Time", "nhx_gNm2yr1"))
  noy <- read.table(filesOfInterest[2], header = F,col.names = c("Time", "noy_gNm2yr1"))
  nitro <- merge(nhx, noy, by=c("Time", "Time"))
  nitro$scenario <- "historical"
  nitro$site <- site
  nitro$date <- as.Date(nitro$Time, format =  "%Y-%m-%d")
  nitro$Time <- NULL
  nitro$year <- format(nitro$date, "%Y")
  nitro$mo <- format(nitro$date, "%m")
  nitro$day <- format(nitro$date, "%d")
  nitro <- nitro[order(nitro$date),]
  write.table(nitro, file.path(outDir,paste(site, "_historical", ".txt", sep = "")),
              row.names = F)
  
  nhx <-read.table(filesOfInterest[3], header = F,col.names = c("Time", "nhx_gNm2yr1"))
  noy <- read.table(filesOfInterest[4], header = F,col.names = c("Time", "noy_gNm2yr1"))
  nitro <- merge(nhx, noy, by=c("Time", "Time"))
  nitro$scenario <- "rcp2p6"
  nitro$site <- site
  nitro$date <- as.Date(nitro$Time)
  nitro$year <- format(nitro$date, "%Y")
  nitro$mo <- format(nitro$date, "%m")
  nitro$day <- format(nitro$date, "%d")
  nitro$Time <- NULL
  nitro <- nitro[order(nitro$date),]
  write.table(nitro, file.path(outDir,paste(site, "_rcp2p6", ".txt", sep = "")),
              row.names = F)
  
  nhx <-read.table(filesOfInterest[5], header = F, col.names = c("Time", "nhx_gNm2yr1"))
  noy <- read.table(filesOfInterest[6], header = F, col.names = c("Time", "noy_gNm2yr1"))
  nitro <- merge(nhx, noy, by=c("Time", "Time"))
  nitro$scenario <- "rcp6p0"
  nitro$site <- site
  nitro$date <- as.Date(nitro$Time)
  nitro$year <- format(nitro$date, "%Y")
  nitro$mo <- format(nitro$date, "%m")
  nitro$day <- format(nitro$date, "%d")
  nitro$Time <- NULL
  nitro <- nitro[order(nitro$date),]
  write.table(nitro, file.path(outDir,paste(site, "_rcp6p0", ".txt", sep = "")),
              row.names = F)
  
  sapply(unzippedFiles, file.remove)
  
  
}


lapply(filenames, writeNDEPfiles)
  
# NEw data december 2017
# Read all files
inDir <- "./ISIMIP_2B/NDEP/"
filenames <- list.files(inDir, full.names=TRUE, recursive = TRUE, pattern = "txt")
# outDir
outDir <- "./Processed/ISIMIP2B/NDEP/new/"

sites.raw <-c("Bily_Kriz", "Collelongo", 
              "Hyytiälä", "Kroof", "Le_Bray", "Peitz", "Solling","Soro")
sites.new <- c("BilyKriz", "Collelongo", 
               "Hyytiala", "Kroof", "LeBray", "Peitz",  "Solling_304","Soro")

forcingConditionss.raw <- c("hist", "rcp26", "rcp45","rcp60", "rcp85")
forcingConditionss.new <- c("historical",  "rcp2p6","rcp4p5", "rcp6p0", "rcp8p5")

for (i in 1:length(sites.raw)){
  for (j in 1:length(forcingConditionss.raw)){
    dummy <- paste("ndep_hd_noy_", forcingConditionss.raw[j], "_", sites.raw[i], ".txt", sep="")
    filesOfInterest <- filenames[grepl(dummy, filenames)]
    noy <- read.table(filesOfInterest, header = F,col.names = c("Time", "noy_gNm2yr1"))
    dummy <- paste("ndep_hd_nhx_", forcingConditionss.raw[j], "_", sites.raw[i], ".txt", sep="")
    filesOfInterest <- filenames[grepl(dummy, filenames)]
    nhx <-read.table(filesOfInterest, header = F,col.names = c("Time", "nhx_gNm2yr1"))
    nitro <- merge(nhx, noy, by=c("Time", "Time"))
    nitro$scenario <- forcingConditionss.new[j]
    nitro$site <- sites.new[i]
    nitro$date <- as.Date(nitro$Time, format =  "%Y-%m-%d")
    nitro$Time <- NULL
    nitro$year <- format(nitro$date, "%Y")
    nitro$mo <- format(nitro$date, "%m")
    nitro$day <- format(nitro$date, "%d")
    nitro <- nitro[order(nitro$date),]
    write.table(nitro, file.path(outDir,paste( sites.new[i],"_", forcingConditionss.new[j], ".txt", sep = "")),
                row.names = F)
    
    }
}
# Test
df1 <- read.table("/home/ramiro/ownCloud/PROFOUND_Data/Processed/ISIMIP2B/NDEP/new/BilyKriz_historical.txt",
                  header = T)
df2 <- read.table("/home/ramiro/ownCloud/PROFOUND_Data/Processed/ISIMIP2B/NDEP/old/BilyKriz_historical.txt",
                  header = T)
identical(df1, df2)
head(df1)
head(df2)
