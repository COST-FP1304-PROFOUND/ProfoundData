# The aim of this test is to check whether it  is possible to download all data

# test whether subsetting a period works with collapse

context("Test basic")
set.seed(1)

library(ProfoundData)
library(testthat)



testPeriod<- function(tmp, period){
   expect_true(max(tmp$date, na.rm = F) == max(period))
   expect_true(min(tmp$date, na.rm = F) == min(period))
}

testPeriodStart<- function(tmp, period){
  expect_true(min(tmp$date, na.rm = F) == min(period))
}
testPeriodEnd<- function(tmp, period){
  expect_true(max(tmp$date, na.rm = F) == max(period))
}
datasets <- c( "CLIMATE_ISIMIP2A","CLIMATE_ISIMIP2B", "CLIMATE_ISIMIP2BLBC",
              "CLIMATE_ISIMIPFT")
dataset <- sample(datasets, 1)


test_that(paste( dataset, " : subset a complete period"), {
    #runtests
    skip_on_travis()
    skip_on_cran()
    # Please put here the path to the DB on your personal computer!!
    setDB("/home/ramiro/ownCloud/PROFOUND_Data/v0.1.13/ProfoundData.sqlite")
    #  cat("\n");cat(datasets[i]); cat("\n");cat(rep("-", 30), collpase="") ;cat("\n")
    suppressMessages(sites <- browseData(dataset = dataset))
    site <- sample(sites$site, 1)
    #  cat(site); cat("... ")
    suppressMessages(tmp <- getData(dataset, site =site, collapse = T))
    period <- sample(tmp$date, size = 2)
    #cat("\n");cat("Period: "); cat(period); cat("\n")
    period <- as.Date(period, format = "%Y-%m-%d")
    #
    suppressMessages(tmp <- getData(dataset, site =site, collapse = T, period = period))
    testPeriod(tmp, period)
  })



dataset <- sample(datasets, 1)

test_that(paste( dataset, " : subset period only with start"), {
    #runtests
    skip_on_travis()
    skip_on_cran()
    # Please put here the path to the DB on your personal computer!!
    setDB("/home/ramiro/ownCloud/PROFOUND_Data/v0.1.13/ProfoundData.sqlite")
    #  cat("\n");cat(datasets[i]); cat("\n");cat(rep("-", 30), collpase="") ;cat("\n")
    suppressMessages(sites <- browseData(dataset = dataset))
    site <- sample(sites$site, 1)
    #  cat(site); cat("... ")
    suppressMessages(tmp <- getData(dataset, site =site, collapse = T))
    period <- sample(tmp$date, size = 1)
    #cat("\n");cat("Period: "); cat(period); cat("\n")
    period <- as.Date(period, format = "%Y-%m-%d")
    #
    suppressMessages(tmp <- getData(dataset, site =site, collapse = T, period = period))
    testPeriodStart(tmp, period)
  })



dataset <- sample(datasets, 1)

test_that(paste( dataset, " : subset period with NA and end"), {
    #runtests
    skip_on_travis()
    skip_on_cran()
    # Please put here the path to the DB on your personal computer!!
    setDB("/home/ramiro/ownCloud/PROFOUND_Data/v0.1.13/ProfoundData.sqlite")
    # #  cat("\n");cat(datasets[i]); cat("\n");cat(rep("-", 30), collpase="") ;cat("\n")
    suppressMessages(sites <- browseData(dataset = dataset))
    site <- sample(sites$site, 1)
    #  cat(site); cat("... ")
    suppressMessages(tmp <- getData(dataset, site =site, collapse = T))
    period <- sample(tmp$date, size = 1)
    #cat("\n");cat("Period: "); cat(period); cat("\n")
    #period <- as.Date(period, format = "%Y-%m-%d")
    period <- c(NA, period)
    #
    suppressMessages(tmp <- getData(dataset, site =site, collapse = T, period = period))
    testPeriodEnd(tmp, period[!is.na(period)])
  })


dataset <- sample(datasets, 1)

test_that(paste( dataset, " : subset period with start and NA"), {
    #runtests
    skip_on_travis()
    skip_on_cran()
    # Please put here the path to the DB on your personal computer!!
    setDB("/home/ramiro/ownCloud/PROFOUND_Data/v0.1.13/ProfoundData.sqlite")
    #  cat("\n");cat(datasets[i]); cat("\n");cat(rep("-", 30), collpase="") ;cat("\n")
    suppressMessages(sites <- browseData(dataset = dataset))
    site <- sample(sites$site, 1)
    #cat(site); cat("... ")
    suppressMessages(tmp <- getData(dataset, site =site, collapse = T))
    period <- sample(tmp$date, size = 1)
    #cat("\n");cat("Period: "); cat(period); cat("\n")
    #period <- as.Date(period, format = "%Y-%m-%d")
    period <- c(period, NA)
    #
    suppressMessages(tmp <- getData(dataset, site =site, collapse = T, period = period))
    testPeriodStart(tmp, period[!is.na(period)])
  })


