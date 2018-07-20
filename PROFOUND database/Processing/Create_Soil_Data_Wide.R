#------------------------------------------------------------------------------#
#                               SOIL DATA
#------------------------------------------------------------------------------#
# Variables
#      thick - thickness [cm] // depth (CM)
#      pv - pore volume [Vol%]
#      f_cap_v - field capacity [Vol.%] 
#      wilt_p_v - wilting point [vol%]
#      dens - bulk density [g/cm³] 
#      spHeat - specific heat capacity   J/(g K)
#      pHv - pH value
#      wlam - lambda-parameter for percolation
#      gravel - soil skeleton fraction [%] 
#      sand  - sand [mass%]  
#      clay  - clay [mass%]
#      humus - content of humus  [mass%]
#      C_hum - C-content of humus per layer [g/m²]
#      N_hum - N-content of humus per layer[g/m²]
#      NH4  -   [g/m²]
#      NO3  -   [g/m²]
#      Texture - According to German classification (AG Boden 2005)
# 
#------------------------------------------------------------------------------#
#                           Melt the soil Data
#------------------------------------------------------------------------------#
source("~/Github/COST-FP1304-PROFOUND/TG2/Processing/utilities.R")
directory <- "~/ownCloud/PROFOUND_Data/Processed/"
setwd(directory)

require(reshape2)
Soil_Data_Wide <- list()


#------------------------------------------------------------------------------#
#                             
#------------------------------------------------------------------------------#
# Soil data is available for?
#         Peitz
#         Solling
#         Kroof
#         Hyytiala
#         Soro
#         Bily Kriz

load("./RData/ProfoundOtherData.RData")
str(ProfoundOtherData,1)
# What can we do?
# Peitz is nice formated
str(ProfoundOtherData$Germany$Peitz,1)
str(ProfoundOtherData$Germany$Peitz$SoilData,1)
head(ProfoundOtherData$Germany$Peitz$SoilData)

# Solllind not at all
str(ProfoundOtherData$Germany$Peitz$SoilData,1)
head(ProfoundOtherData$Germany$Solling$SollingB1_304$SollingB1_304_parameters_soil)

Soil_Data_Wide <- list()


#------------------------------------------------------------------------------#
#                             Arrange Soil data of Hyytiala
#------------------------------------------------------------------------------#
df <- read.table("./Hyytiala/soil_09032016_corrected.csv",
                 sep = ",",header = TRUE)

variables_description <- names(df)

variables_names <- c("ID",  "horizon", "upperDepth_cm", "lowerDepth_cm", "type",
                    "clay_percent", "silt_percent", "sand_percent", "gravel_percent",
                    "porosity_percent","fcapv_percent", "wiltpv_percent",
                    "density_gcm3", "ph_cacl2",
                    "c_percent", "n_percent", "sources_remarks")
names(df) <- variables_names
df$type <- NULL
df$ID <- NULL
df$sources_remarks <- NULL
# From paper
df$type_fao <- "Haplic Podzol"

df$layer_id <- c(1:length(df[,1]))
df$table_id <- 1
df$date <- "1995-1996" # A description of the establishment of SMEAR II soil experimental are in the summer of 1995 and 1996.
Soil_Data_Wide$Hyytiala <- df
#------------------------------------------------------------------------------#
#                            Bily Kriz
#------------------------------------------------------------------------------#
df <- read.table("./BilyKriz/soildata_parameters_bilykriz_new.txt",
                 header = TRUE, sep="\t")
variables_description <- names(df)
variables_description <- gsub("_", " ", variables_description)
variables_description[2] <- "soil type FAO. Soil profile analysis on FAO/ISSS (1998): Haplic Podzols. Literature: ISSS-ISRIC-FAO (1998) World reference basis for soil resources. World Soil Resources Reports 84. FAO, Rome. 92 p.
depth for horizon L, F and H from FAO classification"
variables_description[4] <- "thickness cm.  Soil depth: 60 - 80 cm" 
variables_names <- c("horizon", "type_fao", "texture", "thickness_cm", "upperDepth_cm","lowerDepth_cm",
                    "cMin_percent", "cMax_percent", "C_CV_percent", "nMin_percent", "nMax_percent", "N_CV_percent",
                    "clay_gKg", "silt_gKg", "sand_gKg","clay_percent", "silt_percent",
                    "sand_percent", "density_gcm3", "cOrg_gcm3")

