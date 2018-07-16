#------------------------------------------------------------------------------#
#                             SITES
#------------------------------------------------------------------------------#
## Load  the processed other data
#otherData <- "~/GitHub/TG2/Processing/ProfoundOtherData.new.RData"
#load(otherData)
#Sites <- ProfoundOtherData.new$Sites
#head(Sites)
#
directory <- "~/Github/TG2/Processing"
setwd(directory)


loc  <- read.table("locations_ID.txt", header=T)
coords  <- read.table("LocationsCoordinates.txt", header=T, sep=",")

summary(loc)
summary(coords)
coords$site_id <- as.numeric(as.character(coords$site_id))
loc$site_id <- as.numeric(loc$ID)

Sites <- merge(loc, coords, all=TRUE)

Sites <- Sites[,names(Sites)!="ID"]
names(Sites) <- c("site_id", "name1", "name2", "lat", "lon")
Sites$epsg <- "4326"

write.table(Sites, file="sites.txt", sep=",", dec=".", row.names=FALSE)

### GEOREF? ####
require(maptools)
library(raster)
data(wrld_simpl)

plot(wrld_simpl)
points(lat~lon, Sites, col="red")

projection(wrld_simpl)

# Load  the processed other data
head(Sites)

# Drop locations we are not interested in
locations.aimed <- c("BilyKriz", "Brasschaat","Collelongo","Espirra",
                     "Hesse","Hyytiala", "Kroof", "LeBray","Peitz", "Puechabon",
                     "Solling_304","Soro", "Solling_305" )

Sites <- subset(Sites, name1 %in% locations.aimed)


Sites$name1 <- as.character(Sites$name1)
Sites$name2 <- as.character(Sites$name2)
Sites[is.na(Sites$name2),][["name2"]] <-"none"



# All sites have ISIMPI data / different from climate(observed)
Sites$country <- NA
Sites$aspect_deg <- NA
Sites$elevation_masl <- NA
Sites$slope_percent <- NA
#------------------------------------------------------------------------------#
#                             Add natural vegetation
#------------------------------------------------------------------------------#
directory <- "~/ownCloud/PROFOUND_Data/Processed"
setwd(directory)

filename <- "./sitesInformation/sites_corrected.csv"
df <- read.table(filename, sep= ",", header = TRUE)
names(df)
df <- df[,c("site_id", "natVegetation_code1", "natVegetation_code2",
           "natVegetation_description")]

rownames(df) <- NULL
Sites <- merge(Sites, df, by = intersect("site_id", "site_id"), all = TRUE)

str(Sites)

#------------------------------------------------------------------------------#
#                             Add bio1, bio12, and altitude
#------------------------------------------------------------------------------#
#filename <- "./sitesInformation/sites_with_alt_bio.csv"
#df <- read.table(filename, sep= ";", header = TRUE)
#names(df)
#df <- df[,c("site_id", "bio1", "bio12","altitude_srtm")]
#rownames(df) <- NULL
#Sites <- merge(Sites, df, by = intersect("site_id", "site_id"), all = TRUE)

#str(Sites)
#------------------------------------------------------------------------------#
#                             Add site specific informaiton
#------------------------------------------------------------------------------#
# "BilyKriz"
Sites[Sites$site_id==3,]$name2 <- Sites[Sites$site_id==3,]$name1
Sites[Sites$site_id==3,]$name1 <- "bily_kriz"
Sites[Sites$site_id==3,]$country <- "Czech Republic"
Sites[Sites$site_id==3,]$lat <- 49.3
Sites[Sites$site_id==3,]$lon <- 18.32
Sites[Sites$site_id==3,]$elevation_masl <- 875
Sites[Sites$site_id==3,]$slope_percent <- 12.5
Sites[Sites$site_id==3,]$aspect_deg <- 180 # excposition southern exposition 

# "Brasschaat"
Sites[Sites$site_id==4,]$name2 <- Sites[Sites$site_id==4,]$name1
Sites[Sites$site_id==4,]$name1 <- "brasschaat"
Sites[Sites$site_id==4,]$country <- "Belgium"
Sites[Sites$site_id==4,]$elevation_masl <- 16
Sites[Sites$site_id==4,]$slope_percent <- 0
Sites[Sites$site_id==4,]$aspect_deg <- 192

# "Collelongo"
Sites[Sites$site_id==5,]$name2 <- Sites[Sites$site_id==5,]$name1
Sites[Sites$site_id==5,]$name1 <- "collelongo"
Sites[Sites$site_id==5,]$country <- "Italy"
Sites[Sites$site_id==5,]$elevation_masl <- 1560
Sites[Sites$site_id==5,]$slope_percent <- 10
Sites[Sites$site_id==5,]$aspect_deg <- 252
Sites[Sites$site_id==5,]$lat <- 41.849336
Sites[Sites$site_id==5,]$lon <- 13.588217

# "Espirra"
Sites[Sites$site_id==6,]$name2 <- Sites[Sites$site_id==6,]$name1
Sites[Sites$site_id==6,]$name1 <- "espirra"
Sites[Sites$site_id==6,]$country <- "Portugal"


