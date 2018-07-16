load("ProfoundOtherData.RData")
str(ProfoundOtherData,1)

ProfoundOtherData.new <- list()

### Sites ####
ProfoundOtherData.new$Sites <- read.table(file="sites.txt", sep=",", dec=".", header=T)

#------------------------------------------------------------------------------#
#                             FINLAND: Hyytiala
#------------------------------------------------------------------------------#
str(ProfoundOtherData$Finland,2)
str(ProfoundOtherData$Finland$VegetationData)
ProfoundOtherData$Finland$VegetationData$Explanation_individual_treedata
Hyytiala.new <- list()
#------------------------------------------------------------------------------#
#                                 Stand Data
#------------------------------------------------------------------------------#

ProfoundOtherData$Finland$VegetationData$StandData
# year must be renamed
for (i in 1:3){
  names(ProfoundOtherData$Finland$VegetationData$StandData[[i]])[1] <- "year"
}


Hyytiala.new$VegetationData$StandData <- do.call(rbind, ProfoundOtherData$Finland$VegetationData$StandData)
Hyytiala.new$VegetationData$StandData$species <-  do.call(rbind, strsplit(rownames(Hyytiala.new$VegetationData$StandData), "[.]"))[,1]
rownames(Hyytiala.new$VegetationData$StandData) <- NULL
names(Hyytiala.new$VegetationData$StandData)

### P: One site or 3 monoculture sites?

### New column names: Without spaces; we should use either . or _ --> we use _
names(Hyytiala.new$VegetationData$StandData)
new.names <- gsub( "NA_", "",names(Hyytiala.new$VegetationData$StandData) )
new.names <- gsub( ",", "",new.names)
new.names <- gsub( "  ", "_", new.names)
new.names <- gsub( " ", "_",new.names)
new.names

# here is your old values
#new.names <- c("year", "mean.hight.basalarea.weighted.m", "mean.dbh.basalarea.weighted.cm", "CrownL1.m", "mean.hight.arithmetic.m", "mean.dbh.arithmetic.cm", "CrownL.m", "basal.area.m2", "tree.age","tree.density.NN", "species", "site.id")
### P: Unit for tree density? Number per ha or basal area per ha or...?
names(Hyytiala.new$VegetationData$StandData) <- new.names
Hyytiala.new$VegetationData$StandData$site_id <- 1
#------------------------------------------------------------------------------#
#                             Biomass data
#------------------------------------------------------------------------------#
ProfoundOtherData$Finland$VegetationData$Biomasses.kg.ha
Hyytiala.new$VegetationData$Biomasses.kg.ha <- do.call(rbind, ProfoundOtherData$Finland$VegetationData$Biomasses.kg.ha)
Hyytiala.new$VegetationData$Biomasses.kg.ha$species <-  do.call(rbind, strsplit(rownames(Hyytiala.new$VegetationData$Biomasses.kg.ha), "[.]"))[,1]
rownames(Hyytiala.new$VegetationData$Biomasses.kg.ha) <- NULL
Hyytiala.new$VegetationData$Biomasses.kg.ha
Hyytiala.new$VegetationData$Biomasses.kg.ha$site.id <- 1

head(Hyytiala.new$VegetationData$Biomasses.kg.ha)
new.names <- c("year", "stem_n", "foliage_biomass_kg_ha",
               "branches_biomass_kg_ha", "stump_coarse_roots_biomass_kg_ha",
               "species", "site_id")
names(Hyytiala.new$VegetationData$Biomasses.kg.ha) <- new.names

### Join "Biomass" and "StandData", as there is on eentry for year_species_site.id in each table ####
id1 <- paste(Hyytiala.new$VegetationData$StandData[,"year"], Hyytiala.new$VegetationData$StandData[,"species"],
             Hyytiala.new$VegetationData$StandData[,"site_id"], sep="_")

id2 <-paste(Hyytiala.new$VegetationData$Biomasses.kg.ha[,"year"], Hyytiala.new$VegetationData$Biomasses.kg.ha[,"species"],
            Hyytiala.new$VegetationData$Biomasses.kg.ha[,"site_id"], sep="_")

