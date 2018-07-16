#' @title A function to get data
#'
#' @description  This function allows to download datasets for a location
#' from the PROFOUND database.
#' @param dataset a character string providing the name one of the available datasets
#' @param location a character string providing the name of the location
#' @param forcingDataset a character string providing the name of the a forcingDataset.
#' Only relevant for ISIMIP datasets.
#' @param forcingCondition a character string providing the name of the a forcingCondition.
#' Only relevant for ISIMIP datasets.
#' @param species a character string providing the species name or species id
#' @param variables  a character array holding the variables to be plotted. Default  is all variables.
#' @param quality a number indicating the quality threshold to be used. Default is none.
#' @param decreasing a boolean indicating whether the quality threshold should be applied up- or downwards
#' @param period a character array either start of the subset or start and end.
#'  It must have the format YYYY-MM-DD.
#' @param collapse a boolean indicating whether the returned data should be a
#' single dataframe (TRUE) or list of dataframes. Relevant when downloading SOIL and ISIMIP datasets.
#' @return a dataframe or list of dataframes, depending on collapse
#' @keywords ProfoundData
#' @import zoo
#' @details When using quality, please be aware that the threshold value is included
#' in the returned data. Threshold works by removing data values taht are greater
#'  (decreasing = TRUE) or less(decreasing = FALSE) than the given value.
#'  The quality parameter is only relevant for datasets that have quality flags. These are
#' ATMOSPHERICHEATCONDUCTION, SOILTS, FLUX, METEOROLOGICAL, and CLIMATE LOCAL for some sites. Please
#' check the metadata of each dataset before using this parameter.
#' @note To report errors in the package or the data, please use the issue tracker
#' in the github repository of TG2 https://github.com/COST-FP1304-PROFOUND/TG2/issues
#' (preferred, but requires that you have access to our GitHub account) or
#' or use this google form http://goo.gl/forms/e2ZQCiZz4x
#' @export
#' @examples
#' \dontrun{
#' getData("TREE", location = "Soro")
#' getData("CLIMATE_ISIMIP2B", location = "Soro", collapse=T)
#' getData("CLIMATE_ISIMIP2B", location = "Soro", collapse=F)
#' getData("SOIL", location = "Kroof", collapse=F)
#' getData("SOIL", location = "Kroof", collapse=T)
#' getData("CLIMATE_LOCAL", location = "Collelongo")
#' # Period options
#' getData("CLIMATE_LOCAL", location = "Collelongo", period = "1996-01-01")
#' getData("CLIMATE_LOCAL", location = "Collelongo", period = c("1996-01-01", "1996-12-31"))
#' getData("CLIMATE_LOCAL", location = "Collelongo", period = c(NA "1996-12-31"))
#' getData("CLIMATE_LOCAL", location = "Collelongo", period = c("1996-01-01", NA))
#'  }
#' @author Ramiro Silveyra Gonzalez
#'

getData <- function(dataset, location = NULL, forcingDataset = NULL,
                    forcingCondition = NULL, species = NULL, variables = NULL,
                    period = NULL, collapse = TRUE,
                    quality = NULL,  decreasing = TRUE){
  # parse and test the query
  tmp <- try(parseQuery(dataset =dataset, location = location,  forcingDataset = forcingDataset,
                        forcingCondition = forcingCondition, species = species,
                        variables = variables, period = period, collapse = collapse,
                        quality = quality , decreasing = decreasing), F)
  if ('try-error' %in% class(tmp))    stop("Could not parse the query")
  message(paste("Downloading data from" , dataset, "for the location", location,  sep = " "))
  tmp <- try(fetchQuery(tmp), F)
  if ('try-error' %in% class(tmp)){
    if (tmp[["dataset"]] == "SITES"){
      if(!is.null(tmp[["location"]])){
        data <-getLocations(tmp[["location"]])
      }else{
        data <- getLocations()
      }
    }else  if (tmp[["dataset"]] == "SITEDESCRIPTION"){
      if(!is.null(tmp[["location"]])){
        data <-getSiteDescription(tmp[["dataset"]], tmp[["location"]])
      }else{
        data <- getSiteDescription(tmp[["dataset"]])
      }
    }else{
      warning(tmp[["queried"]])
      stop("Could not fetch the query")
    }
    warning(tmp[["queried"]])
    stop("Could not fetch the query")
  }
  data <- formatData(tmp)
  return(data)
}











