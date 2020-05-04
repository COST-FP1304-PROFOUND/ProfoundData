##########################################################
# This script goes through the Profound data, as "it is", 
# after downloading and extracting. In few speficic cases,
# file have been modified (large excel books) before reading in R. 
# 
# Scritp follows the phsysic structure of the data. 
#     1. Demmark 
#     2. Finland
#     3. France
#     4. Germany
#     5. Level 2
#     6. ISI-MIP_Climate_input
#
##########################################################
# Load utility functions
source("/home/trashtos/GitHub/PROFOUND-Code/Data/processsing/utilities.R")

##########################################################
summaryFile = "/home/trashtos/GitHub/PROFOUND-Code/Data/processsing/summary.txt"
# Open document
sink(summaryFile)
########################## Dennmark ######################
inDir = "/home/trashtos/GitHub/PROFOUND_Data/Denmark"
cat( "1. Demmark Data\n\n")
files = list.files(inDir, pattern ="*.txt", full.names=TRUE)
cat( "    1.1. Level 2\n\n")
## Level 2
subFiles =files[grepl("L2", files )]
# the unique variables:
uniqueVariables <-findVariables(subFiles) 
# print them out
for (i in 1:length (uniqueVariables)){
  cat(paste("       - ", uniqueVariables[i],"\n", sep = ""))
}
## Level 3 and Level 4 
# The other levels
files = list.files(inDir, pattern ="*.zip", full.names=TRUE)
cat("\n")
cat( "    1.2. Level 3\n\n")
## Level 3 
subFiles =files[grepl("L3", files )]
# unzip files
unzippedFiles <- unlist(lapply(subFiles, unzip))
# get the txt files () can do matrix, up to you.)
subFiles =unzippedFiles[grepl("*.txt", unzippedFiles )]
# the unique variables:
uniqueVariables <-findVariables(subFiles) 
# print them out
for (i in 1:length (uniqueVariables)){
  cat(paste("       - ", uniqueVariables[i],"\n", sep = ""))
}
## Level 4 
cat("\n")
cat( "    1.3. Level 4\n\n")
subFiles =files[grepl("L4", files )]
# unzip files
unzippedFiles <- unlist(lapply(subFiles, unzip))
# get the txt files () can do matrix, up to you.)
subFiles =unzippedFiles[grepl("*.txt", unzippedFiles )]
# select by time step
cat( "         1.3.1. Level 4: hourly data\n\n")
subFiles.hour = subFiles[grepl("_h_", subFiles )]
uniqueVariables <-findVariables(subFiles.hour ) 
# print them out
for (i in 1:length (uniqueVariables)){
  cat(paste("         - ", uniqueVariables[i],"\n", sep = ""))
}
# select by time step
cat( "         1.3.2. Level 4: daily data\n\n")
subFiles.day = subFiles[grepl("_d_", subFiles )]
uniqueVariables <-findVariables(subFiles.day ) 
# print them out
for (i in 1:length (uniqueVariables)){
  cat(paste("         - ", uniqueVariables[i],"\n", sep = ""))
}
cat("\n")
# select by time step
cat( "         1.3.3. Level 4: weekly data\n\n")
subFiles.week = subFiles[grepl("_w_", subFiles )]
uniqueVariables <-findVariables(subFiles.week ) 
# print them out
for (i in 1:length (uniqueVariables)){
  cat(paste("         - ", uniqueVariables[i],"\n", sep = ""))
}
cat("\n")
# select by time step
cat( "         1.3.4. Level 4: monthly data\n\n")
subFiles.month = subFiles[grepl("_m_", subFiles )]
uniqueVariables <-findVariables(subFiles.month ) 
# print them out
for (i in 1:length (uniqueVariables)){
  cat(paste("         - ", uniqueVariables[i],"\n", sep = ""))
}



########################## Finland ##########################
inDir = "/home/trashtos/GitHub/PROFOUND_Data/Finland"
cat("\n")
cat( "2. Finland\n\n")
cat( "    2.1. Vegetation Data 2\n\n")
# Find and fead the xlsx:there is only one for vegetation
files = list.files(inDir, pattern ="*.xlsx", full.names=TRUE)
# read the book
dataBook <- read.XLSX(files)
# remove non useful names 
names(dataBook[[1]]) <- NULL