cbind(id1, id2)
identical(id1, id2)

Hyytiala.new$VegetationData$StandData <- cbind.data.frame(Hyytiala.new$VegetationData$StandData, Hyytiala.new$VegetationData$Biomasses.kg.ha[, !colnames(Hyytiala.new$VegetationData$Biomasses.kg.ha) %in% colnames(Hyytiala.new$VegetationData$StandData)])

str(Hyytiala.new$VegetationData)
Hyytiala.new$VegetationData <- Hyytiala.new$VegetationData[names(Hyytiala.new$VegetationData) != "Biomasses.kg.ha"]
str(Hyytiala.new$VegetationData)
#------------------------------------------------------------------------------#
#                                Foliage
#------------------------------------------------------------------------------#
# ### : This is very different now!!!!
# ProfoundOtherData$Finland$VegetationData$FoliageData
# names(ProfoundOtherData$Finland$VegetationData$FoliageData)
# names(ProfoundOtherData$Finland$VegetationData$FoliageData$Foliage_LAI_Data)
# head(ProfoundOtherData$Finland$VegetationData$FoliageData$Foliage_LAI_Data$data)
# ### C: This data is in the wide format, while biomass and stand data are
# # in the long format. I'll change Foliage to long format.
# #ProfoundOtherData$Finland$VegetationData$FoliageData$Biomasses.kg.ha
# #ProfoundOtherData$Finland$VegetationData$FoliageData$Foliage_LAI_Data
#
# ### C: Drop Sum of foliage biamass, since it can easily be caculated fron singly species values.
# ProfoundOtherData$Finland$VegetationData$FoliageData$Foliage_LAI_Data$data$SUM <- NULL
#
# names(ProfoundOtherData$Finland$VegetationData$FoliageData$Biomasses.kg.ha)
# names(ProfoundOtherData$Finland$VegetationData$FoliageData$Biomasses.kg.ha) <- tolower(names(ProfoundOtherData$Finland$VegetationData$FoliageData$Biomasses.kg.ha))
#
# ProfoundOtherData$Finland$VegetationData$FoliageData$Biomasses.kg.ha <- na.omit(ProfoundOtherData$Finland$VegetationData$FoliageData$Biomasses.kg.ha)
#
# ProfoundOtherData$Finland$VegetationData$FoliageData$Biomasses.kg.ha
#
# ### P: What about duplicated colums names but with different data?
# a <- grep("1", names(ProfoundOtherData$Finland$VegetationData$FoliageData$Biomasses.kg.ha), invert=T)
# snames <- names(ProfoundOtherData$Finland$VegetationData$FoliageData$Biomasses.kg.ha[,a])[2:4]
# foliage.long <- reshape(ProfoundOtherData$Finland$VegetationData$FoliageData$Biomasses.kg.ha[,a], direction="long", varying=snames, v.names="foliage.biomass.kg.ha", times=snames)
# names(foliage.long) <- replace(names(foliage.long), names(foliage.long)=="time", "species")
# rownames(foliage.long) <- NULL
# foliage.long <- foliage.long[,c("year", "species", "foliage.biomass.kg.ha")]
# foliage.long$site.id <- 1
#
# merge(Hyytiala.new$VegetationData$StandData, foliage.long, by=c("year", "species", "site.id"))[,c("foliage.biomass.kg.ha.x", "foliage.biomass.kg.ha.y")]
#
# ### -> Data in FoliageData in kg/ha are redundant. I drop them.
#
# ### Strange other values without measurement unit
# a <- grep("1", names(ProfoundOtherData$Finland$VegetationData$FoliageData$Biomasses.kg.ha), invert=F)
# a <- c(1, a)
# snames <- names(ProfoundOtherData$Finland$VegetationData$FoliageData$Biomasses.kg.ha[,a])[2:4]
#
# foliage.long <- reshape(ProfoundOtherData$Finland$VegetationData$FoliageData$Biomasses.kg.ha[,a], direction="long", varying=snames, v.names="foliage.NN", times=snames)
#
# foliage.long$time <- do.call(rbind, strsplit(foliage.long$time, "[.]"))[,1]
#
# names(foliage.long) <- replace(names(foliage.long), names(foliage.long)=="time", "species")
#
# rownames(foliage.long) <- NULL
# foliage.long <- foliage.long[,c("year", "species", "foliage.NN")]
# foliage.long$site.id <- NA
#
# Hyytiala.new$VegetationData$StandData <- merge(Hyytiala.new$VegetationData$StandData, foliage.long, by=c("year", "species", "site.id"))

