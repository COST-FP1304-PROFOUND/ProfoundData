#------------------------------------------------------------------------------#
#                               MODIS
#------------------------------------------------------------------------------#
# It must be derived for:
directory <- "~/ownCloud/PROFOUND_Data/Processed/"
setwd(directory)

#------------------------------------------------------------------------------#
#                               MODIS
#------------------------------------------------------------------------------#
MODIS_Data.files <- c("./MODIS/Update/GPP_MOD17A231march_final.txt",
                      "./MODIS/Update/LSTemperatureMOD11A231march_final.txt",
                      "./MODIS/Update/Reflectance_Indexes_MOD09A131march_final.txt",
                      "./MODIS/Update/LAI_FPAR_MOD15A231march_final.txt"
                      ,"./MODIS/Update/VegetationIndices_MOD13Q131march_final.txt")

modis.df <- lapply(MODIS_Data.files, function(x) read.table(x, sep = "\t", header = T))
          
#------------------------------------------------------------------------------#
#                               MODIS dataset 1 MOD17A2
#------------------------------------------------------------------------------#         
head(modis.df[[1]])
nrow(modis.df[[1]])
names(modis.df[[1]])
names(modis.df[[1]]) <- gsub("GPP.Quality", "gpp_qc", names(modis.df[[1]]))
names(modis.df[[1]]) <- gsub("Gpp_1km", "gpp_gCm2d", names(modis.df[[1]]))
names(modis.df[[1]]) <- gsub("PsnNet_1km", "psNet_gCm2d", names(modis.df[[1]]))
unique(modis.df[[1]]$gpp_qc)
table(modis.df[[1]]$gpp_qc)
modis.df[[1]]$gpp_qc <- ifelse(modis.df[[1]]$gpp_qc=="good quality", 0, ifelse(modis.df[[1]]$gpp_qc=="other quality ",2, 99))
modis.df[[1]]$psNet_qc <- modis.df[[1]]$gpp_qc

head(modis.df[[1]])
#------------------------------------------------------------------------------#
#                               MODIS dataset 2 MOD11A2
#------------------------------------------------------------------------------#  
head(modis.df[[2]])
nrow(modis.df[[2]])
names(modis.df[[2]])
names(modis.df[[2]]) <- gsub("LST_Day_1km", "lstDay_degK", names(modis.df[[2]]))
names(modis.df[[2]]) <- gsub("LST_Night_1km", "lstNight_degK", names(modis.df[[2]]))
names(modis.df[[2]]) <- gsub("Quality_Day", "lstDay_qc", names(modis.df[[2]]))
names(modis.df[[2]]) <- gsub("Quality_Night", "lstNight_qc", names(modis.df[[2]]))
unique(modis.df[[2]]$lstDay_qc) 
table(modis.df[[2]]$lstDay_qc) 
modis.df[[2]]$lstDay_qc <- ifelse(modis.df[[2]]$lstDay_qc == "good quality", 0,
                                  ifelse(modis.df[[2]]$lstDay_qc == "other quality",2, 
                                   ifelse(modis.df[[2]]$lstDay_qc == "interpolated",3,
                                    ifelse(modis.df[[2]]$lstDay_qc == "not produced",4,
                                     99
                                  ))))
unique(modis.df[[2]]$lstNight_qc) 
table(modis.df[[2]]$lstNight_qc) 
modis.df[[2]]$lstNight_qc <- ifelse(modis.df[[2]]$lstNight_qc == "good quality", 0,
                                  ifelse(modis.df[[2]]$lstNight_qc == "other quality",2, 
                                  ifelse(modis.df[[2]]$lstNight_qc == "interpolated",3,
                                  ifelse(modis.df[[2]]$lstNight_qc == "not produced",4,
                                   99
                                  ))))

head(modis.df[[2]])
#------------------------------------------------------------------------------#
#                               MODIS dataset 3 MOD09A1
#------------------------------------------------------------------------------#         
head(modis.df[[3]])
names(modis.df[[3]])
names(modis.df[[3]]) <-c("IDrecord", "site", "date", "day", "mo", "year", "reflB01_percent", "reflB02_percent",
                         "reflB03_percent","reflB04_percent", "reflB05_percent", "reflB06_percent", "reflB07_percent",
                         "refl_qc",
                         "aB01_rad" , "aB02_rad", "aB05_rad", "aB06_rad",
                         "ndwi", "ndvi", "evi", "sasi_rad", "sani_rad")
                        
                         


