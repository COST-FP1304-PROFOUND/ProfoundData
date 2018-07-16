#------------------------------------------------------------------------------#
# The Other Data
#------------------------------------------------------------------------------#
# Load utility functions
source("/home/trashtos/GitHub/TG2/Processing/utilities.R")

#------------------------------------------------------------------------------#
#                                     DENMARK
#------------------------------------------------------------------------------#
# There is ancillary data that must be organized.
# Here I subset the data by variables
# Why are the variables measured several times?

inDir  <- "/home/trashtos/ownCloud/PROFOUND_Data/Denmark"
files <- list.files(inDir, pattern ="*Ancillary_Data.txt", full.names=TRUE)
df <- read.table(files, sep = ",", header = TRUE)
# Get the unique variables
variables <- unique(df$Variable)
# Put data in a listdf <-read.table(files[grepl("Ancillary", files )], sep = ",", header = TRUE)
Denmark <- list("Variables"= variables, "Table"=df)

#------------------------------------------------------------------------------#
#                                      FINLAND
#------------------------------------------------------------------------------#
Finland <- vector("list", 1)
vegetationData <- vector("list", 4)
inDir <- "/home/trashtos/ownCloud/PROFOUND_Data/Finland"
# Find and fead the xlsx:there is only one for vegetation
files <- list.files(inDir, pattern ="*.xlsx", full.names=TRUE)
# read the book
dataBook <- read.XLSX(files)
# remove non useful names
names(dataBook[[1]]) <- NULL
#------------------------------------------#
# First page: Stand Data
#------------------------------------------#
StandData <- vector("list", 3)
sheet <- dataBook[[1]]
# first table: pine
df <- as.data.frame(sheet[c(4:20), ])
names(df) <- paste(sheet[2,], sheet[3,], sep = "_")
StandData[[1]]<-df
names(StandData)[1] <- sheet[2,1]
# second table: spruce
df <- as.data.frame(sheet[c(25:41), ])
names(df)<- paste(sheet[23,], sheet[24,], sep = "_")
StandData[[2]]<-df
names(StandData)[2] <- sheet[23,1]
# third table
df <- as.data.frame(sheet[c(45:53), ])
names(df)<- paste(sheet[43,], sheet[44,], sep = "_")
StandData[[3]]<-df
names(StandData)[3] <- sheet[43,1]
vegetationData[[1]] <- StandData
names(vegetationData)[1] <- "StandData"
rm(StandData)
#------------------------------------------#
# Second page:  Biomasses.kg.ha
#------------------------------------------##
BiomassData <- vector("list", 3)
sheet <- dataBook[[2]]
varnames <- names(sheet)
#first table
df <- as.data.frame(sheet[c(2:18), ])
names(df)<- sheet[1,]
BiomassData[[1]] <-df
names(BiomassData)[1] <-  varnames[1]
# second table
df <- as.data.frame(sheet[c(22:38), ])
names(df)<- sheet[21,]
BiomassData[[2]] <-df
names(BiomassData)[2] <-  sheet[20,1]
# third table
df <- as.data.frame(sheet[c(42:50), ])
names(df)<- sheet[41,]
BiomassData[[3]] <-df
names(BiomassData)[3] <-  sheet[40,1]
#
vegetationData[[2]] <- BiomassData
names(vegetationData)[2] <- "Biomasses.kg.ha "
rm(BiomassData)
#------------------------------------------#
# Third Page: Foliage.kg.ha
#------------------------------------------##
FoliageData <- vector("list", 3)
sheet <- dataBook[[3]]
# first table
df <- sheet[c(2:18), c(1:8)]
names.df <- NULL
for (i in 2:4){
  names.df <- c(names.df, paste(names(df)[2],sheet[1,i])  )
}
for (i in 5:7){
  names.df <- c(names.df, paste(names(df)[5],sheet[1,i])  )
}
names(df) <- names.df
FoliageData[[1]] <- list(data = df, info = paste("For 2011 SUM value",
                                                 "the following info is present:",
                                                  "value:", sheet[2,9],", note:", sheet[2, 10]))