# First Page #
sheet <- dataBook[[1]]
# first table 
cat(paste( "          2.1.1",  sheet[2,1], "Data\n\n", sep = " "))
variables <- vector("character", length(sheet[2,]))
for (i in 1:length(variables)){
  if (!is.na(sheet[2,i])){
    variables[[i]] <-paste(sheet[2,i], sheet[3,i], sep=" ")
  }else{
    variables[[i]]  <-as.character(sheet[3,i])
  }
}
# print them out
for (i in 1:length (variables)){
  cat(paste("              - ", variables[i],"\n", sep = ""))
}
# second table
cat("\n")
cat(paste( "          2.1.2",  sheet[23,1], "Data\n\n", sep = " "))
variables <- vector("character", length(sheet[23,]))
for (i in 1:length(variables)){
  if (!is.na(sheet[23,i])){
    variables[[i]] <-paste(sheet[23,i], sheet[24,i], sep=" ")
  }else{
    variables[[i]]  <-as.character(sheet[24,i])
  }
}
# print them out
for (i in 1:length (variables)){
  cat(paste("              - ", variables[i],"\n", sep = ""))
}
# third table 
cat("\n")
cat(paste( "          2.1.3",  sheet[43,1], "Data\n\n", sep = " "))
cat(space)
variables <- vector("character", length(sheet[43,]))
for (i in 1:length(variables)){
  if (!is.na(sheet[43,i])){
    variables[[i]] <-paste(sheet[43,i], sheet[44,i], sep=" ")
  }else{
    variables[[i]]  <-as.character(sheet[44,i])
  }
}
# print them out
for (i in 1:length (variables)){
  cat(paste("              - ", variables[i],"\n", sep = ""))
}

# Second Page #
sheet <- dataBook[[2]]
# first table 
cat("\n")
varnames <- names(sheet)
cat(paste( "          2.1.4",  varnames[1], "Data\n\n", sep = " "))
cat(space)
variables <- vector("character", length(varnames))
for (i in 1:length(variables)){
  if (!is.na(varnames[i])){
    variables[[i]] <-paste(varnames[i], sheet[1,i], sep=" ")
  }else{
    variables[[i]]  <-as.character(sheet[1,i])
  }
}
# print them out
for (i in 1:length (variables)){
  cat(paste("              - ", variables[i],"\n", sep = ""))
}
# second table
cat("\n")
cat(paste( "          2.1.5",  sheet[20,1], "Data\n\n", sep = " "))
variables <- vector("character", length(sheet[20,]))
for (i in 1:length(variables)){
  if (!is.na(sheet[20,i])){
    variables[[i]] <-paste(sheet[20,i], sheet[21,i], sep=" ")
  }else{
    variables[[i]]  <-as.character(sheet[21,i])
  }
}
# print them out
for (i in 1:length (variables)){
  cat(paste("              - ", variables[i],"\n", sep = ""))
}
# third table 
cat("\n")
cat(paste( "          2.1.6",  sheet[40,1], "Data\n\n", sep = " "))
variables <- vector("character", length(sheet[40,]))
for (i in 1:length(variables)){
  if (!is.na(sheet[40,i])){
    variables[[i]] <-paste(sheet[40,i], sheet[41,i], sep=" ")
  }else{
    variables[[i]]  <-as.character(sheet[41,i])
  }
}
# print them out
for (i in 1:length (variables)){
  cat(paste("              - ", variables[i],"\n", sep = ""))
}

# Third Page #
sheet <- dataBook[[3]]
# first table 
cat("\n")
varnames <- names(sheet)
cat(paste( "          2.1.7",  varnames[2], "Data\n\n", sep = " "))
variables <- vector("character", length(varnames))
for (i in 1:length(variables)){
  if (!is.na(varnames[i])){
    variables[[i]] <-paste(varnames[i], sheet[1,i], sep=" ")
  }else{
    variables[[i]]  <-as.character(sheet[1,i])
  }
}
# print them out
for (i in 1:length (variables)){
  cat(paste("              - ", variables[i],"\n", sep = ""))
}
# second table 
cat("\n")
cat(paste( "          2.1.8",  sheet[21,2], "Data\n\n", sep = " "))
variables <- vector("character", 2)
for (i in 1:length(variables)){
    variables[[i]] <-paste(sheet[20+i, 5], sep=" ")
}
# print them out
for (i in 1:length (variables)){
  cat(paste("              - ", variables[i],"\n", sep = ""))
}
# third table 
cat("\n")
cat(paste( "          2.1.9",  sheet[24,2], "Data\n\n", sep = " "))
variables <- vector("character", 4)
for (i in 1:length(variables)){
  variables[[i]] <-paste(sheet[23+i, 3], sep=" ")
}
# print them out
for (i in 1:length (variables)){
  cat(paste("              - ", variables[i],"\n", sep = ""))
}

# Rest of pages
sheet <- dataBook[[4]]
cat("\n")
cat("There are more sheets containing individual tree data. \n\n")
cat(paste( names(sheet), "\n", sep = " "))
for (i in 1:length(sheet[,1])){
  cat(paste("     ", sheet[i,1],  "\n", sep = " "))
}

