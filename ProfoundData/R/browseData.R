#' @title A browse database function
#'
#' @description  A function to provide information on available data in the
#' PROFOUND database
#' @param location a character string providing the name of the location (optional)
#' @param dataset a character string providing the name of the dataset (optional)
#' @param variables a boolean indicating whether to return the variables of a dataset,
#'  instead of the available locations
#' @param collapse boolean indicating whether to return the compact (TRUE) or the extended (FALSE)
#' data overview, if neither location nor dataset are passed to the function
#' @return \itemize{
#'    \item if no arguments,  an overview of available data
#'    \item  if metadata, the requested metadata
#'    \item  if dataset and variables, available variables for a dataset
#'    \item  if dataset, available locations for the dataset
#'    \item  if location, available datasets for a location
#'    \item  if location and dataset,  retuns a integer. Availability is coded as 0 = no available and 1 = available.
#'     This is the quickest option to check availability.
#'    }
#'
#' @keywords ProfoundData
#' @details  Besides providing information on available data, this function allows
#' to access the database metadata, policy,  data sources and site descriptions.
#' @note To report errors in the package or the data, please use the issue tracker
#' in the github repository of TG2 https://github.com/COST-FP1304-PROFOUND/TG2/issues
#' (preferred, but requires that you have access to our GitHub account) or
#' or use this google form http://goo.gl/forms/e2ZQCiZz4x
#' @example /inst/examples/browseDataHelp.R
#' @export
browseData <- function(dataset = NULL, location = NULL,  variables  = FALSE, collapse = TRUE){

  conn <- try(makeConnection(), T)
  if ('try-error' %in% class(conn)){
    stop("Invalid database connection")
  }else{
    RSQLite::dbDisconnect(conn)
  }

  # 1. See everythin for location
  if(is.null(location) & is.null(dataset)){
    conn <- makeConnection()
    if (collapse){
      table <- RSQLite::dbGetQuery(conn, "SELECT * FROM OVERVIEW")
      RSQLite::dbDisconnect(conn)
    }else{
      table <- RSQLite::dbGetQuery(conn, "SELECT * FROM OVERVIEW_EXTENDED")
      RSQLite::dbDisconnect(conn)
    }
    # return the entire table
    #cat("Returning the overview table")
    # prepare the query
  # 2. No location
  }else if(is.null(location)){
    dataset <- gsub(" ", "",  dataset)
    dataset <- gsub("-", "",  dataset)
    dataset <- gsub("+", "",  dataset)
    if(dataset == "ENERGYBALANCE"){
      warning("Dataset 'ENERGYBALANCE' is deprecated.\n Use 'ATMOSPHERICHEATCONDUCTION' instead.")
      dataset <- "ATMOSPHERICHEATCONDUCTION"
    }

    # a. See all dataset
    if(dataset == "DATASETS"){
      table <- getDatasets()
      if(variables){
        # b. See all variables for all datast
        dummy <- lapply(table, function(x) {
            var <- as.matrix(getVariables(x))
            var <- cbind( rep(x, nrow(var)), var[,1])
            return(var)
          })
        table <- Reduce(rbind, dummy)
        colnames(table) <- c("dataset", "variables")
      }
    }else if (dataset == "VERSION"){
      table <- getVersion()
    }else if (grepl("METADATA", dataset)){
      table <- getMetadata(dataset)
    }else if (grepl("SOURCE", dataset)){
      table <- getSource(dataset)
    }else if (grepl("POLICY", dataset)){
      table <- getPolicy(dataset)
    }else if (dataset == "SITEDESCRIPTION" ){
     stop("Use getData to download this dataset")
    }else{
      if(dataset == "ENERGYBALANCE"){
        warning("Dataset 'ENERGYBALANCE' is deprecated.\n Use 'ATMOSPHERICHEATCONDUCTION' instead.")
        dataset <- "ATMOSPHERICHEATCONDUCTION"
      }

      if (!getDatasets(dataset)){stop("The dataset is not available. Please call getDatasets to see what datasets are available.")}

      # b. See all variables for all datast
      if(variables){
        table <- getVariables(dataset)
        #table <- as.matrix(getVariables(dataset))
        #table <- cbind( rep(dataset, nrow(table)), table[,1])
        #colnames(table) <- c("dataset", "variables")
      }else{
      # c. See what location have the dataset
        conn <- makeConnection()
        table <- RSQLite::dbGetQuery(conn, "SELECT * FROM OVERVIEW_EXTENDED")
        RSQLite::dbDisconnect(conn)
        columns <- c("site_id", "site", dataset)
        table <- table[table[[dataset]]==1, columns ]
      }
    }
  }else if(is.null(dataset)){
    location <- getLocations(location)
    # return the entire table
    if (!location){stop("The location is not available. Please call getLocations to see what locations are available.")}
    conn <- makeConnection()
    table <- RSQLite::dbGetQuery(conn, "SELECT * FROM OVERVIEW_EXTENDED")
    RSQLite::dbDisconnect(conn)
    table <- table[table$site_id == location, ] # c(1:14) THE entire table

  }else{
    location <- getLocations(location)
    dataset <- gsub(" ", "",  dataset)
    dataset <- gsub("-", "",  dataset)
    dataset <- gsub("+", "",  dataset)
    if(dataset == "ENERGYBALANCE"){
      warning("Dataset 'ENERGYBALANCE' is deprecated.\n Use 'ATMOSPHERICHEATCONDUCTION' instead.")
      dataset <- "ATMOSPHERICHEATCONDUCTION"
    }

    if (!getDatasets(dataset) || !location ){stop("Invalid dataset and/or location")}
    if (dataset == "VERSION"){
      table <- getVersion()
#    }else if (dataset == "CO2_ISIMIP"){
#      conn <- makeConnection()
#      table <- RSQLite::dbGetQuery(conn, "SELECT * FROM OVERVIEW")
#      RSQLite::dbDisconnect(conn)
#      columns <- c("site_id", "name1", "name2", dataset)
#      table <- table[table[[dataset]]==1, columns ]
    }else if (grepl("METADATA", dataset)){
      table <- getMetadata(dataset, location)
      #table <- table[table$dataset == dataset, ]
    }else if (grepl("SOURCE", dataset)){
      table <- getSource(dataset, location)
    }else if (grepl("POLICY", dataset)){
      table <- getPolicy(dataset, location)
    }else if (dataset == "SITEDESCRIPTION" ){
      stop("Use getData to download this dataset")
    }else{
      table <- checkAvailable(dataset, location)
    }
  }
  return(table)
}