names(FoliageData)[1] <- "Foliage_LAI_Data"
# second table
df <- sheet[24:27,c(3,4 )]
names(df)<- c("Species", sheet[24,2])
FoliageData[[2]] <- df
names(FoliageData)[2] <- sheet[24,2]
# third table
df <- sheet[21:22,c(5,6)]
names(df) <- c("species", sheet[21,2])
FoliageData[[3]] <- list( data = df, info = sheet[22,7])
names(FoliageData)[[3]] <- "LAI info"
vegetationData[[3]] <- FoliageData
names(vegetationData)[3] <- "FoliageData"
rm(FoliageData)
#------------------------------------------#
# Fourth Page: Explanation on single tree data
#------------------------------------------#
vegetationData[[4]] <- list( info = dataBook[[4]])
names(vegetationData)[4] <- names(dataBook)[4]
#------------------------------------------#
# Fifth Page: Single tree data: pine 2001
#------------------------------------------#
sheet <- dataBook[[5]]
pine2001 <- vector("list", 3)
# table one
df <- sheet[, 1:3]
pine2001[[1]] <- df
# table two
df <- sheet[3:31, 6:8]
names(df) <- c(sheet[2, 6:7], "100/76*Fequency")
pine2001[[2]] <- df
# table two
df <- sheet[36:54, 6:8]
names(df) <- c(sheet[35, 6:7], "100/76*Fequency")
pine2001[[3]] <- df
# add it to vegetation data
names(pine2001) <- c("Data", "Histogram_Data_DBH_ha", "Histogram_Data_H_ha")
vegetationData[[5]] <- pine2001
names(vegetationData)[5] <- names(dataBook)[5]
rm(pine2001)
#------------------------------------------#
# Sixth Page: Single tree data: pine 2008
#------------------------------------------#
sheet <- dataBook[[6]]
pine2008 <- vector("list", 3)
# table one
df <- sheet[, 1:3]
pine2008[[1]] <- df
# table two
df <- sheet[2:32, 6:8]
names(df) <- c(sheet[1, 6:7], "100/76*Fequency")
pine2008[[2]] <- df
# table two
df <- sheet[37:57, 6:8]
names(df) <- c(sheet[36, 6:7], "100/76*Fequency")
pine2008[[3]] <- df
# add it to vegetation data
names(pine2008) <- c("Data", "Histogram_Data_DBH_ha", "Histogram_Data_H_ha")
vegetationData[[6]] <- pine2008
names(vegetationData)[6] <- names(dataBook)[6]
rm(pine2008)
#------------------------------------------#
# Sevent Page: Single tree data: spruce 2008
#------------------------------------------#
sheet <- dataBook[[7]]
spruce2008 <- vector("list", 3)
# table one
df <- sheet[, 1:2]
spruce2008[[1]] <- df
# table two
df <- sheet[2:41, 8:10]
names(df) <- c(sheet[1, 8:9], "100/76*Fequency")
spruce2008[[2]] <- df
# table two
df <- sheet[46:74, 8:10]
names(df) <- c(sheet[45, 8:9], "100/76*Fequency")
spruce2008[[3]] <- df
# add it to vegetation data
names(spruce2008) <- c("Data", "Histogram_Data_DBH_ha", "Histogram_Data_H_ha")
vegetationData[[7]] <- spruce2008
names(vegetationData)[7] <- names(dataBook)[7]
rm(spruce2008)
#------------------------------------------#
# Eight Page: Single tree data: hardwood 2008
#------------------------------------------#
sheet <- dataBook[[8]]
hardwood2008 <- vector("list", 3)
# table one
df <- sheet[, 1:2]
hardwood2008[[1]] <- df
# table two
df <- sheet[2:35, 5:7]
names(df) <- c(sheet[1, 5:6], "100/76*Fequency")
hardwood2008[[2]] <- df
# table two
df <- sheet[39:60, 5:7]
names(df) <- c(sheet[38, 5:6], "100/76*Fequency")
hardwood2008[[3]] <- df
# add it to vegetation data
names(hardwood2008) <- c("Data", "Histogram_Data_DBH_ha", "Histogram_Data_H_ha")
vegetationData[[8]] <- hardwood2008
names(vegetationData)[8] <- names(dataBook)[8]
rm(hardwood2008)
#------------------------------------------#
# END of FINLAND
#------------------------------------------#
Finland[[1]] <- vegetationData
names(Finland)[1] <- "VegetationData"
rm(vegetationData)
rm(sheet)
rm(dataBook)
#------------------------------------------------------------------------------#
# FRANCE
#------------------------------------------------------------------------------#
France <- vector("list", 3)
inDir <- "/home/trashtos/ownCloud/PROFOUND_Data/France"
subDir <- list.files(inDir,  full.names=TRUE)
#------------------------------------------#
# Readme
#------------------------------------------#
lines <- readLines(subDir[grepl(".txt", subDir )], n = -1)
France[[1]]<- paste(lines, collapse= "")
names(France)[1] <- "Info"
#------------------------------------------#
# leBray
#------------------------------------------#
leBray <- vector("list", 2)
files <- list.files(subDir[grepl("bray", subDir )], full.names=TRUE)
# Biological data templates
# read the book
leBray[[1]] <- read.XLSX(files[grepl("Biological", files )])
names(leBray)[1]<- "Biological_Data_Templates"
# Ancillary data
df <-read.table(files[grepl("Ancillary", files )], sep = ",", header = TRUE)
variables <-unique(df[,2])
leBray[[2]] <- list("Variables"= variables, "Table"=df)
names(leBray)[2]<- "AncillaryData"
France[[2]]<- leBray
names(France)[2] <- "LeBray"
rm(leBray)
#------------------------------------------#
# Puechabon
#------------------------------------------#
files <- list.files(subDir[grepl("Puechabon", subDir )], full.names=TRUE)
# Ancillary Data
df <- read.table(files[grepl("Ancillary", files )], sep = ",", header = TRUE)
variables <-unique(df$)
France[[3]]<- list("AncillaryData" = list("Variables"= variables, "Table"=df))
names(France)[3]<-"Puechabon"
#------------------------------------------------------------------------------#
# GERMANY
#------------------------------------------------------------------------------#
inDir <- "/home/trashtos/ownCloud/PROFOUND_Data/Germany"
Germany <- vector("list",2 )
names(Germany) <- c("Peitz", "Solling")
dir <- list.files(inDir,  full.names=TRUE)
#------------------------------------------#
# Peitz
#------------------------------------------#
Peitz <- vector("list", 7)
subdir <- dir[grepl("peitz", dir )]
# xls file cant be read by R, you have to extract the sheets(to csv)!!
subFiles <- list.files(subdir, pattern = ".csv", full.names=TRUE)
df <-read.table(subFiles[grepl("1948", subFiles )], sep = ",", header = TRUE)
Peitz[[1]]<-df
names(Peitz)[1]<-"1948"
df <-read.table(subFiles[grepl("1952", subFiles )], sep = ",", header = TRUE)
Peitz[[2]]<-df
names(Peitz)[2]<-"1952_1971"
df <-read.table(subFiles[grepl("1976", subFiles )], sep = ",", header = TRUE)
Peitz[[3]]<-df
names(Peitz)[3]<-"1976_2001"
df <-read.table(subFiles[grepl("2007", subFiles )], sep = ",", header = TRUE)
Peitz[[4]]<-df
names(Peitz)[4]<-"2007_2011"
df <-read.table(subFiles[grepl("observed_weather", subFiles )], sep = ",", header = TRUE)
Peitz[[5]]<-df
names(Peitz)[5]<-"Observed_weather"
df <-read.table(subFiles[grepl("soil", subFiles )], sep = ",", header = TRUE)
Peitz[[6]]<-df
names(Peitz)[6]<-"SoilData"
df <-read.table(subFiles[grepl("stand_mod.csv", subFiles )], sep = ",",dec = ".",
                header = FALSE, quote = "", stringsAsFactors = FALSE )
