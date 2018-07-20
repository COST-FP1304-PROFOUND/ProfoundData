#------------------------------------------------------------------------------#
#                              SITE DESCRIPTION
#------------------------------------------------------------------------------#
# Stand Data is available for:
#       So far we just keep age
#       Provide age as same period than trees

# It must be derived for:
#       ...
# Target variables
directory <- "~/ownCloud/PROFOUND_Data/Processed/"
setwd(directory)


source("~/Github/COST-FP1304-PROFOUND/TG2/Processing/utilities.R")


variables <- c("site", "description", "reference")
#------------------------------------------------------------------------------#
df <- read.table("./sitesInformation/sites_ecoldescription.csv", header = T, sep =",")
head(df)

SiteDescription_Data <- df[, colnames(df) %in% variables]

#------------------------------------------------------------------------------#
# Add the IDs
# Get sites
# Add the IDs
# Get sites
load("./RData/Sites.RData")
# get the  locations

site.id <- Sites[, c("site2", "site_id")]
names(site.id) <- c("site", "site_id")

SiteDescription_Data <- merge(SiteDescription_Data, site.id, all.x= T )



save(SiteDescription_Data, file="./RData/SiteDescription_Data.RData")
#------------------------------------------------------------------------------#
# Add the IDs
# Get sites
# Add the IDs
# Get sites
load("./RData/Sites.RData")
# get the  locations

site.id <-  Sites$site_id
names(site.id) <- Sites$site2

SiteDescription_Data$site_id <- sapply(as.character(SiteDescription_Data$site), FUN =function(x){site.id[x]})

save(SiteDescription_Data, file="./RData/SiteDescription_Data.RData")

#------------------------------------------------------------------------------#


#------------------------------------------------------------------------------#
#                         Check Data
#------------------------------------------------------------------------------#
load("./RData/SiteDescription_Data.RData")

load("./RData/Sites.RData")
# get the  locations

site.id <-  Sites$site_id
names(site.id) <- Sites$site2


SiteDescription_Data$site_id <- sapply(as.character(SiteDescription_Data$site), FUN =function(x){site.id[x]})
SiteDescription_Data$site_id <- ifelse(is.na(SiteDescription_Data$site_id), 99, SiteDescription_Data$site_id)


str(SiteDescription_Data,1)

#sink("./RData/SiteDescription_Data.txt")
#str(SiteDescription_Data)
#sink()