#------------------------------------------------------------------------------#
#                           Individual Tree Data
#------------------------------------------------------------------------------#
### P: The first sentence tells that tere are individual tree measurements.
# This is not true!! Now it is

# TODO

### New structure for Hyytiala
str(Hyytiala.new)
Hyytiala.new <- Hyytiala.new$VegetationData
### OtherInformation
Hyytiala.new$Info <- ProfoundOtherData$Finland$VegetationData$Explanation_individual_treedata

str(Hyytiala.new)
### -> For Hyytiala there is only one single table with data on stand properties.

ProfoundOtherData.new$Hyytiala <- Hyytiala.new
#------------------------------------------------------------------------------#
#                           GERMANY
#------------------------------------------------------------------------------#
ProfoundOtherData.new$Sites
str(ProfoundOtherData$Germany,2)
### Add all "general" site infos such as area and maybe flagst for additional infos on soil, flux...
#------------------------------------------------------------------------------#
#                           GERMANY: Peitz
#------------------------------------------------------------------------------#
str(ProfoundOtherData$Germany$Peitz,1)
Peitz.new <- list()
Peitz.new$TreeData <- NULL

#------------------------------------------------------------------------------#
#                           Single Tree Data
#------------------------------------------------------------------------------#
### 1948 data ####
head(ProfoundOtherData$Germany$Peitz$"1948")

ProfoundOtherData$Germany$Peitz$Year.1948 <- ProfoundOtherData$Germany$Peitz$"1948"

head(ProfoundOtherData$Germany$Peitz$Year.1948)

Peitz.new$TreeData$Year.1948 <- ProfoundOtherData$Germany$Peitz$Year.1948[, !names(ProfoundOtherData$Germany$Peitz$Year.1948) %in% c( "area")]

Peitz.new$TreeData$Year.1948$site_id <- 16

Peitz.new$TreeData$All <- Peitz.new$TreeData$Year.1948
names(Peitz.new$TreeData$All)
summary(Peitz.new$TreeData$All)
Peitz.new$TreeData$All$height5 <- Peitz.new$TreeData$All$height5   ### Values are in dm. Change to m.
Peitz.new$TreeData$All$heightF5 <- Peitz.new$TreeData$All$heightF5   ### Values are in dm. Change to m.

names(Peitz.new$TreeData$All) <- c("sid", "tree_nr", "species", "age", "date",
                                   "tree_state", "dbh1_mm", "dbh2_mm", "height_cm",
                                   "heightF_cm", "site_id")


### 1952_1971 data ####
Peitz.new$TreeData$Year.1952_1971 <- ProfoundOtherData$Germany$Peitz$"1952_1971"
Peitz.new$TreeData$Year.1952_1971$site_id <- 16
head(Peitz.new$TreeData$Year.1948)
head(Peitz.new$TreeData$Year.1952_1971)
#In table Year1976_2001 there are 5!
Peitz.new$TreeData$Year.1948$date5
Peitz.new$TreeData$Year.1952_1971$date5
Peitz.new$TreeData$Year.1952_1971$date4
Peitz.new$TreeData$Year.1952_1971$date3
Peitz.new$TreeData$Year.1952_1971$date2
Peitz.new$TreeData$Year.1952_1971$date1
Peitz.new$TreeData$Year.1952_1971[,grep("dbh", colnames(Peitz.new$TreeData$Year.1976_2001))]
Peitz.new$TreeData$Year.1948[,grep("dbh", colnames(Peitz.new$TreeData$Year.1948))]

### Re-structure 1952_1971 inventories
# --> we are dropping area?
names(Peitz.new$TreeData$All)
names(Peitz.new$TreeData$Year.1952_1971)
names.root <- c("sid", "nr", "tree", "agex", "datex", "tstatex",
                "dbh1x", "dbh2x", "heightx","heightFx", "site_id")


