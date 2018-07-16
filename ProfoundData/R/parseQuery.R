# @title A function to parse query data from a DB
#
# @description TODO
# @param location a character string providing the name of the location
# @param dataset a character string providing the name one of the available datasets
# @return tmp a object containing only needed parameters for executing the query
# @note To report errors in the package or the data, please use the issue tracker
# in the github repository of TG2 https://github.com/COST-FP1304-PROFOUND/TG2/issues
# (preferred, but requires that you have access to our GitHub account) or
# or use this google form http://goo.gl/forms/e2ZQCiZz4x
# @author Ramiro Silveyra Gonzalez

parseQuery <- function(dataset, location,  forcingDataset = NULL,
                       forcingCondition = NULL, species = NULL, variables = NULL, period = NULL,
                       aggregated = NULL, FUN = mean, automaticPanels = F, quality = NULL ,
                       decreasing = TRUE, collapse = TRUE){

  conn <- try(makeConnection(), T)
  if ('try-error' %in% class(conn)){
    stop("Invalid database connection")
  }else{
    RSQLite::dbDisconnect(conn)
  }
  message("Parsing the query")
  # Clean up the dataset and the dataset options
  dataset <- gsub(" ", "",  dataset)
  dataset <- gsub("-", "",  dataset)
  dataset <- gsub("+", "",  dataset)
  if(!is.null(forcingDataset)){
    forcingDataset <- gsub(" ", "",  forcingDataset)
    forcingDataset <- gsub("-", "",  forcingDataset)
    forcingDataset <- gsub("+", "",  forcingDataset)
    if(!is.null(forcingCondition)){
      forcingCondition <- gsub(" ", "",  forcingCondition)
      forcingCondition <- gsub("-", "",  forcingCondition)
      forcingCondition <- gsub("+", "",  forcingCondition)
      dataset <- paste(dataset, forcingDataset, forcingCondition, sep = "_")
    }else{
      dataset <- paste(dataset, forcingDataset, sep = "_")
    }
  }else if(!is.null(forcingCondition)){
    forcingCondition <- gsub(" ", "",  forcingCondition)
    forcingCondition <- gsub("-", "",  forcingCondition)
    forcingCondition <- gsub("+", "",  forcingCondition)
    dataset <- paste(dataset, forcingCondition, sep = "_")
  }
  if(dataset == "TREE" || dataset == "STAND"){
    if(!is.null(species)){
      species <- gsub("-", "",  species)
      species <- gsub("+", "",  species)
      species <- getTreeSpecies(species)
      dataset <- paste(dataset, species, sep = "_")
    }
  }
  message("Checking the dataset")
  # create the item.dataset
  tmp <- list( dataset = dataset, location = location,
               variables = variables,
               period = period,
               aggregated = aggregated, FUN = FUN, automaticPanels = automaticPanels,
               quality = quality , decreasing = decreasing, collapse = collapse,
               aggregated = aggregated, FUN = FUN,
               item = NULL,variablesChecked = NULL, query = NULL, data = NULL,
               dropVariables = TRUE )

  if(is.null(tmp[["variables"]])) tmp[["dropVariables"]] <- F
  dataset <- getDatasets(tmp[["dataset"]])
  if (!dataset) stop("Invalid dataset. Please use browseData() to see the available datasets")
  if (tmp[["dataset"]] == "VERSION" || grepl("METADATA", tmp[["dataset"]]) || tmp[["dataset"]] == "POLICY" || tmp[["dataset"]] == "SOURCE" ){
    stop(paste("Use browseData for accesing", tmp[["dataset"]]))
  }
  message("Checking the location")
  if(is.null(tmp[["location"]])){
    if (tmp[["dataset"]] == "SITES" || tmp[["dataset"]] == "SITEDESCRIPTION" ){
      tmp[["item"]] <- paste( "SELECT * FROM", tmp[["dataset"]] ,sep = " ")
    }else{
      stop("Bug!")
    }
  }else if(!is.null(tmp[["location"]])){
    tmp[["location"]] <- getLocations(tmp[["location"]])
    if (!tmp[["location"]])stop("Invalid location. Please use browseData to see the available locations")
    message("Checking the variables")
  #  cat(tmp[["dataset"]]); cat(tmp[["variables"]])
    tmp[["variablesChecked"]] <- parseVariables(tmp[["dataset"]], tmp[["variables"]])
    # Here code for CO2 and SITES. Based on version do something or the other.
    # Check data availability
    message("Checking the availability")
    available <- checkAvailable(dataset = tmp[["dataset"]], location=tmp[["location"]])
    if (!available){
      if (tmp$dataset == "CO2_ISIMIP"){
        # Chekc if locations are there
        if(!is.null(location)){
          location <- getLocations(location)
          if (!location){stop("Invalid location. Please use browseData to see the available locations")}
        }
        tmp[["item"]] <- paste( "SELECT * FROM", tmp[["dataset"]],sep = " ")
        tmp[["location"]]<- 99
      }else if (!tmp[["dataset"]] == "SITES" ){
        stop("The dataset is not available for the location. Please use browseData() to check data availability")
      }
    }
    tmp[["item"]] <- paste( "SELECT * FROM", paste(tmp[["dataset"]], tmp[["location"]], sep = "_") ,sep = " ")
  }
  # return the tmp object
  return(tmp)
}




