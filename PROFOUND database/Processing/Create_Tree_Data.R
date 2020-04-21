#------------------------------------------------------------------------------#
#                               SINGLE TREE DATA
#------------------------------------------------------------------------------#
# Single Tree Data is available for:
#       Kroof
#       Peitz
#       Solling
#       Hyytiala
#       Soro
#       BilyKriz
# It must be derived for:
directory <- "~/ownCloud/PROFOUND_Data/Processed/"
setwd(directory)

# Target variables
variables.names <- c("site", "site_id", "year", "size_m2", "tree_id", "species", "age",
                     "dbh1_cm", "dbh2_cm", "height1_m", "height2_m" )

#------------------------------------------------------------------------------#

source("~/Github/COST-FP1304-PROFOUND/TG2/Processing/utilities.R")

# Load  the processed other data
otherData <- "./RData/ProfoundOtherData.new.RData"



# Soro
load("./Soro/Soroe_DBH_H_AGE_1921_2010 (1).RData")
load(otherData)
# Structre
str(ProfoundOtherData.new,1)

# Create Climate data
Tree_Data <- list()

#------------------------------------------------------------------------------#
# Collelongo
#------------------------------------------------------------------------------#
Collelongo <- "./Collelongo/Collelongo_tree_data.csv"
df <- read.table(Collelongo, sep = ",", header = TRUE)
head(df)
summary(df)
df <- nullToNA (df)

names(df)
names(df) <- c("site", "size_m2", "year", "species_id", "age","dbh1_cm", "height1_m")
df$site <- "Collelongo"
for( i in 1:length(variables.names)){
  if (variables.names[i] %in% names(df) == FALSE) {
    df[[variables.names[i]]] <- NA
  }
}
names(df)
df <- df[!is.na(df$dbh1_cm),]
Tree_Data$Collelongo <-df

#------------------------------------------------------------------------------#
# Kroof
#------------------------------------------------------------------------------#
Kroof <- "./Kroof/treedata_for_database_kroof_corrected.txt"
df <- read.table(Kroof, sep = "\t", header = TRUE)
head(df)
summary(df)
df <- nullToNA (df)
length(df$dbh1.cm[is.na(df$dbh1.cm)])
length(df$height1.m[is.na(df$height1.m)])

names(df)
names(df) <- c("year", "tree_id", "species_id", "age","dbh1_cm", "height1_m")
df$size_m2 <- 5000 # Christopher
df$site <- "Kroof"
for( i in 1:length(variables.names)){
  if (variables.names[i] %in% names(df) == FALSE) {
    df[[variables.names[i]]] <- NA
  }
}
names(df)
df <- df[!is.na(df$dbh1_cm),]
Tree_Data$Kroof <-df
#------------------------------------------------------------------------------#
# Hyytiala
#------------------------------------------------------------------------------#
Hyytiala <- "./Hyytiala/treedata_for_database_hyytiala_correction.txt"
df <- read.table(Hyytiala, sep = "\t", header = TRUE)
head(df)
summary(df)
df <- nullToNA (df)
names(df)
names(df) <- c("year",  "species_id",  "height1_m", "dbh1_cm", "age")
for( i in 1:length(variables.names)){
  if (variables.names[i] %in% names(df) == FALSE) {
    df[[variables.names[i]]] <- NA
  }
}
names(df)
df$size_m2 <- 7600
df <- df[!is.na(df$dbh1_cm),]
Tree_Data$Hyytiala <- df
#------------------------------------------------------------------------------#
# Peitz
#------------------------------------------------------------------------------#
str(ProfoundOtherData.new$Peitz$TreeData,1)
# drop sid
df <- ProfoundOtherData.new$Peitz$TreeData[,2:ncol(ProfoundOtherData.new$Peitz$TreeData)]
# Convert DBH from mm to cm
df$year <- as.numeric(df$year)
summary(df)
df <- nullToNA (df)
df$dbh1_cm <- (df$dbh1_mm + df$dbh2_mm)/20
df$dbh2_mm <- NULL
df$dbh1_mm <- NULL
hist(df$height_cm)
hist(df$heightF_cm)
df$height2_m <-df$height_cm /10
df$height1_m <-df$heightF_cm /10
df$height_cm <- NULL
df$heightF_cm <- NULL
summary(df)
hist(df$height2_m)
hist(df$dbh1_cm)

names(df)
names(df)  <- gsub("tree_nr", "tree_id", names(df))
names(df)  <- gsub("species", "species_id", names(df))
df <- df[!is.na(df$dbh1_cm),]
df <- df[df$tree_state=="V",]

df$site <- "Peitz"
table(df$year)

df$size_m2 <- ifelse(df$year > 2001, 700, 1000)
write.table(df, "./Peitz/treedata_for_database.txt", row.names = F)

Tree_Data$Peitz <- df

#------------------------------------------------------------------------------#
# Solling 304
#------------------------------------------------------------------------------#
df <- read.table("./Solling_304/TREE_master_20_new_new.txt", header = T, sep = "\t")
head(df)
summary(df)
df <- nullToNA (df)
df <- df[df$removed=="no",]

