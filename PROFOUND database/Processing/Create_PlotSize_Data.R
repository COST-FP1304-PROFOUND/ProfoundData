# Create the data for the PLOTSIZE table
# collect inventories form Stand and Tree, put them together,
# fill the plot size from the tree and the stand data (only if reported)


directory <- "~/ownCloud/PROFOUND_Data/Processed/"
setwd(directory)



# Load  the processed other data
load("./RData/Tree_Data.RData")
load("./RData/Stand_Data.RData")


i = 1
require(plyr)
tree_size <- lapply(1:length(Tree_Data), function(x){
  tmp <- plyr::ddply(Tree_Data[[x]], .(year), summarise, size_m2 = mean(size_m2, na.rm = T), site_id = mean(site_id, na.rm = T)
                     )} )
tree_size <- Reduce(f = function(...)rbind(...), x = tree_size)

stand_size <- lapply(1:length(Stand_Data), function(x) Stand_Data[[x]][, c("year", "site_id")] )
stand_size <- Reduce(f = function(...)rbind(...), x = stand_size)


PlotSize_Data <- merge(tree_size, stand_size, all = T)
# Attach le bray (site_id 14 ) plot size 4,756 ha
PlotSize_Data[ PlotSize_Data$site_id ==14, ]$size_m2 <- 4756*10000
PlotSize_Data <- PlotSize_Data[order(PlotSize_Data$site_id),]

PlotSize_Data[PlotSize_Data$site_id == 21,]$size_m2 <- ifelse(is.na(PlotSize_Data[PlotSize_Data$site_id == 21,]$size_m2),
                                                              10000, PlotSize_Data[PlotSize_Data$site_id == 21,]$size_m2)

PlotSize_Data[PlotSize_Data$site_id == 16,]$size_m2 <- ifelse(is.na(PlotSize_Data[PlotSize_Data$site_id == 16,]$size_m2),
                                                              1000, PlotSize_Data[PlotSize_Data$site_id == 16,]$size_m2)

PlotSize_Data[PlotSize_Data$site_id == 12,]$size_m2 <- ifelse(is.na(PlotSize_Data[PlotSize_Data$site_id == 12,]$size_m2),
                                                              7600, PlotSize_Data[PlotSize_Data$site_id == 12,]$size_m2)
save(PlotSize_Data, file="./RData/PlotSize_Data.RData")