###
# Other Data from Finland
files = list.files(inDir,  full.names=TRUE)
# subfolder 1
subFolder =files[grepl("FLux_README", files )]
files =  list.files(subFolder,  full.names=TRUE)
cat("\n")
cat( "    2.2. Flux Data \n\n")
cat(paste( "          2.2.1 Flux Data\n\n", sep = " "))
subFiles <- files[grepl("flux", files )]
lines <- readLines(subFiles, n = -1)
# get unique variables
for (i in 9:23){
  cat(paste("              - ", lines[[i]],"\n", sep = ""))
}
cat("\n")
cat(paste( "          2.2.1 Soil Data\n\n", sep = " "))
subFiles <- files[grepl("soil", files )]
lines <- readLines(subFiles, n = -1)
# get unique variables
for (i in 6:22){
  cat(paste("              - ", lines[[i]],"\n", sep = ""))
}
cat("\n")
cat(paste( "          2.2.1 Meteo Data\n\n", sep = " "))
subFiles <- files[grepl("meteo", files )]
lines <- readLines(subFiles, n = -1)
# get unique variables
for (i in 6:38){
  cat(paste("              - ", lines[[i]],"\n", sep = ""))
}


########################## France ##########################
inDir = "/home/trashtos/GitHub/PROFOUND_Data/France"
cat("\n")
cat( "3. France\n\n")
subDir = list.files(inDir,  full.names=TRUE)
lines <- readLines(subDir[grepl(".txt", subDir )], n = -1)
cat("Note from data provider:\n\n")
for (i in 1:length(lines)){
  cat(paste("       ", lines[i], "\n",sep=""))
}
cat("\n")
cat( "    3.1. Le Bray \n\n")
cat(space)
files = list.files(subDir[grepl("bray", subDir )], full.names=TRUE)
cat( "        3.1.1 Biological Data Templates 2\n\n")
cat( "              - Excel book with information, but not data?\n\n")
cat( "        3.1.2 EFDC_L2_Flx \n\n")
subfiles = files[grepl("L2", files )]
variables <- findVariables(subfiles)
for (i in 1:length(variables)){
  cat( paste ( "         - ", variables[i], "\n", sep = ""))
}
cat("\n")
cat( "        3.1.3. CEIP_EC_L3_Flx \n\n")
subfiles <- files[grepl("L3", files )]
subunzipped <- unlist(lapply(subfiles, unzip))
variables <- findVariables(subunzipped[grepl(".txt", subunzipped)])
for (i in 1:length(variables)){
  cat( paste ( "         - ", variables[i], "\n", sep = ""))
}
do.call ("unlink", list(subunzipped))
cat("\n")
cat( "        3.1.4. CEIP_EC_L4_Flx \n\n")
subfiles <- files[grepl("L4", files )]
subunzipped <- unlist(lapply(subfiles, unzip))
variables <- findVariables(subunzipped[grepl(".txt", subunzipped)])
for (i in 1:length(variables)){
  cat( paste ( "         - ", variables[i], "\n", sep = ""))
}
# Delete unzipped files
do.call ("unlink", list(subunzipped))
cat("\n")
cat( "        3.1.5. Fluxes  2001-2002\n\n")
subfiles <- files[grepl("Fluxes", files )]
variables <- findVariables(subfiles)
for (i in 1:length(variables)){
  cat( paste ( "         - ", variables[i], "\n", sep = ""))
}
cat("\n")
cat( "        3.1.6. Ancillary Data \n\n")
table <-read.table(files[grepl("Ancillary", files )], sep = ",", header = TRUE)
variables <-unique(table[,2])
for (i in 1:length(variables)){
  cat( paste ( "         - ", variables[i], "\n", sep = ""))
}
cat("\n")
cat( "    3.2. Puechabon \n\n")
files = list.files(dir[grepl("Puechabon", dir )], full.names=TRUE)
cat( "        3.2.1 EFDC_L2_Flx \n\n")
subfiles = files[grepl("L2", files )]
variables <- findVariables(subfiles)
for (i in 1:length(variables)){
  cat( paste ( "         - ", variables[i], "\n", sep = ""))
}
cat("\n")
cat( "        3.2.2. CEIP_EC_L3_Flx \n\n")
subfiles <- files[grepl("L3", files )][-1]
subunzipped <- unlist(lapply(subfiles, unzip))
variables <- findVariables(subunzipped[grepl(".txt", subunzipped)])
for (i in 1:length(variables)){
  cat( paste ( "         - ", variables[i], "\n", sep = ""))
}
do.call ("unlink", list(subunzipped))
cat("\n")
#cat( "               Description: CEIP_EC_L3_Flx \n\n")
#description <- files[grepl("L3", files )][length(files[grepl("L3", files )])]
#lines <-readLines(description, n = -1)
#cat(space)
#for (i in 10:60){
#  cat( paste ( "           ", lines[i], "\n", sep = ""))
#}
#cat("\n")
cat( "        3.2.3. CEIP_EC_L4_Flx \n\n")
subfiles <- files[grepl("L4", files )][-1]
subunzipped <- unlist(lapply(subfiles, unzip))
variables <- findVariables(subunzipped[grepl(".txt", subunzipped)])
for (i in 1:length(variables)){
  cat( paste ( "         - ", variables[i], "\n", sep = ""))
}
# Delete unzipped files
do.call ("unlink", list(subunzipped))
cat("\n")
#cat( "               Description: CEIP_EC_L4_Flx \n\n")
#description <- files[grepl("L4", files )][length(files[grepl("L4", files )])]
#lines <-readLines(description, n = -1)
#cat(space)
#for (i in 7:80){
#  cat( paste ( "           ", lines[i], "\n", sep = ""))
#}
#cat("\n")
cat( "        3.2.5. Ancillary Data \n\n")
table <-read.table(files[grepl("Ancillary", files )], sep = ",", header = TRUE)
variables <-unique(table[,2])
for (i in 1:length(variables)){
  cat( paste ( "         - ", variables[i], "\n", sep = ""))
}



