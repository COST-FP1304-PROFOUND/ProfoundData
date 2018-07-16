# @title A get version function
# @description  A function to provide information on the version of the DB
# @return a table with the versioning: version name, date and description
# @examples \dontrun{
# versionDB <- getVersion()
# }
# @export
# @keywords ProfoundData
# @author Ramiro Silveyra Gonzalez
getSiteDescription <- function(dataset, location = NULL){
  conn <- try(makeConnection(), T)
  if ('try-error' %in% class(conn)){
    stop("Invalid database connection")
  }
  if(is.null(location)){
    if (!getDatasets(dataset) ){stop("Invalid dataset")}
    table <- RSQLite::dbGetQuery(conn, paste("SELECT * FROM ", dataset, sep = ""))
    RSQLite::dbDisconnect(conn)
  }else{
    location <- getLocations(location)
    if (!getDatasets(dataset) || !location ){stop("Invalid dataset and/or location")}
    if(!checkAvailable(dataset, location)){stop("Location specific source is not available")}
    dataset_location <- paste(dataset, location, sep="_")
    table <- RSQLite::dbGetQuery(conn, paste("SELECT * FROM ", dataset_location, sep = ""))
    RSQLite::dbDisconnect(conn)
  }
  return(table)
}



# @title A get locations function
# @description  A function to provide information on available locations in the
# ProfoundData database
# @param location a character string providing the name of the location (optional)
# @return a table with the locations if not arguments are passed. Otherwise, it returns the
# location ID.
# @export
# @examples \dontrun{
# locations <- getLocations()
# }
# @note To report errors in the package or the data, please use the issue tracker
# in the github repository of TG2 https://github.com/COST-FP1304-PROFOUND/TG2/issues
# (preferred, but requires that you have access to our GitHub account) or
# or use this google form http://goo.gl/forms/e2ZQCiZz4x
# @keywords ProfoundData
# @author Ramiro Silveyra Gonzalez
getLocations <- function(location = NULL){
  conn <- try(makeConnection(), T)
  if ('try-error' %in% class(conn)){
    stop("Invalid database connection")
  }
  table <- RSQLite::dbGetQuery(conn, "SELECT * FROM SITES")
  RSQLite::dbDisconnect(conn)
  if(!is.null(location)){
    if (location %in% table[["site"]]){
      sites <- table[table$site==location,]$site_id
    }else if(location %in% table[["site2"]]){
      sites <- table[table$site2==location,]$site_id
      sites <-  sites[!is.na(sites)]
    }else if (location %in% table[["site_id"]]){
      sites <- location
    }else{
      sites <- 0
    }
  }else{
    sites <- table   #[, c("Site_ID", "name1", "name2")]
  }
  return(sites)
}

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

# @title A get variables function
# @description  A function to provide information on available variables of a
# dataset
# @param dataset a character string providing the name of the dataset
# @param quality a boolean to to see whether we want to see what variables have
# quality flags for the specified dataset.
# @return a vector with the available variables
# @export
# @note To report errors in the package or the data, please use the issue tracker
# in the github repository of TG2 https://github.com/COST-FP1304-PROFOUND/TG2/issues
# (preferred, but requires that you have access to our GitHub account) or
# or use this google form http://goo.gl/forms/e2ZQCiZz4x
# @keywords ProfoundData
# @author Ramiro Silveyra Gonzalez
getVariables <- function(dataset,  quality = FALSE){
  conn <- try(makeConnection(), T)
  if ('try-error' %in% class(conn)){
    stop("Invalid database connection")
  }else{
    RSQLite::dbDisconnect(conn)
  }
  if(is.null(dataset)){
    stop("Please provide a dataset")
  }
  datasets.available <- getDatasets()
  if(dataset == "error"){
    stop("Please provide a valid dataset")
  }

  conn <- makeConnection()
  variables.available <- RSQLite::dbListFields(conn, dataset)
  RSQLite::dbDisconnect(conn)



  if (quality == TRUE){
    allvariables <- variables.available[!grepl("_qc$", variables.available)]
    variables.available <- variables.available[grepl("_qc$", variables.available)]
    variables.available.names <- gsub("qc", "", variables.available)
    for (i in 1:length(variables.available.names)){
      variables.available.names[i] <- allvariables[grepl(variables.available.names[i], allvariables)]
    }
    names(variables.available) <-  variables.available.names
  }else{
    variables.available <- variables.available[!grepl("_qc$", variables.available)]
  }
  return(variables.available)
}