hlpr <- Peitz.new$TreeData$All
# object a???
for(i in 1:5){
  names.subset <- gsub("x", i, names.root )
  invent <- Peitz.new$TreeData$Year.1952_1971[,names.subset]
  names(invent) <- names(Peitz.new$TreeData$All)
  hlpr <- rbind(hlpr, invent)
}
rm(invent)
summary(hlpr)
str(hlpr)
table(hlpr$date)
table(Peitz.new$TreeData$All$tree.nr)
table(!is.na(hlpr$tree.nr))

Peitz.new$TreeData$All <- hlpr
nrow(Peitz.new$TreeData$All)  ### 1572




### 1976_2001 data ####
Peitz.new$TreeData$Year.1976_2001 <- ProfoundOtherData$Germany$Peitz$"1976_2001"
Peitz.new$TreeData$Year.1976_2001$site_id <- 16
head(Peitz.new$TreeData$Year.1948)
head(Peitz.new$TreeData$Year.1976_2001)

names(Peitz.new$TreeData$Year.1948)   ### 5th inventory
names(Peitz.new$TreeData$Year.1976_2001)




### In table Year.1948 there is one inventory. In table Year1976_2001 there are 5!
Peitz.new$TreeData$Year.1948$date5
Peitz.new$TreeData$Year.1976_2001$date5
Peitz.new$TreeData$Year.1976_2001$date4
Peitz.new$TreeData$Year.1976_2001$date3
Peitz.new$TreeData$Year.1976_2001$date2
Peitz.new$TreeData$Year.1976_2001$date1
Peitz.new$TreeData$Year.1976_2001[,grep("dbh", colnames(Peitz.new$TreeData$Year.1976_2001))]
Peitz.new$TreeData$Year.1948[,grep("dbh", colnames(Peitz.new$TreeData$Year.1948))]

### Re-structure 1976_2001 inventories
# --> we are dropping area?
names(Peitz.new$TreeData$All)
names(Peitz.new$TreeData$Year.1976_2001)
names.root <- c("sid", "nr", "tree", "agex", "datex", "tstatex",
                "dbh1x", "dbh2x", "heightx","heightFx", "site_id")


hlpr <- Peitz.new$TreeData$All
# object a???
for(i in 1:5){
  names.subset <- gsub("x", i, names.root )
  invent <- Peitz.new$TreeData$Year.1976_2001[,names.subset]
  names(invent) <- names(Peitz.new$TreeData$All)
  hlpr <- rbind(hlpr, invent)
}
rm(invent)
summary(hlpr)
str(hlpr)
table(hlpr$date)
table(Peitz.new$TreeData$All$tree.nr)
table(!is.na(hlpr$tree.nr))

Peitz.new$TreeData$All <- hlpr
nrow(Peitz.new$TreeData$All)  ### 1572

### Data 2007_2011
str(ProfoundOtherData$Germany$Peitz, 1)
Peitz.new$TreeData$Year.2007_2011 <- ProfoundOtherData$Germany$Peitz$"2007_2011"
Peitz.new$TreeData$Year.2007_2011$site_id <- 2
head(Peitz.new$TreeData$All)
head(Peitz.new$TreeData$Year.2007_2011)

Peitz.new$TreeData$Year.2007_2011[,grep("dbh", colnames(Peitz.new$TreeData$Year.2007_2011))]
hlpr <- Peitz.new$TreeData$All
names.root <- c("sid", "nr", "tree", "agex", "datex", "tstatex",
                "dbh1x", "dbh2x", "heightx","heightFx", "site_id")

                                             
for(i in 1:2){
  names.subset <- gsub("x", i, names.root )
  invent <- Peitz.new$TreeData$Year.2007_2011[,names.subset]
  names(invent) <- names(Peitz.new$TreeData$All)
  hlpr <- rbind(hlpr, invent)
}
summary(hlpr)
table(hlpr$date)
Peitz.new$TreeData$All <- hlpr
nrow(Peitz.new$TreeData$All)  ### 1726
str(ProfoundOtherData$Germany$Peitz,1)
Peitz.new$TreeData <- Peitz.new$TreeData$All

