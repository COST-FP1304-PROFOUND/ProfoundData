#' @title A browse database function
#'
#' @description  A function to provide information on available data in the
#' PROFOUND database.
#' @param site a character string providing the name of the site (optional).
#' @param location deprecated argument. Please use site instead.
#' @param dataset a character string providing the name of the dataset (optional).
#' @param variables a boolean indicating whether to return the variables of a dataset,
#'  instead of the available sites.
#' @param collapse a boolean indicating whether to return the compact (TRUE) or the extended (FALSE)
#' data overview, if neither site nor dataset are passed to the function.
#' @return \itemize{
#'    \item if no arguments,  an overview of available data
#'    \item  if metadata, the requested metadata
#'    \item  if dataset and variables, available variables for a dataset
#'    \item  if dataset, available sites for the dataset
#'    \item  if site, available datasets for a site
#'    \item  if site and dataset,  returns an integer. Availability is coded as 0 = no available and 1 = available.
#'     This is the quickest option to check availability.
#'    }
#'
#' @keywords ProfoundData
#' @details  Besides providing information on available data, this function allows
#' to access the database metadata, policy,  data sources and site descriptions.
#' @note To report errors in the package or the data, please use the issue tracker
#' in the GitHub repository of ProfoundData \url{https://github.com/COST-FP1304-PROFOUND/ProfoundData}
#' @example /inst/examples/browseDataHelp.R
#' @export
browseData <- function(dataset = NULL, site = NULL,  location = NULL, variables  = FALSE, collapse = TRUE){

  conn <- try(makeConnection(), T)
  if ('try-error' %in% class(conn)){
    stop("Invalid database connection")
  }else{
    RSQLite::dbDisconnect(conn)
  }

  if (!is.null(location)) {
    warning("Argument location is deprecated.\nPlease use site instead.",
            call. = FALSE)
    site <- location
  }

  # 1. See everything for site
  if(is.null(site) & is.null(dataset)){
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
  # 2. No site
  }else if(is.null(site)){
    dataset <- gsub(" ", "",  dataset)
    dataset <- gsub("-", "",  dataset)
    dataset <- gsub("+", "",  dataset)
    if(dataset == "ENERGYBALANCE"){
      warning("Dataset 'ENERGYBALANCE' is deprecated.\nUse 'ATMOSPHERICHEATCONDUCTION' instead.",
              call. = FALSE)
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
        warning("Dataset 'ENERGYBALANCE' is deprecated.\nUse 'ATMOSPHERICHEATCONDUCTION' instead.",
                call. = FALSE)
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
      # c. See what site have the dataset
        conn <- makeConnection()
        table <- RSQLite::dbGetQuery(conn, "SELECT * FROM OVERVIEW_EXTENDED")
        RSQLite::dbDisconnect(conn)
        columns <- c("site_id", "site", dataset)
        table <- table[table[[dataset]]==1, columns ]
      }
    }
  }else if(is.null(dataset)){
    site <- getsites(site)
    # return the entire table
    if (!site){stop("The site is not available. Please call getsites to see what sites are available.")}
    conn <- makeConnection()
    table <- RSQLite::dbGetQuery(conn, "SELECT * FROM OVERVIEW_EXTENDED")
    RSQLite::dbDisconnect(conn)
    table <- table[table$site_id == site, ] # c(1:14) THE entire table

  }else{
    site <- getsites(site)
    dataset <- gsub(" ", "",  dataset)
    dataset <- gsub("-", "",  dataset)
    dataset <- gsub("+", "",  dataset)
    if(dataset == "ENERGYBALANCE"){
      warning("Dataset 'ENERGYBALANCE' is deprecated.\nUse 'ATMOSPHERICHEATCONDUCTION' instead.",  call. = FALSE
              )
      dataset <- "ATMOSPHERICHEATCONDUCTION"
    }

    if (!getDatasets(dataset) || !site ){stop("Invalid dataset and/or site")}
    if (dataset == "VERSION"){
      table <- getVersion()
#    }else if (dataset == "CO2_ISIMIP"){
#      conn <- makeConnection()
#      table <- RSQLite::dbGetQuery(conn, "SELECT * FROM OVERVIEW")
#      RSQLite::dbDisconnect(conn)
#      columns <- c("site_id", "name1", "name2", dataset)
#      table <- table[table[[dataset]]==1, columns ]
    }else if (grepl("METADATA", dataset)){
      table <- getMetadata(dataset, site)
      #table <- table[table$dataset == dataset, ]
    }else if (grepl("SOURCE", dataset)){
      table <- getSource(dataset, site)
    }else if (grepl("POLICY", dataset)){
      table <- getPolicy(dataset, site)
    }else if (dataset == "SITEDESCRIPTION" ){
      stop("Use getData to download this dataset")
    }else{
      table <- checkAvailable(dataset, site)
    }
  }
  return(table)
}