# table1
standData <- vector("list", 4)
listNames <- c("Plot", "Experiment", "Area", "UF", "Species", "YieldTable",
               "NutrienStatus", "LocalSoilType", "Table")
dummy <- vector("list", length(listNames))
names(dummy)<- listNames
rows <- c(0,43, 83, 116)
for (i in 1:length(rows)){
  dummy[1] <- df[9+rows[i],5]
  dummy[2] <-paste(df[10+rows[i],5], ": ", df[11+rows[i],5],sep= "")
  dummy[3]<- df[12+rows[i],5]
  dummy[4]<- df[13+rows[i],5]
  dummy[5] <- df[9+rows[i],20]
  dummy[6] <-paste(df[10+rows[i],20], ": ", df[11+rows[i],20],sep= "")
  dummy[7]<- df[12+rows[i],20]
  dummy[8]<- df[13+rows[i],20]
  if(i == 1){
    dummy$Table<- df[c(15:42),c(1:27)]
  }else if (i== 2){
    dummy$Table<- df[c(58:82),c(1:27)]
  }else if(i==3){
    dummy$Table<- df[c(98:115),c(1:27)]
  }else if(i==4){
    dummy$Table<- df[c(131:141),c(1:27)]
  }
  standData[[i]] <- dummy
}
# Now the dictionary
dict <-read.table(subFiles[grepl("stand_dict.csv", subFiles )], sep = ",",dec = ".",
                  header = TRUE)