#"Hesse"
Sites[Sites$site_id==10,]$name2 <- Sites[Sites$site_id==10,]$name1
Sites[Sites$site_id==10,]$name1 <- "hesse"
Sites[Sites$site_id==10,]$country <- "France"
Sites[Sites$site_id==10,]$elevation_masl <- 300


# Hyytiala
Sites[Sites$site_id==12,]$name1 <- "hyytiala"
Sites[Sites$site_id==12,]$name2 <- "Hyytiala"
Sites[Sites$site_id==12,]$country <- "Finland"
Sites[Sites$site_id==12,]$elevation_masl <- 185
Sites[Sites$site_id==12,]$slope_percent <- 2
Sites[Sites$site_id==12,]$aspect_deg <- 180
Sites[Sites$site_id==12,]$lat <- 61.84742
Sites[Sites$site_id==12,]$lon <- 24.29477


# Kroof
Sites[Sites$site_id==13,]$name1 <- "kroof"
Sites[Sites$site_id==13,]$name2 <- "Kroof"
Sites[Sites$site_id==13,]$country <- "Germany"
Sites[Sites$site_id==13,]$elevation_masl <- 502
Sites[Sites$site_id==13,]$slope_percent <- 2.1
Sites[Sites$site_id==13,]$aspect_deg <- 1.8

# LeBray
Sites[Sites$site_id==14,]$name1 <- "le_bray"
Sites[Sites$site_id==14,]$name2 <- "LeBray"
Sites[Sites$site_id==14,]$country <- "France"
Sites[Sites$site_id==14,]$elevation_masl <- 61
Sites[Sites$site_id==14,]$slope_percent <- 0
Sites[Sites$site_id==14,]$aspect_deg <-NA

# Peitz
Sites[Sites$site_id==16,]$name2 <- Sites[Sites$site_id==16,]$name1
Sites[Sites$site_id==16,]$name1 <- "peitz"
Sites[Sites$site_id==16,]$country <- "Germany"
Sites[Sites$site_id==16,]$elevation_masl <- 50
Sites[Sites$site_id==16,]$slope_percent <- 0
Sites[Sites$site_id==16,]$aspect_deg <- NA

# Puechabon
Sites[Sites$site_id==18,]$name1 <- "puechabon"
Sites[Sites$site_id==18,]$name2 <- "Puechabon"
Sites[Sites$site_id==18,]$country <- "France"

# Solling 304
Sites[Sites$site_id==20,]$name2 <- Sites[Sites$site_id==20,]$name1
Sites[Sites$site_id==20,]$name1 <- "solling_beech"
Sites[Sites$site_id==20,]$country <- "Germany"
Sites[Sites$site_id==20,]$elevation_masl<- 504
Sites[Sites$site_id==20,]$lat <- 51.77
Sites[Sites$site_id==20,]$lon <- 9.57
Sites[Sites$site_id==20,]$aspect_deg <- 225
Sites[Sites$site_id==20,]$slope_percent <- 1.0

# Soro
Sites[Sites$site_id==21,]$name2 <- "Soro"
Sites[Sites$site_id==21,]$name1 <- "soro"
Sites[Sites$site_id==21,]$country <- "Denmark"
Sites[Sites$site_id==21,]$elevation_masl <- 40
Sites[Sites$site_id==21,]$aspect_deg <- NA
Sites[Sites$site_id==21,]$slope_percent <- 0



# Solling 305
Sites[Sites$site_id==25,]$name2 <- Sites[Sites$site_id==25,]$name1
Sites[Sites$site_id==25,]$name1 <- "solling_spruce"
Sites[Sites$site_id==25,]$country <- "Germany"
Sites[Sites$site_id==25,]$elevation_masl<- 508
Sites[Sites$site_id==25,]$slope_percent <- 1
Sites[Sites$site_id==25,]$aspect_deg <- 90
Sites[Sites$site_id==25,]$lat <- 51.7647
Sites[Sites$site_id==25,]$lon <- 9.5797

# site 99
Sites[Sites$site_id==99,]$name1 <- "global"
Sites[Sites$site_id==99,]$country <- "World"
Sites[Sites$site_id==99,]$elevation_masl<- 508
Sites[Sites$site_id==99,]$slope_percent <- NA
Sites[Sites$site_id==99,]$aspect_deg <- NA
Sites[Sites$site_id==99,]$lat <- 0
Sites[Sites$site_id==99,]$lon <- 0


save(Sites, file="./RData/Sites.RData")

# Remove sites that are not of interest:  Espirra, Hesse, Puechabon and Braschaat.
load("./RData/Sites.RData")
SitesAll <- Sites
save(SitesAll, file="./RData/SitesAll.RData")
sitesToRemove <- c(4, 6, 10, 18)
Sites <- Sites[!Sites$site_id %in% sitesToRemove,]
save(Sites, file="./RData/Sites.RData")




