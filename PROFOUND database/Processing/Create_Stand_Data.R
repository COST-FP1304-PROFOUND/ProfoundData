#------------------------------------------------------------------------------#
#                              STAND DATA
#------------------------------------------------------------------------------#
# Stand Data is available for:
#       So far we just keep age
#       Provide age as same period than trees

# It must be derived for:
#       ...
# Target variables
directory <- "~/ownCloud/PROFOUND_Data/Processed/"
setwd(directory)

variables_names <- c("site", "site_id", "year", "species_id", "age")

source("~/Github/COST-FP1304-PROFOUND/TG2/Processing/utilities.R")



#------------------------------------------------------------------------------#
# Load  the processed other data
load("./RData/Tree_Data.RData")

Stand_Data_Tree <- vector("list", length(Tree_Data))

names(Stand_Data_Tree) <- names(Tree_Data)

for (i in 1:length(Stand_Data_Tree)){
  Stand_Data_Tree[[i]] <- summarizePROFOUND.TREE(Tree_Data[[i]])
}
# Drop empty values
Stand_Data <- list()

#------------------------------------------------------------------------------#
# Bily Kriz
inFile <- "./BilyKriz/standdata_for_database_bilykriz.txt"
df <- read.table(inFile, header = T, sep = "\t")
df <- df[,colSums(is.na(df))<nrow(df)]

names(df) <-  c("year", "species_id", "site_id", "dbhArith_cm", "ba_m2ha", "age", "density_treeha",
                "stem","foliageBiomass_kgha", "branchesBiomass_kgha",
                "stemBiomass_kgha", "rootBiomass_kgha")
df$stem <- NULL

# biomass stock variables from t/ha into kg/ha because raw data values are in t/ha 
df$foliageBiomass_kgha <- df$foliageBiomass_kgha * 1000
df$branchesBiomass_kgha <- df$branchesBiomass_kgha * 1000
df$stemBiomass_kgha <- df$stemBiomass_kgha * 1000
df$rootBiomass_kgha <- df$rootBiomass_kgha * 1000

#df <- dropDuplicates(df, Tree_Data$BilyKriz)
#df <- df[ df$year %in% unique(Tree_Data$BilyKriz$year), ]
Stand_Data$BilyKriz <- df

#------------------------------------------------------------------------------#
# LeBray: we have no tree data, thus we keep everything!
inFile <- "./LeBray/Bray_Stand_Synthesys.txt"
df <- read.table(inFile, header = T, sep = "\t")
names(df)
newNames <- gsub("YEAR_", "year", names(df))
newNames <- gsub("Living_Trees_tree", "stem", newNames)
newNames <- gsub("Density_tree.ha", "density_treeha", newNames)
newNames <- gsub("C130_moy_cm", "circunferenceBH_cm", newNames)
newNames <- gsub("Height_moy_m", "height1_m", newNames)
newNames <- gsub("Aboveground_biomass_kg_MS..ha", "aboveGroundBiomass_kgha", newNames)
names(df) <-  newNames

head(df)
df$dbh1_cm <- df$circunferenceBH_cm / pi

inFile <- "./LeBray/standdata_for_database_lebray.txt"
df2 <- read.table(inFile, header = T, sep = "\t")
names(df2)
names(df2) <- c("year", "species_id", "site_id", "heightArith_m", "dbhArith_cm",
                "ba_m2ha", "age", "density_treeha", "stem")

df <- merge(df2, df, by=c("year", "year"),suffixes = c("", "_new") )

names(df)
df <- df[, c("year", "site_id",  "species_id", "heightArith_m", "dbhArith_cm", "age", "ba_m2ha",
             "density_treeha", "aboveGroundBiomass_kgha")]
df$size_m2 <-  4756*10000
Stand_Data$LeBray <- df

#------------------------------------------------------------------------------#
# Hyytiala

load("./RData/ProfoundOtherData.RData")
df_list <- ProfoundOtherData$Finland$VegetationData$StandData
stand.names <- c( "year", "BAweightedMeanH_m", "BAweighteddbh1_cm", "BAweightedCrownL_m", "ArithmeticHeight_m", 
                  "Arithmeticdbh1_cm", "ArithmeticCrownL_m", "BA_m2", "age", "density_treeha")