########################## Germany ##########################
inDir = "/home/trashtos/GitHub/PROFOUND_Data/Germany"
cat("\n")
cat( "4. Germany\n\n")
dir = list.files(inDir,  full.names=TRUE)
cat( "    4.1. Peitz: ISI-MIP Data\n\n")
subdir <- dir[grepl("peitz", dir )]
# xls file cant be read by R, you have to extract the sheets(to csv)!!
subFiles <- list.files(subdir, pattern = ".csv", full.names=TRUE)
cat( "        4.1.1. 1948, 1976_2001, 2007_2011 \n\n")
table <-read.table(subFiles[grepl("1948", subFiles )], sep = ",", header = TRUE, nrow= 5)
for (i in 1:length(names(table))){
  cat( paste ( "         - ", names(table)[i], "\n", sep = ""))
}
cat("\n")
cat( "        4.1.2. 1976_2001 \n\n")
table <-read.table(subFiles[grepl("1976", subFiles )], sep = ",", header = TRUE, nrow= 5)
for (i in 1:length(names(table))){
  cat( paste ( "         - ", names(table)[i], "\n", sep = ""))
}
cat("\n")
cat( "        4.1.3. 2007_2011 \n\n")
table <-read.table(subFiles[grepl("2007", subFiles )], sep = ",", header = TRUE, nrow= 5)
for (i in 1:length(names(table))){
  cat( paste ( "         - ", names(table)[i], "\n", sep = ""))
}
cat("\n")
cat( "        4.1.4. Observed_weather \n\n")
table <-read.table(subFiles[grepl("observed_weather", subFiles )], sep = ",", header = TRUE, nrow= 5)
for (i in 1:length(names(table))){
  cat( paste ( "         - ", names(table)[i], "\n", sep = ""))
}
cat("\n")
cat( "        4.1.5. Soil data \n\n")
table <-read.table(subFiles[grepl("soil", subFiles )], sep = ",", header = TRUE, nrow= 5)
for (i in 1:length(names(table))){
  cat( paste ( "         - ", names(table)[i], "\n", sep = ""))
}
cat("\n")
cat( "        4.1.6. Stand data \n\n")
table <-read.table(subFiles[grepl("stand", subFiles )], sep = ",", header = TRUE, nrow = 50)
cat( paste ( "         - ", table[8,1], "\n", sep = ""))
cat( paste ( "         - ", table[9,1], "\n", sep = ""))
cat( paste ( "         - ", table[11,1], "\n", sep = ""))
cat( paste ( "         - ", table[12,1], "\n", sep = ""))
cat( paste ( "         - ", table[8,15], "\n", sep = ""))
cat( paste ( "         - ", table[9,15], "\n", sep = ""))
cat( paste ( "         - ", table[11,15], "\n", sep = ""))
cat( paste ( "         - ", table[12,15], "\n", sep = ""))

for (i in 11:40){
  cat( paste ( "         - ",table[i,32], table[i,35], "\n", sep = ""))
}
cat("\n")
cat( "        4.1.7. GSWP3 \n\n")
table <-read.table(subFiles[grepl("GSWP3", subFiles )], sep = ",", header = TRUE, nrow = 1)

for (i in 1:length(names(table))){
  cat( paste ( "         - ", names(table)[i], "\n", sep = ""))
}
cat("\n")
cat( "        4.1.8. PGFv2 \n\n")
table <-read.table(subFiles[grepl("PGFv2", subFiles )], sep = ",", header = TRUE, nrow = 1)

for (i in 1:length(names(table))){
  cat( paste ( "         - ", names(table)[i], "\n", sep = ""))
}
cat("\n")
cat( "        4.1.9. WATCH \n\n")
table <-read.table(subFiles[grepl("WATCH", subFiles )][1], sep = ",", header = TRUE, nrow = 5)
for (i in 1:length(names(table))){
  cat( paste ( "         - ", names(table)[i], "\n", sep = ""))
}
cat("\n")
cat( "        4.1.10. WATCH + WFDEI \n\n")
table <-read.table(subFiles[grepl("WFDEI", subFiles )], sep = ",", header = TRUE, nrow = 5)
for (i in 1:length(names(table))){
  cat( paste ( "         - ", names(table)[i], "\n", sep = ""))
}