names(df) <- variables_names
df$C_CV_percent <- NULL
df$N_CV_percent <- NULL
df$date <- 2011 #Lenka: Complete soil analyses were done and data provided by Pavel Formánek in 2011. We don't have data published.
df$clay_gKg <- NULL
df$silt_gKg <- NULL
df$sand_gKg <- NULL
df$type_fao <- "Haplic Podzol"
# need a column ID

df$layer_id <- c(1:length(df[,1]))
df$table_id <- 1

Soil_Data_Wide$BilyKriz <- df


#------------------------------------------------------------------------------#
#                            Collelongo
#------------------------------------------------------------------------------#
# There are two tables
df_collelongo <- read.table( "./Collelongo/SOIL_201604190947-1.csv",
                 header = TRUE, sep=",")

df <- df_collelongo[df_collelongo$Table_ID == 1,]

variables_description <- df$description
variables_names <- unique(df$variable)

variables_description <- c("upper limit of layer cm", "lower limit of layer cm",
                          "% Organic carbon", "%  Total Nitrogen",  "% Clay",
                          "% Silt","% Sand", "Bulk density g cm -3",
                          "pH value KCl", "pH value H2O", 
                          "Field capacity -0.3 bar",
                          "permanent wilting point -15 bar")

head(df)
df$variable <- gsub("[:01235468:]", "", df$variable )
df$variable <- gsub("[\\_]+[\\-]+[\\.]", "", df$variable )
df$variable <- gsub("[\\_]+[\\-]", "", df$variable )
df <- dcast(df, Layer_ID ~ variable , value.var="value")
# From paper 
df$type_fao <- "Dystric Luvisol"

df$Layer_ID <- NULL
df$upperDepth_cm <-c(0, 10, 20, 40)
df$lowerDepth_cm <- c(10, 20, 40, 80)
# need a column ID
df$layer_id <- c(1:length(df[,1]))
df$table_id <- 1

df_2 <- df_collelongo[df_collelongo$Table_ID == 2,]
variables_description <- df_2$description
variables_names <- unique(df_2$variable)
head(df_2)
df_2 <- dcast(df_2,  Table_ID  ~ variable , value.var="value")
df_2$Table_ID <- NULL
# need a column ID
df_2$layer_id <- c(1:length(df_2[,1]))
df_2$table_id <- 2
df <- rbind.all(df, df_2)

newNames <- names(df)
newNames <- gsub( "BD","density_gcm3" , newNames )
newNames <- gsub( "clay","clay_percent" , newNames )
newNames <- gsub( "sand","sand_percent" , newNames )
newNames <- gsub( "silt","silt_percent" , newNames )
newNames <- gsub( "wilt_p_v-bar","wiltpv_percent" , newNames )
newNames <- gsub( "f_cap","fcapv_percent" , newNames )
newNames <- gsub( "ph_H","ph_h2o" , newNames )
newNames <- gsub( "ph_KCL","ph_kcl" , newNames )
newNames <- gsub( "OFH_C","ofhC_percent" , newNames )
newNames <- gsub( "OFH_N","ofhN_percent" , newNames )
newNames <- gsub( "OFH$","ofh_gDWm2" , newNames )
newNames <- gsub( "OL","ol_gDWm2" , newNames )
newNames <- gsub( "C$","c_percent" , newNames )
newNames <- gsub( "N$","n_percent" , newNames )
names(df) <- newNames

Soil_Data_Wide$Collelongo <- df
#------------------------------------------------------------------------------#
#                             Arrange Soil data of Kroof
#------------------------------------------------------------------------------#
# There are two tables
df <- read.table( "./Kroof/soildata_for_database1.csv",
                 header = TRUE, sep="\t")

variables_description <- names(df)
variables_description 
variables_names <- c("depth_cm", "horizon", "texture", "density_kgL","whcp",  "pH_H2O",
                    "pH_KCl", "cec_µeqg", "bs_percent")

names(df) <- variables_names
# need a column ID
df$layer_id <- c(1:length(df[,1]))
df <- df[c(1:8),]
df$table_id <- 1
df$upperDepth_cm <- gsub( "-.*", "" , as.character(df$depth_cm))
df$lowerDepth_cm <- gsub( ".*-", "" , as.character(df$depth_cm))
df$depth_cm <- NULL
df$density_gcm3 <- df$density_kgL 
df$density_kgL  <- NULL
df$type_fao <- "Luvisol"