stand.names <- c( "year", "heightBA_m", "dbhBA_cm", "BAweightedCrownL_m", "heightArith_m", 
                  "dbhArith_cm", "ArithmeticCrownL_m", "ba_m2ha", "age", "density_treeha")
for (i in 1:length(df_list)){
  names(  df_list[[i]] ) <- stand.names
  df_list[[i]]$species_id <- names(df_list)[i]
}
df_stand <- do.call(rbind, df_list)
rownames(df_stand) <- NULL
df_stand$species_id <- ifelse(df_stand$species_id == "pine", "pisy", ifelse(df_stand$species_id=="spruce", "piab", "hawo"))
# Add biomass
df_list <- ProfoundOtherData$Finland$VegetationData$Biomasses.kg.ha 
for (i in 1:length(df_list)){
  names(  df_list[[i]] ) <- c("year", "stemBiomass_kgha", "foliageBiomass_kgha", "branchesBiomass_kgha", "stumpCoarseRootBiomass_kgha")
  df_list[[i]]$species_id <- names(df_list)[i]
}
df_biomass <- do.call(rbind, df_list)
rownames(df) <- NULL
df_biomass$species_id <- ifelse(df_biomass$species_id == "pine", "pisy", ifelse(df_biomass$species_id=="spruce", "piab", "hawo"))
df_biomass$stem <- NULL
# Add lai
df_lai <- ProfoundOtherData$Finland$VegetationData$FoliageData$Foliage_LAI_Data$data
names(df_lai) <- c("year", names(df_lai)[1:length(df_lai)-1])
df_lai <-df_lai[c(1, 5:7)]
names(df_lai) <- c("year", "pisy", "piab", "hawo")
require(reshape)
df_lai <- melt(df_lai, id.vars ="year", variable_name ="species_id", value.name = "lai")
names(df_lai) <- gsub("value", "lai", names(df_lai))
# Now merge the three 
df <- Reduce(function(x, y) merge(x,y, by= c("year", "species_id"), all=T), list(df_stand, df_biomass, df_lai))
#df <- df[ df$year %in% unique(Tree_Data$Hyytiala$year), ]
names(df)

#df <- dropDuplicates(df, Tree_Data$Hyytiala)
write.table(df, "./Hyytiala/standdata_for_database.txt", row.names = F)
Stand_Data$Hyytiala <- df

#------------------------------------------------------------------------------#
# Peitz --> Better to take the heightG (basal area)
df <- read.table("./Peitz/standdata_for_database_Peitz.csv",header = TRUE, sep = ",")
names(df) <- gsub("remainingstand", "rem", names(df))
names(df) <- gsub("thinings", "thin", names(df))
names(df) <- gsub("totalstand", "tot", names(df))
names(df) <- gsub("intcrementot", "inc", names(df))
df
df <-df[, c("Datum", "BA", "Age", "rem_N_plot", "rem_heightG_m", "rem_heightO_m", "rem_DG_cm", "rem_DO_cm")]
names(df) <-  c("year", "species_id", "age", "stem", "heightBA_m", "height2_m", "dbhDQ_cm", "dbh2_cm")
df$stem <- as.numeric(sapply(df$stem,FUN =function(x)gsub("[(](\\w+)[)]", "\\1", x)))
df$species_id <-"pisy"
#df <- dropDuplicates(df, Tree_Data$Peitz)
#df <- df[ df$year %in% unique(Tree_Data$Peitz$year), ]
df$stem <- NULL
df
Stand_Data$Peitz <- df

#------------------------------------------------------------------------------#
# Solling 304
stand_file <- "./Solling_304/STAND_master_20_new.txt"
df <- read.table(stand_file, header=T, sep="\t")
df <- df[,colSums(is.na(df))<nrow(df)]
str(df)
head(df)
summary(df)
#names(df) <- gsub("dbh_cm", "dbhDQ_cm", names(df))
Stand_Data$Solling_304 <- df
  
  
#------------------------------------------------------------------------------#
# Solling 305
stand_file <- "./Solling_305/STAND_master_25_new.txt"
df <- read.table(stand_file, header=T, sep="\t")
df <- df[,colSums(is.na(df))<nrow(df)]
str(df)
head(df)
summary(df)
#names(df) <- gsub("dbh_cm", "dbhDQ_cm", names(df))
Stand_Data$Solling_305 <- df
#inFile <- "/home/trashtos/ownCloud/PROFOUND_Data/Processed/Soro/Standdata_for_DB.txt"
#df <- read.table(inFile, header = T, sep = "\t")
#df <- df[,colSums(is.na(df))<nrow(df)]
#Stand_Data$Soro
#variables <- unique(c(variables, names(df)))