#------------------------------------------------------------------------------#
#                           Weather
#------------------------------------------------------------------------------#
ProfoundOtherData$Germany$Peitz$Observed_weather
str(ProfoundOtherData$Germany$Peitz,1)
Peitz.new$ClimateData <- ProfoundOtherData$Germany$Peitz$Observed_weather
names(Peitz.new$ClimateData)
names(Peitz.new$ClimateData) <- c("CID", "day", "month", "year",
                                  "tmax_gradC", "tmean_gradC", "tmin_gradC",
                                  "p_mm", "relhum_percent", "air_press_hPa",
                                  "rad_Jcm2day", "wind_ms")


str(ProfoundOtherData.new,1)
ProfoundOtherData.new$Peitz <- Peitz.new

#------------------------------------------------------------------------------#
#                           Modifications on tree data
#------------------------------------------------------------------------------#
### Change date to year ####
#ProfoundOtherData.new$Peitz$TreeData$date
levels(ProfoundOtherData.new$Peitz$TreeData$date)
ProfoundOtherData.new$Peitz$TreeData$date <- as.Date(ProfoundOtherData.new$Peitz$TreeData$date, format="%m/%d/%Y")
ProfoundOtherData.new$Peitz$TreeData$year <- format(ProfoundOtherData.new$Peitz$TreeData$date, format="%Y" )
table(ProfoundOtherData.new$Peitz$TreeData$year)
sum(is.na(ProfoundOtherData.new$Peitz$TreeData$year)) == 0


### Tree state ####
# V = remaining tree
# D, T, A , T69 = removed/harvested trees, possibly different causes of death but we can pool this into "dead/removed"
# ==>What I am unclear about is that in your rData file it says the variable has 6 levels while I count only 5 levels (V, D, T, A. T69)
library(plyr)
ProfoundOtherData.new$Peitz$TreeData$tree_state
levels(ProfoundOtherData.new$Peitz$TreeData$tree_state)
table(ProfoundOtherData.new$Peitz$TreeData$tree_state)
ProfoundOtherData.new$Peitz$TreeData$tree_state <- gsub("   ,", "", ProfoundOtherData.new$Peitz$TreeData$tree_state )
ProfoundOtherData.new$Peitz$TreeData$tree_state <- gsub("T69 ,","T69",ProfoundOtherData.new$Peitz$TreeData$tree_state )
ProfoundOtherData.new$Peitz$TreeData$tree_state <- gsub(",","",ProfoundOtherData.new$Peitz$TreeData$tree_state )
unique(ProfoundOtherData.new$Peitz$TreeData$tree_state)
table(ProfoundOtherData.new$Peitz$TreeData$tree_state)

#hlpr <- revalue(ProfoundOtherData.new$Peitz$TreeData$tree_state,
#                c("D"="dead", "V"="alive", "A"="removed_A", "S"="removed_S",
#                  "T"="removed_T"))
#levels(hlpr)
#hlpr[as.numeric(hlpr) == 6] <- NA
#hlpr <- as.factor(as.character(hlpr))
#ProfoundOtherData.new$Peitz$TreeData$tree.state <- hlpr
#levels(ProfoundOtherData.new$Peitz$TreeData$tree.state)

#ProfoundOtherData.new$Peitz$TreeData$tree_state
str(ProfoundOtherData.new,1)

#------------------------------------------------------------------------------#
#                           Stand data
#------------------------------------------------------------------------------#
str(ProfoundOtherData$Germany$Peitz,1)
str(ProfoundOtherData.new$Hyytiala,1)
names(ProfoundOtherData$Germany$Peitz)

str(ProfoundOtherData$Germany$Peitz$standData[[1]],1)
str(ProfoundOtherData$Germany$Peitz$standData[[2]],1)
str(ProfoundOtherData$Germany$Peitz$standData[[3]],1)

str(ProfoundOtherData$Germany$Peitz$standData[[1]],2)
str(ProfoundOtherData$Germany$Peitz$standData[[2]],2)

