# The aim of this test is to check whether it  is possible to download all data

# test ranges of climatic variables for climate data and isimip stuff
context("Test basic")


set.seed(1)

library(ProfoundData)
library(testthat)


# Please put here the path to the DB on your personal computer!!
setDB(db_name = "~/ownCloud/PROFOUND_Data/TESTVERSION/ProfoundData.sqlite")


climateRangeDaily <- function(tmp){
  # day
   expect_false(max(tmp$day, na.rm = F) > 31)
   expect_false(min(tmp$day, na.rm = F) < 1)
   # mo
   expect_false(max(tmp$mo, na.rm = F) > 12)
   expect_false(min(tmp$mo, na.rm = F) < 1)
   # mo
   expect_false(max(tmp$year, na.rm = F) > 3000)
   expect_false(min(tmp$year, na.rm = F) < 1900)
   # max temperature
   expect_false(max(tmp$tmax_degc, na.rm = F) > 80)
   expect_false(min(tmp$tmax_degc, na.rm = F) < -90)
   # mean temperature
   expect_false(max(tmp$tmean_degc, na.rm = F) > 80)
   expect_false(min(tmp$tmean_degc, na.rm = F) < -90)
   # min temperature
   expect_false(max(tmp$tmin_degc, na.rm = F) > 80)
   expect_false(min(tmp$tmin_degc, na.rm = F) < -90)
   # precipiation
   expect_false(max(tmp$p_mm, na.rm = F) > 2000)
   expect_false(min(tmp$p_mm, na.rm = F) < 0)
   # relative humidity
   expect_false(max(tmp$relhum_percent, na.rm = F) > 100)
   expect_false(min(tmp$relhum_percent, na.rm = F) < 0)
   # air pressure
   expect_false(max(tmp$airpress_hPa, na.rm = F) > 1200)
   expect_false(min(tmp$airpress_hPa, na.rm = F) < 500)

}


test_that("local climate", {
  suppressMessages(sites <- browseData(dataset = "CLIMATE_LOCAL"))
  for (location in sites$site){
    cat(location); cat(", ")
    suppressMessages(tmp <- getData("CLIMATE_LOCAL", location =location))
    #runtests
    climateRangeDaily(tmp)
  }
})

