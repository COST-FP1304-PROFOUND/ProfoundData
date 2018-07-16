#------------------------------------------------------------------------------#
#                               CREATE POLICY
#------------------------------------------------------------------------------#

myDir <- "~/ownCloud/PROFOUND_Data/Processed/"
setwd(myDir)

METADATA_POLICY <- read.table("./policy/METADATA_POLICY.txt", header = T, sep = "\t",  fill = T,
                              comment.char = "", stringsAsFactors = F)
save(METADATA_POLICY, file="./RData/METADATA_POLICY.RData")


METADATA_POLICY_SITES <- read.table("./policy/METADATA_POLICY_SITES.txt", header = T, sep = "\t",  fill = F,
                                    comment.char = "", stringsAsFactors = F)
save(METADATA_POLICY_SITES, file="./RData/METADATA_POLICY_SITES.RData")




#------------------------------------------------------------------------------#
# Add the IDs
# Get sites
# Add the IDs
# Get sites
load("./RData/Sites.RData")
# get the  locations

site.id <-  Sites$site_id
names(site.id) <- Sites$name2

METADATA_POLICY$site_id <- sapply(as.character(METADATA_POLICY$site), FUN =function(x){site.id[x]})
METADATA_POLICY$site_id <- ifelse(is.na(METADATA_POLICY$site_id), 99, METADATA_POLICY$site_id)


METADATA_POLICY_SITES$site_id <- sapply(as.character(METADATA_POLICY_SITES$site), FUN =function(x){site.id[x]})
METADATA_POLICY_SITES$site_id <- ifelse(is.na(METADATA_POLICY_SITES$site_id), 99, METADATA_POLICY_SITES$site_id)

save(METADATA_POLICY, file="./RData/METADATA_POLICY.RData")
save(METADATA_POLICY_SITES, file="./RData/METADATA_POLICY_SITES.RData")