height1 <- df[!is.na(df$height1_m), c("site_id", "size_m2", "year", "month", "species_id", "tree_id", "height1_m", "Parameter1", "Parameter2")]
heightMod <- df[!is.na(df$height_modelled), c("site_id", "year", "month", "species_id", "tree_id", "height_modelled", "Parameter1", "Parameter2")]
dbh1_cm <- df[!is.na(df$dbh1_cm), c("site_id", "year", "month", "species_id", "tree_id"  ,"dbh1_cm",  "Parameter1", "Parameter2")]
dbh2_cm <- df[!is.na(df$dbh2_cm), c("site_id", "year", "month", "species_id", "tree_id" ,"dbh2_cm",  "Parameter1", "Parameter2")]

reduced <- Reduce(function(...) merge(..., all=T), list(height1, heightMod, dbh1_cm, dbh2_cm))

reduced$height_reconstruct <- 1.3+(reduced$dbh1_cm/(reduced$Parameter2 + reduced$Parameter1*reduced$dbh1_cm))**3


reduced$heigCheck <- abs(reduced$height_reconstruct- reduced$height_modelled)

reduced <- reduced[!is.na(reduced$dbh1_cm),]
barplot(table(reduced$year))
hola <- reduced[reduced$heigCheck > 0.01, ]

summary(df)
df <- df[df$removed=="no",]

df <- df[!is.na(df$dbh1_cm),]
df$dbh2_cm <- NULL
df$height1_m <- df$height_modelled

Tree_Data$Solling_304 <- df


#------------------------------------------------------------------------------#
# BilyKriz
#------------------------------------------------------------------------------#
tree_file <- "./BilyKriz/treedata_for_database_bilykriz.txt"
df <- read.table(tree_file, header=T, sep="\t")
summary(df)
names(df) <- gsub("[.]", "_", names(df))
names(df) <- gsub("height_m", "height1_m", names(df))
names(df) <- gsub("species", "species_id", names(df))
df <- nullToNA (df)
df$site <- "BilyKriz"
df$size_m2 <- 2500

df <- df[!is.na(df$dbh1_cm),]
Tree_Data$BilyKriz <- df

#------------------------------------------------------------------------------#
# Solling_305
#------------------------------------------------------------------------------#
df <- read.table("./Solling_305/TREE_master_25_new_new.txt", header = T, sep = "\t")
head(df)
summary(df)
df <- nullToNA (df)

summary(df)
df <- df[df$removed=="no",]

df <- df[!is.na(df$dbh1_cm),]
df$dbh2_cm <- NULL
df$height1_m <- df$height_modelled


Tree_Data$Solling_305 <- df

#------------------------------------------------------------------------------#
# Soro
#------------------------------------------------------------------------------#
tree_file <- "./Soro/treedata_for_database_soroe_16-04-2020.txt"
df <- read.table(tree_file, header=T, sep="\t")
# description says height and dbh in  m. Dbh it is in cm!!!
names(df)
names(df) <- gsub("Site", "site", names(df))
names(df) <- gsub("site_ID", "site_id", names(df))
names(df) <- gsub("height_m", "height1_m", names(df))
names(df) <- gsub("species", "species_id", names(df))
df <- nullToNA (df)

for( i in 1:length(variables.names)){
  if (variables.names[i] %in% names(df) == FALSE) {
    df[[variables.names[i]]] <- NA
  }
}
df <- df[!is.na(df$dbh1_cm),]
df$size_m2 <- 10000
Tree_Data$Soro <- df

#------------------------------------------------------------------------------#
# Add the IDs
# Get sites
load("./RData/Sites.RData")
# get the  locations
site.id <-  Sites$site_id

columns <- c("site", "site_id","size_m2",  "year", 
             "species", "age", "dbh1_cm", "dbh2_cm", "height1_m", "height2_m" )
names(site.id)<-sites <- Sites$site2

for (i in 1:length(Tree_Data)){
  file.site <- names(Tree_Data)[i]
  Tree_Data[[i]]$site_id <- site.id[[file.site]]
  Tree_Data[[i]]$site <- file.site
  for (j in 1:length(columns)){
    if (columns[j] %in% names(Tree_Data[[i]]) == FALSE){
      Tree_Data[[i]][[columns[j]]] <- NA
    }
  }
  Tree_Data[[i]]$dbh1_cm <- round(Tree_Data[[i]]$dbh1_cm, 2)
  Tree_Data[[i]]$dbh2_cm <- round(Tree_Data[[i]]$dbh2_cm, 2)
  Tree_Data[[i]]$height1_m <- round(Tree_Data[[i]]$height1_m, 2)
  Tree_Data[[i]]$height2_m <- round(Tree_Data[[i]]$height2_m, 2)

}


save(Tree_Data, file="./RData/Tree_Data.RData")

#------------------------------------------------------------------------------#
#                         Check Data
#------------------------------------------------------------------------------#
load("./RData/Tree_Data.RData")

str(Tree_Data,1)

#sink("./RData/Tree_Data.txt")
#str(Tree_Data)
#sink()


