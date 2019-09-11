# @title A function to parse query data from a DB
#
# @description TODO
# @param site a character string providing the name of the site
# @param dataset a character string providing the name one of the available datasets
# @return tmp a object containing only needed parameters for executing the query
# @author Ramiro Silveyra Gonzalez
parseQuery <- function(dataset, site, forcingDataset = NULL,
                       forcingCondition = NULL, species = NULL, variables = NULL, period = NULL,
                       aggregated = NULL, FUN = mean, automaticPanels = F, quality = NULL ,
                       decreasing = TRUE, collapse = TRUE){

  conn <- try(makeConnection(), T)
  if ('try-error' %in% class(conn)){
    stop("Invalid database connection", call. = FALSE)
  }else{
    RSQLite::dbDisconnect(conn)
  }
  message("Parsing query")
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
  message("Checking dataset")
  # create the item.dataset
  tmp <- list( dataset = dataset, site = site,
               variables = variables,
               period = period,
               aggregated = aggregated, FUN = FUN, automaticPanels = automaticPanels,
               quality = quality , decreasing = decreasing, collapse = collapse,
               aggregated = aggregated, FUN = FUN,
               item = NULL,variablesChecked = NULL, query = NULL, data = NULL,
               dropVariables = TRUE )

  if(is.null(tmp[["variables"]])) tmp[["dropVariables"]] <- F
  dataset <- getDatasets(tmp[["dataset"]])
  if (!dataset) stop("Invalid dataset. Please use browseData() to see the available datasets", call. = FALSE)
  if (tmp[["dataset"]] == "VERSION" || grepl("METADATA", tmp[["dataset"]]) || tmp[["dataset"]] == "POLICY" || tmp[["dataset"]] == "SOURCE" ){
    stop(paste("Use browseData for accesing", tmp[["dataset"]]), call. = FALSE)
  }
  message("Checking site")
  if(is.null(tmp[["site"]])){
    if (tmp[["dataset"]] == "SITES" || tmp[["dataset"]] == "SITEDESCRIPTION" ){
      tmp[["item"]] <- paste( "SELECT * FROM", tmp[["dataset"]] ,sep = " ")
    }else{
      stop("Please provide a site name", call. = FALSE)
    }
  }else if(!is.null(tmp[["site"]])){
    tmp[["site"]] <- getsites(tmp[["site"]])
    if (!tmp[["site"]])stop("Invalid site. Please use browseData to see the available sites", call. = FALSE)
    message("Checking variables")
  #  cat(tmp[["dataset"]]); cat(tmp[["variables"]])
    tmp[["variablesChecked"]] <- parseVariables(tmp[["dataset"]], tmp[["variables"]])
    # Here code for CO2 and SITES. Based on version do something or the other.
    # Check data availability
    message("Checking the availability")
    available <- checkAvailable(dataset = tmp[["dataset"]], site=tmp[["site"]])
    if (!available){
      if (tmp$dataset == "CO2_ISIMIP"){
        # Chekc if sites are there
        if(!is.null(site)){
          site <- getsites(site)
          if (!site){stop("Invalid site. Please use browseData to see the available sites", call. = FALSE)}
        }
        tmp[["item"]] <- paste( "SELECT * FROM", tmp[["dataset"]],sep = " ")
        tmp[["site"]]<- 99
      }else if (!tmp[["dataset"]] == "SITES" ){
        stop("The dataset is not available for the site. Please use browseData() to check data availability", call. = FALSE)
      }
    }
    tmp[["item"]] <- paste( "SELECT * FROM", paste(tmp[["dataset"]], tmp[["site"]], sep = "_") ,sep = " ")
  }
  # return the tmp object
  return(tmp)
}




