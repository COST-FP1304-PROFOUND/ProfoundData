#------------------------------------------------------------------------------#
# A script to create the Ndep data: from David Cameron (ISIMIP/Basfor)
#------------------------------------------------------------------------------#

directory <- "~/ownCloud/PROFOUND_Data/Processed/"
setwd(directory)


profoundSites <- read.table(file="./NDEP/profound-sites-index.csv",header=TRUE,sep=',')
EMEPIndex     <- read.table(file="./NDEP/EMEP__david.csv",header=TRUE,sep=',')
NDEPOxi       <- read.table(file="./NDEP/EMEPEU27NDepOxi.txt",header=TRUE,sep=';')
NDEPRed       <- read.table(file="./NDEP/EMEPEU27NDepRed.txt",header=TRUE,sep=';')

yrs <- c(1980,1985,1990,1995:2014)
yrindex <- c(1,2,4,6,9,12,15,18,21,24,27,30,33,36,39,40,41,42,43,44,45,47,48)

NDepEMEP_Data <- vector("list", length(profoundSites$name1))

names(NDepEMEP_Data) <-  profoundSites$name1
# Unit mgN/m2
for (i in 1:length(NDepEMEP_Data)){
    ii               <- EMEPIndex$i[which(EMEPIndex$cell.index==profoundSites$cell.index[i])]
    jj               <- EMEPIndex$j[which(EMEPIndex$cell.index==profoundSites$cell.index[i])]
    extractedNDEPOxi <- NDEPOxi[which(NDEPOxi$i==ii & NDEPOxi$j==jj),]
    extractedNDEPRed <- NDEPRed[which(NDEPRed$i==ii & NDEPRed$j==jj),]
    Oxi              <- extractedNDEPOxi[yrindex,]
    Red              <- extractedNDEPRed[yrindex,]
    NDepEMEP_Data[[i]]   <- data.frame(list(years=yrs,NDEPOxi=rev(Oxi$VALUE),NDEPRed=rev(Red$VALUE),Units=Red$UNIT))
}

NDepEMEP_Data$Solling_305 <- NDepEMEP_Data$Solling_304

save(NDepEMEP_Data, file = "./RData/NDepEMEP_Data.RData")



# Add the IDs
# Get sites
load("./RData/NDepEMEP_Data.RData")
load("./RData/Sites.RData")
# get the  locations
Site <- Sites$site2
Site.id <-  Sites$site_id
names(Site.id) <- Site

columns <- c("site", "site_id",  "year", "NdepOxi_mgm2","NdepRed_mgm2")


for (i in 1:length(NDepEMEP_Data)){
  file.site <-names(NDepEMEP_Data)[i]
  if (file.site %in% names(Site.id)){
    NDepEMEP_Data[[i]]$site_id <- Site.id[[file.site]]
    NDepEMEP_Data[[i]]$site <- file.site
  }else{
    names(NDepEMEP_Data)[i] <- NA
  }
  newnames <- names(NDepEMEP_Data[[i]])
  newnames <- gsub("years", "year",newnames )
  newnames <- gsub("NDEPOxi", "NdepOxi_mgm2",newnames )
  newnames <- gsub("NDEPRed", "NdepRed_mgm2",newnames )
  names(NDepEMEP_Data[[i]]) <- newnames
  
  for (j in 1:length(columns)){
    if (columns[j] %in% names(NDepEMEP_Data[[i]]) == FALSE){
      NDepEMEP_Data[[i]][[columns[j]]] <- NA
    }
  }
}
# Delete not needed sites
NDepEMEP_Data <- NDepEMEP_Data[!is.na(names(NDepEMEP_Data))]


save(NDepEMEP_Data, file="./RData/NDepEMEP_Data.RData")

#------------------------------------------------------------------------------#
# Conversion to g/m2
load("./RData/NDepEMEP_Data.RData")

for (i in 1:length(NDepEMEP_Data)){
  file.site <-names(NDepEMEP_Data)[i]
  NDepEMEP_Data[[i]]$noy_gm2 <- NDepEMEP_Data[[i]]$NdepOxi_mgm2 / 1000
  NDepEMEP_Data[[i]]$nhx_gm2 <- NDepEMEP_Data[[i]]$NdepRed_mgm2 / 1000
  NDepEMEP_Data[[i]]$NdepRed_mgm2 <- NULL
  NDepEMEP_Data[[i]]$NdepOxi_mgm2 <- NULL

}


save(NDepEMEP_Data, file="./RData/NDepEMEP_Data.RData")



#------------------------------------------------------------------------------#