unique(modis.df[[3]]$refl_qc)
table(modis.df[[3]]$refl_qc)
modis.df[[3]]$refl_qc <-  ifelse(modis.df[[3]]$refl_qc =="corrected product produced at ideal quality-all bands" , 0, 
                                  ifelse(modis.df[[3]]$refl_qc == "corrected product produced at less than ideal quality - some or all bands", 2,
                                  ifelse(modis.df[[3]]$refl_qc == "Interpolated values", 3,
                                  ifelse(modis.df[[3]]$refl_qc == "corrected product not produced ", 4,
                                   ifelse(modis.df[[3]]$refl_qc == "Missing data ", 5,
                                   99)))))
                                              
#"reflB01_qc", "reflB02_qc", "reflB03_qc", "reflB04_qc", "reflB05_qc", "reflB06_qc", "reflB07_qc",


replaceQC <- function(x){
  x <- ifelse(x =="highest quality" , 0, 
              ifelse(x == "dead detector", 1,
              ifelse(x == "solar zenith >= 86 degrees", 2,
              ifelse(x =="solar zenith >= 85 and < 86 degrees" , 3,
              ifelse(x == "missing input", 4,
              ifelse(x == "internal constant  used in place of climatological data for at least one atmospheric constant", 5,
              ifelse(x == "correction out of bounds pixel constrained to extreme allowable value", 6,
              ifelse(x == "L1B data faulty" , 7,
              ifelse(x == "not processed due to deep ocean or clouds", 8,
              99)))))))))
  return(x)
}
#unique(replaceQC(modis.df[[3]]$reflB07_qc))
#modis.df[[3]]$reflB01_qc <- replaceQC(modis.df[[3]]$reflB01_qc)
#modis.df[[3]]$reflB02_qc <- replaceQC(modis.df[[3]]$reflB02_qc)
#modis.df[[3]]$reflB03_qc <- replaceQC(modis.df[[3]]$reflB03_qc)
#modis.df[[3]]$reflB04_qc <- replaceQC(modis.df[[3]]$reflB04_qc)
#modis.df[[3]]$reflB05_qc <- replaceQC(modis.df[[3]]$reflB05_qc)
#modis.df[[3]]$reflB06_qc <- replaceQC(modis.df[[3]]$reflB06_qc)
#modis.df[[3]]$reflB07_qc <- replaceQC(modis.df[[3]]$reflB07_qc)
# Add sani corrected
df <-  read.table("./MODIS/Update2/SANI_corr_enviar.csv", sep = ",", header = T)
head(df)
head(modis.df[[3]])
df$id <- paste(df$site, df$date, sep="_")
df <- df[, colnames(df) %in% c("id", "SANI")]
head(df)
modis.df[[3]]$id <- paste(modis.df[[3]]$site, modis.df[[3]]$date, sep="_")
modis.df[[3]] <- merge(modis.df[[3]], df, by = c("id", "id"), all = T)
head(modis.df[[3]])
modis.df[[3]]$sani_rad <- modis.df[[3]]$SANI
modis.df[[3]]$SANI <- NULL
modis.df[[3]]$id <- NULL
#------------------------------------------------------------------------------#
#                               MODIS dataset 4 MOD15A2
#------------------------------------------------------------------------------#         
head(modis.df[[4]])
names(modis.df[[4]])
names(modis.df[[4]]) <- gsub("Fpar_1km", "fpar_percent", names(modis.df[[4]]))
names(modis.df[[4]]) <- gsub("Lai_1km", "lai", names(modis.df[[4]]))
names(modis.df[[4]]) <- gsub("LAI.Quality", "lai_qc", names(modis.df[[4]]))

unique(modis.df[[4]]$lai_qc)
table(modis.df[[4]]$lai_qc)
modis.df[[4]]$lai_qc <-  ifelse(modis.df[[4]]$lai_qc== "good quality", 0,
                                ifelse(modis.df[[4]]$lai_qc== "other quality", 2,
                                ifelse(modis.df[[4]]$lai_qc== "interpolated", 3,
                                ifelse(modis.df[[4]]$lai_qc== "pixel not produced", 4,
                                       99 ))))