#------------------------------------------------------------------------------#
# Soro
stand_file <- "./Soro/Soroe_LAI_2000_2013.RData"
load(stand_file)
str(Soroe_LAI_2000_2013.df)
cat(Soroe_LAI_2000_2013.df.des)
# Description is all  there
df <- Soroe_LAI_2000_2013.df
df$species_id <- "fasy"
# reduce to single lai measurement per year: 
# use only July measurements since most often lai is measured in July in Soro
df <- df[which(!duplicated(df$year)),]
head(df)
names(df) <- gsub("LAI", "lai", names(df))
Stand_Data$Soro<- df
#inFile <- "/home/trashtos/ownCloud/PROFOUND_Data/Processed/Soro/Standdata_for_DB.txt"
#df <- read.table(inFile, header = T, sep = "\t")
#df <- df[,colSums(is.na(df))<nrow(df)]
#Stand_Data$Soro

#------------------------------------------------------------------------------#
#Combine the Tree data
locations <- unique(c(names(Stand_Data), names(Stand_Data_Tree)))
# Remove Hyttiala from this
locations <- locations[c(1:2, 4:9)]

options(stringsAsFactors = FALSE)
for (i in 1:length(locations)){
  if(locations[i] %in% names(Stand_Data) & locations[i]  %in% names(Stand_Data_Tree)){
    Stand_Data[[locations[i]]] <- combineSTAND(stand = Stand_Data[[locations[i]]], standFromTree = Stand_Data_Tree[[locations[i]]])
  }else if (!locations[i]  %in% names(Stand_Data) & locations[i]  %in% names(Stand_Data_Tree)){
    Stand_Data[[locations[i]]] <- Stand_Data_Tree[[locations[i]]]
  }else{
    cat(locations[i]);cat("\n")
    cat("Nothing to do here\n\n")
  }
}

#------------------------------------------------------------------------------#
# Add the IDs
# Get sites
# Add the IDs
# Get sites
load("./RData/Sites.RData")
# get the  locations

site.id <-  Sites$site_id
names(site.id) <- Sites$site2

columns <- c("site_id", "year", "species_id", "age", "dbhArith_cm",
             "dbhBA_cm", "dbhDQ_cm", "heightArith_m", "heightBA_m", "ba_m2ha",
             "density_treeha",  "aboveGroundBiomass_kgha",
             "foliageBiomass_kgha", "branchesBiomass_kgha", "stemBiomass_kgha", "rootBiomass_kgha",
             "stumpCoarseRootBiomass_kgha", "coarseBiomass_kgha", "lai")


for (i in 1:length(Stand_Data)){
  file.site <- names(Stand_Data)[i]
  Stand_Data[[i]]$site_id <- site.id[[file.site]]
  Stand_Data[[i]]$site <- file.site
  for (j in 1:length(columns)){
    if (columns[j] %in% names(Stand_Data[[i]]) == FALSE){
      Stand_Data[[i]][[columns[j]]] <- NA
    }
  }
  #Stand_Data[[i]]$age <- round(Stand_Data[[i]]$age)
}

# Correction to Soro missing ages
Stand_Data$Soro[is.na(Stand_Data$Soro$age),]$age <- c(90,91,92,93)
Stand_Data$Soro[is.na(Stand_Data$Soro$species_id),]$species_id <-"fasy"
tail(Stand_Data$Soro$age)

save(Stand_Data, file="./RData/Stand_Data.RData")

#------------------------------------------------------------------------------#
#                         Check Data
#------------------------------------------------------------------------------#
load("./RData/Stand_Data.RData")

str(Stand_Data,1)

#sink("./RData/Stand_Data.txt")
#str(Stand_Data)
#sink()

dummy <- Reduce(rbind.all, Stand_Data)

dummy <- dummy[,colSums(is.na(dummy))<nrow(dummy)]

write.table(dummy, file =paste("~/", "dummy", sep = ""),
            sep = "\t", row.names = F)
options(stringsAsFactors = TRUE)
