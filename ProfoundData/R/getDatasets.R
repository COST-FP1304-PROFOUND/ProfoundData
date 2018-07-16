# @title A get datasets function
# @description  A function to provide information on available datasets in the
# ProfoundData database
# @param dataset a character string providing the name of the dataset (optional)
# @return a vector with the available datasets if not arguments are passed. Otherwise,
# it returns a numeric boolean.
# @export
# @examples \dontrun{
# datasets <- getDatasets()
# }
# @note To report errors in the package or the data, please use the issue tracker
# in the github repository of TG2 https://github.com/COST-FP1304-PROFOUND/TG2/issues
# (preferred, but requires that you have access to our GitHub account) or
# or use this google form http://goo.gl/forms/e2ZQCiZz4x
# @keywords ProfoundData
# @author Ramiro Silveyra Gonzalez
getDatasets <- function(dataset = NULL){
  conn <- try(makeConnection(), T)
  if ('try-error' %in% class(conn)){
    stop("Invalid database connection")
  }
  datasets.available <- RSQLite::dbListTables(conn)
  datasets.available <- datasets.available[!grepl("_master", datasets.available)]
  RSQLite::dbDisconnect(conn)
  if(!is.null(dataset)){
    if (dataset %in% datasets.available){
      dataset.checked <- 1
    }else{
      dataset.checked  <- 0
    }
  }else{
    dataset.checked <- datasets.available[!grepl("_[0-9]", datasets.available)]
    dataset.checked <- datasets.available[!grepl("OVERVIEW", datasets.available)]
  }
  return(dataset.checked)
}