for (i in 1:length(ProfoundOtherData$Germany$Peitz$standData[[1]])){
  cat(names(ProfoundOtherData$Germany$Peitz$standData[[1]][[i]]))
  cat("\n")
  for(j in 1:15){
    cat( paste(ProfoundOtherData$Germany$Peitz$standData[[1]][[i]]$Table[j,],
               collapse = " "))
    cat("\n")
  }
  cat("----------------------------------------------------------------\n")
}

head(ProfoundOtherData$Germany$Peitz$standData[[1]][[2]]$Table)
names(ProfoundOtherData$Germany$Peitz$standData[[1]][[2]]$Table)

# What is below does no  longer work with the new data
#cnames <- (ProfoundOtherData$Germany$Peitz$standData[[1]]$Table[1,])
#dat <- ProfoundOtherData$Germany$Peitz$standData[[1]]$Table[18:nrow(ProfoundOtherData$Germany$Peitz$standData[[1]]$Table),]
#summary(dat)
#names(cnames) <- NULL
+dim(cnames)
### P: Not structured at all.
# I guess this is data on management.
# Seems to be easier to do that in Excel.
## Yes Easier in EXcel!!!!!!!!!!!!!

str(ProfoundOtherData.new$Peitz,1)
#------------------------------------------------------------------------------#
#                           GERMANY: Solling
#------------------------------------------------------------------------------#
Solling.new <- list()

str(ProfoundOtherData$Germany$Solling,1)
str(ProfoundOtherData.new,2)
Solling.new$Info <- ProfoundOtherData$Germany$Solling$Info

### Plot_304_gesamt
str(ProfoundOtherData$Germany$Solling$Plot_304_gesamt,1)
str(ProfoundOtherData$Germany$Solling$Plot_304_gesamt$plot_304_all,1)

Solling.new$TreeData <- ProfoundOtherData$Germany$Solling$Plot_304_gesamt$plot_304_all

names(ProfoundOtherData.new$Peitz$TreeData)
summary(Solling.new$TreeData)

head(Solling.new$TreeData)
names(Solling.new$TreeData)

Solling.new$TreeData <- Solling.new$TreeData[,c("JAHR", "TREE", "SEQ", "DBH1", "DBH2", "HGHT", "TREVOL", "CRLG", "CRWD", "OBS")]

# Do we need this?
#Solling.new$TreeData$HGHT <- Solling.new$TreeData$HGHT/10  ### Convert tree height from dm to m

### P: Uncler to me what some of the variables are.
### I assume CRWD to be crown.width
names(Solling.new$TreeData) <- c("year", "tree_id", "SEQ", "dbh1_cm", "dbh2_cm",
                                 "height_m", "tree_volume_NN", "CRLG",
                                 "crown_width_m", "OBS")

table(Solling.new$TreeData$year)

Solling.new$TreeData$site_id <- 20

#------------------------------------------------------------------------------#
#                           Add Solling304_2004 and 2009
#------------------------------------------------------------------------------#
Solling2004 <- ProfoundOtherData$Germany$Solling$Plot_304_gesamt$plot304_2004
head(Solling2004)
summary(Solling2004)

names(Solling2004)
names(ProfoundOtherData$Germany$Solling$Plot_304_gesamt$plot304_2009)

Solling2004 <- rbind(Solling2004, ProfoundOtherData$Germany$Solling$Plot_304_gesamt$plot304_2009)

Solling2004$diameter_caliper
Solling2004$diameter <- as.numeric(Solling2004$diameter)

names(Solling.new$TreeData)
names(Solling2004)

Solling2004$height <- as.numeric(Solling2004$height)#/10
Solling2004$crown_base_height <- as.numeric(Solling2004$crown_base_height)#/10
Solling2004$crown_width <- as.numeric(Solling2004$crown_width)

names(Solling2004) <- c("site_id", "year", "tree_id", "species", "dbh1_cm",
                        "diameter_caliper", "bark_NN", "height_m", "tree_volume_NN",
                        "crown_width_m", "crown_base_height_m")

Solling2004$site_id <- 20
table(Solling2004$species)

str(Solling2004)


names(Solling.new$TreeData)
names(Solling2004)


