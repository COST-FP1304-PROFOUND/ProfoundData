# @title A check availability function used by browseData and parseQuery
# @description  A fucntion to check availability of a dataset for a location.
# It is used by browseData and parseQuery
# @param dataset a character string providing the name of the dataset
# @param location a character string providing the name of the location
# @return a numeric boolean
checkAvailable <- function(dataset, location){
  tmp <-0
  dataset_location <- paste(dataset, location, sep="_")
  if(getDatasets(dataset_location)){
    tmp <- 1
  }
  return(tmp)
}


