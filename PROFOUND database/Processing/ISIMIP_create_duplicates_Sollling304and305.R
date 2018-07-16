#------------------------------------------------------------------------------#
# This script does the following:
#       1. Finds all watch+wdfei ISIMIP files
#       2. Deletes from each file years with empty values, namely 2011 and 2012
#       3. Writes out the files replacing original
##------------------------------------------------------------------------------#
# Read all files
inDir <- "/home/trashtos/ownCloud/PROFOUND_Data/Processed/ISI-MIP"
filenames <- list.files(inDir, full.names=TRUE, pattern = "Solling")

for (i in 1:length(filenames)){
  df <- read.table(filenames[i],header = TRUE)
  write.table(df, gsub("Solling", "Solling304", filenames[i]), dec = ".", row.names = FALSE)  
  write.table(df, gsub("Solling", "Solling305", filenames[i]), dec = ".", row.names = FALSE)  
}