hlpr<- merge(Solling.new$TreeData, Solling2004,
             by =c("year", "site_id", "tree_id"),
             all=TRUE, suffixes = c("_x","_y"))
summary(hlpr)
names(hlpr)
hlpr <- hlpr[,grep("_y", names(hlpr), invert=T)]
names(hlpr)[names(hlpr) %in% c("dbh1_cm_x", "height_m_x", "tree_volume_NN_x","crown_width_m_x")] <- c("dbh1_cm", "height_m", "tree_volume_NN", "crown_width_m")


Solling.new$TreeData <- hlpr

ProfoundOtherData.new$Solling304 <- Solling.new
str(ProfoundOtherData.new$Solling304$TreeData, 1)
table(ProfoundOtherData.new$Solling304$TreeData$species)

# Code species names
ProfoundOtherData.new$Solling304$TreeData$species <- ifelse(20, "fasy", "piab")

#------------------------------------------------------------------------------#
#                           Aditional Solling 304 data
#------------------------------------------------------------------------------#
### Add climate data to Solling 304 ; Beech site? ####
names(ProfoundOtherData$Germany$Solling$SollingB1_304)

### SollingB1_304_climate_measured
summary(ProfoundOtherData$Germany$Solling$SollingB1_304$SollingB1_304_climate_measured)
Solling304 <- ProfoundOtherData$Germany$Solling$SollingB1_304
ClimateData <- Solling304$SollingB1_304_climate_measure[-1,]
ClimateData$open.field <- as.Date(as.character(ClimateData$open.field), format="%m/%d/%Y")

ClimateData$day <- format(ClimateData$open.field, format="%d")
ClimateData$month <- format(ClimateData$open.field, format="%m")
ClimateData$year <- format(ClimateData$open.field, format="%Y")
ClimateData <- ClimateData[, names(ClimateData)!="open.field"]

names(ClimateData) <- c("tmin_gradC", "tmax_gradC", "tmean_gradC", "p_mm",
                        "relhum_percent", "rad_Jcm2day", "wind_ms", "day",
                        "month", "year")

ProfoundOtherData.new$Solling304$ClimateData <- ClimateData

### SollingB1_304_comments
ProfoundOtherData$Germany$Solling$SollingB1_304$SollingB1_304_comments

ProfoundOtherData.new$Solling304$Info <- c(ProfoundOtherData.new$Solling304$Info, ProfoundOtherData$Germany$Solling$SollingB1_304$SollingB1_304_comments)

### SollingB1_304_Ndeposition

ProfoundOtherData$Germany$Solling$SollingB1_304$SollingB1_304_Ndeposition


### SollingB1_304_parameters_site
# ProfoundOtherData$Germany$Solling$SollingB1_304$SollingB1_304_parameters_site
# ProfoundOtherData.new$Solling304$Info <- c(ProfoundOtherData.new$Solling304$Info, ProfoundOtherData$Germany$Solling$SollingB1_304$ProfoundOtherData$Germany$Solling$SollingB1_304$SollingB1_304_parameters_site)
#

### Sollinng 304 soil
ProfoundOtherData$Germany$Solling$SollingB1_304$SollingB1_304_parameters_soil

ProfoundOtherData$Germany$Solling$SollingB1_304$SollingB1_304_parameters_stand

### SollingB1_304_plot_304_all
head(ProfoundOtherData$Germany$Solling$SollingB1_304$SollingB1_304_plot_304_all)
head(ProfoundOtherData$Germany$Solling$Plot_304_gesamt$plot_304_all)

apply(cbind(ProfoundOtherData$Germany$Solling$SollingB1_304$SollingB1_304_plot_304_all$DBH1,ProfoundOtherData$Germany$Solling$Plot_304_gesamt$plot_304_all$DBH1), 1, diff)
# -> Same data
names(ProfoundOtherData$Germany$Solling$SollingB1_304)

### SAVE ####
save(ProfoundOtherData.new, file="ProfoundOtherData.new.RData")

### Check data
load("ProfoundOtherData.new.RData")

str(ProfoundOtherData.new,1)

sink("ProfoundOtherData.new.txt")
str(ProfoundOtherData.new)
sink()