# get the second table
# There are two tables
df_2 <- read.table("./Kroof/soildata_for_database2.csv",
                 header = TRUE, sep="\t")

variables_description <- names(df_2)
variables_description 
variables_names <- c("depth_cm", "fcapv_percent", "wiltpv_percent")

variables_description  <- c("Depth cm", "field capacity vol percent",
                            " wilting point vol percent")

names(df_2) <- variables_names
df_2$upperDepth_cm <- gsub( "-.*", "" , as.character(df_2$depth_cm))
df_2$lowerDepth_cm <- gsub( ".*-", "" , as.character(df_2$depth_cm))
df_2$depth_cm <- NULL
# need a column ID
df_2$layer_id <- c(1:length(df_2[,1]))
df_2 <- df_2[1:4,]
df_2$table_id <- 2

ddf <- rbind.all(df, df_2)
names(df) <- gsub( "pH_H2O","ph_h2o" , names(df) )
names(df) <- gsub( "pH_KCl","ph_kcl" , names(df) )

df$type_fao <- "Luvisol"
Soil_Data_Wide$Kroof <- df
#------------------------------------------------------------------------------#
#                             Arrange Soil data of LeBray
#------------------------------------------------------------------------------#
df1 <- read.table( "./LeBray/soildata_singleMeasurements.txt",
                         header = TRUE, sep="\t")
names(df1) <- c("thickness_cm", "thicknesSigma_cm")
df1$thickness_cm <- df1$thickness_cm*100
df1$thicknesSigma_cm <- df1$thicknesSigma_cm*100
df1$layer_id <- c(1:length(df1[,1]))
df1$table_id <- 1


df2 <- read.table( "./LeBray/soildata_horizonMeasurements.txt",
                   header = TRUE, sep=",")
names(df2) <- c("horizon", "upperDepth_cm", "lowerDepth_cm", "sand_percent",
                "silt_percent", "clay_percent", "gravel_percent", "whc_mm","whcSigma_mm" )

df2$upperDepth_cm <- df2$upperDepth_cm*100
df2$lowerDepth_cm <- df2$lowerDepth_cm*100
df2$layer_id <- c(1:length(df2[,1]))
df2$table_id <- 2

df3 <- read.table( "./LeBray/soildata_datahorizonMeasurements1.txt",
                   header = TRUE, sep="\t")
df3$SOIL_PH_PROFILE_MIN <- NULL
df3$SOIL_PH_PROFILE_MAX <- NULL
df3$SOIL_PH_HORIZON <- NULL
names(df3) <- c("date", "density_gcm3", "upperDepth_cm", "lowerDepth_cm", "horizon",
                "ph_h2o")
df3$upperDepth_cm <- df3$upperDepth_cm*100
df3$lowerDepth_cm <- df3$lowerDepth_cm*100
df3$layer_id <- c(1:length(df3[,1]))
df3$table_id <- 3



df4 <- read.table( "./LeBray/soildata_datahorizonMeasurements2.txt",
                   header = TRUE, sep="\t")
df4$SOIL_BD_PROFILE_MIN <- NULL
df4$SOIL_BD_PROFILE_MAX <- NULL
df4$SOIL_BD_HORIZON <- NULL
df4$SOIL_C_PROFILE_MIN <- NULL
df4$SOIL_C_PROFILE_MAX <- NULL
df4$SOIL_C_HORIZON <- NULL
df4$SOIL_N_SIGMA <- NULL
df4$SOIL_C_DATE <- NULL
df4$SOIL_N_DATE <- NULL
df4$SOIL_N_PROFILE_MIN <- NULL
df4$SOIL_N_PROFILE_MAX <- NULL
df4$SOIL_N_HORIZON <- NULL
names(df4) <- c("date","horizon", "upperDepth_cm", "lowerDepth_cm", "density_gcm3",
                "c_kgm2", "cSigma_kgm2", "n_kgm2")

df4$upperDepth_cm <- df4$upperDepth_cm*100
df4$lowerDepth_cm <- df4$lowerDepth_cm*100
df4$layer_id <- c(1:length(df4[,1]))
df4$table_id <- 4

df5 <- read.table( "./LeBray/soildata_datahorizonMeasurements3.txt",
                   header = TRUE, sep="\t")
