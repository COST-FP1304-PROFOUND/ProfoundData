# The aim of this test is to check whether it  is possible to download all data

# test whether collapse works

context("Test basic")
set.seed(1)

library(ProfoundData)



testNoCollapse <- function(tmp){
  expect_true(class(tmp) == "list")
}
testCollapse <- function(tmp){
  expect_true(class(tmp) == "data.frame")
}

test_that("No collapse works", {

  skip_on_travis()
  skip_on_cran()
  # Please put here the path to the DB on your personal computer!!
  setDB(db_name = "~/ownCloud/PROFOUND_Data/v0.1.13/ProfoundData.sqlite")

  datasets <- c("CLIMATE_ISIMIP2A",  "CO2_ISIMIP", "CLIMATE_ISIMIP2B", "CLIMATE_ISIMIP2BLBC",
                "NDEPOSITION_ISIMIP2B","CLIMATE_ISIMIPFT")
  dataset <- sample(datasets, 1)
#    cat("\n");cat(datasets[i]); cat("\n");cat(rep("-", 30), collpase="") ;cat("\n")
  suppressMessages(sites <- browseData(dataset = dataset))
  location <- sample(sites$site, 1)
#    cat(location); cat(", ")
  suppressMessages(tmp <- getData(dataset, location =location, collapse = F))
      #runtests
  testNoCollapse(tmp)

})

test_that("Collapse works", {

  skip_on_travis()
  skip_on_cran()
  # Please put here the path to the DB on your personal computer!!
  setDB(db_name = "~/ownCloud/PROFOUND_Data/v0.1.13/ProfoundData.sqlite")

  datasets <- c("CLIMATE_ISIMIP2A",  "CO2_ISIMIP", #"CLIMATE_ISIMIP2B", #"CLIMATE_ISIMIP2BLBC"
                "NDEPOSITION_ISIMIP2B","CLIMATE_ISIMIPFT")
  dataset <- sample(datasets, 1)
   # cat("\n");cat(datasets[i]); cat("\n");cat(rep("-", 30), collpase="") ;cat("\n")
  suppressMessages(sites <- browseData(dataset = dataset))
  location <- sample(sites$site, 1)
#      cat(location); cat(", ")
  suppressMessages(tmp <- getData(dataset, location =location, collapse = T))
      #runtests
  testCollapse(tmp)
})












