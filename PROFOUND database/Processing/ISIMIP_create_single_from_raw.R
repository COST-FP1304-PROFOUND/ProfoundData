##########################################
# ISI-MIP data
#     This script does the following:
#       1. Finds and unzip all ISI-MIP dataset, output is list of lists
#       2. Opens a connection to a SQL DB
#       3. Reads and processes data by location, storing the data in the DB
#       4. Closes DB connection and deletes unzipped files
#         
#########################################
library(reshape2)

# Read all zip files
inDir = "/home/trashtos/ownCloud/PROFOUND_Data/ISI-MIP_Climate_input/" # path to the zip files
pattern = "*.zip"
filenames <- list.files(inDir, pattern=pattern, full.names=TRUE, recursive = TRUE)
# Unzip all files
unzippedFiles <- lapply(filenames, unzip) #
# I dont set a working directory because I work with full pahts, and if relative paths, 
# I use file.path  to join with my reference dir "inDir". 
# The unzipped files go to wherever you have your working directory, 
# they are temporal and you can delete them afterwards.

# Now do some check 
# All locations have same amount files, 21 locations
# get locations
locations <- list.files(inDir)
  # just checking
cat (length(unzippedFiles) /9)


# Loop over data and to DB ###############
# outDir
outDir <- "/home/trashtos/ownCloud/PROFOUND_Data/Christopher"


# Loop over files adds data to DB, could also add it to list and then do.call(rbind, listDf)
for (i in 1:length(unzippedFiles)){
#for (i in 1:2){
  
  # Case 1: only two files per location
  if ( length(unzippedFiles[[i]]) == 8 ){
    data <- lapply(unzippedFiles[[i]], function(x) {
      df <- read.table(x, header = FALSE, sep = "",  col.names = c("Date", "Value"), colClasses = c("character", "numeric"))
      df$Variable <- sub( "./", "", strsplit(x, "_")[[1]][1])
      df$RCP <- "none"
      return(df)
    })
    data.all <- do.call("rbind",data)
    data.all <- dcast(data.all, Date + RCP ~ Variable, value.var = "Value", fun = mean)
    data.all$Day <- apply(data.all, 1, function(x){strsplit(x, "-")[[1]][3]})
    data.all$Month <- apply(data.all, 1, function(x){strsplit(x, "-")[[1]][2]})
    data.all$Year <- apply(data.all, 1, function(x){strsplit(x, "-")[[1]][1]})
    rm(data) # only to keep RAM low
    data.all$GCM  <- strsplit(unzippedFiles[[i]], "_")[[1]][2], length(data.all$Date) 
    # set the location and if Le_Bray, add Bray to have LeBray
    location <- sub( ".txt", "", strsplit(unzippedFiles[[i]], "_")[[1]][3])
    if(grepl("^Le$", location) ==TRUE){
      location <- paste(location, "Bray", sep = "")
    }else if(grepl("^Alice$", location) ==TRUE){
      location <- paste(location, "Holt", sep = "")
    }else if(grepl("^Bily$", location) ==TRUE){
      location <- paste(location, "Kriz", sep = "")
    }else if(grepl("^Hyy", location) ==TRUE){
      location <-"Hyytiala"}
    data.all$Location <- rep (location, length(data.all$Date) )
    data.all <- data.all[,c("Location", "GCM", "RCP", "Date", "Day", "Month", "Year", "tasmax",
                            "tas", "tasmin", "pr",  "rhs",  "ps", "rsds",  "wind")]
    gcm <- unique(data.all$GCM)
    rcps <- unique(data.all$RCP)
    # print out the information to check whether everything is alright
    cat("\n________________________________________________________\n")
    cat(unique(data.all$Location))
    cat("\n")
    cat(gcm)
    cat("\n")    
    for( j in 1:length(rcps)){
      cat(paste(rcps[j], " "))
      df <- subset( data.all, RCP==rcps[j], select = names(data.all)[c(5:15)])
      for (i in 1:3){df[,i]<-as.numeric(df[,i])}
      names(df) <- c("day",  "mo",  "year",  "tmax",  "tmean",  "tmin",	"p", 	"relhum",	"air_press",	"rad",	"wind")
      write.table(df, file = file.path(outDir,
                                       paste(location, "_",gcm,"_", rcps[j], ".txt", sep = "")),
                                       dec = ".", row.names = FALSE)
    }
    cat("\n")
    rm(data.all) # only to keep RAM low
    
    # Case 2: forty files per location
  }else if (length(unzippedFiles[[i]]) == 40){
    data <- lapply(unzippedFiles[[i]], function(x) {
      df <- read.table(x, header = FALSE, sep = "",  col.names = c("Date", "Value"), colClasses = c("character", "numeric"))
      df$Variable <- rep(sub( "./", "", strsplit(x, "_")[[1]][1]),  length(df$Date))
      df$RCP <- rep(strsplit(x, "_")[[1]][3], length(df$Date) )      
      return(df)
    })
    data.all <- as.data.frame(do.call("rbind",data))
    data.all <- dcast(data.all, Date + RCP ~ Variable, value.var = "Value", fun = mean)
    data.all$Day <- apply(data.all, 1, function(x){strsplit(x, "-")[[1]][3]})
    data.all$Month <- apply(data.all, 1, function(x){strsplit(x, "-")[[1]][2]})
    data.all$Year <- apply(data.all, 1, function(x){strsplit(x, "-")[[1]][1]})
    rm(data) # only to keep RAM low
    data.all$GCM  <- rep(strsplit(unzippedFiles[[i]], "_")[[1]][2], length(data.all$Date) )
    # set the location and if Le_Bray, add Bray to have LeBray
    location <- sub( ".txt", "", strsplit(unzippedFiles[[i]], "_")[[1]][4])
    if(grepl("^Le$", location) ==TRUE){
      location <- paste(location, "Bray", sep = "")
    }else if(grepl("^Alice$", location) ==TRUE){
      location <- paste(location, "Holt", sep = "")
    }else if(grepl("^Bily$", location) ==TRUE){
      location <- paste(location, "Kriz", sep = "")
    }else if(grepl("^Hyy", location) ==TRUE){
      location <-"Hyytiala"}    
    data.all$Location <- rep (location, length(data.all$Date) )
    data.all <- data.all[,c("Location", "GCM", "RCP", "Date", "Day", "Month", "Year", "tasmax",
                               "tas", "tasmin", "pr",  "rhs",  "ps", "rsds",  "wind")]
    gcm <- unique(data.all$GCM)
    rcps <- unique(data.all$RCP)
    # print out the information to check whether everything is alright
    cat("\n________________________________________________________\n")
    cat(unique(data.all$Location))
    cat("\n")
    cat(gcm)
    cat("\n")
    for( j in 1:length(rcps)){
      cat(paste(rcps[j], " "))
      df <- subset( data.all, RCP==rcps[j], select = names(data.all)[c(5:15)])
      for (i in 1:3){df[,i]<-as.numeric(df[,i])}
      names(df) <- c("day",  "mo",  "year",  "tmax",  "tmean",	"tmin",	"p", 	"relhum",	"air_press",	"rad",	"wind")
      write.table(df, file = file.path(outDir,
                                       paste(location, "_",gcm,"_", rcps[j], ".txt", sep = "")),
                                       dec = ".", row.names = FALSE)
    }
    cat("\n")
    rm(data.all)# only to keep RAM low 
  }else{
    # If not case 1 or 2, there must be an error
    print(length(unzippedFiles[[i]]))
    cat("There was en error. Check out the list at the end")
    
  }
}

# Delete unzipped files
do.call ("file.remove", list(unlist(unzippedFiles)))


  
  