Peitz[[7]]<- list(standData = standData, dict = dict, rawData = df)
names(Peitz)[7]<-"standData"
# Remarks
df <-read.table(subFiles[grepl("remarks", subFiles )], sep = ",",dec = ".",
                  header = TRUE)
Peitz[[8]]<- df
names(Peitz)[8]<-"data_original_remarks"
Germany[[1]]<-Peitz
rm(Peitz)
#------------------------------------------#
# Solling
#------------------------------------------#
Solling <- vector("list", 6)
subdir <- dir[grepl("Solling", dir )]
subFiles <- list.files(subdir, full.names=TRUE)
lines <- readLines(subFiles[3], n = -1)
Solling[[1]] <- paste(lines, collapse = " ")
names(Solling)[1]<-"Info"
# Plot_304_gesamt
book <- read.XLSX(subFiles[grepl("304_gesamt", subFiles )])
Solling[[2]]<-book
names(Solling)[2]<-"Plot_304_gesamt"
# Plot_305_gesamt
book <- read.XLSX(subFiles[grepl("305_gesamt", subFiles )])
Solling[[3]]<-book
names(Solling)[3]<-"Plot_305_gesamt"
# SollingB1_304
subList<- vector("list", 15)
# xls file cant be read by R, you have to extract the sheets(to csv)!!
subset <- sort(subFiles[grepl("SollingB1_304", subFiles )])
# iterable ones
index <- c(1, 7:(length(subset)-1))
for (i in index  ){
  table <-read.table(subset[i], sep = ",", header = TRUE)
  cat(paste("                - ",gsub(".csv", "", strsplit(subset[i], "/")[[1]][8]), "\n", sep = ""))
  subList[[i]]<-table
  names(subList)[i]<-gsub(".csv", "", strsplit(subset[i], "/")[[1]][8])
  for (j in 1:length(names(table))){
    cat(paste("                     - ",names(table)[j], "\n", sep = ""))
  }
  cat("\n")
}
# to format speficically : 2, 3, 4, 5, 6
table <-read.table(subset[2], sep = ",", header = TRUE, skip = 2)
subList[[2]]<-table
names(subList)[2]<-gsub(".csv", "", strsplit(subset[2], "/")[[1]][8])
table <-read.table(subset[3], sep = ",", header = FALSE)
subList[[3]]<-table
names(subList)[3]<-gsub(".csv", "", strsplit(subset[3], "/")[[1]][8])
table <-read.table(subset[4], sep = ",", header = FALSE)
subList[[4]]<-table
names(subList)[4]<-gsub(".csv", "", strsplit(subset[4], "/")[[1]][8])
table <-read.table(subset[5], sep = ",", header = TRUE, nrows = 3,
                   quote = "", stringsAsFactors = FALSE )