df5$SOIL_C_SIGMA <- NULL
df5$SOIL_C_DATE <- NULL
names(df5) <- c("date", "c_kgm2","upperDepth_cm", "lowerDepth_cm", "horizon")

df5$upperDepth_cm <- df5$upperDepth_cm*100
df5$lowerDepth_cm <- df5$lowerDepth_cm*100
df5$layer_id <- c(1:length(df5[,1]))
df5$table_id <- 5

df6 <- read.table( "./LeBray/soildata_datahorizonMeasurements4.txt",
                   header = TRUE, sep="\t")
df6$HORIZON <- NULL
df6$SOIL_BD_PROFILE_MIN <- NULL
df6$SOIL_BD_PROFILE_MAX <- NULL
df6$SOIL_BD_HORIZON <- NULL
df6$SOIL_BD_DATE <- NULL
names(df6) <- c("date", "upperDepth_cm", "lowerDepth_cm", "density_gcm3","densitySigma_gcm3")
df6$upperDepth_cm <- df6$upperDepth_cm*100
df6$lowerDepth_cm <- df6$lowerDepth_cm*100
df6$layer_id <- c(1:length(df6[,1]))
df6$table_id <- 6

df7 <- read.table( "./LeBray/soildata_datahorizonMeasurements5.txt",
                   header = TRUE, sep="\t")
df7$SOIL_C_PROFILE_MIN <- NULL
df7$SOIL_C_PROFILE_MAX <- NULL
df7$SOIL_C_HORIZON <- NULL
names(df7) <- c("date", "upperDepth_cm", "lowerDepth_cm", "horizon", "c_kgm2",
                "cSigma_kgm2")
df7$upperDepth_cm <- df7$upperDepth_cm*100
df7$lowerDepth_cm <- df7$lowerDepth_cm*100
df7$layer_id <- c(1:length(df7[,1]))
df7$table_id <- 7

df_list <- list(df3,df4,df5,df6,df7)
df <- rbind.all(df1, df2)
for (i in 1:length(df_list)){
  df <- rbind.all(df, df_list[[i]])
}

df$type_fao <- "Arenosol"
Soil_Data_Wide$LeBray <- df
#------------------------------------------------------------------------------#
#                             Arrange Soil data of Peitz
#------------------------------------------------------------------------------#

df <- ProfoundOtherData$Germany$Peitz$SoilData
names(df)
df$sid <- NULL

variables_description <- names(df)
variables_description <- gsub("[.][.][.]", "", variables_description)
variables_description <- gsub("[.][.]", " ", variables_description)
variables_description <- gsub("[.]", " ", variables_description)

variables_names<- c("horizon", "horizon_n",  "upperDepth_cm","lowerDepth_cm", "clay_percent", "silt_percent",
                   "sand_percent", "gravel_percent","porosity_percent", "fcapv_percent", "wiltpv_percent", "density_gcm3",
                   "ph_h2o", "ph_kcl", "cn", "c_percent", "n_percent", "dryMass_gm2")
names(df) <- variables_names
df[6, "n_percent"] <- 0.003 # Correction
# need a column ID
df$layer_id <- c(1:length(df[,1]))
df$table_id <- 1
df$horizon_n <- NULL
df$dryMass_gm2 <- NULL

# Soil data coming from stand data
df_2 <- as.data.frame(list(nutrient =  "low", local_type ="Baerenthoren Sand-Braunerde (Arenosol)" ))
df_2$layer_id <- c(1:length(df_2[,1]))
df_2$table_id <- 2

df$type_fao <- "Dystric Cambisol"

# df <- rbind.all(df, df_2) # Table two irrelevant (PI)
write.table(df, "./Peitz/soildata_for_database.txt", row.names = F)
Soil_Data_Wide$Peitz <- df

#------------------------------------------------------------------------------#
#                             Arrange Soil data of Solling 304
#------------------------------------------------------------------------------#
# create the column names
df <- read.table("./Solling_304/SOIL_master_20.txt",
                 header = T, sep="\t")

