# The aim of this test is to check whether it  is possible to download all data

# test whether there are dpuplicates in the data

context("Test basic")
set.seed(1)

library(ProfoundData)
library(testthat)

# Please put here the path to the DB on your personal computer!!
setDB("/home/ramiro/ownCloud/PROFOUND_Data/v0.1.13/ProfoundData.sqlite")


testDuplicate<- function(tmp){
   expect_true(nrow(tmp[duplicated(tmp$record_id),]) == 0)
}

datasetsSingle <- c("CLIMATE_ISIMIP2A","CLIMATE_ISIMIP2B", "CLIMATE_ISIMIP2BLBC",
              "CLIMATE_ISIMIPFT", "ATMOSPHERICHEATCONDUCTION", "FLUX", "SOILTS", "METEOROLOGICAL",
              "MODIS_MOD09A1", "MODIS_MOD11A2", "MODIS_MOD13Q1","MODIS_MOD15A2", "MODIS_MOD17A2",
              "CO2_ISIMIP", "NDEPOSITION_EMEP", "NDEPOSITION_ISIMIP2B")

datasetsAll <- c("TREE", "STAND", "SOIL", "CLIMATE_LOCAL")

for (i in 1:length(datasetsSingle)){
#  cat("\n");cat(datasets[i]); cat("\n");cat(rep("-", 30), collpase="") ;cat("\n")
  suppressMessages(sites <- browseData(dataset = datasetsSingle[i]))
  location <- sample(sites$site, 1)
#  cat(location); cat("... ")
  test_that(paste( datasetsSingle[i], " - ", location, ": test for duplicates"), {
    #runtests
    skip_on_travis()
    skip_on_cran()
    suppressMessages(tmp <- getData(datasetsSingle[i], location =location, collapse = T))
    testDuplicate(tmp)
  })
}

for (i in 1:length(datasetsAll)){
#  cat("\n");cat(datasets[i]); cat("\n");cat(rep("-", 30), collpase="") ;cat("\n")
  suppressMessages(sites <- browseData(dataset = datasetsAll[i]))
  location <- sample(sites$site, 1)
#    cat(location[j]); cat("... ")
    test_that(paste( datasetsAll[i], " - ", location, ": test for duplicates"), {
      #runtests
      skip_on_travis()
      skip_on_cran()
      suppressMessages(tmp <- getData(datasetsAll[i], location =location, collapse = T))
      testDuplicate(tmp)
    })

}