subList[[5]]<-table
names(subList)[5]<-gsub(".csv", "", strsplit(subset[5], "/")[[1]][8])
table <-read.table(subset[6], sep = ",", header = TRUE)
subList[[6]]<-table
names(subList)[6]<-gsub(".csv", "", strsplit(subset[6], "/")[[1]][8])
Solling[[4]]<- subList
names(Solling)[4]<-"SollingB1_304"

# SollingB1_site_data_file5_4e_new
subList<-vector("list",13)
# xls file cant be read by R, you have to extract the sheets(to csv)!!
subset <- sort(subFiles[grepl("SollingB1_site_data_file5", subFiles )])
index <- c(1:5, 7:13)
for (i in index){
  table <-read.table(subset[i], sep = ",", header = TRUE)
  cat(paste("                - ",gsub(".csv", "", strsplit(subset[i], "/")[[1]][8]), "\n", sep = ""))
  subList[[i]]<-table
  names(subList)[i]<-gsub(".csv", "", strsplit(subset[i], "/")[[1]][8])
 }
# Site parameters
table <-read.table(subset[6], sep = ",", header = TRUE,quote = "", stringsAsFactors = FALSE)
subList[[6]]<-table
names(subList)[6]<-gsub(".csv", "", strsplit(subset[6], "/")[[1]][8])
Solling[[5]]<-subList
names(Solling)[5]<-"SollingB1_site_data_file5_4e_new"

# SollingF1_site_data_file5e_new
# xls file cant be read by R, you have to extract the sheets(to csv)!!
subList<- vector("list",13)
# Go over themt
subset <- sort(subFiles[grepl("SollingF1_site_data_file5e", subFiles )])
index <- c(1:5, 7:12)
for (i in index){
  table <-read.table(subset[i], sep = ",", header = TRUE)
  cat(paste("                - ",gsub(".csv", "", strsplit(subset[i], "/")[[1]][8]), "\n", sep = ""))
  subList[[i]]<-table
  names(subList)[i]<-gsub(".csv", "", strsplit(subset[i], "/")[[1]][8])
}
# Site parameters
table <-read.table(subset[6], sep = ",", header = TRUE,quote = "", stringsAsFactors = FALSE)
subList[[6]]<-table
names(subList)[6]<-gsub(".csv", "", strsplit(subset[6], "/")[[1]][8])
table <-read.table(subset[14], sep = ",", header = TRUE,quote = "", stringsAsFactors = FALSE)
subList[[13]]<-table
names(subList)[13]<-gsub(".csv", "", strsplit(subset[14], "/")[[1]][8])
Solling[[6]]<-subList
names(Solling)[6]<-"SollingF1_site_data_file5e_new"
Germany[[2]]<-Solling
rm(Solling)

ProfoundOtherData <- list("Denmark" = Denmark,"Finland"=Finland, "France" = France, "Germany" = Germany)
rm(Finland)
rm(France)
rm(Germany)
save(ProfoundOtherData, file = "/home/trashtos/GitHub/TG2/Processing/ProfoundOtherData.RData")

load(file = "/home/trashtos/GitHub/TG2/Processing/ProfoundOtherData.RData")