modis.df[[4]]$fpar_qc <- modis.df[[4]]$lai_qc       
head(modis.df[[4]])
#------------------------------------------------------------------------------#
#                               MODIS dataset 5 MOD13Q1
#------------------------------------------------------------------------------#         
head(modis.df[[5]])
names(modis.df[[5]])
names(modis.df[[5]]) <- gsub("A250m_16_days_EVI", "evi", names(modis.df[[5]]))
names(modis.df[[5]]) <- gsub("A250m_16_days_NDVI", "ndvi", names(modis.df[[5]]))
names(modis.df[[5]]) <- gsub("Index.Quality", "evi_qc", names(modis.df[[5]]))
unique(modis.df[[5]]$evi_qc)
table(modis.df[[5]]$evi_qc)
modis.df[[5]]$evi_qc <-  ifelse(modis.df[[5]]$evi_qc== "good quality", 0,
                                ifelse(modis.df[[5]]$evi_qc== "other quality", 2,
                                       ifelse(modis.df[[5]]$evi_qc== "interpolated", 3,
                                                     99 )))
modis.df[[5]]$ndvi_qc <- modis.df[[5]]$evi_qc
head(modis.df[[5]])
names(modis.df[[5]])
#------------------------------------------------------------------------------#
#                               MODIS:  CLEAN AND TIDY UP
#------------------------------------------------------------------------------#      

is.finite.data.frame <- function(obj){
  sapply(obj,FUN = function(x) all(is.finite(x[is.na(x)])))
}
for (i in 1:length(modis.df)){
  modis.df[[i]] <- modis.df[[i]][modis.df[[i]]$site != "Norunda",]
  tmp <- as.matrix(is.finite((modis.df[[i]])))
  print(tmp)
}
# Add sites
load("./RData/Sites.RData")
Sites <- Sites[, c("site_id", "name2")]
site_id <- Sites[, "site_id"]
names(site_id) <- Sites[, "name2"]

# check sites and site id
lapply(modis.df, function(x)unique(x$site))
modis.sites <- unique(unlist(lapply(modis.df, function(x)unique(x$site))))

modis.sites

for (i in 1:length(modis.df)){
  modis.df[[i]] <- modis.df[[i]][!is.na(modis.df[[i]]$site),]
  modis.df[[i]]$site <- ifelse( modis.df[[i]]$site=="Solling_beech", "Solling_304", as.character( modis.df[[i]]$site))
  dummy <- modis.df[[i]][modis.df[[i]]$site == "Solling_304",]
  dummy$site <- "Solling_305"
  modis.df[[i]] <- rbind(modis.df[[i]], dummy)
  modis.df[[i]]$IDrecord <- NULL
  modis.df[[i]]$id <- NULL
  modis.df[[i]]$date <- paste(modis.df[[i]]$day,modis.df[[i]]$mo,modis.df[[i]]$year, sep="-" )
  
  modis.df[[i]]$date <- as.character(as.Date(modis.df[[i]]$date, format = "%d-%m-%Y"))
  modis.df[[i]]$site_id <- sapply(modis.df[[i]]$site, FUN =function(x){site_id[x]})
  modis.df[[i]] <- modis.df[[i]][!is.na(modis.df[[i]]$site_id),]
}

MODIS_MOD17A2_Data <- modis.df[[1]]
head(MODIS_MOD17A2_Data)
save(MODIS_MOD17A2_Data, file="./RData/MODIS_MOD17A2_Data.RData")
MODIS_MOD11A2_Data <- modis.df[[2]]
head(MODIS_MOD11A2_Data)
save(MODIS_MOD11A2_Data, file="./RData/MODIS_MOD11A2_Data.RData")
MODIS_MOD09A1_Data <- modis.df[[3]]
head(MODIS_MOD09A1_Data)
save(MODIS_MOD09A1_Data, file="./RData/MODIS_MOD09A1_Data.RData")
MODIS_MOD15A2_Data <- modis.df[[4]]
head(MODIS_MOD15A2_Data)
save(MODIS_MOD15A2_Data, file="./RData/MODIS_MOD15A2_Data.RData")
MODIS_MOD13Q1_Data <- modis.df[[5]]
head(MODIS_MOD13Q1_Data)
save(MODIS_MOD13Q1_Data, file="./RData/MODIS_MOD13Q1_Data.RData")

