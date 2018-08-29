# @title A check availability function used by browseData and parseQuery
# @description  A fucntion to check availability of a dataset for a site.
# It is used by browseData and parseQuery
# @param dataset a character string providing the name of the dataset
# @param site a character string providing the name of the site
# @return a numeric boolean
checkAvailable <- function(dataset, site){
  tmp <-0
  dataset_site <- paste(dataset, site, sep="_")
  if(getDatasets(dataset_site)){
    tmp <- 1
  }
  return(tmp)
}