cat("\n")
cat( "    4.2. Solling\n\n")
subdir <- dir[grepl("Solling", dir )]
subFiles <- list.files(subdir, full.names=TRUE)
lines <- readLines(subFiles[3], n = -1)
cat("Note from data provider:\n\n")
for (i in 1:length(lines)){
  cat(paste("     ",lines[i], "\n", sep = ""))
}
cat("\n")
cat( "        4.2.1. Plot_304_gesamt \n\n")
book <- read.XLSX(subFiles[grepl("304_gesamt", subFiles )])

for (i in 1:length(book)){
  cat(paste( "              -  ",  names(book)[i], "\n" , sep = ""))   
  for (j in 1:length(names(book[[i]]))){
    cat(paste("                     - ",names(book[[i]])[j], "\n", sep = ""))
  }
  cat("\n")
}
cat("\n")
cat( "        4.2.2. Plot_305_gesamt \n\n")
book <- read.XLSX(subFiles[grepl("305_gesamt", subFiles )])
for (i in 1:length(book)){
  cat(paste( "              -  ",  names(book)[i], "\n" , sep = ""))   
  for (j in 1:length(names(book[[i]]))){
    cat(paste("                     - ",names(book[[i]])[j], "\n", sep = ""))
  }
  cat("\n")
}
cat("\n")
cat( "        4.2.3. SollingB1_304 \n\n")
# xls file cant be read by R, you have to extract the sheets(to csv)!!
subset <- subFiles[grepl("SollingB1_304", subFiles )]
# iterable ones
index = c(1, 3, 7:(length(subset)-1))
for (i in index  ){
  table <-read.table(subset[i], sep = ",", header = TRUE, nrow = 5)
  cat(paste("                - ",gsub(".csv", "", strsplit(subset[i], "/")[[1]][8]), "\n", sep = ""))
  for (j in 1:length(names(table))){
    cat(paste("                     - ",names(table)[j], "\n", sep = ""))
  }
  cat("\n")
}
# to format speficically : 2, 4, 5, 6
cat("\n")
table <-read.table(subset[2], sep = ",", header = TRUE, skip = 1, nrows= 5)
cat(paste("                - ",gsub(".csv", "", strsplit(subset[2], "/")[[1]][8]), "\n", sep = ""))
for (j in 1:length(names(table))){
  cat(paste("                     - ",names(table)[j], "\n", sep = ""))
}
cat("\n")
table <-read.table(subset[4], sep = ",", header = FALSE,  nrows= 1)
cat(paste("                - ",gsub(".csv", "", strsplit(subset[4], "/")[[1]][8]), "\n", sep = ""))
for (j in 1:length(table[1,])){
  cat(paste("                     - ",table[1,j], "\n", sep = ""))
}
cat("\n")
table <-read.table(subset[5], sep = ",", header = TRUE, skip = 1, nrows= 5)
cat(paste("                - ",gsub(".csv", "", strsplit(subset[5], "/")[[1]][8]), "\n", sep = ""))
for (j in 1:length(names(table))){
  cat(paste("                     - ",names(table)[j], "\n", sep = ""))
}
cat("\n")
table <-read.table(subset[6], sep = ",", header = TRUE)
cat(paste("                - ",gsub(".csv", "", strsplit(subset[6], "/")[[1]][8]), "\n", sep = ""))
for (j in 1:length(table[,1][-1])){
  cat(paste("                     - ",table[j,1], "\n", sep = ""))
}
cat("\n")
cat( "        4.2.4. SollingB1_site_data_file5_4e_new \n\n")
# xls file cant be read by R, you have to extract the sheets(to csv)!!
subset <- subFiles[grepl("SollingB1_site_data_file5", subFiles )]
# Go over them
# N deposition
table <-read.table(subset[1], sep = ",", header = TRUE, nrows=2)
cat(paste("                - ",gsub(".csv", "", strsplit(subset[1], "/")[[1]][8]), "\n", sep = ""))
cat(paste("                     - ",names(table)[2], table[1,2],"\n", sep = ""))
cat("\n")
# Growth
table <-read.table(subset[2], sep = ",", header = TRUE, skip = 1, nrows= 5)
cat(paste("                - ",gsub(".csv", "", strsplit(subset[2], "/")[[1]][8]), "\n", sep = ""))
for (j in 1:length(names(table))){
  cat(paste("                     - ",names(table)[j], "\n", sep = ""))
}
cat("\n")
# Litter Fall
table <-read.table(subset[3], sep = ",", header = TRUE, skip=1, nrows= 5)
cat(paste("                - ",gsub(".csv", "", strsplit(subset[3], "/")[[1]][8]), "\n", sep = ""))
for (j in 1:length(names(table))){
  cat(paste("                     - ",names(table)[j], "\n", sep = ""))
}
cat("\n")
# Meteo
table <-read.table(subset[4], sep = ",", header = TRUE)
cat(paste("                - ",gsub(".csv", "", strsplit(subset[4], "/")[[1]][8]), "\n", sep = ""))
variables <- unique(table[,1])
for (j in 1:length(variables)){
  cat(paste("                     - ",variables[j], "\n", sep = ""))
}
cat("                      * in open field and inside forest\n")
cat("\n")
# Site parameters
table <-read.table(subset[5], sep = ",", header = TRUE, nrows= 1)

