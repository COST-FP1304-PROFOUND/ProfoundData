#' @title A function to extract data
#'
#' @description  A function to extract datasets for a site
#' from the PROFOUND database.
#' @param dataset a character string providing the name of a dataset.
#' @param site a character string providing the name of a site.
#' @param location deprecated argument. Please use site instead.
#' @param forcingDataset a character string providing the name of a forcingDataset.
#' Only relevant for ISIMIP datasets.
#' @param forcingCondition a character string providing the name of a forcingCondition.
#' Only relevant for ISIMIP datasets.
#' @param species a character string providing the species name or species id.
#' @param variables  a character array holding the variables to be plotted. Default  is all variables.
#' @param quality a number indicating the quality threshold to be used. Default is none.
#' @param decreasing a boolean indicating whether the quality threshold should be applied up- or downwards.
#' @param period a character array with either start or start and end of the subset.
#'  It must have the format "YYYY-MM-DD", or c("YYYY-MM-DD", "YYYY-MM-DD").
#' @param collapse a boolean indicating whether the returned data should be a
#' single data frame (TRUE) or a list of data frames (FALSE). Relevant when downloading SOIL and ISIMIP datasets.
#' @return a data frame or a list of data frames, depending on collapse.
#' @keywords ProfoundData
#' @import zoo
#' @details When using quality, please be aware that the threshold value is included
#' in the returned data. Thresholding works by removing data values that are greater
#'  (decreasing = TRUE) or smaller (decreasing = FALSE) than the given value.
#'  The quality parameter is only relevant for datasets that have quality flags. These are
#' ATMOSPHERICHEATCONDUCTION, SOILTS, FLUX, METEOROLOGICAL, and CLIMATE LOCAL. Please
#' check the metadata of each dataset before using this parameter.
#' @note To report errors in the package or the data, please use the issue tracker
#' in the GitHub repository of ProfoundData \url{https://github.com/COST-FP1304-PROFOUND/ProfoundData}
#' @export
#' @example /inst/examples/getDataHelp.R
getData <- function(dataset, site = NULL, location = NULL, forcingDataset = NULL,
                    forcingCondition = NULL, species = NULL, variables = NULL,
                    period = NULL, collapse = TRUE,
                    quality = NULL,  decreasing = TRUE){
  if (!is.null(location)) {
    warning("Argument location is deprecated.\nPlease use site instead.",
            call. = FALSE)
    site <- location
  }
  if(dataset == "ENERGYBALANCE"){
    warning("Dataset 'ENERGYBALANCE' is deprecated.\nPlease use 'ATMOSPHERICHEATCONDUCTION' instead.",
            call. = FALSE)
    dataset <- "ATMOSPHERICHEATCONDUCTION"
  }
  
  # parse and test the query
  tmp <- try(parseQuery(dataset =dataset, site = site,  forcingDataset = forcingDataset,
                        forcingCondition = forcingCondition, species = species,
                        variables = variables, period = period, collapse = collapse,
                        quality = quality , decreasing = decreasing), F)
  if ('try-error' %in% class(tmp))    stop("Could not parse the query")
  message(paste("Downloading data from" , dataset, "for the site", site,  sep = " "))
  tmp <- try(fetchQuery(tmp), F)
  if ('try-error' %in% class(tmp)){
    if (tmp[["dataset"]] == "SITES"){
      if(!is.null(tmp[["site"]])){
        data <-getsites(tmp[["site"]])
      }else{
        data <- getsites()
      }
    }else  if (tmp[["dataset"]] == "SITEDESCRIPTION"){
      if(!is.null(tmp[["site"]])){
        data <-getSiteDescription(tmp[["dataset"]], tmp[["site"]])
      }else{
        data <- getSiteDescription(tmp[["dataset"]])
      }
    }else{
      warning(tmp[["queried"]],  call. = FALSE)
      stop("Could not fetch the query")
    }
    warning(tmp[["queried"]],  call. = FALSE)
    stop("Could not fetch the query")
  }
  data <- formatData(tmp)
  return(data)
}