df <- df[,colSums(is.na(df))<nrow(df)]
names(df) <- gsub("C_min", "cMin_percent", names(df))
names(df) <- gsub("C_max", "cMax_percent", names(df))
names(df) <- gsub("N_min", "nMin_percent", names(df))
names(df) <- gsub("N_max", "nMax_percent", names(df))
names(df) <- gsub("CN", "cn", names(df))
names(df) <- gsub("fineRoot_fraction", "fineRoot_percent", names(df))
names(df) <- gsub( "pH_H2O","ph_h2o" , names(df) )
names(df) <- gsub( "pH_KCl","ph_kcl" , names(df) )
names(df) <- gsub( "CEC_Âµeqg","cec_µeqg" , names(df) )
names(df) <- gsub("C_percent", "c_percent", names(df))
names(df) <- gsub("N_percent", "n_percent", names(df))
names(df) <- gsub("BS_percent", "bs_percent", names(df))
names(df) <- gsub("type_FAO", "type_fao", names(df))
names(df) <- gsub("type_KA5", "type_ka5", names(df))
names(df) <- gsub("N_kgm2", "n_kgm2", names(df))
names(df) <- gsub("Corg_percent", "cOrg_percent", names(df))

# need a column ID
df$layer_id <- c(1:length(df[,1]))
df$table_id <- 1
# Add variable description
df$stoniness_percent <- NULL
df$stone_percent <- NULL
df$dens_kgL <-  NULL
df$clay_gKg <- NULL
df$silt_gKg <- NULL
df$sand_gKg <- NULL
df$porosity_volume <- NULL
df$minDepth_cm <- NULL
df$maxDepth_cm <- NULL
df$symbol <- NULL
#df$date <- 2010
df$type_fao <- "Haplic Cambisol"
Soil_Data_Wide$Solling_304 <- df

#------------------------------------------------------------------------------#
#                             Arrange Soil data of Solling 305
#------------------------------------------------------------------------------#
# create the column names
df <- read.table("./Solling_305/SOIL_master_25.txt",
                 header = T, sep="\t")

df <- df[,colSums(is.na(df))<nrow(df)]

names(df) <- gsub("C_min", "cMin_percent", names(df))
names(df) <- gsub("C_max", "cMax_percent", names(df))
names(df) <- gsub("N_min", "nMin_percent", names(df))
names(df) <- gsub("N_max", "nMax_percent", names(df))
names(df) <- gsub("CN", "cn", names(df))
names(df) <- gsub("fineRoot_fraction", "fineRoot_percent", names(df))
names(df) <- gsub( "pH_H2O","ph_h2o" , names(df) )
names(df) <- gsub( "pH_KCl","ph_kcl" , names(df) )
names(df) <- gsub( "CEC_Âµeqg","cec_µeqg" , names(df) )
names(df) <- gsub("C_percent", "c_percent", names(df))
names(df) <- gsub("N_percent", "n_percent", names(df))
names(df) <- gsub("BS_percent", "bs_percent", names(df))
names(df) <- gsub("type_FAO", "type_fao", names(df))
names(df) <- gsub("type_KA5", "type_ka5", names(df))
names(df) <- gsub("N_kgm2", "n_kgm2", names(df))
names(df) <- gsub("Corg_percent", "cOrg_percent", names(df))
# 
df$stoniness_percent <- NULL
df$dens_kgL <-  NULL
df$stone_percent <- NULL
df$clay_gKg <- NULL
df$silt_gKg <- NULL
df$sand_gKg <- NULL
df$porosity_volume <- NULL
df$minDepth_cm <- NULL
df$maxDepth_cm <- NULL
df$symbol <- NULL

# need a column ID
df$layer_id <- c(1:length(df[,1]))
df$table_id <- 1
# Add variable description
df$type_fao <- "Haplic Cambisol (dystric, densic)l"
#df$date <- 2010
Soil_Data_Wide$Solling_305 <- df


#------------------------------------------------------------------------------#
#                             Arrange Soil data of Soro
#------------------------------------------------------------------------------#
df <- read.table("./Soro/Soroe_20110329_SoilProfiles_singleMeasurements1_data.txt",
                 sep = "\t",header = TRUE)

df$layer_id <- c(1:length(df[,1]))
df$table_id <- 1
df$upperDepth_cm <-gsub( "-.*", "" , as.character(df$depth_m))
df$lowerDepth_cm <- gsub( ".*-", "" , as.character(df$depth_m))
df$depth_m <- NULL
df


df2 <- read.table("./Soro/Soroe_20110329_SoilProfiles_horizonMeasurements1_data.txt",
                 sep = "\t",header = TRUE)