cat(paste("                - ",gsub(".csv", "", strsplit(subset[5], "/")[[1]][8]), "\n", sep = ""))
for (j in 1:length(names(table))){
  cat(paste("                     - ",names(table)[j], "\n", sep = ""))
}
cat("\n")
# Soil parameters
table <-read.table(subset[6], sep = ",", header = TRUE, nrows= 5, skip=1)
cat(paste("                - ",gsub(".csv", "", strsplit(subset[6], "/")[[1]][8]), "\n", sep = ""))
for (j in 1:length(names(table))){
  cat(paste("                     - ",names(table)[j], "\n", sep = ""))
}
cat("\n")
# Stand
table <-read.table(subset[7], sep = ",", header = TRUE)
cat(paste("                - ",gsub(".csv", "", strsplit(subset[7], "/")[[1]][8]), "\n", sep = ""))
for (j in 1:length(table[,1][-1])){
  cat(paste("                     - ",table[j,1], "\n", sep = ""))
}
cat("\n")
# Soil respiration
table <-read.table(subset[8], sep = ",", header = TRUE, nrows=5)
cat(paste("                - ",gsub(".csv", "", strsplit(subset[8], "/")[[1]][8]), "\n", sep = ""))
cat(paste("                  Includes ",names(table)[1]," and ", names(table)[9], "\n", sep = ""))
cat(paste("                     - ",table[1,1], "\n", sep = ""))
cat(paste("                     - ",table[2,2], table[3,2], "\n", sep = ""))
cat("\n")
# Soil Moisture
table <-read.table(subset[9], sep = ",", header = TRUE, nrows=5)
cat(paste("                - ",gsub(".csv", "", strsplit(subset[9], "/")[[1]][8]), "\n", sep = ""))
cat(paste("                  Measures ",table[1,2],table[2,2],"at", table[3,1], ":\n", sep = " "))
variables <- table[3, c(2:6)]
for (j in 1:length(variables)){
  cat(paste("                     - ",variables[[j]], "\n", sep = ""))
}
cat("\n")
cat(paste("                  Measures ",table[1,12],table[2,12],"at", table[3,1], ":\n", sep = " "))
variables <- table[3, c(13:16)]
for (j in 1:length(variables)){
  cat(paste("                     - ",variables[[j]], "\n", sep = ""))
}
cat("\n")
# Tmean inside forest
table <-read.table(subset[10], sep = ",", header = TRUE, nrows=5)
cat(paste("                - ",gsub(".csv", "", strsplit(subset[10], "/")[[1]][8]), "\n", sep = ""))
cat("                  Measures at depth:\n")
variables <- unique(table[3, c(2:13)])
for (j in 1:length(variables)){
  cat(paste("                     - ",variables[[j]], "\n", sep = ""))
}
cat("\n")
# Timeseries inside Forest
table <-read.table(subset[11], sep = ",", header = TRUE, nrows=5, skip =1)
cat(paste("                - ",gsub(".csv", "", strsplit(subset[11], "/")[[1]][8]), "\n", sep = ""))
for (j in 2:length(names(table))){
  cat(paste("                     - ",names(table)[j], "\n", sep = ""))
}
cat("\n")
# Timeseries open Field
table <-read.table(subset[12], sep = ",", header = TRUE, nrows=5, skip =1)
cat(paste("                - ",gsub(".csv", "", strsplit(subset[12], "/")[[1]][8]), "\n", sep = ""))
for (j in 2:length(names(table))){
  cat(paste("                     - ",names(table)[j], "\n", sep = ""))
}
cat("\n")
cat( "        4.2.5. SollingF1_site_data_file5e_new \n\n")
# xls file cant be read by R, you have to extract the sheets(to csv)!!
subset <- subFiles[grepl("SollingF1_site_data_file5", subFiles )]
# Go over them
# N deposition
table <-read.table(subset[2], sep = ",", header = TRUE, nrows=2)
cat(paste("                - ",gsub(".csv", "", strsplit(subset[2], "/")[[1]][8]), "\n", sep = ""))
cat(paste("                     - ",names(table)[2], table[1,2],"\n", sep = ""))
cat("\n")
# Growth
table <-read.table(subset[3], sep = ",", header = TRUE, skip = 1, nrows= 5)
cat(paste("                - ",gsub(".csv", "", strsplit(subset[3], "/")[[1]][8]), "\n", sep = ""))
for (j in 2:length(names(table))){
  cat(paste("                     - ",names(table)[j], "\n", sep = ""))
}
cat("\n")
# Litterfall
table <-read.table(subset[1], sep = ",", header = TRUE, skip=1, nrows= 5)
cat(paste("                - ",gsub(".csv", "", strsplit(subset[1], "/")[[1]][8]), "\n", sep = ""))
for (j in 1:length(names(table))){
  cat(paste("                     - ",names(table)[j], "\n", sep = ""))
}
cat("\n")
# Meteo
table <-read.table(subset[4], sep = ",", header = TRUE)
cat(paste("                - ",gsub(".csv", "", strsplit(subset[4], "/")[[1]][8]), "\n", sep = ""))
variables <- unique(table[,1])
for (j in 1:length(variables)){
  cat(paste("                     - ",variables[j], "\n", sep = ""))
}
cat("                      * in open field and inside forest\n")
cat("\n")
# Site parameters
table <-read.table(subset[5], sep = ",", header = TRUE, nrows= 1)
cat(paste("                - ",gsub(".csv", "", strsplit(subset[5], "/")[[1]][8]), "\n", sep = ""))
for (j in 1:length(names(table))){
  cat(paste("                     - ",names(table)[j], "\n", sep = ""))
}
cat("\n")
# Soil
table <-read.table(subset[6], sep = ",", header = TRUE, nrows= 5, skip=1)
cat(paste("                - ",gsub(".csv", "", strsplit(subset[6], "/")[[1]][8]), "\n", sep = ""))
for (j in 1:length(names(table))){
  cat(paste("                     - ",names(table)[j], "\n", sep = ""))
}
cat("\n")
# Stand
table <-read.table(subset[7], sep = ",", header = TRUE)
cat(paste("                - ",gsub(".csv", "", strsplit(subset[7], "/")[[1]][8]), "\n", sep = ""))
for (j in 1:length(table[,1][-1])){
  cat(paste("                     - ",table[j,1], "\n", sep = ""))
}
cat("\n")
# Respiration
table <-read.table(subset[13], sep = ",", header = TRUE, nrows=5)
cat(paste("                - ",gsub(".csv", "", strsplit(subset[13], "/")[[1]][8]), "\n", sep = ""))
cat(paste("                  Includes ",names(table)[1]," and ", names(table)[9], "\n", sep = ""))
cat(paste("                     - ",table[1,1], "\n", sep = ""))
cat(paste("                     - ",table[2,2], table[3,2], "\n", sep = ""))
cat("\n")
# Soil Moisture
table <-read.table(subset[8], sep = ",", header = TRUE, nrows=5)
cat(paste("                - ",gsub(".csv", "", strsplit(subset[8], "/")[[1]][8]), "\n", sep = ""))
cat(paste("                  Measures ",table[1,2],table[2,2],"at", table[3,1], ":\n", sep = " "))
variables <- table[3, c(2:6)]
for (j in 1:length(variables)){
  cat(paste("                     - ",variables[[j]], "\n", sep = ""))
}
cat("\n")
cat(paste("                  Measures ",table[1,12],table[2,12],"at", table[3,1], ":\n", sep = " "))
variables <- table[3, c(13:16)]
for (j in 1:length(variables)){
  cat(paste("                     - ",variables[[j]], "\n", sep = ""))
}
cat("\n")
# T mean inside forest
table <-read.table(subset[9], sep = ",", header = TRUE, nrows=5)
cat(paste("                - ",gsub(".csv", "", strsplit(subset[9], "/")[[1]][8]), "\n", sep = ""))
cat("                  Measures at depth:\n")
variables <- unique(table[3, c(2:6)])
for (j in 1:length(variables)){
  cat(paste("                     - ",variables[[j]], "\n", sep = ""))
}
cat("\n")
# Timeseries inside forest
table <-read.table(subset[10], sep = ",", header = TRUE, nrows=5, skip =1)
cat(paste("                - ",gsub(".csv", "", strsplit(subset[10], "/")[[1]][8]), "\n", sep = ""))
for (j in 2:length(names(table))){
  cat(paste("                     - ",names(table)[j], "\n", sep = ""))
}
cat("\n")
# Timeseries open field
table <-read.table(subset[11], sep = ",", header = TRUE, nrows=5, skip =1)
cat(paste("                - ",gsub(".csv", "", strsplit(subset[11], "/")[[1]][8]), "\n", sep = ""))
for (j in 2:length(names(table))){
  cat(paste("                     - ",names(table)[j], "\n", sep = ""))
}



