#------------------------------------------------------------------------------#
#                               CREATE SOURCE
#------------------------------------------------------------------------------#

myDir <- "~/ownCloud/PROFOUND_Data/Processed/"
setwd(myDir)

METADATA_SOURCE <- read.table("./source/SOURCE_DATASETS.txt", header = T, sep = "\t",  fill = F,
                     comment.char = "", stringsAsFactors = F)
save(METADATA_SOURCE, file="./RData/METADATA_SOURCE.RData")


METADATA_SOURCE_SITES <- read.table("./source/SOURCE_DATASETS_SITES.txt", header = T, sep = "\t",  fill = T,
                                comment.char = "", stringsAsFactors = F)
save(METADATA_SOURCE_SITES, file="./RData/METADATA_SOURCE_SITES.RData")




#------------------------------------------------------------------------------#
# Add the IDs
# Get sites
# Add the IDs
# Get sites
load("./RData/Sites.RData")
# get the  locations

site.id <-  Sites$site_id
names(site.id) <- Sites$name2

METADATA_SOURCE$site_id <- sapply(as.character(METADATA_SOURCE$site), FUN =function(x){site.id[x]})
METADATA_SOURCE$site_id <- ifelse(is.na(METADATA_SOURCE$site_id), 99, METADATA_SOURCE$site_id)


METADATA_SOURCE_SITES$site_id <- sapply(as.character(METADATA_SOURCE_SITES$site), FUN =function(x){site.id[x]})
METADATA_SOURCE_SITES$site_id <- ifelse(is.na(METADATA_SOURCE_SITES$site_id), 99, METADATA_SOURCE_SITES$site_id)

save(METADATA_SOURCE, file="./RData/METADATA_SOURCE.RData")
save(METADATA_SOURCE_SITES, file="./RData/METADATA_SOURCE_SITES.RData")

