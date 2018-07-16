#' @title A function to plot data
#'
#' @description  A function to plot data of dataset for a location
#' from the ProfoundData database.
#' @param location a character string providing the name of the location
#' @param dataset a character string providing the name one of the available datasets
#' @param forcingDataset a character string providing the name of the a forcingDataset.
#' Only relevant for ISIMIP datasets.
#' @param forcingCondition a character string providing the name of the a forcingCondition.
#' Only relevant for ISIMIP datasets.
#' @param species a character string providing the species name or species id.
#' @param variables  a character array holding the variables to be plotted. Default  is all variables.
#' @param quality a number indicating the quality threshold to be used. Default is none.
#' @param decreasing a boolean indicating whether the quality threshold should be applied up- or downwards
#' @param period a character array either start of the subset or start and end
#' @param aggregated a boolean indicating whether data should be aggregated for display.
#' Possible values are date, day, month and year.
#' @param FUN a function to use for aggregating the data
#' @param automaticPanels should the function automatically create panels
#' @return plots for the specified dataset, location and variables
#' @keywords ProfoundData
#' @note To report errors in the package or the data, please use the issue tracker
#' in the github repository of TG2 https://github.com/COST-FP1304-PROFOUND/TG2/issues
#' (preferred, but requires that you have access to our GitHub account) or
#' or use this google form http://goo.gl/forms/e2ZQCiZz4x
#' @details Plotting is not supported for datasets: OVERVIEW, SITES, SOIL. The aggregation of data
#' relies on the function \code{\link{aggregate}} for \code{\link{zoo}} objects. The FUN parameter
#' is passed to FUN from \code{\link{aggregate}}. Please check the help files of  \code{\link{aggregate}}
#' for further information. For handling NAs we recommend to pass self-defined fuctions (see examples)
#' the behavious
#' @export
#' @examples
#' \dontrun{
#' plotData("TREE", location = "Soro")
#' plotData("TREE", location = "Soro", automaticPanels=T)
#' plotData("TREE", location = "Soro", automaticPanels=T, aggregate = T, FUN= mean)
#' plotData("TREE", location = "Soro", automaticPanels=T, FUN = function(x)mean(x, na.rm=T))
#' #' # Period options
#' plotData("CLIMATE_LOCAL", location = "Collelongo", period = "1996-01-01")
#' plotData("CLIMATE_LOCAL", location = "Collelongo", period = c("1996-01-01", "1996-12-31"))
#' plotData("CLIMATE_LOCAL", location = "Collelongo", period = c(NA "1996-12-31"))
#' plotData("CLIMATE_LOCAL", location = "Collelongo", period = c("1996-01-01", NA))
#'  }
#' @author Ramiro Silveyra Gonzalez
plotData <- function(dataset, location,  forcingDataset = NULL,
                     forcingCondition = NULL, species = NULL, variables = NULL, period = NULL,
                     aggregated = NULL, FUN = mean, automaticPanels = T, quality = NULL , decreasing = TRUE){

  notSupportedDatasets <- c("OVERVIEW", "SITES", "SOIL", "POLICY", "SOURCE", "SITEDESCRITPION",
                            "OVERVIEW_EXTENDED")
  if(dataset %in% notSupportedDatasets) stop("Plotting is not supported")
  # parse and test the query
  tmp <- try(parseQuery(dataset =dataset, location = location,  forcingDataset = forcingDataset,
                        forcingCondition = forcingCondition, species = species,
                        variables = variables, period = period,
                        aggregated = aggregated, FUN = FUN, automaticPanels = automaticPanels,
                        quality = quality , decreasing = decreasing, collapse = F), F)
  if ('try-error' %in% class(tmp))    stop("Could not parse the query")
  # Fetch the query
  message(paste("Downloading data from" , dataset, "for the location", location,  sep = " "))
  tmp <- try(fetchQuery(tmp), F)
  if ('try-error' %in% class(tmp)) stop("Could not fetch the query")
  # Convert into time series
  # if no time series
  tmp$data <- formatData(tmp)

  if (grepl("TREE", tmp[["dataset"]]) ){
    plotPROFOUND.TREE(tmp)
  }else if (grepl("STAND", tmp[["dataset"]]) ){
    plotPROFOUND.STAND(tmp)
  }else if (tmp[["dataset"]] == "CLIMATE_LOCAL" ){
    plotPROFOUND.DAILY(tmp)
  }else  if (tmp[["dataset"]] == "FLUX" || tmp[["dataset"]] == "SOILTS" || tmp[["dataset"]] == "ATMOSPHERICHEATCONDUCTION" || tmp[["dataset"]] == "METEOROLOGICAL"){
    plotPROFOUND.HALFHOURLY(tmp)
    # Yearly data
  }else if (grepl("MODIS", tmp[["dataset"]]))  {
    plotPROFOUND.MODIS(tmp )
  }else if (grepl("ISIMIP", tmp[["dataset"]]))  {
    plotPROFOUND.ISIMIP(tmp )
  }else if (!"date" %in% names(data)){
    #cat("\n");cat("yearly");cat("\n")
    plotPROFOUND.YEARLY(tmp)
      # this is any dayly data
  }else{
    #cat("\n");cat("daily");cat("\n")
    plotPROFOUND.DAILY(tmp)
  }
}