########################## LEVEL 2 (FLUX?) ##########################
inDir = "/home/trashtos/GitHub/PROFOUND_Data/Level-2"
cat("\n")
cat( "5. Level-2 (FLUX) \n\n")
dir <- list.files(inDir, full.names=TRUE)
files <- list.files(dir[2], full.names=FALSE)
cat( "    Following variables:\n\n")
for (i in 1:length(files)){
  cat(paste("        - ", strsplit(files[i], ".c")[[1]][1], "\n", sep=""))
}
cat("\n")
cat( "    And for each variable the following information:\n\n")
files <- list.files(dir[2], full.names=TRUE)
table <-read.table(files[1], sep = ";", header = TRUE , nrow = 5)
for (i in 1:length(names(table))){
  cat( paste ( "    - ", names(table)[i], "\n", sep = ""))
}

cat("\n")
cat( "    Countries :\n\n")
countriesAll <- vector("list", length(files))
plotAll <- vector("list", length(files))
for (i  in 1:length(files)){
  try(table <-read.table(files[i], sep = ";", header = TRUE , nrows = -1, colClasses = "character"))
  try(countriesAll[[i]] <-  unique(table$code_country))
  try(plotAll[[i]] <-  unique(table$code_plot))

}

unique(unlist(countriesAll)) 
unique(unlist(plotAll)) 

