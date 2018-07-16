# The aim of this test is to check whether it  is possible to download all data

# test whether subsetting a period works without collapse

context("Test basic")
set.seed(1)

library(ProfoundData)
library(testthat)

# Please put here the path to the DB on your personal computer!!
setDB("/home/ramiro/ownCloud/PROFOUND_Data/v0.1.12/ProfoundData.sqlite")


testPeriod<- function(tmp, period){
  if(class(tmp)=="data.frame"){
    expect_true(max(tmp$date, na.rm = F) == max(period))
    expect_true(min(tmp$date, na.rm = F) == min(period))
  }else  if (class(tmp)=="list"){
    if(class(tmp[[1]])== "data.frame"){
      for (i in 1:length(tmp)){
        expect_true(max(tmp[[i]]$date, na.rm = F) == max(period))
        expect_true(min(tmp[[i]]$date, na.rm = F) == min(period))
      }
    }else  if(class(tmp[[1]])=="list"){
      if(class(tmp[[1]][[1]])== "data.frame"){
        for (i in 1:length(tmp)){
          for (j in 1:length(tmp[[i]])){
            expect_true(max(tmp[[i]][[j]]$date, na.rm = F) == max(period))
            expect_true(min(tmp[[i]][[j]]$date, na.rm = F) == min(period))
          }
        }
      }else{
        cat("Something real bad is going on")
      }
    }
  }
}

testPeriodStart<- function(tmp, period){
  if(class(tmp)=="data.frame"){
    expect_true(min(tmp$date, na.rm = F) == min(period))
  }else  if (class(tmp)=="list"){
    if(class(tmp[[1]])== "data.frame"){
      for (i in 1:length(tmp)){
        expect_true(min(tmp[[i]]$date, na.rm = F) == min(period))
      }
    }else  if(class(tmp[[1]])=="list"){
      if(class(tmp[[1]][[1]])== "data.frame"){
        for (i in 1:length(tmp)){
          for (j in 1:length(tmp[[i]])){
            expect_true(min(tmp[[i]][[j]]$date, na.rm = F) == min(period))
          }
        }
      }else{
        cat("Something real bad is going on")
      }
    }
  }
}
testPeriodEnd<- function(tmp, period){
  if(class(tmp)=="data.frame"){
    expect_true(max(tmp$date, na.rm = F) == max(period))
  }else  if (class(tmp)=="list"){
    if(class(tmp[[1]])== "data.frame"){
      for (i in 1:length(tmp)){
        expect_true(max(tmp[[i]]$date, na.rm = F) == max(period))
      }
    }else  if(class(tmp[[1]])=="list"){
      if(class(tmp[[1]][[1]])== "data.frame"){
        for (i in 1:length(tmp)){
          for (j in 1:length(tmp[[i]])){
            expect_true(max(tmp[[i]][[j]]$date, na.rm = F) == max(period))
          }
        }
      }else{
        cat("Something real bad is going on")
      }
    }
  }
}

datasets <- c("CLIMATE_ISIMIP2A",  "CLIMATE_ISIMIP2B", "CLIMATE_ISIMIP2BLBC",
              "CLIMATE_ISIMIPFT")

for (i in 1:length(datasets)){
#  cat("\n");cat(datasets[i]); cat("\n");cat(rep("-", 30), collpase="") ;cat("\n")
  suppressMessages(sites <- browseData(dataset = datasets[i]))
  location <- sample(sites$site, 1)
#  cat(location); cat("... ")
  suppressMessages(tmp <- getData(datasets[i], location =location, collapse = T))
  period <- sample(tmp$date, size = 2)
#  cat("\n");cat("Period: "); cat(period); cat("\n")
 # period <- as.Date(period, format = "%Y-%m-%d")
  test_that(paste( datasets[i], " - ", location, ": subset a complete period"), {
    #runtests
    suppressMessages(tmp <- getData(datasets[i], location =location, collapse = F, period = period))
    testPeriod(tmp, period)
  })

}

for (i in 1:length(datasets)){
#  cat("\n");cat(datasets[i]); cat("\n");cat(rep("-", 30), collpase="") ;cat("\n")
  suppressMessages(sites <- browseData(dataset = datasets[i]))
  location <- sample(sites$site, 1)
#  cat(location); cat("... ")
  suppressMessages(tmp <- getData(datasets[i], location =location, collapse = T))
  period <- sample(tmp$date, size = 1)
#  cat("\n");cat("Period: "); cat(period); cat("\n")
#  period <- as.Date(period, format = "%Y-%m-%d")
  test_that(paste( datasets[i], " - ", location, ": subset period only with start"), {
    #runtests
    suppressMessages(tmp <- getData(datasets[i], location =location, collapse = F, period = period))
    testPeriodStart(tmp, period)
  })
}

for (i in 1:length(datasets)){
#  cat("\n");cat(datasets[i]); cat("\n");cat(rep("-", 30), collpase="") ;cat("\n")
  suppressMessages(sites <- browseData(dataset = datasets[i]))
  location <- sample(sites$site, 1)
#  cat(location); cat("... ")
  suppressMessages(tmp <- getData(datasets[i], location =location, collapse = T))
  period <- sample(tmp$date, size = 1)
#  cat("\n");cat("Period: "); cat(period); cat("\n")
  #period <- as.Date(period, format = "%Y-%m-%d")
  period <- c(NA, period)
  test_that(paste( datasets[i], " - ", location, ": subset period with NA and end"), {
    #runtests
    suppressMessages(tmp <- getData(datasets[i], location =location, collapse = F, period = period))
    testPeriodEnd(tmp, period[!is.na(period)])
  })
}

for (i in 1:length(datasets)){
#  cat("\n");cat(datasets[i]); cat("\n");cat(rep("-", 30), collpase="") ;cat("\n")
  suppressMessages(sites <- browseData(dataset = datasets[i]))
  location <- sample(sites$site, 1)
#  cat(location); cat("... ")
  suppressMessages(tmp <- getData(datasets[i], location =location, collapse = T))
  period <- sample(tmp$date, size = 1)
 # cat("\n");cat("Period: "); cat(period); cat("\n")
  #period <- as.Date(period, format = "%Y-%m-%d")
  period <- c(period, NA)
  test_that(paste( datasets[i], " - ", location, ": subset period with start and NA"), {
    #runtests
    suppressMessages(tmp <- getData(datasets[i], location =location, collapse = F, period = period))
    testPeriodStart(tmp, period[!is.na(period)])
  })
}

