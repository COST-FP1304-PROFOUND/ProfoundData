#' @title A function to plot data
#'
#' @description  A function to plot data of a site
#' from the PROFOUND database.
#' @param site a character string providing the name of a site.
#' @param location deprecated argument. Please use site instead.
#' @param dataset a character string providing the name of a dataset
#' @param forcingDataset a character string providing the name of a forcingDataset.
#' Only relevant for ISIMIP datasets.
#' @param forcingCondition a character string providing the name of a forcingCondition.
#' Only relevant for ISIMIP datasets.
#' @param species a character string providing the species name or species id.
#' @param variables a character array holding the variables to be plotted. Default  is all variables.
#' @param quality a number indicating the quality threshold to be used. Default is none.
#' @param decreasing a boolean indicating whether the quality threshold should be applied up- or downwards
#' @param period a character array with either start or start and end of the subset.
#'  It must have the format "YYYY-MM-DD", or c("YYYY-MM-DD", "YYYY-MM-DD").
#' @param aggregated a boolean indicating whether data should be aggregated for display.
#' Possible values are date, day, month and year.
#' @param FUN a function to use for aggregating the data
#' @param automaticPanels a boolean indicating whether the function automatically creates panels
#' @return plots for the specified dataset, site and variables
#' @keywords ProfoundData
#' @note To report errors in the package or the data, please use the issue tracker
#' in the GitHub repository of ProfoundData \url{https://github.com/COST-FP1304-PROFOUND/ProfoundData}
#' @details Plotting is not supported for the following datasets: OVERVIEW, SITES, SOIL(more). The aggregation of data
#' relies on the function \code{\link{aggregate}} for \code{\link{zoo}} objects. The FUN parameter
#' is passed to FUN from \code{\link{aggregate}}. Please check the help files of  \code{\link{aggregate}}
#' for further information. For handling NAs we recommend to pass self-defined functions (see examples).
#' @export
#' @example /inst/examples/plotDataHelp.R
plotData <- function(dataset, site, location=NULL,forcingDataset = NULL,
                     forcingCondition = NULL, species = NULL, variables = NULL, period = NULL,
                     aggregated = NULL, FUN = mean, automaticPanels = T, quality = NULL , decreasing = TRUE){
  if (!is.null(location)) {
    warning("Argument location is deprecated.\nPlease use site instead.",
            call. = FALSE)
    site <- location
  }
  if(dataset == "ENERGYBALANCE"){
    warning("Dataset 'ENERGYBALANCE' is deprecated.\nUse 'ATMOSPHERICHEATCONDUCTION' instead.",
            call. = FALSE)
    dataset <- "ATMOSPHERICHEATCONDUCTION"
  }

  notSupportedDatasets <- c("OVERVIEW", "SITES", "SOIL", "POLICY", "SOURCE", "SITEDESCRITPION",
                            "OVERVIEW_EXTENDED")
  if(dataset %in% notSupportedDatasets) stop("Plotting is not supported")
  # parse and test the query
  tmp <- try(parseQuery(dataset =dataset, site = site,  forcingDataset = forcingDataset,
                        forcingCondition = forcingCondition, species = species,
                        variables = variables, period = period,
                        aggregated = aggregated, FUN = FUN, automaticPanels = automaticPanels,
                        quality = quality , decreasing = decreasing, collapse = F), F)
  if ('try-error' %in% class(tmp))    stop("Could not parse the query")
  # Fetch the query
  message(paste("Downloading data from" , dataset, "for the site", site,  sep = " "))
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
      # this is any daily data
  }else{
    #cat("\n");cat("daily");cat("\n")
    plotPROFOUND.DAILY(tmp)
  }
}



