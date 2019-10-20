# @description  A function to provide information on site
# @return a table with the site description
# @examples \dontrun{
# dataSiteDescription <- getSiteDescription(dataset ="CLIMATE_ISIMIP2A", site = "soro")
# }
# @export
# @keywords ProfoundData
# @author Ramiro Silveyra Gonzalez
getSiteDescription <- function(dataset, site = NULL){
  conn <- try(makeConnection(), T)
  if ('try-error' %in% class(conn)){
    stop("Invalid database connection", call. = FALSE)
  }
  if(is.null(site)){
    if (!getDatasets(dataset) ){stop("Invalid dataset", call. = FALSE)}
    table <- RSQLite::dbGetQuery(conn, paste("SELECT * FROM ", dataset, sep = ""))
    RSQLite::dbDisconnect(conn)
  }else{
    site <- getsites(site)
    if (!getDatasets(dataset) || !site ){stop("Invalid dataset and/or site", call. = FALSE)}
    if(!checkAvailable(dataset, site)){stop("site specific source is not available", call. = FALSE)}
    dataset_site <- paste(dataset, site, sep="_")
    table <- RSQLite::dbGetQuery(conn, paste("SELECT * FROM ", dataset_site, sep = ""))
    RSQLite::dbDisconnect(conn)
  }
  return(table)
}



# @title A get sites function
# @description  A function to provide information on available sites in the
# ProfoundData database
# @param site a character string providing the name of the site (optional)
# @return a table with the sites if not arguments are passed. Otherwise, it returns the
# site ID.
# @export
# @examples \dontrun{
# sites <- getsites()
# }
# @keywords ProfoundData
# @author Ramiro Silveyra Gonzalez
getsites <- function(site = NULL){
  conn <- try(makeConnection(), T)
  if ('try-error' %in% class(conn)){
    stop("Invalid database connection")
  }
  table <- RSQLite::dbGetQuery(conn, "SELECT * FROM SITES")
  RSQLite::dbDisconnect(conn)
  if(!is.null(site)){
    if (site %in% table[["site"]]){
      sites <- table[table$site==site,]$site_id
    }else if(site %in% table[["site2"]]){
      sites <- table[table$site2==site,]$site_id
      sites <-  sites[!is.na(sites)]
    }else if (site %in% table[["site_id"]]){
      sites <- site
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