return(unique(unlist(variablesAll)) )
for (i in 1:length(files)){
  table <-read.table(files[1], sep = ";", header = TRUE , colClasses = "character")
  unique(table$code_plot)
  unique(table$code_country)
}

########################## ISI_MIP ##########################
inDir = "/home/trashtos/GitHub/PROFOUND_Data/ISI-MIP_Climate_input/"
cat("\n")
cat( "6. ISI-MIP \n\n")
pattern = "*.zip"
filenames <- list.files(inDir, pattern=pattern, full.names=TRUE, recursive = TRUE)
# Unzip all files
unzippedFiles <- lapply(filenames, unzip) #
# Check files
Location <- vector("list", length(unzippedFiles))
Parameter <- vector("list", length(unzippedFiles))
Variable <- vector("list", length(unzippedFiles))
VariableType<- vector("list", length(unzippedFiles))
for (i in 1:length(unzippedFiles)){
# Case 1: only two files per location
if ( length(unzippedFiles[[i]]) == 8 ){
  data <- lapply(unzippedFiles[[i]], function(x) {
    Variable <- sub( "./", "", strsplit(x, "_")[[1]][1])
    VariableType <- "none"
    return(c(Variable, VariableType))
  })
  data.all <- do.call("rbind",data)
  rm(data)
  Variable[[i]] <- unique(data.all[,1])
  VariableType[[i]] <- unique(data.all[,2])
  Parameter[[i]]  <- strsplit(unzippedFiles[[i]], "_")[[1]][2]
  Location[[i]] <- sub( ".txt", "", strsplit(unzippedFiles[[i]], "_")[[1]][3])
  rm(data.all) # only to keep RAM low
    # Case 2: forty files per location
}else if (length(unzippedFiles[[i]]) == 40){
  data <- lapply(unzippedFiles[[i]], function(x) {
    Variable <- sub( "./", "", strsplit(x, "_")[[1]][1])
    VariableType <- strsplit(x, "_")[[1]][3]
    return(c(Variable, VariableType))
  })
  data.all <- do.call("rbind",data)
  rm(data)
  Variable[[i]] <- unique(data.all[,1])
  VariableType[[i]] <- unique(data.all[,2])
  # only to keep RAM low
  Parameter[[i]]  <- strsplit(unzippedFiles[[i]], "_")[[1]][2]
  Location[[i]]<- sub( ".txt", "", strsplit(unzippedFiles[[i]], "_")[[1]][4])
  rm(data) # only to keep RAM low
  rm(data.all)# only to keep RAM low
}else{
  # If not case 1 or 2, there must be an error
  print(length(unzippedFiles[[i]]))
  cat("There was en error. Check out the list at the end")
  }
}
cat( "      6.1. Locations \n\n")
uniqueLocations <- unique(Location)
for ( i in 1:length(uniqueLocations)){
  cat( paste ( "    - ", uniqueLocations[i], "\n", sep = ""))
}
cat("\n")
cat( "      6.2. Parameter \n\n")
uniqueParameter <- unique(Parameter)
for ( i in 1:length(uniqueParameter)){
  cat( paste ( "    - ", uniqueParameter[i], "\n", sep = ""))
}
cat("\n")
cat( "      6.3. Variable \n\n")
uniqueVariable <- unique(unlist(Variable))
for ( i in 1:length(uniqueVariable)){
  cat( paste ( "    - ", uniqueVariable[i], "\n", sep = ""))
}
cat("\n")
cat( "      6.4. VariableType \n\n")
uniqueVariableType <- unique(unlist(VariableType))
for ( i in 1:length(uniqueVariableType)){
  cat( paste ( "    - ", uniqueVariableType[i], "\n", sep = ""))
}
cat(   "    * By none is meant that there is not variable type for the variable ")
cat("\n")

## The End ##
# clope document
sink()