df2$upperDepth_cm <- df2$upperDepth_m * 100
df2$lowerDepth_cm <- df2$lowerDepth_m * 100
df2$upperDepth_m <-NULL
df2$lowerDepth_m <- NULL
df2$layer_id <- c(1:length(df2[,1]))
df2$table_id <- 2
df2

df <- rbind.all(df, df2)

df2 <- read.table("./Soro/Soroe_20110329_SoilProfiles_horizonMeasurements2_data.txt",
                  sep = "\t",header = TRUE)
df2$upperDepth_cm <- df2$upperDepth_m 
df2$lowerDepth_cm <- df2$lowerDepth_m 
df2$upperDepth_m <-NULL
df2$lowerDepth_m <- NULL
df2$layer_id <- c(1:length(df2[,1]))
df2$table_id <- 3
df2

df <- rbind.all(df, df2)

df2 <- read.table("./Soro/Soroe_20110329_SoilProfiles_horizonMeasurements3_data.txt",
                  sep = "\t",header = TRUE)
df2$upperDepth_cm <- df2$upperDepth_m # What to do
df2$lowerDepth_cm <- df2$lowerDepth_m 
df2$upperDepth_m <-NULL
df2$lowerDepth_m <- NULL
df2$layer_id <- c(1:length(df2[,1]))
df2$table_id <- 4
df2

df <- rbind.all(df, df2)

df2 <- read.table("./Soro/Soroe_20110329_SoilProfiles_horizonMeasurements4_data.txt",
                  sep = "\t",header = TRUE)
df2$upperDepth_cm <- df2$upperDepth_m 
df2$lowerDepth_cm <- df2$lowerDepth_m 
df2$upperDepth_m <-NULL
df2$lowerDepth_m <- NULL
df2$layer_id <- c(1:length(df2[,1]))
df2$table_id <- 5
df2

df <- rbind.all(df, df2)

names(df)
names(df) <- gsub("type_FAO", "type_fao", names(df))
names(df) <- gsub("density_sigma", "densitySigma_gcm3", names(df))
names(df) <- gsub("MBN_mgNg", "mbN_mgg", names(df))
names(df) <- gsub("MBNSigma_mgNg", "mbNSigma_mgg", names(df))
names(df) <- gsub("MBN_mgNg", "mbN_mgg", names(df))
names(df) <- gsub("MBNSigma_mgNg", "mbNSigma_mgg", names(df))
names(df) <- gsub("MBC_mgCg", "mbC_mgg", names(df))
names(df) <- gsub("MBCSigma_mgCg", "mbCSigma_mgg", names(df))
names(df) <- gsub("Rmin_mgNkgH", "rMin_mgNkgH", names(df))
names(df) <- gsub("RminSigma_mgNkgH", "rMinSigma_mgNkgH", names(df))
names(df) <- gsub("Corg_percent", "cOrg_percent", names(df))
names(df) <- gsub("CorgSigma_percent", "cOrgSigma_percent", names(df))
names(df) <- gsub("Norg_percent", "nOrg_percent", names(df))
names(df) <- gsub("NorgSigma_percent", "nOrgSigma_percent", names(df))

df$type_fao <- "Alfisols/Molisols"
Soil_Data_Wide$Soro <- df


#------------------------------------------------------------------------------#
# Add the IDs
# Get sites
load("./RData/Sites.RData")
# get the  locations
Site <- Sites$site2
Site.id <-  Sites$site_id
names(Site.id) <- Site



for (i in 1:length(Soil_Data_Wide)){
  file.site <- names(Soil_Data_Wide)[i]
  Soil_Data_Wide[[i]]$site_id <- Site.id[[file.site]]
  Soil_Data_Wide[[i]]$site <- file.site
}


hola <- Reduce(rbind.all, Soil_Data_Wide)


Soil_Data_Wide <- Reduce(rbind.all, Soil_Data_Wide)


save(Soil_Data_Wide, file="./RData/Soil_Data_Wide.RData")
#------------------------------------------------------------------------------#
#                           Revise FAO soil type  
#------------------------------------------------------------------------------#
unique(Soil_Data_Wide[Soil_Data_Wide$site=="BilyKriz",]$type_fao)


#------------------------------------------------------------------------------#
#                           Check and Report
#------------------------------------------------------------------------------#
### Check data
load("./RData/Soil_Data_Wide.RData")

str(Soil_Data_Wide,1)

#sink("./RData/Soil_Data_Wide.txt")
#str(Soil_Data_Wide)
#sink()


