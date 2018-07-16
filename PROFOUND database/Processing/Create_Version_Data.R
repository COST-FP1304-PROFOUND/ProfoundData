#------------------------------------------------------------------------------#
#                               CREATE VERSION
#------------------------------------------------------------------------------#

myDir <- "~/ownCloud/PROFOUND_Data/Processed/"
setwd(myDir)

Version_Data <- read.csv("./Version/version.csv", header = T)

save(Version_Data, file="./RData/Version_Data.RData")

